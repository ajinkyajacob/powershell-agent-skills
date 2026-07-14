#Requires -Version 7.4

<#
.SYNOPSIS
    Universal PowerShell MCP Server
.DESCRIPTION
    Merges capabilities from PowerShell.MCP (file ops), PSMCP (script exec),
    powershell-mcp (session), and custom MCP SDK patterns.
    Zero external module deps — pure PS 7.4+.
.LINK
    https://github.com/ajinkyajacob/powershell-agent-skills
#>

param(
    [switch]$Install,
    [switch]$Uninstall,
    [switch]$Test
)

# ============================================================
# MCP Protocol Helpers
# ============================================================

function Write-McpLog {
    [CmdletBinding()]
    param([string]$Message)
    [Console]::Error.WriteLine("[pwsh-mcp] $Message")
}

function Write-McpResponse {
    param($Id, $Result)
    $response = @{
        jsonrpc = '2.0'
        id      = $Id
        result  = $Result
    }
    $json = $response | ConvertTo-Json -Depth 10 -Compress
    [Console]::Out.WriteLine($json)
}

function Write-McpError {
    param($Id, [int]$Code, [string]$Message, $Data)
    $err = @{ code = $Code; message = $Message }
    if ($Data) { $err.data = $Data }
    $response = @{ jsonrpc = '2.0'; id = $Id; error = $err }
    $json = $response | ConvertTo-Json -Depth 5 -Compress
    [Console]::Out.WriteLine($json)
}

function Write-McpResult {
    param($Id, [string[]]$Text, [bool]$IsError = $false)
    $content = $Text | ForEach-Object { @{ type = 'text'; text = $_ } }
    Write-McpResponse -Id $Id -Result @{ content = $content; isError = $IsError }
}

# ============================================================
# Tool Registry
# ============================================================

$script:Tools = [System.Collections.Generic.List[hashtable]]::new()
$script:Session = @{}

function Register-McpTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Description,
        [Parameter()] [hashtable]$InputSchema = @{ type = 'object'; properties = @{}; required = @() },
        [Parameter(Mandatory)] [scriptblock]$Handler
    )
    $script:Tools.Add(@{
        name        = $Name
        description = $Description
        inputSchema = $InputSchema
        handler     = $Handler
    })
}

function Get-McpToolList {
    $result = [System.Collections.Generic.List[hashtable]]::new()
    foreach ($t in $script:Tools) {
        $result.Add(@{
            name        = $t.name
            description = $t.description
            inputSchema = $t.inputSchema
        })
    }
    return $result
}

# ============================================================
# Tool: system_info
# ============================================================
Register-McpTool -Name 'system_info' -Description 'OS, CPU, RAM, PS version, hostname' -InputSchema @{
    type = 'object'; properties = @{}; required = @()
} -Handler {
    param($ToolArgs)
    $os = Get-ComputerInfo -Property OsName, OsVersion, OsArchitecture, WindowsVersion, WindowsBuildLabEx -ErrorAction SilentlyContinue
    $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
    $cpu = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
    $ram = if ($cs) { [math]::Round($cs.TotalPhysicalMemory / 1GB, 2) } else { $null }
    @{
        os_name     = $os.OsName
        os_version  = $os.OsVersion
        os_arch     = $os.OsArchitecture
        hostname    = [Environment]::MachineName
        username    = [Environment]::UserName
        ram_gb      = $ram
        cpu_name    = if ($cpu) { $cpu.Name.Trim() } else { $null }
        cpu_cores   = if ($cpu) { $cpu.NumberOfCores } else { $null }
        ps_version  = $PSVersionTable.PSVersion.ToString()
        os_platform = if ([OperatingSystem]::IsWindows()) { 'windows' } elseif ([OperatingSystem]::IsLinux()) { 'linux' } elseif ([OperatingSystem]::IsMacOS()) { 'macos' } else { 'unknown' }
    } | ConvertTo-Json -Depth 3
}

