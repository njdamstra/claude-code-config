# useOffsetPagination

**Category**: Utilities
**Export Size**: 1.02 kB
**Last Changed**: 7 months ago

Reactive offset pagination.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useOffsetPagination/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

total: 80
pageCount: 8
currentPageSize: 10
currentPage: 1
isFirstPage: true
isLastPage: false
prev 1 2 3 4 5 6 7 8 next
id name

## Usage

```ts
import { useOffsetPagination } from '@vueuse/core'

function fetchData({ currentPage, currentPageSize }: { currentPage: number, currentPageSize: number }) {
  fetch(currentPage, currentPageSize).then((responseData) => { data.value = responseData })
}

const {
  currentPage,
  currentPageSize,
  pageCount,
  isFirstPage,
  isLastPage,
  prev,
  next,
} = useOffsetPagination({
  total: database.value.length,
  page: 1,
  pageSize: 10,
  onPageChange: fetchData,
  onPageSizeChange: fetchData,
})
```

## Component Usage

This function also provides a renderless component version via the @vueuse/components package. Learn more about the usage.

```vue
<template>
  <UseOffsetPagination v-slot="{ currentPage, currentPageSize, next, prev, pageCount, isFirstPage, isLastPage, }" :total="database.length" @page-change="fetchData" @page-size-change="fetchData">
    <div class="gap-x-4 gap-y-2 grid-cols-2 inline-grid items-center">
      <div opacity="50"> total: </div>
      <div>{{ database.length }}</div>
      <div opacity="50"> pageCount: </div>
      <div>{{ pageCount }}</div>
      <div opacity="50"> currentPageSize: </div>
      <div>{{ currentPageSize }}</div>
      <div opacity="50"> currentPage: </div>
      <div>{{ currentPage }}</div>
      <div opacity="50"> isFirstPage: </div>
      <div>{{ isFirstPage }}</div>
      <div opacity="50"> isLastPage: </div>
      <div>{{ isLastPage }}</div>
    </div>
    <div>
      <button :disabled="isFirstPage" @click="prev"> prev </button>
      <button :disabled="isLastPage" @click="next"> next </button>
    </div>
  </UseOffsetPagination>
</template>
```

Component event supported props event callback and event listener.

event listener:

```vue
<template>
  <UseOffsetPagination v-slot="{ currentPage, currentPageSize, next, prev, pageCount, isFirstPage, isLastPage, }" :total="database.length" @page-change="fetchData" @page-size-change="fetchData" @page-count-change="onPageCountChange">
    <!-- your code -->
  </UseOffsetPagination>
</template>
```

or props event callback:

```vue
<template>
  <UseOffsetPagination v-slot="{ currentPage, currentPageSize, next, prev, pageCount, isFirstPage, isLastPage, }" :total="database.length" :on-page-change="fetchData" :on-page-size-change="fetchData" :on-page-count-change="onPageCountChange">
    <!-- your code -->
  </UseOffsetPagination>
</template>
```

## Type Declarations

```ts
export interface UseOffsetPaginationOptions {
  /**
   * Total number of items.
   */
  total?: MaybeRefOrGetter<number>
  /**
   * The number of items to display per page.
   * @default 10
   */
  pageSize?: MaybeRefOrGetter<number>
  /**
   * The current page number.
   * @default 1
   */
  page?: MaybeRef<number>
  /**
   * Callback when the `page` change.
   */
  onPageChange?: (returnValue: UnwrapNestedRefs<UseOffsetPaginationReturn>, ) => unknown
  /**
   * Callback when the `pageSize` change.
   */
  onPageSizeChange?: (returnValue: UnwrapNestedRefs<UseOffsetPaginationReturn>, ) => unknown
  /**
   * Callback when the `pageCount` change.
   */
  onPageCountChange?: (returnValue: UnwrapNestedRefs<UseOffsetPaginationReturn>, ) => unknown
}

export interface UseOffsetPaginationReturn {
  currentPage: Ref<number>
  currentPageSize: Ref<number>
  pageCount: ComputedRef<number>
  isFirstPage: ComputedRef<boolean>
  isLastPage: ComputedRef<boolean>
  prev: () => void
  next: () => void
}

export type UseOffsetPaginationInfinityPageReturn = Omit<UseOffsetPaginationReturn, "isLastPage">

export declare function useOffsetPagination(
  options: Omit<UseOffsetPaginationOptions, "total">,
): UseOffsetPaginationInfinityPageReturn

export declare function useOffsetPagination(
  options: UseOffsetPaginationOptions,
): UseOffsetPaginationReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useOffsetPagination/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useOffsetPagination/demo.vue) • [Docs](https://vueuse.org/core/useOffsetPagination/index.md)

## Contributors

* Anthony Fu
* Anthony Fu
* IlyaL
* IlyaL
* Doctorwu
* LJX
* vaakian X
* JD Solanki
* Curt Grimes
* webfansplz
* 三咲智子
* Jelf

## Changelog

* **v14.0.0-alpha.0** on 9/1/2025
  * `8c521` - feat(components)!: refactor components and make them consistent (#4912)
* **v12.8.0** on 3/5/2025
  * `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.3.0** on 1/2/2025
  * `59f75` - feat(toValue): deprecate toValue from @vueuse/shared in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.7.0** on 12/4/2023
  * `4dace` - fix: don't mutate props when it's readonly (#3581)
