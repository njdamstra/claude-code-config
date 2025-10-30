---
name: Add Dark Mode to Components
type: styling
status: production-ready
updated: 2025-10-16
---

# Workflow: Add Dark Mode to Components

**Goal**: Implement dark mode support with Tailwind CSS and persistent user preference

**Duration**: 1-2 hours
**Complexity**: Medium
**Tech**: Tailwind `dark:` variants, Nanostores, localStorage

---

## Steps

### 1. Research Patterns
Use `/frontend-research "Tailwind dark mode patterns"`

**Agent**: `tailwind-styling-expert` researches best practices

**Learn about:**
- Tailwind dark mode strategies (class vs system)
- CSS variables vs utility classes
- Performance considerations
- Browser support

### 2. Update Components
Use `/style src/components/vue/cards/*.vue`

**Agent**: `tailwind-styling-expert` applies `dark:` variants

**Pattern:**
```vue
<template>
  <div class="
    p-4 md:p-6 lg:p-8
    bg-white dark:bg-gray-800
    text-gray-900 dark:text-white
    border border-gray-200 dark:border-gray-700
    rounded-lg
    shadow-md dark:shadow-gray-900/50
  ">
    <!-- Content -->
  </div>
</template>
```

**Apply to:**
- All background colors
- All text colors
- All border colors
- All shadows
- Interactive states (hover, focus)

### 3. Create Toggle Component
Use `/component create DarkModeToggle`

**Agent**: `vue-architect` creates toggle component

**Implements:**
- Toggle button/switch
- Icon changes (sun/moon)
- Accessible (ARIA labels)
- Smooth transition

**Example:**
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue';
import { darkMode, toggleDarkMode } from '@/stores/themeStore';

const isDark = useStore(darkMode);
</script>

<template>
  <button
    @click="toggleDarkMode"
    aria-label="Toggle dark mode"
    class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700"
  >
    <Icon v-if="isDark" name="mdi:white-balance-sunny" />
    <Icon v-else name="mdi:moon-waning-crescent" />
  </button>
</template>
```

### 4. Create Theme Store
**Agent**: `nanostore-state-architect` handles persistence

**Store:**
```typescript
import { persistentAtom } from '@nanostores/persistent';

type Theme = 'light' | 'dark' | 'system';

export const darkMode = persistentAtom<Theme>(
  'theme-preference',
  'system',
  {
    encode: JSON.stringify,
    decode: JSON.parse,
  }
);

export function toggleDarkMode() {
  const current = darkMode.get();
  const next = current === 'light' ? 'dark' : 'light';
  darkMode.set(next);
  applyTheme(next);
}

function applyTheme(theme: Theme) {
  const isDark = theme === 'dark' ||
    (theme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches);

  if (isDark) {
    document.documentElement.classList.add('dark');
  } else {
    document.documentElement.classList.remove('dark');
  }
}
```

### 5. Test Dark Mode
Use `vue-testing-specialist` to test functionality

**Tests:**
- Toggle button works
- Theme persists on reload
- CSS applied correctly
- System preference respected
- No flash of wrong theme

---

## Agent Orchestration

```
tailwind-styling-expert → vue-architect → nanostore-state-architect → vue-testing-specialist
```

---

## Tailwind Dark Mode Setup

### astro.config.ts
```typescript
export default defineConfig({
  vite: {
    ssr: {
      external: ['react', 'react-dom'],
    },
  },
  integrations: [
    vue(),
    tailwind({
      applyBaseStyles: false,
    }),
  ],
});
```

### tailwind.config.ts
```typescript
export default {
  darkMode: 'class', // Use class strategy
  theme: {
    extend: {
      colors: {
        // Your color customizations
      },
    },
  },
};
```

### Enable in HTML
The `dark` class should be on `<html>`:

```html
<!-- Light mode -->
<html>
  ...
</html>

<!-- Dark mode -->
<html class="dark">
  ...
</html>
```

---

## Dark Mode Colors Pattern

### Text Colors
```vue
<!-- Light: gray-900, Dark: white -->
<p class="text-gray-900 dark:text-white">Content</p>

<!-- Light: gray-600, Dark: gray-400 -->
<p class="text-gray-600 dark:text-gray-400">Secondary text</p>
```

### Backgrounds
```vue
<!-- Light: white, Dark: gray-800 -->
<div class="bg-white dark:bg-gray-800">Content</div>

<!-- Light: gray-50, Dark: gray-900 -->
<div class="bg-gray-50 dark:bg-gray-900">Section</div>
```

### Borders
```vue
<!-- Light: gray-200, Dark: gray-700 -->
<div class="border border-gray-200 dark:border-gray-700">Content</div>
```

### Interactive States
```vue
<!-- Hover state -->
<button class="
  hover:bg-gray-100 dark:hover:bg-gray-700
  active:bg-gray-200 dark:active:bg-gray-600
">
  Click me
</button>

<!-- Focus state -->
<input class="
  focus:ring-2 focus:ring-blue-500
  dark:focus:ring-blue-400
" />
```

### Shadows
```vue
<!-- Light shadow, darker in dark mode -->
<div class="shadow-md dark:shadow-gray-900/50">Content</div>
```

---

## Implementation Checklist

- [ ] `dark:` variants added to all components
- [ ] Theme store created with persistence
- [ ] Toggle component created and accessible
- [ ] No hard-coded colors remain
- [ ] System preference respected
- [ ] No flash of unstyled content (FOUC)
- [ ] Tests cover theme switching
- [ ] Tests cover persistence
- [ ] Mobile appearance checked
- [ ] All contrast ratios pass WCAG AA

---

## Contrast Requirements (WCAG AA)

| Element | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Body text | #000 on #FFF (21:1) | #FFF on #1F2937 (15:1) |
| Secondary text | #4B5563 on #FFF (7:1) | #D1D5DB on #1F2937 (7:1) |
| UI borders | #E5E7EB on #FFF (3.5:1) | #374151 on #1F2937 (3.5:1) |

---

## System Preference Detection

```typescript
// Check system preference
const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

// Listen for changes
prefersDark.addEventListener('change', (e) => {
  if (e.matches) {
    // System switched to dark mode
  }
});
```

---

## Related Workflows

- [Create Feature Page](./01-create-feature-page.md)
- [Refactor to Nanostores](./04-refactor-nanostores.md)
- [Test-Driven Development](./08-test-driven-development.md)

---

**Time Estimate**: 1-2 hours | **Complexity**: Medium | **Status**: ✅ Production Ready
