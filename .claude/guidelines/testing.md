# Testing Guidelines

## TDD (Test-Driven Development) Workflow

### The Red-Green-Refactor Cycle

1. **🔴 RED**: Write a failing test
2. **🟢 GREEN**: Write minimum code to make test pass
3. **🔵 REFACTOR**: Clean up code while keeping tests green

### Example: TDD for a Button Component

#### Step 1: 🔴 Write Failing Test

```typescript
// Button.test.tsx
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument();
  });
});
```

Run test: ❌ **FAILS** (Button component doesn't exist yet)

#### Step 2: 🟢 Write Minimum Code

```typescript
// Button.tsx
export function Button({ children }: { children: React.ReactNode }) {
  return <button>{children}</button>;
}
```

Run test: ✅ **PASSES**

#### Step 3: 🔴 Add More Requirements

```typescript
// Button.test.tsx
it('applies primary variant styles', () => {
  render(<Button variant="primary">Click me</Button>);
  const button = screen.getByRole('button');
  expect(button).toHaveClass('bg-primary');
});
```

Run test: ❌ **FAILS**

#### Step 4: 🟢 Implement Feature

```typescript
// Button.tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary';
  children: React.ReactNode;
}

export function Button({ variant = 'primary', children }: ButtonProps) {
  return (
    <button className={variant === 'primary' ? 'bg-primary' : 'bg-secondary'}>
      {children}
    </button>
  );
}
```

Run test: ✅ **PASSES**

#### Step 5: 🔵 Refactor

```typescript
// Button.tsx (refactored)
const VARIANT_STYLES = {
  primary: 'bg-primary hover:bg-primary-hover',
  secondary: 'bg-secondary hover:bg-secondary-hover',
} as const;

export function Button({ variant = 'primary', children }: ButtonProps) {
  return (
    <button className={`px-4 py-2 rounded-md ${VARIANT_STYLES[variant]}`}>
      {children}
    </button>
  );
}
```

Run test: ✅ **Still PASSES** (refactoring didn't break anything)

## Testing Pyramid

```
        /\
       /E2E\        10% - Slow, expensive, high confidence
      /------\
     /  Integ \     20% - Moderate speed, integration points
    /----------\
   /    Unit    \   70% - Fast, cheap, low-level
  /--------------\
```

### Unit Tests (70%)
- Test individual functions/components in isolation
- Fast execution (milliseconds)
- Use Vitest + React Testing Library

### Integration Tests (20%)
- Test multiple components/modules working together
- Moderate speed (seconds)
- Test API integration, data flow

### E2E Tests (10%)
- Test complete user workflows
- Slow execution (minutes)
- Use Playwright for browser automation

## Frontend Testing (Vitest + React Testing Library)

### Vitest Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './src/test/setup.ts',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: ['**/*.test.{ts,tsx}', '**/test/**', '**/*.config.ts'],
    },
  },
});
```

```typescript
// src/test/setup.ts
import '@testing-library/jest-dom';
```

### Unit Test Examples

#### Testing Components

```typescript
// UserProfileCard.test.tsx
import { render, screen } from '@testing-library/react';
import { UserProfileCard } from './UserProfileCard';