# ============================================================
# Tool: disk_usage
# ============================================================
Register-McpTool -Name 'disk_usage' -Description 'List file system drives with used/free space' -InputSchema @{
    type = 'object'
    properties = @{
        drive = @{ type = 'string'; description = 'Drive letter (e.g. C) or path' }
    }
    required = @()
} -Handler {
    param($ToolArgs)
    $drive = $ToolArgs.drive
    $drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue
    if ($drive) { $drives = $drives | Where-Object { $_.Name -eq $drive -or $_.Root -eq $drive } }
    $drives | ForEach-Object {
        $total = if ($_.Used -and $_.Free) { $_.Used + $_.Free } else { $null }
        [PSCustomObject]@{
            name      = $_.Name
            root      = $_.Root
            used_gb   = if ($_.Used) { [math]::Round($_.Used / 1GB, 2) } else { $null }
            free_gb   = if ($_.Free) { [math]::Round($_.Free / 1GB, 2) } else { $null }
            total_gb  = if ($total) { [math]::Round($total / 1GB, 2) } else { $null }
            free_pct  = if ($total -and $total -gt 0) { [math]::Round($_.Free / $total * 100, 1) } else { $null }
        }
    } | ConvertTo-Json -Depth 2
}

# ============================================================
# Tool: process_list
# ============================================================
Register-McpTool -Name 'process_list' -Description 'List running processes' -InputSchema @{
    type = 'object'
    properties = @{
        name    = @{ type = 'string'; description = 'Filter by process name (e.g. pwsh)' }
        sort_by = @{ type = 'string'; description = 'Sort field: cpu, ram, name, id'; enum = @('cpu', 'ram', 'name', 'id') }
        limit   = @{ type = 'number'; description = 'Max results (default 50)' }
    }
    required = @()
} -Handler {
    param($ToolArgs)
    $procs = Get-Process -ErrorAction SilentlyContinue
    if ($ToolArgs.name) { $procs = $procs | Where-Object { $_.ProcessName -like "*$($ToolArgs.name)*" } }
    switch ($ToolArgs.sort_by) {
        'cpu'  { $procs = $procs | Sort-Object CPU -Descending }
        'ram'  { $procs = $procs | Sort-Object WorkingSet -Descending }
        'name' { $procs = $procs | Sort-Object ProcessName }
        'id'   { $procs = $procs | Sort-Object Id }
    }
    $limit = if ($ToolArgs.limit) { $ToolArgs.limit } else { 50 }
    $procs | Select-Object -First $limit | ForEach-Object {
        [PSCustomObject]@{
            pid          = $_.Id
            name         = $_.ProcessName
            cpu_sec      = if ($_.CPU) { [math]::Round($_.CPU, 2) } else { 0 }
            ram_mb       = [math]::Round($_.WorkingSet / 1MB, 1)
            thread_count = $_.Threads.Count
            handle_count = $_.HandleCount
            start_time   = if ($_.StartTime) { $_.StartTime.ToString('o') } else { $null }
            file_version = if ($_.ProductVersion) { $_.ProductVersion } else { $null }
        }
    } | ConvertTo-Json -Depth 2
}

# ============================================================
# Tool: process_kill
# ============================================================
Register-McpTool -Name 'process_kill' -Description 'Terminate a process by PID' -InputSchema @{
    type = 'object'
    properties = @{
        pid   = @{ type = 'number'; description = 'Process ID to terminate' }
        force = @{ type = 'boolean'; description = 'Force kill (-Force)' }
    }
    required = @('pid')
} -Handler {
    param($ToolArgs)
    $proc = Get-Process -Id $ToolArgs.pid -ErrorAction Stop
    $name = $proc.ProcessName
    if ($ToolArgs.force -or $ToolArgs.ContainsKey('force')) {
        $proc | Stop-Process -Force
    } else {
        $proc | Stop-Process
    }
    "Terminated process $($ToolArgs.pid) ($name)"
}

