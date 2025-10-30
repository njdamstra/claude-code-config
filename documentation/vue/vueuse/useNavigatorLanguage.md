[Skip to content](https://vueuse.org/core/useNavigatorLanguage/#VPContent)

On this page

# useNavigatorLanguage [​](https://vueuse.org/core/useNavigatorLanguage/\#usenavigatorlanguage)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

759 B

Last Changed

2 months ago

Reactive [navigator.language](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/language).

## Demo [​](https://vueuse.org/core/useNavigatorLanguage/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useNavigatorLanguage/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNptkE9LxDAQxb/KkMsquC14LFlxxYsgIugxl2w7WwNtEvKnspR+d6dNtwbxFIa893tvZmRHa4shIqsY97VTNoDHEC10UrcHwYIX7EFo1VvjAowQPb7JQbUyGPdKkihbhAnOzvSweyQQCcraONwJLXRttJ9dyn9EOxOwuVvIq+3wL+/mVmhepjaUTUPA3nYyIE0A3C4PwMasgD8Z06HUz8qT8ALVILuI1D9LFgzKBCgTgWsTEOpOek/K/rS/X3ad0VsnuJaqknO2JHOjBhj26vw3ZCXw2jQZ3C3wccy2nzgdqllpJeFyLnY+/QB8fuFvn2LzH99f6K5AhcBf00FpuJjo4OTMt0dX5GxeZmdk0w8Gu67v)

Supported: true

Navigator Language:

`en-US`

## Usage [​](https://vueuse.org/core/useNavigatorLanguage/\#usage)

ts

```
import {
 } from '@vueuse/core'

const {
 } =
()

(
, () => {
  // Listen to the value changing
})
```

## Type Declarations [​](https://vueuse.org/core/useNavigatorLanguage/\#type-declarations)

Show Type Declarations

ts

```
export interface NavigatorLanguageState {

:
<boolean>
  /**
   *
   * ISO 639-1 standard Language Code
   *
   * @info The detected user agent language preference as a language tag
   * (which is sometimes referred to as a "locale identifier").
   * This consists of a 2-3 letter base language tag that indicates a
   * language, optionally followed by additional subtags separated by
   * '-'. The most common extra information is the country or region
   * variant (like 'en-US' or 'fr-CA').
   *
   *
   * @see https://www.iso.org/iso-639-language-codes.html
   * @see https://www.loc.gov/standards/iso639-2/php/code_list.php
   *
   */

:
<string | undefined>
}
/**
 *
 * Reactive useNavigatorLanguage
 *
 * Detects the currently selected user language and returns a reactive language
 * @see https://vueuse.org/useNavigatorLanguage
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
(

?:
,
):
<NavigatorLanguageState>
export type
 =
<typeof
>
```

## Source [​](https://vueuse.org/core/useNavigatorLanguage/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useNavigatorLanguage/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useNavigatorLanguage/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useNavigatorLanguage/index.md)

## Contributors [​](https://vueuse.org/core/useNavigatorLanguage/\#contributors)

![](https://gravatar.com/avatar/616389b9fc3c3c92d244e2639418f0c5?d=retro) Anthony Fu

![](https://gravatar.com/avatar/b1f73ba4300d063a1ccc27a8e3068d57?d=retro) SerKo

![](https://gravatar.com/avatar/1a35762c4e5869c2ab4feaf3354660a7?d=retro) IlyaL

![](https://gravatar.com/avatar/10af285c4d864f57c5baefa1bcc05ed2?d=retro) Anthony Fu

![](https://gravatar.com/avatar/fcf2fd60dd85e0c9c7c2c1e07b0e44b2?d=retro) Fernando Fernández

![](https://gravatar.com/avatar/4285e144c31e4de4370b7dc19d09a9c5?d=retro) Alex Liu

![](https://gravatar.com/avatar/34cc2a5407b17bea233fe61940d0b047?d=retro) vaakian X

![](https://gravatar.com/avatar/07fd9d00b8f655b55082521e625b3cbb?d=retro) Jelf

![](https://gravatar.com/avatar/2beca816c0cf9e10123f90ff3e1d9b60?d=retro) WuLianN

![](https://gravatar.com/avatar/732e88ac9030d16f0f35a92f0bc76732?d=retro) Michael J. Roberts

## Changelog [​](https://vueuse.org/core/useNavigatorLanguage/\#changelog)

[`v13.6.0`](https://github.com/vueuse/vueuse/releases/tag/v13.6.0) on 7/28/2025

[`d32f8`](https://github.com/vueuse/vueuse/commit/d32f80ca4e0f7600b68cbca05341b351e31563c1) \- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions ( [#4907](https://github.com/vueuse/vueuse/issues/4907))

[`v12.4.0`](https://github.com/vueuse/vueuse/releases/tag/v12.4.0) on 1/10/2025

[`dd316`](https://github.com/vueuse/vueuse/commit/dd316da80925cf6b7d9273419fa86dac50ac23aa) \- feat: use passive event handlers everywhere is possible ( [#4477](https://github.com/vueuse/vueuse/issues/4477))

[`v12.0.0-beta.1`](https://github.com/vueuse/vueuse/releases/tag/v12.0.0-beta.1) on 11/21/2024

[`0a9ed`](https://github.com/vueuse/vueuse/commit/0a9ed589ab0e3a4aa8c7b7a4292757947378c14c) \- feat!: drop Vue 2 support, optimize bundles and clean up ( [#4349](https://github.com/vueuse/vueuse/issues/4349))
