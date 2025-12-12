# Project Context

## What This App Does
[Replace: 2-3 sentences describing app purpose, target users, key features]

## Tech Stack
React 18 + Vite + TypeScript + Tailwind | FastAPI + SQLAlchemy async | SQLite (dev) → PostgreSQL (prod)

## Key Directories
- `src/components/ui/` - Reusable UI primitives
- `src/lib/{db,sync,api}/` - Client DB, offline sync, API client
- `app/api/routes/` - FastAPI endpoints
- `app/models/` - SQLAlchemy models
- See `.claude/guidelines/` for coding standards, design system, security, testing, database

## Commands
```bash
npm run dev              # Frontend (localhost:5173)
uvicorn app.main:app --reload  # Backend (localhost:8000)
npm run test             # Vitest unit tests
npm run test:e2e         # Playwright E2E
pytest --cov=app         # Backend tests with coverage
alembic upgrade head     # Apply migrations
```

## Claude Code Shortcuts
- `/review` - Comprehensive code review
- `/test` [filter] - Run test suite
- `/test-browser <url>` - Visual test with Playwright
- `/security-review` - OWASP audit
- `/migrate <name>` - Create DB migration
- `/component <Name>` - Create UI component (TDD)
- Add "use context7" to prompts for up-to-date docs (React, FastAPI, Tailwind, etc.)

## Current Focus
[Update frequently]
- [ ] Active task 1
- [ ] Active task 2

## GitHub Workflow
- Use `gh` CLI for issues/PRs: `gh pr create`, `gh issue list`
- Branches: `feature/`, `bugfix/`, `hotfix/`
- Commits: Conventional Commits format
