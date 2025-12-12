Generate a project-specific CLAUDE.md file by analyzing the current codebase.

This command:
1. **Analyzes project structure**:
   - Reads package.json, requirements.txt, pyproject.toml
   - Identifies frontend/backend frameworks
   - Detects test frameworks and tools
   - Finds key directories

2. **Extracts project information**:
   - Project name and description
   - Build commands (scripts in package.json)
   - Test commands
   - Database configuration
   - Environment variables needed

3. **Generates minimal CLAUDE.md**:
   - What the app does (from README or package.json description)
   - Tech stack (detected frameworks)
   - Key directories (src/, app/, tests/)
   - Common commands (dev, build, test)
   - Current focus (empty, user fills in)

4. **Validates and saves**:
   - Ensures CLAUDE.md is concise (<50 lines)
   - Uses file:line references, not code snippets
   - Asks user to confirm before overwriting existing CLAUDE.md

Example: `/init` generates a starter CLAUDE.md for this project.

**Best practice**: Run this when starting a new project, then customize the "Current Focus" section as you work.
