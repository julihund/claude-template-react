# Claude Code Setup Guide

## MCP Server Configuration

This template uses 5 MCP servers for enhanced capabilities:

### 1. Playwright (Ready to use)
- **Purpose**: E2E testing, visual regression, screenshots
- **Setup**: None required - installed via npx on first use

### 2. Context7 (Ready to use) ⭐
- **Purpose**: Up-to-date documentation for 20,000+ libraries
- **Setup**: None required - installed via npx on first use
- **Usage**: Add "use context7" to any prompt for current docs
  - Example: "use context7 for FastAPI authentication patterns"
  - Example: "use context7 for React 18 hooks"

### 3. SQLite (Ready to use)
- **Purpose**: Database inspection during development
- **Setup**: None required - automatically connects to `app.db`

### 4. Filesystem (Ready to use)
- **Purpose**: File operations and workspace management
- **Setup**: None required - automatically uses current directory

### 5. GitHub (Requires Setup) 🔐

#### Option A: Using GitHub App (Recommended - Easiest)
```bash
# No manual token needed - uses GitHub app authentication
# Just run in Claude Code:
/install-github-app
```

#### Option B: Using Personal Access Token
If you prefer manual token management:

1. **Create GitHub Personal Access Token**:
   - Go to https://github.com/settings/tokens/new
   - Select scopes:
     - ✅ `repo` (Full control of private repositories)
     - ✅ `read:org` (Read org and team membership)
     - ✅ `read:user` (Read user profile data)
   - Generate token (starts with `ghp_`)

2. **Set Environment Variable**:

   **Windows (PowerShell)**:
   ```powershell
   [Environment]::SetEnvironmentVariable("GITHUB_PERSONAL_ACCESS_TOKEN", "ghp_your_token_here", "User")
   ```

   **macOS/Linux (add to ~/.bashrc or ~/.zshrc)**:
   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_your_token_here"
   ```

3. **Restart Terminal/Claude Code** to load the environment variable

4. **Verify**:
   ```bash
   # In Claude Code, try:
   gh repo list
   # Or ask Claude to "list my GitHub repositories"
   ```

#### GitHub MCP Features
Once configured, you can:
- Create issues: `gh issue create --title "Bug" --body "Description"`
- Create PRs: `gh pr create --title "Feature" --body "Details"`
- List repos: `gh repo list`
- View PR comments: `gh pr view 123 --comments`
- Or simply ask Claude: "create a GitHub issue for this bug"

## Security Best Practices

❌ **NEVER commit tokens to git**:
- Add to `.gitignore`: `*.env`, `.env.local`
- Use environment variables, NOT hardcoded values
- Docker image reads from `GITHUB_PERSONAL_ACCESS_TOKEN` env var

✅ **Safe configuration**:
- Token stored in OS environment variables
- Not visible in code or settings files
- Can be rotated without changing code

## Troubleshooting

### GitHub MCP not working
1. Check environment variable is set: `echo $GITHUB_PERSONAL_ACCESS_TOKEN` (macOS/Linux) or `$env:GITHUB_PERSONAL_ACCESS_TOKEN` (Windows)
2. Verify Docker is running: `docker ps`
3. Restart Claude Code after setting env var
4. Try GitHub App method instead: `/install-github-app`

### Context7 not working
- No setup required - just add "use context7" to your prompt
- Example: "use context7 to get latest Tailwind CSS utilities"

### Playwright not launching
- Ensure you have Chromium/Chrome installed
- Run: `npx playwright install chromium`

## Alternative: .mcp.json (Project-Shared Config)

If you want to share MCP config with your team via git:

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"]
    }
  }
}
```

Still requires each developer to set `GITHUB_PERSONAL_ACCESS_TOKEN` env var locally.

## Resources

- [GitHub MCP Server](https://github.com/github/github-mcp-server)
- [Context7 MCP](https://github.com/upstash/context7)
- [Claude Code MCP Docs](https://docs.anthropic.com/en/docs/claude-code/mcp)
