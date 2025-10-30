---
name: VueUse Expert
description: Master VueUse composables library with decision frameworks, SSR patterns, and animation integration. Covers 160+ composables across 8 categories plus @vueuse/motion. Use when choosing composables for state management, DOM interaction, sensors, network, browser APIs, animations, or utilities. Provides decision trees, SSR safety guidance, and links to local documentation (262 files). Prevents recreating existing composables. Use for "vueuse", "composable", "animation", "motion", "useStorage", "useMounted", "watch*", "use*", "browser api", "ssr safety".
version: 1.0.0
tags: [vueuse, composables, ssr, motion, animations, state, dom, sensors, browser-api, utilities, decision-tree]
---

# VueUse Expert

## Core Philosophy

**ALWAYS check VueUse before creating custom composables.** VueUse provides 160+ battle-tested, SSR-safe composables that solve common problems. This skill helps you:
1. **Discover** which composable solves your problem
2. **Decide** between similar composables
3. **Deploy** with proper SSR safety
4. **Document** with local documentation links (262 files available)

---

## Quick Navigation

- [Top 20 Most-Used Composables](#top-20-most-used-composables) (from this codebase)
- [Decision Trees](#decision-trees) (choose right composable fast)
- [SSR Safety Guide](#ssr-safety-guide) (critical for Astro + Vue)
- [Motion Library](#motion-library-vueusemotion) (@vueuse/motion animations)
- [Category Reference](#category-reference) (8 categories, 160+ composables)
- [Common Patterns](#common-patterns) (combining composables)

---

## Top 20 Most-Used Composables

Based on analysis of this codebase (350+ Vue components, 42 composables):

### 1. useMounted (270+ uses) ⭐ CRITICAL

**Use Case:** Detect when component is mounted client-side. **Essential for SSR safety.**

**SSR Safety:** ✅ SSR-SAFE (designed for this purpose)

**Example:**
```typescript
import { useMounted } from '@vueuse/core'

const mounted = useMounted()

// Wrap browser APIs
watch(mounted, (isMounted) => {
  if (isMounted) {
    theme.value = localStorage.getItem('theme') ?? 'light'
  }
})

// Or in template
<Icon v-if="mounted" icon="mdi:home" /> <!-- SSR-safe icon rendering -->
```

**When NOT to use:** Already inside onMounted() hook (redundant)

**Docs:** [useMounted.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMounted.md)

---

### 2. computedAsync (45+ uses)

**Use Case:** Async computed properties with automatic loading state.

**SSR Safety:** ✅ SSR-SAFE (evaluates on client)

**Example:**
```typescript
import { computedAsync } from '@vueuse/core'

const loading = ref(true)
const accountData = computedAsync(
  async () => {
    const account = await getPlatformAccountById(accountId.value)
    return processAccountData(account)
  },
  undefined, // Default value while loading
  loading // Loading ref
)
```

**When to use:** Need computed value from async operation with loading state

**Docs:** [useAsyncState.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useAsyncState.md)

---

### 3. onClickOutside (20+ uses)

**Use Case:** Close modals, dropdowns, popovers when clicking outside.

**SSR Safety:** ⚠️ SSR-UNSAFE (needs mounted element)

**Example:**
```typescript
import { onClickOutside } from '@vueuse/core'

const modalRef = ref<HTMLElement>()
const isOpen = ref(false)

onClickOutside(modalRef, () => {
  isOpen.value = false
})
```

**When to use:** Any clickable element that needs outside-click detection

**Docs:** [onClickOutside.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/onClickOutside.md)

---

### 4. useWindowSize (12+ uses)

**Use Case:** Reactive window dimensions for responsive logic.

**SSR Safety:** ⚠️ SSR-UNSAFE (wrap with useMounted or use with ssrWidth)

**Example:**
```typescript
import { useWindowSize } from '@vueuse/core'

const { width, height } = useWindowSize()

const isMobile = computed(() => width.value < 768)
const isTablet = computed(() => width.value >= 768 && width.value < 1024)
const isDesktop = computed(() => width.value >= 1024)

// Responsive chart sizing
watch(width, () => {
  chartRef.value?.resize()
})
```

**When to use:** Responsive component behavior based on viewport size

**Docs:** [useWindowSize.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useWindowSize.md)

---

### 5. watchDebounced (10+ uses)

**Use Case:** Debounce watch callbacks (search inputs, resize handlers).

**SSR Safety:** ✅ SSR-SAFE

**Example:**
```typescript
import { watchDebounced } from '@vueuse/core'

const searchQuery = ref('')
const results = ref([])

watchDebounced(
  searchQuery,
  async (query) => {
    results.value = await fetchSearchResults(query)
  },
  { debounce: 500 } // Wait 500ms after last change
)
```

**When to use:** Expensive operations triggered by reactive changes

**Docs:** [watchDebounced.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/watchDebounced.md)

---

### 6. useResizeObserver (8 uses)

**Use Case:** Detect element size changes (charts, grids, responsive containers).

**SSR Safety:** ⚠️ SSR-UNSAFE (needs DOM element)

**Example:**
```typescript
import { useResizeObserver } from '@vueuse/core'

const el = ref<HTMLElement>()

useResizeObserver(el, (entries) => {
  const entry = entries[0]
  const { width, height } = entry.contentRect
  console.log('Element resized:', width, height)
})
```

**When to use:** Need to react to element size changes (not window size)

**Docs:** [useResizeObserver.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useResizeObserver.md)

---

### 7. useElementVisibility (6 uses)

**Use Case:** Lazy load content, trigger scroll animations.

**SSR Safety:** ⚠️ SSR-UNSAFE (Intersection Observer)

**Example:**
```typescript
import { useElementVisibility } from '@vueuse/core'

const sectionRef = ref<HTMLElement>()
const isVisible = useElementVisibility(sectionRef)

watch(isVisible, (visible) => {
  if (visible) {
    // Trigger animation or load data
    triggerAnimation()
  }
})
```

**When to use:** Scroll-based animations or lazy loading

**Docs:** [useElementVisibility.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useElementVisibility.md)

---

### 8. useDropZone (4 uses)

**Use Case:** File drag & drop upload areas.

**SSR Safety:** ⚠️ SSR-UNSAFE (needs DOM element)

**Example:**
```typescript
import { useDropZone } from '@vueuse/core'

const dropZoneRef = ref<HTMLElement>()

const { isOverDropZone } = useDropZone(dropZoneRef, {
  onDrop(files) {
    // Handle dropped files
    uploadFiles(files)
  },
  dataTypes: ['image/png', 'image/jpeg'] // Optional filter
})
```

**When to use:** File upload with drag & drop

**Docs:** [useDropZone.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useDropZone.md)

---

### 9. useLocalStorage (5 uses)

**Use Case:** Persistent state across page reloads.

**SSR Safety:** ⚠️ SSR-UNSAFE (wrap with useMounted check)

**Example:**
```typescript
import { useLocalStorage } from '@vueuse/core'

const preferences = useLocalStorage('user-prefs', {
  theme: 'dark',
  notifications: true
}, {
  mergeDefaults: true // Merge with defaults on updates
})

// Auto-syncs with localStorage
preferences.value.theme = 'light' // Automatically saved
```

**When to use:** User preferences, cached data, session state

**Docs:** [useLocalStorage.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useLocalStorage.md)

---

### 10. useRefHistory (2 uses)

**Use Case:** Undo/redo functionality for text editors.

**SSR Safety:** ✅ SSR-SAFE

**Example:**
```typescript
import { useRefHistory } from '@vueuse/core'

const content = ref('')
const { undo, redo, canUndo, canRedo, history } = useRefHistory(content, {
  capacity: 50 // Keep last 50 changes
})

// Undo/redo methods
function handleUndo() {
  if (canUndo.value) undo()
}
```

**When to use:** Text editors, drawing apps, form state history

**Docs:** [useRefHistory.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useRefHistory.md)

---

### 11. useDraggable (2 uses)

**Use Case:** Make elements draggable (drag handles, moveable panels).

**SSR Safety:** ⚠️ SSR-UNSAFE (needs DOM element)

**Example:**
```typescript
import { useDraggable } from '@vueuse/core'

const el = ref<HTMLElement>()
const { x, y, style } = useDraggable(el, {
  initialValue: { x: 40, y: 40 },
  preventDefault: true
})
```

**When to use:** Floating panels, sortable lists, custom drag interactions

**Docs:** [useDraggable.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useDraggable.md)

---

### 12. useSwipe (2 uses)

**Use Case:** Touch swipe gestures (carousels, mobile menus).

**SSR Safety:** ⚠️ SSR-UNSAFE (needs touch events)

**Example:**
```typescript
import { useSwipe } from '@vueuse/core'

const el = ref<HTMLElement>()
const { direction, isSwiping } = useSwipe(el, {
  onSwipeEnd(e, direction) {
    if (direction === 'left') nextSlide()
    if (direction === 'right') prevSlide()
  }
})
```

**When to use:** Mobile touch gestures, swipeable UI

**Docs:** [useSwipe.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useSwipe.md)

---

### 13. useEventListener (Multiple uses)

**Use Case:** Auto-cleanup event listeners.

**SSR Safety:** ⚠️ SSR-UNSAFE (needs event target)

**Example:**
```typescript
import { useEventListener } from '@vueuse/core'

// Document-level keyboard shortcuts
useEventListener(document, 'keydown', (e: KeyboardEvent) => {
  if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
    e.preventDefault()
    openGlobalSearch()
  }
})

// Auto-cleanup on component unmount
```

**When to use:** Any event listener that needs automatic cleanup

**Docs:** [useEventListener.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useEventListener.md)

---

### 14. useBreakpoints (FloatingPanel)

**Use Case:** Tailwind-style responsive breakpoints in JavaScript.

**SSR Safety:** ⚠️ SSR-UNSAFE (use with ssrWidth or provideSSRWidth)

**Example:**
```typescript
import { useBreakpoints, breakpointsTailwind } from '@vueuse/core'

const breakpoints = useBreakpoints(breakpointsTailwind)

const isSm = breakpoints.smaller('md') // < 768px
const isMd = breakpoints.between('md', 'lg') // 768-1024px
const isLg = breakpoints.greater('lg') // >= 1024px
```

**When to use:** JavaScript logic based on Tailwind breakpoints

**Docs:** [useBreakpoints.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useBreakpoints.md)

---

### 15. useMediaQuery (FloatingPanel)

**Use Case:** React to CSS media queries.

**SSR Safety:** ⚠️ SSR-UNSAFE (use with ssrWidth)

**Example:**
```typescript
import { useMediaQuery } from '@vueuse/core'

const isLarge = useMediaQuery('(min-width: 1024px)')
const prefersDark = useMediaQuery('(prefers-color-scheme: dark)')
const prefersReducedMotion = useMediaQuery('(prefers-reduced-motion: reduce)')
```

**When to use:** Any media query in JavaScript

**Docs:** [useMediaQuery.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMediaQuery.md)

---

### 16. useWindowScroll (Multiple uses)

**Use Case:** Track or control window scroll position.

**SSR Safety:** ⚠️ SSR-UNSAFE

**Example:**
```typescript
import { useWindowScroll } from '@vueuse/core'

const { x, y } = useWindowScroll()

// Scroll to top
function scrollToTop() {
  y.value = 0
}

// Show "scroll to top" button
const showScrollButton = computed(() => y.value > 300)
```

**When to use:** Scroll position tracking, programmatic scrolling

**Docs:** [useWindowScroll.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useWindowScroll.md)

---

### 17. useElementBounding (GridSystem)

**Use Case:** Element position and dimensions (getBoundingClientRect).

**SSR Safety:** ⚠️ SSR-UNSAFE

**Example:**
```typescript
import { useElementBounding } from '@vueuse/core'

const el = ref<HTMLElement>()
const { x, y, top, left, width, height } = useElementBounding(el)

// Position overlay relative to element
const overlayStyle = computed(() => ({
  top: `${y.value}px`,
  left: `${x.value}px`
}))
```

**When to use:** Position overlays, tooltips, popovers relative to elements

**Docs:** [useElementBounding.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useElementBounding.md)

---

### 18. useMouse (GridSystem)

**Use Case:** Track mouse position globally.

**SSR Safety:** ⚠️ SSR-UNSAFE

**Example:**
```typescript
import { useMouse } from '@vueuse/core'

const { x, y, sourceType } = useMouse()

// Create custom cursor follower
const cursorStyle = computed(() => ({
  left: `${x.value}px`,
  top: `${y.value}px`
}))
```

**When to use:** Custom cursors, mouse-following effects

**Docs:** [useMouse.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMouse.md)

---

### 19. usePreferredReducedMotion (2 uses)

**Use Case:** Respect user's motion preferences (accessibility).

**SSR Safety:** ⚠️ SSR-UNSAFE

**Example:**
```typescript
import { usePreferredReducedMotion } from '@vueuse/core'

const prefersReducedMotion = usePreferredReducedMotion()

const shouldAnimate = computed(() =>
  prefersReducedMotion.value !== 'reduce'
)

// Conditionally disable animations
const animationConfig = computed(() => ({
  duration: shouldAnimate.value ? 300 : 0
}))
```

**When to use:** Animation systems, accessibility compliance

**Docs:** [usePreferredReducedMotion.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/usePreferredReducedMotion.md)

---

### 20. MotionPlugin (@vueuse/motion)

**Use Case:** Declarative animations with spring physics.

**SSR Safety:** ✅ SSR-SAFE (v-motion directive)

**Example:**
```vue
<script setup>
import { useMotion } from '@vueuse/motion'

const target = ref()
const { variant } = useMotion(target, {
  initial: { opacity: 0, y: 100 },
  enter: { opacity: 1, y: 0 },
  leave: { opacity: 0, y: -100 }
})
</script>

<template>
  <div
    ref="target"
    v-motion
    :initial="{ opacity: 0 }"
    :enter="{ opacity: 1 }"
  >
    Animated content
  </div>
</template>
```

**When to use:** Complex animations, scroll-based animations

**Docs:** [motion-introduction.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-introduction.md)

---

## Decision Trees

### Decision Tree 1: State Management

```
Need to persist data across page reloads?
├─ YES → Need to sync across tabs?
│  ├─ YES → useBroadcastChannel + useStorage
│  └─ NO → Storage type?
│     ├─ localStorage → useLocalStorage
│     ├─ sessionStorage → useSessionStorage
│     └─ cookies → useCookies
│
└─ NO → Need async data fetching?
   ├─ YES → Need loading state management?
   │  ├─ YES → useAsyncState (built-in loading ref)
   │  └─ NO → computedAsync (simpler)
   │
   └─ NO → Need undo/redo?
      ├─ YES → Track changes?
      │  ├─ Full history → useRefHistory
      │  ├─ Debounced → useDebouncedRefHistory
      │  └─ Throttled → useThrottledRefHistory
      │
      └─ NO → Simple state?
         ├─ Counter → useCounter
         ├─ Toggle → useToggle
         ├─ Cycle list → useCycleList
         └─ Generic → ref() or reactive()
```

---

### Decision Tree 2: DOM Interaction

```
Need to detect element visibility?
├─ Scroll-based lazy load → useElementVisibility (Intersection Observer)
├─ Precise control → useIntersectionObserver (full API access)
├─ Page visibility → useDocumentVisibility (tab switching)
└─ Window focus → useWindowFocus

Need to track element size/position?
├─ Size changes only → useElementSize (resize detection)
├─ Full bounding box → useElementBounding (x, y, width, height, top, left, etc.)
├─ Advanced resize → useResizeObserver (full ResizeObserver API)
└─ Viewport size → useWindowSize (window dimensions)

Need user interactions?
├─ Click outside element → onClickOutside (modals, dropdowns)
├─ Long press → onLongPress (touch/mouse hold)
├─ Drag element → useDraggable (moveable elements)
├─ Drop files → useDropZone (file uploads)
├─ Swipe gestures → useSwipe or usePointerSwipe (touch/pointer)
├─ Keyboard → onKeyStroke or useMagicKeys
└─ Hover → useElementHover
```

---

### Decision Tree 3: SSR Safety

```
Does this composable access window/document/navigator?
├─ YES → SSR-UNSAFE ⚠️
│  └─ Mitigation strategies:
│     ├─ Wrap with useMounted() → Only run on client
│     ├─ Use useSupported() → Returns false on server
│     ├─ Use SSR options → e.g., useMediaQuery({ ssrWidth: 768 })
│     └─ Check import.meta.env.SSR → Manual SSR check
│
└─ NO → SSR-SAFE ✅
   └─ Can use directly
      Examples: useStorage, useAsyncState, useRefHistory,
                watchDebounced, useCounter, useToggle

SSR-SAFE Composables:
- useMounted ✅ (designed for SSR)
- useSupported ✅ (returns false on server)
- useStorage ✅ (with SSR handling built-in)
- useAsyncState ✅ (evaluates on client)
- watchDebounced ✅ (pure reactive)
- useRefHistory ✅ (pure reactive)
- useCounter ✅ (pure reactive)
- useToggle ✅ (pure reactive)

SSR-UNSAFE Composables (need useMounted):
- useMouse ⚠️ (window events)
- useWindowSize ⚠️ (window.innerWidth)
- useBreakpoints ⚠️ (matchMedia)
- onClickOutside ⚠️ (document events)
- useDraggable ⚠️ (pointer events)
- useEventListener ⚠️ (addEventListener)
- useGeolocation ⚠️ (navigator.geolocation)
```

---

### Decision Tree 4: Animations

```
Need animations?
├─ Simple transitions?
│  ├─ CSS-based → Tailwind + Vue Transition component
│  └─ JavaScript → useTransition (interpolation)
│
├─ Complex animations?
│  ├─ Declarative (HTML attributes) → v-motion directive
│  ├─ Programmatic control → useMotion composable
│  ├─ Spring physics → useSpring (natural motion)
│  ├─ Transform animations → useElementTransform
│  └─ Style animations → useElementStyle
│
├─ Scroll-based?
│  ├─ Scroll progress → useScroll + computed
│  └─ Scroll-triggered → useElementVisibility + useMotion
│
└─ Performance critical?
   ├─ RAF-based → useRafFn (60fps callback)
   └─ CSS-based → useTransition with CSS animations
```

---

### Decision Tree 5: Watchers

```
Need to watch reactive data?
├─ Need debouncing? (wait for changes to settle)
│  └─ watchDebounced(source, callback, { debounce: 500 })
│
├─ Need throttling? (limit callback frequency)
│  └─ watchThrottled(source, callback, { throttle: 500 })
│
├─ Need to pause/resume?
│  └─ watchPausable(source, callback)
│     Returns: { pause, resume, isWatching }
│
├─ Need to temporarily ignore updates?
│  └─ watchIgnorable(source, callback)
│     Returns: { ignoreUpdates(fn) }
│
├─ Track all changes?
│  └─ watchWithFilter(source, callback, { eventFilter })
│
└─ Standard watch?
   └─ watch(source, callback) (Vue core)
```

---

## SSR Safety Guide

### Pattern 1: useMounted (Most Critical)

**Problem:** Browser APIs crash during SSR (window, document, navigator, localStorage, etc.)

**Solution:** Wrap with `useMounted()`

```typescript
import { useMounted } from '@vueuse/core'
import { ref, watch } from 'vue'

const mounted = useMounted()
const theme = ref('light')

// Safe: Only runs after client mount
watch(mounted, (isMounted) => {
  if (isMounted) {
    theme.value = localStorage.getItem('theme') ?? 'light'
  }
})
```

**Template Usage:**
```vue
<template>
  <!-- Render after mount -->
  <Icon v-if="mounted" icon="mdi:home" />

  <!-- Conditional entire sections -->
  <template v-if="mounted">
    <ClientOnlyFeatures />
  </template>
</template>
```

---

### Pattern 2: useSupported (Feature Detection)

**Problem:** Need to check if browser feature exists

**Solution:** Use `useSupported()` - returns false on server

```typescript
import { useSupported } from '@vueuse/core'

const isGeolocationSupported = useSupported(() =>
  'geolocation' in navigator
)

const isWebGLSupported = useSupported(() =>
  'WebGLRenderingContext' in window
)

const isClipboardSupported = useSupported(() =>
  navigator && 'clipboard' in navigator
)
```

**Benefits:**
- Returns false on server (SSR-safe)
- Returns true/false on client (actual feature detection)
- No crashes during SSR

---

### Pattern 3: SSR Width for Media Queries

**Problem:** Media queries need viewport width during SSR

**Solution:** Use `provideSSRWidth()` + `useMediaQuery()`

```typescript
// In root component or app setup
import { provideSSRWidth } from '@vueuse/core'

provideSSRWidth(768) // Assume 768px viewport on server

// In components
import { useMediaQuery } from '@vueuse/core'

const isLarge = useMediaQuery('(min-width: 1024px)')
// Server assumes 768px, so isLarge = false
// Client uses actual viewport width
```

**Alternative:** Use `ssrWidth` option directly

```typescript
const isLarge = useMediaQuery('(min-width: 1024px)', {
  ssrWidth: 768
})
```

---

### Pattern 4: Manual SSR Check

**When:** Need fine-grained control

```typescript
import { ref, onMounted } from 'vue'

const data = ref<string | null>(null)

// Check if SSR environment
if (!import.meta.env.SSR) {
  // Only runs on client
  data.value = localStorage.getItem('key')
}

// Or use onMounted (always client-side)
onMounted(() => {
  data.value = localStorage.getItem('key')
})
```

---

### SSR Safety Checklist

**Before using ANY VueUse composable:**

- [ ] Does it access `window`? → ⚠️ Needs useMounted
- [ ] Does it access `document`? → ⚠️ Needs useMounted
- [ ] Does it access `navigator`? → ⚠️ Use useSupported
- [ ] Does it use `localStorage`/`sessionStorage`? → ⚠️ Needs useMounted
- [ ] Does it use event listeners? → ⚠️ Needs useMounted
- [ ] Does it use Intersection/Resize/Mutation Observer? → ⚠️ Needs useMounted
- [ ] Is it pure reactive (computed, watch, ref)? → ✅ SSR-safe

**When in doubt:** Wrap with `useMounted()` - it's always safe!

---

## Motion Library (@vueuse/motion)

### Installation

```bash
npm install @vueuse/motion
```

**Plugin Setup (in main.ts or _vueEntrypoint.ts):**
```typescript
import { MotionPlugin } from '@vueuse/motion'
import { createApp } from 'vue'

const app = createApp(App)
app.use(MotionPlugin) // Global v-motion directive
app.mount('#app')
```

---

### Directive Usage (v-motion)

**Basic Pattern:**
```vue
<template>
  <div
    v-motion
    :initial="{ opacity: 0, y: 100 }"
    :enter="{ opacity: 1, y: 0 }"
    :leave="{ opacity: 0, y: -100 }"
  >
    Animated content
  </div>
</template>
```

**With Variants:**
```vue
<script setup>
const variants = {
  initial: { opacity: 0, scale: 0.8 },
  enter: {
    opacity: 1,
    scale: 1,
    transition: {
      duration: 300,
      ease: 'easeOut'
    }
  },
  leave: { opacity: 0, scale: 0.8 }
}
</script>

<template>
  <div v-motion :variants="variants">
    Animated with variants
  </div>
</template>
```

---

### Composable Usage (useMotion)

**Programmatic Control:**
```vue
<script setup>
import { useMotion } from '@vueuse/motion'
import { ref } from 'vue'

const target = ref()

const { variant, apply } = useMotion(target, {
  initial: { opacity: 0, x: -100 },
  enter: { opacity: 1, x: 0 },
  hovered: { scale: 1.1 },
  tapped: { scale: 0.95 }
})

function handleHover() {
  variant.value = 'hovered'
}

function handleMouseLeave() {
  variant.value = 'enter'
}
</script>

<template>
  <div
    ref="target"
    @mouseenter="handleHover"
    @mouseleave="handleMouseLeave"
  >
    Animated with programmatic control
  </div>
</template>
```

---

### Presets

**Built-in Animation Presets:**
```vue
<template>
  <div v-motion-fade>Fade in</div>
  <div v-motion-slide-left>Slide from left</div>
  <div v-motion-slide-right>Slide from right</div>
  <div v-motion-slide-top>Slide from top</div>
  <div v-motion-slide-bottom>Slide from bottom</div>
  <div v-motion-pop>Pop in</div>
  <div v-motion-roll-left>Roll from left</div>
</template>
```

**Docs:** [motion-presets.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-presets.md)

---

### Spring Physics (useSpring)

**Natural Motion:**
```vue
<script setup>
import { useSpring } from '@vueuse/motion'
import { ref } from 'vue'

const x = ref(0)
const springX = useSpring(x, {
  stiffness: 100,
  damping: 10,
  mass: 1
})

function moveRight() {
  x.value = 300 // Spring animates to new value
}
</script>

<template>
  <div
    :style="{ transform: `translateX(${springX}px)` }"
    @click="moveRight"
  >
    Click to move with spring physics
  </div>
</template>
```

---

### Scroll-Based Animations

**Trigger animations on scroll:**
```vue
<script setup>
import { useElementVisibility } from '@vueuse/core'
import { useMotion } from '@vueuse/motion'
import { ref, watch } from 'vue'

const target = ref()
const isVisible = useElementVisibility(target)

const { variant } = useMotion(target, {
  initial: { opacity: 0, y: 100 },
  visible: { opacity: 1, y: 0 }
})

watch(isVisible, (visible) => {
  variant.value = visible ? 'visible' : 'initial'
})
</script>

<template>
  <div ref="target">
    Animates when scrolled into view
  </div>
</template>
```

---

### Motion + Accessibility

**Respect user preferences:**
```vue
<script setup>
import { usePreferredReducedMotion } from '@vueuse/core'
import { computed } from 'vue'

const prefersReducedMotion = usePreferredReducedMotion()

const motionVariants = computed(() => {
  if (prefersReducedMotion.value === 'reduce') {
    // Disable animations
    return {
      initial: { opacity: 1 },
      enter: { opacity: 1 }
    }
  }

  // Full animations
  return {
    initial: { opacity: 0, y: 100 },
    enter: { opacity: 1, y: 0 }
  }
})
</script>

<template>
  <div v-motion :variants="motionVariants">
    Respects user motion preferences
  </div>
</template>
```

**Motion Docs:**
- [motion-introduction.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-introduction.md)
- [motion-directive-usage.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-directive-usage.md)
- [motion-variants.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-variants.md)
- [useMotion.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMotion.md)
- [useSpring.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useSpring.md)

---

## Category Reference

### 1. State Management (20 composables)

**Overview:** Manage reactive state with persistence, async data, history tracking.

**Most Useful:**
1. **useStorage** - Reactive localStorage/sessionStorage
2. **useLocalStorage** - Shorthand for useStorage with localStorage
3. **useSessionStorage** - Shorthand for useStorage with sessionStorage
4. **useAsyncState** - Async data with loading/error states
5. **useRefHistory** - Undo/redo functionality

**All Composables:**
- useStorage, useLocalStorage, useSessionStorage, useStorageAsync
- useAsyncState, useAsyncQueue
- useCounter, useToggle, useCycleList
- useRefHistory, useManualRefHistory, useDebouncedRefHistory, useThrottledRefHistory
- useCached, useCloned, useLast Changed, usePrevious
- useToNumber, useToString

**Decision Guide:**
```
Need persistence?
├─ Local → useLocalStorage
├─ Session → useSessionStorage
└─ Custom storage → useStorage

Need async data?
└─ useAsyncState

Need history?
├─ Standard → useRefHistory
├─ Debounced → useDebouncedRefHistory
└─ Throttled → useThrottledRefHistory

Simple counters/toggles?
├─ Counter → useCounter
├─ Boolean → useToggle
└─ Array cycling → useCycleList
```

**Docs:** [useStorage.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useStorage.md), [useAsyncState.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useAsyncState.md), [useRefHistory.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useRefHistory.md)

---

### 2. Elements & DOM (35 composables)

**Overview:** Interact with DOM elements - size, position, visibility, observers.

**Most Useful:**
1. **useMounted** - Detect client-side mount (SSR critical)
2. **useElementVisibility** - Scroll-based lazy loading
3. **useResizeObserver** - Detect element size changes
4. **useElementBounding** - Element position and dimensions
5. **onClickOutside** - Close modals/dropdowns

**All Composables:**
- useMounted, useActiveElement, useCurrentElement, useParentElement
- useElementBounding, useElementSize, useElementVisibility, useElementHover
- useElementByPoint, useElementStyle, useElementTransform
- useResizeObserver, useMutationObserver, useIntersectionObserver
- usePerformanceObserver, useFocus, useFocusWithin
- onClickOutside, onLongPress, onElementRemoval
- useDraggable, useDropZone, useVirtualList
- useInfiniteScroll, useScroll, useScrollLock
- useParallax, useTextSelection
- useTemplateRefsList, useCurrentElement

**Decision Guide:**
```
Element visibility?
├─ Simple → useElementVisibility
├─ Advanced → useIntersectionObserver
└─ Document → useDocumentVisibility

Element size/position?
├─ Size only → useElementSize
├─ Position → useElementBounding
└─ Observe changes → useResizeObserver

User interactions?
├─ Click outside → onClickOutside
├─ Drag → useDraggable
├─ Drop → useDropZone
└─ Long press → onLongPress
```

**Docs:** [useMounted.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMounted.md), [useElementVisibility.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useElementVisibility.md), [useResizeObserver.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useResizeObserver.md)

---

### 3. Browser APIs (30 composables)

**Overview:** Access browser features - clipboard, geolocation, notifications, etc.

**Most Useful:**
1. **useClipboard** - Copy to clipboard
2. **useTitle** - Update document title
3. **useFavicon** - Dynamic favicon
4. **useShare** - Native share API
5. **useFullscreen** - Fullscreen mode

**All Composables:**
- useClipboard, useClipboardItems
- useTitle, useFavicon, useDocumentVisibility
- useGeolocation, usePermission
- useBattery, useNetwork, useOnline
- useShare, useWebNotification
- useFullscreen, useScreenOrientation, useScreenSafeArea
- useUserMedia, useDisplayMedia
- useBluetooth, useDevicesList, useEyeDropper
- useFileDialog, useFileSystemAccess
- useSpeechRecognition, useSpeechSynthesis
- useVibrate, useWakeLock
- useCookies, useBrowserLocation
- usePageLeave, useWindowFocus

**Decision Guide:**
```
Clipboard operations?
├─ Text → useClipboard
└─ Files/images → useClipboardItems

Location/device?
├─ GPS → useGeolocation
├─ Battery → useBattery
├─ Network → useNetwork
└─ Orientation → useDeviceOrientation

Media?
├─ Camera/mic → useUserMedia
├─ Screen share → useDisplayMedia
└─ Media controls → useMediaControls

Permissions?
└─ usePermission
```

**Docs:** [useClipboard.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useClipboard.md), [useGeolocation.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useGeolocation.md), [useShare.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useShare.md)

---

### 4. Sensors & Input (25 composables)

**Overview:** Track mouse, keyboard, pointer, touch, and device motion.

**Most Useful:**
1. **useMouse** - Mouse position tracking
2. **onKeyStroke** - Keyboard shortcuts
3. **useSwipe** - Touch swipe gestures
4. **useMagicKeys** - Advanced keyboard handling
5. **usePointer** - Unified pointer events

**All Composables:**
- useMouse, useMouseInElement, useMousePressed
- usePointer, usePointerLock, usePointerSwipe
- onKeyStroke, useKeyModifier, useMagicKeys, onStartTyping
- useSwipe, useDeviceMotion, useDeviceOrientation
- useGamepad, useIdle
- useScroll, useWindowScroll
- useTextDirection, useTextareaAutosize

**Decision Guide:**
```
Mouse tracking?
├─ Global → useMouse
├─ In element → useMouseInElement
└─ Mouse buttons → useMousePressed

Keyboard?
├─ Simple → onKeyStroke
├─ Modifiers → useKeyModifier
└─ Complex → useMagicKeys

Touch/gestures?
├─ Swipe → useSwipe
└─ Pointer → usePointer

Device sensors?
├─ Motion → useDeviceMotion
└─ Orientation → useDeviceOrientation
```

**Docs:** [useMouse.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMouse.md), [onKeyStroke.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/onKeyStroke.md), [useSwipe.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useSwipe.md)

---

### 5. Network & Communication (10 composables)

**Overview:** HTTP requests, WebSockets, Web Workers, broadcasting.

**Most Useful:**
1. **useFetch** - HTTP fetch wrapper
2. **useWebSocket** - WebSocket connection
3. **useBroadcastChannel** - Cross-tab communication
4. **useWebWorker** - Web Worker integration
5. **useEventSource** - Server-Sent Events

**All Composables:**
- useFetch
- useWebSocket, useEventSource
- useBroadcastChannel
- useWebWorker, useWebWorkerFn
- useUrlSearchParams
- useImage, useObjectUrl
- useBase64

**Decision Guide:**
```
HTTP requests?
└─ useFetch (or use fetch directly)

Real-time?
├─ WebSocket → useWebSocket
└─ SSE → useEventSource

Cross-tab?
└─ useBroadcastChannel

Background processing?
├─ Inline → useWebWorkerFn
└─ External → useWebWorker
```

**Docs:** [useFetch.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useFetch.md), [useWebSocket.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useWebSocket.md), [useBroadcastChannel.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useBroadcastChannel.md)

---

### 6. Watchers & Timing (15 composables)

**Overview:** Enhanced watchers, intervals, timeouts, debouncing, throttling.

**Most Useful:**
1. **watchDebounced** - Debounce watch callbacks
2. **watchThrottled** - Throttle watch callbacks
3. **watchPausable** - Pause/resume watchers
4. **useIntervalFn** - setInterval with auto-cleanup
5. **useTimeoutFn** - setTimeout with auto-cleanup

**All Composables:**
- watchDebounced, watchThrottled
- watchPausable, watchIgnorable, watchWithFilter
- useInterval, useIntervalFn
- useTimeout, useTimeoutFn, useTimeoutPoll
- useRafFn, useTimestamp, useNow
- useFps, useCountdown

**Decision Guide:**
```
Enhanced watchers?
├─ Debounce → watchDebounced
├─ Throttle → watchThrottled
├─ Pause/resume → watchPausable
└─ Ignore updates → watchIgnorable

Timers?
├─ Interval → useInterval or useIntervalFn
├─ Timeout → useTimeout or useTimeoutFn
└─ RAF → useRafFn (60fps)

Time tracking?
├─ Current time → useNow
├─ Timestamp → useTimestamp
├─ Countdown → useCountdown
└─ FPS → useFps
```

**Docs:** [watchDebounced.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/watchDebounced.md), [useIntervalFn.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useIntervalFn.md), [useRafFn.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useRafFn.md)

---

### 7. Utilities & Helpers (20 composables)

**Overview:** Shared state, reactive transforms, breakpoints, dark mode, helpers.

**Most Useful:**
1. **useBreakpoints** - Responsive breakpoints
2. **useMediaQuery** - CSS media queries
3. **useDark** - Dark mode toggle
4. **createSharedComposable** - Share composable instances
5. **createInjectionState** - Provide/inject pattern

**All Composables:**
- useBreakpoints, useMediaQuery, useWindowSize
- useColorMode, useDark, usePreferredColorScheme, usePreferredDark
- usePreferredReducedMotion, usePreferredReducedTransparency, usePreferredContrast, usePreferredLanguages
- createSharedComposable, createInjectionState, createGlobalState
- toReactive, toRef, toRefs, createRef
- useSupported, useDevicePixelRatio
- useMemoize, useSorted
- createEventHook, createUnrefFn
- createReusableTemplate, createTemplatePromise

**Decision Guide:**
```
Responsive design?
├─ Tailwind → useBreakpoints(breakpointsTailwind)
├─ Custom → useMediaQuery
└─ Window size → useWindowSize

Dark mode?
├─ Auto + toggle → useDark
├─ Multi-theme → useColorMode
└─ Preference only → usePreferredColorScheme

Shared state?
├─ Global → createGlobalState
├─ Component tree → createInjectionState
└─ Share instance → createSharedComposable

Transforms?
├─ Ref to reactive → toReactive
└─ Reactive to refs → toRefs
```

**Docs:** [useBreakpoints.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useBreakpoints.md), [useDark.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useDark.md), [createSharedComposable.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/createSharedComposable.md)

---

### 8. Animations (@vueuse/motion) (23 docs)

**Overview:** Declarative animations with spring physics, scroll-based, gestures.

**Most Useful:**
1. **v-motion** - Directive for declarative animations
2. **useMotion** - Programmatic animation control
3. **useSpring** - Spring physics
4. **Presets** - Ready-to-use animation presets
5. **Variants** - Define animation states

**All Resources:**
- motion-introduction.md - Getting started
- motion-directive-usage.md - v-motion directive
- motion-composable-usage.md - useMotion composable
- motion-variants.md - Animation state management
- motion-presets.md - Built-in presets
- motion-transition-properties.md - Transition config
- motion-motion-properties.md - Animatable properties
- useMotion.md, useMotionControls.md, useMotionVariants.md
- useSpring.md - Spring physics
- useElementStyle.md, useElementTransform.md
- motion-components.md - Component patterns

**Decision Guide:**
```
Animation approach?
├─ Declarative → v-motion directive
├─ Programmatic → useMotion composable
└─ Spring physics → useSpring

Animation type?
├─ Enter/leave → variants (initial, enter, leave)
├─ Hover/tap → variants (hovered, tapped)
├─ Scroll-based → useScroll + variants
└─ Gesture-based → useSwipe + variants

Presets?
└─ v-motion-fade, v-motion-slide-left, etc.
```

**Docs:** [motion-introduction.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-introduction.md), [useMotion.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMotion.md), [useSpring.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useSpring.md)

---

## Common Patterns

### Pattern 1: Combining Composables

**Responsive + Debounced + Storage:**
```typescript
import { useWindowSize, useLocalStorage, watchDebounced } from '@vueuse/core'

const { width, height } = useWindowSize()
const savedDimensions = useLocalStorage('window-dimensions', { width: 0, height: 0 })

// Save dimensions with debounce
watchDebounced(
  [width, height],
  ([w, h]) => {
    savedDimensions.value = { width: w, height: h }
  },
  { debounce: 500 }
)
```

---

### Pattern 2: Shared Mouse Tracking

**Prevent duplicate event listeners:**
```typescript
import { createSharedComposable, useMouse } from '@vueuse/core'

// Create shared instance
export const useSharedMouse = createSharedComposable(useMouse)

// In multiple components
const { x, y } = useSharedMouse() // All share same tracking
```

---

### Pattern 3: Injection State for Component Trees

**Parent-child state sharing:**
```typescript
import { createInjectionState } from '@vueuse/core'
import { ref, computed } from 'vue'

// Define provider/consumer
const [useProvideTeam, useTeam] = createInjectionState((teamId: string) => {
  const team = ref<Team | null>(null)
  const isLoading = ref(false)

  async function loadTeam() {
    isLoading.value = true
    team.value = await fetchTeam(teamId)
    isLoading.value = false
  }

  const displayName = computed(() => team.value?.name ?? 'Unknown')

  return { team, isLoading, loadTeam, displayName }
})

export { useProvideTeam, useTeam }

// In parent component
useProvideTeam('team-123')

// In any child component
const { team, isLoading, displayName } = useTeam()!
```

---

### Pattern 4: Scroll Progress Bar

**Track scroll percentage:**
```typescript
import { useWindowScroll, useWindowSize, computed } from '@vueuse/core'

const { y } = useWindowScroll()
const { height } = useWindowSize()

const scrollPercentage = computed(() => {
  const documentHeight = document.documentElement.scrollHeight
  const windowHeight = height.value
  const scrollableHeight = documentHeight - windowHeight

  return (y.value / scrollableHeight) * 100
})
```

---

### Pattern 5: Dark Mode with Persistence

**Auto dark mode + manual toggle:**
```typescript
import { useDark, useToggle } from '@vueuse/core'

const isDark = useDark({
  storageKey: 'theme',
  valueDark: 'dark',
  valueLight: 'light'
})

const toggleDark = useToggle(isDark)

// Auto-syncs with localStorage and system preference
```

---

## Cross-References

### Related Skills

- **vue-composable-builder** - How to create custom composables (use VueUse when available!)
- **vue-component-builder** - Using VueUse composables in Vue components
- **astro-vue-architect** - SSR patterns with VueUse in Astro

### When NOT to Use VueUse

- **Simple one-off logic** → Keep inline in component
- **Already have custom composable** → Use custom (don't duplicate)
- **Store-based state** → Use Nanostores (see nanostore-builder)
- **Appwrite operations** → Use useAppwriteClient (see soc-appwrite-integration)

### Integration Examples

**With Nanostores:**
```typescript
import { useStore } from '@nanostores/vue'
import { useLocalStorage } from '@vueuse/core'
import { $user } from '@/stores/authStore'

const user = useStore($user) // Nanostore
const preferences = useLocalStorage('prefs', {}) // VueUse

// Combine both
watch(user, (newUser) => {
  if (newUser) {
    preferences.value.userId = newUser.$id
  }
})
```

---

## Documentation Navigation

### Browse All Documentation

**VueUse Core Composables:**
```bash
ls /Users/natedamstra/.claude/documentation/vue/vueuse/use*.md
```

**Motion Library:**
```bash
ls /Users/natedamstra/.claude/documentation/vue/vueuse/motion-*.md
```

**Utilities:**
```bash
ls /Users/natedamstra/.claude/documentation/vue/vueuse/{create,on,to}*.md
```

### Search for Specific Composable

```bash
# Find composable documentation
find /Users/natedamstra/.claude/documentation/vue/vueuse -name "useStorage.md"

# Search content
grep -r "localStorage" /Users/natedamstra/.claude/documentation/vue/vueuse/
```

### Documentation Links

**All 262 documentation files available at:**
`/Users/natedamstra/.claude/documentation/vue/vueuse/`

**Categories:**
- **157 use* composables** - Core functionality
- **23 motion-* files** - Animation library
- **8 utility functions** - create*, on*, to*
- **Special files** - MEMORIES.md, README.md

---

## Quick Command Reference

### Finding the Right Composable

```typescript
// State persistence?
import { useLocalStorage } from '@vueuse/core'

// Async data?
import { useAsyncState } from '@vueuse/core'

// SSR safety?
import { useMounted } from '@vueuse/core'

// DOM interaction?
import { onClickOutside, useElementVisibility } from '@vueuse/core'

// Responsive?
import { useBreakpoints, breakpointsTailwind } from '@vueuse/core'

// Animations?
import { useMotion } from '@vueuse/motion'

// Watchers?
import { watchDebounced } from '@vueuse/core'
```

---

## Summary

**VueUse provides 160+ composables across 8 categories:**

1. **State Management** - Storage, async, history
2. **Elements & DOM** - Size, position, visibility, observers
3. **Browser APIs** - Clipboard, geolocation, notifications
4. **Sensors & Input** - Mouse, keyboard, touch, gestures
5. **Network** - Fetch, WebSocket, Workers
6. **Watchers & Timing** - Debounce, throttle, intervals
7. **Utilities** - Breakpoints, dark mode, shared state
8. **Animations** - @vueuse/motion for declarative animations

**Critical for this codebase:**
- useMounted (270+ uses) - SSR safety
- computedAsync (45+ uses) - Async data
- onClickOutside (20+ uses) - Modals/dropdowns

**Always:**
- ✅ Check VueUse before creating custom composable
- ✅ Use useMounted() for SSR safety
- ✅ Prefer VueUse over recreating logic
- ✅ Reference local documentation (262 files)

**Never:**
- ❌ Recreate existing VueUse composables
- ❌ Use browser APIs without SSR safety check
- ❌ Ignore performance optimization (shared instances, debouncing)
