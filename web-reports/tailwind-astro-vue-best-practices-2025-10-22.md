# Tailwind CSS + Astro + Vue 3 Best Practices (2024-2025)

**Research Date:** 2025-10-22
**Focus:** Configuration architecture, animations, SSR patterns, plugin design

---

## Executive Summary

Tailwind CSS v4 introduced major architectural changes that fundamentally alter configuration patterns. The shift from `tailwind.config.js` to CSS-first configuration via `@theme` directive provides cleaner theme management, better type safety, and simplified multi-theme implementations. Astro + Vue 3 integration benefits from these patterns through improved SSR safety and hydration management.

**Key Findings:**
- Tailwind v4 uses `@theme` directive in CSS files instead of JavaScript config
- `darkMode: "selector"` (v3) becomes `darkMode: "class"` for Astro SSR compatibility
- Animation systems should centralize tokens via `@theme` with JavaScript/Vue integration via CSS variables
- Custom utilities via `@utility` directive preferred over full plugins for most cases
- Astro View Transitions require special dark mode persistence patterns

---

## 1. Tailwind Config Architecture

### v4 Paradigm Shift: CSS-First Configuration

**Source:** https://tailwindcss.com/docs/theme

Tailwind v4 eliminates `tailwind.config.js` in favor of CSS-based configuration using the `@theme` directive.

#### `@theme` Directive Fundamentals

**Core difference from `:root`:**
- `@theme` variables generate utility classes AND create CSS variables
- `:root` variables are purely stylistic (no utilities generated)
- Use `@theme` for design tokens, `:root` for internal CSS-only values

**Theme Variable Namespaces:**

| Namespace | Generated Utilities | Example |
|-----------|-------------------|---------|
| `--color-*` | `bg-`, `text-`, `border-`, `fill-` | `--color-primary: #3f3cbb` |
| `--font-*` | `font-sans`, `font-serif` | `--font-display: Poppins, sans-serif` |
| `--spacing-*` | `px-`, `py-`, `gap-`, `max-h-` | `--spacing-7: 1.75rem` |
| `--radius-*` | `rounded-sm`, `rounded-lg` | `--radius-xl: 1rem` |
| `--shadow-*` | `shadow-md`, `shadow-lg` | `--shadow-brutal: 4px 4px 0 #000` |
| `--breakpoint-*` | `sm:*`, `md:*`, `lg:*` | `--breakpoint-tablet: 48rem` |

#### Configuration Patterns

**1. Extending Default Theme (Recommended for Most Cases):**

```css
@import "tailwindcss";

@theme {
  /* Adds to existing colors, doesn't replace */
  --color-brand-primary: #3f3cbb;
  --color-brand-secondary: #f59e0b;

  /* Custom font families */
  --font-display: Poppins, sans-serif;
  --font-body: Inter, system-ui, sans-serif;

  /* Custom spacing tokens */
  --spacing-18: 4.5rem;
  --spacing-128: 32rem;
}
```

**2. Overriding Default Values:**

```css
@theme {
  /* Changes existing breakpoint */
  --breakpoint-sm: 30rem; /* was 40rem */

  /* Replaces default shadow */
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.15);
}
```

**3. Complete Namespace Replacement:**

```css
@theme {
  /* Remove ALL default colors */
  --color-*: initial;

  /* Define only your custom palette */
  --color-primary: #3f3cbb;
  --color-secondary: #f59e0b;
  --color-neutral-50: #fafafa;
  --color-neutral-900: #171717;
}
```

**⚠️ Warning:** Complete replacement removes utility classes like `bg-red-500`, `text-blue-600`, etc.

#### Advanced Techniques

**Referencing Other Variables:**

```css
@theme inline {
  /* inline option prevents CSS variable resolution issues */
  --font-sans: var(--font-inter);
  --color-accent: var(--color-brand-primary);
}
```

**Animation Keyframes in @theme:**

