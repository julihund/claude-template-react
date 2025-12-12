# Setup Project

Initialize the complete development environment for the MontaVis Template.

## What This Command Does

Executes the automated initialization script that:
1. Installs frontend dependencies (npm)
2. Sets up Python virtual environment
3. Installs backend dependencies (pip)
4. Initializes database with demo data
5. Verifies all tools are correctly installed

## Usage

```
/setup-project
```

## Implementation

Run the initialization script:

```bash
chmod +x ./scripts/init.sh
./scripts/init.sh
```

## Post-Setup Verification

After setup completes, verify everything works:

```bash
# Frontend health check
cd client && npm run typecheck && npm run lint

# Backend health check
cd server && python -m app.main  # Should start without errors

# Run quick test suite
cd client && npm run test:run
cd server && pytest -k "test_health"
```

## Expected Output

```
🚀 Initializing MontaVis Template...
📦 Installing frontend dependencies...
✅ Frontend ready

🐍 Setting up Python environment...
✅ Python environment ready

🗄️  Initializing database...
✅ Database initialized with demo data

✅ Setup complete!

Start development servers:
  Frontend: cd client && npm run dev
  Backend:  cd server && uvicorn app.main:app --reload
```

## Troubleshooting

### Frontend Issues
- **Node.js version**: Requires Node.js 20+
  ```bash
  node --version  # Should be v20.x or higher
  ```
- **npm install fails**: Try clearing cache
  ```bash
  cd client && rm -rf node_modules package-lock.json && npm install
  ```

### Backend Issues
- **Python version**: Requires Python 3.12+
  ```bash
  python --version  # Should be 3.12 or higher
  ```
- **venv activation fails**: Manually activate
  ```bash
  cd server && source venv/bin/activate  # Linux/Mac
  cd server && venv\Scripts\activate      # Windows
  ```
- **pip install fails**: Upgrade pip first
  ```bash
  python -m pip install --upgrade pip
  ```

### Database Issues
- **SQLite locked**: Close any DB browsers
- **Demo data fails**: Drop DB and retry
  ```bash
  rm server/montavis.db && python -m app.db_init --demo
  ```

## When to Use

- **First time setup**: Initial project clone
- **After git pull**: When dependencies change
- **Fresh start**: Reset development environment
- **Team onboarding**: New developer setup
