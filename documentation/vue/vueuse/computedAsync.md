# computedAsync

**Category**: Reactivity
**Export Size**: 1.1 kB
**Last Changed**: 2 weeks ago

Computed for async functions.

## Usage

`computedAsync` takes an asynchronous function as its first argument. The resolved value of the promise will be the value of the ref.

```ts
import { ref } from 'vue'
import { computedAsync } from '@vueuse/core'

const userId = ref(1)

const user = computedAsync(
  async () => {
    const response = await fetch(`https://jsonplaceholder.typicode.com/users/${userId.value}`)
    const data = await response.json()
    return data
  },
  null, // initial value
)

// change userId to trigger re-evaluation
userId.value = 2
```

## Dependency Tracking

`computedAsync` tracks dependencies just like `computed`. When any reactive dependency used inside the async function changes, `computedAsync` will re-evaluate.

## `onCancel` Callback

If the source changes before a previous async call has been resolved, `computedAsync` will invoke the `onCancel` callback. This is useful for canceling ongoing async calls.

```ts
import { computedAsync } from '@vueuse/core'
import { shallowRef } from 'vue'

const packageName = shallowRef('@vueuse/core')
const downloads = computedAsync(
  async (onCancel) => {
    const abortController = new AbortController()
    onCancel(() => abortController.abort())

    return await fetch(
      `https://api.npmjs.org/downloads/point/last-week/${packageName.value}`,
      { signal: abortController.signal },
    )
      .then(response => response.ok ? response.json() : { downloads: '—' })
      .then(result => result.downloads)
  },
  0, // initial value
)
```

## `evaluating` State

You can pass a ref to the `evaluating` option, which will be `true` while the async function is running and `false` otherwise. This is useful for showing loading states.

```ts
import { ref } from 'vue'
import { computedAsync } from '@vueuse/core'

const isLoading = ref(false)
const data = computedAsync(
  async () => { /* ... */ },
  null,
  isLoading, // pass the ref
)
```

## Lazy Evaluation

By default, `computedAsync` starts resolving immediately. You can set `lazy: true` in the options to make it start resolving only when it's first accessed.

```ts
import { computedAsync } from '@vueuse/core'

const data = computedAsync(
  async () => { /* ... */ },
  null,
  { lazy: true },
)
```

## Type Declarations

```ts
export declare function computedAsync<T>(
  fn: (onCancel: (cancelCallback: Fn) => void) => T | Promise<T>,
  initialState?: T,
  optionsOrRef?: Ref<boolean> | UseAsyncStateOptions<boolean, T>,
): Ref<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/computedAsync/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/computedAsync/index.md)
