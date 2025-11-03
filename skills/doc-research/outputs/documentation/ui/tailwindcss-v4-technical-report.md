# Tailwind CSS v4.1.11 Technical Documentation

Ground-up rewrite optimized for performance and modern CSS, eliminating JavaScript configuration in favor of CSS-first design token management.

## Core Architecture

### Oxide Engine

Tailwind v4 uses the Rust-based Oxide engine:
- **5x faster full builds** vs v3
- **100x faster incremental builds** (microseconds)
- Builds without new CSS complete in <1ms
- Lightning CSS integrated for vendor prefixing, syntax transforms
- Built-in @import handling (no postcss-import needed)

### Browser Support

**Target browsers:**
- Safari 16.4+
- Chrome 111+
- Firefox 128+

**Requires:**
- `@property` (registered custom properties)
- `color-mix()` 
- Native cascade layers

v4.1+ includes fallbacks for older browsers (colors degrade gracefully in Safari 15).

## Installation & Setup

### With @tailwindcss/vite Plugin

```bash
# Install
pnpm install tailwindcss @tailwindcss/vite
```

**Vite configuration:**

```ts
// vite.config.ts
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    vue(),
    tailwindcss({
      // Optional: disable Lightning CSS optimization
      optimize: false,
      
      // Or keep Lightning CSS but disable minification
      optimize: {
        minify: false
      }
    })
  ]
})
```

**Astro 5.13.7 integration:**

```ts
// astro.config.mjs
import { defineConfig } from 'astro/config'
import vue from '@astrojs/vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  integrations: [vue()],
  vite: {
    plugins: [tailwindcss()]
  }
})
```

### CSS Entry Point

```css
/* src/styles/global.css */
@import "tailwindcss";

/* That's it! No more @tailwind directives */
```

## Design Tokens & @theme Directive

### Basic @theme Usage

Theme variables are CSS variables that instruct Tailwind to generate utility classes.

```css
@import "tailwindcss";

@theme {
  /* Colors - generates bg-*, text-*, border-* utilities */
  --color-brand-50: oklch(0.98 0.02 276);
  --color-brand-500: oklch(0.57 0.24 276);
  --color-brand-900: oklch(0.26 0.12 276);
  
  /* Spacing - generates p-*, m-*, gap-* utilities */
  --spacing-xs: 0.5rem;
  --spacing-2xl: 3rem;
  
  /* Typography */
  --font-display: "Inter", sans-serif;
  --text-xs: 0.75rem;
  --text-xs--line-height: 1rem;
  
  /* Shadows */
  --shadow-brutal: 4px 4px 0 0 black;
  
  /* Border radius */
  --radius-blob: 30% 70% 70% 30% / 30% 30% 70% 70%;
  
  /* Breakpoints */
  --breakpoint-tablet: 48rem;
  --breakpoint-desktop: 80rem;
  
  /* Animations */
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
  --animate-duration-fast: 150ms;
}
```

### @theme vs @theme inline

**Critical distinction:**

```css
/* @theme - Value references CSS variable */
@theme {
  --color-primary: #3b82f6;
}
/* Generates: */
.bg-primary {
  background-color: var(--color-primary);
}

/* @theme inline - Value inlined directly */
@theme inline {
  --color-primary: #3b82f6;
}
/* Generates: */
.bg-primary {
  background-color: #3b82f6;
}
```

**When to use each:**

```css
/* Use @theme for runtime overridable values */
@theme {
  --color-brand: oklch(0.57 0.24 276);
}

:root {
  --color-brand: oklch(0.57 0.24 276);
}

.dark {
  --color-brand: oklch(0.37 0.18 276); /* Overrides work */
}

/* Use @theme inline for indirection */
@theme inline {
  --color-primary: var(--semantic-primary);
}

:root {
  --semantic-primary: oklch(0.57 0.24 276);
}

.theme-blue {
  --semantic-primary: oklch(0.55 0.22 240);
}
```

**Best practice:** Use `@theme` by default. Only use `@theme inline` when you need CSS variable indirection for theming.

### Theme Variable Namespaces

Namespaces determine which utilities are generated:

```css
@theme {
  /* --color-* → bg-*, text-*, border-*, ring-*, etc. */
  --color-success: oklch(0.65 0.19 145);
  
  /* --font-* → font-* utilities */
  --font-mono: "Fira Code", monospace;
  
  /* --text-* → text-* utilities */
  --text-fluid: clamp(1rem, 2vw, 1.5rem);
  
  /* --spacing-* → p-*, m-*, gap-*, space-*, etc. */
  --spacing-gutter: clamp(1rem, 5vw, 3rem);
  
  /* --shadow-* → shadow-* utilities */
  --shadow-glow: 0 0 20px oklch(0.7 0.3 276 / 0.4);
  
  /* --radius-* → rounded-* utilities */
  --radius-xl: 1rem;
  
  /* --blur-* → blur-* utilities */
  --blur-heavy: 24px;
  
  /* --inset-* → inset-* utilities */
  --inset-safe: env(safe-area-inset-top);
  
  /* --width-* → w-* utilities */
  --width-prose: 65ch;
  
  /* --height-* → h-* utilities */
  --height-hero: 80vh;
  
  /* --breakpoint-* → responsive variants */
  --breakpoint-3xl: 1920px;
  
  /* --container-* → container query sizes */
  --container-card: 320px;
  
  /* --font-weight-* → font-* utilities */
  --font-weight-black: 900;
  
  /* --ease-* → arbitrary values for transitions */
  --ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
  
  /* --animate-* → animate-* utilities */
  --animate-spin: spin 1s linear infinite;
}
```

### Accessing Theme Variables in CSS

All theme variables are automatically exposed as CSS custom properties:

