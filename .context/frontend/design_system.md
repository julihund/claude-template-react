# Frontend Design System

## Design Philosophy

**Schlicht, Professionell, Funktional** - Minimalist design that stays out of the way and lets content shine.

### Core Values
- **Clarity**: Every element has clear purpose and hierarchy
- **Consistency**: Reusable patterns across the application
- **Accessibility**: WCAG AA compliant, keyboard-first
- **Performance**: Smooth 60fps animations, instant feedback

## No Pixels Policy

**CRITICAL RULE**: Never use pixel values in CSS. Use:

```tsx
// ❌ WRONG: Pixel values
<div style={{ padding: '16px', fontSize: '14px', margin: '8px' }} />

// ✅ CORRECT: Tailwind classes
<div className="p-4 text-sm m-2" />

// ✅ CORRECT: rem values for custom cases
<div style={{ padding: '1rem', fontSize: '0.875rem' }} />

// ✅ CORRECT: CSS variables for theme values
<div style={{ color: 'var(--color-primary)' }} />
```

## Color System

### Primary Palette

| Name | HSL | Hex | Usage |
|------|-----|-----|-------|
| **Background** | `hsl(210, 44%, 11%)` | `#101827` | Main background (dark theme) |
| **Surface** | `hsl(210, 44%, 15%)` | `#1a2332` | Cards, panels, elevated surfaces |
| **Border** | `hsl(210, 44%, 20%)` | `#252d3a` | Dividers, outlines |
| **Primary** | `hsl(187, 69%, 62%)` | `#5eced7` | Primary actions, links |
| **Accent** | `hsl(45, 100%, 51%)` | `#ffc107` | Highlights, selection, warnings |
| **Success** | `hsl(142, 71%, 45%)` | `#22c55e` | Success states |
| **Error** | `hsl(354, 70%, 54%)` | `#ef4444` | Errors, destructive actions |
| **Text Primary** | `hsl(0, 0%, 98%)` | `#fafafa` | Main text |
| **Text Secondary** | `hsl(0, 0%, 70%)` | `#b3b3b3` | Subtle text, labels |

### HSLA Lightness System

Interactive elements use systematic lightness shifts:

| State | Dark Theme Lightness | Light Theme Lightness |
|-------|---------------------|----------------------|
| **Default** | Base value | Base value |
| **Hover** | +8% | -5% |
| **Selected** | +12% | -10% |
| **Active/Pressed** | +22% | -18% |

```tsx
// Implementation pattern
<button
  className={clsx(
    'bg-[hsl(210,44%,15%)]',  // Base
    'hover:bg-[hsl(210,44%,23%)]',  // +8%
    selected && 'bg-[hsl(210,44%,27%)]',  // +12%
    'active:bg-[hsl(210,44%,37%)]'  // +22%
  )}
/>

// Using CSS variables (preferred)
<button
  className={clsx(
    'bg-[--item-bg]',
    'hover:bg-[--item-bg-hover]',
    selected && 'bg-[--item-bg-selected]',
    'active:bg-[--item-bg-active]'
  )}
/>
```

### CSS Variables Configuration

```css
/* client/src/styles/theme.css */
:root {
  --color-bg: hsl(210, 44%, 11%);
  --color-surface: hsl(210, 44%, 15%);
  --color-border: hsl(210, 44%, 20%);
  --color-primary: hsl(187, 69%, 62%);
  --color-accent: hsl(45, 100%, 51%);
  --color-error: hsl(354, 70%, 54%);

  /* Interactive states */
  --item-bg: hsl(210, 44%, 15%);
  --item-bg-hover: hsl(210, 44%, 23%);
  --item-bg-selected: hsl(210, 44%, 27%);
  --item-bg-active: hsl(210, 44%, 37%);
}
```

## Typography

### Font Stack

```css
--font-sans: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
--font-mono: 'SF Mono', Monaco, 'Cascadia Code', 'Courier New', monospace;
```

### Type Scale

| Class | Size (rem) | Line Height | Usage |
|-------|-----------|-------------|-------|
| `text-xs` | 0.75rem | 1rem | Captions, labels |
| `text-sm` | 0.875rem | 1.25rem | **Default UI text** |
| `text-base` | 1rem | 1.5rem | Body text |
| `text-lg` | 1.125rem | 1.75rem | Emphasized text |
| `text-xl` | 1.25rem | 1.75rem | H3 headings |
| `text-2xl` | 1.5rem | 2rem | H2 headings |
| `text-3xl` | 1.875rem | 2.25rem | H1 headings |