```css
@theme {
  --animate-fade-in: fade-in 0.3s ease-out;
  --animate-slide-up: slide-up 0.4s cubic-bezier(0.4, 0, 0.2, 1);

  @keyframes fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  @keyframes slide-up {
    from { transform: translateY(1rem); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
  }
}
```

**Sharing Across Projects (Monorepo Pattern):**

```css
/* packages/design-tokens/theme.css */
@theme {
  --color-brand-primary: #3f3cbb;
  --color-brand-secondary: #f59e0b;
  /* ... all shared tokens */
}

/* apps/marketing/styles/global.css */
@import "@company/design-tokens/theme.css";
@import "tailwindcss";
```

---

## 2. Custom Color Palette Organization

### Semantic Naming with Dark Mode Support

**Source:** https://simonswiss.com/posts/tailwind-v4-multi-theme

Tailwind v4 drastically simplifies multi-theme implementation by eliminating the need for RGB channel workarounds required in v3.

#### v3 vs v4 Comparison

**v3 Pattern (Complex, Error-Prone):**
```javascript
// tailwind.config.js
module.exports = {
  theme: {
    colors: {
      primary: 'rgb(var(--color-primary) / <alpha-value>)',
    }
  }
}
```
```css
:root {
  --color-primary: 59 130 246; /* RGB channels only */
}
```

**v4 Pattern (Simple, Intuitive):**
```css
@theme {
  --color-primary: #3b82f6; /* Any valid color format */
}
```

#### Multi-Theme Architecture

**Base Theme Definition:**
```css
@import "tailwindcss";

@theme {
  /* Default/light theme colors */
  --color-background: #ffffff;
  --color-foreground: #171717;
  --color-primary: #3f3cbb;
  --color-secondary: #f59e0b;
  --color-accent: #ec4899;
  --color-muted: #f5f5f5;
  --color-border: #e5e5e5;
}
```

**Theme Variants:**
```css
@layer base {
  /* Dark mode */
  .dark {
    --color-background: #0a0a0a;
    --color-foreground: #fafafa;
    --color-primary: #818cf8;
    --color-secondary: #fbbf24;
    --color-accent: #f9a8d4;
    --color-muted: #262626;
    --color-border: #404040;
  }

  /* Custom themes via data attributes */
  [data-theme='ocean'] {
    --color-primary: #aab9ff;
    --color-secondary: #56d0a0;
  }

  [data-theme='rainforest'] {
    --color-primary: #56d0a0;
    --color-secondary: #34d399;
  }

  [data-theme='candy'] {
    --color-primary: #f9a8d4;
    --color-secondary: #fb7185;
  }
}
```

**Usage in Markup:**
```html
<!-- Automatic utility class generation -->
<div class="bg-primary text-foreground">
  <button class="bg-accent hover:bg-accent/90">Click me</button>
</div>

<!-- Arbitrary value syntax for theme variables -->
<div class="bg-(--color-primary)"></div>
```

#### Semantic Color Strategy (Recommended)

**Role-Based Naming:**
```css
@theme {
  /* Surface colors */
  --color-background: #ffffff;
  --color-surface: #f9fafb;
  --color-surface-elevated: #ffffff;

  /* Text colors */
  --color-foreground: #171717;
  --color-muted-foreground: #737373;

  /* Interactive states */
  --color-primary: #3f3cbb;
  --color-primary-hover: #312e81;
  --color-destructive: #dc2626;
  --color-destructive-hover: #b91c1c;

  /* Borders and dividers */
  --color-border: #e5e5e5;
  --color-input-border: #d4d4d4;
  --color-ring: #3f3cbb; /* Focus rings */
}
```

**Benefits:**
- Component-agnostic (works across design systems)
- Easy theme switching (override semantic tokens)
- Predictable dark mode (same utility classes, different values)

---

## 3. Animation & Motion Systems

### Centralized Animation Tokens

**Sources:**
- https://motion.dev/docs/react-tailwind
- https://tailwindcss.com/docs/animation

