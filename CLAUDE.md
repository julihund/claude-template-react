# CLAUDE.md

**MontaVis Template - Agentisches Development Framework**

This file provides immediate guidance to Claude Code when working with this repository.

## 🎯 Project Mission

Enterprise-grade full-stack template optimized for Claude Code's agentisches development approach. Built for startups that need rapid, reliable development with strict quality standards.

## ⚡ Quick Reference

### Start Development

```bash
# One-command setup
./scripts/init.sh

# Or use Claude Code
/setup-project

# Start servers
cd client && npm run dev          # Frontend: http://localhost:5173
cd server && uvicorn app.main:app --reload  # Backend: http://localhost:8000
```

### Essential Commands

```bash
# Development
npm run dev              # Start frontend dev server
npm run test             # Run tests (watch mode)
npm run lint             # Lint code
npm run typecheck        # TypeScript type checking

cd server
pytest                   # Run backend tests
uvicorn app.main:app --reload  # Start backend server
```

### Claude Code Features

**Skills (automatisch):**
- **ui-ux-designer**: "Bewerte mein Design", "Design eine Settings-Page"

**Slash Commands (manuell):**
```
/setup-project           Initialize complete environment
/multi-agent-review      Comprehensive code review before commit
/smart-debug [error]     Intelligent error analysis
```

## 📋 Critical Rules

### Universal Constraints

1. **No Backwards Compatibility** - Delete unused code, don't preserve it
2. **Test Before Commit** - All tests must pass
3. **Follow Context** - `.context/` directory is source of truth
4. **Use Subagents** - Delegate complex tasks to specialized agents

### Frontend Rules

- ❌ **NO PIXELS** - Use rem/Tailwind classes only
- ❌ **NO 'any' TYPE** - Use proper TypeScript types
- ❌ **NO HARDCODED TEXT** - All text in i18n files
- ❌ **NO DEEP IMPORTS** - Import from feature index only
- ✅ **ALWAYS aria-label** on icon buttons
- ✅ **ALWAYS HSLA** for interactive color states

### Backend Rules

- ✅ **ALWAYS async/await** for database operations
- ✅ **ALWAYS company_id filter** for multi-tenant queries
- ✅ **ALWAYS permission checks** before data access
- ✅ **ALWAYS Pydantic v2** for validation
- ❌ **NO print()** - Use logger instead
- ❌ **NO secrets in code** - Use environment variables

## 🏗️ Architecture

### Tech Stack

**Frontend:**
- React 19 + Vite 7 + TypeScript 5
- Tailwind CSS v4
- Zustand (state)
- react-i18next (EN/DE)
- Vitest + Playwright

**Backend:**
- Python 3.12 + FastAPI
- SQLAlchemy 2.0 async
- Pydantic v2
- JWT + Argon2 auth
- pytest

**Infrastructure:**
- DevContainer (Docker)
- SQLite (dev) / PostgreSQL (prod)
- GitHub Actions (CI/CD)

### Directory Structure

```
.context/          # 📚 Knowledge base (READ THIS FIRST)
  ├── substrate.md           # Project overview
  ├── architecture/          # System design
  ├── guidelines/            # Coding standards
  ├── frontend/              # Design system
  └── backend/               # API contracts

.claude/           # 🤖 Agent configuration
  ├── skills/                # Auto-activated capabilities
  ├── agents/                # Specialized subagents
  └── commands/              # Slash commands

client/            # ⚛️ React frontend
  └── src/
      ├── features/          # Feature modules (auth, etc.)
      ├── components/ui/     # Shared components
      ├── hooks/             # Custom hooks
      ├── services/          # API layer
      └── locales/           # i18n (en.json, de.json)

server/            # 🐍 Python backend
  └── app/
      ├── api/               # API routes
      ├── models/            # SQLAlchemy models
      ├── schemas/           # Pydantic schemas
      └── services/          # Business logic
```

## 🤖 Agentisches Development

### Skills (Automatisch aktiviert)

Claude erkennt automatisch, wann diese Skills benötigt werden:

| Skill | Wann aktiviert | Was es tut |
|-------|----------------|------------|
| **ui-ux-designer** | Design-Fragen, UI-Entwicklung | Bewertet Designs, schlägt Verbesserungen vor, entwickelt neue UIs |

**Beispiele:**
- "Ist mein Button zu klein?" → ui-ux-designer aktiviert
- "Design mir eine Settings-Page" → ui-ux-designer aktiviert
- "Bewerte die Navigation" → ui-ux-designer aktiviert

### Specialized Agents

Use the Task tool with these agents for optimal efficiency:

| Agent | Use For | Key Expertise |
|-------|---------|---------------|
| **python-api-expert** | Backend code | FastAPI, async SQLAlchemy, multi-tenant security |
| **react-ts-expert** | Frontend code | React 19, TypeScript strict, design system |
| **contract-tester** | Testing only | Vitest, pytest, E2E (NEVER implements features) |
| **dependency-synchronizer** | Packages | npm/pip, version conflicts, security |

### Context Engineering

**Always delegate to subagents for:**
- Long error logs → `/smart-debug`
- Code reviews → `/multi-agent-review`
- Complex debugging → Isolated subagent
- Multi-file changes → Parallel subagents

**Benefits:**
- 8x more efficient (prevents context pollution)
- Parallel processing
- Specialized knowledge
- Clean main context

## 🎨 Design System

### Color System (HSLA Lightness)