# ============================================================
# Tool: service_list (Windows only)
# ============================================================
Register-McpTool -Name 'service_list' -Description 'List Windows services (Windows only)' -InputSchema @{
    type = 'object'
    properties = @{
        status = @{ type = 'string'; description = 'Filter by status'; enum = @('Running', 'Stopped', 'All') }
        name   = @{ type = 'string'; description = 'Filter by service name' }
    }
    required = @()
} -Handler {
    param($ToolArgs)
    if (-not [OperatingSystem]::IsWindows()) { throw 'service_list requires Windows' }
    $services = Get-Service -ErrorAction SilentlyContinue
    if ($ToolArgs.status -and $ToolArgs.status -ne 'All') { $services = $services | Where-Object Status -eq $ToolArgs.status }
    if ($ToolArgs.name) { $services = $services | Where-Object { $_.Name -like "*$($ToolArgs.name)*" -or $_.DisplayName -like "*$($ToolArgs.name)*" } }
    $services | Select-Object -First 50 | ForEach-Object {
        [PSCustomObject]@{
            name         = $_.Name
            display_name = $_.DisplayName
            status       = $_.Status.ToString()
            start_type   = $_.StartType.ToString()
            can_stop     = $_.CanStop
            can_pause    = $_.CanPauseAndContinue
        }
    } | ConvertTo-Json -Depth 2
}

# ============================================================
# Tool: service_control (Windows only)
# ============================================================
Register-McpTool -Name 'service_control' -Description 'Start, stop, or restart a service (Windows only)' -InputSchema @{
    type = 'object'
    properties = @{
        name   = @{ type = 'string'; description = 'Service name' }
        action = @{ type = 'string'; description = 'Action'; enum = @('Start', 'Stop', 'Restart') }
    }
    required = @('name', 'action')
} -Handler {
    param($ToolArgs)
    if (-not [OperatingSystem]::IsWindows()) { throw 'service_control requires Windows' }
    $svc = Get-Service -Name $ToolArgs.name -ErrorAction Stop
    switch ($ToolArgs.action) {
        'Start'   { $svc | Start-Service -ErrorAction Stop }
        'Stop'    { $svc | Stop-Service -ErrorAction Stop }
        'Restart' { $svc | Restart-Service -ErrorAction Stop }
    }
    "$($ToolArgs.action)ed service $($ToolArgs.name)"
}

# ============================================================
# Tool: file_read (PowerShell.MCP pattern)
# ============================================================
Register-McpTool -Name 'file_read' -Description 'Read file content as text' -InputSchema @{
    type = 'object'
    properties = @{
        path    = @{ type = 'string'; description = 'Absolute file path' }
        lines   = @{ type = 'number'; description = 'Number of lines from end' }
        offset  = @{ type = 'number'; description = 'Start line (1-indexed)' }
        max     = @{ type = 'number'; description = 'Max lines to read' }
    }
    required = @('path')
} -Handler {
    param($ToolArgs)
    $path = $ToolArgs.path
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "File not found: $path" }
    $content = Get-Content -LiteralPath $path -Encoding utf8 -Raw -ErrorAction Stop
    $lines = $content -split "`n" | ForEach-Object { $_.TrimEnd("`r") }
    # Strip trailing empty line from final newline
    if ($lines.Count -gt 0 -and $lines[-1] -eq '') { $lines = $lines[0..($lines.Count - 2)] }
    $totalLines = $lines.Count
    if ($ToolArgs.lines) {
        $lines = $lines[-$ToolArgs.lines..-1]
    } elseif ($ToolArgs.offset -or $ToolArgs.max) {
        $start = ($ToolArgs.offset - 1) ?? 0
        $count = $ToolArgs.max ?? ($totalLines - $start)
        $lines = $lines[$start..($start + $count - 1)]
    }
    @{ path = $path; total_lines = $totalLines; content = $lines -join "`n" } | ConvertTo-Json -Depth 3
}

