# useRafFn

**Category:** Animation
**Export Size:** 443 B
**Last Changed:** 8 months ago

Call function on every `requestAnimationFrame`. With controls of pausing and resuming.

## Usage

```ts
import { useRafFn } from '@vueuse/core'
import { ref } from 'vue'

const count = ref(0)

const { pause, resume } = useRafFn(() => {
  count.value++
  console.log(count.value)
})
```

## Type Declarations

```ts
export interface UseRafFnCallbackArguments {
  /**
   * Time elapsed between this and the last frame.
   */
  delta: number

  /**
   * Time elapsed since the creation of the web page. See {@link https://developer.mozilla.org/en-US/docs/Web/API/DOMHighResTimeStamp#the_time_origin Time origin}.
   */
  timestamp: DOMHighResTimeStamp
}

export interface UseRafFnOptions extends ConfigurableWindow {
  /**
   * Start the requestAnimationFrame loop immediately on creation
   *
   * @default true
   */
  immediate?: boolean

  /**
   * The maximum frame per second to execute the function.
   * Set to `undefined` to disable the limit.
   *
   * @default undefined
   */
  fpsLimit?: MaybeRefOrGetter<number>

  /**
   * After the requestAnimationFrame loop executed once, it will be automatically stopped.
   *
   * @default false
   */
  once?: boolean
}

/**
 * Call function on every `requestAnimationFrame`. With controls of pausing and resuming.
 *
 * @see https://vueuse.org/useRafFn
 * @param fn
 * @param options
 */
export declare function useRafFn(
  fn: (args: UseRafFnCallbackArguments) => void,
  options?: UseRafFnOptions,
): Pausable
```

## Key Features

- **requestAnimationFrame Loop**: Executes callback on every animation frame
- **Pausable Controls**: Pause and resume the animation loop
- **FPS Limiting**: Optional frame rate limiting (can be reactive)
- **Delta Time**: Provides time elapsed between frames
- **Timestamp**: Access to high-resolution timestamp
- **Immediate Start**: Auto-start on creation (configurable)
- **Once Option**: Execute only once then stop

## Options

- `immediate` - Start the requestAnimationFrame loop immediately on creation (default: `true`)
- `fpsLimit` - Maximum frames per second to execute the function (default: `undefined` - no limit). Can be a reactive value.
- `once` - Execute once then automatically stop (default: `false`)

## Callback Arguments

The callback function receives an object with:
- `delta` - Time elapsed in milliseconds between this frame and the last frame
- `timestamp` - DOMHighResTimeStamp representing time elapsed since page creation

## Return Value

Returns a `Pausable` object with:
- `pause()` - Pause the animation loop
- `resume()` - Resume the animation loop
- `isActive` - Ref indicating if the loop is currently running

## Examples

### Basic Animation Loop
```ts
const { pause, resume } = useRafFn(() => {
  // Animation code here
  updateAnimation()
})
```

### With FPS Limiting
```ts
const fps = ref(30)

useRafFn(() => {
  // Will run at max 30 FPS
  updateGameLogic()
}, { fpsLimit: fps })

// Change FPS dynamically
fps.value = 60
```

### Using Delta Time
```ts
useRafFn(({ delta, timestamp }) => {
  // delta: time since last frame in ms
  // timestamp: total time since page load

  position.value += velocity.value * (delta / 1000)
})
```

### Execute Once
```ts
useRafFn(() => {
  // Runs once on next frame then stops
  performInitialAnimation()
}, { once: true })
```

### Manual Control
```ts
const { pause, resume, isActive } = useRafFn(() => {
  updateAnimation()
}, { immediate: false })

// Start manually
resume()

// Pause when needed
pause()

// Check if running
if (isActive.value) {
  // Animation is running
}
```

## Use Cases

- **Smooth Animations**: Create frame-based animations
- **Game Loops**: Implement game update logic
- **Physics Simulations**: Run physics calculations on each frame
- **Performance Monitoring**: Track FPS and frame timing
- **Canvas Rendering**: Update canvas drawings smoothly
- **DOM Animations**: Alternative to CSS animations for complex logic

## References

- [VueUse Documentation](https://vueuse.org/core/useRafFn/)
- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/core/useRafFn/index.ts)
- [requestAnimationFrame MDN](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame)
- [DOMHighResTimeStamp MDN](https://developer.mozilla.org/en-US/docs/Web/API/DOMHighResTimeStamp)
