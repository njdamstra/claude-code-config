[Skip to content](https://vueuse.org/core/useFavicon/#VPContent)

On this page

# useFavicon [​](https://vueuse.org/core/useFavicon/\#usefavicon)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

441 B

Last Changed

7 months ago

Reactive favicon

## Demo [​](https://vueuse.org/core/useFavicon/\#demo)

Change favicon to

Vue  VueUse

## Usage [​](https://vueuse.org/core/useFavicon/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
()


.
= 'dark.png' // change current icon
```

### Passing a source ref [​](https://vueuse.org/core/useFavicon/\#passing-a-source-ref)

You can pass a `ref` to it, changes from of the source ref will be reflected to your favicon automatically.

ts

```
import {
,
} from '@vueuse/core'
import {
} from 'vue'

const
=
()
const
=
(() =>
.
? 'dark.png' : 'light.png')

(
)
```

When a source ref is passed, the return ref will be identical to the source ref

ts

```
const
=
('icon.png')
const
=
(
)


.
(
===
) // true
```

## Type Declarations [​](https://vueuse.org/core/useFavicon/\#type-declarations)

ts

```
export interface UseFaviconOptions extends ConfigurableDocument {

?: string

?: string
}
/**
 * Reactive favicon.
 *
 * @see https://vueuse.org/useFavicon
 * @param newIcon
 * @param options
 */
export declare function
(

:
<string | null | undefined>,

?: UseFaviconOptions,
):
<string | null | undefined>
export declare function
(

?:
<string | null | undefined>,

?: UseFaviconOptions,
):
<string | null | undefined>
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useFavicon/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useFavicon/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useFavicon/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useFavicon/index.md)