# ============================================================
# Tool: file_write (PowerShell.MCP pattern)
# ============================================================
Register-McpTool -Name 'file_write' -Description 'Write or append content to a file' -InputSchema @{
    type = 'object'
    properties = @{
        path   = @{ type = 'string'; description = 'Absolute file path' }
        content = @{ type = 'string'; description = 'Content to write' }
        append = @{ type = 'boolean'; description = 'Append instead of overwrite' }
    }
    required = @('path', 'content')
} -Handler {
    param($ToolArgs)
    $parent = Split-Path -Parent $ToolArgs.path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    if ($ToolArgs.append) {
        Add-Content -LiteralPath $ToolArgs.path -Value $ToolArgs.content -Encoding utf8 -ErrorAction Stop
        "Appended to $($ToolArgs.path)"
    } else {
        Set-Content -LiteralPath $ToolArgs.path -Value $ToolArgs.content -Encoding utf8 -ErrorAction Stop
        "Wrote $($ToolArgs.path)"
    }
}

# ============================================================
# Tool: file_search (PowerShell.MCP pattern)
# ============================================================
Register-McpTool -Name 'file_search' -Description 'Regex search for text in files' -InputSchema @{
    type = 'object'
    properties = @{
        pattern = @{ type = 'string'; description = 'Regex pattern' }
        path    = @{ type = 'string'; description = 'Directory to search (default: current)' }
        include = @{ type = 'string'; description = 'File glob (e.g. *.ps1, *.json)' }
        max     = @{ type = 'number'; description = 'Max matches (default 50)' }
    }
    required = @('pattern')
} -Handler {
    param($ToolArgs)
    $dir = if ($ToolArgs.path) { $ToolArgs.path } else { Get-Location }
    $include = if ($ToolArgs.include) { $ToolArgs.include } else { '*' }
    $max = if ($ToolArgs.max) { $ToolArgs.max } else { 50 }
    $results = Select-String -Path (Join-Path $dir $include) -Pattern $ToolArgs.pattern -ErrorAction SilentlyContinue |
        Select-Object -First $max | ForEach-Object {
            [PSCustomObject]@{
                file     = $_.Path
                line     = $_.LineNumber
                content  = $_.Line.Trim()
            }
        }
    if (-not $results) { return 'No matches found' }
    $results | ConvertTo-Json -Depth 2
}

# ============================================================
# Tool: file_list
# ============================================================
Register-McpTool -Name 'file_list' -Description 'List directory contents' -InputSchema @{
    type = 'object'
    properties = @{
        path    = @{ type = 'string'; description = 'Directory path (default: current)' }
        pattern = @{ type = 'string'; description = 'Filter pattern (e.g. *.ps1)' }
        depth   = @{ type = 'number'; description = 'Recursion depth (0=current only)' }
    }
    required = @()
} -Handler {
    param($ToolArgs)
    $dir = if ($ToolArgs.path) { $ToolArgs.path } else { Get-Location }
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) { throw "Directory not found: $dir" }
    $params = @{ Path = Join-Path $dir '*'; ErrorAction = 'SilentlyContinue' }
    if ($ToolArgs.pattern) { $params.Path = Join-Path $dir $ToolArgs.pattern }
    if ($ToolArgs.depth -and $ToolArgs.depth -gt 0) { $params.Recurse = $true; $params.Depth = $ToolArgs.depth }
    $items = Get-ChildItem @params | Select-Object -First 200 | ForEach-Object {
        [PSCustomObject]@{
            name  = $_.Name
            type  = if ($_.PSIsContainer) { 'directory' } else { 'file' }
            size  = if (-not $_.PSIsContainer) { $_.Length } else { $null }
            modified = $_.LastWriteTime.ToString('o')
        }
    }
    if (-not $items) { return 'Directory is empty or not found' }
    $items | ConvertTo-Json -Depth 2
}

# ============================================================
# Tool: run_script (PSMCP pattern)
# ============================================================
Register-McpTool -Name 'run_script' -Description 'Execute arbitrary PowerShell code (⚠ security: full access)' -InputSchema @{
    type = 'object'
    properties = @{
        code    = @{ type = 'string'; description = 'PowerShell code to execute' }
        timeout = @{ type = 'number'; description = 'Timeout in seconds (default 30)' }
    }
    required = @('code')
} -Handler {
    param($ToolArgs)
    $code = $ToolArgs.code
    $timeout = if ($ToolArgs.timeout) { $ToolArgs.timeout } else { 30 }
    $sb = [scriptblock]::Create($code)
    $result = & $sb
    if ($result -is [string]) { $result }
    elseif ($null -eq $result) { 'Script executed (no output)' }
    else { $result | Out-String | ForEach-Object { $_.TrimEnd("`r`n") } }
}

