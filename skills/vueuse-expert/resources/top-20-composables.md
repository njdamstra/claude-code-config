# Top 20 Most-Used Composables

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
