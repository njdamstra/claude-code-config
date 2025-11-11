[Skip to content](https://vueuse.org/core/useClipboardItems/#VPContent)

On this page

# useClipboardItems [​](https://vueuse.org/core/useClipboardItems/\#useclipboarditems)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

1.03 kB

Last Changed

last month

Related

[`useClipboard`](https://vueuse.org/core/useClipboard/)

Reactive [Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API). Provides the ability to respond to clipboard commands (cut, copy, and paste) as well as to asynchronously read from and write to the system clipboard. Access to the contents of the clipboard is gated behind the [Permissions API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API). Without user permission, reading or altering the clipboard contents is not permitted.

## Demo [​](https://vueuse.org/core/useClipboardItems/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboardItems/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVF1r2zAU/SsXM2oZUufdOKHdnvpQKF1hjLpQfyitNlsSkpysuP7vu9eKYyfNRg1GtnTuuV/nqguutY63LQ+SILWlEdqB5a7VUOfyZZUFzmbBOpOi0co46KC1/FstdKFyU9043tgFbd1x0whrhZLQw8aoBsIrJMWTZakMD2cEfLPhpVuAfc3rWu3u+eZgghaIzGSppHUgpG4drGZAFobRdN4Bro5L5BL2e6uJn1cL3NVvCzA8r5B49TFghhyeoVQNuuDVA/9zztEx6FY0/OFN8zNAnxJjEazW0GUS4A7zEZbHiGP7KONtXrc8bnLNBIZBUFrjF+6IloUOo1jqOhcyjCJkBXxi98oly+2bLIEVtSrs5IOe0+C8EwxxwA7O6ItsaI0dYqL4lxKShQug2I95qBIHDpbvcuGOcvkXLZoxDPojdY8rvb6W+iCTe2rP0JxJOiwsx0ZdUvumHkx2PwwW7X+GOwJ4mWxaWTqSZIls7lQFFHMC1hkhXyJfUe+swVqih3k/pkOfNki+g6/4yR4J9bRAMVJpE29MCQMq0LVGDtAj12zfvUfCPiUD5YK2hlplMl36OcSpwx80wBgcxz+AtBJb2F6KDQ7mTPPDhBJlKtUeSc/BK0ylSvxgpMW6607b0ffpsljDOww1HFlOob4DHrv3upy5TfXkvzUGhU8DKXiVQFqqihMZjsRs8C4u4PlLN9/qgVFtEpi2R4H30XME7++QBVJJngVDIAPvGMvoP/X3x/aywdOaCkb/aEGNoosNHU2FK1rnFNbbR36Feip/I8iPNN0o7PGsigbS6CnKAm87JY82Y0ie/FOuqDt4QZ2y3eayzevh9AxpukRd+C+NCfPajuX4qVoDhVE7yw1UilvAVoH1wpkJ5PruxhNR9dLlTHRB/xcJmhN0)

Clipboard Permission: read **prompt** \| write **granted**

Current copied: `none`

Copy  Manual read

## Difference from `useClipboard` [​](https://vueuse.org/core/useClipboardItems/\#difference-from-useclipboard)

[`useClipboard`](https://vueuse.org/core/useClipboard/) is a "text-only" function, while [`useClipboardItems`](https://vueuse.org/core/useClipboardItems/) is a [ClipboardItem](https://developer.mozilla.org/en-US/docs/Web/API/ClipboardItem) based function. You can use [`useClipboardItems`](https://vueuse.org/core/useClipboardItems/) to copy any content supported by [ClipboardItem](https://developer.mozilla.org/en-US/docs/Web/API/ClipboardItem).

## Usage [​](https://vueuse.org/core/useClipboardItems/\#usage)

vue

```
<script setup lang="ts">
import {
 } from '@vueuse/core'

const
 = 'text/plain'
const
 =
([\
  new\
({\
    [\
]: new\
(['plain text'], {\
:\
 }),\
  })\
])

const {
,
,
,
 } =
({
 })
</script>

<template>
  <
 v-if="
">
    <
 @
="
(
)">
      <!-- by default, `copied` will be reset in 1.5s -->
      <
 v-if="!
">Copy</
>
      <
 v-else>Copied!</
>
    </
>
    <
>
      Current copied: <
>{{
 || 'none' }}</
>
    </
>
  </
>
  <
 v-else>
    Your browser does not support Clipboard API
  </
>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useClipboardItems/\#type-declarations)

Show Type Declarations

ts

```
export interface
<
>
  extends ConfigurableNavigator {
  /**
   * Enabled reading for clipboard
   *
   * @default false
   */

?: boolean
  /**
   * Copy source
   */

?:


  /**
   * Milliseconds to reset state of `copied` ref
   *
   * @default 1500
   */

?: number
}
export interface
<
> {

:
<boolean>

:
<
<
>>

:
<
<boolean>>

:
 extends true
    ? (
?:
) =>
<void>
    : (
:
) =>
<void>

: () => void
}
/**
 * Reactive Clipboard API.
 *
 * @see https://vueuse.org/useClipboardItems
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
(

?:
<undefined>,
):
<false>
export declare function
(

:
<
<
>>,
):
<true>
```

## Source [​](https://vueuse.org/core/useClipboardItems/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboardItems/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboardItems/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboardItems/index.md)

## Contributors [​](https://vueuse.org/core/useClipboardItems/\#contributors)

![](https://gravatar.com/avatar/616389b9fc3c3c92d244e2639418f0c5?d=retro) Anthony Fu

![](https://gravatar.com/avatar/7a1806b5ad96f54dbdb5e593cef7cb51?d=retro) Robin

![](https://gravatar.com/avatar/b1f73ba4300d063a1ccc27a8e3068d57?d=retro) SerKo

![](https://gravatar.com/avatar/10af285c4d864f57c5baefa1bcc05ed2?d=retro) Anthony Fu

![](https://gravatar.com/avatar/1a35762c4e5869c2ab4feaf3354660a7?d=retro) IlyaL

![](https://gravatar.com/avatar/fcf2fd60dd85e0c9c7c2c1e07b0e44b2?d=retro) Fernando Fernández

![](https://gravatar.com/avatar/4285e144c31e4de4370b7dc19d09a9c5?d=retro) Alex Liu

![](https://gravatar.com/avatar/4932c033267bef3f076107b02bd590d7?d=retro) Indrek Ardel

![](https://gravatar.com/avatar/957809d83cf701f34e53e9d3ed7a2242?d=retro) Shang Chien

![](https://gravatar.com/avatar/c317c9f126373a8a57802075a20fc101?d=retro) Naoki Haba

![](https://gravatar.com/avatar/070b126eb17dd71afdcd278e5687f8fa?d=retro) Doctorwu

## Changelog [​](https://vueuse.org/core/useClipboardItems/\#changelog)

[`v13.7.0`](https://github.com/vueuse/vueuse/releases/tag/v13.7.0) on 8/18/2025

[`d03b2`](https://github.com/vueuse/vueuse/commit/d03b2a4296b1af81d05ff6e3f472a7f5bf116a36) \- feat: expose `read()` ( [#4954](https://github.com/vueuse/vueuse/issues/4954))

[`v13.6.0`](https://github.com/vueuse/vueuse/releases/tag/v13.6.0) on 7/28/2025

[`d32f8`](https://github.com/vueuse/vueuse/commit/d32f80ca4e0f7600b68cbca05341b351e31563c1) \- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions ( [#4907](https://github.com/vueuse/vueuse/issues/4907))

[`v12.8.0`](https://github.com/vueuse/vueuse/releases/tag/v12.8.0) on 3/5/2025

[`7432f`](https://github.com/vueuse/vueuse/commit/7432fd1d4f47613a26e9286d2723b87eebfb30f3) \- feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native ( [#4636](https://github.com/vueuse/vueuse/issues/4636))

[`v12.4.0`](https://github.com/vueuse/vueuse/releases/tag/v12.4.0) on 1/10/2025

[`dd316`](https://github.com/vueuse/vueuse/commit/dd316da80925cf6b7d9273419fa86dac50ac23aa) \- feat: use passive event handlers everywhere is possible ( [#4477](https://github.com/vueuse/vueuse/issues/4477))

[`v12.3.0`](https://github.com/vueuse/vueuse/releases/tag/v12.3.0) on 1/2/2025

[`59f75`](https://github.com/vueuse/vueuse/commit/59f75c706aa42be1dd79b86c59d98794069dd0df) \- feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

[`6860f`](https://github.com/vueuse/vueuse/commit/6860f651b0c0eeaae708b24aaafce07d278cc02c) \- fix(useClipboard,useClipboardItems): avoid running "copied" timeout during initialization ( [#4299](https://github.com/vueuse/vueuse/issues/4299))

[`v12.0.0-beta.1`](https://github.com/vueuse/vueuse/releases/tag/v12.0.0-beta.1) on 11/21/2024

[`0a9ed`](https://github.com/vueuse/vueuse/commit/0a9ed589ab0e3a4aa8c7b7a4292757947378c14c) \- feat!: drop Vue 2 support, optimize bundles and clean up ( [#4349](https://github.com/vueuse/vueuse/issues/4349))

[`v10.6.0`](https://github.com/vueuse/vueuse/releases/tag/v10.6.0) on 11/9/2023

[`1aa50`](https://github.com/vueuse/vueuse/commit/1aa50f825a24007ce58f9aaa352da75fcfd15818) \- feat: new function ( [#3477](https://github.com/vueuse/vueuse/issues/3477))
