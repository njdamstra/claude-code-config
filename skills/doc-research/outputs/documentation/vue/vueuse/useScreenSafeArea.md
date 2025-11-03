# useScreenSafeArea

**Category**: Browser
**Export Size**: 1.63 kB
**Last Changed**: 4 weeks ago

Reactive `env(safe-area-inset-*)`

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenSafeArea/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

top:
right:
bottom:
left:

## Usage

In order to make the page to be fully rendered in the screen, the additional attribute viewport-fit=cover within viewport meta tag must be set firstly, the viewport meta tag may look like this:

```html
<meta name="viewport" content="initial-scale=1, viewport-fit=cover" />
```

Then we could use useScreenSafeArea in the component as shown below:

```ts
import { useScreenSafeArea } from '@vueuse/core'

const { top, right, bottom, left, } = useScreenSafeArea()
```

For further details, you may refer to this documentation: [Designing Websites for iPhone X](https://webkit.org/blog/7929/designing-websites-for-iphone-x/)

## Component Usage

This function also provides a renderless component version via the @vueuse/components package. Learn more about the usage.

```vue
<template>
  <UseScreenSafeArea top right bottom left>
    content
  </UseScreenSafeArea>
</template>
```

## Type Declarations

```ts
/**
 * Reactive `env(safe-area-inset-*)`
 *
 * @see https://vueuse.org/useScreenSafeArea
 */
export declare function useScreenSafeArea(): {
  top: ShallowRef<string, string>
  right: ShallowRef<string, string>
  bottom: ShallowRef<string, string>
  left: ShallowRef<string, string>
  update: () => void
}

export type UseScreenSafeAreaReturn = ReturnType<typeof useScreenSafeArea>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenSafeArea/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenSafeArea/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenSafeArea/index.md)

## Contributors

* Anthony Fu
* Anthony Fu
* IlyaL
* Melkumyants Danila
* Fernando Fernández
* vaakian X
* Ayaka Rizumu
* Jelf

## Changelog

* **v14.0.0-alpha.0** on 9/1/2025
  * `8c521` - feat(components)!: refactor components and make them consistent (#4912)
* **v13.4.0** on 6/19/2025
  * `ae573` - fix: сhanged initial value update (#4789)
* **v12.4.0** on 1/10/2025
  * `dd316` - feat: use passive event handlers everywhere is possible (#4477)
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
