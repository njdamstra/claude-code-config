# useDevicePixelRatio

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 1.27 kB

Last Changed: 2 months ago

Reactively track [`window.devicePixelRatio`](https://developer.mozilla.org/docs/Web/API/Window/devicePixelRatio)

> NOTE: there is no event listener for `window.devicePixelRatio` change. So this function uses [`Testing media queries programmatically (window.matchMedia)`](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries) applying the same mechanism as described in [this example](https://developer.mozilla.org/en-US/docs/Web/API/Window/devicePixelRatio#monitoring_screen_resolution_or_zoom_level_changes).

## Demo

Device Pixel Ratio:

```
pixelRatio: 1
```

Zoom in and out (or move the window to a screen with a different scaling factor) to see the value changes

## Usage

```ts
import { useDevicePixelRatio } from '@vueuse/core'

const { pixelRatio } = useDevicePixelRatio()
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseDevicePixelRatio v-slot="{ pixelRatio }">
    Pixel Ratio: {{ pixelRatio }}
  </UseDevicePixelRatio>
</template>
```

## Type Declarations

```ts
/**
 * Reactively track `window.devicePixelRatio`.
 *
 * @see https://vueuse.org/useDevicePixelRatio
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useDevicePixelRatio(
  options?: ConfigurableWindow
): {
  pixelRatio: Ref<WritableComputedRef<number, number>>
  cleanup: WatchStopHandle
}

export type UseDevicePixelRatioReturn = ReturnType<typeof useDevicePixelRatio>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDevicePixelRatio/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDevicePixelRatio/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDevicePixelRatio/index.md)

## Contributors

- Anthony Fu
- Antério Vieira
- SerKo
- Waleed Khaled
- wheat
- IlyaL
- Yu Lia
- Robin
- Fernando Fernández
- David Hewson
- vaakian X
- Shinigami
- Alex Kozack
- Konstantin Barabanov

## Changelog

### v14.0.0-alpha.0 on 9/1/2025

`8c521` - feat(components)!: refactor components and make them consistent (#4912)

### v13.7.0 on 8/18/2025

`1b3d4` - feat: improve types (#4927)

### v13.6.0 on 7/28/2025

`d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

### v12.3.0 on 1/2/2025

`59f75` - feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

### v12.0.0-beta.1 on 11/21/2024

`0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
