# pwsh-mcp-server

Unified PowerShell MCP server — merges file ops (PowerShell.MCP), script exec (PSMCP), session state (powershell-mcp), and custom tools. Zero external module dependencies.

## Usage

### Run as MCP server
```powershell
.\pwsh-mcp-server.ps1
```

### Self-test
```powershell
.\pwsh-mcp-server.ps1 -Test
```

### Register with Claude Desktop
```powershell
.\pwsh-mcp-server.ps1 -Install
```

### Unregister
```powershell
.\pwsh-mcp-server.ps1 -Uninstall
```

## Tools (20)

| Tool | Source | Description |
|------|--------|-------------|
| `system_info` | System | OS, CPU, RAM, PS version |
| `disk_usage` | System | Drive space (used/free/total) |
| `process_list` | System | Running processes with CPU/RAM |
| `process_kill` | System | Terminate by PID |
| `service_list` | System | Windows services (Win only) |
| `service_control` | System | Start/stop/restart (Win only) |
| `environment_get` | System | Environment variables |
| `file_read` | PowerShell.MCP | Read file with line offsets |
| `file_write` | PowerShell.MCP | Write or append files |
| `file_search` | PowerShell.MCP | Regex search across files |
| `file_list` | PowerShell.MCP | Directory listing |
| `run_script` | PSMCP | Execute PowerShell code |
| `run_command` | PSMCP | Execute native command |
| `session_get` | powershell-mcp | Get session variable |
| `session_set` | powershell-mcp | Set session variable |
| `session_list` | powershell-mcp | List session variables |
| `session_clear` | powershell-mcp | Clear session |

## Claude Desktop Config

If you don't use `-Install`, add to `%APPDATA%\Claude\claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "pwsh-mcp": {
      "command": "pwsh",
      "args": ["-NoProfile", "-File", "C:\\path\\to\\pwsh-mcp-server.ps1"]
    }
  }
}
```

## Removing External Modules

After switching to pwsh-mcp-server, clean up:

```powershell
Uninstall-Module PowerShell.MCP -Force -ErrorAction SilentlyContinue
Uninstall-Module PSMCP -Force -ErrorAction SilentlyContinue
npm uninstall -g powershell-mcp
```
