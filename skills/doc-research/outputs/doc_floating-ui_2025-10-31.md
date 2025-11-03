# Floating UI Documentation Research
**Date:** 2025-10-31
**Topic:** Floating UI (Core + Vue Integration)

## Overview

Floating UI is a low-level library for positioning floating elements (tooltips, popovers, dropdowns) next to reference elements. For Vue 3 applications, there are TWO integration approaches:

1. **@floating-ui/vue** - Official Vue bindings for direct Floating UI integration
2. **floating-vue** - High-level Vue component library (formerly vue-popperjs)

## Key Findings

### Floating Vue (Recommended for Vue 3)

**Package:** `floating-vue`
**Trust Score:** 10/10
**Code Snippets:** 146 examples
**Best For:** Complete tooltip/dropdown/menu solution with minimal setup

#### Quick Setup

```bash
npm install floating-vue
```

```js
import FloatingVue from 'floating-vue'
import 'floating-vue/dist/style.css'

app.use(FloatingVue)
```

#### Three Usage Patterns

**1. Directive (v-tooltip) - Simplest**
```vue
<button v-tooltip="'You have ' + count + ' new messages.'">
  Notifications
</button>

<!-- Object notation for advanced options -->
<button v-tooltip="{
  content: 'Tooltip text',
  placement: 'bottom-start',
  theme: 'dropdown',
  triggers: ['click'],
  distance: 12,
  html: true
}">
  Advanced
</button>
```

**2. Component (VDropdown/VTooltip) - Most Flexible**
```vue
<VDropdown
  :distance="32"
  :skidding="-16"
  :triggers="['click']"
  auto-hide
>
  <button>Click me</button>

  <template #popper>
    <MyAwesomeComponent />
  </template>
</VDropdown>
```

**3. Programmatic (createTooltip) - Full Control**
```js
import { createTooltip, destroyTooltip } from 'floating-vue'

const tooltip = createTooltip(el, {
  triggers: [],
  content: 'Text copied!',
})
tooltip.show()
setTimeout(() => {
  tooltip.hide()
  setTimeout(() => destroyTooltip(el), 400)
}, 600)
```

#### Critical Props

| Prop | Type | Description | Default |
|------|------|-------------|---------|
| `distance` | number | Main axis offset (px) | 5 |
| `skidding` | number | Cross axis offset (px) | 0 |
| `placement` | string | Position relative to ref | 'top' (tooltip), 'bottom' (dropdown) |
| `triggers` | string[] | Events that show popper | ['hover', 'focus', 'touch'] (tooltip), ['click'] (dropdown) |
| `auto-hide` | boolean | Hide on outside click | true (dropdown) |
| `flip` | boolean | Flip to opposite if overflow | true |
| `shift` | boolean | Shift on cross axis to prevent overflow | true |
| `arrow-padding` | number | Padding for arrow (prevents overflow) | 0 |
| `prevent-overflow` | boolean | Prevent boundary overflow | true |
| `overflow-padding` | number | Virtual boundary padding | 0 |
| `html` | boolean | Enable HTML content (XSS risk) | false |

#### Async Content Loading

```vue
<button v-tooltip="{
  content: fetchTooltip,
  loadingContent: 'Loading...'
}">
  Hover for async content
</button>
```

```js
async function fetchTooltip() {
  const response = await fetch('/api/tooltip-data')
  return response.text()
}
```

#### Themes

**Built-in themes:** `tooltip`, `dropdown`, `menu`

```js
// Define custom theme globally
Vue.use(FloatingVue, {
  themes: {
    'info-tooltip': {
      $extend: 'tooltip',
      distance: 24,
      delay: { show: 1000, hide: 0 },
    },
  },
})
```

```vue
<!-- Use custom theme -->
<button v-tooltip="{
  content: 'Info message',
  theme: 'info-tooltip'
}">
  Info
</button>
```

#### SSR Compatibility

Floating Vue is SSR-safe. For Nuxt 3:

```js
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['floating-vue/nuxt']
})
```

#### v4 Migration Notes

**Breaking Changes from v3:**
- `offset` prop → `distance` + `skidding` props
- `arrow` modifier options → `arrow-padding` prop
- `preventOverflow` modifier → `prevent-overflow` + `overflow-padding` props
- `modifiers` array → dedicated props (`flip`, `shift`, `shift-cross-axis`)
- Slot renamed: `popover` → `popper`
- CSS classes updated: `.tooltip` → `.v-popper__popper`, `.tooltip-inner` → `.v-popper__inner`
- `html` now defaults to `false` for XSS protection

