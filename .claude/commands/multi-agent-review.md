# Multi-Agent Review

Coordinate comprehensive code review across multiple specialized agents for thorough quality assurance.

## What This Command Does

Orchestrates a coordinated review process using specialized subagents:
1. **python-api-expert**: Reviews backend code for scalability, security, async patterns
2. **react-ts-expert**: Reviews frontend code for design compliance, accessibility, type safety
3. **contract-tester**: Validates tests exist and pass, checks API contracts

Each agent provides domain-specific feedback in isolation, preventing context pollution.

## Usage

```
/multi-agent-review [target]
```

**Examples:**
```
/multi-agent-review                              # Review recent changes
/multi-agent-review features/auth                # Review auth feature
/multi-agent-review src/backend/app/api/users.py # Review specific file
```

## Implementation

### Step 1: Identify Changed Files

If no target specified, find recent changes:

```bash
# Get files changed in last commit
git diff --name-only HEAD~1 HEAD

# Or get uncommitted changes
git diff --name-only
```

### Step 2: Categorize Files

Separate frontend and backend files:

```bash
# Frontend files (client/)
# Backend files (server/)
# Tests (*.test.ts, test_*.py)
```

### Step 3: Launch Specialized Reviews (In Parallel)

Use the Task tool to launch agents in parallel for maximum efficiency:

**Backend Review** (python-api-expert):
```
Prompt: "Review the following backend files for:
- Async/await consistency
- Multi-tenant data isolation (company_id filtering)
- Permission checks before data access
- N+1 query prevention
- Proper error handling
- Security vulnerabilities

Files: [backend files list]

Provide:
1. Critical issues (security, data leaks, bugs)
2. Performance concerns
3. Code quality improvements
4. Compliance with .context/backend/api_contracts.md
"
```

**Frontend Review** (react-ts-expert):
```
Prompt: "Review the following frontend files for:
- TypeScript strict mode compliance (no 'any' types)
- Design system compliance (no pixel values, HSLA lightness system)
- Accessibility (aria-labels, keyboard navigation)
- i18n compliance (no hardcoded text)
- Feature-based imports (no deep imports)
- Performance patterns (memoization, code splitting)

Files: [frontend files list]

Provide:
1. Critical issues (accessibility, type safety)
2. Design system violations
3. Performance improvements
4. Compliance with .context/frontend/design_system.md
"
```

**Test Review** (contract-tester):
```
Prompt: "Review test coverage for the changed files:
- Do tests exist for all new functionality?
- Are tests comprehensive (happy path + edge cases + errors)?
- Do all tests pass?
- Are API contracts validated?
- Is multi-tenant isolation tested?

Files: [all changed files]

Provide:
1. Missing test coverage
2. Test failures
3. Recommended additional test cases
"
```

### Step 4: Aggregate Results

After all agents complete, consolidate feedback:

```
## Multi-Agent Review Summary

### Backend Review (python-api-expert)
[Agent feedback]

### Frontend Review (react-ts-expert)
[Agent feedback]

### Test Review (contract-tester)
[Agent feedback]

### Action Items
1. [Critical issue 1]
2. [Critical issue 2]
...

### Recommendations
- [Improvement 1]
- [Improvement 2]
...
```

## Review Checklist

### Backend
- [ ] All queries filter by `company_id` for multi-tenant isolation
- [ ] Permission checks before data access
- [ ] Async/await used consistently
- [ ] No N+1 queries (using `selectinload`)
- [ ] Pydantic validation on all inputs
- [ ] Proper error handling with appropriate HTTP status codes
- [ ] No secrets in code (use environment variables)
- [ ] Type annotations on all functions

### Frontend
- [ ] No `any` types in TypeScript
- [ ] No pixel values (use rem/Tailwind)
- [ ] All text in i18n files
- [ ] Barrel imports only (no deep imports)
- [ ] ARIA labels on icon buttons
- [ ] Keyboard accessibility
- [ ] HSLA lightness system for interactive states
- [ ] Performance optimizations (memoization)

### Tests
- [ ] Unit tests for business logic
- [ ] Integration tests for API endpoints
- [ ] E2E tests for critical user flows
- [ ] All tests pass
- [ ] Test coverage >80% for new code

## When to Use

**Use Before:**
- Committing significant changes
- Creating pull requests
- Merging to main branch
- Releasing to production

**Use After:**
- Implementing new features
- Refactoring existing code
- Fixing complex bugs
- Adding new API endpoints

## Output Format

The review provides structured feedback organized by severity:

**Critical** 🔴 - Must fix before commit:
- Security vulnerabilities
- Data leaks (missing company_id filtering)
- Type safety violations
- Accessibility blockers

**Major** 🟡 - Should fix soon:
- Performance issues
- Design system violations
- Missing tests
- Code quality concerns

**Minor** 🟢 - Nice to have:
- Documentation improvements
- Code style consistency
- Refactoring opportunities

## Follow-Up Actions

After receiving review:
1. Address all critical issues immediately
2. Create tickets for major issues
3. Consider minor improvements
4. Re-run `/multi-agent-review` to verify fixes
5. Run tests: `npm run test && cd server && pytest`
