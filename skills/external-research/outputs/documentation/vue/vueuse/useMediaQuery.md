[Skip to content](https://vueuse.org/core/useMediaQuery/#VPContent)

On this page

# useMediaQuery [​](https://vueuse.org/core/useMediaQuery/\#usemediaquery)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

1.17 kB

Last Changed

7 months ago

Reactive [Media Query](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Testing_media_queries). Once you've created a MediaQueryList object, you can check the result of the query or receive notifications when the result changes.

## Demo [​](https://vueuse.org/core/useMediaQuery/\#demo)

```
isLargeScreen: true
prefersDark: false

```

## Usage [​](https://vueuse.org/core/useMediaQuery/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
('(min-width: 1024px)')
const
=
('(prefers-color-scheme: dark)')
```

#### Server Side Rendering and Nuxt [​](https://vueuse.org/core/useMediaQuery/\#server-side-rendering-and-nuxt)

If you are using [`useMediaQuery`](https://vueuse.org/core/useMediaQuery/) with SSR enabled, then you need to specify which screen size you would like to render on the server and before hydration to avoid an hydration mismatch

ts

```
import {
} from '@vueuse/core'

const
=
('(min-width: 1024px)', {

: 768 // Will enable SSR mode and render like if the screen was 768px wide
})


.
(
.
) // always false because ssrWidth of 768px is smaller than 1024px

(() => {

.
(
.
) // false if screen is smaller than 1024px, true if larger than 1024px
})
```

Alternatively you can set this up globally for your app using [`provideSSRWidth`](https://vueuse.org/core/useSSRWidth/)

## Type Declarations [​](https://vueuse.org/core/useMediaQuery/\#type-declarations)

ts

```
/**
 * Reactive Media Query.
 *
 * @see https://vueuse.org/useMediaQuery
 * @param query
 * @param options
 */
export declare function
(

:
<string>,

?:
& {

?: number
  },
):
<boolean>
```

## Source [​](https://vueuse.org/core/useMediaQuery/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMediaQuery/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useMediaQuery/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useMediaQuery/index.md)
