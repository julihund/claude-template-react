# Claude Code Configuration

This directory contains the complete Claude Code configuration for agentisches development.

## Structure

```
.claude/
├── agents/                      # Specialized subagents
│   ├── python-api-expert.json   # Backend specialist
│   ├── react-ts-expert.json     # Frontend specialist
│   ├── contract-tester.json     # QA specialist
│   └── dependency-synchronizer.json  # Package management
├── commands/                    # Slash commands
│   ├── setup-project.md         # Environment initialization
│   ├── multi-agent-review.md    # Coordinated code review
│   └── smart-debug.md           # Intelligent error analysis
├── settings.json                # Permissions and configuration
└── README.md                    # This file
```

## Agents

### python-api-expert

**Expertise**: FastAPI, SQLAlchemy 2.0 async, Pydantic v2, multi-tenant security

**Use for:**
- Implementing API endpoints
- Database queries and migrations
- Authentication and authorization
- Backend business logic

**Critical Rules:**
- Always use async/await
- Always filter by company_id for multi-tenant isolation
- Always validate permissions before data access
- Use Pydantic v2 for validation

**Example:**
```
Use the python-api-expert agent to implement a new API endpoint for creating instructions with proper permission checks and company isolation.
```

---

### react-ts-expert

**Expertise**: React 19, TypeScript strict, Tailwind CSS v4, accessibility, design system

**Use for:**
- Building React components
- Implementing UI features
- State management with Zustand
- Internationalization

**Critical Rules:**
- Never use 'any' type
- Never use pixel values (rem/Tailwind only)
- Never hardcode text (use i18n)
- Never deep import (barrel exports only)
- Always add aria-label to icon buttons

**Example:**
```
Use the react-ts-expert agent to create a login form component following the design system with full accessibility support.
```

---

### contract-tester

**Expertise**: Vitest, React Testing Library, Playwright, pytest, test-driven development

**Use for:**
- Writing unit tests
- Writing integration tests
- Writing E2E tests
- Validating API contracts

**Critical Rule:**
**NEVER writes implementation code** - only tests and validation

**Example:**
```
Use the contract-tester agent to write comprehensive tests for the authentication feature, including happy path, edge cases, and error scenarios.
```

---

### dependency-synchronizer

**Expertise**: npm, pip, version conflicts, security audits, package management

**Use for:**
- Adding/updating dependencies
- Resolving version conflicts
- Security vulnerability scanning
- Maintaining package.json and requirements.txt

**Example:**
```
Use the dependency-synchronizer agent to update React to version 19 and resolve any peer dependency conflicts.
```

## Slash Commands

### /setup-project

Initializes the complete development environment.

**What it does:**
- Installs frontend dependencies (npm)
- Sets up Python virtual environment
- Installs backend dependencies (pip)
- Initializes database with demo data

**When to use:**
- First time project setup
- After cloning repository
- After major dependency updates
- When onboarding new team members

**Usage:**
```
/setup-project
```

---

### /multi-agent-review

Coordinates comprehensive code review across all specialized agents.

**What it does:**
- Launches python-api-expert for backend review
- Launches react-ts-expert for frontend review
- Launches contract-tester for test validation
- Aggregates feedback from all agents

**When to use:**
- Before committing significant changes
- Before creating pull requests
- After implementing new features
- Before merging to main branch

**Usage:**
```
/multi-agent-review                    # Review recent changes
/multi-agent-review features/auth      # Review specific feature
/multi-agent-review src/api/users.py   # Review specific file
```

---

### /smart-debug

Intelligent error analysis using isolated subagents to prevent context pollution.

**What it does:**
- Routes error to appropriate specialist agent
- Analyzes error in isolated context
- Returns concise root cause analysis
- Provides exact fix recommendations

**When to use:**
- Complex error messages
- Build/compilation failures
- Test failures
- Runtime errors

**Usage:**
```
/smart-debug "API returns 500 on login"
/smart-debug build error
/smart-debug test failures in video player
```

## Best Practices

### Context Isolation

**Always use subagents for:**
- Long error logs (prevents context pollution)
- Complex debugging (isolates analysis)
- Code reviews (parallel processing)
- Dependency updates (version conflict resolution)

