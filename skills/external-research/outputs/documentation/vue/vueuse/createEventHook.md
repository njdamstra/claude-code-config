# createEventHook

**Category:** Utilities
**Export Size:** 247 B
**Last Changed:** 2 months ago

Utility for creating event hooks

## Usage

### Creating a function that uses `createEventHook`

```ts
import { createEventHook } from '@vueuse/core'

export function useMyFetch(url: string) {
  const fetchResult = createEventHook<Response>()
  const fetchError = createEventHook<any>()

  fetch(url)
    .then(result => fetchResult.trigger(result))
    .catch(error => fetchError.trigger(error.message))

  return {
    onResult: fetchResult.on,
    onError: fetchError.on,
  }
}
```

### Using a function that uses `createEventHook`

```vue
<script setup lang="ts">
import { useMyFetch } from './my-fetch-function'

const { onResult, onError } = useMyFetch('my api url')

onResult((result) => {
  console.log(result)
})

onError((error) => {
  console.error(error)
})
</script>
```

## Type Declarations

```ts
type EventHookOn<T> = (fn: (param: T) => void) => {
  off: () => void
}

export type EventHookOff<T = any> = (fn: (param: T) => void) => void

export type EventHookTrigger<T = any> = (
  ...params: Parameters<(param: T) => void>
) => Promise<unknown[]>

export interface EventHook<T = any> {
  on: EventHookOn<T>
  off: EventHookOff<T>
  trigger: EventHookTrigger<T>
  clear: () => void
}

/**
 * Utility for creating event hooks
 *
 * @see https://vueuse.org/createEventHook
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function createEventHook<T = any>(): EventHook<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/createEventHook/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/createEventHook/index.md)

## Changelog

**v13.6.0** (7/28/2025)
- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

**v13.1.0** (4/8/2025)
- feat(shared): ensure return types exists (#4659)

**v12.6.0** (2/13/2025)
- fix: type check for multiple arguments (#4555)

**v12.1.0** (12/22/2024)
- feat: add `clear` function (#4378)

**v10.7.0** (12/4/2023)
- fix: `trigger` should not ignore falsy values (#3561)
- fix: make createEventHook union type can be inferred correctly (#3569)

**v10.6.0** (11/9/2023)
- feat: allow trigger to optionally have no parameters (#3507)

## Notes

The source code for this function was inspired by vue-apollo's `useEventHook` util.
