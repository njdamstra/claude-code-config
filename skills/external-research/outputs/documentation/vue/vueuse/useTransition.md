[Skip to content](https://vueuse.org/core/useTransition/#VPContent)

On this page

# useTransition [​](https://vueuse.org/core/useTransition/\#usetransition)

Category

[Animation](https://vueuse.org/functions#category=Animation)

Export Size

912 B

Last Changed

2 weeks ago

Transition between values

## Usage [​](https://vueuse.org/core/useTransition/\#usage)

Define a source value to follow, and when changed the output will transition to the new value. If the source changes while a transition is in progress, a new transition will begin from where the previous one was interrupted.

ts

```
import {
,
} from '@vueuse/core'
import {
} from 'vue'

const
=
(0)

const
=
(
, {

: 1000,

:
.
,
})
```

Transition easing can be customized using [cubic bezier curves](https://developer.mozilla.org/en-US/docs/Web/CSS/easing-function/cubic-bezier#description).

ts

```

(source, {

: [0.75, 0, 0.25, 1],
})
```

The following transitions are available via the `TransitionPresets` constant.

- [`linear`](https://cubic-bezier.com/#0,0,1,1)
- [`easeInSine`](https://cubic-bezier.com/#.12,0,.39,0)
- [`easeOutSine`](https://cubic-bezier.com/#.61,1,.88,1)
- [`easeInOutSine`](https://cubic-bezier.com/#.37,0,.63,1)
- [`easeInQuad`](https://cubic-bezier.com/#.11,0,.5,0)
- [`easeOutQuad`](https://cubic-bezier.com/#.5,1,.89,1)
- [`easeInOutQuad`](https://cubic-bezier.com/#.45,0,.55,1)
- [`easeInCubic`](https://cubic-bezier.com/#.32,0,.67,0)
- [`easeOutCubic`](https://cubic-bezier.com/#.33,1,.68,1)
- [`easeInOutCubic`](https://cubic-bezier.com/#.65,0,.35,1)
- [`easeInQuart`](https://cubic-bezier.com/#.5,0,.75,0)
- [`easeOutQuart`](https://cubic-bezier.com/#.25,1,.5,1)
- [`easeInOutQuart`](https://cubic-bezier.com/#.76,0,.24,1)
- [`easeInQuint`](https://cubic-bezier.com/#.64,0,.78,0)
- [`easeOutQuint`](https://cubic-bezier.com/#.22,1,.36,1)
- [`easeInOutQuint`](https://cubic-bezier.com/#.83,0,.17,1)
- [`easeInExpo`](https://cubic-bezier.com/#.7,0,.84,0)
- [`easeOutExpo`](https://cubic-bezier.com/#.16,1,.3,1)
- [`easeInOutExpo`](https://cubic-bezier.com/#.87,0,.13,1)
- [`easeInCirc`](https://cubic-bezier.com/#.55,0,1,.45)
- [`easeOutCirc`](https://cubic-bezier.com/#0,.55,.45,1)
- [`easeInOutCirc`](https://cubic-bezier.com/#.85,0,.15,1)
- [`easeInBack`](https://cubic-bezier.com/#.36,0,.66,-.56)
- [`easeOutBack`](https://cubic-bezier.com/#.34,1.56,.64,1)
- [`easeInOutBack`](https://cubic-bezier.com/#.68,-.6,.32,1.6)

For more complex easing, a custom function can be provided.

ts

```
function
(
) {
  return
=== 0
    ? 0
    :
=== 1
      ? 1
      : (2 ** (-10 *
)) *
.
((
* 10 - 0.75) * ((2 *
.
) / 3)) + 1
}


(source, {

:
,
})
```

## Source [​](https://vueuse.org/core/useTransition/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTransition/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useTransition/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useTransition/index.md)