#### Architecture Strategy: Tailwind for Static, Motion for Dynamic

**Key Principle:** Let each library do what it does best:
- **Tailwind:** Static animations (transitions, keyframes)
- **Motion/Vue Animations:** Dynamic, interactive animations (gestures, layout shifts)

#### Tailwind Animation Configuration

**Define Animation Tokens:**
```css
@theme {
  /* Animation durations */
  --animate-duration-fast: 150ms;
  --animate-duration-base: 300ms;
  --animate-duration-slow: 500ms;

  /* Easing functions */
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);

  /* Predefined animations */
  --animate-fade-in: fade-in var(--animate-duration-base) var(--ease-in-out);
  --animate-slide-up: slide-up var(--animate-duration-base) var(--ease-in-out);
  --animate-scale-in: scale-in var(--animate-duration-fast) var(--ease-spring);

  @keyframes fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  @keyframes slide-up {
    from {
      opacity: 0;
      transform: translateY(1rem);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  @keyframes scale-in {
    from {
      opacity: 0;
      transform: scale(0.95);
    }
    to {
      opacity: 1;
      transform: scale(1);
    }
  }
}
```

**Usage:**
```html
<div class="animate-fade-in">Fades in on load</div>
<div class="animate-slide-up hover:animate-scale-in">Interactive</div>
```

#### Vue 3 Transition Integration

**Sources:**
- https://vueschool.io/lessons/custom-vue-transition-classes-aka-tailwind-css-with-vue-transitions
- https://stackoverflow.com/questions/68998731/vue-transition-with-tailwind

**Pattern: Custom Transition Classes:**
```vue
<template>
  <Transition
    enter-active-class="transition duration-300 ease-out"
    enter-from-class="opacity-0 scale-95"
    enter-to-class="opacity-100 scale-100"
    leave-active-class="transition duration-200 ease-in"
    leave-from-class="opacity-100 scale-100"
    leave-to-class="opacity-0 scale-95"
  >
    <div v-if="show" class="modal">Content</div>
  </Transition>
</template>
```

**Reusable Composable Pattern:**
```typescript
// composables/useTransitionClasses.ts
export const useTransitionClasses = () => ({
  fadeIn: {
    enterActiveClass: 'transition-opacity duration-300',
    enterFromClass: 'opacity-0',
    enterToClass: 'opacity-100',
    leaveActiveClass: 'transition-opacity duration-200',
    leaveFromClass: 'opacity-100',
    leaveToClass: 'opacity-0',
  },
  slideUp: {
    enterActiveClass: 'transition-all duration-300 ease-out',
    enterFromClass: 'opacity-0 translate-y-4',
    enterToClass: 'opacity-100 translate-y-0',
    leaveActiveClass: 'transition-all duration-200 ease-in',
    leaveFromClass: 'opacity-100 translate-y-0',
    leaveToClass: 'opacity-0 translate-y-4',
  },
});
```

```vue
<script setup lang="ts">
import { useTransitionClasses } from '@/composables/useTransitionClasses';

const transitions = useTransitionClasses();
</script>

<template>
  <Transition v-bind="transitions.fadeIn">
    <div v-if="show">Content</div>
  </Transition>
</template>
```

#### Responsive Animation Scaling

**Pattern: CSS Variables + Tailwind Responsive Utilities:**
```css
@theme {
  --animate-duration: 300ms;
}

@layer base {
  /* Reduce motion on mobile */
  @media (max-width: 640px) {
    :root {
      --animate-duration: 200ms;
    }
  }

  /* Respect user preferences */
  @media (prefers-reduced-motion: reduce) {
    :root {
      --animate-duration: 0ms;
    }
  }
}
```

