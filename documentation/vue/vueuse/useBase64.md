[Skip to content](https://vueuse.org/core/useBase64/#VPContent)

On this page

# useBase64 [​](https://vueuse.org/core/useBase64/\#usebase64)

Category

[Utilities](https://vueuse.org/functions#category=Utilities)

Export Size

794 B

Last Changed

7 months ago

Reactive base64 transforming. Supports plain text, buffer, files, canvas, objects, maps, sets and images.

## Demo [​](https://vueuse.org/core/useBase64/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useBase64/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNq9VV1v2jAU/Ssu0vh4yAeMUWCka6t1baXxMlWbpmUPJnGIK8fObIeAUP/7rh0+QgXTpK19Su4959rHx9f2unGV5+6iII1xY6IiSXONFNFFjhjm8yBsaBU2LkJOs1xIjdaoUOQaKzLooyeUSJGh1iVUQ9aLhCStGlOlmDFRfiHJjgpMYIQ8ElxppMlSo6DGa7danS2YUEYOwMknyFy0dwSa4fkzxt3D9PO9Sd8wkhGuLXvLX6OZ1T228+7WEOxX1DbAbvw930g5yjfAEb5VdrTAIkcqZkWSEHm0hJMSXUmJV9eW0x527JqSgkeaCo4EN77c87zQbTJGNwtYdwetQ46sbneBWWFsahNXYzknGmGFrFGmZGNUxzVcdfbD/xnyp5BPvKoVYOMh0CTLGdYEIoQmMV0gleOIOCunb1Ob5FzSGGXx2HydSDDl9NAc505vQ6pouwBCGIZfPJgusGJgVpOoEcyGYEkwWjiZiAkz/QipsIFSp+8jvcrJPgUaI5IKFhMJyQfAkBIZ0Snlc9d1geHtlXh1KUd1Vf7/QZOVMLb+bkRUJTARwLHgbHVixu3/v5tXNcUp+3JJUKZhjOdN1PV7/c7EA/wFHak39Wt6Ys7DKUcO+ZCghmdN2naTOQkg99IiENcOmL0Jd6WHhv13+/a3zmuaZ6/PU+7RbF43T5IEdNo7LWzUgdJJCsaq9YjZI4k0KFgQWedEDCsF5VIUPCYgFbbgcBQlI8BTrXM19jw7jXILruCcq9SNROblqdDC6fZH/d67wWh0PvD7zvlgGHeTgT+McPSBLmkcTHm5nD5evU0+Xg+nd8sS34782apbfv8Ws+RuOUxuvxYGM/9NumR0FsiZ03V7breJCy2CRMgM62ZCdRBJkTfLoOf7zV/B0K8LfsFWqD0of98L+7+JV7vBIVR6BSdERSInMWR2k9pHI6PcKWms0zHy0Vn1mGOu3xtsk+/6/huIq3fCjAWDNJ5+A8/Kkc8=)

Text Input

Base64

Buffer Input

```
new ArrayBuffer(1024)
```

Base64

File Input

Base64

Image Input![](https://images.unsplash.com/photo-1494256997604-768d1f608cac?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80)

Base64

"\[object Event\]"

## Usage [​](https://vueuse.org/core/useBase64/\#usage)

ts

```
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
('')

const {
} =
(
)
```

If you use object, array, map or set you can provide serializer in options. Otherwise, your data will be serialized by default serializer. Objects and arrays will be transformed in string by JSON.stringify. Map and set will be transformed in object and array respectively before stringify.

## Type Declarations [​](https://vueuse.org/core/useBase64/\#type-declarations)

Show Type Declarations

ts

```
export interface UseBase64Options {
  /**
   * Output as Data URL format
   *
   * @default true
   */

?: boolean
}
export interface ToDataURLOptions extends UseBase64Options {
  /**
   * MIME type
   */

?: string | undefined
  /**
   * Image quality of jpeg or webp
   */

?: any
}
export interface
<
> extends UseBase64Options {

?: (
:
) => string
}
export interface UseBase64Return {

:
<string>

:
<
<string>>

: () =>
<string>
}
export declare function
(

:
<string | undefined>,

?: UseBase64Options,
): UseBase64Return
export declare function
(

:
<Blob | undefined>,

?: UseBase64Options,
): UseBase64Return
export declare function
(

:
<ArrayBuffer | undefined>,

?: UseBase64Options,
): UseBase64Return
export declare function
(

:
<HTMLCanvasElement | undefined>,

?: ToDataURLOptions,
): UseBase64Return
export declare function
(

:
<HTMLImageElement | undefined>,

?: ToDataURLOptions,
): UseBase64Return
export declare function
<
extends
<string, unknown>>(

:
<
>,

?:
<
>,
): UseBase64Return
export declare function
<
extends
<string, unknown>>(

:
<
>,

?:
<
>,
): UseBase64Return
export declare function
<
extends
<unknown>>(

:
<
>,

?:
<
>,
): UseBase64Return
export declare function
<
>(

:
<
[]>,

?:
<
[]>,
): UseBase64Return
```

## Source [​](https://vueuse.org/core/useBase64/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useBase64/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useBase64/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useBase64/index.md)