### Font Weights

```tsx
className="font-normal"    // 400 - Body text
className="font-medium"    // 500 - Emphasized text
className="font-semibold"  // 600 - Headings, buttons
className="font-bold"      // 700 - Strong emphasis
```

## Spacing System

Use Tailwind's spacing scale (based on 0.25rem = 4px):

```tsx
// Padding
className="p-2"    // 0.5rem = 8px
className="p-4"    // 1rem = 16px (standard)
className="p-6"    // 1.5rem = 24px (large panels)

// Margin
className="m-2"    // 0.5rem = 8px
className="m-4"    // 1rem = 16px

// Gap (Flexbox/Grid)
className="gap-2"  // 0.5rem = 8px (tight)
className="gap-4"  // 1rem = 16px (standard)
```

## Component Patterns

### Buttons

```tsx
import { Button } from '@/components/ui/Button';

// Primary action
<Button variant="primary">Save Changes</Button>

// Secondary action
<Button variant="secondary">Cancel</Button>

// Destructive action
<Button variant="destructive">Delete</Button>

// Ghost button (minimal)
<Button variant="ghost">Edit</Button>

// Icon button (MUST have aria-label)
<Button variant="ghost" size="icon" aria-label="Close panel">
  <XIcon className="h-4 w-4" />
</Button>

// Loading state
<Button loading disabled>Saving...</Button>
```

### Inputs

```tsx
import { Input } from '@/components/ui/Input';

// Standard input
<div>
  <label htmlFor="email" className="block text-sm font-medium mb-1">
    {t('auth.email')}
  </label>
  <Input
    id="email"
    type="email"
    value={email}
    onChange={(e) => setEmail(e.target.value)}
  />
</div>

// With error state
<Input
  error={errors.email}
  aria-invalid={!!errors.email}
  aria-describedby="email-error"
/>
{errors.email && (
  <p id="email-error" className="text-sm text-error mt-1">
    {errors.email}
  </p>
)}
```

### Cards

```tsx
import { Card } from '@/components/ui/Card';

<Card>
  <Card.Header>
    <Card.Title>Instruction Details</Card.Title>
    <Card.Description>Edit assembly steps</Card.Description>
  </Card.Header>
  <Card.Content>
    {/* Main content */}
  </Card.Content>
  <Card.Footer>
    <Button>Save</Button>
  </Card.Footer>
</Card>
```

### Badges

```tsx
import { Badge } from '@/components/ui/Badge';

<Badge variant="default">Active</Badge>
<Badge variant="success">Completed</Badge>
<Badge variant="warning">Pending</Badge>
<Badge variant="error">Failed</Badge>
```

## Layout Patterns

### Application Shell

```tsx
<div className="min-h-screen bg-[--color-bg] text-[--color-text-primary]">
  <Navbar />
  <div className="flex">
    <Sidebar />
    <main className="flex-1 p-6">
      {children}
    </main>
  </div>
</div>
```

### Responsive Grid

```tsx
// Auto-responsive grid
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  {items.map(item => <Card key={item.id}>{item.name}</Card>)}
</div>
```

### Flexbox Centering

```tsx
// Horizontal + vertical center
<div className="flex items-center justify-center min-h-screen">
  <LoginForm />
</div>

// Horizontal center only
<div className="flex justify-center">
  <Content />
</div>
```

## Accessibility Requirements

### Keyboard Navigation

```tsx
// All interactive elements must be keyboard accessible
<button onClick={handleClick}>Click me</button>  // ✅ Native button

<div onClick={handleClick}>Click me</div>  // ❌ Not keyboard accessible

// If using div, add keyboard support:
<div
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      handleClick();
    }
  }}
>
  Click me
</div>
```

### ARIA Labels

```tsx
// Icon buttons MUST have aria-label
<Button aria-label="Delete instruction">
  <TrashIcon />
</Button>

// Images MUST have alt text
<img src={url} alt="Assembly step 3: Connect cable" />

// Form inputs MUST have labels
<label htmlFor="username">{t('auth.username')}</label>
<Input id="username" />
```

### Focus Indicators

```tsx
// Default focus ring (Tailwind)
<button className="focus:outline-none focus:ring-2 focus:ring-primary">
  Action
</button>

// Custom focus style
<a className="focus-visible:underline focus-visible:text-primary">
  Link
</a>
```