**Vue Composable for Responsive Animations:**
```typescript
// composables/useResponsiveAnimation.ts
import { ref, computed, onMounted } from 'vue';

export const useResponsiveAnimation = () => {
  const prefersReducedMotion = ref(false);

  onMounted(() => {
    const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
    prefersReducedMotion.value = mediaQuery.matches;

    mediaQuery.addEventListener('change', (e) => {
      prefersReducedMotion.value = e.matches;
    });
  });

  const animationDuration = computed(() => {
    if (prefersReducedMotion.value) return 0;
    return getComputedStyle(document.documentElement)
      .getPropertyValue('--animate-duration');
  });

  return { animationDuration, prefersReducedMotion };
};
```

#### Performance Considerations: Web Animations API

**When to Use:**
- Complex, multi-property animations
- Animations requiring fine-grained control
- Performance-critical animations (runs on compositor thread)

**Pattern:**
```typescript
// composables/useWebAnimation.ts
export const useWebAnimation = (
  element: Ref<HTMLElement | null>,
  keyframes: Keyframe[],
  options: KeyframeAnimationOptions
) => {
  const animation = ref<Animation | null>(null);

  const play = () => {
    if (!element.value) return;

    animation.value = element.value.animate(keyframes, {
      duration: parseInt(
        getComputedStyle(document.documentElement)
          .getPropertyValue('--animate-duration')
      ),
      easing: getComputedStyle(document.documentElement)
        .getPropertyValue('--ease-in-out'),
      ...options,
    });
  };

  return { play, animation };
};
```

---

## 4. Astro + Vue + Tailwind Integration

### SSR-Safe Tailwind Patterns

**Sources:**
- https://docs.astro.build/en/guides/styling/
- https://themefisher.com/tailwind-css-with-astro

#### Setup Configuration

**Install Tailwind:**
```bash
npx astro add tailwind
```

**Tailwind Config (`tailwind.config.mjs`):**
```javascript
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'
  ],
  darkMode: 'class', // Critical for SSR compatibility
  theme: {
    extend: {}, // Use CSS @theme instead in v4
  },
  plugins: [],
}
```

**Global Styles (`src/styles/global.css`):**
```css
@import "tailwindcss";

@theme {
  /* Custom design tokens */
  --color-brand: #3f3cbb;
  --font-display: Poppins, sans-serif;
}

@layer base {
  /* Base styles that affect all pages */
  html {
    font-family: var(--font-display);
  }
}
```

**Layout Component (`src/layouts/Layout.astro`):**
```astro
---
import '../styles/global.css';

interface Props {
  title: string;
}

const { title } = Astro.props;
---

<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>{title}</title>
  </head>
  <body class="bg-background text-foreground">
    <slot />
  </body>
</html>
```

#### Dark Mode Implementation (SSR-Safe)

**Source:** https://namoku.dev/blog/darkmode-tailwind-astro/

**Critical Pattern: Inline Script for Flash Prevention**

```astro
---
// src/layouts/Layout.astro
import '../styles/global.css';
---

<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>{title}</title>

    <!-- CRITICAL: Inline script runs before page render -->
    <script is:inline>
      // IIFE to prevent global scope pollution
      (function() {
        const getTheme = () => {
          // Check localStorage first
          if (typeof localStorage !== 'undefined') {
            const stored = localStorage.getItem('theme');
            if (stored) return stored;
          }

          // Fall back to system preference
          return window.matchMedia('(prefers-color-scheme: dark)').matches
            ? 'dark'
            : 'light';
        };

        const theme = getTheme();

        // Apply dark class immediately (before render)
        if (theme === 'dark') {
          document.documentElement.classList.add('dark');
        }
      })();
    </script>
  </head>
  <body>
    <slot />
  </body>
</html>
```

**⚠️ Key Point:** The `is:inline` directive prevents Astro from bundling/optimizing the script, ensuring it runs synchronously before page render.

#### View Transitions Dark Mode Persistence

**Problem:** Astro View Transitions API replaces DOM content, removing the `dark` class.

