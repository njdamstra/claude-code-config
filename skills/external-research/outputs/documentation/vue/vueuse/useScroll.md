[Skip to content](https://vueuse.org/core/useScroll/#VPContent)

On this page

# useScroll [​](https://vueuse.org/core/useScroll/\#usescroll)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

2.22 kB

Last Changed

3 months ago

Reactive scroll position and state.

## Demo [​](https://vueuse.org/core/useScroll/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScroll/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNq9V21vGzcM/iucv9gBTnGcttsQOF5bdME+NMPQZECDuhjkM21r0Z0ESecXZPnvo0735kvzZqf94jvpyIcPKZKibzrvtD5cZtg56QxtbIR2YNFlGiRP56fjjrPjzmicikQr4+AGMosXsVFSwi3MjEqg+5a0abcfK4PdhmSsEp05nEaQ4tpdivg6ArvgUqrVJ5xF4BQ9bOQRLzHRkjukjQqWUAltnMYqtQ5QwmlLcvjH5fnH3yUmmLpRr4uye1BK20QptyCN2l5vxqXFSmKCC74UypBMybPXO4DTUaF7uOQyQ/gNumHdhRPo8syp2sgNrCPYRCBsCIhI5xFwY8QSpxeOOEYwFQZjJ0g8ggS5zQySf7kjQaeHMiKgis1tA13izEVgxHxBD6d0BBPlHIXGI4Tg9ZrmWqonJPOxhvDLTxWWX13WkH75/g54zZ6gx2m/D2fKJNyBWyCkWTJBY2ElKNBOnYk1RfCA3iDh1+hFklwlFTEavz0Vlk5uU5Islp+bB3AzTgHm6AgnfwUwlIomhXU4jsPSzoAIAdxG/peytUdfK5VClnD/zCkeam4snknFg1ypWYe6oHL1JCqbZ1ApZJ9EpSSzQH9IW6k77C7YlzdHR3r9tQv/gV8dhxWlff2JQGZZmh8YZHpKGRFy7C9lhd8sXQkWKmrby9PTHL+0RvlfW/MlUH/zUGVhF6VTuF1kei/4R7+343TYD82FWgktXFHFtAIYTsUSYsmtpXYzk7jOG44Hyr8YnNE+ynGnElqxV54DLIpnwnxlglqimVHIGJnyDWoyZ3PDN4wI99+AUVk6xWkF3jK88mKEZZCIUU2RuZPyWwhRQ7PQ1UVkSYRPrJKUOXnpsSNfY+yIMCa+h9YsaEfTxpodw4YNthABqCB9wTaM9MnKM4yGYn623VD5O5rOm8vuDuctaQ+ze7m8q/E83IP+q9xpej7TeHF/nuN9ppurrfdmwhZJv2LHv/q81ZK9vi+39Zr9DHrDXpdFAHMjwg+LlbTsy+CYMP7xgF9hzjXR3iqe7dS3mqfgqPQJOj8H8lZpHgu3oZ1fvPOVZTJKyp+hbELUB0i7HeRS3IMybUTCzaYVNC+3tUFbIqVmDUuWqClKUi/vFCLgNhppJ9xStE6EP0GfJglf0xu1NHq3Dv0xDfx73QhmGZ3OT6TBVj6xtmm0c6S9fn5wrn5ocK6eEJzB9wpO0x1KPObdDYi+74Oge8GymOY5Ghn+zawTsw2boFshpi1T5+GO2bI+yaioU3gbS7qSyMK3LsEWjO9B87nE4hbcdibgPeSP5BMaTGfKkLUwJxZ3D82CTOlgsA7eghwkl2NkqVoZrv1RPJQpo4swx1aYw35usZ1vo+KwxfRBHnUuBJk6E+IFxtcT5W/euzn4eEaPGiPwXf33Sknk6YeQf3CSTxqk2VAixH47Tx622LpG4F0YhB84q/toUA/fz3x+i+xBoDSxB4Vidt+dQ7hG9yPhB4g9KPhLdT8CVTrB33qnRKBEeikGj40W95MImi9E44Na0by9A4uQUS9F45HZ8n4auWKTxLdHo/Jt2G/8s+jc/g9T8j0E)

TopLeft

BottomLeft

TopRight

BottomRight

Scroll Me

X Position

Y Position

Measure  Toggle height

Smooth scrollingisScrollingfalse

Top Arrived

true

Right Arrived

true

Bottom Arrived

true

Left Arrived

true

Scrolling Up

false

Scrolling Right

false

Scrolling Down

false

Scrolling Left

false

## Usage [​](https://vueuse.org/core/useScroll/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
<HTMLElement>('el')
const {
,
,
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

### With offsets [​](https://vueuse.org/core/useScroll/\#with-offsets)

ts

```
const {
,
,
,
,
} =
(el, {

: {
: 30,
: 30,
: 30,
: 30 },
})
```

### Setting scroll position [​](https://vueuse.org/core/useScroll/\#setting-scroll-position)

Set the `x` and `y` values to make the element scroll to that position.

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
<HTMLElement>('el')
const {
,
} =
(
)
</script>

<template>
  <

="
" />
  <
 @
="
+= 10">
    Scroll right 10px
  </
>
  <
 @
="
+= 10">
    Scroll down 10px
  </
>
</template>
```

### Smooth scrolling [​](https://vueuse.org/core/useScroll/\#smooth-scrolling)

Set `behavior: smooth` to enable smooth scrolling. The `behavior` option defaults to `auto`, which means no smooth scrolling. See the `behavior` option on [`window.scrollTo()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollTo) for more information.

TypeScript

ts

```
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
<HTMLElement>('el')
const {
,
} =
(
, {
: 'smooth' })

// Or as a `ref`:
const
=
(false)
const
=
(() =>
.
? 'smooth' : 'auto')
const {
,
} =
(
, {
})
```

js

```
import { useScroll } from '@vueuse/core'
import { useTemplateRef } from 'vue'
const el = useTemplateRef('el')
const { x, y } = useScroll(el, { behavior: 'smooth' })
// Or as a `ref`:
const smooth = ref(false)
const behavior = computed(() => (smooth.value ? 'smooth' : 'auto'))
const { x, y } = useScroll(el, { behavior })
```

### Recalculate scroll state [​](https://vueuse.org/core/useScroll/\#recalculate-scroll-state)

You can call the `measure()` method to manually update the scroll position and `arrivedState` at any time.

This is useful, for example, after dynamic content changes or when you want to recalculate the scroll state outside of scroll events.

TypeScript

ts

```
import {
} from '@vueuse/core'
import {
,
,
,
} from 'vue'

const
=
<HTMLElement>('el')
const
=
(false)

const {
} =
(
)

// In a watcher

(
, () => {

()
})

// Or inside any function
function
() {
  // ...some logic

(() => {

()
  })
}
```

js

```
import { useScroll } from '@vueuse/core'
import { nextTick, useTemplateRef, watch } from 'vue'
const el = useTemplateRef('el')
const reactiveValue = shallowRef(false)
const { measure } = useScroll(el)
// In a watcher
watch(reactiveValue, () => {
  measure()
})
// Or inside any function
function updateScrollState() {
  // ...some logic
  nextTick(() => {
    measure()
  })
}
```

NOTE

it's recommended to call `measure()` inside `nextTick()`, to ensure the DOM is updated first. The scroll state is initialized automatically `onMount`. You only need to call `measure()` manually if you want to recalculate the state after some dynamic changes.

## Directive Usage [​](https://vueuse.org/core/useScroll/\#directive-usage)

> This function also provides a directive version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<script setup lang="ts">
import type {
} from '@vueuse/core'
import {
} from '@vueuse/components'

const
=
([1, 2, 3, 4, 5, 6])

function
(
:
) {

.
(
) // {x, y, isScrolling, arrivedState, directions}
}
</script>

<template>
  <

l="
">
    <
 v-for="
 in
"
="
">
      {{
}}
    </
>
  </
>

  <!-- with options -->
  <

l="


">
    <
 v-for="
 in
"
="
">
      {{
}}
    </
>
  </
>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useScroll/\#type-declarations)

Show Type Declarations

ts

```
export interface UseScrollOptions extends ConfigurableWindow {
  /**
   * Throttle time for scroll event, it's disabled by default.
   *
   * @default 0
   */

?: number
  /**
   * The check time when scrolling ends.
   * This configuration will be setting to (throttle + idle) when the `throttle` is configured.
   *
   * @default 200
   */

?: number
  /**
   * Offset arrived states by x pixels
   *
   */

?: {

?: number

?: number

?: number

?: number
  }
  /**
   * Use MutationObserver to monitor specific DOM changes,
   * such as attribute modifications, child node additions or removals, or subtree changes.
   * @default { mutation: boolean }
   */

?:
    | boolean
    | {

?: boolean
      }
  /**
   * Trigger it when scrolling.
   *
   */

?: (
: Event) => void
  /**
   * Trigger it when scrolling ends.
   *
   */

?: (
: Event) => void
  /**
   * Listener options for scroll event.
   *
   * @default {capture: false, passive: true}
   */

?: boolean | AddEventListenerOptions
  /**
   * Optionally specify a scroll behavior of `auto` (default, not smooth scrolling) or
   * `smooth` (for smooth scrolling) which takes effect when changing the `x` or `y` refs.
   *
   * @default 'auto'
   */

?:
<
>
  /**
   * On error callback
   *
   * Default log error to `console.error`
   */

?: (
: unknown) => void
}
/**
 * Reactive scroll.
 *
 * @see https://vueuse.org/useScroll
 * @param element
 * @param options
 */
export declare function
(

:
<
    HTMLElement | SVGElement | Window | Document | null | undefined
  >,

?: UseScrollOptions,
): {

:
<number, number>

:
<number, number>

:
<boolean, boolean>

: {

: boolean

: boolean

: boolean

: boolean
  }

: {

: boolean

: boolean

: boolean

: boolean
  }

(): void
}
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useScroll/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScroll/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useScroll/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useScroll/index.md)
