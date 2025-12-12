# Security Guidelines

## OWASP Top 10 Prevention

###  1. Injection (SQL, NoSQL, Command)

❌ **Bad** (vulnerable to SQL injection):
```python
# NEVER do this - vulnerable to SQL injection
user_id = request.get("user_id")
query = f"SELECT * FROM users WHERE id = {user_id}"
db.execute(query)
```

✅ **Good** (use ORM or parameterized queries):
```python
# Use SQLAlchemy ORM - safe from SQL injection
from sqlalchemy.orm import Session

def get_user_by_id(user_id: int, db: Session) -> Optional[User]:
    return db.query(User).filter(User.id == user_id).first()
```

### 2. Broken Authentication

❌ **Bad** (storing plaintext passwords):
```python
# NEVER store plaintext passwords
user = User(username=username, password=password)
db.add(user)
```

✅ **Good** (hash passwords with bcrypt):
```python
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_user(username: str, password: str, db: Session) -> User:
    hashed_password = pwd_context.hash(password)
    user = User(username=username, hashed_password=hashed_password)
    db.add(user)
    db.commit()
    return user

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)
```

### 3. Sensitive Data Exposure

❌ **Bad** (exposing sensitive data in API responses):
```python
@router.get("/users/{user_id}")
def get_user(user_id: int):
    user = db.query(User).filter(User.id == user_id).first()
    return user  # Exposes hashed_password, email_verified, etc.
```

✅ **Good** (use Pydantic schemas to control output):
```python
from pydantic import BaseModel

class UserResponse(BaseModel):
    id: int
    username: str
    email: str
    created_at: datetime

    class Config:
        from_attributes = True  # SQLAlchemy 2.0

@router.get("/users/{user_id}", response_model=UserResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user  # Pydantic automatically filters fields
```

### 4. XML External Entities (XXE)

Not applicable for React + FastAPI (JSON-based), but be cautious if parsing XML.

### 5. Broken Access Control

❌ **Bad** (no authorization check):
```python
@router.delete("/users/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    db.delete(user)  # Any authenticated user can delete any other user!
    db.commit()
```

✅ **Good** (check ownership or permissions):
```python
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> User:
    # Verify JWT and return current user
    ...

@router.delete("/users/{user_id}")
def delete_user(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if current_user.id != user_id and not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Not authorized")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    db.delete(user)
    db.commit()
```

### 6. Security Misconfiguration

❌ **Bad** (debug mode in production):
```python
# main.py
app = FastAPI(debug=True)  # NEVER in production!
```

✅ **Good** (environment-based configuration):
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    debug: bool = False
    secret_key: str
    database_url: str

    class Config:
        env_file = ".env"

settings = Settings()
app = FastAPI(debug=settings.debug)
```

### 7. Cross-Site Scripting (XSS)

React automatically escapes JSX content, but be careful with `dangerouslySetInnerHTML`:

❌ **Bad** (XSS vulnerability):
```typescript
function UserComment({ comment }: { comment: string }) {
  return <div dangerouslySetInnerHTML={{ __html: comment }} />;
}
```

✅ **Good** (use a sanitization library):
```typescript
import DOMPurify from 'dompurify';

function UserComment({ comment }: { comment: string }) {
  const sanitizedComment = DOMPurify.sanitize(comment);
  return <div dangerouslySetInnerHTML={{ __html: sanitizedComment }} />;
}
```

Or better, avoid `dangerouslySetInnerHTML`:
```typescript
function UserComment({ comment }: { comment: string }) {
  return <div>{comment}</div>;  // React auto-escapes
}
```

### 8. Insecure Deserialization

Use Pydantic for validation, don't use `pickle` or `eval`:

❌ **Bad**:
```python
import pickle
data = pickle.loads(request_data)  # Arbitrary code execution!
```

✅ **Good**:
```python
from pydantic import BaseModel

class UserInput(BaseModel):
    username: str
    email: EmailStr

@router.post("/users")
def create_user(user_data: UserInput, db: Session = Depends(get_db)):
    # Pydantic validates and sanitizes input
    user = User(**user_data.dict())
    db.add(user)
    db.commit()
```

### 9. Using Components with Known Vulnerabilities

Regularly update dependencies:

```bash
# Frontend
npm audit
npm audit fix

# Backend
pip list --outdated
pip install --upgrade package-name
```

Add to CI/CD:
```yaml
# .github/workflows/security.yml
- name: Run npm audit
  run: npm audit --audit-level=high

- name: Run safety check (Python)
  run: pip install safety && safety check
```

### 10. Insufficient Logging & Monitoring

❌ **Bad** (no logging):
```python
@router.post("/login")
def login(credentials: LoginCredentials):
    user = authenticate(credentials)
    return {"access_token": create_token(user)}
