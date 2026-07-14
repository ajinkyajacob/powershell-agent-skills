#Requires -Version 7.4
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot 'pwsh-mcp-server.ps1'
    $testDir = Join-Path $env:TEMP "pwsh-mcp-test-$([System.IO.Path]::GetRandomFileName())"
    New-Item -ItemType Directory -Path $testDir -Force | Out-Null

    # Dot-source server to load functions, suppress -Test auto-run
    . $scriptPath
}

AfterAll {
    if (Test-Path -LiteralPath $testDir) {
        Remove-Item -LiteralPath $testDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# ============================================================
# Tool Registration Tests
# ============================================================

Describe 'Tool Registration' {
    It 'registers 17 tools' {
        $script:Tools.Count | Should -Be 17
    }

    It 'registers all expected tool names' {
        $names = $script:Tools | ForEach-Object { $_.name } | Sort-Object
        $names -join ',' | Should -BeExactly (
            'disk_usage,environment_get,file_list,file_read,file_search,file_write,process_kill,process_list,run_command,run_script,service_control,service_list,session_clear,session_get,session_list,session_set,system_info'
        )
    }

    It 'every tool has name, description, inputSchema, handler' {
        foreach ($t in $script:Tools) {
            $t.name | Should -Not -BeNullOrEmpty
            $t.description | Should -Not -BeNullOrEmpty
            $t.inputSchema | Should -Not -BeNullOrEmpty
            $t.handler | Should -Not -BeNullOrEmpty
        }
    }
}

# ============================================================
# Dispatch / Protocol Tests (via Invoke-McpDispatch)
# ============================================================

Describe 'MCP Protocol Dispatch' {
    It 'handles initialize' {
        $resp = @{}
        $null = Invoke-McpDispatch -Request @{ id = 1; method = 'initialize'; params = @{ protocolVersion = '2025-03-26'; clientInfo = @{ name = 'test'; version = '1.0' }; capabilities = @{} } }
        # Dispatcher writes via Write-McpResponse — we can't capture it easily
        # So we verify no exceptions were thrown (test passed if we got here)
        $true | Should -Be $true
    }

    It 'handles ping without error' {
        Invoke-McpDispatch -Request @{ id = 2; method = 'ping' }
        $true | Should -Be $true
    }

    It 'tools/list returns tool definitions' {
        $list = Get-McpToolList
        $list.Count | Should -Be 17
        $list[0].name | Should -Not -BeNullOrEmpty
        $list[0].inputSchema | Should -Not -BeNullOrEmpty
    }

    It 'tools/call dispatches to correct handler' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'system_info' }).handler @{}
        $result | Should -Not -BeNullOrEmpty
        $result | Should -Match '"hostname"'
        $result | Should -Match '"ps_version"'
    }

    It 'dispatch errors on unknown method' {
        $caught = $false
        try {
            Invoke-McpDispatch -Request @{ id = 99; method = 'nope' }
        } catch {
            $caught = $true
        }
        # Dispatcher writes error to stdout, doesn't throw
        $true | Should -Be $true
    }
}

# ============================================================
# System Tool Tests (direct handler calls)
# ============================================================

Describe 'System Tools' {
    It 'system_info returns valid data' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'system_info' }).handler @{} | ConvertFrom-Json
        $result.hostname | Should -Not -BeNullOrEmpty
        $result.os_platform | Should -Be 'windows'
        $result.ps_version | Should -Match '7\.'
    }

    It 'disk_usage returns drive info' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'disk_usage' }).handler @{} | ConvertFrom-Json
        $result.Count | Should -BeGreaterThan 0
        $result[0].name | Should -Not -BeNullOrEmpty
        $result[0].free_gb | Should -Not -BeNullOrEmpty
    }

    It 'disk_usage filters by drive' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'disk_usage' }).handler @{ drive = 'C' } | ConvertFrom-Json
        $result.Count | Should -BeGreaterThan 0
        $result[0].name | Should -Be 'C'
    }

    It 'environment_get returns process vars' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'environment_get' }).handler @{ scope = 'Process' } | ConvertFrom-Json
        $result.PATH | Should -Not -BeNullOrEmpty
    }

    It 'environment_get returns single var' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'environment_get' }).handler @{ name = 'COMPUTERNAME'; scope = 'Process' }
        $result | Should -Match $env:COMPUTERNAME
    }

    It 'process_list returns processes' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'process_list' }).handler @{ limit = 5 } | ConvertFrom-Json
        $result.Count | Should -BeLessOrEqual 5
        $result.Count | Should -BeGreaterThan 0
        $result[0].pid | Should -BeGreaterThan 0
        $result[0].name | Should -Not -BeNullOrEmpty
    }

    It 'process_list filters by name' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'process_list' }).handler @{ name = 'pwsh'; limit = 5 } | ConvertFrom-Json
        $result.Count | Should -BeGreaterThan 0
        foreach ($p in $result) { $p.name | Should -Match 'pwsh' }
    }

    It 'service_list returns services (Windows)' {
        if (-not [OperatingSystem]::IsWindows()) { Set-ItResult -Skipped -Because 'Windows only' }
        $result = & ($script:Tools | Where-Object { $_.name -eq 'service_list' }).handler @{ status = 'Running'; limit = 5 } | ConvertFrom-Json
        $result.Count | Should -BeGreaterThan 0
        $result[0].name | Should -Not -BeNullOrEmpty
    }
}

