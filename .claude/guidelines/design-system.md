# Design System

## HSL Color Palette

Our design system uses **HSL (Hue, Saturation, Lightness)** for consistent, accessible color management across themes. Customize these values for your brand.

### Color Tokens

| Name | HSL | Tailwind Class | Usage |
|------|-----|----------------|-------|
| Background | `hsl(210, 44%, 11%)` | `bg-background` | Dark theme base, app background |
| Surface | `hsl(210, 44%, 15%)` | `bg-surface` | Cards, panels, elevated elements |
| Primary | `hsl(187, 69%, 62%)` | `bg-primary` | Primary actions, interactive elements |
| Secondary | `hsl(265, 89%, 78%)` | `bg-secondary` | Accents, highlights, secondary actions |
| Success | `hsl(142, 76%, 56%)` | `bg-success` | Success states, confirmations |
| Warning | `hsl(38, 92%, 60%)` | `bg-warning` | Warning states, alerts |
| Error | `hsl(0, 84%, 60%)` | `bg-error` | Error states, destructive actions |
| Text Primary | `hsl(210, 44%, 97%)` | `text-primary` | Main text, headings |
| Text Secondary | `hsl(210, 44%, 70%)` | `text-secondary` | Secondary text, captions |
| Border | `hsl(210, 44%, 25%)` | `border-border` | Borders, dividers |

### Tailwind Configuration

Add to `tailwind.config.js`:

```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        background: 'hsl(var(--background))',
        surface: 'hsl(var(--surface))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          hover: 'hsl(var(--primary-hover))',
          selected: 'hsl(var(--primary-selected))',
          active: 'hsl(var(--primary-active))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          hover: 'hsl(var(--secondary-hover))',
        },
        success: 'hsl(var(--success))',
        warning: 'hsl(var(--warning))',
        error: 'hsl(var(--error))',
        'text-primary': 'hsl(var(--text-primary))',
        'text-secondary': 'hsl(var(--text-secondary))',
        border: 'hsl(var(--border))',
      },
    },
  },
};
```

Add to your global CSS (`src/index.css`):

```css
:root {
  /* Base colors (dark theme) */
  --background: 210 44% 11%;
  --surface: 210 44% 15%;
  --primary: 187 69% 62%;
  --primary-hover: 187 69% 70%;      /* +8% lightness */
  --primary-selected: 187 69% 74%;   /* +12% lightness */
  --primary-active: 187 69% 84%;     /* +22% lightness */
  --secondary: 265 89% 78%;
  --secondary-hover: 265 89% 86%;    /* +8% lightness */
  --success: 142 76% 56%;
  --warning: 38 92% 60%;
  --error: 0 84% 60%;
  --text-primary: 210 44% 97%;
  --text-secondary: 210 44% 70%;
  --border: 210 44% 25%;
}

/* Light theme (optional) */
[data-theme="light"] {
  --background: 0 0% 100%;
  --surface: 210 44% 98%;
  --primary: 187 69% 42%;            /* Darker for light theme */
  --primary-hover: 187 69% 37%;      /* -5% lightness */
  --primary-selected: 187 69% 32%;   /* -10% lightness */
  --primary-active: 187 69% 24%;     /* -18% lightness */
  --text-primary: 210 44% 10%;
  --text-secondary: 210 44% 40%;
  --border: 210 44% 85%;
}
```

## Lightness-Based Interaction States

Interactive elements use **lightness shifts** for hover, selected, and active states. This creates a consistent interaction language.

### Dark Theme States

| State | Lightness Adjustment | Example (Primary) |
|-------|---------------------|-------------------|
| Default | Base | `hsl(187, 69%, 62%)` |
| Hover | +8% lightness | `hsl(187, 69%, 70%)` |
| Selected / Focus | +12% lightness | `hsl(187, 69%, 74%)` |
| Active / Pressed | +22% lightness | `hsl(187, 69%, 84%)` |

### Light Theme States

| State | Lightness Adjustment | Example (Primary) |
|-------|---------------------|-------------------|
| Default | Base | `hsl(187, 69%, 42%)` |
| Hover | -5% lightness | `hsl(187, 69%, 37%)` |
| Selected / Focus | -10% lightness | `hsl(187, 69%, 32%)` |
| Active / Pressed | -18% lightness | `hsl(187, 69%, 24%)` |