**Solution:**
```astro
<script>
  // Theme toggle logic
  function applyTheme() {
    const theme = localStorage.getItem('theme') || 'light';
    document.documentElement.classList.toggle('dark', theme === 'dark');
  }

  function toggleTheme() {
    const currentTheme = localStorage.getItem('theme') || 'light';
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    localStorage.setItem('theme', newTheme);
    applyTheme();
  }

  // Apply on initial load
  applyTheme();

  // Reapply after View Transitions navigation
  document.addEventListener('astro:after-swap', () => {
    applyTheme();

    // Reattach event listeners (removed during swap)
    const themeToggle = document.getElementById('themeToggle');
    if (themeToggle && !themeToggle.hasAttribute('onclick')) {
      themeToggle.addEventListener('click', toggleTheme);
    }
  });
</script>

<button id="themeToggle" type="button">
  Toggle Theme
</button>
```

**Event Lifecycle:**
- `astro:before-preparation` - Before new page fetch
- `astro:after-preparation` - After new page fetch
- `astro:before-swap` - Before DOM replacement
- **`astro:after-swap`** - **Use this for theme persistence**
- `astro:page-load` - After navigation complete

#### Vue Component Tailwind Class Hydration

**SSR-Safe Pattern:**
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue';

// Safe: Static classes (hydrated correctly)
const baseClasses = 'bg-primary text-white px-4 py-2 rounded';

// Dangerous: Dynamic classes computed during SSR
// const dynamicClasses = computed(() => {
//   return isDark.value ? 'bg-gray-900' : 'bg-white'; // ❌ SSR mismatch
// });

// Safe: Dynamic classes after mount
const themeClasses = ref('');

onMounted(() => {
  const theme = localStorage.getItem('theme');
  themeClasses.value = theme === 'dark' ? 'bg-gray-900' : 'bg-white';
});
</script>

<template>
  <button :class="[baseClasses, themeClasses]">
    Click me
  </button>
</template>
```

**Alternative: CSS Variable Strategy (Preferred):**
```vue
<script setup lang="ts">
// No JavaScript needed - CSS handles theme reactivity
</script>

<template>
  <button class="bg-background text-foreground hover:bg-primary">
    Click me
  </button>
</template>

<style scoped>
/* Tailwind utilities automatically respond to .dark class */
</style>
```

#### Global Styles Organization

**Recommended Directory Structure:**
```
src/
├── styles/
│   ├── global.css         # Tailwind imports + @theme
│   ├── base.css           # Base element styles
│   ├── components.css     # Component-layer styles
│   └── utilities.css      # Custom utility classes
├── layouts/
│   └── Layout.astro       # Imports global.css
└── components/
    └── (Vue components)
```

**global.css Pattern:**
```css
/* src/styles/global.css */
@import "tailwindcss";

/* Design tokens */
@theme {
  --color-brand: #3f3cbb;
  --font-display: Poppins, sans-serif;
  --spacing-section: 6rem;
}

/* Base styles */
@layer base {
  html {
    @apply scroll-smooth;
  }

  body {
    @apply font-sans antialiased;
  }

  h1, h2, h3, h4, h5, h6 {
    @apply font-display font-bold;
  }
}

/* Component patterns (reusable) */
@layer components {
  .btn {
    @apply px-4 py-2 rounded font-medium transition-colors;
  }

  .btn-primary {
    @apply btn bg-primary text-white hover:bg-primary-hover;
  }
}

/* Custom utilities */
@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
```

**Import Strategy:**
```astro
---
// src/layouts/Layout.astro
// Import once in layout, available globally
import '../styles/global.css';
---
```

**❌ Anti-Pattern:**
```vue
<!-- Don't import global.css in Vue components -->
<script setup lang="ts">
import '@/styles/global.css'; // ❌ Duplicates styles
</script>
```

---

## 5. Plugin Architecture

### When to Create Plugins vs Utilities

**Source:** https://tailwindcss.com/docs/plugins

#### Decision Framework

| Use Case | Solution | Reasoning |
|----------|----------|-----------|
| Single CSS property | `@utility` directive | Simpler, less overhead |
| Multi-property pattern | `@utility` with nesting | Keeps CSS together |
| Complex component base styles | Plugin with `addComponents` | Semantic, reusable |
| New variants (custom selectors) | `@custom-variant` directive | Built-in support in v4 |
| JavaScript-generated utilities | Plugin with `matchUtilities` | Dynamic value generation |

#### Custom Utilities (Preferred for Most Cases)

**Simple Utility:**
```css
@utility content-auto {
  content-visibility: auto;
}

