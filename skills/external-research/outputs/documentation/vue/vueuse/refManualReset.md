# refManualReset

**Category**: Reactivity
**Export Size**: 118 B
**Last Changed**: 2 weeks ago

Create a ref with a manual reset function.

## Usage

`refManualReset` creates a ref that includes a `reset()` method, allowing you to manually revert the ref's value back to its initial state at any time.

```ts
import { refManualReset } from '@vueuse/core'

const message = refManualReset('Default Message')

console.log(message.value) // 'Default Message'

message.value = 'A new message'
console.log(message.value) // 'A new message'

message.reset()
console.log(message.value) // 'Default Message'
```

This is a convenient way to manage state that needs to be resettable without having to store the initial value separately.

## Type Declarations

```ts
/**
 * Create a ref with a manual reset function.
 *
 * @see https://vueuse.org/refManualReset
 * @param defaultValue The value to be set.
 */
export declare function refManualReset<T>(
  defaultValue: T,
): Ref<T> & {
  reset: () => void
}
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/refManualReset/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/refManualReset/index.md)
