# useDebouncedRefHistory

**Category**: State
**Export Size**: 1.39 kB
**Last Changed**: 7 months ago
**Related**: [useRefHistory](useRefHistory.md) [useThrottledRefHistory](useThrottledRefHistory.md)

Shorthand for `useRefHistory` with debounced filter.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDebouncedRefHistory/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqVVNFu2zAM/RXBl9pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

This function takes a snapshot of your counter after 1000ms when the value of it starts to change.

```ts
import { useDebouncedRefHistory } from '@vueuse/core'
import { shallowRef } from 'vue'

const counter = shallowRef(0)
const { history, undo, redo } = useDebouncedRefHistory(counter, {
  deep: true,
  debounce: 1000,
})
```

## Type Declarations

```ts
/**
 * Shorthand for [useRefHistory](https://vueuse.org/useRefHistory) with debounce filter.
 *
 * @see https://vueuse.org/useDebouncedRefHistory
 * @param source
 * @param options
 */
export declare function useDebouncedRefHistory<Raw, Serialized = Raw>(
  source: Ref<Raw>,
  options?: Omit<UseRefHistoryOptions<Raw, Serialized>, "eventFilter"> & {
    debounce?: MaybeRefOrGetter<number>
  },
): UseRefHistoryReturn<Raw, Serialized>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDebouncedRefHistory/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDebouncedRefHistory/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDebouncedRefHistory/index.md)

## Contributors

* Anthony Fu
* IlyaL
* Anthony Fu
* Roman Harmyder
* Robin
* OrbisK
* wheat

## Changelog

### v12.8.0 on 3/5/2025
- `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)

### v12.0.0-beta.1 on 11/21/2024
- `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