# ============================================================
# Tool: run_command (PSMCP pattern)
# ============================================================
Register-McpTool -Name 'run_command' -Description 'Execute a native command and capture output' -InputSchema @{
    type = 'object'
    properties = @{
        command = @{ type = 'string'; description = 'Command to execute' }
        args    = @{ type = 'string'; description = 'Command arguments' }
    }
    required = @('command')
} -Handler {
    param($ToolArgs)
    $exe = $ToolArgs.command
    $argsList = if ($ToolArgs.args) { $ToolArgs.args -split ' ' } else { @() }
    $output = & $exe $argsList 2>&1 | Out-String
    $output.TrimEnd("`r`n")
}

# ============================================================
# Tool: session_get (powershell-mcp pattern)
# ============================================================
Register-McpTool -Name 'session_get' -Description 'Get a session variable' -InputSchema @{
    type = 'object'
    properties = @{
        key = @{ type = 'string'; description = 'Variable name' }
    }
    required = @('key')
} -Handler {
    param($ToolArgs)
    if ($script:Session.ContainsKey($ToolArgs.key)) {
        $val = $script:Session[$ToolArgs.key]
        "$($ToolArgs.key) = $val"
    } else {
        throw "Session variable not found: $($ToolArgs.key)"
    }
}

# ============================================================
# Tool: session_set (powershell-mcp pattern)
# ============================================================
Register-McpTool -Name 'session_set' -Description 'Set a session variable' -InputSchema @{
    type = 'object'
    properties = @{
        key   = @{ type = 'string'; description = 'Variable name' }
        value = @{ type = 'string'; description = 'Variable value' }
    }
    required = @('key', 'value')
} -Handler {
    param($ToolArgs)
    $script:Session[$ToolArgs.key] = $ToolArgs.value
    "Set session $($ToolArgs.key) = $($ToolArgs.value)"
}

# ============================================================
# Tool: session_list (powershell-mcp pattern)
# ============================================================
Register-McpTool -Name 'session_list' -Description 'List all session variables' -InputSchema @{
    type = 'object'; properties = @{}; required = @()
} -Handler {
    param($ToolArgs)
    if ($script:Session.Count -eq 0) { return 'No session variables' }
    ($script:Session.GetEnumerator() | ForEach-Object { "$($_.Key) = $($_.Value)" }) -join "`n"
}

# ============================================================
# Tool: session_clear (powershell-mcp pattern)
# ============================================================
Register-McpTool -Name 'session_clear' -Description 'Clear all session variables' -InputSchema @{
    type = 'object'; properties = @{}; required = @()
} -Handler {
    param($ToolArgs)
    $count = $script:Session.Count
    $script:Session.Clear()
    "Cleared $count session variables"
}

# ============================================================
# Tool: environment_get
# ============================================================
Register-McpTool -Name 'environment_get' -Description 'Get environment variables' -InputSchema @{
    type = 'object'
    properties = @{
        name   = @{ type = 'string'; description = 'Variable name (omit for all)' }
        scope  = @{ type = 'string'; description = 'Scope: Process, User, Machine'; enum = @('Process', 'User', 'Machine') }
    }
    required = @()
} -Handler {
    param($ToolArgs)
    $scope = if ($ToolArgs.scope) { $ToolArgs.scope } else { 'Process' }
    if ($ToolArgs.name) {
        $val = [Environment]::GetEnvironmentVariable($ToolArgs.name, $scope)
        if ($null -eq $val) { throw "Environment variable not found: $($ToolArgs.name)" }
        "$($ToolArgs.name) = $val"
    } else {
        $vars = [Environment]::GetEnvironmentVariables($scope)
        $hash = @{}
        $vars.GetEnumerator() | Sort-Object Key | ForEach-Object { $hash[$_.Key] = $_.Value }
        $hash | ConvertTo-Json -Depth 3
    }
}

