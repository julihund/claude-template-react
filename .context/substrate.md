# Project Substrate

**MontaVis Template** - Enterprise-grade React/Vite + Python/FastAPI stack optimized for Claude Code development.

## System Overview

Full-stack monorepo with strict separation of concerns:

```
montavis-template/
├── client/              # React 19 + Vite 7 + TypeScript
├── server/              # Python 3.12 + FastAPI + SQLAlchemy
├── .context/            # Claude Code knowledge base (this directory)
├── .claude/             # Agents, commands, MCP configuration
├── .devcontainer/       # Docker development environment
└── scripts/             # Automation and initialization
```

## Technology Stack

### Frontend
- **Runtime**: React 19 (Concurrent Features, RSC-ready)
- **Build**: Vite 7 (ESBuild, HMR, optimized chunks)
- **Language**: TypeScript 5+ (strict mode)
- **Styling**: Tailwind CSS v4 (CSS-first config)
- **State**: Zustand (lightweight, TypeScript-first)
- **i18n**: react-i18next (EN/DE)
- **Testing**: Vitest + React Testing Library + Playwright

### Backend
- **Framework**: FastAPI 0.115+
- **ORM**: SQLAlchemy 2.0 (async)
- **Validation**: Pydantic v2
- **Database**: SQLite (dev) / PostgreSQL (prod)
- **Auth**: JWT + Argon2
- **Migrations**: Alembic
- **Testing**: pytest + pytest-asyncio

### DevOps
- **Container**: DevContainer (Docker + Firewall isolation)
- **CI/CD**: GitHub Actions (linting, tests, security scans)
- **Version Control**: Git (conventional commits)

## Key Architectural Decisions

### 1. Monorepo Structure
- Single repository for client and server ensures atomic cross-stack changes
- Shared TypeScript types generated from Pydantic schemas
- Unified linting and formatting configuration

### 2. Feature-Based Organization
```
client/src/features/auth/
├── index.ts           # Public API (barrel export)
├── components/        # AuthForm, LoginButton
├── hooks/             # useAuth, usePermissions
├── services/          # authService (API calls)
└── types.ts           # Feature-specific types
```

### 3. Permission-Based Security
- Backend: Resource-based permissions (`resource:action:resource_id`)
- Frontend: Role-based UI rendering
- Multi-tenant data isolation via `company_id`

### 4. Type-Safe API Layer
```typescript
// Generated from Pydantic schemas
import { UserSchema, InstructionSchema } from '@/types/api';
```

## Databases

### Development
- SQLite with WAL mode
- In-memory option for tests
- Demo data seeding via `scripts/seed-db.py`

### Production
- PostgreSQL 16+
- Connection pooling via SQLAlchemy AsyncEngine
- Alembic migrations

## Core Entities

```
User → Company → Instruction → Version → Step → Substep
                                              ↓
                                        Video + Content
```

## Environment Configuration

### Required Environment Variables

```bash
# Backend (server/.env)
DATABASE_URL=sqlite:///./montavis.db
SECRET_KEY=your-secret-key-min-32-chars
CORS_ORIGINS=["http://localhost:5173"]

# Frontend (client/.env)
VITE_API_URL=http://localhost:8000

# Optional: MCP GitHub integration
GITHUB_TOKEN=ghp_your_github_token
```

## Quick Start Commands

```bash
# Full stack initialization
./scripts/init.sh

# Frontend only
cd client && npm install && npm run dev

# Backend only
cd server && pip install -r requirements.txt && uvicorn app.main:app --reload

# Run all tests
npm run test && cd server && pytest
```

## Development Workflow

1. **Start**: Use `/setup-project` command (auto-runs init.sh)
2. **Develop**: Feature-based branches, TDD workflow
3. **Review**: `/multi-agent-review` before commit
4. **Test**: Continuous testing with contract-tester agent
5. **Deploy**: GitHub Actions CI/CD pipeline

## Session Continuity

When resuming work (even on different machines):
- `.context/` contains all architectural knowledge
- `scripts/init.sh` bootstraps environment in <30s
- Claude Code reconstructs full context from file system
- No manual state reconstruction needed

## Project Constraints

See specialized context files:
- [architecture/system_design.md](architecture/system_design.md) - System boundaries, API contracts
- [guidelines/coding_standards.md](guidelines/coding_standards.md) - Code quality rules
- [frontend/design_system.md](frontend/design_system.md) - UI/UX standards
- [backend/api_contracts.md](backend/api_contracts.md) - API specifications