```css
@theme {
  --color-brand-500: oklch(0.57 0.24 276);
  --text-xl: 1.25rem;
  --text-xl--line-height: 1.75rem;
}

/* Available everywhere */
.custom-component {
  color: var(--color-brand-500);
  font-size: var(--text-xl);
  line-height: var(--text-xl--line-height);
}

/* In arbitrary values */
<div class="top-[calc(var(--spacing-4)*-1)]" />

/* Inline styles */
<div style={{ color: 'var(--color-brand-500)' }} />
```

### Overriding Default Theme

```css
/* Override specific values */
@theme {
  --color-blue-500: oklch(0.55 0.25 250); /* Custom blue */
}

/* Override entire namespace */
@theme {
  --color-*: initial; /* Remove all default colors */
  --color-white: #fff;
  --color-black: #000;
  --color-brand-100: oklch(0.95 0.05 276);
  --color-brand-500: oklch(0.57 0.24 276);
  --color-brand-900: oklch(0.26 0.12 276);
}

/* Disable entire default theme */
@theme {
  --*: initial;
}
```

### TypeScript Design Token Patterns

**Type-safe token references:**

```ts
// src/tokens.ts
export const tokens = {
  color: {
    brand: {
      50: 'oklch(0.98 0.02 276)',
      500: 'oklch(0.57 0.24 276)',
      900: 'oklch(0.26 0.12 276)'
    }
  },
  spacing: {
    xs: '0.5rem',
    xl: '2rem'
  }
} as const

export type ColorToken = keyof typeof tokens.color
export type SpacingToken = keyof typeof tokens.spacing

// Generate CSS from tokens
export function generateThemeCSS() {
  const entries = Object.entries(tokens.color.brand)
    .map(([key, value]) => `--color-brand-${key}: ${value};`)
  return entries.join('\n')
}
```

**Component token mapping:**

```vue
<script setup lang="ts">
interface ButtonTokens {
  padding: string
  backgroundColor: string
  textColor: string
}

const BUTTON_TOKENS: Record<'primary' | 'secondary', ButtonTokens> = {
  primary: {
    padding: 'var(--spacing-4)',
    backgroundColor: 'var(--color-brand-500)',
    textColor: 'var(--color-white)'
  },
  secondary: {
    padding: 'var(--spacing-3)',
    backgroundColor: 'var(--color-gray-200)',
    textColor: 'var(--color-gray-900)'
  }
}

const props = defineProps<{
  variant: 'primary' | 'secondary'
}>()

const tokens = BUTTON_TOKENS[props.variant]
</script>

<template>
  <button 
    :style="{
      padding: tokens.padding,
      backgroundColor: tokens.backgroundColor,
      color: tokens.textColor
    }"
    class="rounded-lg font-medium"
  >
    <slot />
  </button>
</template>
```

## global.css Patterns & Best Practices

### Recommended Structure

```css
/* global.css */

/* 1. Import Tailwind */
@import "tailwindcss";

/* 2. Define theme tokens */
@theme {
  /* Custom design tokens */
  --color-brand-500: oklch(0.57 0.24 276);
  --font-display: "Inter", system-ui, sans-serif;
  --spacing-section: clamp(2rem, 8vw, 6rem);
}

/* 3. Light/dark theme overrides */
@theme inline {
  --color-primary: var(--theme-primary);
}

:root {
  --theme-primary: oklch(0.57 0.24 276);
}

.dark {
  --theme-primary: oklch(0.37 0.18 276);
}

/* 4. Base layer - HTML element defaults */
@layer base {
  html {
    font-family: var(--font-sans);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  
  body {
    @apply bg-white text-gray-900 dark:bg-gray-950 dark:text-gray-50;
  }
  
  h1, h2, h3, h4, h5, h6 {
    font-weight: var(--font-weight-semibold);
  }
  
  /* Custom focus styles */
  :focus-visible {
    outline: 2px solid var(--color-blue-500);
    outline-offset: 2px;
  }
  
  /* Remove default margins from Markdown content */
  .prose > * + * {
    margin-top: var(--spacing-4);
  }
}

/* 5. Components layer - reusable patterns */
@layer components {
  .btn-primary {
    background-color: var(--color-brand-500);
    color: var(--color-white);
    padding: var(--spacing-3) var(--spacing-6);
    border-radius: var(--radius-lg);
    font-weight: var(--font-weight-medium);
  }
  
  .btn-primary:hover {
    background-color: var(--color-brand-600);
  }
  
  .card {
    background-color: var(--color-white);
    border-radius: var(--radius-xl);
    padding: var(--spacing-6);
    box-shadow: var(--shadow-lg);
  }
}

/* 6. Custom utilities */
@utility scrollbar-hidden {
  scrollbar-width: none;
  -ms-overflow-style: none;
}

@utility scrollbar-hidden::-webkit-scrollbar {
  display: none;
}

/* Functional utility with argument */
@utility debug {
  outline: 2px solid red;
  outline-offset: calc(--value() * -1px);
}

/* 7. Third-party overrides */
@layer components {
  /* Override library styles that need high specificity */
  .select2-container {
    @apply rounded-lg border-gray-300;
  }
}

/* 8. Regular CSS (when needed) */
.legacy-component {
  /* Sometimes you just need plain CSS */
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
}
```

### Dark Mode Pattern

```css
/* Method 1: @theme inline with CSS variables */
@theme inline {
  --color-background: var(--bg);
  --color-foreground: var(--fg);
  --color-primary: var(--primary);
}

:root {
  --bg: oklch(1 0 0);
  --fg: oklch(0.2 0 0);
  --primary: oklch(0.57 0.24 276);
}

.dark {
  --bg: oklch(0.2 0 0);
  --fg: oklch(0.95 0 0);
  --primary: oklch(0.67 0.24 276);
}

/* Method 2: Custom variant (more control) */
@custom-variant dark (&:where(.dark, .dark *));

@theme {
  --color-background: oklch(1 0 0);
}

@variant dark {
  @theme {
    --color-background: oklch(0.2 0 0);
  }
}
```

