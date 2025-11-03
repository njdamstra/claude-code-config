[Skip to content](https://vueuse.org/core/usePageLeave/#VPContent)

On this page

# usePageLeave [​](https://vueuse.org/core/usePageLeave/\#usepageleave)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

707 B

Last Changed

last month

Reactive state to show whether the mouse leaves the page.

## Demo [​](https://vueuse.org/core/usePageLeave/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePageLeave/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNpVjbEOwjAMRH/FygIsZEcpgr0DH5AlqtyqqHWs2O0S5d+xBEgwnu7uveruzOd9Q3dxQYYys4KgbgxLoqmLTiW6a6R55VwUKmyCjzRhj2lHaDCWvMLhZgAr/JALHiJFGjKJwiw9jgrd3+l4ihT8W2VgC4orL0nREkDggl/3UzKZvVbzflgNWgveNjYO/ufp2gu6LEgY)

```
{
  "isLeft": false
}
```

## Usage [​](https://vueuse.org/core/usePageLeave/\#usage)

ts

```
import {
 } from '@vueuse/core'

const
 =
()
```

## Component Usage [​](https://vueuse.org/core/usePageLeave/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UsePageLeave v-slot="{
 }">
    Has Left Page: {{
 }}
  </UsePageLeave>
</template>
```

## Type Declarations [​](https://vueuse.org/core/usePageLeave/\#type-declarations)

ts

```
/**
 * Reactive state to show whether mouse leaves the page.
 *
 * @see https://vueuse.org/usePageLeave
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
(

?:
,
):
<boolean, boolean>
export type
 =
<typeof
>
```

## Source [​](https://vueuse.org/core/usePageLeave/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePageLeave/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/usePageLeave/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/usePageLeave/index.md)

## Contributors [​](https://vueuse.org/core/usePageLeave/\#contributors)

![](https://gravatar.com/avatar/616389b9fc3c3c92d244e2639418f0c5?d=retro) Anthony Fu

![](https://gravatar.com/avatar/b1f73ba4300d063a1ccc27a8e3068d57?d=retro) SerKo

![](https://gravatar.com/avatar/46f3527083016d732d6846ca84a8fb94?d=retro) IlyaL

![](https://gravatar.com/avatar/fcf2fd60dd85e0c9c7c2c1e07b0e44b2?d=retro) Fernando Fernández

![](https://gravatar.com/avatar/10af285c4d864f57c5baefa1bcc05ed2?d=retro) Anthony Fu

![](https://gravatar.com/avatar/8bf1ff4343c98b9e31761fb7394f1794?d=retro) vaakian X

![](https://gravatar.com/avatar/7b99d2c6265ccbf8c94f9e999c635ead?d=retro) lxhyl

![](https://gravatar.com/avatar/d2eccc131bb7a5815d1ef3695ad30b04?d=retro) wheat

![](https://gravatar.com/avatar/11e362516e144541907475ff1dbcea6b?d=retro) Alex Kozack

![](https://gravatar.com/avatar/77b8ac226fff6d2ac09e16d547cd9ac5?d=retro) Antério Vieira

## Changelog [​](https://vueuse.org/core/usePageLeave/\#changelog)

[`v14.0.0-alpha.0`](https://github.com/vueuse/vueuse/releases/tag/v14.0.0-alpha.0) on 9/1/2025

[`8c521`](https://github.com/vueuse/vueuse/commit/8c521d4e4cebc78f59db70cd137098b7095ed605) \- feat(components)!: refactor components and make them consistent ( [#4912](https://github.com/vueuse/vueuse/issues/4912))

[`v13.6.0`](https://github.com/vueuse/vueuse/releases/tag/v13.6.0) on 7/28/2025

[`d32f8`](https://github.com/vueuse/vueuse/commit/d32f80ca4e0f7600b68cbca05341b351e31563c1) \- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions ( [#4907](https://github.com/vueuse/vueuse/issues/4907))

[`v12.4.0`](https://github.com/vueuse/vueuse/releases/tag/v12.4.0) on 1/10/2025

[`dd316`](https://github.com/vueuse/vueuse/commit/dd316da80925cf6b7d9273419fa86dac50ac23aa) \- feat: use passive event handlers everywhere is possible ( [#4477](https://github.com/vueuse/vueuse/issues/4477))

[`v12.0.0-beta.1`](https://github.com/vueuse/vueuse/releases/tag/v12.0.0-beta.1) on 11/21/2024

[`0a9ed`](https://github.com/vueuse/vueuse/commit/0a9ed589ab0e3a4aa8c7b7a4292757947378c14c) \- feat!: drop Vue 2 support, optimize bundles and clean up ( [#4349](https://github.com/vueuse/vueuse/issues/4349))
