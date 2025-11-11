# VueUse Functions Index

This document lists all the VueUse composables that have been scraped and saved to this directory.

## State

- **[createGlobalState](createGlobalState.md)** - Keep states in the global scope to be reusable across Vue instances.
- **[createInjectionState](createInjectionState.md)** - Create global state that can be injected into components.
- **[createSharedComposable](createSharedComposable.md)** - Make a composable function usable with multiple Vue instances.
- **[injectLocal](injectLocal.md)** - Extended `inject` with ability to call `provideLocal` to provide the value in the same component.
- **[provideLocal](provideLocal.md)** - Extended `provide` with ability to call `injectLocal` to obtain the value in the same component.
- **[useAsyncState](useAsyncState.md)** - Reactive async state.
- **[useDebouncedRefHistory](useDebouncedRefHistory.md)** - Shorthand for `useRefHistory` with debounced filter.
- **[useLastChanged](useLastChanged.md)** - Records the timestamp of the last change.
- **[useLocalStorage](useLocalStorage.md)** - Reactive LocalStorage.
- **[useManualRefHistory](useManualRefHistory.md)** - Manually track the change history of a ref when the using calls `commit()`.
- **[useRefHistory](useRefHistory.md)** - Track the change history of a ref, also provides undo and redo functionality.
- **[useSessionStorage](useSessionStorage.md)** - Reactive SessionStorage.
- **[useStorage](useStorage.md)** - Create a reactive ref that can be used to access & modify LocalStorage or SessionStorage.
- **[useStorageAsync](useStorageAsync.md)** - Reactive Storage with async support.
- **[useThrottledRefHistory](useThrottledRefHistory.md)** - Shorthand for `useRefHistory` with throttled filter.

## Browser

- **[useBluetooth](useBluetooth.md)** - Reactive Web Bluetooth API.
- **[useBreakpoints](useBreakpoints.md)** - Reactive viewport breakpoints.
- **[useBroadcastChannel](useBroadcastChannel.md)** - Reactive BroadcastChannel API.
- **[useBrowserLocation](useBrowserLocation.md)** - Reactive browser location.
- **[useClipboard](useClipboard.md)** - Reactive Clipboard API.
- **[useClipboardItems](useClipboardItems.md)** - Reactive Clipboard API.
- **[useColorMode](useColorMode.md)** - Reactive color mode (dark / light / customs) with auto data persistence.
- **[useCssVar](useCssVar.md)** - Manipulate CSS variables.
- **[useDark](useDark.md)** - Reactive dark mode with auto data persistence.
- **[useEventListener](useEventListener.md)** - Use EventListener with ease.
- **[useEyeDropper](useEyeDropper.md)** - Reactive EyeDropper API.
- **[useFavicon](useFavicon.md)** - Reactive favicon.
- **[useFileDialog](useFileDialog.md)** - Open file dialog with ease.
- **[useFileSystemAccess](useFileSystemAccess.md)** - Create and read and write local files with FileSystemAccessAPI.
- **[useFullscreen](useFullscreen.md)** - Reactive Fullscreen API.
- **[useGamepad](useGamepad.md)** - Provides reactive bindings for the Gamepad API.
- **[useImage](useImage.md)** - Reactive load an image in the browser.
- **[useMediaControls](useMediaControls.md)** - Reactive media controls for both audio and video elements.
- **[useMediaQuery](useMediaQuery.md)** - Reactive Media Query.
- **[useMemory](useMemory.md)** - Reactive Memory Info.
- **[useObjectUrl](useObjectUrl.md)** - Reactive URL representing an object.
- **[usePerformanceObserver](usePerformanceObserver.md)** - Observe performance metrics.
- **[usePermission](usePermission.md)** - Reactive Permissions API.
- **[usePreferredColorScheme](usePreferredColorScheme.md)** - Reactive prefers-color-scheme media query.
- **[usePreferredContrast](usePreferredContrast.md)** - Reactive prefers-contrast media query.
- **[usePreferredDark](usePreferredDark.md)** - Reactive dark theme preference.
- **[usePreferredLanguages](usePreferredLanguages.md)** - Reactive Navigator Languages.
- **[usePreferredReducedMotion](usePreferredReducedMotion.md)** - Reactive prefers-reduced-motion media query.
- **[usePreferredReducedTransparency](usePreferredReducedTransparency.md)** - Reactive prefers-reduced-transparency media query.
- **[useScreenOrientation](useScreenOrientation.md)** - Reactive Screen Orientation API.
- **[useScreenSafeArea](useScreenSafeArea.md)** - Reactive `env(safe-area-inset-*)`.
- **[useScriptTag](useScriptTag.md)** - Creates a script tag.
- **[useShare](useShare.md)** - Reactive Web Share API.
- **[useSSRWidth](useSSRWidth.md)** - Used to set a global viewport width which will be used when rendering SSR components that rely on the viewport width like `useMediaQuery` or `useBreakpoints`.
- **[useStyleTag](useStyleTag.md)** - Inject reactive style element in head.
- **[useTextareaAutosize](useTextareaAutosize.md)** - Automatically update the height of a textarea depending on the content.
- **[useTextDirection](useTextDirection.md)** - Reactive dir of the element's text.
- **[useTitle](useTitle.md)** - Reactive document title.
- **[useUrlSearchParams](useUrlSearchParams.md)** - Reactive URLSearchParams.
- **[useVibrate](useVibrate.md)** - Reactive Vibration API.
- **[useWakeLock](useWakeLock.md)** - Reactive Screen Wake Lock API.
- **[useWebNotification](useWebNotification.md)** - Reactive Notification.
- **[useWebWorker](useWebWorker.md)** - Simple Web Workers registration and communication.
- **[useWebWorkerFn](useWebWorkerFn.md)** - Run expensive functions without blocking the UI.