### Multi-Theme Pattern

```css
/* Define semantic color mappings */
@theme inline {
  --color-primary: var(--theme-primary);
  --color-secondary: var(--theme-secondary);
  --color-accent: var(--theme-accent);
}

/* Default theme */
:root {
  --theme-primary: oklch(0.57 0.24 276);
  --theme-secondary: oklch(0.55 0.22 240);
  --theme-accent: oklch(0.65 0.28 150);
}

/* Alternate themes */
[data-theme="ocean"] {
  --theme-primary: oklch(0.55 0.18 220);
  --theme-secondary: oklch(0.65 0.15 180);
  --theme-accent: oklch(0.75 0.12 200);
}

[data-theme="sunset"] {
  --theme-primary: oklch(0.65 0.22 40);
  --theme-secondary: oklch(0.55 0.25 20);
  --theme-accent: oklch(0.75 0.18 60);
}
```

### Font Configuration

```css
@theme {
  --font-sans: "Inter", system-ui, sans-serif;
  --font-serif: "Playfair Display", Georgia, serif;
  --font-mono: "Fira Code", "Cascadia Code", monospace;
}

/* Ensure fonts are loaded */
@layer base {
  @font-face {
    font-family: "Inter";
    src: url("/fonts/Inter-Variable.woff2") format("woff2");
    font-weight: 100 900;
    font-display: swap;
  }
}

/* Font features */
@layer base {
  .font-sans {
    font-feature-settings: "cv02", "cv03", "cv04", "cv11";
  }
  
  .font-mono {
    font-variant-ligatures: common-ligatures;
    font-feature-settings: "liga", "calt";
  }
}
```

## @layer Directive in v4

### Layer System Overview

```css
/* Define layer order (optional, has sensible defaults) */
@layer theme, base, components, utilities;

/* Import Tailwind (automatically creates layers) */
@import "tailwindcss";

/* Equivalent to: */
@import "tailwindcss/theme.css" layer(theme);
@import "tailwindcss/preflight.css" layer(base);
@import "tailwindcss/utilities.css" layer(utilities);
```

### Base Layer

Global element defaults. Lowest specificity.

```css
@layer base {
  /* Reset/normalize */
  *, ::before, ::after {
    box-sizing: border-box;
  }
  
  /* Element defaults */
  html {
    font-size: 16px;
    scroll-behavior: smooth;
  }
  
  body {
    margin: 0;
    line-height: 1.5;
  }
  
  img, picture, video, canvas, svg {
    display: block;
    max-width: 100%;
  }
  
  button, input, textarea, select {
    font: inherit;
  }
  
  /* Accessibility */
  .sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border-width: 0;
  }
}
```

### Components Layer

Reusable multi-property patterns. Can be overridden by utilities.

```css
@layer components {
  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: var(--spacing-2) var(--spacing-4);
    border-radius: var(--radius-md);
    font-weight: var(--font-weight-medium);
    transition-property: color, background-color, border-color;
    transition-duration: 150ms;
  }
  
  .btn-primary {
    background-color: var(--color-brand-500);
    color: var(--color-white);
  }
  
  .btn-primary:hover {
    background-color: var(--color-brand-600);
  }
  
  /* Can be overridden */
  .btn.rounded-none {
    border-radius: 0; /* Utility wins */
  }
}
```

### Custom Utilities with @utility

In v4, `@layer` doesn't hijack CSS cascade layers. Use `@utility` for custom classes:

```css
/* Simple utility */
@utility text-balance {
  text-wrap: balance;
}

/* Utility with layer placement */
@utility text-pretty {
  @layer utilities {
    text-wrap: pretty;
  }
}

/* Functional utility */
@utility debug {
  outline: 2px solid red;
  outline-offset: calc(--value() * -1px);
}

/* Usage: debug-2 generates outline-offset: -2px */

/* Utility with theme key resolution */
@utility backdrop {
  backdrop-filter: blur(--value(--blur-*));
}

/* Usage: backdrop-sm, backdrop-lg, etc. */

/* Complex utility with variants */
@utility card {
  background-color: var(--color-white);
  border-radius: var(--radius-lg);
  padding: var(--spacing-6);
  box-shadow: var(--shadow-md);
  
  @nest &:hover {
    box-shadow: var(--shadow-lg);
  }
}
```

**CRITICAL:** In v4, cannot use `@apply` inside `@layer base` or `@layer components` without first defining utilities with `@utility`.

```css
/* ❌ FAILS in v4 */
@layer components {
  .card {
    @apply rounded-lg p-6 shadow-md;
  }
}

/* ✅ CORRECT - Use @utility */
@utility card {
  @apply rounded-lg p-6 shadow-md;
}

/* ✅ CORRECT - Or use CSS directly */
@layer components {
  .card {
    border-radius: var(--radius-lg);
    padding: var(--spacing-6);
    box-shadow: var(--shadow-md);
  }
}
```

### Custom Cascade Layers

Create additional layers for fine-grained control:

```css
/* Define custom layer order */
@layer theme, base, vendor, components, utilities, overrides;

@import "tailwindcss/theme.css" layer(theme);
@import "tailwindcss/preflight.css" layer(base);
@import "tailwindcss/utilities.css" layer(utilities);

/* Third-party styles in their own layer */
@import "some-library.css" layer(vendor);

/* Your components */
@layer components {
  .my-component { /* ... */ }
}

/* Emergency overrides (use sparingly) */
@layer overrides {
  .important-fix {
    /* Beats utilities due to layer order */
  }
}
```

## Container Queries

