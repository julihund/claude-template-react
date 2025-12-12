# Claude Code Template for React + Vite + FastAPI

Production-ready Claude Code configuration following [official best practices](https://www.anthropic.com/engineering/claude-code-best-practices).

## Quick Start

1. **Copy `.claude/` folder** into your project root
2. **Run `/init`** to auto-generate project-specific CLAUDE.md
3. **Update "Current Focus"** section in CLAUDE.md as you work
4. **Start coding** - Claude automatically loads configuration

## What to Modify Per Project

✅ **Only modify**: `CLAUDE.md` "Current Focus" section (2-3 active tasks)

❌ **Don't modify**: Guidelines, agents, skills, commands (reusable across all projects)

## File Structure (18 files total)

```
.claude/
├── CLAUDE.md                    # ⭐ Minimal context (43 lines, user customizes "Current Focus")
├── README.md                    # This file
├── settings.json                # MCP servers (Playwright, GitHub, SQLite, filesystem)
│
├── guidelines/ (5 files)        # Reference docs (loaded by agents, NOT in main context)
│   ├── coding-standards.md      # Self-documenting code, naming conventions
│   ├── design-system.md         # HSL colors + Tailwind + lightness states
│   ├── security.md              # OWASP Top 10 prevention
│   ├── testing.md               # TDD workflow (Red-Green-Refactor)
│   └── database.md              # SQLAlchemy async + migrations + offline sync
│
├── skills/ (2 files)            # Lightweight domain knowledge
│   ├── design-system.md         # Apply HSL palette + Tailwind
│   └── tdd.md                   # Guide test-first development
│
├── agents/ (4 files)            # Complex multi-step tasks
│   ├── implement-ui-component.md # TDD + Playwright visual tests + design system
│   ├── review-pr.md              # Run all tests + check all guidelines
│   ├── fix-security-issue.md     # OWASP audit + automated/manual scans
│   └── create-db-migration.md    # Alembic migrations + safety checks
│
└── commands/ (7 files)          # Parametrized slash commands
    ├── init.md                  # /init - Generate CLAUDE.md from codebase
    ├── review.md                # /review - Spawn review-pr agent
    ├── test.md                  # /test [filter] - Run test suite
    ├── test-browser.md          # /test-browser <url> - Playwright visual testing
    ├── security-review.md       # /security-review - Spawn security agent
    ├── migrate.md               # /migrate <name> - Create DB migration
    └── component.md             # /component <Name> - Create UI component
```

## How to Use

### Slash Commands

Quick actions (7 commands total):

- **/init** - Auto-generate CLAUDE.md by analyzing codebase
- **/review** - Comprehensive code review against all guidelines
- **/test** [filter] - Run test suite (Vitest + Playwright + pytest)
- **/test-browser <url>** - Visual testing with Playwright (screenshots, accessibility)
- **/security-review** - OWASP Top 10 audit + dependency scans
- **/migrate <name>** - Create Alembic database migration
- **/component <Name>** - Create UI component with TDD + Playwright tests

Examples:

- `/init` - Generate starter CLAUDE.md
- `/test-browser http://localhost:5173/components/button` - Visual test button
- `/security-review` - Full security audit
- `/component LoginForm` - Create LoginForm with tests

### Skills

Lightweight domain knowledge executed in main conversation:

- **design-system** - Apply HSL color palette and Tailwind CSS classes
- **tdd** - Guide test-first development workflow

Example: "Use the design-system skill to create a button component"

### Agents

Complex multi-step tasks spawned as separate processes:

- **implement-ui-component** - Build complete UI component with:
  - TDD (write tests first)
  - Design system compliance (HSL colors, Tailwind)
  - Responsive design
  - Accessibility
- **review-pr** - Comprehensive code review:
  - Run all tests (unit + integration + E2E)
  - Check against all guidelines
  - Verify code coverage
  - Suggest improvements
- **fix-security-issue** - Security audit:
  - Scan for OWASP Top 10 vulnerabilities
  - Check FastAPI security (JWT, CORS, validation)
  - Identify issues
  - Provide fixes
- **create-db-migration** - Database migration:
  - Create Alembic migration
  - Validate schema changes
  - Check for common pitfalls

Example: "Use the implement-ui-component agent to create a LoginForm"

## Guidelines

The `guidelines/` folder contains comprehensive coding standards with concrete examples. These are automatically loaded by agents when needed:

- **coding-standards.md** - Self-documenting code philosophy, naming conventions by language (TypeScript/Python), clean code principles
- **design-system.md** - HSL color palette, Tailwind configuration, lightness-based interaction states, responsive breakpoints
- **security.md** - OWASP Top 10 prevention, FastAPI security, JWT auth, input validation
- **testing.md** - TDD workflow, testing pyramid, Vitest/Playwright/pytest patterns, coverage requirements
- **database.md** - SQLAlchemy async patterns, migration best practices, offline-first sync architecture

## MCP Servers (5 configured)

Configured in `settings.json`:

- **@playwright** - E2E testing, visual regression, screenshot reviews
- **@context7** ⭐ - Up-to-date docs for 20,000+ libraries (React, FastAPI, Tailwind, etc.)
- **@github** - Issue/PR management (requires setup - see `SETUP.md`)
- **@sqlite** - Database inspection during development
- **@filesystem** - File operations

**Setup required**: GitHub MCP needs environment variable `GITHUB_PERSONAL_ACCESS_TOKEN` or use `/install-github-app`. See `SETUP.md` for details.

## Claude Code Best Practices

Based on [official documentation](https://www.anthropic.com/engineering/claude-code-best-practices):

### CLAUDE.md Guidelines

✅ **Keep it concise** - Minimal, universally applicable only (our template: 43 lines)
✅ **Use file:line references** - Not code snippets (they get outdated)
✅ **Update frequently** - Especially "Current Focus" section
✅ **Provide alternatives** - Not just restrictions ("use X instead of Y")
❌ **Don't include code style** - That's for linters (.prettierrc, .eslintrc, pyproject.toml)
❌ **Don't copy code** - Reference it with file paths

### Workflow Tips

- Use `/init` on new projects to auto-generate CLAUDE.md
- Update "Current Focus" daily with active tasks
- Use `gh` CLI for GitHub operations (`gh pr create`, `gh issue list`)
- Leverage MCP servers (Playwright for visual tests, GitHub for PRs)
- Guidelines are reference docs - agents load them when needed
- Run `/review` before committing to catch issues early

## Tech Stack Best Practices

This template follows official standards for:

### React + TypeScript

- Functional components with hooks
- TypeScript strict mode
- Component composition
- Custom hooks for reusable logic
- ESLint + Prettier

### Python + FastAPI

- Type hints everywhere (Python 3.11+)
- Pydantic validation
- Async/await for I/O
- SQLAlchemy 2.0 async ORM
- Black + isort + mypy

### Tailwind CSS

- Utility-first approach
- HSL color system with CSS variables
- Mobile-first responsive design
- Component variants via data attributes

### Testing (TDD)

- Write tests first, then implementation
- Testing pyramid: unit > integration > E2E
- 80%+ code coverage
- Playwright for E2E with visual regression

## Customization for Your Organization

### Updating Color Palette

Edit `.claude/guidelines/design-system.md` to customize the HSL color palette for your brand.

### Adding Custom Agents

Create new agent files in `.claude/agents/` following the pattern of existing agents.

### Adding Custom Commands

Create new command files in `.claude/commands/` with `$ARGUMENTS` support.

## Support

For issues or questions about Claude Code, visit:

- Claude Code documentation: https://claude.com/claude-code
- GitHub issues: https://github.com/anthropics/claude-code/issues

## Template Version

Version: 1.0.0
Last updated: 2025-12-12
Optimized for: Claude Code + React + Vite + FastAPI + Tailwind CSS
