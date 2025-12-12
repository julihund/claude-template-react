# Coding Standards

## Self-Documenting Code Philosophy

**Code should be understandable without comments.** Use descriptive names that reveal intent. Comments are a last resort, not a first choice.

### When to Use Comments
✅ **Do use comments for**:
- Complex algorithms that aren't obvious
- Non-obvious business logic or domain rules
- Workarounds for bugs or limitations
- TODOs with context
- Public API documentation (JSDoc, docstrings)

❌ **Don't use comments for**:
- Explaining what code does (make the code clearer instead)
- Redundant information that's obvious from the code
- Commented-out code (delete it, use git history)
- Noise like `// Constructor` or `// End of function`

### Example: Bad vs Good

❌ **Bad** (needs comments to explain):
```typescript
// Get user data
function getData(id: number) {
  // Call API
  const res = await fetch(`/api/users/${id}`);
  // Parse response
  const data = await res.json();
  // Return user
  return data;
}
```

✅ **Good** (self-documenting):
```typescript
async function fetchUserProfileById(userId: number): Promise<UserProfile> {
  const response = await fetch(`/api/users/${userId}`);
  const userProfile = await response.json();
  return userProfile;
}
```

## Naming Conventions by Language

### TypeScript / JavaScript / React

#### Variables & Functions: `camelCase`
```typescript
const userProfile = getUserProfile();
const isAuthenticated = checkAuthStatus();
const totalOrderCount = calculateTotalOrders();

function validateEmailFormat(email: string): boolean { ... }
function handleSubmitLoginForm(event: FormEvent): void { ... }
```

#### Components & Classes: `PascalCase`
```typescript
function UserProfileCard({ user }: UserProfileCardProps) { ... }
class AuthenticationService { ... }
interface OrderValidationResult { ... }
type PaymentMethodType = 'card' | 'paypal';
```

#### Constants: `UPPER_SNAKE_CASE`
```typescript
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.example.com';
const DEFAULT_TIMEOUT_MS = 5000;
```

#### Private Methods: Prefix with `_` (optional but recommended)
```typescript
class DataService {
  private _cacheData(key: string, data: unknown): void { ... }
  private _validateInput(input: string): boolean { ... }
}
```

### Python / FastAPI

#### Variables & Functions: `snake_case`
```python
user_profile = get_user_profile()
is_authenticated = check_auth_status()
total_order_count = calculate_total_orders()

def validate_email_format(email: str) -> bool: ...
def handle_submit_login_form(form_data: LoginForm) -> None: ...
```

#### Classes: `PascalCase`
```python
class UserProfileService: ...
class AuthenticationMiddleware: ...
class OrderRepository: ...
```

#### Constants: `UPPER_SNAKE_CASE`
```python
MAX_RETRY_ATTEMPTS = 3
API_BASE_URL = "https://api.example.com"
DEFAULT_TIMEOUT_MS = 5000
```

#### Private Methods: Prefix with `_`
```python
class DataService:
    def _cache_data(self, key: str, data: Any) -> None: ...
    def _validate_input(self, input_str: str) -> bool: ...
```

## Descriptive Naming Examples

### ❌ Bad: Vague, Generic Names
```typescript
function fetchData() { ... }              // What data?
function handleClick() { ... }            // Handle what action?
const tmp = getUserId();                  // Temporary what?
const data = await getResponse();         // What kind of data?
const flag = checkStatus();               // What flag? What status?
const arr = getItems();                   // Array of what?
```

### ✅ Good: Specific, Intent-Revealing Names
```typescript
function fetchUserProfileById(userId: number) { ... }
function handleSubmitLoginForm(event: FormEvent) { ... }
const unverifiedUserId = getUserId();
const authenticatedUser = await getAuthenticatedUser();
const isEmailVerified = checkEmailVerificationStatus();
const unprocessedOrders = getUnprocessedOrders();
```

