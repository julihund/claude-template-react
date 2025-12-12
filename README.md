# MontaVis Template

**Enterprise-grade React/Vite + Python/FastAPI stack optimized for Claude Code development**

A production-ready full-stack template featuring agentisches development with specialized AI agents, comprehensive testing, and strict type safety.

## Features

- **🤖 Agentisches Development**: Specialized Claude Code agents for backend, frontend, testing, and dependency management
- **⚡ Modern Stack**: React 19, Vite 7, Python 3.12, FastAPI, SQLAlchemy 2.0
- **🎨 Design System**: Tailwind CSS v4 with HSLA lightness system for consistent UI
- **🔒 Security-First**: Multi-tenant isolation, JWT auth, permission-based access control
- **✅ Test-Driven**: Vitest, React Testing Library, Playwright, pytest
- **🌍 i18n Ready**: react-i18next with English and German
- **📦 DevContainer**: Isolated Docker environment with firewall configuration
- **🚀 Type-Safe**: TypeScript strict mode, Pydantic v2 validation

## Quick Start

### Prerequisites

- **Node.js** 20+ ([Download](https://nodejs.org/))
- **Python** 3.12+ ([Download](https://python.org/))
- **Git** ([Download](https://git-scm.com/))

### Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd montavis-template

# Run automated setup
chmod +x ./scripts/init.sh
./scripts/init.sh

# Or use Claude Code
/setup-project
```

### Start Development

**Terminal 1 - Frontend:**
```bash
cd client
npm run dev
```

**Terminal 2 - Backend:**
```bash
cd server
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate      # Windows

uvicorn app.main:app --reload
```

**Access:**
- Frontend: [http://localhost:5173](http://localhost:5173)
- API Docs: [http://localhost:8000/docs](http://localhost:8000/docs)

## Project Structure

```
montavis-template/
├── .context/                    # Claude Code knowledge base
│   ├── substrate.md             # Project overview
│   ├── architecture/            # System design
│   ├── guidelines/              # Coding standards
│   ├── frontend/                # Design system
│   └── backend/                 # API contracts
├── .claude/                     # Claude Code configuration
│   ├── agents/                  # Specialized subagents
│   │   ├── python-api-expert.json
│   │   ├── react-ts-expert.json
│   │   ├── contract-tester.json
│   │   └── dependency-synchronizer.json
│   ├── commands/                # Slash commands
│   │   ├── setup-project.md
│   │   ├── multi-agent-review.md
│   │   └── smart-debug.md
│   └── settings.json            # Permissions
├── .devcontainer/               # Docker dev environment
├── client/                      # React frontend
│   ├── src/
│   │   ├── features/            # Feature-based modules
│   │   ├── components/ui/       # Shared UI components
│   │   ├── hooks/               # Custom hooks
│   │   ├── services/            # API layer
│   │   ├── types/               # TypeScript types
│   │   └── locales/             # i18n translations
│   └── package.json
├── server/                      # FastAPI backend
│   ├── app/
│   │   ├── api/                 # API routes
│   │   ├── core/                # Security, dependencies
│   │   ├── models/              # SQLAlchemy models
│   │   ├── schemas/             # Pydantic schemas
│   │   └── services/            # Business logic
│   ├── alembic/                 # Database migrations
│   └── requirements.txt
├── scripts/                     # Automation scripts
│   └── init.sh
├── .mcp.json                    # MCP server config
└── README.md
```

## Claude Code Integration

### Skills (Automatisch aktiviert)

**Skills** sind Fähigkeiten, die Claude automatisch erkennt und nutzt, wenn relevant:

| Skill | Wofür | Beispiel-Prompts |
|-------|-------|------------------|
| **ui-ux-designer** | Design-Bewertung, UI-Entwicklung, Accessibility | "Bewerte das Login-Design", "Design eine Settings-Page" |

Skills aktivieren sich automatisch - du musst sie nicht explizit aufrufen.

### Specialized Agents

This template includes four specialized agents that work in isolation to prevent context pollution:

| Agent | Purpose | Key Responsibilities |
|-------|---------|---------------------|
| **python-api-expert** | Backend development | FastAPI routes, async SQLAlchemy, multi-tenant isolation, permissions |
| **react-ts-expert** | Frontend development | React components, TypeScript strict mode, design system, accessibility |
| **contract-tester** | Quality assurance | Write tests, validate contracts, never writes implementation code |
| **dependency-synchronizer** | Package management | npm/pip dependencies, version conflicts, security audits |

### Slash Commands

Use these commands for streamlined workflows:

```bash
/setup-project           # Initialize complete environment
/multi-agent-review      # Coordinate comprehensive code review
/smart-debug            # Intelligent error analysis
```

### MCP Servers

Configured tools for enhanced capabilities:

- **SQLite**: Database queries and debugging
- **GitHub**: PR management, issue tracking
- **Filesystem**: Enhanced file access
- **Playwright**: Browser automation for E2E testing

## Development Workflow

### 1. Feature Development

```bash
# Create feature branch
git checkout -b feature/user-authentication

# Develop with TDD
# - Write tests first (contract-tester agent)
# - Implement feature (python-api-expert or react-ts-expert)
# - Run tests continuously

npm run test          # Frontend tests (watch mode)
pytest               # Backend tests
```

### 2. Code Review

```bash
# Before committing
/multi-agent-review

# Address feedback from all agents
# - python-api-expert: Security, scalability
# - react-ts-expert: Design compliance, accessibility
# - contract-tester: Test coverage

# Run full test suite
npm run test:run && cd server && pytest
```

### 3. Commit

```bash
# Follow conventional commits
git add .
git commit -m "feat(auth): add JWT authentication"
```

## Testing

### Frontend (Vitest + React Testing Library + Playwright)

```bash
cd client

npm run test              # Watch mode
npm run test:run          # Single run
npm run test:coverage     # With coverage report
npm run test:e2e          # Playwright E2E tests
npm run test:e2e:ui       # Playwright UI mode
```

### Backend (pytest + pytest-asyncio)

```bash
cd server
source venv/bin/activate

pytest                           # All tests
pytest tests/test_auth.py        # Specific file
pytest -k test_login             # Specific test
pytest --cov=app                 # With coverage
```

## Code Quality

### Linting & Type Checking

```bash
# Frontend
cd client
npm run lint              # ESLint
npm run typecheck         # TypeScript compiler

# Backend
cd server
ruff check .              # Linting
mypy app                  # Type checking
black --check .           # Formatting check
```

### Pre-commit Checks

```bash
# Run before every commit
cd client && npm run lint && npm run typecheck && npm run test:run
cd server && ruff check . && mypy app && pytest
```

## Architecture Principles

### Context Engineering

- **Subagents for isolation**: All complex tasks delegated to specialized agents
- **Concise context**: Only essential information in main thread
- **8x efficiency gain**: Compared to direct context pollution

### No Pixels Policy

```tsx
// ❌ WRONG
<div style={{ padding: '16px', fontSize: '14px' }} />

// ✅ CORRECT
<div className="p-4 text-sm" />
```

### Multi-Tenant Security

```python
# ✅ CORRECT: Always filter by company_id
stmt = select(Instruction).where(
    Instruction.id == id,
    Instruction.company_id == user.company_id  # REQUIRED
)

# ❌ WRONG: Missing company filter (SECURITY VULNERABILITY)
stmt = select(Instruction).where(Instruction.id == id)
```

### Type Safety

```typescript
// ❌ WRONG: Using 'any'
function processData(data: any) { }

// ✅ CORRECT: Proper types
function processData(data: UserData) { }
```

## Deployment

### Environment Variables

Create [.env](./server/.env) files:

**Backend (.env):**
```bash
DATABASE_URL=postgresql://user:pass@localhost/dbname
SECRET_KEY=your-secret-key-min-32-chars
CORS_ORIGINS=["https://your-domain.com"]
```

**Frontend (.env):**
```bash
VITE_API_URL=https://api.your-domain.com
```

### Build for Production

```bash
# Frontend
cd client
npm run build
# Output: client/dist/

# Backend
cd server
pip install -r requirements.txt
# Deploy with gunicorn or uvicorn
```

## Onboarding for Team Members

### For Developers

1. **Clone and setup**: Run `./scripts/init.sh`
2. **Read context**: Browse [.context/](./.context/) directory
3. **Try slash commands**: Use `/setup-project`, `/multi-agent-review`
4. **Follow patterns**: Check existing code for conventions

### For Designers (Non-Developers)

You can use Claude Code to improve UI without writing code:

```bash
# Example prompts for designers:
"Make the login button more prominent"
"Update the color scheme to be warmer"
"Improve the spacing in the navigation bar"
"Add a loading animation to the submit button"
```

Claude's react-ts-expert agent will:
- Apply design system rules automatically
- Ensure accessibility compliance
- Maintain consistent spacing/colors
- Generate proper TypeScript

### For QA/Testers

```bash
# Use contract-tester agent
"Write E2E test for login flow"
"Add validation tests for user registration"
"Test edge cases for video upload"
```

## Troubleshooting

### Common Issues

**Frontend won't start:**
```bash
cd client
rm -rf node_modules package-lock.json
npm install
```

**Backend import errors:**
```bash
cd server
source venv/bin/activate
pip install -r requirements.txt
```

**Database errors:**
```bash
cd server
rm montavis.db
python -m app.db_init --demo
```

**Port already in use:**
```bash
# Frontend
npm run dev -- --port 5174

# Backend
uvicorn app.main:app --reload --port 8001
```

### Getting Help

1. **Use `/smart-debug`**: Intelligent error analysis
2. **Check context docs**: [.context/](./.context/) has answers
3. **Ask specialized agents**: Use Task tool with appropriate agent

## Contributing

### Standards

- Follow [Coding Standards](./.context/guidelines/coding_standards.md)
- Apply [Design System](./.context/frontend/design_system.md)
- Adhere to [API Contracts](./.context/backend/api_contracts.md)

### Pull Request Process

1. Create feature branch
2. Implement with TDD (tests first)
3. Run `/multi-agent-review`
4. Address all critical issues
5. Ensure tests pass
6. Submit PR with clear description

## License

[Your License Here]

## Support

For issues or questions:
- Check [.context/](./.context/) documentation
- Use Claude Code's `/smart-debug` command
- Review [troubleshooting](#troubleshooting) section

---

**Built with Claude Code** - Leveraging agentisches development for maximum efficiency.
