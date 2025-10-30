# useEventBus

**Category**: Utilities
**Export Size**: 366 B
**Last Changed**: 2 weeks ago

A basic event bus.

## Usage

`useEventBus` provides a simple publish-subscribe mechanism for communication between different parts of your application.

### Basic Usage

Create an event bus by providing a unique key.

```ts
import { useEventBus } from '@vueuse/core'

const bus = useEventBus<string>('my-event')

// Listener function
const listener = (event: string) => {
  console.log(`Event received: ${event}`)
}

// Subscribe to the event
const unsubscribe = bus.on(listener)

// Emit an event
bus.emit('Hello, world!')

// Unsubscribe
unsubscribe()
```

### Automatic Unregistration

Listeners registered within a component's `setup` function are automatically unregistered when the component is unmounted, preventing memory leaks.

### Type-Safe Events with `EventBusKey`

For better type safety in TypeScript, you can use `EventBusKey`.

```ts
// event-keys.ts
import type { EventBusKey } from '@vueuse/core'

export const myCustomEvent: EventBusKey<{ id: number }> = Symbol('my-custom-event')

// componentA.vue
import { useEventBus } from '@vueuse/core'
import { myCustomEvent } from './event-keys'

const bus = useEventBus(myCustomEvent)
bus.emit({ id: 123 })

// componentB.vue
import { useEventBus } from '@vueuse/core'
import { myCustomEvent } from './event-keys'

const bus = useEventBus(myCustomEvent)
bus.on((payload) => {
  // payload is typed as { id: number }
  console.log(payload.id)
})
```

## API

- `bus.on(listener)`: Register a listener. Returns an `unsubscribe` function.
- `bus.once(listener)`: Register a listener that only fires once.
- `bus.emit(payload)`: Emit an event to all listeners.
- `bus.off(listener)`: Remove a specific listener.
- `bus.reset()`: Removes all listeners for the event bus.

## Type Declarations

```ts
export interface EventBus<T> {
  on: (listener: (event: T) => void) => () => void
  once: (listener: (event: T) => void) => void
  emit: (event: T) => void
  off: (listener: (event: T) => void) => void
  reset: () => void
}

export declare function useEventBus<T = void>(
  key: EventBusKey<T> | string | number,
): EventBus<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useEventBus/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useEventBus/index.md)
