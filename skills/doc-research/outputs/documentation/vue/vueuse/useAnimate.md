# useAnimate

**Category:** Animation
**Export Size:** 1.75 kB
**Last Changed:** 2 months ago

Reactive [Web Animations API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API).

## Usage

### Basic Usage

The `useAnimate` function returns the animation and its control functions.

```vue
<script setup lang="ts">
import { useAnimate } from '@vueuse/core'
import { ref } from 'vue'

const el = ref('el')
const {
  isSupported,
  animate,

  // actions
  play,
  pause,
  reverse,
  finish,
  cancel,

  // states
  pending,
  playState,
  replaceState,
  startTime,
  currentTime,
  timeline,
  playbackRate,
} = useAnimate(el, { transform: 'rotate(360deg)' }, 1000)
</script>

<template>
  <div ref="el" style="display:inline-block">useAnimate</div>
</template>
```

### Custom Keyframes

Either an array of keyframe objects, or a keyframe object, or a `ref`. See [Keyframe Formats](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API/Keyframe_Formats) for more details.

```ts
// Single keyframe object
const keyframes = { transform: 'rotate(360deg)' }

// Array of keyframes
const keyframes = [
  { transform: 'rotate(0deg)' },
  { transform: 'rotate(360deg)' },
]

// Reactive keyframes
const keyframes = ref([
  { clipPath: 'circle(20% at 0% 30%)' },
  { clipPath: 'circle(20% at 50% 80%)' },
  { clipPath: 'circle(20% at 100% 30%)' },
])

useAnimate(el, keyframes, 1000)
```

## Type Declarations

```ts
export interface UseAnimateOptions
  extends KeyframeAnimationOptions,
    ConfigurableWindow {
  /**
   * Will automatically run play when `useAnimate` is used
   *
   * @default true
   */
  immediate?: boolean

  /**
   * Whether to commits the end styling state of an animation to the element being animated
   * In general, you should use `fill` option with this.
   *
   * @default false
   */
  commitStyles?: boolean

  /**
   * Whether to persists the animation
   *
   * @default false
   */
  persist?: boolean

  /**
   * Executed after animation initialization
   */
  onReady?: (animate: Animation) => void

  /**
   * Callback when error is caught.
   */
  onError?: (e: unknown) => void
}

export type UseAnimateKeyframes = MaybeRef<
  Keyframe[] | PropertyIndexedKeyframes | null
>

export interface UseAnimateReturn {
  isSupported: Ref<boolean>
  animate: Ref<Animation | undefined>
  play: () => void
  pause: () => void
  reverse: () => void
  finish: () => void
  cancel: () => void
  pending: Ref<boolean>
  playState: Ref<AnimationPlayState>
  replaceState: Ref<AnimationReplaceState>
  startTime: Ref<CSSNumberish | number | null>
  currentTime: Ref<CSSNumberish | null>
  timeline: Ref<AnimationTimeline | null>
  playbackRate: Ref<number>
}

/**
 * Reactive Web Animations API
 *
 * @see https://vueuse.org/useAnimate
 * @param target
 * @param keyframes
 * @param options
 */
export declare function useAnimate(
  target: MaybeRefOrGetter,
  keyframes: UseAnimateKeyframes,
  options?: number | UseAnimateOptions,
): UseAnimateReturn
```

## Key Features

- **Web Animations API**: Full access to native browser animation capabilities
- **Reactive Keyframes**: Support for reactive keyframe updates
- **Animation Controls**: Play, pause, reverse, finish, cancel
- **Animation States**: Access to pending, playState, replaceState, etc.
- **Timeline Control**: Access to animation timeline and playback rate
- **Commit Styles**: Option to persist animation end state
- **Auto-play**: Automatic animation start (configurable)

## Options

- `immediate` - Automatically run play when useAnimate is used (default: `true`)
- `commitStyles` - Commits the end styling state to the element (default: `false`)
- `persist` - Persists the animation (default: `false`)
- `onReady` - Executed after animation initialization
- `onError` - Callback when error is caught

## Return Values

### Actions
- `play()` - Play the animation
- `pause()` - Pause the animation
- `reverse()` - Reverse the animation
- `finish()` - Finish the animation
- `cancel()` - Cancel the animation

### States
- `isSupported` - Whether Web Animations API is supported
- `animate` - The Animation instance
- `pending` - Whether animation is pending
- `playState` - Current play state (idle, running, paused, finished)
- `replaceState` - Current replace state
- `startTime` - Animation start time
- `currentTime` - Current animation time
- `timeline` - Animation timeline
- `playbackRate` - Playback rate

## Examples

### Rotation Animation
```ts
useAnimate(el, { transform: 'rotate(360deg)' }, 1000)
```

### Multi-step Animation
```ts
useAnimate(el, [
  { transform: 'scale(1)', opacity: 1 },
  { transform: 'scale(1.2)', opacity: 0.8 },
  { transform: 'scale(1)', opacity: 1 },
], {
  duration: 1000,
  iterations: Infinity,
})
```

### With Easing
```ts
useAnimate(el,
  { transform: 'translateX(100px)' },
  {
    duration: 500,
    easing: 'ease-in-out',
    fill: 'forwards'
  }
)
```

## References

- [VueUse Documentation](https://vueuse.org/core/useAnimate/)
- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/core/useAnimate/index.ts)
- [Web Animations API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API)
- [Keyframe Formats](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API/Keyframe_Formats)