```

✅ **Good** (log security events):
```python
import logging

logger = logging.getLogger(__name__)

@router.post("/login")
def login(credentials: LoginCredentials):
    logger.info(f"Login attempt for user: {credentials.username}")

    user = authenticate(credentials)
    if not user:
        logger.warning(f"Failed login attempt for user: {credentials.username}")
        raise HTTPException(status_code=401, detail="Invalid credentials")

    logger.info(f"Successful login for user: {credentials.username}")
    return {"access_token": create_token(user)}
```

## FastAPI Security Best Practices

### JWT Authentication

✅ **Complete JWT implementation**:

```python
# app/core/security.py
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

SECRET_KEY = "your-secret-key-here"  # Use environment variable!
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise credentials_exception

    return user
```

### Input Validation with Pydantic

❌ **Bad** (no validation):
```python
@router.post("/users")
def create_user(request: Request):
    data = await request.json()
    email = data.get("email")  # Could be anything!
    age = data.get("age")      # Could be a string!
```

✅ **Good** (Pydantic validation):
```python
from pydantic import BaseModel, EmailStr, Field, validator

class UserCreate(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    email: EmailStr  # Validates email format
    age: int = Field(..., ge=13, le=120)  # 13 <= age <= 120
    password: str = Field(..., min_length=8)

    @validator('password')
    def password_strength(cls, v):
        if not any(char.isdigit() for char in v):
            raise ValueError('Password must contain at least one digit')
        if not any(char.isupper() for char in v):
            raise ValueError('Password must contain at least one uppercase letter')
        return v

@router.post("/users")
def create_user(user_data: UserCreate, db: Session = Depends(get_db)):
    # user_data is validated and type-safe
    ...
```

### CORS Configuration

❌ **Bad** (allowing all origins):
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # INSECURE!
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

✅ **Good** (specific origins):
```python
from fastapi.middleware.cors import CORSMiddleware

ALLOWED_ORIGINS = [
    "http://localhost:5173",  # Vite dev server
    "https://your-production-domain.com",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Content-Type", "Authorization"],
)
```

### Rate Limiting

```python
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

@router.post("/login")
@limiter.limit("5/minute")  # Max 5 login attempts per minute
async def login(request: Request, credentials: LoginCredentials):
    ...
```

### Secure Headers

```python
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from starlette.middleware.httpsredirect import HTTPSRedirectMiddleware

# Force HTTPS in production
if not settings.debug:
    app.add_middleware(HTTPSRedirectMiddleware)

# Prevent host header attacks
app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=["localhost", "your-domain.com"]
)

# Security headers
@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    return response
```

## Frontend Security (React)

### Secure API Calls

```typescript
// src/lib/api.ts
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

async function apiFetch<T>(
  endpoint: string,
  options?: RequestInit
): Promise<T> {
  const token = localStorage.getItem('access_token');

  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
      ...options?.headers,
    },
  });

  if (!response.ok) {
    if (response.status === 401) {
      // Token expired, redirect to login
      localStorage.removeItem('access_token');
      window.location.href = '/login';
    }
    throw new Error(`HTTP ${response.status}`);
  }

  return response.json();
}
```

### Content Security Policy

Add to `index.html`:

```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self' 'unsafe-inline';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  connect-src 'self' https://your-api-domain.com;
">
```

## Environment Variables

❌ **Bad** (committing secrets):
```typescript
// NEVER commit this!
const API_KEY = "sk_live_abc123...";
```

✅ **Good** (use environment variables):
```bash
# .env (add to .gitignore!)
VITE_API_BASE_URL=http://localhost:8000
DATABASE_URL=postgresql://user:pass@localhost/db
SECRET_KEY=your-secret-key-here
```

```typescript
// Access in React
const apiBaseUrl = import.meta.env.VITE_API_BASE_URL;
```

```python
# Access in FastAPI
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    secret_key: str

    class Config:
        env_file = ".env"

settings = Settings()
```

## Summary

1. **Prevent injection**: Use ORM (SQLAlchemy), never raw SQL with user input
2. **Authentication**: Hash passwords (bcrypt), use JWT tokens, implement refresh tokens
3. **Authorization**: Check permissions before sensitive operations
4. **Input validation**: Use Pydantic schemas with validators
5. **CORS**: Allow only specific origins, not `*`
6. **Rate limiting**: Prevent brute force attacks
7. **Secure headers**: X-Content-Type-Options, X-Frame-Options, HSTS
8. **Environment variables**: Never commit secrets, use `.env` files
9. **Logging**: Log security events (login attempts, failures, access denials)
10. **Regular updates**: `npm audit`, `safety check`, keep dependencies current
