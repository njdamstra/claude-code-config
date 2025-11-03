[Skip to content](https://vueuse.org/shared/watchPausable/#VPContent)

On this page

# watchPausable [​](https://vueuse.org/shared/watchPausable/\#watchpausable)

Category

[Watch](https://vueuse.org/functions#category=Watch)

Export Size

463 B

Last Changed

2 weeks ago

Alias

`pausableWatch`

Pausable watch

INFO

This function will be removed in future version.

TIP

[Pausable Watcher](https://vuejs.org/api/reactivity-core.html#watch) has been added to Vue [since 3.5](https://github.com/vuejs/core/pull/9651), use `const { stop, pause, resume } = watch(watchSource, callback)` instead.

## Demo [​](https://vueuse.org/shared/watchPausable/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchPausable/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNp9U9tq3DAQ/ZWpKdhLkzX0MXi3CaHQQgolzaMe4rXHFypLRhenxfW/dyRbjpdt8ybNnHNGc2Y0Rnd9vx8sRjdRpgvV9gY0GtsDz0V9YJHRLDoy0Xa9VAZGkOKHyZV5+t23or6Cl9wUzffc6vzEESaolOwgviVBqzEtpMJ4Q9ZNzrl8ecRqhRKSEEwUUmgDreitgcMGmH15+vbw1YU/c+xQGPgDwnJ+THaBxGV9RknimHIhq6VVBb4B8C2gIsRZMwkTsJCv3HGAwxESqrUfcm4RPhzg+b4hk7AEI4FF78dhYhFj4nlHBF/gzKwk2TkJ3+Ks8WlfycLqZOfBlRWFaaWAgmOuCDy6sq8FDxCTU9MG2NNT8RJIL4tdF1jSY4gCocX9QjhXUaht9x+ZR5+70AkULxR8HKHVdyQ5uD1YzETFRJbOe0VbRBeDXc9zg3QDyMp28Ac6CmmQWs+1pq3rTtcf/d65FAAZiDSLDk1DRsIJaY7OdKPauqbRmQbneotW6sSCsDc8KCmsSH4ORSE4XHeyRE6Jed6vGUOF3SfAXyvct+GFT9YY8u+mbP3ClAR8Fyxg0dqLVG5JKHBb8Lb4SRE/hk17fljh6bNqePw/amxKrIrzQDaS8+De1FzJft823Ht3hwdZX9CDgFql3GkzwCOxVveXeK/wOI7+l05Tlrqrn306Dz9LNysRTX8B1byIJw==)

Type something below to trigger the watch

Pause  Resume  Clear Log

Log

```

```

## Usage [​](https://vueuse.org/shared/watchPausable/\#usage)

Use as normal the `watch`, but return extra `pause()` and `resume()` functions to control.

ts

```
import {
 } from '@vueuse/core'
import {
,
 } from 'vue'

const
 =
('foo')

const {
,
,
 } =
(


,

 =>
.
(`Changed to ${
}!`),
)

.
 = 'bar'
await
() // Changed to bar!

()

.
 = 'foobar'
await
() // (nothing happend)

()

.
 = 'hello'
await
() // Changed to hello!
```

## Type Declarations [​](https://vueuse.org/shared/watchPausable/\#type-declarations)

Show Type Declarations

ts

```
export interface WatchPausableReturn extends Pausable {

:


}
export type
<
> =

<
> &


/**
 * @deprecated This function will be removed in future version.
 */
export declare function
<

 extends
<
<unknown>[]>,

 extends
<boolean> = false,
>(

: [...\
],

:
<
<
>,
<
,
>>,

?:
<
>,
): WatchPausableReturn
export declare function
<


,

 extends
<boolean> = false,
>(

:
<
>,

:
<
,
 extends true ?
 | undefined :
>,

?:
<
>,
): WatchPausableReturn
export declare function
<

 extends object,

 extends
<boolean> = false,
>(

:
,

:
<
,
 extends true ?
 | undefined :
>,

?:
<
>,
): WatchPausableReturn
/** @deprecated use `watchPausable` instead */
export declare const
: typeof


```

## Source [​](https://vueuse.org/shared/watchPausable/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchPausable/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchPausable/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchPausable/index.md)
