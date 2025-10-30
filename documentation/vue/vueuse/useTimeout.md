[Skip to content](https://vueuse.org/shared/useTimeout/#VPContent)

On this page

# useTimeout [​](https://vueuse.org/shared/useTimeout/\#usetimeout)

Category

[Animation](https://vueuse.org/functions#category=Animation)

Export Size

402 B

Last Changed

6 months ago

Update value after a given time with controls.

## Demo [​](https://vueuse.org/shared/useTimeout/\#demo)

Ready: false

Start Again

## Usage [​](https://vueuse.org/shared/useTimeout/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
(1000)
```

ts

```
const {
,
,
} =
(1000, {
: true })
```

ts

```
import {
} from '@vueuse/core'


.
(ready.value) // false

await
(1200)


.
(ready.value) // true
```

## Source [​](https://vueuse.org/shared/useTimeout/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useTimeout/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/useTimeout/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useTimeout/index.md)
