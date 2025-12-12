# Run Tests

Execute tests and report results.

## Instructions

Based on the target, run the appropriate tests:

### Unit Tests (Vitest)
```bash
npm run test           # Run all unit tests
npm run test -- path   # Run tests for specific file
npm run test:coverage  # Run with coverage report
```

### E2E Tests (Playwright)
```bash
npm run test:e2e       # Run all E2E tests
npm run test:e2e -- --grep "pattern"  # Filter tests
```

### Backend Tests (pytest)
```bash
cd src/backend
pytest                 # Run all backend tests
pytest -v              # Verbose output
pytest tests/test_file.py  # Specific file
```

## Output Format

### Test Summary
| Suite | Tests | Passed | Failed | Skipped |
|-------|-------|--------|--------|---------|
| Unit | X | X | X | X |
| E2E | X | X | X | X |

### Failures
For each failure:
- Test name
- Expected vs Actual
- Stack trace (relevant parts)
- Suggested fix

### Coverage (if available)
- Overall percentage
- Uncovered critical areas

---

**Target:** $ARGUMENTS (leave empty for all tests)
