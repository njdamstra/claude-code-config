# useScrollLock

**Category**: Sensors
**Export Size**: 1.2 kB
**Last Changed**: 7 months ago

Lock scrolling of the element.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScrollLock/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

```vue
<script setup lang="ts">
import { useScrollLock } from '@vueuse/core'
import { useTemplateRef } from 'vue'

const el = useTemplateRef<HTMLElement>('el')
const isLocked = useScrollLock(el)

isLocked.value = true // lock
isLocked.value = false // unlock
</script>

<template>
  <div ref="el" />
</template>
```

## Directive Usage

This function also provides a directive version via the `@vueuse/components` package. Learn more about the usage.

```vue
<script setup lang="ts">
import { vScrollLock } from '@vueuse/components'
const data = ref([1, 2, 3, 4, 5, 6])
const isLocked = ref(false)
const toggleLock = useToggle(isLocked)
</script>

<template>
  <div v-scroll-lock="isLocked">
    <div v-for="item in data" :key="item">
      {{ item }}
    </div>
  </div>
  <button @click="toggleLock()">Toggle lock state</button>
</template>
```

## Type Declarations

```ts
/**
 * Lock scrolling of the element.
 *
 * @see https://vueuse.org/useScrollLock
 * @param element
 */
export declare function useScrollLock(
  element: MaybeRefOrGetter<HTMLElement | SVGElement | Window | Document | null | undefined>,
  initialState?: boolean,
): WritableComputedRef<boolean, boolean>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScrollLock/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useScrollLock/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useScrollLock/index.md)

## Contributors

* Anthony Fu
* webfansplz
* IlyaL
* Ayaka Rizumu
* Robin
* Coder Poet
* YASS
* Doctorwu
* Zhaolin Liang
* Valery
* Dominik Pschenitschni
* Robin Scholz
* Jelf
* wheat

## Changelog

* **v14.0.0-alpha.0** on 9/1/2025: `feat(components)!: refactor components and make them consistent (#4912)`
* **v12.8.0** on 3/5/2025: `feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)`
* **v12.3.0** on 1/2/2025: `feat(toValue): deprecate toValue from `@vueuse/shared` in favor of Vue's native`
* **v12.0.0-beta.1** on 11/21/2024: `feat!: drop Vue 2 support, optimize bundles and clean up (#4349)`
* **v10.10.0** on 5/27/2024: `fix: function unlock does not work (#3847)`
* **v10.9.0** on 2/27/2024: `fix: initialOverflow is not working (#3798)`
* **v10.6.0** on 11/9/2023: `fix(onScrollLock): cache the el initial overflow value (#3527)`
* **v10.4.0** on 8/25/2023: `fix: support using window or document (#3319)`
* **v10.2.0** on 6/16/2023: `fix: fix scrollable children check (#3065)`
