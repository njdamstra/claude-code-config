# usePointerLock

**Category**: Sensors
**Export Size**: 1.48 kB
**Last Changed**: 2 months ago

Reactive pointer lock.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointerLock/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Basic Usage

```ts
import { usePointerLock } from '@vueuse/core'

const { isSupported, lock, unlock, element, triggerElement } = usePointerLock()
```

## Component Usage

This function also provides a renderless component version via the @vueuse/components package. Learn more about the usage.

```vue
<template>
  <UsePointerLock v-slot="{ lock }">
    <canvas />
    <button @click="lock">
      Lock Pointer on Canvas
    </button>
  </UsePointerLock>
</template>
```

## Type Declarations

```ts
export interface UsePointerLockOptions extends ConfigurableDocument {}

/**
 * Reactive pointer lock.
 *
 * @see https://vueuse.org/usePointerLock
 * @param target
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function usePointerLock(
  target?: MaybeElementRef,
  options?: UsePointerLockOptions,
): {
  isSupported: ComputedRef<boolean>
  element: ShallowRef<MaybeElement, MaybeElement>
  triggerElement: ShallowRef<MaybeElement, MaybeElement>
  lock: (e: MaybeElementRef | Event) => Promise<HTMLElement | SVGElement>
  unlock: () => Promise<boolean>
}

export type UsePointerLockReturn = ReturnType<typeof usePointerLock>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointerLock/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointerLock/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointerLock/index.md)

## Contributors

* Anthony Fu
* IlyaL
* SerKo
* IlyaL
* Robin
* Fernando Fernández
* Robin
* Anthony Fu
* Sergey Danilchenko

## Changelog

* **v14.0.0-alpha.0** on 9/1/2025
  * `8c521` - feat(components)!: refactor components and make them consistent (#4912)
* **v13.6.0** on 7/28/2025
  * `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
* **v12.6.0** on 2/14/2025
  * `ce9e5` - fix(useMouse): check for MouseEvent instead of Touch to work with FF (#4457)
* **v12.4.0** on 1/10/2025
  * `dd316` - feat: use passive event handlers everywhere is possible (#4477)
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.8.0** on 2/20/2024
  * `a086e` - fix: stricter types