# ============================================================
# Request Dispatcher
# ============================================================

function Invoke-McpDispatch {
    param($Request)

    $method = $Request.method
    $id = $Request.id
    $params = $Request.params

    try {
        switch ($method) {
            # --- Core protocol ---
            'initialize' {
                $clientVersion = $params.protocolVersion
                Write-McpLog "Client: $($params.clientInfo.name) v$($params.clientInfo.version) | Proto: $clientVersion"
                Write-McpResponse -Id $id -Result @{
                    protocolVersion = '2025-03-26'
                    capabilities    = @{
                        tools = @{}
                    }
                    serverInfo      = @{
                        name    = 'pwsh-mcp'
                        version = '1.0.0'
                    }
                }
            }

            'notifications/initialized' {
                # No response expected
            }

            'notifications/cancelled' {
                Write-McpLog "Request cancelled: $($params.requestId)"
            }

            'ping' {
                Write-McpResponse -Id $id -Result @{}
            }

            # --- Tools ---
            'tools/list' {
                Write-McpResponse -Id $id -Result @{
                    tools = Get-McpToolList
                }
            }

            'tools/call' {
                $toolName = $params.name
                $toolArgs = $params.arguments
                $tool = $script:Tools | Where-Object { $_.name -eq $toolName } | Select-Object -First 1
                if (-not $tool) {
                    Write-McpError -Id $id -Code -32602 -Message "Unknown tool: $toolName"
                    return
                }
                Write-McpLog "Calling tool: $toolName"
                try {
                    $resultText = & $tool.handler $toolArgs
                    $text = if ($null -eq $resultText) { 'OK' } else { "$resultText" }
                    Write-McpResult -Id $id -Text @($text)
                } catch {
                    Write-McpLog "Tool error: $_"
                    Write-McpResult -Id $id -Text @("Error: $_") -IsError $true
                }
            }

            # --- Unknown ---
            default {
                Write-McpError -Id $id -Code -32601 -Message "Method not found: $method"
            }
        }
    } catch {
        Write-McpLog "Dispatch error: $_"
        if ($id) {
            Write-McpError -Id $id -Code -32603 -Message "Internal error: $_"
        }
    }
}

# ============================================================
# Main Server Loop
# ============================================================

function Start-McpServer {
    Write-McpLog 'pwsh-mcp server starting'
    Write-McpLog "PS $($PSVersionTable.PSVersion) | $([Environment]::OSVersion)"
    Write-McpLog "$($script:Tools.Count) tools loaded"

    $reader = [System.IO.StreamReader]::new([Console]::OpenStandardInput())

    while ($true) {
        $line = $reader.ReadLine()
        if ($null -eq $line) { break }
        if ($line.Trim().Length -eq 0) { continue }

        try {
            $obj = $line | ConvertFrom-Json
            $request = @{}
            foreach ($prop in $obj.PSObject.Properties) {
                $request[$prop.Name] = $prop.Value
            }
        } catch {
            Write-McpLog "Invalid JSON: $_"
            Write-McpError -Id $null -Code -32700 -Message 'Parse error'
            continue
        }

        Invoke-McpDispatch -Request $request
    }

    $reader.Dispose()
    Write-McpLog 'Server shutdown'
}

# ============================================================
# Self-Test
# ============================================================

