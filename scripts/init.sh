#!/bin/bash

# MontaVis Template Initialization Script
# This script sets up the complete development environment

set -e  # Exit on error

echo "🚀 Initializing MontaVis Template..."
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check prerequisites
print_step "Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 20+ from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "❌ Node.js version must be 20 or higher. Current version: $(node --version)"
    exit 1
fi
print_success "Node.js $(node --version)"

# Check Python
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Python is not installed. Please install Python 3.12+ from https://python.org/"
    exit 1
fi

PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 12 ]); then
    print_warning "Python version should be 3.12+. Current version: $($PYTHON_CMD --version)"
    echo "Continuing anyway, but you may encounter issues..."
else
    print_success "Python $($PYTHON_CMD --version 2>&1)"
fi

echo ""

# Frontend setup
print_step "Installing frontend dependencies..."
if [ ! -d "client" ]; then
    echo "Creating client directory structure..."
    mkdir -p client/src
fi

cd client

if [ -f "package.json" ]; then
    npm install
    print_success "Frontend dependencies installed"
else
    print_warning "No package.json found. Skipping frontend setup."
    print_warning "You'll need to create the React project manually."
fi

cd ..
echo ""

# Backend setup
print_step "Setting up Python virtual environment..."
if [ ! -d "server" ]; then
    echo "Creating server directory structure..."
    mkdir -p server/app
fi

cd server

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    $PYTHON_CMD -m venv venv
    print_success "Virtual environment created"
else
    print_success "Virtual environment already exists"
fi

# Activate virtual environment
print_step "Activating virtual environment..."
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
elif [ -f "venv/Scripts/activate" ]; then
    source venv/Scripts/activate
else
    echo "❌ Could not find activation script"
    exit 1
fi

# Upgrade pip
print_step "Upgrading pip..."
pip install --upgrade pip --quiet

# Install backend dependencies
if [ -f "requirements.txt" ]; then
    print_step "Installing backend dependencies..."
    pip install -r requirements.txt --quiet
    print_success "Backend dependencies installed"
else
    print_warning "No requirements.txt found. Skipping backend dependency installation."
    print_warning "You'll need to create requirements.txt manually."
fi

# Database initialization
if [ -f "app/db_init.py" ] || [ -f "db_init.py" ]; then
    print_step "Initializing database with demo data..."
    if [ -f "app/db_init.py" ]; then
        $PYTHON_CMD -m app.db_init --demo
    else
        $PYTHON_CMD db_init.py --demo
    fi
    print_success "Database initialized"
else
    print_warning "No database initialization script found."
    print_warning "You'll need to set up the database manually."
fi

cd ..
echo ""

# Final summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_success "Setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Next steps:"
echo ""
echo "  1️⃣  Start the frontend dev server:"
echo "     ${BLUE}cd client && npm run dev${NC}"
echo ""
echo "  2️⃣  Start the backend API server (in new terminal):"
echo "     ${BLUE}cd server && source venv/bin/activate && uvicorn app.main:app --reload${NC}"
echo ""
echo "  3️⃣  Open your browser:"
echo "     ${BLUE}http://localhost:5173${NC} (Frontend)"
echo "     ${BLUE}http://localhost:8000/docs${NC} (API Docs)"
echo ""
echo "💡 Tips:"
echo "  - Use ${BLUE}/setup-project${NC} command in Claude Code to run this script"
echo "  - Use ${BLUE}/multi-agent-review${NC} before committing code"
echo "  - Run tests: ${BLUE}npm run test${NC} (frontend), ${BLUE}pytest${NC} (backend)"
echo ""
echo "📚 Documentation:"
echo "  - Project context: ${BLUE}.context/${NC}"
echo "  - Claude agents: ${BLUE}.claude/agents/${NC}"
echo "  - Slash commands: ${BLUE}.claude/commands/${NC}"
echo ""