Built-in support for styling based on container size (no plugin needed).

### Basic Usage

```vue
<template>
  <div class="@container">
    <div class="grid grid-cols-1 @sm:grid-cols-2 @lg:grid-cols-4">
      <!-- Responds to container width, not viewport -->
    </div>
  </div>
</template>
```

### Container Sizes (Default)

```css
/* Available by default: */
@xs   /* 20rem */
@sm   /* 24rem */
@md   /* 28rem */
@lg   /* 32rem */
@xl   /* 36rem */
@2xl  /* 42rem */
@3xl  /* 48rem */
@4xl  /* 56rem */
@5xl  /* 64rem */
@6xl  /* 72rem */
@7xl  /* 80rem */
```

### Custom Container Sizes

```css
@theme {
  --container-card: 20rem;
  --container-sidebar: 16rem;
  --container-content: 48rem;
}

/* Usage: @card:*, @sidebar:*, @content:* */
```

### Named Containers

```vue
<template>
  <div class="@container/sidebar">
    <aside class="w-full @lg/sidebar:w-64">
      <!-- Responds to 'sidebar' container -->
    </aside>
  </div>
  
  <div class="@container/main">
    <article class="@xl/main:columns-2">
      <!-- Responds to 'main' container -->
    </article>
  </div>
</template>
```

### Max-Width Container Queries

```vue
<template>
  <div class="@container">
    <div class="
      grid
      @max-md:grid-cols-1
      @md:grid-cols-2
      @lg:grid-cols-3
    ">
      <!-- Collapses when container is below @md -->
    </div>
  </div>
</template>
```

### Container Units (cqw, cqh)

```vue
<template>
  <div class="@container">
    <!-- 10% of container width -->
    <div class="text-[10cqw]">
      Scales with container
    </div>
    
    <!-- Responsive calculation -->
    <div class="p-[calc(5cqw+1rem)]">
      Fluid padding
    </div>
  </div>
</template>
```

### Container vs Media Queries

**Container queries:** Component responds to available space
**Media queries:** Component responds to viewport size

```vue
<template>
  <!-- Container query: adapts to parent -->
  <div class="@container w-1/2">
    <div class="@lg:flex-row flex-col">
      <!-- Changes at container threshold -->
    </div>
  </div>
  
  <!-- Media query: adapts to viewport -->
  <div class="w-1/2">
    <div class="lg:flex-row flex-col">
      <!-- Changes at viewport threshold -->
    </div>
  </div>
</template>
```

### Practical Patterns

**Responsive card:**

```vue
<script setup lang="ts">
interface Product {
  name: string
  image: string
  price: number
}

defineProps<{
  product: Product
}>()
</script>

<template>
  <div class="@container">
    <article class="
      flex flex-col
      @md:flex-row
      rounded-lg border
      overflow-hidden
    ">
      <img 
        :src="product.image"
        class="w-full @md:w-1/3 object-cover"
      />
      <div class="p-4 @md:p-6">
        <h3 class="text-lg @md:text-xl font-semibold">
          {{ product.name }}
        </h3>
        <p class="text-2xl @md:text-3xl font-bold mt-2">
          ${{ product.price }}
        </p>
      </div>
    </article>
  </div>
</template>
```

**Dashboard widgets:**

```vue
<template>
  <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
    <div 
      v-for="widget in widgets" 
      :key="widget.id"
      class="@container"
    >
      <div class="
        rounded-lg border p-4
        @xs:p-6
      ">
        <h2 class="text-base @xs:text-lg font-semibold">
          {{ widget.title }}
        </h2>
        <div class="
          grid grid-cols-1
          @xs:grid-cols-2
          @sm:grid-cols-3
          gap-2 mt-4
        ">
          <!-- Widget content adapts to widget size -->
        </div>
      </div>
    </div>
  </div>
</template>
```

## Modern CSS Features

### Wide-Gamut Colors (OKLCH)

```css
@theme {
  /* P3 color space - more vivid on modern displays */
  --color-brand-500: oklch(0.57 0.24 276);
  
  /* Fallback for older browsers automatically handled */
  /* Old Safari gets: rgb(approximation) */
}

/* Manual P3 with fallback */
.custom {
  background: rgb(59 130 246); /* Fallback */
  background: oklch(0.57 0.24 276); /* P3 */
}
```

### 3D Transforms

```vue
<template>
  <!-- Perspective container -->
  <div class="perspective-distant">
    <!-- 3D transforms -->
    <div class="
      rotate-x-12
      rotate-y-45
      rotate-z-6
      transform-3d
      hover:rotate-x-0
      transition-transform
    ">
      3D Card
    </div>
  </div>
</template>
```

### @starting-style (Enter/Exit Transitions)

```vue
<script setup lang="ts">
import { ref } from 'vue'

const isOpen = ref(false)
</script>

<template>
  <button @click="isOpen = !isOpen">
    Toggle
  </button>
  
  <div
    v-if="isOpen"
    class="
      opacity-100
      translate-y-0
      transition-all
      duration-300
      starting:opacity-0
      starting:translate-y-4
    "
  >
    Animates in from starting state
  </div>
</template>
```

### not-* Variant

```vue
<template>
  <!-- Apply when NOT matching condition -->
  <div class="
    text-gray-900
    not-hover:opacity-50
    not-focus:ring-0
    not-disabled:cursor-pointer
  ">
    Interactive element
  </div>
  
  <!-- Combine with other variants -->
  <button class="
    bg-blue-500
    hover:bg-blue-600
    not-hover:shadow-none
    disabled:opacity-50
    not-disabled:hover:scale-105
  ">
    Button
  </button>
</template>
```

### color-scheme Support

