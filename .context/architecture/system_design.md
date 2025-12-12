# System Design

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Client (React/Vite)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Features   │  │  Components  │  │   Services   │      │
│  │  (Business)  │  │     (UI)     │  │  (API Layer) │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                  │              │
│         └─────────────────┴──────────────────┘              │
│                           │                                 │
│                    HTTP/JSON (REST)                         │
│                           │                                 │
├───────────────────────────┼─────────────────────────────────┤
│                           ▼                                 │
│                    Server (FastAPI)                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │     API      │  │   Services   │  │    Models    │      │
│  │   (Routes)   │──│  (Business)  │──│ (SQLAlchemy) │      │
│  └──────────────┘  └──────────────┘  └──────┬───────┘      │
│                                              │              │
│                                              ▼              │
│                                      Database (SQLite/PG)   │
└─────────────────────────────────────────────────────────────┘
```

## Service Boundaries

### Client Responsibilities
- **Presentation**: UI rendering, user interactions
- **State Management**: Client-side cache (Zustand), optimistic updates
- **Validation**: Input validation (duplicates server validation)
- **Routing**: SPA navigation (React Router)
- **i18n**: Text translation, locale formatting

### Server Responsibilities
- **Authentication**: JWT issuance and validation
- **Authorization**: Permission checks on every protected route
- **Business Logic**: Data transformation, aggregation
- **Persistence**: Database operations via ORM
- **Validation**: Canonical source of truth (Pydantic)

## API Design Principles

### RESTful Conventions

```
GET    /api/v1/instructions          # List (with filtering)
POST   /api/v1/instructions          # Create
GET    /api/v1/instructions/{id}     # Read one
PATCH  /api/v1/instructions/{id}     # Partial update
DELETE /api/v1/instructions/{id}     # Delete
```

### Request/Response Format

**Request:**
```json
{
  "name": "Assembly Process A",
  "description": "Manufacturing workflow",
  "company_id": "company-uuid"
}
```

**Success Response (200/201):**
```json
{
  "id": "instruction-uuid",
  "name": "Assembly Process A",
  "created_at": "2025-01-15T10:30:00Z"
}
```

**Error Response (4xx/5xx):**
```json
{
  "detail": "Resource not found",
  "error_code": "INSTRUCTION_NOT_FOUND"
}
```

### Pagination

```typescript
GET /api/v1/instructions?skip=0&limit=20

Response:
{
  "items": [...],
  "total": 150,
  "skip": 0,
  "limit": 20
}
```

## Data Flow Patterns

### 1. Read Operation
```
User Action → API Call → Auth Check → Permission Check → DB Query → Response → UI Update
```

### 2. Write Operation
```
User Input → Client Validation → API Call → Auth Check → Permission Check →
→ Server Validation → DB Transaction → Response → Cache Update → UI Update
```

### 3. Optimistic Update
```
User Action → UI Update (optimistic) → API Call → On Success: Confirm → On Error: Rollback
```

## Critical API Routes

### Authentication
```
POST /api/v1/auth/login           # Returns JWT token
POST /api/v1/auth/register        # User signup
POST /api/v1/auth/refresh         # Refresh token
GET  /api/v1/auth/me              # Current user profile
```

### Instructions (Multi-Tenant)
```
GET    /api/v1/instructions                    # List (filtered by company)
POST   /api/v1/instructions                    # Create
GET    /api/v1/instructions/{id}               # Read (check company isolation)
PATCH  /api/v1/instructions/{id}               # Update (check permissions)
DELETE /api/v1/instructions/{id}               # Soft delete
GET    /api/v1/instructions/{id}/versions      # Version history
```

### Permissions
```
GET  /api/v1/permissions/me                    # User's permissions
POST /api/v1/permissions/check                 # Validate permission
```

## Multi-Tenant Isolation

**Critical**: All database queries MUST enforce `company_id` filtering.

```python
# CORRECT: Automatic company filtering
async def get_instruction(db: AsyncSession, user: User, instruction_id: str):
    stmt = select(Instruction).where(
        Instruction.id == instruction_id,
        Instruction.company_id == user.company_id  # REQUIRED
    )
    result = await db.execute(stmt)
    return result.scalar_one_or_none()

# WRONG: Missing company filter (data leak!)
async def get_instruction_UNSAFE(db: AsyncSession, instruction_id: str):
    stmt = select(Instruction).where(Instruction.id == instruction_id)
    # Missing company_id check - SECURITY VULNERABILITY
    result = await db.execute(stmt)
    return result.scalar_one_or_none()
```

## Error Handling

### Backend Error Types

```python
from fastapi import HTTPException

# 400 - Validation Error
raise HTTPException(status_code=400, detail="Invalid input data")

# 401 - Authentication Failed
raise HTTPException(status_code=401, detail="Invalid credentials")

# 403 - Permission Denied
raise HTTPException(status_code=403, detail="Insufficient permissions")

# 404 - Resource Not Found
raise HTTPException(status_code=404, detail="Instruction not found")

# 409 - Conflict
raise HTTPException(status_code=409, detail="Resource already exists")

# 500 - Internal Server Error (logged, not exposed)
# Log the error, return generic message
```

### Frontend Error Display

```typescript
try {
  await instructionService.create(data);
} catch (error) {
  if (error.status === 403) {
    toast.error(t('errors.permission_denied'));
  } else if (error.status === 422) {
    // Show validation errors
    setErrors(error.detail);
  } else {
    toast.error(t('errors.generic'));
  }
}
```

## Performance Considerations

### Database Queries
- Use `select_in_loading` for relationships to avoid N+1 queries
- Index foreign keys and frequently queried columns
- Paginate all list endpoints (default: 20 items)

### Frontend Optimization
- Code splitting by route (`React.lazy()`)
- Memoize expensive computations (`useMemo`, `useCallback`)
- Virtualize long lists (react-window)
- Debounce search inputs (300ms)

### API Response Times
- Target: <100ms for simple queries
- Target: <500ms for complex operations
- Use async/await consistently for I/O operations

## Security Architecture

### Authentication Flow

```
1. User submits credentials → POST /auth/login
2. Server validates → Argon2 password verification
3. Generate JWT (exp: 24h) → { user_id, company_id, permissions }
4. Client stores token → localStorage (with XSS mitigation)
5. Subsequent requests → Authorization: Bearer <token>
6. Server validates → JWT signature + expiration check
```

### Permission System

Format: `{resource}:{action}:{resource_id}`

```python
# Examples
"instruction:read:*"              # Read all instructions
"instruction:write:inst-123"      # Edit specific instruction
"user:admin:*"                    # Admin all users
"*:*:*"                           # Super admin (dangerous!)
```

### CORS Configuration

```python
# server/app/config.py
cors_origins = [
    "http://localhost:5173",  # Vite dev server
    "http://localhost:5174",  # Alternative port
    "https://app.montavis.tech"  # Production
]
```

## WebSocket Support (Future)

Planned for real-time collaboration:

```
WS /api/v1/ws/instruction/{id}

Events:
- user_joined
- user_left
- cursor_moved
- content_updated
```

## API Versioning

Current: `/api/v1/`

Breaking changes require new version:
- `/api/v2/` with gradual migration
- Maintain v1 for 6 months minimum
- Document migration guide