### ❌ Bad: Ambiguous Boolean Names
```python
is_valid = check()                        # Valid what?
flag = True                               # What flag?
status = get_status()                     # Boolean or string?
```

### ✅ Good: Clear Boolean Names (is_, has_, can_, should_)
```python
is_email_verified = check_email_verification()
has_admin_privileges = user.check_admin_role()
can_access_dashboard = check_dashboard_permission()
should_send_notification = determine_notification_eligibility()
```

### ❌ Bad: Abbreviations and Single Letters
```typescript
const usr = getUser();                    // usr?
const ord = getOrder();                   // ord?
const qty = getQuantity();                // qty?
for (let i of users) { ... }              // i is confusing for objects
```

### ✅ Good: Full Words
```typescript
const authenticatedUser = getAuthenticatedUser();
const pendingOrder = getPendingOrder();
const availableQuantity = getAvailableQuantity();
for (const user of users) { ... }
```

## File Structure Conventions

### React (TypeScript)
```
src/
├── components/
│   ├── ui/                      # Reusable primitives
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   └── Card.tsx
│   └── features/                # Feature-specific components
│       ├── UserProfile.tsx
│       └── OrderList.tsx
├── hooks/                       # Custom hooks
│   ├── useAuth.ts
│   └── useOfflineSync.ts
├── lib/                         # Utility libraries
│   ├── api/
│   ├── db/
│   └── utils/
├── types/                       # TypeScript type definitions
│   ├── user.ts
│   └── order.ts
└── pages/                       # Page components
    ├── HomePage.tsx
    └── DashboardPage.tsx
```

### FastAPI (Python)
```
app/
├── api/
│   ├── routes/                  # API endpoints
│   │   ├── auth.py
│   │   └── users.py
│   └── deps.py                  # Dependencies (DB sessions, auth)
├── core/
│   ├── config.py                # Settings and configuration
│   ├── security.py              # JWT, password hashing
│   └── database.py              # DB connection
├── models/                      # SQLAlchemy models
│   ├── user.py
│   └── order.py
├── schemas/                     # Pydantic schemas
│   ├── user.py
│   └── order.py
├── services/                    # Business logic
│   ├── auth_service.py
│   └── order_service.py
└── tests/                       # Test files
    ├── test_auth.py
    └── test_orders.py
```

## Import Organization

### React (TypeScript)
Group imports in this order:
1. External libraries (React, third-party)
2. Internal modules (lib, utils)
3. Relative imports (components, types)
4. Styles (CSS, SCSS)

```typescript
// 1. External libraries
import { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';

// 2. Internal modules
import { api } from '@/lib/api';
import { formatDate } from '@/lib/utils';

// 3. Relative imports
import { Button } from './Button';
import type { UserProfile } from '../types/user';

// 4. Styles
import './UserProfileCard.css';
```

### Python
Group imports in this order:
1. Standard library
2. Third-party packages
3. Local application imports

```python
# 1. Standard library
from datetime import datetime
from typing import Optional

# 2. Third-party packages
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

# 3. Local application imports
from app.core.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserResponse
```

## Clean Code Principles

### SOLID Principles

#### Single Responsibility Principle
❌ **Bad** (does too much):
```typescript
class UserManager {
  validateUser(user: User) { ... }
  saveToDatabase(user: User) { ... }
  sendEmail(user: User) { ... }
  generateReport(user: User) { ... }
}
```

✅ **Good** (single responsibility):
```typescript
class UserValidator {
  validate(user: User): ValidationResult { ... }
}

class UserRepository {
  save(user: User): Promise<void> { ... }
}

class EmailService {
  sendWelcomeEmail(user: User): Promise<void> { ... }
}
```

#### Dependency Inversion
❌ **Bad** (tightly coupled):
```python
class OrderService:
    def __init__(self):
        self.db = PostgreSQLDatabase()  # Hard-coded dependency
```

