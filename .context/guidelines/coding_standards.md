# Coding Standards

## Core Principles

1. **Clean Code**: Self-documenting code with minimal comments
2. **Single Responsibility**: One purpose per function/class/module
3. **Type Safety**: Strict TypeScript, no `any` types
4. **Test Coverage**: TDD workflow for all new features
5. **No Backwards Compatibility**: Delete unused code, don't preserve it

## TypeScript Standards

### Strict Mode Configuration

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### Type Declaration Rules

```typescript
// ✅ CORRECT: Explicit interface
interface User {
  id: string;
  email: string;
  company_id: string;
}

// ✅ CORRECT: Type inference when obvious
const count = 5; // number inferred

// ❌ WRONG: Using 'any'
function processData(data: any) { }

// ✅ CORRECT: Use proper types
function processData(data: unknown) {
  if (typeof data === 'object' && data !== null) {
    // Type narrowing
  }
}

// ❌ WRONG: Optional chaining abuse
const value = data?.user?.profile?.name?.first;

// ✅ CORRECT: Validate structure
if (data?.user?.profile) {
  const name = data.user.profile.name.first;
}
```

### Import Organization

```typescript
// 1. External dependencies
import { useState, useEffect } from 'react';
import { clsx } from 'clsx';

// 2. Internal aliases (@/)
import { Button } from '@/components/ui';
import { useAuth } from '@/features/auth';

// 3. Relative imports (same feature only)
import { validateEmail } from './utils';
import type { LoginFormData } from './types';
```

### Feature Exports (Barrel Pattern)

```typescript
// ✅ CORRECT: Import from feature index
import { useAuth, LoginForm } from '@/features/auth';

// ❌ WRONG: Deep import (ESLint error)
import { LoginForm } from '@/features/auth/components/LoginForm';
```

## Python Standards

### Style Guide

Follow PEP 8 with modifications:
- Line length: 100 characters
- Use Black formatter (automatic)
- Use Ruff for linting

### Type Annotations

```python
# ✅ CORRECT: Full type annotations
async def get_user(db: AsyncSession, user_id: str) -> User | None:
    stmt = select(User).where(User.id == user_id)
    result = await db.execute(stmt)
    return result.scalar_one_or_none()

# ❌ WRONG: No type annotations
async def get_user(db, user_id):
    stmt = select(User).where(User.id == user_id)
    result = await db.execute(stmt)
    return result.scalar_one_or_none()
```

### Async/Await

```python
# ✅ CORRECT: Consistent async
async def create_instruction(
    db: AsyncSession,
    data: InstructionCreate
) -> Instruction:
    instruction = Instruction(**data.model_dump())
    db.add(instruction)
    await db.commit()
    await db.refresh(instruction)
    return instruction

# ❌ WRONG: Mixing sync and async
def create_instruction(db, data):  # Should be async
    instruction = Instruction(**data.dict())
    db.add(instruction)
    db.commit()  # Blocking call!
    return instruction
```

### Pydantic Schemas

```python
from pydantic import BaseModel, Field, ConfigDict

class InstructionCreate(BaseModel):
    """Create instruction request"""
    name: str = Field(..., min_length=1, max_length=200)
    description: str | None = None
    company_id: str

    model_config = ConfigDict(from_attributes=True)

class InstructionResponse(InstructionCreate):
    """Instruction response with generated fields"""
    id: str
    created_at: datetime
    updated_at: datetime
```

## Naming Conventions

### TypeScript/React

```typescript
// Components: PascalCase
export function UserProfile() {}

// Hooks: camelCase with 'use' prefix
export function useAuth() {}

// Constants: UPPER_SNAKE_CASE
export const API_BASE_URL = 'http://localhost:8000';

// Functions/Variables: camelCase
const getUserName = (user: User) => user.name;

// Types/Interfaces: PascalCase
interface UserProfile {}
type UserRole = 'admin' | 'user';

// Files: Match export name
UserProfile.tsx
useAuth.ts
api.ts
```

### Python

