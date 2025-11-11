[Skip to content](https://vueuse.org/core/useGamepad/#VPContent)

On this page

# useGamepad [​](https://vueuse.org/core/useGamepad/\#usegamepad)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

1.47 kB

Last Changed

last month

Provides reactive bindings for the [Gamepad API](https://developer.mozilla.org/en-US/docs/Web/API/Gamepad_API).

## Demo [​](https://vueuse.org/core/useGamepad/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useGamepad/demo.client.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNq9VE1r3DAQ/StTX9JCbZfSUli8pqEtJZdS6NUXRZ5di/VKQpKdXUL62/u0/kx7KASS23zP03tj3yfX1mZ9x8kmKbx0ygbyHDpLrdD7bZUEXyVlpdXRGhfonjrP38WRrajpgXbOHOnqM9oRzqVxfDWXTlVDTYYs4pp18PmYimtRX2lptI+zlf/V2djM9VvaD0Uea7orra/fVLrIB6TABSfw0bYiMDyiolb9xRhM6lO1wyterUZXCe1aPiH6m5y5g4t2yfAVRvlUAiM7AqgAa3RRdcmiag54O7Sd0g8XjuJSrFWkUincrdEpO2ccBT4FlH08tWgyaFLhHP13cPOlL8KdgUmD4jmHLJbpadL7OKmcCFaetIFq0/vIoLBBtOZeSc7AFnr/mbUA+QQg5U3UHQ+ks+nc2Eq14UfDMZdnYa9/3mT0pWF5oEJQ4zgS3YRg/SbPpdAKomVQPR+VxJKGHRe5KGkHWgS1CrIvuIel/m/ARb7SdG0P+nLreRB5upisZb0PDW23W4ocv5TacX8ab9m0/Fyi/zAz/185sARv/9U37iy/ad85HtQdiYqXA7j6MoWErsk69h7C3HYhxCsydCcODC6os0+QZebs/Jiz6QV9ijtYhCOl568eLG0OHNGPkUzFD3czekt8ReeCYrKKfPVzSB7+AENgn7k=)

No Gamepad DetectedEnsure your gamepad is connected and press a button to wake it up.

## Usage [​](https://vueuse.org/core/useGamepad/\#usage)

> Due to how the Gamepad API works, you must interact with the page using the gamepad before it will be detected.

vue

```
<script setup lang="ts">
import {
 } from '@vueuse/core'
import {
 } from 'vue'

const {
,
 } =
()
const
 =
(() =>
.
.
(
 =>
.
 === 'standard'))
</script>

<template>
  <
>
    {{
.
 }}
  </
>
</template>
```

### Gamepad Updates [​](https://vueuse.org/core/useGamepad/\#gamepad-updates)

Currently the Gamepad API does not have event support to update the state of the gamepad. To update the gamepad state, `requestAnimationFrame` is used to poll for gamepad changes. You can control this polling by using the `pause` and `resume` functions provided by `useGamepad`

ts

```
import {
 } from '@vueuse/core'

const {
,
,
 } =
()

()

// gamepads object will not update

()

// gamepads object will update on user input
```

### Gamepad Connect & Disconnect Events [​](https://vueuse.org/core/useGamepad/\#gamepad-connect-disconnect-events)

The `onConnected` and `onDisconnected` events will trigger when a gamepad is connected or disconnected.

ts

```
const {
,
,
 } =
()

((
) => {

.
(`${
.
[\
].
} connected`)
})

((
) => {

.
(`${
} disconnected`)
})
```

### Vibration [​](https://vueuse.org/core/useGamepad/\#vibration)

> The Gamepad Haptics API is sparse, so check the [compatibility table](https://developer.mozilla.org/en-US/docs/Web/API/GamepadHapticActuator#browser_compatibility) before using.

ts

```
import {
 } from 'vue'

const
 =
(() =>
.hapticActuators.length > 0)
function
() {
  if (
.
) {
    const
 =
.hapticActuators[0]

.playEffect('dual-rumble', {

: 0,

: 1000,

: 1,

: 1,
    })
  }
}
```

### Mappings [​](https://vueuse.org/core/useGamepad/\#mappings)

To make the Gamepad API easier to use, we provide mappings to map a controller to a controllers button layout.

#### Xbox360 Controller [​](https://vueuse.org/core/useGamepad/\#xbox360-controller)

vue

```
<script setup>
import {
 } from '@vueuse/core'

const
 =
(gamepad)
</script>

<template>
  <
>{{
.
.
.
 }}</
>
  <
>{{
.
.
.
 }}</
>
  <
>{{
.
.
.
 }}</
>
  <
>{{
.
.
.
 }}</
>
</template>
```

Currently there are only mappings for the Xbox 360 controller. If you have controller you want to add mappings for, feel free to open a PR for more controller mappings!

### SSR Compatibility [​](https://vueuse.org/core/useGamepad/\#ssr-compatibility)

This component is designed to be used in the client side. In some cases, SSR might cause some hydration mismatches.

If you are using Nuxt, you can simply rename your component file with the `.client.vue` suffix (e.g., `GamepadComponent.client.vue`) which will automatically make it render only on the client side, avoiding hydration mismatches.

In other frameworks or plain Vue, you can wrap your usage component with a `<ClientOnly>` component to ensure it is only rendered on the client side.

## Type Declarations [​](https://vueuse.org/core/useGamepad/\#type-declarations)

Show Type Declarations

ts

```
export interface UseGamepadOptions
  extends ConfigurableWindow,
    ConfigurableNavigator {}
/**
 * Maps a standard standard gamepad to an Xbox 360 Controller.
 */
export declare function
(

:
<Gamepad | undefined>,
):
<{

: {

: GamepadButton

: GamepadButton

: GamepadButton

: GamepadButton
  }

: {

: GamepadButton

: GamepadButton
  }

: {

: GamepadButton

: GamepadButton
  }

: {

: {

: number

: number

: GamepadButton
    }

: {

: number

: number

: GamepadButton
    }
  }

: {

: GamepadButton

: GamepadButton

: GamepadButton

: GamepadButton
  }

: GamepadButton

: GamepadButton
} | null>
export declare function
(
?: UseGamepadOptions): {

:
<boolean>

:
<number>

:
<number>

:
<
    {
      readonly
:
<number>
      readonly
: readonly {
        readonly
: boolean
        readonly
: boolean
        readonly
: number
      }[]
      readonly
: boolean
      readonly
: string
      readonly
: number
      readonly
:


      readonly
:


      readonly
: {

: (

:
,

?: GamepadEffectParameters,
        ) =>
<
>

: () =>
<
>
      }
    }[],
    | Gamepad[]
    | {
        readonly
:
<number>
        readonly
: readonly {
          readonly
: boolean
          readonly
: boolean
          readonly
: number
        }[]
        readonly
: boolean
        readonly
: string
        readonly
: number
        readonly
:


        readonly
:


        readonly
: {

: (

:
,

?: GamepadEffectParameters,
          ) =>
<
>

: () =>
<
>
        }
      }[]
  >

:


:



:
<
<boolean>>
}
export type
 =
<typeof
>
```

## Source [​](https://vueuse.org/core/useGamepad/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useGamepad/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useGamepad/demo.client.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useGamepad/index.md)

## Contributors [​](https://vueuse.org/core/useGamepad/\#contributors)

![](https://gravatar.com/avatar/616389b9fc3c3c92d244e2639418f0c5?d=retro) Anthony Fu

![](https://gravatar.com/avatar/d2eccc131bb7a5815d1ef3695ad30b04?d=retro) wheat

![](https://gravatar.com/avatar/b1f73ba4300d063a1ccc27a8e3068d57?d=retro) SerKo

![](https://gravatar.com/avatar/10af285c4d864f57c5baefa1bcc05ed2?d=retro) Anthony Fu

![](https://gravatar.com/avatar/07fd9d00b8f655b55082521e625b3cbb?d=retro) Jelf

![](https://gravatar.com/avatar/99eb998777e92818fc1e4eacb5179fb3?d=retro) Arthur Darkstone

![](https://gravatar.com/avatar/f51f296ebe029205494b11b547e46d20?d=retro) isolcat

![](https://gravatar.com/avatar/fcf2fd60dd85e0c9c7c2c1e07b0e44b2?d=retro) Fernando Fernández

![](https://gravatar.com/avatar/43ccdfefe51e610d6dca3eeca53eb14b?d=retro) Robin

![](https://gravatar.com/avatar/d8ad4c0ae7d3caa06ba57673c92bd9ec?d=retro) Aaron-zon

![](https://gravatar.com/avatar/4e1d81d4ff324dc387a54f7241578482?d=retro) yue

![](https://gravatar.com/avatar/f0ebb9f59597d96b43d1b965809ae80f?d=retro) Curt Grimes

![](https://gravatar.com/avatar/3c332f66631af2f53aa035dc9a3b8fa2?d=retro) Stefan

![](https://gravatar.com/avatar/062c64463025de168c66bfb8bb6f9fe8?d=retro) Antonin Rousset

![](https://gravatar.com/avatar/3dcd491fb0108c7ede95cf76ae5966e7?d=retro) 丶远方

![](https://gravatar.com/avatar/e2456e5a43aeb2bd86970a3837fd8496?d=retro) 三咲智子

## Changelog [​](https://vueuse.org/core/useGamepad/\#changelog)

[`v13.7.0`](https://github.com/vueuse/vueuse/releases/tag/v13.7.0) on 8/18/2025

[`c5277`](https://github.com/vueuse/vueuse/commit/c5277625e10fa124f6dc2a396942bbaa8a691eb1) \- fix: correct type assertion for vibrationActuator ( [#4964](https://github.com/vueuse/vueuse/issues/4964))

[`v13.6.0`](https://github.com/vueuse/vueuse/releases/tag/v13.6.0) on 7/28/2025

[`d32f8`](https://github.com/vueuse/vueuse/commit/d32f80ca4e0f7600b68cbca05341b351e31563c1) \- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions ( [#4907](https://github.com/vueuse/vueuse/issues/4907))

[`v12.4.0`](https://github.com/vueuse/vueuse/releases/tag/v12.4.0) on 1/10/2025

[`dd316`](https://github.com/vueuse/vueuse/commit/dd316da80925cf6b7d9273419fa86dac50ac23aa) \- feat: use passive event handlers everywhere is possible ( [#4477](https://github.com/vueuse/vueuse/issues/4477))

[`v12.0.0-beta.1`](https://github.com/vueuse/vueuse/releases/tag/v12.0.0-beta.1) on 11/21/2024

[`0a9ed`](https://github.com/vueuse/vueuse/commit/0a9ed589ab0e3a4aa8c7b7a4292757947378c14c) \- feat!: drop Vue 2 support, optimize bundles and clean up ( [#4349](https://github.com/vueuse/vueuse/issues/4349))

[`v10.10.0`](https://github.com/vueuse/vueuse/releases/tag/v10.10.0) on 5/27/2024

[`2ccbd`](https://github.com/vueuse/vueuse/commit/2ccbd3db39bcb778d83877d108273f62af0a516f) \- fix: avoid spread to fix gamepad state ( [#3913](https://github.com/vueuse/vueuse/issues/3913))

[`v10.8.0`](https://github.com/vueuse/vueuse/releases/tag/v10.8.0) on 2/20/2024

[`9b8ed`](https://github.com/vueuse/vueuse/commit/9b8ed55f8efa05b409cfedc10a8ef1d58cb57af3) \- fix: improve data updating logic ( [#3775](https://github.com/vueuse/vueuse/issues/3775))

[`8c735`](https://github.com/vueuse/vueuse/commit/8c73515fd614443484ca4ea22383f7f0ebc56b8a) \- fix: explicitly ensure gamepad index is available ( [#3653](https://github.com/vueuse/vueuse/issues/3653))