/* Generates: */
.content-auto { content-visibility: auto; }
```

**Multi-Property Utility:**
```css
@utility scrollbar-hidden {
  &::-webkit-scrollbar {
    display: none;
  }

  scrollbar-width: none;
}

/* Generates with variants: */
.scrollbar-hidden::-webkit-scrollbar { display: none; }
.hover\:scrollbar-hidden:hover::-webkit-scrollbar { display: none; }
```

**Parameterized Utility:**
```css
@utility tab-* {
  tab-size: --value(--tab-size-*);
}

/* Usage: tab-4, tab-8, tab-[12] */
```

**Value Function Capabilities:**
```css
@utility leading-* {
  /* Theme matching */
  line-height: --value(--line-height-*);

  /* Bare values */
  /* --value(integer) - unitless numbers */
  /* --value(percentage) - percentage values */

  /* Literal values */
  /* --value("inherit", "initial") */

  /* Arbitrary values */
  /* --value([length], [percentage]) */
}
```

#### Custom Variants (v4 Pattern)

**Role-Based Variant:**
```css
@custom-variant theme-midnight {
  &:where([data-theme="midnight"] *) {
    @slot;
  }
}

/* Usage: theme-midnight:bg-purple-900 */
```

**State Variant:**
```css
@custom-variant group-loading {
  :merge(.group)[data-loading] & {
    @slot;
  }
}

/* Usage: group-loading:opacity-50 */
```

**Media Query Variant:**
```css
@custom-variant motion-safe {
  @media (prefers-reduced-motion: no-preference) {
    @slot;
  }
}

/* Usage: motion-safe:animate-fade-in */
```

#### Plugin Patterns (v3 and Legacy Support)

**When to Use Plugins:**
- Supporting Tailwind v3 projects
- Complex JavaScript logic for utility generation
- Third-party libraries/design systems
- Advanced theme manipulation

**Component Plugin Pattern:**
```javascript
// plugins/components.js
const plugin = require('tailwindcss/plugin');

module.exports = plugin(function({ addComponents, theme }) {
  addComponents({
    '.card': {
      backgroundColor: theme('colors.white'),
      borderRadius: theme('borderRadius.lg'),
      padding: theme('spacing.6'),
      boxShadow: theme('boxShadow.xl'),
    },
    '.card-dark': {
      backgroundColor: theme('colors.gray.800'),
      color: theme('colors.white'),
    },
  });
});
```

**Dynamic Utility Plugin:**
```javascript
// plugins/utilities.js
const plugin = require('tailwindcss/plugin');

module.exports = plugin(function({ matchUtilities, theme }) {
  matchUtilities(
    {
      'grid-cols-fit': (value) => ({
        gridTemplateColumns: `repeat(auto-fit, minmax(${value}, 1fr))`,
      }),
    },
    { values: theme('spacing') }
  );
});

// Usage: grid-cols-fit-64, grid-cols-fit-[200px]
```

**Variant Plugin:**
```javascript
// plugins/variants.js
const plugin = require('tailwindcss/plugin');

module.exports = plugin(function({ addVariant }) {
  addVariant('third', '&:nth-child(3)');
  addVariant('hocus', ['&:hover', '&:focus']);

  // Complex selector
  addVariant('supports-grid', '@supports (display: grid)');
});

