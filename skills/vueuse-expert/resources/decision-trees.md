# Decision Trees

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