```tsx
// Interactive element pattern
<button className={clsx(
  'bg-[--item-bg]',
  'hover:bg-[--item-bg-hover]',      // +8% lightness
  selected && 'bg-[--item-bg-selected]',  // +12%
  'active:bg-[--item-bg-active]'    // +22%
)} />
```

### Typography

- Default UI: `text-sm` (0.875rem)
- Body text: `text-base` (1rem)
- Headings: `font-semibold`

### Spacing

- Standard: `p-4` (1rem)
- Large: `p-6` (1.5rem)
- Tight: `gap-2` (0.5rem)

## 🔒 Security

### Multi-Tenant Isolation

```python
# ✅ CORRECT: Always filter by company_id
stmt = select(Instruction).where(
    Instruction.id == id,
    Instruction.company_id == user.company_id  # REQUIRED
)

# ❌ WRONG: Missing company filter
stmt = select(Instruction).where(Instruction.id == id)
# This leaks data across companies!
```

### Permission System

Format: `{resource}:{action}:{resource_id}`

```python
# Examples
"instruction:read:*"           # Read all instructions
"instruction:write:abc123"     # Write specific instruction
"*:*:*"                        # Super admin
```

## 🧪 Testing

### TDD Workflow

1. **contract-tester writes tests** based on requirements
2. **Developer agent implements** feature
3. **contract-tester validates** implementation
4. **Repeat** until tests pass

### Test Commands

```bash
# Frontend
npm run test              # Watch mode
npm run test:run          # Single run
npm run test:e2e          # Playwright E2E

# Backend
pytest                    # All tests
pytest -k test_auth       # Specific test
pytest --cov=app          # With coverage
```

## 📝 Code Patterns

### React Component

```typescript
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui';

interface Props {
  onSubmit: (data: FormData) => void;
}

export function Component({ onSubmit }: Props) {
  const { t } = useTranslation();
  const [value, setValue] = useState('');

  const handleSubmit = () => {
    onSubmit({ value });
  };

  return (
    <form className="p-4 bg-[--color-surface] rounded-lg">
      <h2 className="text-lg font-semibold mb-2">
        {t('component.title')}
      </h2>
      {/* Content */}
    </form>
  );
}
```

### FastAPI Endpoint

```python
from typing import Annotated
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.deps import get_db, get_current_user

router = APIRouter(prefix="/api/v1/resource")

@router.get("/")
async def list_resources(
    db: Annotated[AsyncSession, Depends(get_db)],
    user: Annotated[User, Depends(get_current_user)]
):
    # Check permission
    await check_permission(db, user, "resource", "read", "*")

    # Query with company isolation
    stmt = select(Resource).where(
        Resource.company_id == user.company_id
    )
    result = await db.execute(stmt)
    return result.scalars().all()
```

## 🚀 Workflow

### Before Starting Work

1. Read `.context/` docs for feature area
2. Understand existing patterns
3. Plan with appropriate agent

### During Development

1. Use TDD (tests first)
2. Follow strict rules (no pixels, no any, etc.)
3. Run tests continuously
4. Commit frequently with conventional commits

### Before Committing

```bash
# Automated review
/multi-agent-review

# Fix critical issues

# Verify
npm run lint && npm run typecheck && npm run test:run
cd server && pytest

# Commit
git commit -m "feat(auth): add password reset"
```

## 🎓 Onboarding

### For Developers

1. Run `/setup-project`
2. Read `.context/substrate.md`
3. Browse existing features for patterns
4. Try `/multi-agent-review` on sample code

### For Non-Developers (Designers, PMs)

You can use Claude Code to:
- Improve UI: "Make login button more prominent"
- Fix styling: "Increase spacing in navigation"
- Add features: "Add loading spinner to submit button"

Claude's agents will:
- Follow design system automatically
- Ensure accessibility
- Generate proper code
- Run tests

## 📚 Documentation

**Full context in `.context/` directory:**

- [substrate.md](./.context/substrate.md) - Project overview
- [architecture/system_design.md](./.context/architecture/system_design.md) - Architecture
- [guidelines/coding_standards.md](./.context/guidelines/coding_standards.md) - Code standards
- [frontend/design_system.md](./.context/frontend/design_system.md) - Design system
- [backend/api_contracts.md](./.context/backend/api_contracts.md) - API specs

**Agent documentation:**
- [.claude/README.md](./.claude/README.md) - Agent guide
- [.claude/agents/](./.claude/agents/) - Agent configs
- [.claude/commands/](./.claude/commands/) - Command docs

## 🔧 Troubleshooting

### Use `/smart-debug`

For any error, use the smart debug command:

```
/smart-debug "Build fails with TypeScript error"
/smart-debug "API returns 500 on login"
/smart-debug "Tests failing in video player"
```

### Common Issues

**Port conflicts:**
```bash
npm run dev -- --port 5174
uvicorn app.main:app --port 8001
```

**Database reset:**
```bash
rm server/montavis.db
python -m app.db_init --demo
```

**Clean install:**
```bash
rm -rf client/node_modules client/package-lock.json
cd client && npm install
```

## 💡 Tips for Maximum Efficiency

1. **Always read `.context/` first** - It's the source of truth
2. **Use specialized agents** - They're experts in their domain
3. **Leverage parallel processing** - `/multi-agent-review` runs agents simultaneously
4. **Keep context clean** - Delegate complex tasks to subagents
5. **Follow TDD** - Tests first, implementation second
6. **Review before commit** - `/multi-agent-review` catches issues early

---

**Built for Claude Code** - Optimized for agentisches development with context engineering principles.
