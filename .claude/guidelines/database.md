# Database Guidelines

## SQLAlchemy 2.0 Async Patterns

### Model Definition

```python
# app/models/user.py
from datetime import datetime
from sqlalchemy import String, Boolean, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.core.database import Base

class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, index=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String(255))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    # Relationships
    orders: Mapped[list["Order"]] = relationship(back_populates="user")
```

### Relationships

```python
# app/models/order.py
from sqlalchemy import ForeignKey, Numeric
from sqlalchemy.orm import Mapped, mapped_column, relationship

class Order(Base):
    __tablename__ = "orders"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    total: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    status: Mapped[str] = mapped_column(String(20), default="pending")

    # Relationships
    user: Mapped["User"] = relationship(back_populates="orders")
    items: Mapped[list["OrderItem"]] = relationship(back_populates="order", cascade="all, delete-orphan")
```

### Async Database Session

```python
# app/core/database.py
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import declarative_base

DATABASE_URL = "sqlite+aiosqlite:///./app.db"  # Dev
# DATABASE_URL = "postgresql+asyncpg://user:pass@localhost/dbname"  # Prod

engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

Base = declarative_base()

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
```

### Async CRUD Operations

❌ **Bad** (synchronous):
```python
def get_user(user_id: int, db: Session):
    return db.query(User).filter(User.id == user_id).first()
```

✅ **Good** (async):
```python
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

async def get_user_by_id(user_id: int, db: AsyncSession) -> Optional[User]:
    result = await db.execute(select(User).filter(User.id == user_id))
    return result.scalar_one_or_none()

async def get_users_by_status(is_active: bool, db: AsyncSession) -> list[User]:
    result = await db.execute(select(User).filter(User.is_active == is_active))
    return list(result.scalars().all())

async def create_user(user_data: UserCreate, db: AsyncSession) -> User:
    user = User(**user_data.dict())
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user

async def update_user(user_id: int, user_data: UserUpdate, db: AsyncSession) -> Optional[User]:
    result = await db.execute(select(User).filter(User.id == user_id))
    user = result.scalar_one_or_none()

    if not user:
        return None

    for key, value in user_data.dict(exclude_unset=True).items():
        setattr(user, key, value)

    await db.commit()
    await db.refresh(user)
    return user

async def delete_user(user_id: int, db: AsyncSession) -> bool:
    result = await db.execute(select(User).filter(User.id == user_id))
    user = result.scalar_one_or_none()

    if not user:
        return False

    await db.delete(user)
    await db.commit()
    return True
```

### Eager Loading (Avoid N+1 Queries)

❌ **Bad** (N+1 problem):
```python
async def get_users_with_orders(db: AsyncSession):
    result = await db.execute(select(User))
    users = result.scalars().all()

    # This causes N additional queries!
    for user in users:
        print(user.orders)  # Lazy load for each user
```

✅ **Good** (eager loading):
```python
from sqlalchemy.orm import selectinload

async def get_users_with_orders(db: AsyncSession) -> list[User]:
    result = await db.execute(
        select(User).options(selectinload(User.orders))
    )
    return list(result.scalars().all())
```

## Database Migrations with Alembic

### Initialization

```bash
alembic init alembic
```

### Configure Alembic

```python
# alembic/env.py
from app.core.database import Base
from app.models import user, order  # Import all models

target_metadata = Base.metadata
```

### Create Migration

```bash
# Auto-generate migration from model changes
alembic revision --autogenerate -m "Add user table"

# Create empty migration
alembic revision -m "Add custom index"
```

### Migration Best Practices

✅ **Good migration**:
```python
# alembic/versions/xxx_add_user_email_index.py
from alembic import op
import sqlalchemy as sa

revision = 'xxx'
down_revision = 'yyy'

def upgrade():
    op.create_index(
        'ix_users_email',
        'users',
        ['email'],
        unique=True
    )

def downgrade():
    op.drop_index('ix_users_email', table_name='users')
```

### Apply Migrations

```bash
# Upgrade to latest
alembic upgrade head

# Downgrade one version
alembic downgrade -1

# Check current version
alembic current
```

### Migration Guidelines

1. **Always test migrations**: Run upgrade and downgrade locally before deploying
2. **Make migrations reversible**: Always implement both `upgrade()` and `downgrade()`
3. **Avoid data loss**: Be careful with DROP TABLE, DROP COLUMN
4. **Index important columns**: email, username, foreign keys
5. **Use transactions**: Alembic wraps each migration in a transaction by default

## Offline-First Sync Architecture

### Client-Side (SQLite in Browser)

```typescript
// src/lib/db/client.ts
import initSqlJs, { Database } from 'sql.js';

let db: Database | null = null;

export async function initDatabase(): Promise<Database> {
  const SQL = await initSqlJs({
    locateFile: (file) => `https://sql.js.org/dist/${file}`,
  });

  const savedDb = localStorage.getItem('app_database');

  if (savedDb) {
    const buffer = Uint8Array.from(atob(savedDb), c => c.charCodeAt(0));
    db = new SQL.Database(buffer);
  } else {
    db = new SQL.Database();
    createTables(db);
  }

  return db;
}

