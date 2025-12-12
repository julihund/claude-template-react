Run the full test suite for both frontend and backend.

Execute:
- Frontend: `npm run test` (Vitest unit tests)
- Frontend E2E: `npm run test:e2e` (Playwright)
- Backend: `pytest --cov=app` (pytest with coverage)

Display results with:
- Pass/fail status for each test suite
- Coverage percentages (aim for 80%+)
- Any failing tests with error messages

Filter tests if $ARGUMENTS provided (e.g., `/test UserProfile` runs only UserProfile tests)