# Smart Debug

Intelligent error analysis using isolated subagents to prevent context pollution from large error logs.

## What This Command Does

Routes complex debugging tasks to specialized subagents who analyze errors in isolation and return concise root cause analysis. This prevents the main context from being flooded with lengthy stack traces and logs.

## Usage

```
/smart-debug [error description or file]
```

**Examples:**
```
/smart-debug "API returns 500 on login"
/smart-debug build error
/smart-debug test failures in video player
```

## Implementation

### Step 1: Gather Error Context

Collect relevant error information:

```bash
# For build errors
npm run build 2>&1 | tee build-error.log

# For test failures
npm run test:run 2>&1 | tee test-error.log
cd server && pytest 2>&1 | tee pytest-error.log

# For runtime errors
# Check browser console or server logs
```

### Step 2: Categorize Error Type

Determine which specialist agent should handle this:

| Error Type | Agent | Rationale |
|------------|-------|-----------|
| Build/TypeScript errors | react-ts-expert | Frontend compilation issues |
| Import/dependency errors | dependency-synchronizer | Package conflicts |
| API/Database errors | python-api-expert | Backend logic issues |
| Test failures | contract-tester | Test analysis and fixes |

### Step 3: Launch Isolated Debugging Session

Use Task tool to create isolated context with the specialized agent:

**For Frontend Errors:**
```
Agent: react-ts-expert
Prompt: "Analyze the following error and provide root cause analysis:

Error: [paste error message]

File(s) involved: [list files mentioned in error]

Please:
1. Identify the root cause
2. Explain why this error occurs
3. Provide exact fix with code example
4. Suggest how to prevent similar errors

Do NOT include the full error log in your response - only your analysis.
"
```

**For Backend Errors:**
```
Agent: python-api-expert
Prompt: "Analyze the following backend error:

Error: [paste error message]

Stack trace key points:
- File: [file:line]
- Function: [function name]
- Error type: [exception type]

Please:
1. Identify root cause
2. Check for common issues:
   - Missing await on async function?
   - Database connection issue?
   - Missing company_id filtering?
   - Permission check failure?
3. Provide exact fix
4. Suggest prevention strategy

Return concise analysis only.
"
```

**For Dependency Errors:**
```
Agent: dependency-synchronizer
Prompt: "Resolve the following dependency conflict:

Error: [paste dependency error]

Please:
1. Identify conflicting packages
2. Explain version incompatibility
3. Provide resolution strategy
4. Update package.json or requirements.txt as needed

Return only the fix, not the full error log.
"
```

**For Test Failures:**
```
Agent: contract-tester
Prompt: "Analyze why the following tests are failing:

Test failures: [paste test failure summary]

Please:
1. Categorize failures (setup issue, assertion failure, timeout, etc.)
2. Identify root cause for each category
3. Recommend fixes
4. Suggest additional test cases to prevent regression

Return analysis without repeating full test output.
"
```

### Step 4: Present Concise Analysis

The subagent returns distilled insights:

```
## Debug Analysis

### Root Cause
[Clear explanation of what's wrong]

### Why This Happens
[Technical explanation]

### Fix
'''language
[Exact code fix]
'''

### Prevention
[How to avoid this in the future]
```

## Common Error Patterns

### Frontend

**TypeScript Errors:**
- Type mismatch → Check interface definitions
- Cannot find module → Check import path or missing dependency
- Property doesn't exist → Update type definition

**Build Errors:**
- Syntax error → Check for incomplete refactor
- Module not found → Run `npm install`
- Out of memory → Increase `NODE_OPTIONS=--max-old-space-size=4096`

**Runtime Errors:**
- Undefined is not an object → Null check missing
- Cannot read property of null → Add optional chaining
- Maximum call stack → Infinite loop or recursion

### Backend

**Database Errors:**
- No such table → Run migrations: `alembic upgrade head`
- Connection refused → Start database server
- Unique constraint violation → Duplicate data

**FastAPI Errors:**
- 422 Unprocessable Entity → Pydantic validation failed
- 401 Unauthorized → Missing or invalid JWT token
- 403 Forbidden → Permission check failed
- 500 Internal Server Error → Check server logs

**Import Errors:**
- ModuleNotFoundError → Install package: `pip install package-name`
- Cannot import name → Circular import or typo
- No module named 'app' → Wrong working directory

### Test Failures

**Common Causes:**
- Test isolation → Tests affecting each other's state
- Async timing → Missing await or race condition
- Mock not reset → Mock state carries over between tests
- Environment → Missing env var or test database

## Debug Workflow

1. **Reproduce** the error consistently
2. **Collect** error message and stack trace
3. **Use `/smart-debug`** to get expert analysis
4. **Apply** the recommended fix
5. **Verify** the error is resolved
6. **Add test** to prevent regression

## When to Use

Use `/smart-debug` when:
- Error messages are long and complex
- Multiple interconnected errors
- Root cause is not immediately obvious
- Need expert domain knowledge
- Want to avoid polluting main context with logs

## Performance Optimization

By using isolated subagents:
- **Main context stays clean** - No 10,000 line error logs
- **Faster analysis** - Agent focuses only on relevant parts
- **Better solutions** - Specialized knowledge applied
- **8x more efficient** - Avoids context pollution overhead

## Follow-Up Commands

After debugging:
```bash
# Verify fix
npm run typecheck  # Frontend
pytest            # Backend

# Run affected tests
npm run test -- LoginForm.test.tsx
pytest tests/test_auth.py

# Commit fix
git add .
git commit -m "fix: resolve [error description]"
```
