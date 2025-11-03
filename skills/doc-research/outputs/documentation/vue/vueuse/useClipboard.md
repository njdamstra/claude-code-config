[Skip to content](https://vueuse.org/core/useClipboard/#VPContent)

On this page

# useClipboard [​](https://vueuse.org/core/useClipboard/\#useclipboard)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

1.44 kB

Last Changed

2 months ago

Related

[`useClipboardItems`](https://vueuse.org/core/useClipboardItems/)

Reactive [Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API). Provides the ability to respond to clipboard commands (cut, copy, and paste) as well as to asynchronously read from and write to the system clipboard. Access to the contents of the clipboard is gated behind the [Permissions API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API). Without user permission, reading or altering the clipboard contents is not permitted.

[Learn how to reactively save text to the clipboard with this FREE video lesson from Vue School!](https://vueschool.io/lessons/reactive-browser-wrappers-in-vueuse-useclipboard?friend=vueuse)

## Demo [​](https://vueuse.org/core/useClipboard/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboard/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNp9UrtuwzAM/BXCi10gqfdACRJ06hakQ1HAix9MK9SWBD2cBo7/vZQVP5qhmkzz7ng8qYsOSj23DqNNxEypubJg0DoFdS4+t1lkTRbtMsEbJbWFDpzBl5qrQua6WvnqiLrhxnApoIezlg3Ee9KjTlpKjfGCa77yupaXE54nKCEJkYlSCmOBC+UsbBfAJI6f5n4HFn/sCrh5c8qLInkopbqS3vaPtYRYgaMmfyfMqwCbPSdxOVLWmvp+2iPvXXOL/xEvHuCZLA0RUmBUWGxUnVukCoBVvIV2zc+U6cL+EC7QYULekf5Me8A8cQPeILBi13WPW/U9S4sd3GCwMqo8QsMiAXufmi7GMjXPd1qjsD5bjtUGWCkr9GI+f7jdIBZSYDxoDa1RbpRg4SrbdUPd2u/s6ywCe1XonxXpzLsXzlp6P3uKtPymrr/SZGA8TSAyRX/HOYERkk0p2vClaCDWZrTzIZ2GQsuLQQ2VRAO0LZiQ/SLjw/E1CHn3LF3cW9T/AjLME7w=)

Clipboard Permission: read **prompt** \| write **granted**

Current copied: `none`

Copy

## Usage [​](https://vueuse.org/core/useClipboard/\#usage)

vue

```
<script setup lang="ts">
import {
 } from '@vueuse/core'

const
 =
('Hello')
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
>Current copied: <
>{{
 || 'none' }}</
></
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

Set `legacy: true` to keep the ability to copy if [Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API) is not available. It will handle copy with [execCommand](https://developer.mozilla.org/en-US/docs/Web/API/Document/execCommand) as fallback.

## Component Usage [​](https://vueuse.org/core/useClipboard/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UseClipboard v-slot="{
,
 }"
="copy me">
    <
 @
="
()">
      {{
 ? 'Copied' : 'Copy' }}
    </
>
  </UseClipboard>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useClipboard/\#type-declarations)

Show Type Declarations

ts

```
export interface
<
> extends ConfigurableNavigator {
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
  /**
   * Whether fallback to document.execCommand('copy') if clipboard is undefined.
   *
   * @default false
   */

?: boolean
}
export interface
<
> {

:
<boolean>

:
<string>

:
<boolean>

:
 extends true
    ? (
?: string) =>
<void>
    : (
: string) =>
<void>
}
/**
 * Reactive Clipboard API.
 *
 * @see https://vueuse.org/useClipboard
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
<string>>,
):
<true>
```

## Source [​](https://vueuse.org/core/useClipboard/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboard/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboard/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useClipboard/index.md)
