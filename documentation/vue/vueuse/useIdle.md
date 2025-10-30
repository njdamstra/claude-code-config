[Skip to content](https://vueuse.org/core/useIdle/#VPContent)

On this page

# useIdle [​](https://vueuse.org/core/useIdle/\#useidle)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

1.18 kB

Last Changed

3 months ago

Tracks whether the user is being inactive.

## Demo [​](https://vueuse.org/core/useIdle/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useIdle/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNptks1OwzAQhF9llQupRJsUqZcoDRQhpB64cczFTbbUUvwje1Ooqrw7a1spPZBTbI+/GY99zXbWrs4jZlVW+85JS+CRRguD0F/bNiPfZk2rpbLGEVxh9LjvB3wMP59SoSehLExwdEbBwwuTeKHojMOHu12dUXYk7G9C1vF6qzujfRDIyByEp11H8ows3M5e+aYsy8WfWpvvtHjzzxmgCd1ZDBWsWQ3TnT6w+3fjeNOcI88XsG3g2mrguSASyXYLH4JOq+NgjMtzdloxc0RY3mVLUwsoolU0AnBcmtMzpoESnudBBWWrQ6C6SA1znzwgVHYQhDwCqLUhhI5NPJeuDsunWDvwF5L3qEJKJ0gaDXZ01njui04YTwfETZiRj+rD7QEZqA/NxtfFoeFmWCd9ggUQ5D0exTgQrJXUi1X0L0KAFKWX5/+ThMuooH41ZkCh36Tn/BeoYh2sDUnaDIpEKRhz4zV7ncrg7YcbnPCHltZJJdyFTa7pGcSrmqYYfqbUxV1b2fQLktLrbw==)

For demonstration purpose, the idle timeout is set to **5s** in this demo (default 1min).

Idle: false

Inactive: **0s**

## Usage [​](https://vueuse.org/core/useIdle/\#usage)

ts

```
import {
} from '@vueuse/core'

const {
,
} =
(5 * 60 * 1000) // 5 min

.
(
.
) // true or false
```

Programatically resetting:

ts

```
import {
,
} from '@vueuse/core'
import {
} from 'vue'

const {
,
} =
()

const {
,
,
} =
(5 * 60 * 1000) // 5 min

(
, (
) => {
  if (
) {

()

.
(`Triggered ${
.
} times`)

() // restarts the idle timer. Does not change lastActive value
  }
})
```

## Component Usage [​](https://vueuse.org/core/useIdle/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UseIdle v-slot="{
}"
="5 * 60 * 1000">
    Is Idle: {{
}}
  </UseIdle>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useIdle/\#type-declarations)

ts

```
export interface UseIdleOptions
  extends ConfigurableWindow,
    ConfigurableEventFilter {
  /**
   * Event names that listen to for detected user activity
   *
   * @default ['mousemove', 'mousedown', 'resize', 'keydown', 'touchstart', 'wheel']
   */

?:
[]
  /**
   * Listen for document visibility change
   *
   * @default true
   */

?: boolean
  /**
   * Initial state of the ref idle
   *
   * @default false
   */

?: boolean
}
export interface UseIdleReturn {

:
<boolean>

:
<number>

: () => void
}
/**
 * Tracks whether the user is being inactive.
 *
 * @see https://vueuse.org/useIdle
 * @param timeout default to 1 minute
 * @param options IdleOptions
 */
export declare function
(

?: number,

?: UseIdleOptions,
): UseIdleReturn
```

## Source [​](https://vueuse.org/core/useIdle/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useIdle/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useIdle/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useIdle/index.md)
