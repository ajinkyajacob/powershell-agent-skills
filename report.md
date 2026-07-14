# PowerShell Agent Skills — Research Report

**18 items** researched across 6 categories.

## Table of Contents

| # | Item | stars | skill_type | platform | ps_version | install_complexity | skill_count | skill_domain | forks |
|---|---|---|---|---|---|---|---|---|---|
| 1 | [Azure/Metro.AI.PowerShell](#azure-metro-ai-powershell) | 11 | module | cross-platform | 7.0 | single-command | 0 | ai-agent-building | 4 |
| 2 | [BallLightningAB/agent-skills-updater](#balllightningab-agent-skills-updater) | 2 | script | cross-platform | both | multi-step | 0 | gallery-mgmt | 0 |
| 3 | [Devolutions/powershell-universal-skills](#devolutions-powershell-universal-skills) | 1 | skill-pack | cross-platform | both | single-command | — | agent-framework | 0 |
| 4 | [PSAI](#psai) | 266 | module | cross-platform | 7.1 | single-command | 60 | agent-framework | 35 |
| 5 | [PSClaudeCode](#psclaudecode) | 82 | module | cross-platform | 5.1 | single-command | 1 | agent-framework | 14 |
| 6 | [PSMCP](#psmcp) | 51 | module | cross-platform | 5.1 | single-command | 1 | mcp-bridge | 12 |
| 7 | [powershell](#powershell) | 2 | skill | Windows-only | — | copy-only | 1 | scripting-skill | 2 |
| 8 | [github/awesome-copilot/powershell-instructions](#github-awesome-copilot-powershell-instructions) | 36600 | reference | cross-platform | both | copy-only | 0 | module-dev | 4600 |
| 9 | [gunjanjp/powershell-mcp](#gunjanjp-powershell-mcp) | 23 | script | Windows-only | both | single-command | 0 | mcp-bridge | 6 |
| 10 | [powershell-expert](#powershell-expert) | 38 | skill-pack | cross-platform | both | copy-only | 1 | scripting-skill | 9 |
| 11 | [agent-skills](#agent-skills) | 7 | skill-pack | cross-platform | — | single-command | 8 | agent-framework | 1 |
| 12 | [JosiahSiegel/powershell-master](#josiahsiegel-powershell-master) | — | skill-pack | cross-platform | both | copy-only | 5 | agent-framework | — |
| 13 | [powershell-expert](#powershell-expert) | 0 | style-guide | cross-platform | both | — | 1 | scripting-skill | 0 |
| 14 | [powershell-5.1-expert](#powershell-5-1-expert) | 18 | skill | Windows-only | 5.1 | single-command | 1 | scripting-skill | 2 |
| 15 | [matheusallvarenga/claude-code-skills](#matheusallvarenga-claude-code-skills) | 3 | skill-pack | cross-platform | — | single-command | 33 | agent-framework | 0 |
| 16 | [PowerShell-official/GitHub-skills](#powershell-official-github-skills) | — | skill-pack | cross-platform | both | copy-only | 6 | agent-framework | — |
| 17 | [start-automating/PowerShellAI](#start-automating-powershellai) | 35 | module | cross-platform | — | single-command | 1 | ai-agent-building | 100 |
| 18 | [yotsuda/PowerShell.MCP](#yotsuda-powershell-mcp) | 83 | module | cross-platform | 7.4+ | single-command | 1 | mcp-bridge | 7 |

## Detailed Analysis

### [Azure/Metro.AI.PowerShell](https://github.com/Azure/Metro.AI.PowerShell)  {#azure-metro-ai-powershell}

**Basic Info**

- **name**: Azure/Metro.AI.PowerShell
- **repo_url**: https://github.com/Azure/Metro.AI.PowerShell
- **stars**: 11
- **forks**: 4
- **description**: Unified PowerShell module for Azure AI Agent and Assistant APIs — MCP server integration, multi-environment deployment, enterprise AI agent management
- **license**: MIT
- **first_release_date**: 2025-03-14
- **last_updated**: 2025-12-12

**Scope**

- **skill_type**: module
- **ps_version**: 7.0
- **platform**: cross-platform
- **skill_format**: .psm1 module
- **skill_domain**: ai-agent-building

**Content & Coverage**

- **skill_count**: 0
- **command_count**: 0
- **reference_count**: 1
- **coverage_areas**: AI agent-building, Azure AI, MCP, API integration, conversation management, file management

**Quality & Community**

- **source_quality_signals**: has tests
- **open_issues**: 1
- **maintainer**: Microsoft (SWAT)
- **ecosystem_crossref**: Azure/azure-powershell (Az.Accounts), dfinke/PSAI, PowerShell/AIShell, Microsoft Foundry AI Agents

**Installation & Requirements**

- **install_method**: PowerShell-Gallery
- **dependencies**: PowerShell 7.0+, Azure subscription
- **sdk_requirements**: Az.Accounts 5.1.0+, Azure SDK
- **install_complexity**: single-command

**Use Case**

- **target_audience**: AI engineers, developers, enterprise
- **automation_domain**: AI
- **complexity_level**: intermediate
- **runtime_compatibility**: PowerShell console, OpenCode, Claude Code, Codex, Copilot CLI, Gemini CLI, Cursor
- **ai_framework_affiliation**: Metro.AI, PSAI

**Uncertain Fields**

- `psscriptanalyzer_integration`: value uncertain, skipped from report

### [BallLightningAB/agent-skills-updater](https://github.com/BallLightningAB/agent-skills-updater)  {#balllightningab-agent-skills-updater}

**Basic Info**

- **name**: BallLightningAB/agent-skills-updater
- **repo_url**: https://github.com/BallLightningAB/agent-skills-updater
- **stars**: 2
- **forks**: 0
- **description**: Automated skill management for AI coding assistants. Clones skills from multiple GitHub repositories, handles different repository structures, and copies files to appropriate directories. Works with Windsurf, Cursor, Claude Code, GitHub Copilot, Opencode, and other AI-powered IDEs.
- **license**: Apache-2.0
- **first_release_date**: 2026-01-30
- **last_updated**: 2026-02-09

**Scope**

- **skill_type**: script
- **ps_version**: both
- **platform**: cross-platform
- **skill_domain**: gallery-mgmt

**Content & Coverage**

- **skill_count**: 0
- **command_count**: 0
- **reference_count**: 4

**Quality & Community**

- **source_quality_signals**: has tests, has CI, has changelog, has contributing guide
- **open_issues**: 1
- **maintainer**: BallLightningAB
- **psscriptanalyzer_integration**: False

**Installation & Requirements**

- **install_method**: manual-copy
- **dependencies**: Git, PowerShell 5.1+ or 7+
- **sdk_requirements**: 
- **install_complexity**: multi-step

**Use Case**

- **target_audience**: devs, admins, AI engineers
- **automation_domain**: ops
- **complexity_level**: intermediate
- **runtime_compatibility**: <br>- Claude Code<br>- Cursor<br>- GitHub Copilot<br>- OpenCode<br>- Codex<br>- Gemini CLI<br>- Windsurf

**Uncertain Fields**

- `skill_format`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report
- `coverage_areas`: value uncertain, skipped from report

### [Devolutions/powershell-universal-skills](https://github.com/Devolutions/powershell-universal-skills)  {#devolutions-powershell-universal-skills}

**Basic Info**

- **name**: Devolutions/powershell-universal-skills
- **repo_url**: https://github.com/Devolutions/powershell-universal-skills
- **stars**: 1
- **forks**: 0
- **description**: Agent skills for PowerShell Universal (PSU) sandbox install — first enterprise PSU-specific skill pack, MIT
- **license**: MIT
- **first_release_date**: 2026-03-12
- **last_updated**: 2026-03-13

**Scope**

- **skill_type**: skill-pack
- **ps_version**: both
- **platform**: cross-platform
- **skill_format**: SKILL.md
- **skill_domain**: agent-framework

**Content & Coverage**

- **command_count**: 0
- **coverage_areas**: scripting, GUI, APIs, automation, module development

**Quality & Community**

- **source_quality_signals**: none identified
- **open_issues**: 0
- **maintainer**: Devolutions
- **ecosystem_crossref**: Devolutions/powershell-universal-gallery, Devolutions/powershell-universal-demo, ironmansoftware/powershell-universal, ironmansoftware/universal-docs

**Installation & Requirements**

- **install_method**: npx-command
- **dependencies**: Node.js (npx), PowerShell Universal (commercial)
- **install_complexity**: single-command

**Use Case**

- **target_audience**: developers, admins, DevOps, enterprise
- **automation_domain**: dev, ops, infra
- **complexity_level**: intermediate
- **runtime_compatibility**: OpenCode, Claude Code, Codex, Copilot CLI, Gemini CLI, Cursor

**Uncertain Fields**

- `skill_count`: value uncertain, skipped from report
- `reference_count`: value uncertain, skipped from report
- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `sdk_requirements`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [PSAI](https://github.com/dfinke/PSAI)  {#psai}

**Basic Info**

- **name**: PSAI
- **repo_url**: https://github.com/dfinke/PSAI
- **stars**: 266
- **forks**: 35
- **description**: High-agency PowerShell AI framework for multi-agent orchestration and autonomous systems engineering
- **license**: MIT
- **first_release_date**: 2024-04-14
- **last_updated**: 2026-03-22

**Scope**

- **skill_type**: module
- **ps_version**: 7.1
- **platform**: cross-platform
- **skill_format**: .psm1 module
- **skill_domain**: agent-framework

**Content & Coverage**

- **skill_count**: 60
- **command_count**: 3
- **reference_count**: 1
- **coverage_areas**: AI agent-building, multi-agent orchestration, MCP, testing/TDD, CI/CD, module development, API integration, automation

**Quality & Community**

- **source_quality_signals**: has tests, has CI, has changelog, has CLAUDE.md
- **open_issues**: 1
- **maintainer**: Doug Finke
- **ecosystem_crossref**: PSClaudeCode (dfinke/PSClaudeCode), PSAISuite (dfinke/psaisuite), PSUnplugged (dfinke/PSUnplugged)

**Installation & Requirements**

- **install_method**: PowerShell-Gallery
- **dependencies**: PowerShell 7.1+, OpenAI API key or Azure OpenAI secrets
- **sdk_requirements**: OpenAI API, Azure SDK (optional)
- **install_complexity**: single-command

**Use Case**

- **target_audience**: developers, AI engineers, architects, DevOps
- **automation_domain**: AI
- **complexity_level**: advanced
- **runtime_compatibility**: PowerShell console, Claude Code, OpenCode, Copilot CLI
- **ai_framework_affiliation**: PSClaudeCode, PSAISuite, PowerShellAI

**Uncertain Fields**

- `psscriptanalyzer_integration`: value uncertain, skipped from report

### [PSClaudeCode](https://github.com/dfinke/PSClaudeCode)  {#psclaudecode}

**Basic Info**

- **name**: PSClaudeCode
- **repo_url**: https://github.com/dfinke/PSClaudeCode
- **stars**: 82
- **forks**: 14
- **description**: A PowerShell implementation of Claude Code: agent loop + tools + permissions
- **license**: MIT
- **first_release_date**: 2026-01-10
- **last_updated**: 2026-01-25

**Scope**

- **skill_type**: module
- **ps_version**: 5.1
- **platform**: cross-platform
- **skill_format**: .psm1 module
- **skill_domain**: agent-framework

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 0
- **reference_count**: 4
- **coverage_areas**: AI agent-building, file operations, command execution, automation, scripting

**Quality & Community**

- **source_quality_signals**: has tests, has CI, has changelog, has contributing guide
- **open_issues**: 0
- **maintainer**: Doug Finke
- **ecosystem_crossref**: PSAI (dfinke/psai), PSAISuite (dfinke/psaisuite)

**Installation & Requirements**

- **install_method**: PowerShell-Gallery
- **dependencies**: PowerShell 5.1+, Anthropic API key
- **sdk_requirements**: None
- **install_complexity**: single-command

**Use Case**

- **target_audience**: developers, AI engineers
- **automation_domain**: AI
- **complexity_level**: intermediate
- **runtime_compatibility**: PowerShell console, Claude Code, OpenCode, Copilot CLI
- **ai_framework_affiliation**: PSAI

**Uncertain Fields**

- `psscriptanalyzer_integration`: value uncertain, skipped from report

### [PSMCP](https://github.com/dfinke/PSMCP)  {#psmcp}

**Basic Info**

- **name**: PSMCP
- **repo_url**: https://github.com/dfinke/PSMCP
- **stars**: 51
- **forks**: 12
- **description**: PSMCP turns your PowerShell scripts into intelligent, conversational services—zero YAML, zero APIs, zero headaches.
- **license**: MIT
- **first_release_date**: 2025-04-13
- **last_updated**: 2025-04-28

**Scope**

- **skill_type**: module
- **ps_version**: 5.1
- **platform**: cross-platform
- **skill_format**: .psm1 module
- **skill_domain**: mcp-bridge

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 0
- **coverage_areas**: MCP, AI

**Quality & Community**

- **source_quality_signals**: has CI, has license, has tests
- **open_issues**: 2
- **maintainer**: Douglas Finke
- **psscriptanalyzer_integration**: False

**Installation & Requirements**

- **install_method**: PowerShell-Gallery
- **dependencies**: PowerShell 5.1+
- **sdk_requirements**: none
- **install_complexity**: single-command

**Use Case**

- **target_audience**: AI engineers, devs
- **automation_domain**: AI
- **complexity_level**: intermediate
- **runtime_compatibility**: OpenCode, Claude Code, Codex, Copilot CLI, Gemini CLI, Cursor

**Uncertain Fields**

- `reference_count`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [powershell](https://github.com/ffsshhttiikk/opencode-agents-skills/tree/main/systems-administration/powershell)  {#powershell}

**Basic Info**

- **name**: powershell
- **repo_url**: https://github.com/ffsshhttiikk/opencode-agents-skills/tree/main/systems-administration/powershell
- **stars**: 2
- **forks**: 2
- **description**: PowerShell scripting for Windows automation, system administration, and cloud management
- **license**: MIT
- **first_release_date**: 2026-02-28
- **last_updated**: 2026-02-28

**Scope**

- **skill_type**: skill
- **platform**: Windows-only
- **skill_format**: SKILL.md
- **skill_domain**: scripting-skill

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 0
- **reference_count**: 0
- **coverage_areas**: scripting, DSC, remoting, modules, GUI

**Quality & Community**

- **source_quality_signals**: 
- **maintainer**: ffsshhttiikk
- **psscriptanalyzer_integration**: False

**Installation & Requirements**

- **install_method**: manual-copy
- **dependencies**: 
- **sdk_requirements**: 
- **install_complexity**: copy-only

**Use Case**

- **target_audience**: admins
- **automation_domain**: ops
- **complexity_level**: intermediate
- **runtime_compatibility**: OpenCode

**Uncertain Fields**

- `ps_version`: value uncertain, skipped from report
- `open_issues`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [github/awesome-copilot/powershell-instructions](https://github.com/github/awesome-copilot/blob/main/instructions/powershell.instructions.md)  {#github-awesome-copilot-powershell-instructions}

**Basic Info**

- **name**: github/awesome-copilot/powershell-instructions
- **repo_url**: https://github.com/github/awesome-copilot/blob/main/instructions/powershell.instructions.md
- **stars**: 36600
- **forks**: 4600
- **description**: Official GitHub Copilot PowerShell instructions (.instructions.md) from 36K star repo covering cmdlet development guidelines, naming conventions, parameter design, error handling, pipeline output, formatting, and documentation style.
- **license**: MIT

**Scope**

- **skill_type**: reference
- **ps_version**: both
- **platform**: cross-platform
- **skill_format**: article/guide
- **skill_domain**: module-dev

**Content & Coverage**

- **skill_count**: 0
- **command_count**: 0
- **reference_count**: 0
- **coverage_areas**: scripting, module development, cmdlet design, error handling, pipeline, formatting, documentation

**Quality & Community**

- **open_issues**: 17
- **maintainer**: GitHub (awesome-copilot community)

**Installation & Requirements**

- **install_method**: manual-copy
- **dependencies**: none
- **sdk_requirements**: none
- **install_complexity**: copy-only

**Use Case**

- **target_audience**: developers
- **automation_domain**: dev
- **complexity_level**: intermediate
- **runtime_compatibility**: GitHub Copilot, VS Code, Copilot CLI

**Uncertain Fields**

- `first_release_date`: value uncertain, skipped from report
- `last_updated`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report
- `source_quality_signals`: value uncertain, skipped from report

### [gunjanjp/powershell-mcp](https://github.com/gunjanjp/powershell-mcp)  {#gunjanjp-powershell-mcp}

**Basic Info**

- **name**: gunjanjp/powershell-mcp
- **repo_url**: https://github.com/gunjanjp/powershell-mcp
- **stars**: 23
- **forks**: 6
- **description**: PowerShell MCP server for Claude — execute commands/scripts, system monitoring (processes, services, disk), file operations, one-command setup. 12 commits, MIT, JavaScript.
- **license**: MIT
- **first_release_date**: 2025-06-06

**Scope**

- **skill_type**: script
- **ps_version**: both
- **platform**: Windows-only
- **skill_format**: script
- **skill_domain**: mcp-bridge

**Content & Coverage**

- **skill_count**: 0
- **command_count**: 0
- **reference_count**: 5
- **coverage_areas**: scripting, system-monitoring, file-operations

**Quality & Community**

- **source_quality_signals**: has_tests, has_ci, has_changelog
- **open_issues**: 2
- **maintainer**: gunjanjp (Gunj P)

**Installation & Requirements**

- **install_method**: bootstrap-script
- **dependencies**: Node.js 18+, PowerShell 5.1+/7+, Windows 10/11 or Server 2016+
- **sdk_requirements**: @modelcontextprotocol/sdk, node-powershell
- **install_complexity**: single-command

**Use Case**

- **target_audience**: devs, admins, AI engineers
- **automation_domain**: dev, ops, infra
- **complexity_level**: intermediate
- **runtime_compatibility**: Claude Desktop, any MCP-compatible client

**Uncertain Fields**

- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report
- `last_updated`: value uncertain, skipped from report

### [powershell-expert](https://github.com/hmohamed01/powershell-expert)  {#powershell-expert}

**Basic Info**

- **name**: powershell-expert
- **repo_url**: https://github.com/hmohamed01/powershell-expert
- **stars**: 38
- **forks**: 9
- **description**: Claude Code skill for PowerShell development - scripts, tools, modules, and GUIs
- **license**: MIT
- **first_release_date**: 2025-12-28
- **last_updated**: 2026-04-13

**Scope**

- **skill_type**: skill-pack
- **ps_version**: both
- **platform**: cross-platform
- **skill_format**: SKILL.md
- **skill_domain**: scripting-skill

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 0
- **reference_count**: 3
- **coverage_areas**: scripting, GUI, modules, testing

**Quality & Community**

- **source_quality_signals**: has changelog
- **open_issues**: 0
- **maintainer**: hmohamed01
- **ecosystem_crossref**: Pester, PSScriptAnalyzer, PSReadLine, PSResourceGet, Az

**Installation & Requirements**

- **install_method**: manual-copy
- **dependencies**: PowerShell 5.1, PowerShell 7+
- **sdk_requirements**: PSResourceGet
- **install_complexity**: copy-only

**Use Case**

- **target_audience**: devs
- **automation_domain**: dev
- **complexity_level**: intermediate
- **runtime_compatibility**: Claude Code

**Uncertain Fields**

- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [agent-skills](https://github.com/jorgeasaurus/agent-skills)  {#agent-skills}

**Basic Info**

- **name**: agent-skills
- **repo_url**: https://github.com/jorgeasaurus/agent-skills
- **stars**: 7
- **forks**: 1
- **description**: Reusable Copilot agent skills for PowerShell development workflows
- **license**: MIT
- **last_updated**: 2026-03-15

**Scope**

- **skill_type**: skill-pack
- **platform**: cross-platform
- **skill_format**: SKILL.md
- **skill_domain**: agent-framework

**Content & Coverage**

- **skill_count**: 8
- **coverage_areas**: scripting, modules, GUI, testing, AI, MCP, cloud

**Quality & Community**

- **source_quality_signals**: has license
- **open_issues**: 0
- **maintainer**: Jorge Suarez

**Installation & Requirements**

- **install_method**: bootstrap-script, manual-copy
- **dependencies**: PowerShell
- **install_complexity**: single-command

**Use Case**

- **target_audience**: devs
- **automation_domain**: dev
- **complexity_level**: intermediate
- **runtime_compatibility**: OpenCode, Claude Code, Codex, Copilot CLI, Gemini CLI, Cursor

**Uncertain Fields**

- `first_release_date`: value uncertain, skipped from report
- `ps_version`: value uncertain, skipped from report
- `command_count`: value uncertain, skipped from report
- `reference_count`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `sdk_requirements`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [JosiahSiegel/powershell-master](https://github.com/JosiahSiegel/claude-plugin-marketplace/tree/main/plugins/powershell-master)  {#josiahsiegel-powershell-master}

**Basic Info**

- **name**: JosiahSiegel/powershell-master
- **repo_url**: https://github.com/JosiahSiegel/claude-plugin-marketplace/tree/main/plugins/powershell-master
- **description**: Comprehensive PowerShell Claude Code plugin — 5 slash commands (/pwsh-script, /pwsh-module, /pwsh-cicd, /pwsh-azure, /pwsh-performance), cross-platform, PSGallery, CI/CD, cloud automation (Az, Microsoft.Graph, AWS). v1.5.0.
- **license**: MIT
- **last_updated**: 2025-10

**Scope**

- **skill_type**: skill-pack
- **ps_version**: both
- **platform**: cross-platform
- **skill_format**: SKILL.md
- **skill_domain**: agent-framework

**Content & Coverage**

- **skill_count**: 5
- **command_count**: 5
- **reference_count**: 5
- **coverage_areas**: scripting, module-management, CI/CD, cloud-automation, security, cross-platform, testing

**Quality & Community**

- **source_quality_signals**: 
- **maintainer**: JosiahSiegel (Josiah Siegel)
- **psscriptanalyzer_integration**: Yes

**Installation & Requirements**

- **install_method**: plugin-marketplace
- **dependencies**: PowerShell 7+ (recommended), Windows PowerShell 5.1 (legacy)
- **sdk_requirements**: None
- **install_complexity**: copy-only

**Use Case**

- **target_audience**: devs, admins, DevOps, AI engineers
- **automation_domain**: dev, ops, AI, infra, security, testing
- **complexity_level**: intermediate
- **runtime_compatibility**: Claude Code

**Uncertain Fields**

- `first_release_date`: value uncertain, skipped from report
- `stars`: value uncertain, skipped from report
- `forks`: value uncertain, skipped from report
- `open_issues`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [powershell-expert](https://github.com/jralph/.config-opencode)  {#powershell-expert}

**Basic Info**

- **name**: powershell-expert
- **repo_url**: https://github.com/jralph/.config-opencode
- **stars**: 0
- **forks**: 0
- **description**: PowerShell scripting best practices and style guidelines
- **last_updated**: 2026-02-21

**Scope**

- **skill_type**: style-guide
- **ps_version**: both
- **platform**: cross-platform
- **skill_format**: SKILL.md
- **skill_domain**: scripting-skill

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 0
- **reference_count**: 0
- **coverage_areas**: scripting, security

**Quality & Community**

- **source_quality_signals**: 
- **open_issues**: 0
- **maintainer**: jralph

**Installation & Requirements**

- **dependencies**: 
- **sdk_requirements**: 

**Use Case**

- **target_audience**: devs
- **automation_domain**: dev
- **complexity_level**: intermediate
- **runtime_compatibility**: OpenCode, Claude Code, Copilot CLI, Gemini CLI

**Uncertain Fields**

- `license`: value uncertain, skipped from report
- `first_release_date`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `install_method`: value uncertain, skipped from report
- `install_complexity`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [powershell-5.1-expert](https://github.com/jshsakura/awesome-opencode-skills/tree/main/skills/powershell-5.1-expert)  {#powershell-5-1-expert}

**Basic Info**

- **name**: powershell-5.1-expert
- **repo_url**: https://github.com/jshsakura/awesome-opencode-skills/tree/main/skills/powershell-5.1-expert
- **stars**: 18
- **forks**: 2
- **description**: Use when a task needs Windows PowerShell 5.1 expertise for legacy automation, full .NET Framework interop, or Windows administration scripts.
- **license**: MIT
- **last_updated**: 2026-03-24

**Scope**

- **skill_type**: skill
- **ps_version**: 5.1
- **platform**: Windows-only
- **skill_format**: SKILL.md
- **skill_domain**: scripting-skill

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 0
- **reference_count**: 0
- **coverage_areas**: scripting, remoting, security

**Quality & Community**

- **source_quality_signals**: has CI
- **open_issues**: 0
- **maintainer**: jshsakura
- **ecosystem_crossref**: VoltAgent/awesome-codex-subagents
- **psscriptanalyzer_integration**: False

**Installation & Requirements**

- **install_method**: bootstrap-script
- **dependencies**: 
- **sdk_requirements**: 
- **install_complexity**: single-command

**Use Case**

- **target_audience**: devs, admins, enterprise
- **automation_domain**: ops
- **complexity_level**: advanced
- **runtime_compatibility**: OpenCode

**Uncertain Fields**

- `first_release_date`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [matheusallvarenga/claude-code-skills](https://github.com/matheusallvarenga/claude-code-skills)  {#matheusallvarenga-claude-code-skills}

**Basic Info**

- **name**: matheusallvarenga/claude-code-skills
- **repo_url**: https://github.com/matheusallvarenga/claude-code-skills
- **stars**: 3
- **forks**: 0
- **description**: Collection of reusable Claude Code Skills and MCPs for productivity, education, and development
- **first_release_date**: 2025-11-07

**Scope**

- **skill_type**: skill-pack
- **platform**: cross-platform
- **skill_format**: SKILL.md
- **skill_domain**: agent-framework

**Content & Coverage**

- **skill_count**: 33
- **command_count**: 45
- **reference_count**: 6

**Quality & Community**

- **source_quality_signals**: has changelog
- **open_issues**: 0
- **maintainer**: matheusallvarenga
- **psscriptanalyzer_integration**: False

**Installation & Requirements**

- **install_method**: bootstrap-script
- **dependencies**: Claude Code 2.1.0+, Node.js 18+
- **sdk_requirements**: 
- **install_complexity**: single-command

**Use Case**

- **target_audience**: devs
- **automation_domain**: dev
- **complexity_level**: intermediate
- **runtime_compatibility**: Claude Code

**Uncertain Fields**

- `license`: value uncertain, skipped from report
- `last_updated`: value uncertain, skipped from report
- `ps_version`: value uncertain, skipped from report
- `coverage_areas`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [PowerShell-official/GitHub-skills](https://github.com/PowerShell)  {#powershell-official-github-skills}

**Basic Info**

- **name**: PowerShell-official/GitHub-skills
- **repo_url**: https://github.com/PowerShell
- **description**: Collection of 6 official PowerShell team agent skills across vscode-powershell (release, update-npm-packages, interactive-extension-testing), DSC (create-dsc-resource, create-resource-doc), and PowerShell (analyze-pester-failures) repositories
- **license**: MIT
- **last_updated**: 2026-06-18

**Scope**

- **skill_type**: skill-pack
- **ps_version**: both
- **platform**: cross-platform
- **skill_format**: SKILL.md
- **skill_domain**: agent-framework

**Content & Coverage**

- **skill_count**: 6
- **command_count**: 0
- **coverage_areas**: <br>- scripting<br>- DSC<br>- testing<br>- CI-CD<br>- release-management<br>- VS-Code-extension-dev

**Quality & Community**

- **source_quality_signals**: has-CI, has-contributing-guide, has-changelog
- **maintainer**: PowerShell Team (Microsoft)

**Installation & Requirements**

- **install_method**: manual-copy
- **dependencies**: none
- **sdk_requirements**: none
- **install_complexity**: copy-only

**Use Case**

- **target_audience**: developers
- **automation_domain**: dev
- **complexity_level**: intermediate
- **runtime_compatibility**: <br>- Claude Code<br>- VS Code<br>- Copilot CLI<br>- Codex CLI<br>- Gemini CLI<br>- Cursor

**Uncertain Fields**

- `stars`: value uncertain, skipped from report
- `forks`: value uncertain, skipped from report
- `first_release_date`: value uncertain, skipped from report
- `reference_count`: value uncertain, skipped from report
- `open_issues`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

### [start-automating/PowerShellAI](https://github.com/StartAutomating/PowerShellAI)  {#start-automating-powershellai}

**Basic Info**

- **name**: start-automating/PowerShellAI
- **repo_url**: https://github.com/StartAutomating/PowerShellAI
- **stars**: 35
- **forks**: 100
- **description**: Community-maintained PowerShell module for OpenAI GPT-3 and DALL-E API integration with cross-platform support and PowerShell Gallery installation
- **license**: Apache-2.0
- **first_release_date**: 2023-01-12

**Scope**

- **skill_type**: module
- **platform**: cross-platform
- **skill_format**: .psm1 module
- **skill_domain**: ai-agent-building

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 0
- **coverage_areas**: <br>- AI<br>- text-generation<br>- image-generation<br>- chat<br>- automation<br>- code-generation

**Quality & Community**

- **source_quality_signals**: has-tests, has-CI, has-changelog, has-readme
- **maintainer**: Douglas Finke (StartAutomating)

**Installation & Requirements**

- **install_method**: PowerShell-Gallery
- **dependencies**: PowerShell 7+
- **sdk_requirements**: OpenAI API
- **install_complexity**: single-command

**Use Case**

- **target_audience**: developers
- **automation_domain**: AI
- **complexity_level**: beginner
- **ai_framework_affiliation**: OpenAI

**Uncertain Fields**

- `last_updated`: value uncertain, skipped from report
- `ps_version`: value uncertain, skipped from report
- `reference_count`: value uncertain, skipped from report
- `open_issues`: value uncertain, skipped from report
- `ecosystem_crossref`: value uncertain, skipped from report
- `psscriptanalyzer_integration`: value uncertain, skipped from report
- `runtime_compatibility`: value uncertain, skipped from report

### [yotsuda/PowerShell.MCP](https://github.com/yotsuda/PowerShell.MCP)  {#yotsuda-powershell-mcp}

**Basic Info**

- **name**: yotsuda/PowerShell.MCP
- **repo_url**: https://github.com/yotsuda/PowerShell.MCP
- **stars**: 83
- **forks**: 7
- **description**: Universal MCP server for Claude Code and other MCP-compatible clients. One installation gives AI access to 10000+ PowerShell modules and any CLI tool. Shared console, persistent session, cross-platform (Win/Linux/macOS).
- **license**: MIT
- **first_release_date**: 2025-06-14
- **last_updated**: 2026-07-01

**Scope**

- **skill_type**: module
- **ps_version**: 7.4+
- **platform**: cross-platform
- **skill_format**: .psm1 module
- **skill_domain**: mcp-bridge

**Content & Coverage**

- **skill_count**: 1
- **command_count**: 6
- **reference_count**: 0
- **coverage_areas**: scripting, AI, MCP, system administration, automation, CLI integration

**Quality & Community**

- **source_quality_signals**: has changelog, has contributing guide, has CI, has tests, has code of conduct, has security policy
- **open_issues**: 4
- **maintainer**: Yoshifumi Tsuda (yotsuda)
- **psscriptanalyzer_integration**: False

**Installation & Requirements**

- **install_method**: PowerShell-Gallery
- **dependencies**: PowerShell 7.4+, PSReadLine 2.3.4+ (Windows)
- **sdk_requirements**: MCP SDK (built-in)
- **install_complexity**: single-command

**Use Case**

- **target_audience**: developers, admins, AI engineers, enterprise
- **automation_domain**: AI
- **complexity_level**: intermediate
- **runtime_compatibility**: OpenCode, Claude Code, Claude Desktop, any MCP-compatible client

**Uncertain Fields**

- `ecosystem_crossref`: value uncertain, skipped from report
- `ai_framework_affiliation`: value uncertain, skipped from report

## Summary

- **Total items researched**: 18
- **Total field coverage**: 31/31 per item (100%)
- **Total uncertain fields**: 77
- **Failed items**: None
- **Output directory**: `results/`

### Items with Uncertain Fields

- agent-skills: 8 uncertain
- PowerShell-official/GitHub-skills: 8 uncertain
- powershell-expert: 7 uncertain
- start-automating/PowerShellAI: 7 uncertain
- github/awesome-copilot/powershell-instructions: 6 uncertain
- JosiahSiegel/powershell-master: 6 uncertain
- matheusallvarenga/claude-code-skills: 6 uncertain
- Devolutions/powershell-universal-skills: 5 uncertain
- BallLightningAB/agent-skills-updater: 4 uncertain
- powershell: 4 uncertain
- gunjanjp/powershell-mcp: 4 uncertain
- PSMCP: 3 uncertain
- powershell-expert: 2 uncertain
- powershell-5.1-expert: 2 uncertain
- yotsuda/PowerShell.MCP: 2 uncertain
- Azure/Metro.AI.PowerShell: 1 uncertain
- PSAI: 1 uncertain
- PSClaudeCode: 1 uncertain