### @floating-ui/vue (Low-Level Alternative)

**Package:** `@floating-ui/vue`
**Best For:** Maximum control, custom implementations, existing Floating UI knowledge

#### Setup

```bash
npm install @floating-ui/vue
```

```vue
<script setup>
import { ref } from 'vue'
import { useFloating, offset, flip, shift } from '@floating-ui/vue'

const reference = ref(null)
const floating = ref(null)

const { floatingStyles } = useFloating(reference, floating, {
  placement: 'top',
  middleware: [
    offset(10),
    flip(),
    shift({ padding: 5 })
  ]
})
</script>

<template>
  <button ref="reference">Reference</button>
  <div ref="floating" :style="floatingStyles">
    Tooltip content
  </div>
</template>
```

#### Middleware (Core Floating UI Concepts)

**Order matters!** Recommended sequence:
1. `offset()` - first
2. `flip()`, `shift()` - middle
3. `arrow()`, `hide()` - last

```js
import {
  offset,
  flip,
  shift,
  arrow,
  autoPlacement,
  hide,
  inline,
  limitShift
} from '@floating-ui/vue'

const middleware = [
  offset(8),
  flip({
    fallbackPlacements: ['top', 'right', 'left'],
    padding: 5,
  }),
  shift({
    padding: 10,
    limiter: limitShift({ offset: 10 })
  }),
  arrow({ element: arrowRef, padding: 5 }),
  hide()
]
```

**Middleware Reference:**

| Middleware | Purpose | Key Options |
|------------|---------|-------------|
| `offset()` | Distance from reference | `mainAxis`, `crossAxis`, `alignmentAxis` |
| `flip()` | Change placement when overflow | `fallbackPlacements`, `padding`, `boundary` |
| `shift()` | Slide along alignment axis | `padding`, `boundary`, `limiter`, `crossAxis` |
| `arrow()` | Position arrow element | `element`, `padding` |
| `autoPlacement()` | Auto-choose best placement | `allowedPlacements`, `alignment` |
| `hide()` | Detect when element is hidden | N/A |
| `inline()` | Position relative to inline text | `padding` |

#### Auto Update (Keep Position Synced)

```vue
<script setup>
import { useFloating, autoUpdate } from '@floating-ui/vue'

const { floatingStyles } = useFloating(reference, floating, {
  whileElementsMounted: autoUpdate,
  middleware: [offset(10)]
})

// With options
const { floatingStyles } = useFloating(reference, floating, {
  whileElementsMounted: (...args) => {
    return autoUpdate(...args, {
      animationFrame: true
    })
  }
})
</script>
```

**⚠️ Critical:** Only use with `v-if`, NOT `v-show`. Conditional rendering required.

#### Manual Updates

```vue
<script setup>
const { update } = useFloating(reference, floating)

// Call update() when needed
onMounted(() => {
  watch(someData, () => update())
})
</script>
```

#### Arrow Positioning

```vue
<script setup>
import { ref, computed } from 'vue'
import { useFloating, arrow, offset } from '@floating-ui/vue'

const arrowRef = ref(null)

const { placement, middlewareData } = useFloating(reference, floating, {
  middleware: [
    offset(8),
    arrow({ element: arrowRef, padding: 5 })
  ]
})

const arrowStyles = computed(() => {
  const { x, y } = middlewareData.value.arrow || {}
  const staticSide = {
    top: 'bottom',
    right: 'left',
    bottom: 'top',
    left: 'right',
  }[placement.value.split('-')[0]]

  return {
    left: x != null ? `${x}px` : '',
    top: y != null ? `${y}px` : '',
    [staticSide]: '-4px'
  }
})
</script>

<template>
  <div ref="floating">
    Tooltip
    <div ref="arrowRef" :style="arrowStyles" class="arrow" />
  </div>
</template>
```

#### Return Values

```ts
const {
  x,                    // number - x coordinate
  y,                    // number - y coordinate
  placement,            // Placement - final placement
  strategy,             // 'absolute' | 'fixed'
  middlewareData,       // object - data from middleware
  isPositioned,         // boolean - ready state
  floatingStyles,       // object - computed styles
  update,               // function - manual update
} = useFloating(reference, floating, options)
```

