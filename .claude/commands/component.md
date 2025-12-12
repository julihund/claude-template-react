Create a new UI component using the implement-ui-component agent.

Component name from $ARGUMENTS (e.g., `/component Button` or `/component UserProfileCard`).

The agent will:
1. Write tests first (TDD approach) in `[ComponentName].test.tsx`
2. Implement component in `[ComponentName].tsx` following design system
3. Use HSL color tokens and Tailwind CSS utilities
4. Apply lightness-based interaction states (hover, selected, active)
5. Ensure mobile-first responsive design
6. Include accessibility features (ARIA labels, keyboard navigation)
7. Verify all tests pass

Deliverables:
- Test file with 80%+ coverage
- Component file with TypeScript types
- Clean, self-documenting code
- Confirmation that tests pass ✅