### Button Component Example

❌ **Bad** (hard-coded colors):
```typescript
function Button({ children }: ButtonProps) {
  return (
    <button className="bg-blue-500 hover:bg-blue-600 active:bg-blue-700">
      {children}
    </button>
  );
}
```

✅ **Good** (using design tokens):
```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary';
  children: React.ReactNode;
}

function Button({ variant = 'primary', children }: ButtonProps) {
  return (
    <button
      className={`
        px-4 py-2 rounded-md font-medium transition-colors
        ${variant === 'primary'
          ? 'bg-primary hover:bg-primary-hover active:bg-primary-active text-white'
          : 'bg-secondary hover:bg-secondary-hover text-white'
        }
      `}
    >
      {children}
    </button>
  );
}
```

### Input Component Example

✅ **Good** (focus states with lightness):
```typescript
function Input({ ...props }: InputProps) {
  return (
    <input
      className="
        px-3 py-2 rounded-md
        bg-surface border border-border
        text-primary
        focus:outline-none focus:ring-2 focus:ring-primary-selected
        placeholder:text-secondary
      "
      {...props}
    />
  );
}
```

## Responsive Design

### Tailwind Breakpoints

| Breakpoint | Min Width | Usage |
|------------|-----------|-------|
| `sm` | 640px | Small tablets, large phones |
| `md` | 768px | Tablets |
| `lg` | 1024px | Laptops, small desktops |
| `xl` | 1280px | Desktops |
| `2xl` | 1536px | Large desktops |

### Mobile-First Approach

Always design for mobile first, then add complexity for larger screens using breakpoints.

❌ **Bad** (desktop-first):
```tsx
<div className="grid grid-cols-3 md:grid-cols-1">
  {/* Starts with 3 columns, collapses to 1 on mobile */}
</div>
```

✅ **Good** (mobile-first):
```tsx
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
  {/* Starts with 1 column, expands on larger screens */}
</div>
```

### Responsive Component Example

```typescript
function ProductCard({ product }: ProductCardProps) {
  return (
    <div className="
      bg-surface rounded-lg p-4
      flex flex-col gap-3
      md:flex-row md:gap-6
      lg:p-6
    ">
      <img
        src={product.image}
        alt={product.name}
        className="
          w-full h-48 object-cover rounded-md
          md:w-32 md:h-32
          lg:w-48 lg:h-48
        "
      />
      <div className="flex-1">
        <h3 className="text-lg font-semibold text-primary md:text-xl">
          {product.name}
        </h3>
        <p className="text-sm text-secondary mt-1 md:text-base">
          {product.description}
        </p>
      </div>
    </div>
  );
}
```

### Touch Target Sizes

For mobile accessibility, ensure interactive elements are at least 44x44px:

```tsx
function IconButton({ icon, onClick }: IconButtonProps) {
  return (
    <button
      onClick={onClick}
      className="
        min-w-[44px] min-h-[44px]
        flex items-center justify-center
        bg-surface hover:bg-primary-hover
        rounded-md transition-colors
      "
    >
      {icon}
    </button>
  );
}
```

## Component Reusability

### Build Reusable Primitives

Create a library of reusable UI components in `src/components/ui/`:

✅ **Good structure**:
```
src/components/ui/
├── Button.tsx        # Primary, secondary, danger variants
├── Input.tsx         # Text, email, password variants
├── Card.tsx          # Surface elevation
├── Dialog.tsx        # Modal overlays
├── Badge.tsx         # Status indicators
└── Spinner.tsx       # Loading states
```

### Avoid Component Duplication

❌ **Bad** (creating similar components):
```typescript
// SubmitButton.tsx
function SubmitButton() {
  return <button className="bg-primary ...">Submit</button>;
}

// CancelButton.tsx
function CancelButton() {
  return <button className="bg-secondary ...">Cancel</button>;
}

// DeleteButton.tsx
function DeleteButton() {
  return <button className="bg-error ...">Delete</button>;
}
```