**Benefits:**
- 8x more efficient token usage
- Higher quality output (specialized knowledge)
- Cleaner main context
- Parallel processing capability

### Agent Selection

| Task Type | Agent | Why |
|-----------|-------|-----|
| API endpoint | python-api-expert | Database, permissions, async patterns |
| React component | react-ts-expert | Design system, accessibility, TypeScript |
| Write tests | contract-tester | Test methodology, never implements |
| Package issue | dependency-synchronizer | Version resolution, security |
| Code review | /multi-agent-review | All agents in parallel |
| Error analysis | /smart-debug | Routes to appropriate agent |

### Parallel Processing

Launch multiple agents simultaneously for maximum efficiency:

```
# Instead of sequential:
1. Review backend
2. Review frontend
3. Review tests

# Use parallel:
Use /multi-agent-review (launches all 3 agents at once)
```

## MCP Servers

Configured in [../.mcp.json](../.mcp.json):

| Server | Purpose | Authentication |
|--------|---------|----------------|
| **sqlite** | Database queries and debugging | None (local file) |
| **github** | PR management, issue tracking | GITHUB_TOKEN env var |
| **filesystem** | Enhanced file access | None (local) |
| **playwright** | Browser automation, E2E testing | None |

### Setting up GitHub MCP

```bash
# Windows (PowerShell)
$env:GITHUB_TOKEN="ghp_your_token_here"

# Linux/Mac
export GITHUB_TOKEN="ghp_your_token_here"
```

Get token at: https://github.com/settings/tokens (needs `repo` scope)

## Permissions

Configured in [settings.json](./settings.json):

**Allowed:**
- All file operations (Read, Write, Edit, Glob, Grep)
- Bash commands
- Web access (WebFetch, WebSearch)
- All MCP tools
- Task tool (for agent orchestration)

**Scope:**
- Limited to project directory only
- No access to system files outside project

## Context Documents

The [../.context/](../.context/) directory provides the knowledge base for all agents:

| Document | Purpose | Used By |
|----------|---------|---------|
| substrate.md | Project overview | All agents |
| architecture/system_design.md | System architecture | python-api-expert, react-ts-expert |
| guidelines/coding_standards.md | Code quality rules | All agents |
| frontend/design_system.md | UI/UX standards | react-ts-expert |
| backend/api_contracts.md | API specifications | python-api-expert, contract-tester |

## Workflow Example

### Implementing a New Feature

```
1. Plan:
   "I need to add a user profile page with edit functionality"

2. Backend (python-api-expert):
   "Create API endpoints for:
   - GET /api/v1/users/me/profile
   - PATCH /api/v1/users/me/profile
   Follow multi-tenant isolation and permission checks"

3. Frontend (react-ts-expert):
   "Create ProfilePage component with:
   - Profile display
   - Edit form
   - Follow design system (no pixels, HSLA states, i18n)"

4. Tests (contract-tester):
   "Write tests for profile feature:
   - API endpoint tests (auth, validation, company isolation)
   - Component tests (rendering, interactions, errors)
   - E2E test (view and edit profile)"

5. Review:
   /multi-agent-review

6. Debug (if needed):
   /smart-debug "profile update fails with 403"
```

## Tips for Maximum Efficiency

1. **Use slash commands** - They orchestrate agents automatically
2. **Leverage parallel processing** - Multiple agents work simultaneously
3. **Keep context clean** - Delegate complex tasks to subagents
4. **Follow TDD** - Let contract-tester write tests first
5. **Review before commit** - Always run /multi-agent-review

## Extending the Configuration

### Adding a New Agent

1. Create JSON file in `agents/` directory
2. Define name, description, instructions, tools, model
3. Reference context documents
4. Use Task tool to invoke

### Adding a New Command

1. Create markdown file in `commands/` directory
2. Document purpose, usage, implementation
3. Include examples and troubleshooting
4. Test with various scenarios

## Support

- **Context docs**: See [../.context/](../.context/)
- **Usage examples**: Check agent JSON files
- **Troubleshooting**: Use `/smart-debug`
- **Architecture**: Read [substrate.md](../.context/substrate.md)