### Screen Reader Support

```tsx
// Live regions for dynamic content
<div aria-live="polite" aria-atomic="true">
  {toast.message}
</div>

// Hidden but available to screen readers
<span className="sr-only">Loading...</span>

// Skip navigation link
<a href="#main-content" className="sr-only focus:not-sr-only">
  Skip to main content
</a>
```

## Internationalization

### Text Translation

```tsx
import { useTranslation } from 'react-i18next';

function Component() {
  const { t } = useTranslation();

  return (
    <div>
      <h1>{t('instruction.title')}</h1>
      <p>{t('instruction.description', { count: items.length })}</p>
    </div>
  );
}

// ❌ WRONG: Hardcoded text
<p>No instructions found</p>

// ✅ CORRECT: Translated
<p>{t('instruction.empty')}</p>
```

### Locale Files

```json
// client/src/locales/en.json
{
  "instruction": {
    "title": "Instructions",
    "description": "{{count}} instruction",
    "description_plural": "{{count}} instructions",
    "empty": "No instructions found"
  }
}

// client/src/locales/de.json
{
  "instruction": {
    "title": "Anleitungen",
    "description": "{{count}} Anleitung",
    "description_plural": "{{count}} Anleitungen",
    "empty": "Keine Anleitungen gefunden"
  }
}
```

## Animation Guidelines

### Transition Durations

```tsx
// Micro-interactions (hover, focus)
className="transition-colors duration-150"

// Component state changes (expand/collapse)
className="transition-all duration-300"

// Page transitions
className="transition-opacity duration-500"
```

### Easing Functions

```tsx
// Most interactions
className="ease-out"

// Toggles, two-way animations
className="ease-in-out"

// Exits
className="ease-in"
```

### Reduced Motion

```tsx
// Respect user preferences
<div className={clsx(
  'transition-all duration-300',
  'motion-reduce:transition-none'
)}>
```

## Responsive Design

### Breakpoints

```tsx
// Mobile-first approach
<div className={clsx(
  'text-sm',        // Mobile (default)
  'md:text-base',   // Tablet (768px+)
  'lg:text-lg'      // Desktop (1024px+)
)}>
```

### Touch Targets

Minimum size: 44x44px (WCAG AAA)

```tsx
// Button with sufficient touch target
<button className="min-h-[2.75rem] min-w-[2.75rem] p-2">
  <Icon className="h-5 w-5" />
</button>
```

## Performance Patterns

### Code Splitting

```tsx
// Route-based code splitting
import { lazy, Suspense } from 'react';

const EditorPage = lazy(() => import('@/pages/EditorPage'));

<Suspense fallback={<LoadingSpinner />}>
  <EditorPage />
</Suspense>
```

### Memoization

```tsx
import { useMemo, useCallback } from 'react';

// Expensive computation
const sortedItems = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// Callback that doesn't change on every render
const handleSubmit = useCallback(async (data: FormData) => {
  await api.submit(data);
}, []);
```

### List Virtualization

```tsx
import { useVirtualizer } from '@tanstack/react-virtual';

// For lists with >100 items
const virtualizer = useVirtualizer({
  count: items.length,
  getScrollElement: () => parentRef.current,
  estimateSize: () => 50,
});
```

## Design Tokens

Export design system as TypeScript constants for programmatic use:

```typescript
// client/src/constants/design.ts
export const COLORS = {
  background: 'hsl(210, 44%, 11%)',
  surface: 'hsl(210, 44%, 15%)',
  primary: 'hsl(187, 69%, 62%)',
  accent: 'hsl(45, 100%, 51%)',
} as const;

export const SPACING = {
  xs: '0.5rem',
  sm: '1rem',
  md: '1.5rem',
  lg: '2rem',
  xl: '3rem',
} as const;

export const BREAKPOINTS = {
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
} as const;
```

## Dark/Light Theme (Future)

Structure for theme support:

```tsx
// Theme context
const ThemeContext = createContext<'light' | 'dark'>('dark');

// CSS variables switch based on theme
[data-theme='light'] {
  --color-bg: hsl(0, 0%, 100%);
  --color-text-primary: hsl(0, 0%, 10%);
}

[data-theme='dark'] {
  --color-bg: hsl(210, 44%, 11%);
  --color-text-primary: hsl(0, 0%, 98%);
}
```