// Usage: third:font-bold, hocus:underline
```

#### Plugin File Organization

**Monolithic (Small Projects):**
```javascript
// tailwind.config.js
module.exports = {
  plugins: [
    require('@tailwindcss/forms'),
    require('./plugins/custom'),
  ],
};
```

**Modular (Design Systems/Large Projects):**
```
plugins/
├── index.js              # Aggregates all plugins
├── components/
│   ├── buttons.js
│   ├── cards.js
│   └── forms.js
├── utilities/
│   ├── grid.js
│   ├── typography.js
│   └── spacing.js
└── variants/
    ├── states.js
    └── themes.js
```

```javascript
// plugins/index.js
const components = require('./components');
const utilities = require('./utilities');
const variants = require('./variants');

module.exports = [
  components,
  utilities,
  variants,
];

// tailwind.config.js
module.exports = {
  plugins: require('./plugins'),
};
```

---

## 6. Design System Examples & Industry Patterns

### Shadcn/UI Approach (CSS Variables + Semantic Naming)

**Pattern:** Define all colors as CSS variables, use semantic utility classes

```css
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
```

**Benefits:**
- Theme switching via CSS variable override
- HSL format allows opacity modifiers: `bg-primary/50`
- Semantic names survive redesigns

### Radix UI/Headless UI Pattern (Unstyled Components + Tailwind)

**Pattern:** Headless components with Tailwind styling via props

```vue
<script setup lang="ts">
import { Dialog, DialogPanel, DialogTitle } from '@headlessui/vue';

const isOpen = ref(false);
</script>

<template>
  <Dialog
    :open="isOpen"
    @close="isOpen = false"
    class="relative z-50"
  >
    <!-- Backdrop -->
    <div class="fixed inset-0 bg-black/30" aria-hidden="true" />

    <!-- Panel -->
    <div class="fixed inset-0 flex items-center justify-center p-4">
      <DialogPanel class="mx-auto max-w-sm rounded bg-white p-6 shadow-xl">
        <DialogTitle class="text-lg font-medium">
          Deactivate account
        </DialogTitle>
        <p class="mt-2 text-sm text-gray-500">
          Are you sure you want to deactivate your account?
        </p>
        <div class="mt-4 flex gap-2">
          <button
            class="btn-primary"
            @click="isOpen = false"
          >
            Deactivate
          </button>
          <button
            class="btn-secondary"
            @click="isOpen = false"
          >
            Cancel
          </button>
        </div>
      </DialogPanel>
    </div>
  </Dialog>