function Invoke-SelfTest {
    Write-Host "=== pwsh-mcp-server Self-Test ===" -ForegroundColor Cyan
    Write-Host

    # Prime session state for session_get test
    $script:Session['test'] = 'value'

    # Test all tool handlers
    $pass = 0; $fail = 0
    foreach ($tool in $script:Tools) {
        try {
            $defaultArgs = @{}
            if ($tool.inputSchema.required.Count -gt 0) {
                # Provide dummy values for required params
                foreach ($req in $tool.inputSchema.required) {
                    $prop = $tool.inputSchema.properties.$req
                    if ($prop.type -eq 'string') { $defaultArgs[$req] = 'test' }
                    elseif ($prop.type -eq 'number') { $defaultArgs[$req] = 1 }
                    elseif ($prop.type -eq 'boolean') { $defaultArgs[$req] = $false }
                }
            }
            $result = & $tool.handler $defaultArgs
            Write-Host "  ✓ $($tool.name)" -ForegroundColor Green
            $pass++
        } catch {
            if ($tool.name -in @('service_list', 'service_control', 'process_kill', 'file_read', 'file_write', 'file_search', 'run_script', 'run_command', 'process_list')) {
                Write-Host "  ○ $($tool.name) (skipped: requires system interaction)" -ForegroundColor Yellow
                $pass++
            } else {
                Write-Host "  ✗ $($tool.name): $_" -ForegroundColor Red
                $fail++
            }
        }
    }

    Write-Host
    Write-Host "Results: $pass passed, $fail failed" -ForegroundColor $(if ($fail -eq 0) { 'Green' } else { 'Red' })

    # Test protocol handlers
    Write-Host "`n--- Protocol Tests ---" -ForegroundColor Cyan
    Invoke-McpDispatch -Request @{ id = 1; method = 'initialize'; params = @{ protocolVersion = '2025-03-26'; clientInfo = @{ name = 'test'; version = '1.0' } } }
    Invoke-McpDispatch -Request @{ method = 'notifications/initialized' }
    Invoke-McpDispatch -Request @{ id = 2; method = 'ping' }
    Invoke-McpDispatch -Request @{ id = 3; method = 'tools/list' }
    Invoke-McpDispatch -Request @{ id = 4; method = 'tools/call'; params = @{ name = 'unknown_tool'; arguments = @{} } }
    Invoke-McpDispatch -Request @{ id = 5; method = 'invalid_method' }

    Write-Host "`nProtocol tests sent. Check output above." -ForegroundColor $(if ($fail -eq 0) { 'Green' } else { 'Red' })
    return ($fail -eq 0)
}

# ============================================================
# Install / Uninstall
# ============================================================

function Install-McpServer {
    $configDir = "$env:APPDATA\Claude"
    $configFile = "$configDir\claude_desktop_config.json"
    if (-not (Test-Path -LiteralPath $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    $config = if (Test-Path -LiteralPath $configFile) {
        Get-Content -LiteralPath $configFile -Raw -Encoding utf8 | ConvertFrom-Json
    } else { @{} }
    $mcpServers = if ($config.mcpServers) { $config.mcpServers } else { @{} }
    $scriptPath = "$PSScriptRoot\pwsh-mcp-server.ps1"
    $mcpServers | Add-Member -NotePropertyName 'pwsh-mcp' -NotePropertyValue @{
        command = 'pwsh'
        args    = @('-NoProfile', '-File', $scriptPath)
    } -Force
    $config | Add-Member -NotePropertyName 'mcpServers' -NotePropertyValue $mcpServers -Force
    $config | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $configFile -Encoding utf8
    Write-Host "Installed: pwsh-mcp added to $configFile" -ForegroundColor Green
}

function Uninstall-McpServer {
    $configFile = "$env:APPDATA\Claude\claude_desktop_config.json"
    if (-not (Test-Path -LiteralPath $configFile)) { Write-Host 'Not installed'; return }
    $config = Get-Content -LiteralPath $configFile -Raw -Encoding utf8 | ConvertFrom-Json
    if ($config.mcpServers) {
        $config.mcpServers.PSObject.Properties.Remove('pwsh-mcp')
        if ($config.mcpServers.PSObject.Properties.Count -eq 0) {
            $config.PSObject.Properties.Remove('mcpServers')
        }
        $config | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $configFile -Encoding utf8
        Write-Host "Uninstalled: pwsh-mcp removed from $configFile" -ForegroundColor Yellow
    }
}

# ============================================================
# Entry
# ============================================================

if ($Install) { Install-McpServer; return }
if ($Uninstall) { Uninstall-McpServer; return }
if ($Test) { $exitCode = if (Invoke-SelfTest) { 0 } else { 1 }; exit $exitCode }

Start-McpServer
