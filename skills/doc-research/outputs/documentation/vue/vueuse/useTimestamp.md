# useTimestamp

**Category:** Animation
**Export Size:** 709 B
**Last Changed:** 8 months ago

Reactive current timestamp

## Usage

### Basic Usage

```ts
import { useTimestamp } from '@vueuse/core'

const timestamp = useTimestamp({ offset: 0 })
```

### With Controls

```ts
const { timestamp, pause, resume } = useTimestamp({ controls: true })
```

## Demo

Provides a reactive timestamp that updates automatically.

## Component Usage

This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UseTimestamp v-slot="{ timestamp, pause, resume }">
    Current Time: {{ timestamp }}
    <button @click="pause()">Pause</button>
    <button @click="resume()">Resume</button>
  </UseTimestamp>
</template>
```

## Type Declarations

```ts
export interface UseTimestampOptions<Controls extends boolean> {
  /**
   * Expose more controls
   *
   * @default false
   */
  controls?: Controls

  /**
   * Offset value adding to the value
   *
   * @default 0
   */
  offset?: number

  /**
   * Update the timestamp immediately
   *
   * @default true
   */
  immediate?: boolean

  /**
   * Update interval, or use requestAnimationFrame
   *
   * @default requestAnimationFrame
   */
  interval?: "requestAnimationFrame" | number

  /**
   * Callback on each update
   */
  callback?: (timestamp: number) => void
}

/**
 * Reactive current timestamp.
 *
 * @see https://vueuse.org/useTimestamp
 * @param options
 */
export declare function useTimestamp(
  options?: UseTimestampOptions<false>
): Ref<number>

export declare function useTimestamp(
  options: UseTimestampOptions<true>
): {
  timestamp: Ref<number>
} & Pausable

export type UseTimestampReturn = ReturnType<typeof useTimestamp>
```

## Key Features

- **Reactive Timestamp**: Automatically updates timestamp value
- **requestAnimationFrame**: Uses RAF by default for smooth updates
- **Custom Intervals**: Can specify custom update intervals in milliseconds
- **Offset Support**: Add offset to timestamp value
- **Pausable**: Optional controls for pause/resume functionality
- **Callback Support**: Execute callback on each update

## Options

- `controls` - Expose pause/resume controls (default: `false`)
- `offset` - Offset value to add to timestamp (default: `0`)
- `immediate` - Update timestamp immediately (default: `true`)
- `interval` - Update interval, or use `'requestAnimationFrame'` (default: `'requestAnimationFrame'`)
- `callback` - Callback function executed on each update

## References

- [VueUse Documentation](https://vueuse.org/core/useTimestamp/)
- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/core/useTimestamp/index.ts)
