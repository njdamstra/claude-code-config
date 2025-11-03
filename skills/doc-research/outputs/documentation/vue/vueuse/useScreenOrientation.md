# useScreenOrientation

**Category**: Browser
**Export Size**: 848 B
**Last Changed**: 2 months ago

Reactive Screen Orientation API. It provides web developers with information about the user's current screen orientation.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenOrientation/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXzfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

For best results, please use a mobile or tablet device (or use your browser's native inspector to simulate an orientation change)

`isSupported: false`
`Orientation Type:`
`Orientation Angle: 0`

## Usage

```ts
import { useScreenOrientation } from '@vueuse/core'

const {
  isSupported,
  orientation,
  angle,
  lockOrientation,
  unlockOrientation,
} = useScreenOrientation()
```

To lock the orientation, you can pass an `OrientationLockType` to the `lockOrientation` function:

```ts
import { useScreenOrientation } from '@vueuse/core'

const {
  isSupported,
  orientation,
  angle,
  lockOrientation,
  unlockOrientation,
  } = useScreenOrientation()

lockOrientation('portrait-primary')
```

and then unlock again, with the following:

```ts
unlockOrientation()
```

Accepted orientation types are one of "landscape-primary", "landscape-secondary", "portrait-primary", "portrait-secondary", "any", "natural", "landscape" and "portrait".

[Screen Orientation API MDN](https://developer.mozilla.org/en-US/docs/Web/API/Screen_Orientation_API)

## Type Declarations

```ts
export type OrientationType = 
  | "portrait-primary"
  | "portrait-secondary"
  | "landscape-primary"
  | "landscape-secondary"
export type OrientationLockType =
  | "any"
  | "natural"
  | "landscape"
  | "portrait"
  | "portrait-primary"
  | "portrait-secondary"
  | "landscape-primary"
  | "landscape-secondary"

export interface ScreenOrientation extends EventTarget {
  lock: (orientation: OrientationLockType) => Promise<void>
  unlock: () => void
  readonly type: OrientationType
  readonly angle: number
  addEventListener: (
    type: "change",
    listener: (this: this, ev: Event) => any,
    useCapture?: boolean,
  ) => void
}

/**
 * Reactive screen orientation
 *
 * @see https://vueuse.org/useScreenOrientation
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useScreenOrientation(
  options?: ConfigurableWindow,
): {
  isSupported: ComputedRef<boolean>
  orientation: Ref<OrientationType | undefined, OrientationType | undefined>
  angle: ShallowRef<number, number>
  lockOrientation: (type: OrientationLockType) => Promise<void>
  unlockOrientation: () => void
}

export type UseScreenOrientationReturn = ReturnType<typeof useScreenOrientation>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenOrientation/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenOrientation/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useScreenOrientation/index.md)
