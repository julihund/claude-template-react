# Backend API Contracts

## API Design Principles

1. **RESTful**: Resources as nouns, HTTP methods as verbs
2. **Versioned**: `/api/v1/` prefix for all endpoints
3. **Consistent**: Standard response formats across all endpoints
4. **Secure**: Authentication required by default
5. **Validated**: Pydantic schemas for all request/response data

## Authentication

### JWT Token Structure

```json
{
  "user_id": "uuid-string",
  "company_id": "uuid-string",
  "email": "user@example.com",
  "exp": 1705334400,
  "iat": 1705248000
}
```

### Headers

```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
Accept: application/json
```

## Standard Response Formats

### Success Response

```json
// Single resource (200 OK, 201 Created)
{
  "id": "abc123",
  "name": "Resource Name",
  "created_at": "2025-01-15T10:30:00Z"
}

// List resource (200 OK)
{
  "items": [...],
  "total": 150,
  "skip": 0,
  "limit": 20
}
```

### Error Response

```json
{
  "detail": "Human-readable error message",
  "error_code": "SNAKE_CASE_CODE",
  "field_errors": {
    "email": "Invalid email format"
  }
}
```

### Error Codes

| HTTP | Error Code | Usage |
|------|-----------|-------|
| 400 | `VALIDATION_ERROR` | Invalid request data |
| 401 | `AUTHENTICATION_FAILED` | Invalid or missing token |
| 403 | `PERMISSION_DENIED` | User lacks required permission |
| 404 | `RESOURCE_NOT_FOUND` | Resource doesn't exist |
| 409 | `RESOURCE_CONFLICT` | Duplicate resource |
| 422 | `UNPROCESSABLE_ENTITY` | Validation failed (Pydantic) |
| 500 | `INTERNAL_ERROR` | Server error (logged) |

## Core Endpoints

### Authentication

#### POST /api/v1/auth/register

Create new user account.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "company_name": "Acme Corp"
}
```

**Response (201 Created):**
```json
{
  "user": {
    "id": "user-uuid",
    "email": "user@example.com",
    "company_id": "company-uuid"
  },
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "token_type": "bearer"
}
```

**Errors:**
- 409: Email already exists
- 422: Password too weak

---

#### POST /api/v1/auth/login

Authenticate user and receive JWT token.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "token_type": "bearer",
  "expires_in": 86400
}
```

**Errors:**
- 401: Invalid credentials
- 429: Too many login attempts (rate limited)

---

#### GET /api/v1/auth/me

Get current user profile.

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "id": "user-uuid",
  "email": "user@example.com",
  "company_id": "company-uuid",
  "permissions": [
    "instruction:read:*",
    "instruction:write:*"
  ]
}
```

**Errors:**
- 401: Invalid/expired token

---

### Instructions

#### GET /api/v1/instructions

List instructions (filtered by user's company).

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `skip` (int, default: 0) - Pagination offset
- `limit` (int, default: 20, max: 100) - Items per page
- `search` (string, optional) - Search by name

**Response (200 OK):**
```json
{
  "items": [
    {
      "id": "inst-uuid",
      "name": "Assembly Process A",
      "description": "Manufacturing workflow",
      "company_id": "company-uuid",
      "created_at": "2025-01-15T10:00:00Z",
      "updated_at": "2025-01-15T12:00:00Z"
    }
  ],
  "total": 5,
  "skip": 0,
  "limit": 20
}
```

---

#### POST /api/v1/instructions

Create new instruction.

**Headers:** `Authorization: Bearer <token>`

**Request:**
```json
{
  "name": "New Assembly Process",
  "description": "Optional description"
}
```

**Response (201 Created):**
```json
{
  "id": "inst-uuid",
  "name": "New Assembly Process",
  "description": "Optional description",
  "company_id": "company-uuid",
  "created_at": "2025-01-15T14:00:00Z",
  "updated_at": "2025-01-15T14:00:00Z"
}
```

**Errors:**
- 403: User lacks `instruction:write:*` permission
- 422: Name is required

---

#### GET /api/v1/instructions/{instruction_id}

Get single instruction (with company isolation check).

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "id": "inst-uuid",
  "name": "Assembly Process A",
  "description": "Manufacturing workflow",
  "company_id": "company-uuid",
  "created_at": "2025-01-15T10:00:00Z",
  "updated_at": "2025-01-15T12:00:00Z",
  "versions": [
    {
      "id": "ver-uuid",
      "version_number": 1,
      "status": "draft"
    }
  ]
}
```

**Errors:**
- 404: Instruction not found or belongs to different company
- 403: User lacks `instruction:read:{instruction_id}` permission

---

#### PATCH /api/v1/instructions/{instruction_id}

Partially update instruction.

**Headers:** `Authorization: Bearer <token>`

**Request:**
```json
{
  "name": "Updated Name",
  "description": "Updated description"
}
```

**Response (200 OK):**
```json
{
  "id": "inst-uuid",
  "name": "Updated Name",
  "description": "Updated description",
  "company_id": "company-uuid",
  "updated_at": "2025-01-15T15:00:00Z"
}
```

**Errors:**
- 404: Not found
- 403: Permission denied

---

#### DELETE /api/v1/instructions/{instruction_id}

Delete instruction (soft delete).

**Headers:** `Authorization: Bearer <token>`

**Response (204 No Content)**

**Errors:**
- 404: Not found
- 403: Permission denied

---

### Permissions

#### GET /api/v1/permissions/me

Get current user's permissions.

**Headers:** `Authorization: Bearer <token>`

