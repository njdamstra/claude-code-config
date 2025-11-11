[Skip to content](https://vueuse.org/core/useConfirmDialog/#VPContent)

On this page

# useConfirmDialog [​](https://vueuse.org/core/useConfirmDialog/\#useconfirmdialog)

Category

[Utilities](https://vueuse.org/functions#category=Utilities)

Export Size

416 B

Last Changed

2 months ago

Creates event hooks to support modals and confirmation dialog chains.

Functions can be used on the template, and hooks are a handy skeleton for the business logic of modals dialog or other actions that require user confirmation.

## Demo [​](https://vueuse.org/core/useConfirmDialog/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useConfirmDialog/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNq1VtuO2zYQ/ZWJi8JaYCnb6i6KqN5tihR9KYoCm1e/UBIlM6FIgaRsJ47/PUORsuRLNosgsSGbMxyeOXM4pL2f/NU08aZlk3SyNLnmjQXDbNuAoLJ6WE2sWU0eV5LXjdIW9tAa9lbJkuv6b06FquAApVY1TN8gCE7OcqXZdLTArKkQavvEymMoRmLESuZKGgs1M4ZWDB5GodF0etPPa7ZhVLBicRpRUmHYRVByPagPKzrODum8juiY5ojpgx3iV4OTDjugxko+df4ouoGHR9ivJPTVxRsqWlfj9D9VUAHcIE21la9QiMMZSEg1RglUYp83wgUXi6jM2fOZfQgrznMmLyP+jqEsBdTP8ndYR/6amVbYAZKX0PuceY2iX+o5AjDcvcugJ/ae5fZ6HZcy9BIN0r1AmuXMnwXsfDQsqxtBLUMLYLlOum8cmYZKyAU1xh0UtrNEaTw1jNzN53hq9vtjbx8OiIjRHmEWIJZZa63CDA4tLbihGXJArKHlP38eWns18ZFvcsHzDxh2WpqfDtzeuhCwCt7hLoHvOd+7noHP3JWH5itC4B+usefDoSbEEyz4BjaEl2NO3X3Q1Y+zYXhmoNk8dplD03jYP5ezZlgwO1leKmWZHiN4ipfVIqDrkSMN//r/39HSobxvo3U7fwbm2+EZwOXshO9QSz86ynoiwHO64va+TNdwRkBp8CfhB6ia9KpGVrd4YZ7JERT/DoEH4HAVnyL7Ar4T+Ofs3HI2Ou5oGvtRMDC5aliBntjff93V0ijDLVcyhZLvWPGH8wlW2hTu5792llXNyMDLwZRK16kfuhwRwdlbcJ83XdCWF3adwl0yb3ado6Y7EpyLeUD6RLgs2M550D70rIigH1WLP7onMYmL6Yn5cUfLD6/VkNH8Q6VVKwuSK6F0Cr/8nndvOuZ4pLNmvFojeHA4PlxKpj2RS7QN1REhm4bkJKt82Q0tCi4rZBXfsRoSVnsmShdME00L3hpUMmji3Ziw2YFRghdjSNxGjrMeN1M7gv8HCrVFITDaPQuUFnSV0Wgxv0XLP/N44ZY48qbGPxDnW0wzzNRaNghI5vFrHYhqrwC67ntXqaQl2yBNpoTT1qH7hkxLlbfGJ8E9E1yy1JGKXi9uwT3J/f1NKO63rmy3ds1QCVn5ZdcSBK/hnxBuEd/1ZGqqKy5JpjA39l/i/QiJv0uuwbGzJ4cvZMU56Q==)

Click to Show Modal Dialog

## Functions and hooks [​](https://vueuse.org/core/useConfirmDialog/\#functions-and-hooks)

- `reveal()` \- triggers `onReveal` hook and sets `revealed.value` to `true`. Returns promise that resolves by `confirm()` or `cancel()`.
- `confirm()` \- sets `isRevealed.value` to `false` and triggers `onConfirm` hook.
- `cancel()` \- sets `isRevealed.value` to `false` and triggers `onCancel` hook.

## Basic Usage [​](https://vueuse.org/core/useConfirmDialog/\#basic-usage)

### Using hooks [​](https://vueuse.org/core/useConfirmDialog/\#using-hooks)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'

const {
,
,
,
,
,
,
}
  =
()
</script>

<template>
  <
@
="
">
    Reveal Modal
  </
>

  <

="body">
    <
v-if="
"
="modal-bg">
      <

="modal">
        <
>Confirm?</
>
        <
@
="
">
          Yes
        </
>
        <
@
="
">
          Cancel
        </
>
      </
>
    </
>
  </teleport>
</template>
```

### Promise [​](https://vueuse.org/core/useConfirmDialog/\#promise)

If you prefer working with promises:

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'

const {


,


,


,


,
} =
()

async function
() {
  const {
,
} = await
()
  if (!
)

.
(
)
}
</script>

<template>
  <
@
="
">
    Show Modal
  </
>

  <

="body">
    <
v-if="
"
="modal-layout">
      <

="modal">
        <
>Confirm?</
>
        <
@
="
(true)">
          Yes
        </
>
        <
@
="
(false)">
          No
        </
>
      </
>
    </
>
  </teleport>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useConfirmDialog/\#type-declarations)

Show Type Declarations

ts

```
export type
<
,
> =

  | {

?:


: false
    }
  | {

?:


: true
    }
export interface
<
,
,
> {
  /**
   * Revealing state
   */

:
<boolean>
  /**
   * Opens the dialog.
   * Create promise and return it. Triggers `onReveal` hook.
   */

: (


?:
,
  ) =>
<
<
,
>>
  /**
   * Confirms and closes the dialog. Triggers a callback inside `onConfirm` hook.
   * Resolves promise from `reveal()` with `data` and `isCanceled` ref with `false` value.
   * Can accept any data and to pass it to `onConfirm` hook.
   */

: (
?:
) => void
  /**
   * Cancels and closes the dialog. Triggers a callback inside `onCancel` hook.
   * Resolves promise from `reveal()` with `data` and `isCanceled` ref with `true` value.
   * Can accept any data and to pass it to `onCancel` hook.
   */

: (
?:
) => void
  /**
   * Event Hook to be triggered right before dialog creating.
   */

:
<
>
  /**
   * Event Hook to be called on `confirm()`.
   * Gets data object from `confirm` function.
   */

:
<
>
  /**
   * Event Hook to be called on `cancel()`.
   * Gets data object from `cancel` function.
   */

:
<
>
}
/**
 * Hooks for creating confirm dialogs. Useful for modal windows, popups and logins.
 *
 * @see https://vueuse.org/useConfirmDialog/
 * @param revealed `boolean` `ref` that handles a modal window
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
<


= any,


= any,


= any,
>(

?:
<boolean>,
):
<
,
,

>
```

## Source [​](https://vueuse.org/core/useConfirmDialog/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useConfirmDialog/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useConfirmDialog/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useConfirmDialog/index.md)
