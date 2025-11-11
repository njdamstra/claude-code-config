[Skip to content](https://vueuse.org/core/useTitle/#VPContent)

On this page

# useTitle [​](https://vueuse.org/core/useTitle/\#usetitle)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

912 B

Last Changed

7 months ago

Reactive document title.

WARNING

This composable isn't compatible with SSR.

## Demo [​](https://vueuse.org/core/useTitle/\#demo)

Title

## Usage [​](https://vueuse.org/core/useTitle/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
()


.
(
.
) // print current title


.
= 'Hello' // change current title
```

Set initial title immediately:

ts

```
const
=
('New Title')
```

Pass a `ref` and the title will be updated when the source ref changes:

ts

```
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
(0)

const
=
(() => {
  return !
.
? 'No message' : `${
.
} new messages`
})

(
) // document title will match with the ref "title"
```

Pass an optional template tag [Vue Meta Title Template](https://vue-meta.nuxtjs.org/guide/metainfo.html) to update the title to be injected into this template:

ts

```
const
=
('New Title', {

: '%s | My Awesome Website'
})
```

WARNING

`observe` is incompatible with `titleTemplate`.

## Source [​](https://vueuse.org/core/useTitle/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTitle/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useTitle/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useTitle/index.md)
