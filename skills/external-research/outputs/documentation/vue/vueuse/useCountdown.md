# useCountdown

**Category:** Time
**Export Size:** 565 B
**Last Changed:** 7 months ago

Wrapper for [`useIntervalFn`](https://vueuse.org/shared/useIntervalFn/) that provides a countdown timer in seconds.

## Usage

### Basic Usage

```ts
import { useCountdown } from '@vueuse/core'

const countdown = 5
const { count, pause, resume, stop, start } = useCountdown(countdown, {
  onFinish() {
    console.log('Countdown finished!')
  },
  onTick() {
    console.log('Tick')
  }
})
```

### Dynamic Countdown

You can use a `ref` to change the initial countdown. `start()` and `resume()` also accept a new countdown value for the next countdown.

```ts
import { useCountdown } from '@vueuse/core'
import { ref } from 'vue'

const countdown = ref(5)
const { count, start, reset } = useCountdown(countdown, {})

// change the countdown value
countdown.value = 10

// start a new countdown with 2 seconds
start(2)

// reset the countdown to 4, but do not start it
reset(4)

// start the countdown with the current value of `countdown`
start()
```

## Type Declarations

```ts
export interface UseCountdownOptions {
  /**
   *  Interval for the countdown in milliseconds. Default is 1000ms.
   */
  interval?: MaybeRefOrGetter<number>

  /**
   * Callback function called when the countdown reaches 0.
   */
  onFinish?: () => void

  /**
   * Callback function called on each tick of the countdown.
   */
  onTick?: () => void

  /**
   * Start the countdown immediately
   *
   * @default false
   */
  immediate?: boolean
}

export interface UseCountdownReturn extends Pausable {
  /**
   * Current countdown value.
   */
  count: Ref<number>

  /**
   * Resets the countdown and repeatsLeft to their initial values.
   */
  reset: (newCountdown?: MaybeRefOrGetter<number>) => void

  /**
   * Stops the countdown and resets its state.
   */
  stop: () => void

  /**
   * Reset the countdown and start it again.
   */
  start: (newCountdown?: MaybeRefOrGetter<number>) => void
}

/**
 * Wrapper for `useIntervalFn` that provides a countdown timer in seconds.
 *
 * @param initialCountdown
 * @param options
 *
 * @see https://vueuse.org/useCountdown
 */
export declare function useCountdown(
  initialCountdown: MaybeRefOrGetter<number>,
  options?: UseCountdownOptions,
): UseCountdownReturn
```

## Key Features

- **Pausable Controls**: Pause, resume, stop, and start the countdown
- **Callback Support**: Execute functions on each tick or when finished
- **Custom Intervals**: Configurable interval (default: 1000ms)
- **Dynamic Values**: Change countdown value on the fly
- **Reactive**: Built on Vue's reactivity system
- **Immediate Start**: Optional auto-start on creation

## Options

- `interval` - Interval for the countdown in milliseconds (default: `1000`)
- `onFinish` - Callback function called when the countdown reaches 0
- `onTick` - Callback function called on each tick of the countdown
- `immediate` - Start the countdown immediately (default: `false`)

## Return Values

### Properties
- `count` - Ref containing the current countdown value

### Methods
- `start(newCountdown?)` - Reset the countdown and start it again (optionally with a new value)
- `pause()` - Pause the countdown
- `resume()` - Resume the countdown
- `stop()` - Stop the countdown and reset its state
- `reset(newCountdown?)` - Reset the countdown to initial or new value without starting
- `isActive` - Ref indicating if the countdown is currently running

## Examples

### Simple Countdown
```ts
const { count, start } = useCountdown(10)
start()
// count: 10, 9, 8, 7, ...
```

### With Callbacks
```ts
const { count, start } = useCountdown(5, {
  onTick() {
    console.log(`${count.value} seconds remaining`)
  },
  onFinish() {
    console.log('Blast off! 🚀')
  }
})

start()
```

### Custom Interval
```ts
// Countdown every 500ms instead of 1000ms
const { count, start } = useCountdown(10, {
  interval: 500
})
```

### Pause and Resume
```ts
const { count, start, pause, resume, isActive } = useCountdown(30)

start()

// Pause after 5 seconds
setTimeout(pause, 5000)

// Resume after 10 seconds
setTimeout(resume, 10000)

// Check if active
console.log(isActive.value) // true/false
```

### Dynamic Countdown Values
```ts
const initialCount = ref(10)
const { count, start, reset } = useCountdown(initialCount)

// Start with initial value (10)
start()

// Change the base countdown value
initialCount.value = 20

// Start a new countdown with 15 seconds
start(15)

// Reset to 30 seconds but don't start
reset(30)

// Start with current value of initialCount
start()
```

### Immediate Start
```ts
const { count } = useCountdown(60, {
  immediate: true,
  onFinish() {
    alert('Time is up!')
  }
})
// Starts immediately
```

### Complete Example
```vue
<script setup>
import { useCountdown } from '@vueuse/core'
import { ref } from 'vue'

const duration = ref(10)
const { count, start, pause, resume, stop, isActive } = useCountdown(duration, {
  onFinish() {
    console.log('Countdown complete!')
  }
})

function startCountdown() {
  start(duration.value)
}
</script>

<template>
  <div>
    <p>Time remaining: {{ count }} seconds</p>
    <input v-model.number="duration" type="number" />
    <button @click="startCountdown">Start</button>
    <button @click="pause" :disabled="!isActive">Pause</button>
    <button @click="resume" :disabled="isActive">Resume</button>
    <button @click="stop">Stop</button>
  </div>
</template>
```

## Use Cases

- **Countdown Timers**: Display time remaining for offers, events, etc.
- **Game Timers**: Time-limited game mechanics
- **OTP Expiration**: Show time remaining for one-time passwords
- **Session Timeouts**: Warn users before session expires
- **Pomodoro Timers**: Work/break interval timers
- **Rocket Launches**: Countdown to events
- **Quiz Timers**: Time limits for questions
- **Auction Timers**: Countdown to bid closure

## Comparison with Alternatives

### vs useInterval
- **Purpose-built**: Designed specifically for countdowns
- **Simpler API**: Countdown-specific methods (start, stop, reset)
- **Callback Support**: Built-in onFinish and onTick callbacks

### vs setInterval
- **Reactive**: Built on Vue's reactivity system
- **Pausable**: Easy pause/resume functionality
- **Auto-cleanup**: Automatically cleaned up on component unmount

## References

- [VueUse Documentation](https://vueuse.org/core/useCountdown/)
- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/core/useCountdown/index.ts)
- [useIntervalFn](https://vueuse.org/shared/useIntervalFn/)
