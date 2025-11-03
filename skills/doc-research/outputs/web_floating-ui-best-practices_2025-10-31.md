# Floating UI Best Practices - Web Research
**Date:** 2025-10-31
**Topic:** Community patterns, real-world usage, UI library integrations

## Key Insights from Community

### Industry Adoption

**Floating UI is widely adopted across major UI libraries:**

1. **Shepherd.js** - Product tour library uses Floating UI for tooltip positioning
2. **React Joyride** - Uses React-floater (based on Popper.js predecessor)
3. **Tippy.js** - Popular tooltip library built on Floating UI
4. **Base UI** - MUI team's headless components use Floating UI
5. **Swiper, Mobiscroll** - Advanced UI component libraries integrate Floating UI

### Production Use Cases

**1. User Onboarding Tours**
- Tooltips with "Next", "Skip", "Back" buttons
- Collision detection to keep tooltips visible
- Scroll-into-view helpers for long pages
- Multi-step progress indicators

**Example from Shepherd.js pattern:**
```js
{
  placement: 'bottom',
  middleware: [
    offset(12),
    flip(),
    shift({ padding: 8 }),
    arrow({ element: arrowEl })
  ]
}
```

**2. Form Validation Popovers**
- Anchor to form inputs
- Auto-hide on outside click
- Real-time positioning during scroll
- Responsive to viewport changes

**3. Context Menus & Dropdowns**
- Click triggers (not hover)
- Auto-hide on selection
- Nested menu support
- Keyboard navigation

### Positioning Strategies

**Community-Recommended Middleware Order:**

```js
const middleware = [
  offset(distance),           // Always first
  flip(),                     // Before shift for edge cases
  shift({ padding: 5 }),      // Slide to stay in view
  arrow({ element, padding }) // Always last
]
```

**Smart Placement Logic:**
```js
// Prioritize flip over shift for edge-aligned placements
if (placement.includes('-')) {
  middleware.push(flipMiddleware, shiftMiddleware)
} else {
  middleware.push(shiftMiddleware, flipMiddleware)
}
```

### Mobile Best Practices

**From Mobiscroll & React Joyride patterns:**

1. **Viewport-Based Display Modes**
   - Mobile: Bottom-positioned (sheet-style)
   - Tablet: Centered modal
   - Desktop: Anchored to reference

```js
const display = {
  xsmall: 'bottom',   // Mobile
  medium: 'center',   // Tablet
  large: 'anchored'   // Desktop
}
```

2. **Touch-Friendly Triggers**
   - Include `'touch'` in triggers array
   - Larger tap targets (min 44x44px)
   - Prevent scroll when popover open

3. **Collision Handling**
   - Use `shift({ padding: 16 })` for mobile (larger padding)
   - Enable `flip()` for all mobile tooltips
   - Consider `auto-placement` for unpredictable viewports

### Accessibility Patterns

**ARIA Integration (from Shepherd.js):**

```html
<button
  aria-describedby="tooltip-123"
  aria-expanded="true"
>
  Reference Element
</button>

<div
  id="tooltip-123"
  role="tooltip"
  class="v-popper__popper"
>
  Tooltip content
</div>
```

**Keyboard Support:**
- Escape key to close
- Focus management (return focus on close)
- Arrow keys for nested menus
- Tab to navigate within popover

### Performance Optimization

**From Real-World Implementations:**

1. **Lazy Mounting**
   - Don't render popper content until first show
   - Use `eager-mount` sparingly (only when needed)

2. **Debounce Updates**
   - Throttle `autoUpdate` for scroll events
   - Use `animationFrame: true` for smooth animations

3. **Virtual Elements**
   - For context menus (mouse position)
   - Reduces DOM node count
   - Better for large datasets

**Example from Vue community:**
```js
const virtualElement = ref({
  getBoundingClientRect: () => ({
    width: 0,
    height: 0,
    x: mouseX.value,
    y: mouseY.value,
    top: mouseY.value,
    left: mouseX.value,
    right: mouseX.value,
    bottom: mouseY.value,
  })
})
```

### Styling Recommendations

**Tailwind CSS Integration (from FloatUI, 9ui):**

```css
/* Dark mode support */
.v-popper__inner {
  @apply bg-white dark:bg-gray-800;
  @apply text-gray-900 dark:text-gray-100;
  @apply border border-gray-200 dark:border-gray-700;
  @apply shadow-lg dark:shadow-2xl;
  @apply rounded-lg;
  @apply p-3;
}

/* Arrow styling */
.v-popper__arrow-outer {
  @apply border-gray-200 dark:border-gray-700;
}

.v-popper__arrow-inner {
  @apply bg-white dark:bg-gray-800;
}
```

**Animation Best Practices:**