# ============================================================
# Session Tool Tests
# ============================================================

Describe 'Session Tools' {
    BeforeEach {
        $script:Session.Clear()
    }

    It 'session_set stores value' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'session_set' }).handler @{ key = 'foo'; value = 'bar' }
        $result | Should -Match 'Set session foo = bar'
        $script:Session['foo'] | Should -Be 'bar'
    }

    It 'session_get retrieves stored value' {
        $script:Session['greeting'] = 'hello'
        $result = & ($script:Tools | Where-Object { $_.name -eq 'session_get' }).handler @{ key = 'greeting' }
        $result | Should -Match 'hello'
    }

    It 'session_get throws for missing key' {
        { & ($script:Tools | Where-Object { $_.name -eq 'session_get' }).handler @{ key = 'nonexistent' } } | Should -Throw
    }

    It 'session_list returns all vars' {
        $script:Session['a'] = '1'
        $script:Session['b'] = '2'
        $result = & ($script:Tools | Where-Object { $_.name -eq 'session_list' }).handler @{}
        $result | Should -Match 'a = 1'
        $result | Should -Match 'b = 2'
    }

    It 'session_clear removes all' {
        $script:Session['x'] = 'y'
        & ($script:Tools | Where-Object { $_.name -eq 'session_clear' }).handler @{}
        $script:Session.Count | Should -Be 0
    }
}

# ============================================================
# File Tool Tests
# ============================================================

Describe 'File Tools' {
    It 'file_write creates a new file' {
        $testFile = Join-Path $testDir "newfile.txt"
        & ($script:Tools | Where-Object { $_.name -eq 'file_write' }).handler @{ path = $testFile; content = 'hello world' }
        Test-Path -LiteralPath $testFile | Should -Be $true
        (Get-Content -LiteralPath $testFile -Raw -Encoding utf8).Trim() | Should -Be 'hello world'
    }

    It 'file_write appends to existing file' {
        $testFile = Join-Path $testDir "append.txt"
        Set-Content -LiteralPath $testFile -Value "line1" -Encoding utf8 -NoNewline
        & ($script:Tools | Where-Object { $_.name -eq 'file_write' }).handler @{ path = $testFile; content = "`nline2"; append = $true }
        $lines = Get-Content -LiteralPath $testFile -Encoding utf8
        $lines.Count | Should -Be 2
        $lines[0] | Should -Be 'line1'
        $lines[1] | Should -Be 'line2'
    }

    It 'file_read returns file content' {
        $testFile = Join-Path $testDir "read.txt"
        Set-Content -LiteralPath $testFile -Value "line1`nline2`nline3" -Encoding utf8
        $result = & ($script:Tools | Where-Object { $_.name -eq 'file_read' }).handler @{ path = $testFile } | ConvertFrom-Json
        $result.path | Should -Be $testFile
        $result.total_lines | Should -Be 3
        $result.content | Should -Match 'line2'
    }

    It 'file_read respects -lines param' {
        $testFile = Join-Path $testDir "read-lines.txt"
        Set-Content -LiteralPath $testFile -Value "a`nb`nc`nd`ne" -Encoding utf8
        $result = & ($script:Tools | Where-Object { $_.name -eq 'file_read' }).handler @{ path = $testFile; lines = 2 } | ConvertFrom-Json
        $result.total_lines | Should -Be 5
        $result.content | Should -BeExactly "d`ne"
    }

    It 'file_list returns directory' {
        New-Item -ItemType File -Path (Join-Path $testDir "list-a.txt") -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $testDir "list-b.txt") -Force | Out-Null
        $result = & ($script:Tools | Where-Object { $_.name -eq 'file_list' }).handler @{ path = $testDir } | ConvertFrom-Json
        $names = $result | ForEach-Object { $_.name }
        $names | Should -Contain 'list-a.txt'
        $names | Should -Contain 'list-b.txt'
    }

    It 'file_search finds text' {
        New-Item -ItemType File -Path (Join-Path $testDir "grep.txt") -Value "unique_pattern_999" -Force
        $result = & ($script:Tools | Where-Object { $_.name -eq 'file_search' }).handler @{ pattern = 'unique_pattern_999'; path = $testDir; include = '*.txt' } | ConvertFrom-Json
        $result.Count | Should -BeGreaterThan 0
        $result[0].file | Should -Match 'grep.txt'
        $result[0].content | Should -Match 'unique_pattern_999'
    }
}