</template>
```

**Benefits:**
- Accessibility built-in (focus management, ARIA)
- Full styling control via Tailwind
- No CSS conflicts or specificity issues

---

## 7. Key Takeaways & Action Items

### Immediate Implementation Steps

1. **Migrate to Tailwind v4 CSS Configuration**
   - Replace `tailwind.config.js` theme with `@theme` directive
   - Define semantic color tokens with dark mode variants
   - Use `@utility` for custom utilities instead of plugins

2. **Implement SSR-Safe Dark Mode**
   - Use `is:inline` script in Astro layout for flash prevention
   - Add `astro:after-swap` listener for View Transitions persistence
   - Store theme preference in localStorage with system fallback

3. **Centralize Animation System**
   - Define animation tokens via `@theme` (durations, easings, keyframes)
   - Create Vue composables for Transition class sets
   - Implement `prefers-reduced-motion` checks

4. **Organize Global Styles**
   - Single import in layout component (`src/styles/global.css`)
   - Use `@layer base` for element defaults
   - Use `@layer components` for reusable patterns
   - Use `@layer utilities` for custom utility classes

5. **Adopt Semantic Color Naming**
   - Replace literal names (`blue-500`) with role-based (`primary`, `foreground`)
   - Define dark mode as CSS variable overrides
   - Use HSL format for opacity modifier support

### Anti-Patterns to Avoid

❌ **Don't:** Compute Tailwind classes dynamically during SSR
```vue
<!-- Bad: SSR hydration mismatch -->
<div :class="isDark ? 'bg-gray-900' : 'bg-white'">
```

✅ **Do:** Use CSS variables for theme reactivity
```vue
<!-- Good: CSS handles reactivity -->
<div class="bg-background">
```

---

❌ **Don't:** Import global styles in Vue components
```vue
<script setup lang="ts">
import '@/styles/global.css'; // ❌ Duplicates
</script>
```

✅ **Do:** Import once in Astro layout
```astro
---
import '../styles/global.css'; // ✅ Single import
---
```

---

❌ **Don't:** Create plugins for simple utilities
```javascript
// Over-engineered
plugin(({ addUtilities }) => {
  addUtilities({ '.content-auto': { 'content-visibility': 'auto' } });
});
```

✅ **Do:** Use `@utility` directive
```css
@utility content-auto {
  content-visibility: auto;
}
```

---

❌ **Don't:** Use `theme` to override (removes defaults)
```javascript
module.exports = {
  theme: {
    colors: { primary: '#3f3cbb' } // ❌ Removes all default colors
  }
}
```

✅ **Do:** Use `@theme` to extend
```css
@theme {
  --color-primary: #3f3cbb; /* ✅ Adds to defaults */
}
```

### Performance Optimizations

1. **Purge Unused Styles**
   - Ensure `content` array includes all template files
   - Use PurgeCSS safelist for dynamic classes

2. **Minimize CSS Variable Lookups**
   - Use `@theme inline` when referencing other variables
   - Avoid deeply nested variable references

3. **Optimize Animations**
   - Respect `prefers-reduced-motion`
   - Use `will-change` sparingly (only during animation)
   - Prefer `transform` and `opacity` for GPU acceleration

4. **Code Splitting**
   - Import component-specific styles via dynamic imports
   - Use Astro's built-in CSS bundling for critical styles

---

## Sources Referenced

1. **Tailwind CSS v4 Theme Documentation**
   https://tailwindcss.com/docs/theme
   *Theme variables, @theme directive, namespace organization*

2. **Simon Swiss - Tailwind v4 Multi-Theme Strategy**
   https://simonswiss.com/posts/tailwind-v4-multi-theme
   *CSS variable patterns, semantic color naming, dark mode*

3. **Namoku.dev - Dark Mode with Tailwind and Astro**
   https://namoku.dev/blog/darkmode-tailwind-astro/
   *SSR-safe implementation, View Transitions persistence*

4. **Tailwind CSS Plugins Documentation**
   https://tailwindcss.com/docs/plugins
   *Plugin architecture, addUtilities, matchUtilities patterns*

5. **Astro Styling Documentation**
   https://docs.astro.build/en/guides/styling/
   *Global styles organization, CSS import strategies*

6. **Vue School - Custom Transition Classes**
   https://vueschool.io/lessons/custom-vue-transition-classes-aka-tailwind-css-with-vue-transitions
   *Vue 3 Transition integration with Tailwind utilities*

7. **Motion.dev - Tailwind Integration Guide**
   https://motion.dev/docs/react-tailwind
   *Animation architecture, responsive animation scaling*

8. **Stack Overflow - Tailwind v4 Theme Variables**
   https://stackoverflow.com/questions/79691837/how-to-override-theme-variables-in-tailwindcss-v4-theme-vs-layer-theme-vs-r
   *@theme vs @layer theme vs :root clarification*

9. **Theme Fisher - Integrating Tailwind with Astro**
   https://themefisher.com/tailwind-css-with-astro
   *Setup guide, configuration patterns*

10. **Kevin Zuniga Cuellar - Dark Mode in Astro**
    https://www.kevinzunigacuellar.com/blog/dark-mode-in-astro/
    *Flash prevention, localStorage integration*

---

**Report compiled:** 2025-10-22
**Research scope:** 5 targeted searches (token-optimized)
**Primary focus:** Production-ready patterns for Tailwind v4 + Astro + Vue 3