✅ **Good** (depends on abstraction):
```python
class OrderService:
    def __init__(self, database: Database):  # Injected dependency
        self.database = database
```

### DRY (Don't Repeat Yourself)

❌ **Bad** (repetition):
```typescript
function getActiveUsers() {
  return users.filter(user => user.status === 'active' && user.verified === true);
}

function getActiveAdmins() {
  return admins.filter(admin => admin.status === 'active' && admin.verified === true);
}
```

✅ **Good** (extracted logic):
```typescript
function isActiveAndVerified(user: User | Admin): boolean {
  return user.status === 'active' && user.verified === true;
}

function getActiveUsers() {
  return users.filter(isActiveAndVerified);
}

function getActiveAdmins() {
  return admins.filter(isActiveAndVerified);
}
```

### KISS (Keep It Simple, Stupid)

❌ **Bad** (over-engineered):
```typescript
class AbstractFactoryPatternBasedUserServiceProviderFactory {
  createUserServiceProvider(): IUserServiceProvider { ... }
}
```

✅ **Good** (simple):
```typescript
function createUserService(): UserService {
  return new UserService();
}
```

## Type Safety

### TypeScript
Always use strict mode and explicit types:

```typescript
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

❌ **Bad**:
```typescript
function processData(data: any) {  // Don't use 'any'
  return data.value;
}
```

✅ **Good**:
```typescript
interface ProcessableData {
  value: string;
  metadata?: Record<string, unknown>;
}

function processData(data: ProcessableData): string {
  return data.value;
}
```

### Python
Use type hints everywhere (Python 3.11+):

❌ **Bad**:
```python
def process_order(order, user):  # No type hints
    return order.total
```

✅ **Good**:
```python
def process_order(order: Order, user: User) -> Decimal:
    return order.total
```

## Error Handling

### React (TypeScript)
```typescript
// Use Result pattern or throw meaningful errors
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };

async function fetchUserProfile(userId: number): Promise<Result<UserProfile>> {
  try {
    const response = await fetch(`/api/users/${userId}`);

    if (!response.ok) {
      return { ok: false, error: new Error(`HTTP ${response.status}`) };
    }

    const userProfile = await response.json();
    return { ok: true, value: userProfile };
  } catch (error) {
    return { ok: false, error: error as Error };
  }
}
```

### Python (FastAPI)
```python
from fastapi import HTTPException, status

async def get_user_by_id(user_id: int, db: Session) -> User:
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with ID {user_id} not found"
        )

    return user
```

## Using Context7 for Up-to-Date Documentation

When working with external libraries, use **Context7 MCP** to get current, version-specific documentation:

```
# In your prompt, add:
"use context7 to get latest OpenAI API docs"
"use context7 for Pydantic v2 examples"
"use context7 for Tailwind CSS utilities"
```

Context7 provides:
- ✅ Up-to-date documentation for 20,000+ libraries
- ✅ Version-specific code examples
- ✅ Eliminates hallucinated/deprecated APIs
- ✅ Works for: React, FastAPI, Pydantic, Stripe, OpenAI, Tailwind, etc.

Example:
```typescript
// Instead of using outdated patterns, use context7:
// "use context7 for React 18 best practices"

// Context7 will provide current recommendations like:
import { useTransition } from 'react'; // React 18 feature
```

## Summary

1. **Self-documenting code**: Names should reveal intent, avoid comments
2. **Naming conventions**: camelCase (TS), snake_case (Python), PascalCase (classes/components), UPPER_SNAKE_CASE (constants)
3. **Descriptive names**: Be specific, avoid abbreviations, use full words
4. **File structure**: Organized by feature/domain, clear hierarchy
5. **Import organization**: External → internal → relative → styles
6. **Clean code**: SOLID, DRY, KISS principles
7. **Type safety**: Strict TypeScript, type hints in Python
8. **Error handling**: Meaningful errors, graceful degradation
9. **Context7**: Use "use context7" for up-to-date library documentation