✅ **Good** (one reusable component):
```typescript
// Button.tsx
type ButtonVariant = 'primary' | 'secondary' | 'danger';

interface ButtonProps {
  variant?: ButtonVariant;
  children: React.ReactNode;
  onClick?: () => void;
}

function Button({ variant = 'primary', children, onClick }: ButtonProps) {
  const variantStyles = {
    primary: 'bg-primary hover:bg-primary-hover',
    secondary: 'bg-secondary hover:bg-secondary-hover',
    danger: 'bg-error hover:bg-error',
  };

  return (
    <button
      onClick={onClick}
      className={`px-4 py-2 rounded-md font-medium ${variantStyles[variant]}`}
    >
      {children}
    </button>
  );
}

// Usage
<Button variant="primary">Submit</Button>
<Button variant="secondary">Cancel</Button>
<Button variant="danger">Delete</Button>
```

## Typography Scale

Define a consistent type scale:

```css
/* Add to tailwind.config.js */
theme: {
  extend: {
    fontSize: {
      'xs': ['0.75rem', { lineHeight: '1rem' }],
      'sm': ['0.875rem', { lineHeight: '1.25rem' }],
      'base': ['1rem', { lineHeight: '1.5rem' }],
      'lg': ['1.125rem', { lineHeight: '1.75rem' }],
      'xl': ['1.25rem', { lineHeight: '1.75rem' }],
      '2xl': ['1.5rem', { lineHeight: '2rem' }],
      '3xl': ['1.875rem', { lineHeight: '2.25rem' }],
      '4xl': ['2.25rem', { lineHeight: '2.5rem' }],
    },
  },
}
```

Example usage:

```tsx
function ArticlePage() {
  return (
    <article className="prose">
      <h1 className="text-4xl font-bold text-primary mb-4">Article Title</h1>
      <p className="text-lg text-secondary mb-6">Subtitle or excerpt</p>
      <p className="text-base text-primary leading-relaxed">
        Body content goes here...
      </p>
    </article>
  );
}
```

## Spacing System

Use Tailwind's default spacing scale (based on 0.25rem = 4px):

| Class | Size | Pixels | Usage |
|-------|------|--------|-------|
| `gap-1` | 0.25rem | 4px | Tight spacing |
| `gap-2` | 0.5rem | 8px | Small gaps |
| `gap-3` | 0.75rem | 12px | Default gaps |
| `gap-4` | 1rem | 16px | Medium gaps |
| `gap-6` | 1.5rem | 24px | Large gaps |
| `gap-8` | 2rem | 32px | Section spacing |

Example:

```tsx
function UserProfile() {
  return (
    <div className="flex flex-col gap-6">  {/* 24px between sections */}
      <header className="flex items-center gap-4">  {/* 16px between avatar and name */}
        <img className="w-12 h-12 rounded-full" />
        <div className="flex flex-col gap-1">  {/* 4px between name and subtitle */}
          <h2>John Doe</h2>
          <p className="text-sm">Software Engineer</p>
        </div>
      </header>
      <section className="flex flex-col gap-3">  {/* 12px between items */}
        <p>Bio content...</p>
        <p>More content...</p>
      </section>
    </div>
  );
}
```

## Accessibility

### Color Contrast

Ensure WCAG AA compliance (4.5:1 contrast ratio for normal text):
- Text Primary on Background: ✅ Pass
- Text Secondary on Surface: ✅ Pass
- Primary button text: ✅ Pass

Test contrast at https://webaim.org/resources/contrastchecker/

### Focus States

Always provide visible focus indicators:

```tsx
<button className="
  focus:outline-none
  focus:ring-2 focus:ring-primary-selected
  focus:ring-offset-2 focus:ring-offset-background
">
  Accessible Button
</button>
```

## Summary

1. **HSL colors**: Use design tokens, not hard-coded values
2. **Lightness interactions**: +8% hover, +12% selected, +22% active (dark theme)
3. **Responsive**: Mobile-first, use breakpoints (sm, md, lg, xl, 2xl)
4. **Reusable components**: Build once, use everywhere (Button, Input, Card)
5. **Typography & spacing**: Consistent scales, Tailwind defaults
6. **Accessibility**: WCAG AA contrast, visible focus states, 44x44px touch targets
