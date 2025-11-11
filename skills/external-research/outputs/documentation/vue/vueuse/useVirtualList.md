# useVirtualList

**Category**: Component
**Export Size**: 1.74 kB
**Last Changed**: 3 months ago

---

**WARNING**: Consider using `vue-virtual-scroller` instead, if you are looking for more features.

Create virtual lists with ease. Virtual lists (sometimes called virtual scrollers) allow you to render a large number of items performantly. They only render the minimum number of DOM nodes necessary to show the items within the container element by using the wrapper element to emulate the container element's full height.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useVirtualList/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrQVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXnfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

**WARNING**: Consider using `vue-virtual-scroller` instead, if you are looking for more features.

Create virtual lists with ease. Virtual lists (sometimes called virtual scrollers) allow you to render a large number of items performantly. They only render the minimum number of DOM nodes necessary to show the items within the container element by using the wrapper element to emulate the container element's full height.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useVirtualList/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrQVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXnfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

Jump to index
Go
Filter list by size

- Row 0 (small)
- Row 1 (large)
- Row 2 (small)
- Row 3 (large)
- Row 4 (small)
- Row 5 (large)
- Row 6 (small)
- Row 7 (large)
- Row 8 (small)
- Row 9 (large)
- Row 10 (small)
- Row 11 (large)
- Row 12 (small)
- Row 13 (large)
- Row 14 (small)

## Usage

### Simple list

```ts
import { useVirtualList } from '@vueuse/core'

const {
  list,
  containerProps,
  wrapperProps
} = useVirtualList(
  Array.from(Array.from({
    length: 99999
  }).keys()), { // Keep `itemHeight` in sync with the item's row.
    itemHeight: 22,
  },
)
```

### Config

| State | Type | Description |
|---|---|---|
| `list` | `ComputedRef<T[]>` | The list of items to be rendered. |
| `containerProps` | `Object` | Props to be passed to the container element. |
| `wrapperProps` | `Object` | Props to be passed to the wrapper element. |
| `scrollTo` | `Function` | Scrolls to the specified index. |

## Type Declarations

```ts
export interface UseVirtualListOptions {
  /**
   * The height of each item.
   * @default 0
   */
  itemHeight: number | ((index: number) => number)
  /**
   * The height of the container.
   * @default '100%'
   */
  containerHeight?: string | number
  /**
   * The number of items to render above and below the visible area.
   * @default 5
   */
  overscan?: number
}

export interface UseVirtualListReturn<T> {
  list: ComputedRef<T[]>
  containerProps: {
    style: { height: string }
  }
  wrapperProps: {
    style: { width: string; transform: string }
  }
  scrollTo: (index: number) => void
}

/**
 * Create virtual lists with ease.
 *
 * @see https://vueuse.org/useVirtualList
 * @param list
 * @param options
 */
export declare function useVirtualList<T>(
  list: MaybeRefOrGetter<T[]>,
  options: UseVirtualListOptions,
): UseVirtualListReturn<T>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useVirtualList/index.ts) • [Demo](https://vueuse.org/core/useVirtualList/#demo) • [Docs](https://vueuse.org/core/useVirtualList/)

## Contributors

* Anthony Fu
* IlyaL
* SerKo
* Anthony Fu
* Doctorwu
* qiang
* Eureka

## Changelog

* **v14.0.0-alpha.0** on 9/1/2025: `feat(components)!: refactor components and make them consistent (#4912)`
* **v12.8.0** on 3/5/2025: `feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)`
* **v12.3.0** on 1/2/2025: `59f75` - feat(toValue): deprecate toValue from @vueuse/shared in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024: `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.7.1** on 12/27/2023: `ce420` - fix: fix tryOnMounted in vue2 (#3658)
* **v10.7.0** on 12/5/2023: `f2aeb` - feat(tryOnMounted): support target arguement (#3185)
