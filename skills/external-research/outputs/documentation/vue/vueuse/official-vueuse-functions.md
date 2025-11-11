State
createGlobalState
-
keep states in the global scope to be reusable across Vue instances
createInjectionState
-
create global state that can be injected into components
createSharedComposable
-
make a composable function usable with multiple Vue instances
injectLocal
-
extended inject with ability to call provideLocal to provide the value in the same component
provideLocal
-
extended provide with ability to call injectLocal to obtain the value in the same component
useAsyncState
-
reactive async state
useDebouncedRefHistory
-
shorthand for useRefHistory with debounced filter
useLastChanged
-
records the timestamp of the last change
useLocalStorage
-
reactive LocalStorage
useManualRefHistory
-
manually track the change history of a ref when the using calls commit()
useRefHistory
-
track the change history of a ref
useSessionStorage
-
reactive SessionStorage
useStorage
-
create a reactive ref that can be used to access & modify LocalStorage or SessionStorage
useStorageAsync
-
reactive Storage in with async support
useThrottledRefHistory
-
shorthand for useRefHistory with throttled filter
Elements
useActiveElement
-
reactive document.activeElement
useDocumentVisibility
-
reactively track document.visibilityState
useDraggable
-
make elements draggable
useDropZone
-
create a zone where files can be dropped
useElementBounding
-
reactive bounding box of an HTML element
useElementSize
-
reactive size of an HTML element
useElementVisibility
-
tracks the visibility of an element within the viewport
useIntersectionObserver
-
detects that a target element's visibility
useMouseInElement
-
reactive mouse position related to an element
useMutationObserver
-
watch for changes being made to the DOM tree
useParentElement
-
get parent element of the given element
useResizeObserver
-
reports changes to the dimensions of an Element's content or the border-box
useWindowFocus
-
reactively track window focus with window.onfocus and window.onblur events
useWindowScroll
-
reactive window scroll
useWindowSize
-
reactive window size
Browser
useBluetooth
-
reactive Web Bluetooth API
useBreakpoints
-
reactive viewport breakpoints
useBroadcastChannel
-
reactive BroadcastChannel API
useBrowserLocation
-
reactive browser location
useClipboard
-
reactive Clipboard API
useClipboardItems
-
reactive Clipboard API
useColorMode
-
reactive color mode (dark / light / customs) with auto data persistence
useCssVar
-
manipulate CSS variables
useDark
-
reactive dark mode with auto data persistence
useEventListener
-
use EventListener with ease
useEyeDropper
-
reactive EyeDropper API
useFavicon
-
reactive favicon
useFileDialog
-
open file dialog with ease
useFileSystemAccess
-
create and read and write local files with FileSystemAccessAPI
useFullscreen
-
reactive Fullscreen API
useGamepad
-
provides reactive bindings for the Gamepad API
useImage
-
reactive load an image in the browser
useMediaControls
-
reactive media controls for both audio and video elements
useMediaQuery
-
reactive Media Query
useMemory
-
reactive Memory Info
useObjectUrl
-
reactive URL representing an object
usePerformanceObserver
-
observe performance metrics
usePermission
-
reactive Permissions API
usePreferredColorScheme
-
reactive prefers-color-scheme media query
usePreferredContrast
-
reactive prefers-contrast media query
usePreferredDark
-
reactive dark theme preference
usePreferredLanguages
-
reactive Navigator Languages
usePreferredReducedMotion
-
reactive prefers-reduced-motion media query
usePreferredReducedTransparency
-
reactive prefers-reduced-transparency media query
useScreenOrientation
-
reactive Screen Orientation API
useScreenSafeArea
-
reactive env(safe-area-inset-*)
useScriptTag
-
creates a script tag
useShare
-
reactive Web Share API
useSSRWidth
-
used to set a global viewport width which will be used when rendering SSR components that rely on the viewport width like useMediaQuery or useBreakpoints
useStyleTag
-
inject reactive style element in head
useTextareaAutosize
-
automatically update the height of a textarea depending on the content
useTextDirection
-
reactive dir of the element's text
useTitle
-
reactive document title
useUrlSearchParams
-
reactive URLSearchParams
useVibrate
-
reactive Vibration API
useWakeLock
-
reactive Screen Wake Lock API
useWebNotification
-
reactive Notification
useWebWorker
-
simple Web Workers registration and communication
useWebWorkerFn
-
run expensive functions without blocking the UI
Sensors
onClickOutside
-
listen for clicks outside of an element
onElementRemoval
-
fires when the element or any element containing it is removed
onKeyStroke
-
listen for keyboard keystrokes
onLongPress
-
listen for a long press on an element
onStartTyping
-
fires when users start typing on non-editable elements
useBattery
-
reactive Battery Status API
useDeviceMotion
-
reactive DeviceMotionEvent
useDeviceOrientation
-
reactive DeviceOrientationEvent
useDevicePixelRatio
-
reactively track window.devicePixelRatio
useDevicesList
-
reactive enumerateDevices listing available input/output devices
useDisplayMedia
-
reactive mediaDevices.getDisplayMedia streaming
useElementByPoint
-
reactive element by point
useElementHover
-
reactive element's hover state
useFocus
-
reactive utility to track or set the focus state of a DOM element
useFocusWithin
-
reactive utility to track if an element or one of its decendants has focus
useFps
-
reactive FPS (frames per second)
useGeolocation
-
reactive Geolocation API
useIdle
-
tracks whether the user is being inactive
useInfiniteScroll
-
infinite scrolling of the element
useKeyModifier
-
reactive Modifier State
useMagicKeys
-
reactive keys pressed state
useMouse
-
reactive mouse position
useMousePressed
-
reactive mouse pressing state
useNavigatorLanguage
-
reactive navigator.language
useNetwork
-
reactive Network status
useOnline
-
reactive online state
usePageLeave
-
reactive state to show whether the mouse leaves the page
useParallax
-
create parallax effect easily
usePointer
-
reactive pointer state
usePointerLock
-
reactive pointer lock
usePointerSwipe
-
reactive swipe detection based on PointerEvents
useScroll
-
reactive scroll position and state
useScrollLock
-
lock scrolling of the element
useSpeechRecognition
-
reactive SpeechRecognition
useSpeechSynthesis
-
reactive SpeechSynthesis
useSwipe
-
reactive swipe detection based on TouchEvents
useTextSelection
-
reactively track user text selection based on Window.getSelection
useUserMedia
-
reactive mediaDevices.getUserMedia streaming
Network
useEventSource
-
an EventSource or Server-Sent-Events instance opens a persistent connection to an HTTP server
useFetch
-
reactive Fetch API provides the ability to abort requests
useWebSocket
-
reactive WebSocket client
Animation
useAnimate
-
reactive Web Animations API
useInterval
-
reactive counter increases on every interval
useIntervalFn
-
wrapper for setInterval with controls
useNow
-
reactive current Date instance
useRafFn
-
call function on every requestAnimationFrame
useTimeout
-
update value after a given time with controls
useTimeoutFn
-
wrapper for setTimeout with controls
useTimestamp
-
reactive current timestamp
useTransition
-
transition between values
Component
computedInject
-
combine computed and inject
createReusableTemplate
-
define and reuse template inside the component scope
createTemplatePromise
-
template as Promise
templateRef
-
shorthand for binding ref to template element
tryOnBeforeMount
-
safe onBeforeMount
tryOnBeforeUnmount
-
safe onBeforeUnmount
tryOnMounted
-
safe onMounted
tryOnScopeDispose
-
safe onScopeDispose
tryOnUnmounted
-
safe onUnmounted
unrefElement
-
retrieves the underlying DOM element from a Vue ref or component instance
useCurrentElement
-
get the DOM element of current component as a ref
useMounted
-
mounted state in ref
useTemplateRefsList
-
shorthand for binding refs to template elements and components inside v-for
useVirtualList
-
create virtual lists with ease
useVModel
-
shorthand for v-model binding
useVModels
-
shorthand for props v-model binding
Watch
until
-
promised one-time watch for changes
watchArray
-
watch for an array with additions and removals
watchAtMost
-
watch with the number of times triggered
watchDebounced
-
debounced watch
watchDeep
-
shorthand for watching value with {deep: true}
watchIgnorable
-
ignorable watch
watchImmediate
-
shorthand for watching value with {immediate: true}
watchOnce
-
shorthand for watching value with { once: true }
watchPausable
-
pausable watch
watchThrottled
-
throttled watch
watchTriggerable
-
watch that can be triggered manually
watchWithFilter
-
watch with additional EventFilter control
whenever
-
shorthand for watching value to be truthy
Reactivity
computedAsync
-
computed for async functions
computedEager
-
eager computed without lazy evaluation
computedWithControl
-
explicitly define the dependencies of computed
createRef
-
returns a deepRef or shallowRef depending on the deep param
extendRef
-
add extra attributes to Ref
reactify
-
converts plain functions into reactive functions
reactifyObject
-
apply reactify to an object
reactiveComputed
-
computed reactive object
reactiveOmit
-
reactively omit fields from a reactive object
reactivePick
-
reactively pick fields from a reactive object
refAutoReset
-
a ref which will be reset to the default value after some time
refDebounced
-
debounce execution of a ref value
refDefault
-
apply default value to a ref
refManualReset
-
create a ref with manual reset functionality
refThrottled
-
throttle changing of a ref value
refWithControl
-
fine-grained controls over ref and its reactivity
syncRef
-
two-way refs synchronization
syncRefs
-
keep target refs in sync with a source ref
toReactive
-
converts ref to reactive
toRef
-
normalize value/ref/getter to ref or computed
toRefs
-
extended toRefs that also accepts refs of an object
Array
useArrayDifference
-
reactive get array difference of two arrays
useArrayEvery
-
reactive Array.every
useArrayFilter
-
reactive Array.filter
useArrayFind
-
reactive Array.find
useArrayFindIndex
-
reactive Array.findIndex
useArrayFindLast
-
reactive Array.findLast
useArrayIncludes
-
reactive Array.includes
useArrayJoin
-
reactive Array.join
useArrayMap
-
reactive Array.map
useArrayReduce
-
reactive Array.reduce
useArraySome
-
reactive Array.some
useArrayUnique
-
reactive unique array
useSorted
-
reactive sort array
Time
useCountdown
-
wrapper for useIntervalFn that provides a countdown timer
useDateFormat
-
get the formatted date according to the string of tokens passed in
useTimeAgo
-
reactive time ago
useTimeAgoIntl
-
reactive time ago with i18n supported
Utilities
createEventHook
-
utility for creating event hooks
createUnrefFn
-
make a plain function accepting ref and raw values as arguments
get
-
shorthand for accessing ref.value
isDefined
-
non-nullish checking type guard for Ref
makeDestructurable
-
make isomorphic destructurable for object and array at the same time
set
-
shorthand for ref.value = x
useAsyncQueue
-
executes each asynchronous task sequentially and passes the current task result to the next task
useBase64
-
reactive base64 transforming
useCached
-
cache a ref with a custom comparator
useCloned
-
reactive clone of a ref
useConfirmDialog
-
creates event hooks to support modals and confirmation dialog chains
useCounter
-
basic counter with utility functions
useCycleList
-
cycle through a list of items
useDebounceFn
-
debounce execution of a function
useEventBus
-
a basic event bus
useMemoize
-
cache results of functions depending on arguments and keep it reactive
useOffsetPagination
-
reactive offset pagination
usePrevious
-
holds the previous value of a ref
useStepper
-
provides helpers for building a multi-step wizard interface
useSupported
-
SSR compatibility isSupported
useThrottleFn
-
throttle execution of a function
useTimeoutPoll
-
use timeout to poll something
useToggle
-
a boolean switcher with utility functions
useToNumber
-
reactively convert a string ref to number
useToString
-
reactively convert a ref to string
@Electron
useIpcRenderer
-
provides ipcRenderer and all of its APIs
useIpcRendererInvoke
-
reactive ipcRenderer.invoke API result
useIpcRendererOn
-
use ipcRenderer.on with ease and ipcRenderer.removeListener automatically on unmounted
useZoomFactor
-
reactive WebFrame zoom factor
useZoomLevel
-
reactive WebFrame zoom level
@Firebase
useAuth
-
reactive Firebase Auth binding
useFirestore
-
reactive Firestore binding
useRTDB
-
reactive Firebase Realtime Database binding
@Head
createHead
-
create the head manager instance.
useHead
-
update head meta tags reactively.
@Integrations
useAsyncValidator
-
wrapper for async-validator
useAxios
-
wrapper for axios
useChangeCase
-
reactive wrapper for change-case
useCookies
-
wrapper for universal-cookie
useDrauu
-
reactive instance for drauu
useFocusTrap
-
reactive wrapper for focus-trap
useFuse
-
easily implement fuzzy search using a composable with Fuse.js
useIDBKeyval
-
wrapper for idb-keyval
useJwt
-
wrapper for jwt-decode
useNProgress
-
reactive wrapper for nprogress
useQRCode
-
wrapper for qrcode
useSortable
-
wrapper for sortable
@Math
createGenericProjection
-
generic version of createProjection
createProjection
-
reactive numeric projection from one domain to another
logicAnd
-
AND condition for refs
logicNot
-
NOT condition for ref
logicOr
-
OR conditions for refs
useAbs
-
reactive Math.abs
useAverage
-
get the average of an array reactively
useCeil
-
reactive Math.ceil
useClamp
-
reactively clamp a value between two other values
useFloor
-
reactive Math.floor
useMath
-
reactive Math methods
useMax
-
reactive Math.max
useMin
-
reactive Math.min
usePrecision
-
reactively set the precision of a number
useProjection
-
reactive numeric projection from one domain to another
useRound
-
reactive Math.round
useSum
-
get the sum of an array reactively
useTrunc
-
reactive Math.trunc
@Motion
useElementStyle
-
sync a reactive object to a target element CSS styling
useElementTransform
-
sync a reactive object to a target element CSS transform.
useMotion
-
putting your components in motion.
useMotionProperties
-
access Motion Properties for a target element.
useMotionVariants
-
handle the Variants state and selection.
useSpring
-
spring animations.
@Router
useRouteHash
-
shorthand for a reactive route.hash
useRouteParams
-
shorthand for a reactive route.params
useRouteQuery
-
shorthand for a reactive route.query
@RxJS
from
-
wrappers around RxJS's from() and fromEvent() to allow them to accept refs
toObserver
-
sugar function to convert a ref into an RxJS Observer
useExtractedObservable
-
use an RxJS Observable as extracted from one or more composables
useObservable
-
use an RxJS Observable
useSubject
-
bind an RxJS Subject to a ref and propagate value changes both ways
useSubscription
-
use an RxJS Subscription without worrying about unsubscribing from it or creating memory leaks
watchExtractedObservable
-
watch the values of an RxJS Observable as extracted from one or more composables
@SchemaOrg
createSchemaOrg
-
create the schema.org manager instance.
useSchemaOrg
-
update schema.org reactively.
@Sound
useSound
-
play sound effects reactively.