function createTables(db: Database) {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY,
      username TEXT NOT NULL,
      email TEXT NOT NULL,
      created_at TEXT NOT NULL,
      synced INTEGER DEFAULT 0
    );

    CREATE TABLE IF NOT EXISTS orders (
      id INTEGER PRIMARY KEY,
      user_id INTEGER NOT NULL,
      total REAL NOT NULL,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      synced INTEGER DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users(id)
    );
  `);
}

export function saveDatabase() {
  if (!db) return;

  const data = db.export();
  const buffer = Buffer.from(data);
  localStorage.setItem('app_database', buffer.toString('base64'));
}
```

### Sync Queue

```typescript
// src/lib/sync/queue.ts
interface SyncOperation {
  id: string;
  table: string;
  operation: 'INSERT' | 'UPDATE' | 'DELETE';
  data: Record<string, unknown>;
  timestamp: number;
}

export class SyncQueue {
  private queue: SyncOperation[] = [];

  addOperation(op: Omit<SyncOperation, 'id' | 'timestamp'>) {
    this.queue.push({
      ...op,
      id: crypto.randomUUID(),
      timestamp: Date.now(),
    });
    this.persistQueue();
  }

  private persistQueue() {
    localStorage.setItem('sync_queue', JSON.stringify(this.queue));
  }

  async syncWithServer(apiClient: ApiClient) {
    if (this.queue.length === 0) return;

    try {
      const response = await apiClient.post('/sync', {
        operations: this.queue,
      });

      // Clear synced operations
      this.queue = [];
      this.persistQueue();

      // Apply server changes to local database
      await this.applyServerChanges(response.data.changes);
    } catch (error) {
      console.error('Sync failed:', error);
      // Keep operations in queue for retry
    }
  }

  private async applyServerChanges(changes: any[]) {
    // Apply changes from server to local SQLite
    for (const change of changes) {
      // ... apply to local db
    }
    saveDatabase();
  }
}
```

### Server-Side Sync Endpoint

```python
# app/api/routes/sync.py
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db

router = APIRouter()

@router.post("/sync")
async def sync_data(
    sync_request: SyncRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    changes_applied = []
    conflicts = []

    for operation in sync_request.operations:
        try:
            if operation.operation == "INSERT":
                await handle_insert(operation, current_user, db)
            elif operation.operation == "UPDATE":
                await handle_update(operation, current_user, db)
            elif operation.operation == "DELETE":
                await handle_delete(operation, current_user, db)

            changes_applied.append(operation.id)
        except ConflictError as e:
            conflicts.append({
                "operation_id": operation.id,
                "reason": str(e)
            })

    await db.commit()

    # Get server changes since last sync
    server_changes = await get_server_changes_since(
        current_user.id,
        sync_request.last_sync_timestamp,
        db
    )

    return {
        "changes_applied": changes_applied,
        "conflicts": conflicts,
        "changes": server_changes
    }
```

### Conflict Resolution (Last-Write-Wins)

```python
async def handle_update(operation: SyncOperation, user: User, db: AsyncSession):
    result = await db.execute(
        select(Order).filter(Order.id == operation.data["id"])
    )
    existing_order = result.scalar_one_or_none()

    if not existing_order:
        raise NotFoundError(f"Order {operation.data['id']} not found")

    # Last-write-wins: compare timestamps
    if existing_order.updated_at > operation.timestamp:
        raise ConflictError(
            f"Server version is newer (server: {existing_order.updated_at}, "
            f"client: {operation.timestamp})"
        )

    # Apply update
    for key, value in operation.data.items():
        setattr(existing_order, key, value)

    existing_order.updated_at = datetime.utcnow()
```

## Data Validation

### Pydantic Schemas with Validators

```python
# app/schemas/user.py
from pydantic import BaseModel, EmailStr, Field, validator
from datetime import datetime

class UserCreate(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    email: EmailStr
    password: str = Field(..., min_length=8)

    @validator('username')
    def username_alphanumeric(cls, v):
        if not v.isalnum():
            raise ValueError('Username must be alphanumeric')
        return v.lower()

class UserUpdate(BaseModel):
    username: Optional[str] = Field(None, min_length=3, max_length=50)
    email: Optional[EmailStr] = None

class UserResponse(BaseModel):
    id: int
    username: str
    email: str
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True  # SQLAlchemy 2.0
```

## Index Optimization

### Creating Indexes

```python
# In model definition
class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)  # Index
    username: Mapped[str] = mapped_column(String(50), unique=True, index=True)  # Index

# Composite index via Alembic migration
def upgrade():
    op.create_index(
        'ix_orders_user_status',
        'orders',
        ['user_id', 'status']
    )
```

### When to Index

✅ **Index these columns**:
- Foreign keys (user_id, order_id)
- Columns used in WHERE clauses frequently (status, is_active)
- Columns used in ORDER BY (created_at)
- Unique constraints (email, username)

❌ **Don't index**:
- Columns with low cardinality (boolean fields, unless filtered often)
- Small tables (< 1000 rows)
- Columns that change frequently (write performance impact)

## Summary

1. **SQLAlchemy 2.0 async**: Use `Mapped[]`, `async def`, `await db.execute(select())`
2. **Eager loading**: Use `selectinload()` to avoid N+1 queries
3. **Migrations**: Always reversible, test locally, index important columns
4. **Offline sync**: Client SQLite → Sync queue → Server PostgreSQL
5. **Conflict resolution**: Last-write-wins, compare timestamps
6. **Validation**: Pydantic schemas with custom validators
7. **Indexing**: Foreign keys, WHERE columns, ORDER BY columns
8. **Database choice**: SQLite (dev), PostgreSQL (prod)
