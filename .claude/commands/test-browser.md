Open a browser with Playwright and visually test a component or page.

URL from $ARGUMENTS (e.g., `/test-browser http://localhost:5173/components/button`).

Actions performed:
1. Launch browser with Playwright (headless: false for visibility)
2. Navigate to $ARGUMENTS URL
3. Take screenshots at multiple viewports:
   - Mobile (375x667)
   - Tablet (768x1024)
   - Desktop (1280x720)
   - Wide (1920x1080)
4. Test interactions:
   - Hover states
   - Focus states (keyboard navigation)
   - Click interactions
5. Check accessibility:
   - ARIA labels present
   - Keyboard navigation works
   - Color contrast (via axe-core)
6. Generate visual regression report with screenshots

Optionally, if no URL provided, list available test pages and ask which to test.

Example: `/test-browser http://localhost:5173` opens homepage for visual testing.
