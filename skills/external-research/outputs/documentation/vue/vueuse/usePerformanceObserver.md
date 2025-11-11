# usePerformanceObserver

**Category**: Browser
**Export Size**: 391 B
**Last Changed**: last year

Observe performance metrics.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePerformanceObserver/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVM1u2zAQ/isHl1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

```ts
import { usePerformanceObserver } from '@vueuse/core'

const entrys = ref<PerformanceEntry[]>([])

usePerformanceObserver({
  entryTypes: ['paint'],
}, (list) => {
  entrys.value = list.getEntries()
})
```

## Type Declarations

```ts
export type UsePerformanceObserverOptions = PerformanceObserverInit & ConfigurableWindow & {
  /**
   * Start the observer immediate.
   *
   * @default true
   */
  immediate?: boolean
}

/**
 * Observe performance metrics.
 *
 * @see https://vueuse.org/usePerformanceObserver
 * @param options
 */
export declare function usePerformanceObserver(
  options: UsePerformanceObserverOptions,
  callback: PerformanceObserverCallback,
): {
  isSupported: ComputedRef<boolean>
  start: () => void
  stop: () => void
}
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePerformanceObserver/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/usePerformanceObserver/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/usePerformanceObserver/index.md)

## Contributors

* Anthony Fu
* IlyaL
* Anthony Fu
* geekreal

## Changelog

No recent changes