```css
@layer base {
  html {
    color-scheme: light dark;
  }
}

/* Utility classes */
<html class="color-scheme-light" />
<html class="color-scheme-dark" />
<html class="color-scheme-light-dark" />
```

### field-sizing

```vue
<template>
  <!-- Auto-sizing textarea -->
  <textarea 
    class="field-sizing-content w-full"
    placeholder="Grows with content..."
  />
  
  <!-- Fixed sizing (default) -->
  <textarea class="field-sizing-fixed h-32" />
</template>
```

### Inert Styling

```vue
<template>
  <dialog :inert="!isActive">
    <div class="
      inert:opacity-50
      inert:pointer-events-none
      inert:blur-sm
    ">
      Dialog content
    </div>
  </dialog>
</template>
```

### Radial & Conic Gradients

```vue
<template>
  <!-- Radial gradient -->
  <div class="
    bg-gradient-radial
    from-blue-500
    via-purple-500
    to-pink-500
  " />
  
  <!-- Conic gradient -->
  <div class="
    bg-gradient-conic
    from-red-500
    via-yellow-500
    to-green-500
  " />
  
  <!-- With interpolation mode -->
  <div class="
    bg-gradient-to-r
    from-blue-500
    to-pink-500
    in-oklch
  " />
</template>
```

### Complex Shadows

```css
@theme {
  /* Multi-layer shadows */
  --shadow-brutal: 
    4px 4px 0 0 black,
    8px 8px 0 0 rgb(0 0 0 / 0.2);
    
  --shadow-glow:
    0 0 20px oklch(0.7 0.3 276 / 0.4),
    0 0 40px oklch(0.7 0.3 276 / 0.2);
}
```

## Performance & Optimization

### Lightning CSS

Automatically enabled in production (via `@tailwindcss/vite`):
- Vendor prefixing
- Syntax lowering (modern → compatible CSS)
- Minification
- Dead code elimination

```ts
// Disable if needed
tailwindcss({
  optimize: false
})
```

### Content Detection

Zero configuration. Automatically scans:
- All files (respects `.gitignore`)
- Ignores binary files (images, videos, etc.)
- No `content` array needed

**Manual control:**

```css
/* Include specific paths */
@source "../components/**/*.vue";
@source "../pages/**/*.astro";

/* Inline content (safelist) */
@source inline() {
  /* Classes that must always exist */
  .dynamic-class-1
  .dynamic-class-2
}
```

### Build Performance

**Full rebuild:** ~200-500ms (3.5x faster than v3)
**Incremental rebuild:** <1ms (100x faster than v3)

**Tips:**
- Use `@theme` tokens instead of arbitrary values when possible
- Minimize `@layer` complexity
- Leverage content detection instead of manual configuration

### Runtime Performance

All theme variables are CSS custom properties:
- **No runtime overhead** for theme value lookups
- **Animatable** (gradients, transforms, etc.)
- **Debuggable** in DevTools

## TypeScript Integration

### Type-Safe Utilities

```ts
// src/utils/cn.ts
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

// Usage
import { cn } from '@/utils/cn'

const classes = cn(
  'base-class',
  isActive && 'active-class',
  { 'conditional-class': someCondition }
)
```

### Component Props with Tailwind Classes

```vue
<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md'
})

const variantClasses: Record<Props['variant'], string> = {
  primary: 'bg-brand-500 text-white hover:bg-brand-600',
  secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300',
  ghost: 'bg-transparent hover:bg-gray-100'
}

const sizeClasses: Record<Props['size'], string> = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg'
}

const classes = computed(() => cn(
  'rounded-lg font-medium transition-colors',
  variantClasses[props.variant],
  sizeClasses[props.size],
  props.class
))
</script>

<template>
  <button :class="classes">
    <slot />
  </button>
</template>
```

### Autocomplete (VSCode)

**Tailwind CSS IntelliSense Extension:**

```json
// .vscode/settings.json
{
  "tailwindCSS.experimental.classRegex": [
    // Vue class attribute
    ["class\\s*=\\s*['\"]([^'\"]*)['\"]"],
    // Vue :class binding
    [":class\\s*=\\s*['\"]([^'\"]*)['\"]"],
    // cn() function
    ["cn\\(([^)]*)\\)"],
    // clsx/classnames
    ["clsx\\(([^)]*)\\)"],
    // @apply directive
    ["@apply\\s+([^;{]+)"]
  ],
  "tailwindCSS.includeLanguages": {
    "vue": "html",
    "astro": "html"
  }
}
```

## Astro + Vue Integration

### Project Structure

```
project/
├── src/
│   ├── styles/
│   │   └── global.css          # @import "tailwindcss"
│   ├── components/
│   │   ├── Button.vue
│   │   └── Card.astro
│   ├── layouts/
│   │   └── Layout.astro
│   └── pages/
│       └── index.astro
├── astro.config.mjs
└── vite.config.ts (if needed)
```

### Layout Integration

```astro
---
// src/layouts/Layout.astro
import '@/styles/global.css'

interface Props {
  title: string
}

const { title } = Astro.props
---

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>{title}</title>
  </head>
  <body class="bg-white text-gray-900 dark:bg-gray-950 dark:text-gray-50">
    <slot />
  </body>
</html>
```

### Vue Component with Tailwind

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'

interface Props {
  variant?: 'default' | 'outlined'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default'
})

const isHovered = ref(false)

const cardClasses = computed(() => [
  'rounded-xl p-6 transition-all duration-300',
  props.variant === 'default' 
    ? 'bg-white shadow-lg hover:shadow-xl' 
    : 'border-2 border-gray-200 hover:border-brand-500'
])
</script>

<template>
  <div 
    :class="cardClasses"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <slot />
  </div>
</template>
```

### Astro Component with Vue

```astro
---
// src/components/ProductCard.astro
import Card from './Card.vue'

