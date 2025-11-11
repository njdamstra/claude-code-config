# useThrottledRefHistory

**Category**: State
**Export Size**: 1.47 kB
**Last Changed**: 7 months ago
**Related**: [useDebouncedRefHistory](useDebouncedRefHistory.md) [useRefHistory](useRefHistory.md)

Shorthand for `useRefHistory` with throttled filter.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useThrottledRefHistory/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqVVNFu2zAM/RXBl9pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

This function takes the first snapshot right after the counter's value was changed and the second with a delay of 1000ms.

```ts
import { useThrottledRefHistory } from '@vueuse/core'
import { shallowRef } from 'vue'

const counter = shallowRef(0)
const { history, undo, redo } = useThrottledRefHistory(counter, { deep: true, throttle: 1000 })
```

## Type Declarations

```ts
export type UseThrottledRefHistoryOptions < Raw , Serialized = Raw > = Omit < UseRefHistoryOptions < Raw , Serialized >, "eventFilter" > & {
  throttle ?: MaybeRef <number>
  trailing ?: boolean
}
export type UseThrottledRefHistoryReturn < Raw , Serialized = Raw , > = UseRefHistoryReturn < Raw , Serialized >
/**
 * Shorthand for [useRefHistory](https://vueuse.org/useRefHistory) with throttled filter.
 *
 * @see https://vueuse.org/useThrottledRefHistory
 * @param source
 * @param options
 */
export declare function useThrottledRefHistory < Raw , Serialized = Raw >(
  source : Ref < Raw >,
  options ?: UseThrottledRefHistoryOptions < Raw , Serialized >,
): UseThrottledRefHistoryReturn < Raw , Serialized >
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useThrottledRefHistory/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useThrottledRefHistory/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useThrottledRefHistory/index.md)

## Contributors

* Anthony Fu
* Roman Harmyder
* IlyaL
* Robin
* OrbisK
* Jelf
* Bodo Graumann
* wheat

## Changelog

* **v12.8.0** on 3/5/2025
  * `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.7.0** on 12/5/2023
  * `fccf2` - feat: upgrade deps (#3614)