## Network

- **[useEventSource](useEventSource.md)** - An EventSource or Server-Sent-Events instance opens a persistent connection to an HTTP server, which sends events in text/event-stream format.
- **[useFetch](useFetch.md)** - Reactive Fetch API with abort, intercept, and auto-refetch capabilities
- **[useWebSocket](useWebSocket.md)** - Reactive WebSocket client

## Sensors

- **[onClickOutside](onClickOutside.md)** - Listen for clicks outside of an element.
- **[onElementRemoval](onElementRemoval.md)** - Fires when the element or any element containing it is removed.
- **[onKeyStroke](onKeyStroke.md)** - Listen for keyboard keystrokes.
- **[onLongPress](onLongPress.md)** - Listen for a long press on an element.
- **[onStartTyping](onStartTyping.md)** - Fires when users start typing on non-editable elements.
- **[useBattery](useBattery.md)** - Reactive Battery Status API.
- **[useDeviceMotion](useDeviceMotion.md)** - Reactive DeviceMotionEvent.
- **[useDeviceOrientation](useDeviceOrientation.md)** - Reactive DeviceOrientationEvent.
- **[useDevicePixelRatio](useDevicePixelRatio.md)** - Reactively track `window.devicePixelRatio`.
- **[useDevicesList](useDevicesList.md)** - Reactive enumerateDevices listing available input/output devices.
- **[useDisplayMedia](useDisplayMedia.md)** - Reactive `mediaDevices.getDisplayMedia` streaming.
- **[useElementByPoint](useElementByPoint.md)** - Reactive element by point.
- **[useElementHover](useElementHover.md)** - Reactive element's hover state.
- **[useFocus](useFocus.md)** - Reactive utility to track or set the focus state of a DOM element.
- **[useFocusWithin](useFocusWithin.md)** - Reactive utility to track if an element or one of its descendants has focus.
- **[useFps](useFps.md)** - Reactive FPS (frames per second).
- **[useGeolocation](useGeolocation.md)** - Reactive Geolocation API.
- **[useIdle](useIdle.md)** - Tracks whether the user is being inactive.
- **[useInfiniteScroll](useInfiniteScroll.md)** - Infinite scrolling of the element.
- **[useKeyModifier](useKeyModifier.md)** - Reactive Modifier State.
- **[useMagicKeys](useMagicKeys.md)** - Reactive keys pressed state.
- **[useMouse](useMouse.md)** - Reactive mouse position.
- **[useMouseInElement](useMouseInElement.md)** - Reactive mouse position related to an element.
- **[useMousePressed](useMousePressed.md)** - Reactive mouse pressing state.
- **[useNavigatorLanguage](useNavigatorLanguage.md)** - Reactive navigator.language.
- **[useNetwork](useNetwork.md)** - Reactive Network status.
- **[useOnline](useOnline.md)** - Reactive online state.
- **[usePageLeave](usePageLeave.md)** - Reactive state to show whether the mouse leaves the page.
- **[useParallax](useParallax.md)** - Create parallax effect easily.
- **[usePointer](usePointer.md)** - Reactive pointer state.
- **[usePointerLock](usePointerLock.md)** - Reactive pointer lock.
- **[usePointerSwipe](usePointerSwipe.md)** - Reactive swipe detection based on PointerEvents.
- **[useScroll](useScroll.md)** - Reactive scroll position and state.
- **[useScrollLock](useScrollLock.md)** - Lock scrolling of the element.
- **[useSpeechRecognition](useSpeechRecognition.md)** - Reactive SpeechRecognition.
- **[useSpeechSynthesis](useSpeechSynthesis.md)** - Reactive SpeechSynthesis.
- **[useSwipe](useSwipe.md)** - Reactive swipe detection based on `TouchEvents`.
- **[useTextSelection](useTextSelection.md)** - Reactively track user text selection based on `Window.getSelection`.
- **[useUserMedia](useUserMedia.md)** - Reactive `mediaDevices.getUserMedia` streaming.

