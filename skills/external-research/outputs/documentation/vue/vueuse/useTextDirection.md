[Skip to content](https://vueuse.org/core/useTextDirection/#VPContent)

On this page

# useTextDirection [​](https://vueuse.org/core/useTextDirection/\#usetextdirection)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

796 B

Last Changed

2 months ago

Reactive [dir](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/dir) of the element's text.

## Demo [​](https://vueuse.org/core/useTextDirection/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextDirection/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNp9kkGP0zAQhf/KKBzSlWizQuylJLBolzOX5UQQMs40sXBsy3Yqqij/neekWXXLip48ncn35j17zD47tzsOnO2zMkivXKTAcXCkhWmrOouhzj7WRvXO+kgjDYGf+E98VJ5lVNbQRAdve8rvAUGzkNZzXpuLT6Tt3RC5eR7F5DwhrQmRGuWp+oe7GWtDWEWjtH5P+Zuf1yOP3Nv8bW2mmxUV0QZrFdxsbqjC8pQ0dkehB6aqqijX0WMBwu8T5U+dCuSEF60XriMUytAX02oVOhKmAc4nRX2i1nIgzQcoWfKq7eLuzMGC/+X8GiLKK9JMSKiE3OWwUZvDYJZcO0hr/moetJK/YWTO48LHtScfdZ7sJG9pnVQjm9qUxXKvCAJF5N5pEXmOpWzUkVSDa3413Pnmk7vSnQ9E47ikPIE8t4q1V3Z+PcFthIV7mXYH/YWXZyoGgxOGpBYhYKrX23doQiFZi/abc+wfRGC4nybYwPCqUCwSa/mC47bvyTohVTxt725BnGVTzhKLtEyx4ySxGL3glgXywKksLlJCGeJJMwVpHTf45/WX+B3Eak79B7nltqTV6el6bj7MN3GOZe71wrfKbOcnsKfb3R33yxD2SXLQyaa/+y885A==)

This paragraph is in English and correctly goes left to right.

* * *

LTRClick to change the direction

## Usage [​](https://vueuse.org/core/useTextDirection/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
() // Ref<'ltr' | 'rtl' | 'auto'>
```

By default, it returns `rtl` direction when dir `rtl` is applied to the `html` tag, for example:

html

```
<!--ltr-->
<html>
  ...
</html>

<!--rtl-->
<html dir="rtl">
  ...
</html>
```

## Options [​](https://vueuse.org/core/useTextDirection/\#options)

ts

```
import {
} from '@vueuse/core'

const
=
({

: 'body'
}) // Ref<'ltr' | 'rtl' | 'auto'>
```

## Type Declarations [​](https://vueuse.org/core/useTextDirection/\#type-declarations)

ts

```
export type
= "ltr" | "rtl" | "auto"
export interface UseTextDirectionOptions extends ConfigurableDocument {
  /**
   * CSS Selector for the target element applying to
   *
   * @default 'html'
   */

?: string
  /**
   * Observe `document.querySelector(selector)` changes using MutationObserve
   *
   * @default false
   */

?: boolean
  /**
   * Initial value
   *
   * @default 'ltr'
   */

?:


}
/**
 * Reactive dir of the element's text.
 *
 * @see https://vueuse.org/useTextDirection
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
(

?: UseTextDirectionOptions,
):
<
,

>
```

## Source [​](https://vueuse.org/core/useTextDirection/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextDirection/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextDirection/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextDirection/index.md)
