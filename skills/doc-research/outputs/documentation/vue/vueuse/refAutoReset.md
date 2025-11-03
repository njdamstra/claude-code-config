# refAutoReset

**Category**: Reactivity
**Export Size**: 183 B
**Last Changed**: 2 weeks ago

A ref that will be reset to the default value after some time.

## Usage

`refAutoReset` creates a ref that automatically resets to its initial value after a specified duration. This is useful for temporary states, like a "Copied!" message that should disappear after a few seconds.

```ts
import { refAutoReset } from '@vueuse/core'

// The ref will reset to 'default' after 1000ms (1 second)
const message = refAutoReset('default', 1000)

function showMessage() {
  // This new value will be active for 1000ms
  message.value = 'This is a temporary message'
}
```

When you set a new value, the timer starts. After the specified delay, the ref's value automatically reverts to the default value provided during creation.

## Type Declarations

```ts
/**
 * A ref that will be reset to the default value after some time.
 *
 * @see https://vueuse.org/refAutoReset
 * @param defaultValue The value to be set.
 * @param afterMs A zero-or-greater value representing the delay in milliseconds.
 */
export declare function refAutoReset<T>(
  defaultValue: T,
  afterMs?: number,
): Ref<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/refAutoReset/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/refAutoReset/index.md)