interface Props {
  title: string
  price: number
}

const { title, price } = Astro.props
---

<Card client:load variant="default">
  <h3 class="text-xl font-semibold mb-2">
    {title}
  </h3>
  <p class="text-2xl font-bold text-brand-500">
    ${price}
  </p>
</Card>
```

### SSR Considerations

Tailwind classes work in both SSR and CSR contexts:

```vue
<script setup lang="ts">
// Runs server-side and client-side
const classes = 'bg-blue-500 text-white p-4'
</script>

<template>
  <!-- Classes applied during SSR -->
  <div :class="classes">
    Content
  </div>
</template>
```

**Dynamic classes with hydration:**

```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'

// Safe: runs both server and client
const baseClasses = 'p-4 rounded-lg'

// Client-only: starts empty, updates after mount
const dynamicClasses = ref('')

onMounted(() => {
  dynamicClasses.value = 'bg-blue-500'
})
</script>

<template>
  <div :class="[baseClasses, dynamicClasses]">
    Hydration-safe styling
  </div>
</template>
```

## Migration from v3

### Automated Tool

```bash
# Requires Node 20+
npx @tailwindcss/upgrade@next
```

Handles:
- Dependency updates
- Config migration to CSS
- Template file updates
- Variant order changes

### Breaking Changes

**1. No more `content` array** - automatic detection

```js
// v3 - tailwind.config.js
module.exports = {
  content: ['./src/**/*.{astro,html,js,jsx,vue}']
}

// v4 - Not needed! Auto-detected.
// Override with @source if needed
```

**2. @import replaces @tailwind directives**

```css
/* v3 */
@tailwind base;
@tailwind components;
@tailwind utilities;

/* v4 */
@import "tailwindcss";
```

**3. Configuration in CSS, not JS**

```js
// v3 - tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: '#3b82f6'
      }
    }
  }
}
```

```css
/* v4 - global.css */
@import "tailwindcss";

@theme {
  --color-brand: #3b82f6;
}
```

**4. Variant order changed (left-to-right)**

```html
<!-- v3 - applied right to left -->
<ul class="first:*:pt-0 last:*:pb-0">

<!-- v4 - applied left to right -->
<ul class="*:first:pt-0 *:last:pb-0">
```

**5. Preflight changes**

```css
/* v3 */
::placeholder {
  color: theme('colors.gray.400');
}

/* v4 */
::placeholder {
  color: currentColor;
  opacity: 0.5;
}

/* v3 */
button {
  cursor: pointer;
}

/* v4 */
button {
  cursor: default; /* Matches browser default */
}

/* Override if needed */
@layer base {
  button {
    cursor: pointer;
  }
}
```

**6. Border and ring defaults**

```css
/* v3 */
.border {
  border-color: theme('colors.gray.200');
}

/* v4 */
.border {
  border-color: currentColor;
}

/* v3 */
.ring {
  ring-color: theme('colors.blue.500');
  ring-width: 3px;
}

/* v4 */
.ring {
  ring-color: currentColor;
  ring-width: 1px;
}
```

**7. @layer behavior**

```css
/* v3 - Tailwind hijacks @layer */
@layer components {
  .btn {
    @apply bg-blue-500; /* Works */
  }
}

/* v4 - @layer is native CSS */
@layer components {
  .btn {
    @apply bg-blue-500; /* ERROR */
  }
}

/* v4 - Use @utility or CSS */
@utility btn {
  @apply bg-blue-500;
}

/* Or */
@layer components {
  .btn {
    background-color: var(--color-blue-500);
  }
}
```

### Gradual Migration Strategy

**1. Keep v3 config for compatibility**

```css
/* Load v3 config */
@config "./tailwind.config.js";

/* Mix with v4 @theme */
@theme {
  --color-new-brand: oklch(0.57 0.24 276);
}
```

**2. Load legacy plugins**

```css
@plugin "@tailwindcss/typography";
@plugin "./my-plugin.js";
```

**3. Migrate incrementally**

- Move theme to `@theme` gradually
- Keep working JS config during transition
- Update one namespace at a time

```css
/* Step 1: Migrate colors */
@theme {
  --color-*: initial;
  --color-brand-500: oklch(0.57 0.24 276);
  /* ... more colors */
}

/* Step 2: Keep other config in JS for now */
@config "./tailwind.config.js";

/* Step 3: Migrate spacing next */
@theme {
  --spacing-*: initial;
  --spacing-xs: 0.5rem;
  /* ... */
}
```

## Common Gotchas & Edge Cases

### 1. @theme Order Matters

```css
/* ❌ WRONG - @theme must come before usage */
:root {
  --bg: oklch(1 0 0);
}

@theme inline {
  --color-background: var(--bg); /* --bg not defined yet */
}

/* ✅ CORRECT */
:root {
  --bg: oklch(1 0 0);
}

@theme inline {
  --color-background: var(--bg);
}
```

### 2. Can't Nest @theme in Media Queries

```css
/* ❌ WRONG */
@media (prefers-color-scheme: dark) {
  @theme {
    --color-background: oklch(0.2 0 0);
  }
}

/* ✅ CORRECT - Use @theme inline + CSS variables */
@theme inline {
  --color-background: var(--bg);
}

:root {
  --bg: oklch(1 0 0);
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: oklch(0.2 0 0);
  }
}
```

### 3. @import Order Matters

```css
/* ❌ WRONG - @import must be first */
@theme {
  --color-brand: red;
}

@import "tailwindcss";

/* ✅ CORRECT */
@import "tailwindcss";

@theme {
  --color-brand: red;
}
```

### 4. Dynamic Class Concatenation

```vue
<script setup lang="ts">
// ❌ WRONG - Tailwind can't detect classes
const size = 'lg'
const className = `text-${size}` // text-lg won't be generated