```python
# Classes: PascalCase
class UserService:
    pass

# Functions/Variables: snake_case
def get_user_by_email(email: str) -> User | None:
    pass

# Constants: UPPER_SNAKE_CASE
MAX_LOGIN_ATTEMPTS = 5

# Private: Leading underscore
def _internal_helper():
    pass

# Files: snake_case
user_service.py
auth_middleware.py
```

## Code Organization

### React Component Structure

```typescript
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui';

interface LoginFormProps {
  onSuccess: (token: string) => void;
}

export function LoginForm({ onSuccess }: LoginFormProps) {
  // 1. Hooks (order: context, state, effects, custom)
  const { t } = useTranslation();
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);

  // 2. Event handlers
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    // ...
  };

  // 3. Derived state / memoization
  const isValid = email.length > 0;

  // 4. Render
  return (
    <form onSubmit={handleSubmit}>
      {/* JSX */}
    </form>
  );
}
```

### Python Module Structure

```python
"""Module docstring describing purpose"""

# 1. Standard library imports
from typing import Annotated
from datetime import datetime

# 2. Third-party imports
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

# 3. Local imports
from app.core.deps import get_db, get_current_user
from app.models.user import User
from app.schemas.instruction import InstructionCreate, InstructionResponse

# 4. Constants
ROUTER_PREFIX = "/api/v1/instructions"

# 5. Router/Blueprint
router = APIRouter(prefix=ROUTER_PREFIX)

# 6. Route handlers
@router.get("/")
async def list_instructions(
    db: Annotated[AsyncSession, Depends(get_db)],
    user: Annotated[User, Depends(get_current_user)]
):
    pass
```

## Comment Policy

### Minimal Comments

Code should be self-explanatory through:
- Clear naming
- Small functions (single responsibility)
- Type annotations

```typescript
// ❌ WRONG: Obvious comment
// Get user name
const name = user.name;

// ✅ CORRECT: No comment needed
const userName = user.name;

// ❌ WRONG: Comment explaining complex logic
// Check if user has admin role or owns the resource
if ((user.role === 'admin') || (resource.owner_id === user.id)) {}

// ✅ CORRECT: Extract to function
const canEditResource = (user: User, resource: Resource) => {
  return user.role === 'admin' || resource.owner_id === user.id;
};

if (canEditResource(user, resource)) {}
```

### When Comments Are Needed

```typescript
// ✅ CORRECT: Explain WHY, not WHAT
// Using 300ms debounce to balance UX and server load (measured optimal)
const debouncedSearch = useDebounceFn(search, 300);

// ✅ CORRECT: Document complex algorithms
/**
 * Converts frame number to pixel position using timeline zoom level.
 * Algorithm: Linear interpolation with min compression to prevent
 * extremely short clips from being invisible.
 */
function frameToPixels(frame: number, totalFrames: number): number {
  const MIN_PX_PER_FRAME = 0.5;
  // ...
}

// ✅ CORRECT: Mark technical debt
// TODO: Replace with WebSocket for real-time updates (Issue #123)
const pollData = () => setInterval(fetchData, 5000);
```

## Error Handling

### Frontend

```typescript
// ✅ CORRECT: Specific error handling
try {
  await api.createInstruction(data);
  toast.success(t('instruction.created'));
} catch (error) {
  if (error instanceof ValidationError) {
    setFieldErrors(error.fields);
  } else if (error instanceof PermissionError) {
    toast.error(t('errors.permission_denied'));
  } else {
    logger.error('Failed to create instruction', error);
    toast.error(t('errors.generic'));
  }
}

// ❌ WRONG: Silent failures
try {
  await api.createInstruction(data);
} catch {
  // Empty catch block
}
```

### Backend

```python
# ✅ CORRECT: Let FastAPI handle validation errors
@router.post("/")
async def create_instruction(data: InstructionCreate):
    # Pydantic validation happens automatically
    pass

# ✅ CORRECT: Specific error handling
from app.core.exceptions import PermissionDenied

async def delete_instruction(db: AsyncSession, user: User, id: str):
    instruction = await get_instruction(db, id)
    if not instruction:
        raise HTTPException(status_code=404, detail="Instruction not found")

    if instruction.company_id != user.company_id:
        raise PermissionDenied("Cannot delete instruction from different company")

    await db.delete(instruction)
    await db.commit()

# ❌ WRONG: Generic error handling
except Exception as e:
    print(e)  # Don't use print, use logger
```

