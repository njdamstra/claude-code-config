# watchDebounced

Category: Watch

Export Size: 455 B

Alias: `debouncedWatch`

Debounced watch

## Usage

Similar to `watch`, but offering extra options `debounce` and `maxWait` which will be applied to the callback function.

```ts
import { watchDebounced } from '@vueuse/core'

watchDebounced(
  source,
  () => { console.log('changed!') },
  { debounce: 500, maxWait: 1000 },
)
```

It's essentially a shorthand for the following code:

```ts
import { watch, useDebounceFn } from '@vueuse/core'

watch(
  source,
  () => { console.log('changed!') },
  {
    eventFilter: useDebounceFn(500, { maxWait: 1000 }),
  },
)
```
