[Skip to content](https://vueuse.org/core/useBreakpoints/#VPContent)

On this page

# useBreakpoints [​](https://vueuse.org/core/useBreakpoints/\#usebreakpoints)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

1.74 kB

Last Changed

2 months ago

Reactive viewport breakpoints.

## Demo [​](https://vueuse.org/core/useBreakpoints/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useBreakpoints/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqVlE2PmzAQhv/KiEMh0jZIPaYEdbetemzVrtRD6YEFQ6z1B7VNQhTx3zsBEgPFSOUC2M/7eoaZ4eI9VtX2WBNv50U6U7QyoImpK2CpKPeJZ3TixYmgvJLKwAVeFElfK0mF0c8pZScq8geoNXmy69BCoSQH/wP64laYSUX8kYc+pIzJ03dS3FEkkUhEJoU240NgP3MPFiLYWKnmP2luDihb4LaaWxK3M0OP5IepiwJ5G1X0Ss6yAHOuCN4WfOLA19zHU3snqr8gY4h6PqTChjqNYVv2zFf1+U+dsiDYwD6eBrE9pqwmo2SyWinyj9GwGtzP7y1mVL9ooeb6KceA5pgvUdNUGj33GbBb2BNa8xn8QsyJENFRD+Dz3LI8d7FIIctKy7LSxSKFbMNGETMXixSy7ybwnP7V7f9ORBT23Y+9ji+G8IphtfANIMrpETKWao3zUEhh3nIpZDcWgNd1O4aPQ6lG3ju4XO4lbFuIwis5Fj32hbOaTjKUc1HR6OANM++RujV621bNZgfRk5SMpOIT1Rj5GXZdL2HADQ4whLHTav9fXsRhpvmKDKduWcXzFRXPHSpWrqhY6UqXrSXGllXYHGsql2wY9fvv4FtfW6eR4wcyM789ReGoPb32LzCVBJY=)

Current breakpoints: \[
"sm",
"md",
"lg",
"xl",
"2xl"
\]

Active breakpoint: 2xl

xs(<640px): false

xs(<=640px): false

sm: false

md: false

lg: false

xl: false

2xl: true

greaterThanBreakPoint: true

## Usage [​](https://vueuse.org/core/useBreakpoints/\#usage)

ts

```
import {
,
} from '@vueuse/core'

const
=
(
)

const
=
.
('sm') // sm and larger
const
=
.
('sm') // only larger than sm
const
=
.
('lg') // lg and smaller
const
=
.
('lg') // only smaller than lg
```

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'

const
=
({

: 0, // optional

: 640,

: 1024,

: 1280,
})

// Can be 'mobile' or 'tablet' or 'laptop' or 'desktop'
const
=
.
()

// true or false
const
=
.
('laptop', 'desktop')
</script>

<template>
  <

="
">
    ...
  </
>
</template>
```

#### Server Side Rendering and Nuxt [​](https://vueuse.org/core/useBreakpoints/\#server-side-rendering-and-nuxt)

If you are using [`useBreakpoints`](https://vueuse.org/core/useBreakpoints/) with SSR enabled, then you need to specify which screen size you would like to render on the server and before hydration to avoid an hydration mismatch

ts

```
import {
,
} from '@vueuse/core'

const
=
(
, {

: 768 // Will enable SSR mode and render like if the screen was 768px wide
})
```

Alternatively you can set this up globally for your app using [`provideSSRWidth`](https://vueuse.org/core/useSSRWidth/)

## Presets [​](https://vueuse.org/core/useBreakpoints/\#presets)

- Tailwind: `breakpointsTailwind`
- Bootstrap v5: `breakpointsBootstrapV5`
- Vuetify v2: `breakpointsVuetifyV2` (deprecated: `breakpointsVuetify`)
- Vuetify v3: `breakpointsVuetifyV3`
- Ant Design: `breakpointsAntDesign`
- Quasar v2: `breakpointsQuasar`
- Sematic: `breakpointsSematic`
- Master CSS: `breakpointsMasterCss`
- Prime Flex: `breakpointsPrimeFlex`
- ElementUI / ElementPlus: `breakpointsElement`

_Breakpoint presets are deliberately not auto-imported, as they do not start with `use` to have the scope of VueUse. They have to be explicitly imported:_

js

```
import { breakpointsTailwind } from '@vueuse/core'
// and so on
```

## Type Declarations [​](https://vueuse.org/core/useBreakpoints/\#type-declarations)

Show Type Declarations

ts

```
export * from "./breakpoints"
export type
<
extends string = string> =

<


,

<number | string>
>
export interface UseBreakpointsOptions extends ConfigurableWindow {
  /**
   * The query strategy to use for the generated shortcut methods like `.lg`
   *
   * 'min-width' - .lg will be true when the viewport is greater than or equal to the lg breakpoint (mobile-first)
   * 'max-width' - .lg will be true when the viewport is smaller than the xl breakpoint (desktop-first)
   *
   * @default "min-width"
   */

?: "min-width" | "max-width"

?: number
}
/**
 * Reactively viewport breakpoints
 *
 * @see https://vueuse.org/useBreakpoints
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
<
extends string>(

:
<
>,

?: UseBreakpointsOptions,
):

<
,
<boolean>> & {

: (
:
<
>) =>
<boolean>

: (
:
<
>) =>
<boolean>

(
:
<
>):
<boolean>

(
:
<
>):
<boolean>

(
:
<
>,
:
<
>):
<boolean>

(
:
<
>): boolean

(
:
<
>): boolean

(
:
<
>): boolean

(
:
<
>): boolean

(
:
<
>,
:
<
>): boolean

: () =>
<
[]>

():
<"" |
>
}
export type
<
extends string = string> =

<
  typeof
<
>
>
```

## Source [​](https://vueuse.org/core/useBreakpoints/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useBreakpoints/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useBreakpoints/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useBreakpoints/index.md)
