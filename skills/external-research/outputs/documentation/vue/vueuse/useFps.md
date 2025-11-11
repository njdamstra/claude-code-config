# useFps

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 553 B

Last Changed: 2 months ago

Reactive FPS (frames per second).

## Demo

FPS: 40

## Usage

```ts
import { useFps } from '@vueuse/core'

const fps = useFps()
```

## Type Declarations

```ts
export interface UseFpsOptions {
  /**
   * Calculate the FPS on every x frames.
   * @default 10
   */
  every?: number
}

export declare function useFps(
  options?: UseFpsOptions
): Ref<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useFps/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useFps/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useFps/index.md)

## Contributors

- Anthony Fu
- SerKo
- IlyaL
- webfansplz
- jelf

## Changelog

### v13.6.0 on 7/28/2025

`d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

### v12.0.0-beta.1 on 11/21/2024

`0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
