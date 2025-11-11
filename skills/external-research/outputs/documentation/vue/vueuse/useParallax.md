[Skip to content](https://vueuse.org/core/useParallax/#VPContent)

On this page

# useParallax [​](https://vueuse.org/core/useParallax/\#useparallax)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

2.41 kB

Last Changed

11 months ago

Create parallax effect easily. It uses [`useDeviceOrientation`](https://vueuse.org/core/useDeviceOrientation/) and fallback to [`useMouse`](https://vueuse.org/core/useMouse/) if orientation is not supported.

## Demo [​](https://vueuse.org/core/useParallax/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useParallax/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNq1Vwtv2zYQ/isHd4XlwZHl1wYYdrYuG1AMDdA2xbYCBlJaOtlMJFIgKcee4f++o2hJtvNYUsQIEJP3/O6Od6Q2jXdZ5i9zbIwaYx0qnhnQaPIMEibmk2nD6GnjfCp4mkllwKwzhA1cXF19VDJDZThq2EKsZApNstKsJDegkIWGx+s25BovMeLsU47KbT8yxZKErSrdX0mZ6J1QqgMjoUyz3GDU3plbYqH/BdMsYQY/Y/yw+6/vLj/s6GuWJsSYilAKTdEZxcWccMGkguhNBYDHBbkaARPrFkzOCxN+Je24bfBu27As+BurBMBj8GxaZAxLmEwm0IxzQValaLZKGSBPJlcCchFhzAVGjr51Pzvm0u627VJJk+MEP+XS4AiMyrHt6HEi7y5kkmDh5COLIhIcQcwS7US2Lfpp1REbpuZoKNzDxI3ff7n88EeCKQpz7jWdVJP0nBbXl3LGE3R6df28ppey1dkdj8xiBD8HQbZqWa1SLytLW6Z3id5exT3np3UP35VZJxTo4dGauGREXBPq9Yhym+CqWURpV79z5bJAnFAmeSoc7ybXtqwXUhgKzjLpB5Vjply8Rz5fWPrQwndko5jQfGfM72tApvFM5gYItxWhYjm8IVPR31xE8u4pzHKJypaKrC14FOEOWkyYrvi/pNX8SWHqiJmsPLOZpkAM7kDJzKJnSegNg7dwBl1MW46VYFxE9hBvUcbXKz3sylUTUko6LxzmRh6ER4lG9RsF/0hgj4KtvHaD4O2h25rygjRTphj1inoqy1UYfUyhDIUwotKZPRpLm+h+WWWyXR1vEcvCMFkqh4znFY3tufplLOSGzlzgD/Zq0asOzK4Ag4pQJ6bsHX/JkhzhF2hysUDFTROOsrYFzQzXsQ3pIMD9BikqEjwG1Pf9qmR1imOp0hF8K9a24f/xftiUrekbnhj4EbrBlprXyVuZryTjZkwlqWjQFJLFYLHSmk4cel2/3299swHcA9p9faC9ZwPtvQBo7/WB9p8NtP8CoP3XBzp4NtDBC4AOCGgFqObZgflkr81YeDtXkm5Hao83cRwfj7GgGpXVRBlWpJlUEarPLOK5tjO97EdHt7LZCqjleARvwsj+Of4jE/p/J5S1vLpaMLoASCKAgE4deQhAzWfM6w2Hbaj/BX5vuJvK+8VR0hxXpjrB2wjnLXASD9Sl6omiLla2Ksa4455w9GCjjdnd9bQDGEd8WSzcku7m2L7uiqt32oCRtvWpKEW1ioefe76MM4W1TDU7SWKzqV9UXomxBdvtuEM6tQHrszJwONr3/NwTLE/OgcxDUnsX8pEsSfN0fkiBWtkN12njWECrkLgLYzI96nRuGL0ll3KOiU8nuMNTNkfdiVDzuejc5GlGGbhWbDbjppMRr+fM+pmY3zfNEkOmj+kvBt09DejuSUH3TgO6d1LQ/dOA7p8U9OA0oAffDXrcqWfQ/f3RzjZ4mDCtyaqgT6DyPXZGp37PxoWiDxMD9PHl4NMrbc8B23e/cCOvjD6UEWYofC73EnGI381C0rm+ntHn8O0+9/xPqwR/Wa1xhz0YRr0uV+PO3lBubP8D82Xopg==)

```
roll: 0.5
tilt: -0.5
source: mouse

```

![](https://jaromvogel.com/images/design/jumping_rabbit/page2layer0.png)![](https://jaromvogel.com/images/design/jumping_rabbit/page2layer1.png)![](https://jaromvogel.com/images/design/jumping_rabbit/page2layer2.png)![](https://jaromvogel.com/images/design/jumping_rabbit/page2layer3.png)![](https://jaromvogel.com/images/design/jumping_rabbit/page2layer4.png)

Credit of images to [Jarom Vogel](https://codepen.io/jaromvogel)

## Usage [​](https://vueuse.org/core/useParallax/\#usage)

vue

```
<script setup lang="ts">
import {
 } from '@vueuse/core'

const
 =
(null)
const {
,
,
 } =
(
)
</script>

<template>
  <

="
 " />
</template>
```

## Type Declarations [​](https://vueuse.org/core/useParallax/\#type-declarations)

ts

```
export interface UseParallaxOptions extends ConfigurableWindow {

?: (
: number) => number

?: (
: number) => number

?: (
: number) => number

?: (
: number) => number
}
export interface UseParallaxReturn {
  /**
   * Roll value. Scaled to `-0.5 ~ 0.5`
   */

:
<number>
  /**
   * Tilt value. Scaled to `-0.5 ~ 0.5`
   */

:
<number>
  /**
   * Sensor source, can be `mouse` or `deviceOrientation`
   */

:
<"deviceOrientation" | "mouse">
}
/**
 * Create parallax effect easily. It uses `useDeviceOrientation` and fallback to `useMouse`
 * if orientation is not supported.
 *
 * @param target
 * @param options
 */
export declare function
(

:
,

?: UseParallaxOptions,
): UseParallaxReturn
```

## Source [​](https://vueuse.org/core/useParallax/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useParallax/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useParallax/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useParallax/index.md)

## Contributors [​](https://vueuse.org/core/useParallax/\#contributors)

![](https://gravatar.com/avatar/616389b9fc3c3c92d244e2639418f0c5?d=retro) Anthony Fu

![](https://gravatar.com/avatar/77b8ac226fff6d2ac09e16d547cd9ac5?d=retro) Antério Vieira

![](https://gravatar.com/avatar/10af285c4d864f57c5baefa1bcc05ed2?d=retro) Anthony Fu

![](https://gravatar.com/avatar/b1f73ba4300d063a1ccc27a8e3068d57?d=retro) SerKo

![](https://gravatar.com/avatar/7a1806b5ad96f54dbdb5e593cef7cb51?d=retro) Robin

![](https://gravatar.com/avatar/bbbb81d8447ca40b810c9121337b25b3?d=retro) James Garbutt

![](https://gravatar.com/avatar/1a35762c4e5869c2ab4feaf3354660a7?d=retro) IlyaL

![](https://gravatar.com/avatar/43ccdfefe51e610d6dca3eeca53eb14b?d=retro) Robin

![](https://gravatar.com/avatar/f9e55a44aff5199a22ec52fb565469c8?d=retro) huiliangShen

![](https://gravatar.com/avatar/07fd9d00b8f655b55082521e625b3cbb?d=retro) Jelf

![](https://gravatar.com/avatar/d2eccc131bb7a5815d1ef3695ad30b04?d=retro) wheat

## Changelog [​](https://vueuse.org/core/useParallax/\#changelog)

[`v12.0.0-beta.1`](https://github.com/vueuse/vueuse/releases/tag/v12.0.0-beta.1) on 11/21/2024

[`0a9ed`](https://github.com/vueuse/vueuse/commit/0a9ed589ab0e3a4aa8c7b7a4292757947378c14c) \- feat!: drop Vue 2 support, optimize bundles and clean up ( [#4349](https://github.com/vueuse/vueuse/issues/4349))

[`v10.8.0`](https://github.com/vueuse/vueuse/releases/tag/v10.8.0) on 2/20/2024

[`3fd94`](https://github.com/vueuse/vueuse/commit/3fd94343472ffd4f25d0ff6628ad6b436b07f365) \- feat: can work with different screen orientation ( [#3675](https://github.com/vueuse/vueuse/issues/3675))