## Decision Framework: Which Library?

### Choose **Floating Vue** if:
- ✅ Building tooltips, dropdowns, menus quickly
- ✅ Need directive-based approach (`v-tooltip`)
- ✅ Want built-in themes and styling
- ✅ SSR compatibility required (Astro, Nuxt)
- ✅ Team prefers high-level components

### Choose **@floating-ui/vue** if:
- ✅ Need maximum positioning control
- ✅ Building custom UI components
- ✅ Already using Floating UI in other frameworks
- ✅ Want zero-styling (BYO CSS)
- ✅ Performance-critical applications

## Common Gotchas

### Floating Vue
1. **XSS Risk:** `html: true` allows arbitrary HTML. Sanitize user content.
2. **Migration:** v3→v4 changes props (`offset` → `distance`/`skidding`)
3. **CSS Classes:** v4 uses `.v-popper__*` instead of `.tooltip-*`
4. **Default padding removed:** Add custom padding to `dropdown` theme

### @floating-ui/vue
1. **Conditional Rendering:** MUST use `v-if`, NOT `v-show` with `whileElementsMounted`
2. **Initial Position:** Element starts at (0,0) until positioned (use `isPositioned`)
3. **Middleware Order:** `offset` first, `arrow`/`hide` last
4. **Manual Updates:** `autoUpdate` doesn't cover all cases (need `update()` for some scenarios)

## Real-World Usage Patterns

### SSR-Safe Tooltip (Astro + Vue)

```vue
<!-- components/Tooltip.vue -->
<script setup>
import { ref, onMounted } from 'vue'

const isMounted = ref(false)
onMounted(() => { isMounted.value = true })
</script>

<template>
  <VTooltip v-if="isMounted" :triggers="['hover']">
    <slot />
    <template #popper>
      <slot name="content" />
    </template>
  </VTooltip>
  <slot v-else />
</template>
```

### Mobile-Friendly Dropdown

```vue
<VDropdown
  :positioning-disabled="isMobile"
  @apply-show="isMobile && lockScroll()"
  @apply-hide="isMobile && unlockScroll()"
>
  <button>Menu</button>

  <template #popper="{ hide }">
    <div>Content</div>
    <button v-if="isMobile" @click="hide()">Close</button>
  </template>
</VDropdown>

<style>
.v-popper__popper--no-positioning {
  position: fixed;
  z-index: 9999;
  inset: 0;
  display: flex;
  align-items: flex-end;
}
</style>
```

### Form Input with Validation Popover

```vue
<VDropdown
  auto-min-size
  auto-hide
  :distance="4"
  :triggers="['focus']"
>
  <input type="email" />

  <template #popper>
    <div v-if="errors.email">{{ errors.email }}</div>
  </template>
</VDropdown>
```

## Resources

- **Floating Vue Docs:** https://floating-vue.starpad.dev/
- **Floating UI Docs:** https://floating-ui.com/
- **Floating UI Vue:** https://floating-ui.com/docs/vue
- **Migration Guide:** https://floating-vue.starpad.dev/guide/migration
- **GitHub (Floating Vue):** https://github.com/akryum/floating-vue
- **GitHub (Floating UI):** https://github.com/floating-ui/floating-ui

## Recommended Implementation for Astro + Vue 3

**Use Floating Vue** for most cases:
1. SSR-compatible out of box
2. Directive syntax (`v-tooltip`) reduces boilerplate
3. Built-in dark mode support via Tailwind integration
4. Themes allow consistent styling
5. Lower learning curve for team

**Import in Astro layout:**

```astro
---
// src/layouts/Layout.astro
import 'floating-vue/dist/style.css'
---
```

**Vue plugin registration:**

```ts
// src/app.ts (appEntrypoint)
import FloatingVue from 'floating-vue'

export default (app) => {
  app.use(FloatingVue, {
    themes: {
      tooltip: {
        distance: 8,
        delay: { show: 500, hide: 0 },
      },
      dropdown: {
        distance: 4,
        triggers: ['click'],
      }
    }
  })
}
```

## Next Steps

1. Install `floating-vue`
2. Add CSS import to Astro layout
3. Register plugin in Vue appEntrypoint
4. Create reusable tooltip/dropdown components
5. Add Tailwind dark mode classes to `.v-popper__inner`