// ✅ CORRECT - Use complete class names
const className = size === 'lg' ? 'text-lg' : 'text-sm'

// ✅ CORRECT - Or safelist in CSS
</script>
```

```css
@source inline() {
  /* Safelist dynamic classes */
  .text-sm
  .text-md
  .text-lg
  .text-xl
}
```

### 5. @apply with @layer

```css
/* ❌ FAILS in v4 */
@layer components {
  .btn {
    @apply bg-blue-500 text-white;
  }
}

/* ✅ Use @utility */
@utility btn {
  @apply bg-blue-500 text-white;
}

/* ✅ Or use CSS */
@layer components {
  .btn {
    background-color: var(--color-blue-500);
    color: var(--color-white);
  }
}
```

### 6. Container Query Naming Conflicts

```vue
<!-- ❌ Ambiguous -->
<div class="@container">
  <div class="@container">
    <div class="@lg:flex-row">
      <!-- Which container? -->
    </div>
  </div>
</div>

<!-- ✅ Named containers -->
<div class="@container/outer">
  <div class="@container/inner">
    <div class="@lg/outer:flex-row">
      <!-- Explicit -->
    </div>
  </div>
</div>
```

### 7. Dark Mode with @theme inline

```css
/* ❌ Won't work - hardcoded value */
@theme inline {
  --color-background: oklch(1 0 0);
}

.dark {
  --color-background: oklch(0.2 0 0); /* No effect */
}

/* ✅ Use indirection */
@theme inline {
  --color-background: var(--bg);
}

:root {
  --bg: oklch(1 0 0);
}

.dark {
  --bg: oklch(0.2 0 0);
}
```

### 8. Third-Party CSS with @layer

```css
/* ❌ Imports third-party CSS with @layer base */
@import "some-library.css";

/* Error: no matching @tailwind base directive */

/* ✅ Use layer() syntax */
@layer theme, base, vendor, utilities;

@import "tailwindcss/theme.css" layer(theme);
@import "tailwindcss/preflight.css" layer(base);
@import "some-library.css" layer(vendor);
@import "tailwindcss/utilities.css" layer(utilities);
```

### 9. Arbitrary Values with Theme Variables

```vue
<template>
  <!-- ❌ Wrong syntax -->
  <div class="text-[--color-brand-500]" />
  
  <!-- ✅ Correct -->
  <div class="text-[var(--color-brand-500)]" />
  
  <!-- ✅ Better - use utility directly -->
  <div class="text-brand-500" />
</template>
```

### 10. SSR Hydration with Dynamic Classes

```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'

// ❌ Causes hydration mismatch
const classes = ref(
  typeof window !== 'undefined' 
    ? 'client-class' 
    : 'server-class'
)

// ✅ Defer client-only classes to onMounted
const classes = ref('server-class')

onMounted(() => {
  classes.value = 'client-class'
})
</script>
```

## Best Practices

### 1. Prefer @theme for Scalability

```css
/* ✅ Maintainable */
@theme {
  --color-primary: oklch(0.57 0.24 276);
  --color-secondary: oklch(0.55 0.22 240);
}

/* ❌ Harder to maintain */
.btn-primary {
  background: oklch(0.57 0.24 276);
}
```

### 2. Use Semantic Color Names

```css
/* ✅ Semantic */
@theme {
  --color-brand-primary: oklch(0.57 0.24 276);
  --color-brand-accent: oklch(0.65 0.28 150);
  --color-success: oklch(0.65 0.19 145);
  --color-error: oklch(0.55 0.22 25);
}

/* ❌ Implementation-focused */
@theme {
  --color-blue-thing: oklch(0.57 0.24 276);
  --color-special-green: oklch(0.65 0.28 150);
}
```

### 3. Document Theme Structure

```css
/**
 * Theme Structure
 * 
 * Colors:
 *   --color-brand-*: Primary brand colors (50-950)
 *   --color-semantic-*: Functional colors (success, error, etc.)
 *   --color-surface-*: Background surfaces
 * 
 * Spacing:
 *   --spacing-*: Standard spacing scale
 *   --spacing-section-*: Layout-specific spacing
 * 
 * Typography:
 *   --font-*: Font families
 *   --text-*: Font sizes with line heights
 */
 
@theme {
  /* Implementation follows... */
}
```

### 4. Leverage Container Queries

```vue
<!-- ✅ Component responds to available space -->
<div class="@container">
  <MyComponent class="@lg:grid-cols-3" />
</div>

<!-- ❌ Component tied to viewport -->
<MyComponent class="lg:grid-cols-3" />
```

### 5. Minimize @apply Usage

```vue
<!-- ✅ Preferred -->
<button class="
  px-4 py-2
  bg-brand-500 hover:bg-brand-600
  text-white rounded-lg
">
  Button
</button>

<!-- ❌ Avoid -->
<style>
.btn {
  @apply px-4 py-2 bg-brand-500 hover:bg-brand-600 text-white rounded-lg;
}
</style>
```

**When @apply is acceptable:**
- Third-party library overrides
- Very complex, repeated patterns
- Generated/template code

### 6. Component-Scoped Tokens

```vue
<script setup lang="ts">
// Define component tokens as CSS variables
const cardTokens = {
  '--card-padding': 'var(--spacing-6)',
  '--card-radius': 'var(--radius-xl)',
  '--card-shadow': 'var(--shadow-lg)'
}
</script>

<template>
  <div 
    :style="cardTokens"
    class="p-[--card-padding] rounded-[--card-radius] shadow-[--card-shadow]"
  >
    <slot />
  </div>