```css
/* Smooth transitions */
.v-popper__wrapper {
  transition: opacity 0.15s, transform 0.15s;
}

.v-popper__popper--hidden .v-popper__wrapper {
  opacity: 0;
  transform: scale(0.95);
}

/* Transform origin for zoom effects */
.v-popper__popper[data-popper-placement^='top'] .v-popper__wrapper {
  transform-origin: bottom center;
}

.v-popper__popper[data-popper-placement^='bottom'] .v-popper__wrapper {
  transform-origin: top center;
}
```

### Common Pitfalls

**1. Z-Index Issues**
```css
/* Solution: Use CSS custom properties */
.v-popper__popper {
  z-index: var(--popper-z-index, 9999);
}
```

**2. Overflow Parent Clipping**
```js
// Use portal/teleport to body
container: 'body'

// Or use `strategy: 'fixed'`
useFloating(ref, floating, {
  strategy: 'fixed'
})
```

**3. SSR Hydration Mismatches**
```vue
<!-- Wrap in ClientOnly or use v-if with onMounted -->
<ClientOnly>
  <VDropdown>...</VDropdown>
</ClientOnly>
```

**4. Memory Leaks**
```js
// Always cleanup in onUnmounted
onUnmounted(() => {
  destroyTooltip(el)
  cleanup() // from autoUpdate
})
```

### Framework-Specific Patterns

**Nuxt 3 + Floating Vue:**

```ts
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['floating-vue/nuxt'],
  floatingVue: {
    themes: {
      tooltip: {
        distance: 12,
        delay: 500
      }
    }
  }
})
```

**Astro + Vue Integration:**

```astro
---
// src/layouts/Layout.astro
import 'floating-vue/dist/style.css'
---

<script>
  // Client-side only initialization
  if (import.meta.env.SSR === false) {
    import('floating-vue').then(({ default: FloatingVue }) => {
      // Vue app setup
    })
  }
</script>
```

### Advanced Techniques

**1. Dynamic Content Loading**
```vue
<VTooltip>
  <button>Hover for details</button>

  <template #popper>
    <Suspense>
      <AsyncComponent :id="itemId" />
      <template #fallback>
        <LoadingSpinner />
      </template>
    </Suspense>
  </template>
</VTooltip>
```

**2. Tooltip Groups**
```vue
<!-- Only one tooltip from group shown at a time -->
<VTooltip show-group="details">
  <button>Item 1</button>
  <template #popper>Details 1</template>
</VTooltip>

<VTooltip show-group="details">
  <button>Item 2</button>
  <template #popper>Details 2</template>
</VTooltip>
```

**3. Conditional Positioning**
```js
const middleware = computed(() => {
  const base = [offset(8)]

  if (props.allowFlip) {
    base.push(flip())
  }

  if (props.preventOverflow) {
    base.push(shift({ padding: 5 }))
  }

  return base
})
```

### Testing Recommendations

**From UI Component Libraries:**

1. **Visual Regression Testing**
   - Screenshot tooltips in all placements
   - Test dark mode variants
   - Verify arrow positioning

2. **Interaction Testing**
   - Keyboard navigation
   - Touch events on mobile
   - Click outside to close

3. **Position Accuracy**
   - Verify no overflow on small viewports
   - Test with scrolled containers
   - Check RTL layout support

**Example Playwright Test:**
```js
test('tooltip positions correctly', async ({ page }) => {
  await page.goto('/tooltip-demo')

  const button = page.locator('button')
  await button.hover()

  const tooltip = page.locator('.v-popper__popper')
  await expect(tooltip).toBeVisible()

  const box = await tooltip.boundingBox()
  expect(box.y).toBeLessThan(await button.boundingBox().y)
})
```

## Summary: Production-Ready Checklist

- ✅ Use `flip()` + `shift()` for all tooltips
- ✅ Set appropriate `padding` for mobile (12-16px)
- ✅ Include `arrow` for visual anchoring
- ✅ Add ARIA attributes for screen readers
- ✅ Support Escape key to close
- ✅ Test with `v-if` (not `v-show`) for SSR
- ✅ Use `auto-hide` for dropdowns
- ✅ Set `z-index` via CSS custom properties
- ✅ Enable dark mode with Tailwind classes
- ✅ Add loading states for async content
- ✅ Cleanup listeners in `onUnmounted`
- ✅ Test on real mobile devices (not just emulators)

## Resources

- Shepherd.js patterns: https://shepherdjs.dev/
- Tippy.js docs: https://atomiks.github.io/tippyjs/
- Base UI (MUI): https://mui.com/base-ui/
- Mobiscroll demos: https://demo.mobiscroll.com/
- FloatUI (Tailwind): https://floatui.com/
