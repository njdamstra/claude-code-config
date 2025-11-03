[Skip to content](https://vueuse.org/shared/useInterval/#VPContent)

On this page

# useInterval [​](https://vueuse.org/shared/useInterval/\#useinterval)

Category

[Animation](https://vueuse.org/functions#category=Animation)

Export Size

461 B

Last Changed

6 months ago

Reactive counter increases on every interval

## Demo [​](https://vueuse.org/shared/useInterval/\#demo)

Interval fired: 2

## Usage [​](https://vueuse.org/shared/useInterval/\#usage)

ts

```
import {
} from '@vueuse/core'

// count will increase every 200ms
const
=
(200)
```

ts

```
const {
,
,
,
} =
(200, {

: true
})
```

## Type Declarations [​](https://vueuse.org/shared/useInterval/\#type-declarations)

ts

```
export interface
<
 extends boolean> {
  /**
   * Expose more controls
   *
   * @default false
   */

?:


  /**
   * Execute the update immediately on calling
   *
   * @default true
   */

?: boolean
  /**
   * Callback on every interval
   */

?: (
: number) => void
}
export interface UseIntervalControls {

:
<number>

: () => void
}
export type
=
  |
<
<number>>
  |
<UseIntervalControls &
>
/**
 * Reactive counter increases on every interval
 *
 * @see https://vueuse.org/useInterval
 * @param interval
 * @param options
 */
export declare function
(

?:
<number>,

?:
<false>,
):
<
<number>>
export declare function
(

:
<number>,

:
<true>,
):
<UseIntervalControls &
>
```

## Source [​](https://vueuse.org/shared/useInterval/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useInterval/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/useInterval/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useInterval/index.md)