</template>
```

### 7. Type-Safe Variant Patterns

```ts
// utils/variants.ts
export const buttonVariants = {
  variant: {
    primary: 'bg-brand-500 hover:bg-brand-600 text-white',
    secondary: 'bg-gray-200 hover:bg-gray-300 text-gray-900',
    ghost: 'hover:bg-gray-100'
  },
  size: {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2',
    lg: 'px-6 py-3 text-lg'
  }
} as const

export type ButtonVariant = keyof typeof buttonVariants.variant
export type ButtonSize = keyof typeof buttonVariants.size
```

### 8. Progressive Enhancement

```vue
<template>
  <!-- Works without @container support -->
  <div class="grid grid-cols-1 md:grid-cols-3">
    <!-- Content -->
  </div>
  
  <!-- Enhanced with container queries -->
  <div class="@container">
    <div class="grid grid-cols-1 @md:grid-cols-3">
      <!-- Better: adapts to container -->
    </div>
  </div>
</template>
```

### 9. Organize Utilities by Function

```css
@import "tailwindcss";

/* Design tokens */
@theme { /* ... */ }

/* Base styles */
@layer base { /* ... */ }

/* Layout utilities */
@utility container-prose {
  max-width: 65ch;
  margin-inline: auto;
}

/* Component utilities */
@utility card { /* ... */ }

/* Animation utilities */
@utility slide-in { /* ... */ }
```

### 10. Performance-First Approach

```vue
<script setup lang="ts">
// ✅ Static classes - generated at build time
const baseClasses = 'p-4 rounded-lg shadow-md'

// ✅ Conditional classes - still static
const variantClasses = computed(() =>
  props.variant === 'primary' 
    ? 'bg-blue-500 text-white'
    : 'bg-gray-200 text-gray-900'
)

// ❌ Avoid runtime concatenation
const dynamicClasses = computed(() => 
  `text-${props.size}` // Can't be statically analyzed
)

// ✅ Map to complete class names
const sizeClasses = computed(() => ({
  sm: 'text-sm',
  md: 'text-base',
  lg: 'text-lg'
}[props.size]))
</script>
```

## Debugging & Tooling

### Browser DevTools

Theme variables visible in inspector:

```css
/* Inspect element shows: */
element.style {
  /* Your inline styles */
}

:root {
  --color-brand-500: oklch(0.57 0.24 276);
  --spacing-4: 1rem;
  /* All theme variables visible here */
}
```

### VSCode IntelliSense

```json
// .vscode/settings.json
{
  "tailwindCSS.experimental.configFile": null,
  "tailwindCSS.experimental.classRegex": [
    ["class\\s*=\\s*['\"]([^'\"]*)['\"]"],
    [":class\\s*=\\s*['\"]([^'\"]*)['\"]"],
    ["className\\s*=\\s*['\"]([^'\"]*)['\"]"],
    ["cn\\(([^)]*)\\)"]
  ],
  "files.associations": {
    "*.css": "tailwindcss"
  }
}
```

### Build Warnings

```bash
# Enable verbose logging
DEBUG=tailwindcss:* pnpm dev

# Check for unused theme variables
# (No built-in tool yet, manually verify)
```

### Testing Responsive Behavior

```vue
<script setup lang="ts">
import { onMounted } from 'vue'

onMounted(() => {
  // Log container query support
  console.log(
    'Container queries supported:',
    CSS.supports('container-type', 'inline-size')
  )
  
  // Log current theme values
  const root = document.documentElement
  const brandColor = getComputedStyle(root)
    .getPropertyValue('--color-brand-500')
  console.log('Brand color:', brandColor)
})
</script>
```

## Quick Reference

```css
/* Complete setup template */
@import "tailwindcss";

/* Design tokens */
@theme {
  --color-brand-500: oklch(0.57 0.24 276);
  --font-display: "Inter", sans-serif;
  --spacing-section: clamp(2rem, 8vw, 6rem);
  --radius-xl: 1rem;
  --breakpoint-tablet: 48rem;
}

/* Theming with indirection */
@theme inline {
  --color-primary: var(--theme-primary);
}

:root {
  --theme-primary: oklch(0.57 0.24 276);
}

.dark {
  --theme-primary: oklch(0.37 0.18 276);
}

/* Base styles */
@layer base {
  html {
    font-family: var(--font-display);
  }
}

/* Component patterns */
@utility btn {
  @apply px-4 py-2 rounded-lg font-medium;
}

/* Custom utility */
@utility scrollbar-hidden {
  scrollbar-width: none;
}
```

```vue
<!-- Complete component template -->
<script setup lang="ts">
import { computed } from 'vue'
import { cn } from '@/utils/cn'

interface Props {
  variant?: 'primary' | 'secondary'
  size?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md'
})

const classes = computed(() => cn(
  'rounded-lg font-medium transition-colors',
  {
    'bg-brand-500 text-white hover:bg-brand-600': props.variant === 'primary',
    'bg-gray-200 text-gray-900 hover:bg-gray-300': props.variant === 'secondary'
  },
  {
    'px-3 py-1.5 text-sm': props.size === 'sm',
    'px-4 py-2': props.size === 'md',
    'px-6 py-3 text-lg': props.size === 'lg'
  }
))
</script>

<template>
  <!-- Container query responsive -->
  <div class="@container">
    <button :class="classes">
      <slot />
    </button>
  </div>
</template>
```

## Version-Specific Notes

### v4.1.11 (Current)

**New features:**
- `text-shadow-*` utilities
- `mask-*` utilities (image/gradient masking)
- `overflow-wrap` utilities (`wrap-break-word`, `wrap-anywhere`)
- Improved browser compatibility fallbacks
- Better OKLCH support in older browsers

**Astro 5.13.7 compatibility:** Fully supported via `@tailwindcss/vite`

**Vue 3.5.17 compatibility:** No issues, works seamlessly in SFCs

**TypeScript 5.8.3:** Full autocomplete support with IntelliSense extension