## Elements

- **[useActiveElement](useActiveElement.md)** - Reactive `document.activeElement`.
- **[useDocumentVisibility](useDocumentVisibility.md)** - Reactively track `document.visibilityState`.
- **[useDraggable](useDraggable.md)** - Make elements draggable.
- **[useDropZone](useDropZone.md)** - Create a zone where files can be dropped.
- **[useElementBounding](useElementBounding.md)** - Reactive bounding box of an HTML element.
- **[useElementSize](useElementSize.md)** - Reactive size of an HTML element.
- **[useElementVisibility](useElementVisibility.md)** - Tracks the visibility of an element within the viewport.
- **[useIntersectionObserver](useIntersectionObserver.md)** - Detects that a target element's visibility.
- **[useMutationObserver](useMutationObserver.md)** - Watch for changes being made to the DOM tree.
- **[useParentElement](useParentElement.md)** - Get parent element of the given element.
- **[useResizeObserver](useResizeObserver.md)** - Reports changes to the dimensions of an Element's content or the border-box.
- **[useWindowFocus](useWindowFocus.md)** - Reactively track window focus.
- **[useWindowScroll](useWindowScroll.md)** - Reactive window scroll.
- **[useWindowSize](useWindowSize.md)** - Reactive window size.

## Animation

- **[useAnimate](useAnimate.md)** - Reactive Web Animations API.
- **[useInterval](useInterval.md)** - Reactive counter increases on every interval.
- **[useIntervalFn](useIntervalFn.md)** - Wrapper for `setInterval` with controls.
- **[useNow](useNow.md)** - Reactive current Date instance.
- **[useRafFn](useRafFn.md)** - Call function on every `requestAnimationFrame`.
- **[useTimeout](useTimeout.md)** - Update value after a given time with controls.
- **[useTimeoutFn](useTimeoutFn.md)** - Wrapper for `setTimeout` with controls.
- **[useTimestamp](useTimestamp.md)** - Reactive current timestamp.
- **[useTransition](useTransition.md)** - Transition between values.

## Component

- **[computedInject](computedInject.md)** - Combine `computed` and `inject`.
- **[createReusableTemplate](createReusableTemplate.md)** - Define and reuse template inside the component scope.
- **[createTemplatePromise](createTemplatePromise.md)** - Template as Promise.
- **[templateRef](templateRef.md)** - Shorthand for binding ref to template element.
- **[tryOnBeforeMount](tryOnBeforeMount.md)** - Safe `onBeforeMount`.
- **[tryOnBeforeUnmount](tryOnBeforeUnmount.md)** - Safe `onBeforeUnmount`.
- **[tryOnMounted](tryOnMounted.md)** - Safe `onMounted`.
- **[tryOnScopeDispose](tryOnScopeDispose.md)** - Safe `onScopeDispose`.
- **[tryOnUnmounted](tryOnUnmounted.md)** - Safe `onUnmounted`.
- **[unrefElement](unrefElement.md)** - Retrieves the underlying DOM element from a Vue ref or component instance.
- **[useCurrentElement](useCurrentElement.md)** - Get the DOM element of current component as a ref.
- **[useMounted](useMounted.md)** - Mounted state in ref.
- **[useTemplateRefsList](useTemplateRefsList.md)** - Shorthand for binding refs to template elements and components inside `v-for`.
- **[useVirtualList](useVirtualList.md)** - Create virtual lists with ease.
- **[useVModel](useVModel.md)** - Shorthand for v-model binding.
- **[useVModels](useVModels.md)** - Shorthand for props v-model binding.

## Watch