describe('UserProfileCard', () => {
  const mockUser = {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
  };

  it('renders user information', () => {
    render(<UserProfileCard user={mockUser} />);

    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('shows loading state when user is null', () => {
    render(<UserProfileCard user={null} />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });
});
```

#### Testing User Interactions

```typescript
// LoginForm.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { LoginForm } from './LoginForm';

describe('LoginForm', () => {
  it('calls onSubmit with form data', async () => {
    const user = userEvent.setup();
    const handleSubmit = vi.fn();

    render(<LoginForm onSubmit={handleSubmit} />);

    await user.type(screen.getByLabelText(/email/i), 'test@example.com');
    await user.type(screen.getByLabelText(/password/i), 'password123');
    await user.click(screen.getByRole('button', { name: /login/i }));

    expect(handleSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123',
    });
  });

  it('shows validation errors for empty fields', async () => {
    const user = userEvent.setup();
    render(<LoginForm onSubmit={vi.fn()} />);

    await user.click(screen.getByRole('button', { name: /login/i }));

    expect(screen.getByText(/email is required/i)).toBeInTheDocument();
    expect(screen.getByText(/password is required/i)).toBeInTheDocument();
  });
});
```

#### Testing Custom Hooks

```typescript
// useAuth.test.ts
import { renderHook, act } from '@testing-library/react';
import { useAuth } from './useAuth';

describe('useAuth', () => {
  it('starts with no authenticated user', () => {
    const { result } = renderHook(() => useAuth());
    expect(result.current.user).toBeNull();
    expect(result.current.isAuthenticated).toBe(false);
  });

  it('logs in user successfully', async () => {
    const { result } = renderHook(() => useAuth());

    await act(async () => {
      await result.current.login('test@example.com', 'password123');
    });

    expect(result.current.isAuthenticated).toBe(true);
    expect(result.current.user).toEqual({ email: 'test@example.com' });
  });
});
```

### Mocking API Calls

```typescript
// api.test.ts
import { vi } from 'vitest';
import { fetchUserProfile } from './api';

global.fetch = vi.fn();

describe('fetchUserProfile', () => {
  afterEach(() => {
    vi.resetAllMocks();
  });

  it('fetches user profile successfully', async () => {
    const mockUser = { id: 1, name: 'John Doe' };

    (fetch as any).mockResolvedValueOnce({
      ok: true,
      json: async () => mockUser,
    });

    const result = await fetchUserProfile(1);

    expect(fetch).toHaveBeenCalledWith('/api/users/1');
    expect(result).toEqual({ ok: true, value: mockUser });
  });

  it('handles fetch errors', async () => {
    (fetch as any).mockResolvedValueOnce({
      ok: false,
      status: 404,
    });

    const result = await fetchUserProfile(999);

    expect(result.ok).toBe(false);
  });
});
```

## Backend Testing (pytest + FastAPI)

### pytest Configuration

```ini
# pytest.ini
[pytest]
testpaths = app/tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = -v --cov=app --cov-report=html --cov-report=term
```

### Testing API Endpoints

```python
# app/tests/test_users.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.main import app
from app.models.user import User

client = TestClient(app)

def test_create_user(db: Session):
    """Test creating a new user"""
    response = client.post(
        "/api/users",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "password123"
        }
    )

    assert response.status_code == 201
    data = response.json()
    assert data["username"] == "testuser"
    assert data["email"] == "test@example.com"
    assert "password" not in data  # Should not expose password

def test_get_user_by_id(db: Session):
    """Test retrieving user by ID"""
    # Create test user
    user = User(username="testuser", email="test@example.com")
    db.add(user)
    db.commit()

    response = client.get(f"/api/users/{user.id}")

    assert response.status_code == 200
    data = response.json()
    assert data["id"] == user.id
    assert data["username"] == "testuser"

def test_get_nonexistent_user():
    """Test 404 for non-existent user"""
    response = client.get("/api/users/999999")
    assert response.status_code == 404
```

### Testing with Database Fixtures

```python
# app/tests/conftest.py
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.database import Base, get_db
from app.main import app

# Use in-memory SQLite for tests
TEST_DATABASE_URL = "sqlite:///:memory:"

@pytest.fixture(scope="function")
def db():
    """Create a fresh database for each test"""
    engine = create_engine(TEST_DATABASE_URL, connect_args={"check_same_thread": False})
    TestSessionLocal = sessionmaker(bind=engine)

    Base.metadata.create_all(bind=engine)

    db = TestSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def client(db):
    """Test client with database override"""
    def override_get_db():
        try:
            yield db
        finally:
            pass

    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()
```

### Testing Authentication

```python
# app/tests/test_auth.py
def test_login_success(client, db):
    """Test successful login"""
    # Create user
    client.post("/api/users", json={
        "username": "testuser",
        "email": "test@example.com",
        "password": "password123"
    })

    # Login
    response = client.post("/api/auth/login", data={
        "username": "testuser",
        "password": "password123"
    })

    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"

def test_login_wrong_password(client, db):
    """Test login with wrong password"""
    client.post("/api/users", json={
        "username": "testuser",
        "email": "test@example.com",
        "password": "password123"
    })

    response = client.post("/api/auth/login", data={
        "username": "testuser",
        "password": "wrongpassword"
    })

    assert response.status_code == 401
```

## E2E Testing (Playwright)

### Playwright Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:5173',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:5173',
    reuseExistingServer: !process.env.CI,
  },
});
```

### E2E Test Examples

```typescript
// e2e/login.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Login Flow', () => {
  test('successful login redirects to dashboard', async ({ page }) => {
    await page.goto('/login');

    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'password123');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toContainText('Dashboard');
  });

  test('shows error for invalid credentials', async ({ page }) => {
    await page.goto('/login');

    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'wrongpassword');
    await page.click('button[type="submit"]');

    await expect(page.locator('[role="alert"]')).toContainText(
      'Invalid credentials'
    );
  });
});
```

## Coverage Requirements

Aim for **80%+ code coverage**, but prioritize meaningful tests over coverage numbers.

```bash
# Frontend coverage
npm run test -- --coverage

# Backend coverage
pytest --cov=app --cov-report=html
```

## Summary

1. **TDD workflow**: Red → Green → Refactor
2. **Testing pyramid**: 70% unit, 20% integration, 10% E2E
3. **Vitest**: Frontend unit tests with React Testing Library
4. **pytest**: Backend tests with TestClient and database fixtures
5. **Playwright**: E2E tests for critical user flows
6. **Coverage**: 80%+ target, but quality over quantity
7. **Mocking**: Use vi.fn() (Vitest), TestClient (FastAPI)
8. **CI/CD**: Run all tests on PR, fail build if tests fail