## Testing Standards

### Test Organization

```typescript
// Feature.test.tsx
import { describe, it, expect } from 'vitest';
import { render, screen } from '@/test';
import { LoginForm } from './LoginForm';

describe('LoginForm', () => {
  describe('rendering', () => {
    it('displays email and password inputs', () => {
      render(<LoginForm onSuccess={() => {}} />);
      expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    });
  });

  describe('validation', () => {
    it('shows error for invalid email', async () => {
      // ...
    });
  });

  describe('submission', () => {
    it('calls onSuccess with token on valid submission', async () => {
      // ...
    });
  });
});
```

### Test Naming

```typescript
// ✅ CORRECT: Descriptive test names
it('disables submit button while loading', () => {});
it('redirects to dashboard after successful login', () => {});

// ❌ WRONG: Vague test names
it('works correctly', () => {});
it('test login', () => {});
```

## Git Commit Standards

### Conventional Commits

```bash
# Format: <type>(<scope>): <description>

# Types:
feat: Add new feature
fix: Fix bug
docs: Documentation changes
style: Code style changes (formatting)
refactor: Code refactoring
test: Add or update tests
chore: Build process, dependencies

# Examples:
feat(auth): add password reset functionality
fix(editor): prevent timeline overflow on long videos
docs(api): update authentication endpoints
refactor(video): extract playback logic to custom hook
test(instruction): add E2E test for create flow
```

### Commit Message Body

```
feat(timeline): add frame-accurate seeking

Implemented pixel-to-frame conversion with zoom level support.
Users can now click on timeline ruler to seek to exact frames.

Closes #45
```

## Code Review Checklist

Before marking code as complete:

- [ ] All tests pass (`npm run test && cd server && pytest`)
- [ ] Linting passes (`npm run lint && cd server && ruff check`)
- [ ] Type checking passes (`npm run typecheck && cd server && mypy`)
- [ ] No `any` types in TypeScript
- [ ] No `print()` statements in Python (use `logger`)
- [ ] All user-visible text in i18n files
- [ ] No pixel values in CSS (use rem/Tailwind)
- [ ] All icon buttons have `aria-label`
- [ ] Multi-tenant queries include `company_id` filter
- [ ] Secrets not hardcoded (use environment variables)

## Performance Guidelines

### Frontend

```typescript
// ✅ CORRECT: Memoize expensive computations
const sortedItems = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// ✅ CORRECT: Debounce user input
const debouncedSearch = useDebounceFn(search, 300);

// ❌ WRONG: Inline object in props (causes re-renders)
<Component style={{ margin: 10 }} />

// ✅ CORRECT: Extract to constant
const componentStyle = { margin: 10 };
<Component style={componentStyle} />
```

### Backend

```python
# ✅ CORRECT: Use select_in_loading to avoid N+1
stmt = select(Instruction).options(
    selectinload(Instruction.versions)
)

# ✅ CORRECT: Paginate all list endpoints
async def list_instructions(skip: int = 0, limit: int = 20):
    stmt = select(Instruction).offset(skip).limit(limit)

# ❌ WRONG: Loading entire table
async def list_all_instructions():
    stmt = select(Instruction)  # No limit!
```

## Security Checklist

- [ ] All API routes require authentication (except login/register)
- [ ] Permission checks before data access
- [ ] SQL injection prevented (SQLAlchemy parameterized queries)
- [ ] XSS prevented (React auto-escapes, no `dangerouslySetInnerHTML`)
- [ ] CSRF protection (SameSite cookies for session-based auth)
- [ ] Passwords hashed with Argon2
- [ ] JWT tokens validated and not stored in localStorage (use httpOnly cookies)
- [ ] Multi-tenant isolation enforced (`company_id` filtering)
- [ ] Rate limiting on authentication endpoints
- [ ] Environment secrets not committed to git