- **[until](until.md)** - Promised one-time watch for changes.
- **[watchArray](watchArray.md)** - Similar to `watch`, but provides added and removed elements to the callback function.
- **[watchAtMost](watchAtMost.md)** - `watch` with the number of times triggered.
- **[watchDebounced](watchDebounced.md)** - Debounced watch.
- **[watchDeep](watchDeep.md)** - Shorthand for watching value with {deep: true}
- **[watchIgnorable](watchIgnorable.md)** - Ignorable watch.
- **[watchImmediate](watchImmediate.md)** - Shorthand for watching value with {immediate: true}
- **[watchOnce](watchOnce.md)** - Shorthand for watching value with `{ once: true }`.
- **[watchPausable](watchPausable.md)** - Pausable watch.
- **[watchThrottled](watchThrottled.md)** - Throttled watch.
- **[watchTriggerable](watchTriggerable.md)** - Watch that can be triggered manually.
- **[watchWithFilter](watchWithFilter.md)** - `watch` with additional EventFilter control.
- **[whenever](whenever.md)** - Shorthand for watching value to be truthy.

## Reactivity

- **[computedAsync](computedAsync.md)** - Computed for async functions.
- **[computedEager](computedEager.md)** - Eager computed without lazy evaluation.
- **[computedWithControl](computedWithControl.md)** - Explicitly define the dependencies of a computed property.
- **[createRef](createRef.md)** - returns a deepRef or shallowRef depending on the deep param.
- **[extendRef](extendRef.md)** - Add extra attributes to Ref.
- **[reactify](reactify.md)** - Converts plain functions into reactive functions.
- **[reactifyObject](reactifyObject.md)** - apply reactify to an object.
- **[reactiveComputed](reactiveComputed.md)** - Computed reactive object.
- **[reactiveOmit](reactiveOmit.md)** - Reactively omit fields from a reactive object.
- **[reactivePick](reactivePick.md)** - Reactively pick fields from a reactive object.
- **[refAutoReset](refAutoReset.md)** - a ref which will be reset to the default value after some time.
- **[refDebounced](refDebounced.md)** - Debounce execution of a ref value.
- **[refDefault](refDefault.md)** - Apply a default value to a ref.
- **[refManualReset](refManualReset.md)** - create a ref with manual reset functionality.
- **[refThrottled](refThrottled.md)** - Throttle changing of a ref value.
- **[refWithControl](refWithControl.md)** - fine-grained controls over ref and its reactivity.
- **[syncRef](syncRef.md)** - Two-way refs synchronization.
- **[syncRefs](syncRefs.md)** - Keep target refs in sync with a source ref.
- **[toReactive](toReactive.md)** - Converts ref to reactive.
- **[toRef](toRef.md)** - Normalize value/ref/getter to ref or computed.
- **[toRefs](toRefs.md)** - Extended `toRefs` that also accepts refs of an object.

## Array

- **[useArrayDifference](useArrayDifference.md)** - Reactive get array difference of two arrays.
- **[useArrayEvery](useArrayEvery.md)** - Reactive `Array.every`.
- **[useArrayFilter](useArrayFilter.md)** - Reactive `Array.filter`.
- **[useArrayFind](useArrayFind.md)** - Reactive `Array.find`.
- **[useArrayFindIndex](useArrayFindIndex.md)** - Reactive `Array.findIndex`.
- **[useArrayFindLast](useArrayFindLast.md)** - Reactive `Array.findLast`.
- **[useArrayIncludes](useArrayIncludes.md)** - Reactive `Array.includes`.
- **[useArrayJoin](useArrayJoin.md)** - Reactive `Array.join`.
- **[useArrayMap](useArrayMap.md)** - Reactive `Array.map`.
- **[useArrayReduce](useArrayReduce.md)** - Reactive `Array.reduce`.
- **[useArraySome](useArraySome.md)** - Reactive `Array.some`.
- **[useArrayUnique](useArrayUnique.md)** - Reactive unique array.
- **[useSorted](useSorted.md)** - Reactive sort array.

## Time

- **[useCountdown](useCountdown.md)** - Wrapper for `useIntervalFn` that provides a countdown timer in seconds.
- **[useDateFormat](useDateFormat.md)** - Get the formatted date according to the string of tokens passed in.
- **[useTimeAgo](useTimeAgo.md)** - Reactive time ago.
- **[useTimeAgoIntl](useTimeAgoIntl.md)** - Reactive time ago with i18n support.

## Utilities