**Response (200 OK):**
```json
{
  "permissions": [
    "instruction:read:*",
    "instruction:write:*",
    "user:read:*"
  ]
}
```

---

#### POST /api/v1/permissions/check

Validate if user has specific permission.

**Headers:** `Authorization: Bearer <token>`

**Request:**
```json
{
  "resource": "instruction",
  "action": "write",
  "resource_id": "inst-uuid"
}
```

**Response (200 OK):**
```json
{
  "allowed": true
}
```

---

### Health Check

#### GET /api/v1/health

Service health status (no auth required).

**Response (200 OK):**
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "database": "connected"
}
```

## Pydantic Schemas

### Base Schemas

```python
from pydantic import BaseModel, Field, EmailStr, ConfigDict
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    company_id: str | None = None

class UserCreate(UserBase):
    password: str = Field(..., min_length=8)
    company_name: str | None = None

class UserResponse(UserBase):
    id: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
```

### Instruction Schemas

```python
class InstructionBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    description: str | None = None

class InstructionCreate(InstructionBase):
    pass

class InstructionUpdate(BaseModel):
    name: str | None = Field(None, min_length=1, max_length=200)
    description: str | None = None

class InstructionResponse(InstructionBase):
    id: str
    company_id: str
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

class InstructionListResponse(BaseModel):
    items: list[InstructionResponse]
    total: int
    skip: int
    limit: int
```

## SQLAlchemy Models

### User Model

```python
from sqlalchemy import String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import Base, TimestampMixin, UUIDMixin

class User(Base, UUIDMixin, TimestampMixin):
    __tablename__ = "user"

    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255))
    company_id: Mapped[str] = mapped_column(ForeignKey("company.id"))

    # Relationships
    company: Mapped["Company"] = relationship(back_populates="users")
```

### Instruction Model

```python
class Instruction(Base, UUIDMixin, TimestampMixin):
    __tablename__ = "instruction"

    name: Mapped[str] = mapped_column(String(200))
    description: Mapped[str | None] = mapped_column(String(1000))
    company_id: Mapped[str] = mapped_column(ForeignKey("company.id"), index=True)

    # Relationships
    company: Mapped["Company"] = relationship(back_populates="instructions")
    versions: Mapped[list["Version"]] = relationship(back_populates="instruction")
```

## Permission System

### Permission Format

```
{resource}:{action}:{resource_id}

Examples:
  instruction:read:*           # Read all instructions
  instruction:write:abc123     # Write specific instruction
  user:admin:*                 # Admin all users
  *:*:*                        # Super admin
```

### Permission Check Function

```python
from app.core.permissions import check_permission

async def delete_instruction(
    db: AsyncSession,
    user: User,
    instruction_id: str
):
    # Check permission
    await check_permission(db, user, "instruction", "delete", instruction_id)

    # Permission granted, proceed
    instruction = await get_instruction(db, instruction_id)
    if not instruction:
        raise HTTPException(status_code=404)

    # Verify company isolation
    if instruction.company_id != user.company_id:
        raise HTTPException(status_code=403, detail="Cross-company access denied")

    await db.delete(instruction)
    await db.commit()
```

## Multi-Tenant Security

**CRITICAL**: All queries MUST filter by `company_id`.

```python
# ✅ CORRECT: Company-filtered query
async def list_instructions(db: AsyncSession, user: User):
    stmt = select(Instruction).where(
        Instruction.company_id == user.company_id
    )
    result = await db.execute(stmt)
    return result.scalars().all()

# ❌ WRONG: No company filter (SECURITY VULNERABILITY)
async def list_instructions_UNSAFE(db: AsyncSession):
    stmt = select(Instruction)  # Returns ALL companies' data!
    result = await db.execute(stmt)
    return result.scalars().all()
```

## Database Optimization

### N+1 Query Prevention

```python
from sqlalchemy.orm import selectinload

# ✅ CORRECT: Eager loading relationships
async def get_instruction_with_versions(db: AsyncSession, id: str):
    stmt = select(Instruction).where(Instruction.id == id).options(
        selectinload(Instruction.versions)
    )
    result = await db.execute(stmt)
    return result.scalar_one_or_none()

# ❌ WRONG: Lazy loading causes N+1
async def get_instruction(db: AsyncSession, id: str):
    stmt = select(Instruction).where(Instruction.id == id)
    result = await db.execute(stmt)
    instruction = result.scalar_one_or_none()
    # Accessing versions triggers additional query per version
    for version in instruction.versions:
        print(version.name)
```

### Indexing Strategy

```python
class Instruction(Base):
    __tablename__ = "instruction"

    # Primary key (automatic index)
    id: Mapped[str] = mapped_column(String(36), primary_key=True)

    # Foreign key (should be indexed)
    company_id: Mapped[str] = mapped_column(
        ForeignKey("company.id"),
        index=True  # ✅ Indexed for company filtering
    )

    # Searchable field (should be indexed)
    name: Mapped[str] = mapped_column(String(200), index=True)
```

## Rate Limiting

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@router.post("/auth/login")
@limiter.limit("5/minute")
async def login(request: Request, credentials: LoginRequest):
    # Login logic
    pass
```

## CORS Configuration

```python
# server/app/config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    cors_origins: list[str] = [
        "http://localhost:5173",  # Vite dev
        "http://localhost:5174",
        "https://app.montavis.tech"  # Production
    ]

# server/app/main.py
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## API Versioning Strategy

Current: `/api/v1/`

For breaking changes:
1. Create new version: `/api/v2/`
2. Maintain v1 for minimum 6 months
3. Add deprecation warnings to v1 responses
4. Document migration guide
5. Sunset v1 with advance notice
