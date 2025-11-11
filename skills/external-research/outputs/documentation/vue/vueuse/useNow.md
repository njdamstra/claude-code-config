# useNow

**Category:** Animation
**Export Size:** 676 B
**Last Changed:** 2 months ago

Reactive current Date instance.

## Usage

### Basic Usage

```ts
import { useNow } from '@vueuse/core'

const now = useNow()
```

### With Controls

```ts
const { now, pause, resume } = useNow({ controls: true })
```

## Component Usage

This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UseNow v-slot="{ now, pause, resume }">
    Now: {{ now }}
    <button @click="pause()">Pause</button>
    <button @click="resume()">Resume</button>
  </UseNow>
</template>
```

## Type Declarations

```ts
export interface UseNowOptions<Controls extends boolean> {
  /**
   * Expose more controls
   *
   * @default false
   */
  controls?: Controls

  /**
   * Start the clock immediately
   *
   * @default true
   */
  immediate?: boolean

  /**
   * Update interval in milliseconds, or use requestAnimationFrame
   *
   * @default requestAnimationFrame
   */
  interval?: "requestAnimationFrame" | number
}

/**
 * Reactive current Date instance.
 *
 * @see https://vueuse.org/useNow
 * @param options
 */
export declare function useNow(
  options?: UseNowOptions<false>
): Ref<Date>

export declare function useNow(
  options: UseNowOptions<true>
): {
  now: Ref<Date>
} & Pausable

export type UseNowReturn = ReturnType<typeof useNow>
```

## Key Features

- **Reactive Date**: Automatically updating Date instance
- **requestAnimationFrame**: Uses RAF by default for smooth updates
- **Custom Intervals**: Can specify custom update intervals in milliseconds
- **Pausable**: Optional controls for pause/resume functionality
- **Immediate Start**: Auto-start on creation (configurable)

## Options

- `controls` - Expose pause/resume controls (default: `false`)
- `immediate` - Start the clock immediately (default: `true`)
- `interval` - Update interval in milliseconds, or use `'requestAnimationFrame'` (default: `'requestAnimationFrame'`)

## Return Value

### Without Controls
Returns a `Ref<Date>` that updates automatically.

### With Controls
Returns an object with:
- `now` - Ref containing the current Date
- `pause()` - Pause the clock
- `resume()` - Resume the clock
- `isActive` - Ref indicating if the clock is running

## Examples

### Display Current Time
```vue
<script setup>
import { useNow } from '@vueuse/core'

const now = useNow()
</script>

<template>
  <div>{{ now.toLocaleTimeString() }}</div>
</template>
```

### With Custom Interval
```ts
// Update every second
const now = useNow({ interval: 1000 })
```

### With Pause/Resume
```ts
const { now, pause, resume, isActive } = useNow({ controls: true })

// Pause the clock
pause()

// Resume the clock
resume()

// Check if running
console.log(isActive.value)
```

### Delayed Start
```ts
const { now, resume } = useNow({
  controls: true,
  immediate: false
})

// Start manually later
setTimeout(resume, 5000)
```

## Use Cases

- **Live Clocks**: Display current time that updates automatically
- **Elapsed Time**: Calculate time since an event
- **Time-based Animations**: Trigger animations based on current time
- **Countdowns**: Create countdown timers
- **Scheduling**: Check current time for scheduled tasks
- **Time Displays**: Show formatted current time

## Comparison with useTimestamp

- `useNow()` - Returns a Date object, better for date operations
- `useTimestamp()` - Returns a number (milliseconds), better for calculations

## References

- [VueUse Documentation](https://vueuse.org/core/useNow/)
- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/core/useNow/index.ts)
