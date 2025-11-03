# useElementByPoint

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 859 B

Last Changed: 7 months ago

Reactive element by point.

## Demo

X

Y

## Usage

```ts
import { useMouse, useElementByPoint } from '@vueuse/core'

const { x, y } = useMouse({ type: 'client' })
const { element } = useElementByPoint({ x, y })
```

## Type Declarations

```ts
export interface UseElementByPointOptions<Multiple extends boolean = false>
  extends ConfigurableDocument {
  x: MaybeRefOrGetter<number>
  y: MaybeRefOrGetter<number>
  multiple?: MaybeRefOrGetter<Multiple>
  immediate?: boolean
  interval?: "requestAnimationFrame" | number
}

export interface UseElementByPointReturn<Multiple extends boolean = false>
  extends Pausable {
  isSupported: Ref<boolean>
  element: Ref<
    Multiple extends true ? HTMLElement[] : HTMLElement | null
  >
}

/**
 * Reactive element by point.
 *
 * @see https://vueuse.org/useElementByPoint
 * @param options - UseElementByPointOptions
 */
export declare function useElementByPoint<Multiple extends boolean = false>(
  options: UseElementByPointOptions<Multiple>,
): UseElementByPointReturn<Multiple>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementByPoint/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementByPoint/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementByPoint/index.md)

## Contributors

- Anthony Fu
- IlyaL
- Jelf
- wheat
- Fernando Fernández
- Alex Liu
- vaakian X
- BaboonKing

## Changelog

### v12.8.0 on 3/5/2025

`7432f` - feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native (#4636)

### v12.3.0 on 1/2/2025

`59f75` - feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

### v12.0.0-beta.1 on 11/21/2024

`0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v10.2.0 on 6/16/2023

`31b66` - feat: new `multiple` and `interval` options (#3089)
