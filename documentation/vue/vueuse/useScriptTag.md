[Skip to content](https://vueuse.org/core/useScriptTag/#VPContent)

On this page

# useScriptTag [​](https://vueuse.org/core/useScriptTag/\#usescripttag)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

1.16 kB

Last Changed

3 months ago

Creates a script tag, with support for automatically unloading (deleting) the script tag on unmount.

If a script tag already exists for the given URL, `useScriptTag()` will not create another script tag, but keep in mind that depending on how you use it, `useScriptTag()` might have already loaded then unloaded that particular JS file from a previous call of `useScriptTag()`.

## Usage [​](https://vueuse.org/core/useScriptTag/\#usage)

TypeScript

ts

```
import {
} from '@vueuse/core'

(
  'https://player.twitch.tv/js/embed/v1.js',
  // on script tag loaded.
  (
: HTMLScriptElement) => {
    // do something
  },
)
```

js

```
import { useScriptTag } from '@vueuse/core'
useScriptTag(
  'https://player.twitch.tv/js/embed/v1.js',
  // on script tag loaded.
  (el) => {
    // do something
  },
)
```

The script will be automatically loaded when the component is mounted and removed when the component is unmounted.

## Configuration [​](https://vueuse.org/core/useScriptTag/\#configuration)

Set `manual: true` to have manual control over the timing to load the script.

ts

```
import {
} from '@vueuse/core'

const {
,
,
} =
(
  'https://player.twitch.tv/js/embed/v1.js',
  () => {
    // do something
  },
  {
: true },
)

// manual controls
await
()
await
()
```

## Type Declarations [​](https://vueuse.org/core/useScriptTag/\#type-declarations)

Show Type Declarations

ts

```
export interface UseScriptTagOptions extends ConfigurableDocument {
  /**
   * Load the script immediately
   *
   * @default true
   */

?: boolean
  /**
   * Add `async` attribute to the script tag
   *
   * @default true
   */

?: boolean
  /**
   * Script type
   *
   * @default 'text/javascript'
   */

?: string
  /**
   * Manual controls the timing of loading and unloading
   *
   * @default false
   */

?: boolean

?: "anonymous" | "use-credentials"

?:
    | "no-referrer"
    | "no-referrer-when-downgrade"
    | "origin"
    | "origin-when-cross-origin"
    | "same-origin"
    | "strict-origin"
    | "strict-origin-when-cross-origin"
    | "unsafe-url"

?: boolean

?: boolean
  /**
   * Add custom attribute to the script tag
   *
   */

?:
<string, string>
  /**
   * Nonce value for CSP (Content Security Policy)
   * @default undefined
   */

?: string
}
/**
 * Async script tag loading.
 *
 * @see https://vueuse.org/useScriptTag
 * @param src
 * @param onLoaded
 * @param options
 */
export declare function
(

:
<string>,

?: (
: HTMLScriptElement) => void,

?: UseScriptTagOptions,
): {

:
<HTMLScriptElement | null, HTMLScriptElement | null>

: (
?: boolean) =>
<HTMLScriptElement | boolean>

: () => void
}
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useScriptTag/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useScriptTag/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useScriptTag/index.md)