- **[createEventHook](createEventHook.md)** - Utility for creating event hooks.
- **[createUnrefFn](createUnrefFn.md)** - Make a plain function accepting ref and raw values as arguments.
- **[get](get.md)** - Shorthand for accessing `ref.value`.
- **[isClient](isClient.md)** - A boolean constant that checks if the code is running in a browser environment (client-side).
- **[isDefined](isDefined.md)** - Non-nullish checking type guard for Ref.
- **[makeDestructurable](makeDestructurable.md)** - Make isomorphic destructurable for object and array at the same time.
- **[set](set.md)** - Shorthand for `ref.value = x`.
- **[useAsyncQueue](useAsyncQueue.md)** - Executes each asynchronous task sequentially and passes the current task result to the next task.
- **[useBase64](useBase64.md)** - Reactive base64 transforming.
- **[useCached](useCached.md)** - Cache a ref with a custom comparator.
- **[useCloned](useCloned.md)** - Reactive clone of a ref.
- **[useConfirmDialog](useConfirmDialog.md)** - Creates event hooks to support modals and confirmation dialog chains.
- **[useCounter](useCounter.md)** - Basic counter with utility functions.
- **[useCycleList](useCycleList.md)** - Cycle through a list of items.
- **[useDebounceFn](useDebounceFn.md)** - Debounce execution of a function.
- **[useEventBus](useEventBus.md)** - a basic event bus.
- **[useMemoize](useMemoize.md)** - Cache results of functions depending on arguments and keep it reactive.
- **[useOffsetPagination](useOffsetPagination.md)** - Reactive offset pagination.
- **[usePrevious](usePrevious.md)** - Holds the previous value of a ref.
- **[useStepper](useStepper.md)** - Provides helpers for building a multi-step wizard interface.
- **[useSupported](useSupported.md)** - SSR compatibility isSupported.
- **[useThrottleFn](useThrottleFn.md)** - Throttle execution of a function.
- **[useTimeoutPoll](useTimeoutPoll.md)** - Use timeout to poll something.
- **[useToNumber](useToNumber.md)** - Reactively convert a string ref to number.
- **[useToString](useToString.md)** - Reactively convert a ref to string.
- **[useToggle](useToggle.md)** - A boolean switcher with utility functions.

## @Integrations

- **[useCookies](useCookies.md)** - Wrapper for `universal-cookie`.

## @Math

- **[logicAnd](math-logicAnd.md)** - `AND` condition for refs.
- **[logicNot](math-logicNot.md)** - `NOT` condition for ref.
- **[logicOr](math-logicOr.md)** - `OR` conditions for refs.
- **[useAbs](math-useAbs.md)** - Reactive `Math.abs`.
- **[useAverage](math-useAverage.md)** - Get the average of an array reactively.
- **[useCeil](math-useCeil.md)** - Reactive `Math.ceil`.
- **[useClamp](math-useClamp.md)** - Reactively clamp a value between two other values.
- **[useFloor](math-useFloor.md)** - Reactive `Math.floor`.
- **[useMax](math-useMax.md)** - Reactive `Math.max`.
- **[useMin](math-useMin.md)** - Reactive `Math.min`.
- **[usePrecision](math-usePrecision.md)** - Reactively set the precision of a number.
- **[useProjection](math-useProjection.md)** - Reactive numeric projection from one domain to another.
- **[useRound](math-useRound.md)** - Reactive `Math.round`.
- **[useSum](math-useSum.md)** - Get the sum of an array reactively.
- **[useTrunc](math-useTrunc.md)** - Reactive `Math.trunc`.

## @Motion

- **[useElementStyle](motion-useElementStyle.md)** - Sync a reactive object to a target element CSS styling.
- **[useElementTransform](motion-useElementTransform.md)** - Sync a reactive object to a target element CSS transform.
- **[useMotion](motion-useMotion.md)** - The core composable of this package.
- **[useMotionControls](motion-useMotionControls.md)** - Create motion controls from motion properties and motion transitions.
- **[useMotionFeatures](motion-useMotionFeatures.md)** - Register features such as variant sync, event listeners.
- **[useMotionProperties](motion-useMotionProperties.md)** - Access Motion Properties for a target element.
- **[useMotions](motion-useMotions.md)** - Access the motion instances from v-motion directives declared from templates.
- **[useMotionTransitions](motion-useMotionTransitions.md)** - Handle the multiple animations created when you animate your elements.
- **[useMotionVariants](motion-useMotionVariants.md)** - Handle the Variants state and selection.
- **[useSpring](motion-useSpring.md)** - Animate HTML or SVG Elements in your Vue components using spring animations.

## Additional Resources

- [VueUse Official Documentation](https://vueuse.org)
- [VueUse GitHub Repository](https://github.com/vueuse/vueuse)
- [Vue School Video Lessons](https://vueschool.io/lessons?friend=vueuse)