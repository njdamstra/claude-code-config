# Category Reference

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
