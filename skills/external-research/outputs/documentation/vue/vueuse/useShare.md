[Skip to content](https://vueuse.org/core/useShare/#VPContent)

On this page

# useShare [​](https://vueuse.org/core/useShare/\#useshare)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

360 B

Last Changed

2 weeks ago

Reactive [Web Share API](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share). The Browser provides features that can share content in text or file.

> The `share` method has to be called following a user gesture like a button click. It can't simply be called on page load for example. That's in place to help prevent abuse.

## Demo [​](https://vueuse.org/core/useShare/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useShare/demo.client.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNplUsFuwjAM/RWvlzJpo3cEg4n7DkNsl15K6o5oIYkShw1V/fc5CVDQTnXs9+rnZ/fFq7XTY8BiVsy9cNISeKRgQTX6a1EX5OvipdbyYI0j6CF43OwbhzBA58wByhWTOVkJ47C8AUq/VhI1/QP6SG9voQ47aDy0iPadwwuB8YyqtTDaExhLkgNYXHCTvtYAJEnhDMqPgFuP5VPK4S9xam2UQhFZYDpA71mNbBQwFNaGm3uZiluSiiP0D5kenJqN8pegjGgicLqPQvnHETY8jtJ6SDM9MWkTbBwKW55icTVrchafOF3QWZSnxlGuP0IaxrHzjgs5N+W2Yj9B52DxAvxh+lDreZX3xFvhB+HBqoaQXwDzVh5TwKHUNlCOAY7PsuNl3uiri7F2MC0qLp9VTqN/Y51OFuMh3CW5p8C9US06rr0Zwkvt0n8XiHjIWSt9s1PYMuzhrj+shJLim/OjEenWcoc+ntBo5xLKhCjjAj5xl01iCGjDJ3vFSQ0nExzsnPnx6EoY2LIkqMqKslFVdmpe3fhXDH9F6Axl)

Web share is not supported in your browser

## Usage [​](https://vueuse.org/core/useShare/\#usage)

ts

```
import {
} from '@vueuse/core'

const {
,
} =
()

function
() {

({


: 'Hello',


: 'Hello my friend!',


:
.
,
  })
}
```

### Passing a source ref [​](https://vueuse.org/core/useShare/\#passing-a-source-ref)

You can pass a `ref` to it, changes from the source ref will be reflected to your sharing options.

TypeScript

ts

```
import {
} from 'vue'

const
=
<
>({
: 'foo' })
const {
,
} = useShare(
)

.value.text = 'bar'

()
```

js

```
import { ref } from 'vue'
const shareOptions = ref({ text: 'foo' })
const { share, isSupported } = useShare(shareOptions)
shareOptions.value.text = 'bar'
share()
```

## Type Declarations [​](https://vueuse.org/core/useShare/\#type-declarations)

ts

```
export interface UseShareOptions {

?: string

?: File[]

?: string

?: string
}
/**
 * Reactive Web Share API.
 *
 * @see https://vueuse.org/useShare
 * @param shareOptions
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
(

?:
<UseShareOptions>,

?:
,
): {

:
<boolean>

: (
?:
<UseShareOptions>) =>
<void>
}
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useShare/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useShare/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useShare/demo.client.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useShare/index.md)