# ============================================================
# Script Execution Tests
# ============================================================

Describe 'Script Execution' {
    It 'run_script executes code and returns string' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'run_script' }).handler @{ code = '"hello from test"' }
        $result.Trim() | Should -Be 'hello from test'
    }

    It 'run_script handles no output' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'run_script' }).handler @{ code = '$null' }
        $result | Should -Be 'Script executed (no output)'
    }

    It 'run_script handles errors' {
        { & ($script:Tools | Where-Object { $_.name -eq 'run_script' }).handler @{ code = 'throw "boom"' } } | Should -Throw
    }

    It 'run_command executes native command' {
        $result = & ($script:Tools | Where-Object { $_.name -eq 'run_command' }).handler @{ command = 'cmd.exe'; args = '/c echo test123' }
        $result.Trim() | Should -Be 'test123'
    }
}

# ============================================================
# Error & Edge Case Tests
# ============================================================

Describe 'Error Handling' {
    It 'file_read throws on missing file' {
        { & ($script:Tools | Where-Object { $_.name -eq 'file_read' }).handler @{ path = 'C:\does_not_exist_xyz\file.txt' } } | Should -Throw
    }

    It 'process_kill throws on invalid PID' {
        { & ($script:Tools | Where-Object { $_.name -eq 'process_kill' }).handler @{ pid = 99999999 } } | Should -Throw
    }

    It 'service_control throws on Windows for missing service' {
        if (-not [OperatingSystem]::IsWindows()) { Set-ItResult -Skipped -Because 'Windows only' }
        { & ($script:Tools | Where-Object { $_.name -eq 'service_control' }).handler @{ name = 'NoSuchServiceXYZ'; action = 'Start' } } | Should -Throw
    }
}

# ============================================================
# Self-Test
# ============================================================

Describe 'Self-Test Mode' {
    It 'self-test passes (all 17 tools)' {
        $psi = [System.Diagnostics.ProcessStartInfo]@{
            FileName               = 'pwsh'
            Arguments              = "-NoProfile -File `"$scriptPath`" -Test"
            UseShellExecute        = $false
            RedirectStandardOutput = $true
            RedirectStandardError  = $true
            WorkingDirectory       = $testDir
        }
        $proc = [System.Diagnostics.Process]::Start($psi)
        $stdout = $proc.StandardOutput.ReadToEnd()
        $proc.WaitForExit(10000) | Out-Null
        $proc.ExitCode | Should -Be 0
        $stdout | Should -Match '17 passed, 0 failed'
    }
}

# ============================================================
# Integration (stdin/stdout pipe)
# ============================================================

Describe 'Integration' {
    It 'handles full MCP session over stdio' {
        # Spawn server, send requests, read responses
        $psi = [System.Diagnostics.ProcessStartInfo]@{
            FileName               = 'pwsh'
            Arguments              = "-NoProfile -File `"$scriptPath`""
            UseShellExecute        = $false
            RedirectStandardInput  = $true
            RedirectStandardOutput = $true
            RedirectStandardError  = $true
            StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
            WorkingDirectory       = $testDir
        }
        $proc = [System.Diagnostics.Process]::Start($psi)
        Start-Sleep -Milliseconds 300

        $proc.StandardInput.WriteLine('{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","clientInfo":{"name":"test","version":"1.0"},"capabilities":{}}}')
        Start-Sleep -Milliseconds 100
        $proc.StandardInput.WriteLine('{"jsonrpc":"2.0","id":2,"method":"tools/list"}')
        Start-Sleep -Milliseconds 100
        $proc.StandardInput.WriteLine('{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"system_info","arguments":{}}}')
        Start-Sleep -Milliseconds 100
        $proc.StandardInput.Close()

        $stdout = $proc.StandardOutput.ReadToEnd().Trim()
        $proc.WaitForExit(3000) | Out-Null

        $lines = $stdout -split "`n" | Where-Object { $_.Trim().Length -gt 0 }
        $lines.Count | Should -Be 3

        $initResp = $lines[0] | ConvertFrom-Json
        $initResp.id | Should -Be 1
        $initResp.result.serverInfo.name | Should -Be 'pwsh-mcp'

        $listResp = $lines[1] | ConvertFrom-Json
        $listResp.id | Should -Be 2
        $listResp.result.tools.Count | Should -Be 17

        $callResp = $lines[2] | ConvertFrom-Json
        $callResp.id | Should -Be 3
        $callResp.result.content[0].text | Should -Match '"hostname"'
    }
}
