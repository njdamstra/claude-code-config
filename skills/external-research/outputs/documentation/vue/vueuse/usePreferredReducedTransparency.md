# usePreferredReducedTransparency

**Category**: Browser
**Export Size**: 1.22 kB
**Last Changed**: last month

Reactive prefers-reduced-transparency media query.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePreferredReducedTransparency/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtOwzAQ/ZVRlq5F2s4LFFUqVUDqgQfiJLNp1MSxI9tWqKr8O8ZJ0qYHDzPezM7MHt9lH6m61T5mG5IapqtGg3FrKxBZLLLCFEpZLaqudGqhhWtuWflVSKXzo+DQwVmrC0Q7lHCGJ0xpXk3gpsxFUdcdP49QRCKCSqakcSBVAckEFkfRYsgZ5TTj8/Qas0O+hco3wj/qU265wQrZQ38xlXCTefbPB7ItxLh51eTCcVhmcHgt0Sk/gVVAyVPbdJRQKg+LQGjhLJwpNxCZb8ki6DAaOjg7yWylJDDBcx0voL2XuslnsPax+7UMInTeTcgudP4Xe7mcI3unp97qQJjZjzGK7kLityZAh32jYpr0a8al4sfySy2QjT+A9FQ120/P2ECLu+vH33Vp4hMBcXTWYjc7Jir2hefRGwgn4qv2rQRk0kNnNCZyY5CFy8GRU3LXmdkb5cIecTX/yI4qYRcje8/xkh9IPU0PL6nQ+rsq0iS8btFa8y3596fpzfurm9tkVqT7ARogHJ)

Preferred Transparency: no-preference

## Usage

```ts
import { usePreferredReducedTransparency } from '@vueuse/core'

const preferredTransparency = usePreferredReducedTransparency()
```

## Component Usage

This function also provides a renderless component version via the @vueuse/components package. Learn more about the usage.

```vue
<template>
  <UsePreferredReducedTransparency v-slot="{ transparency }">
    Preferred Reduced transparency: {{ transparency }}
  </UsePreferredReducedTransparency>
</template>
```

## Type Declarations

```ts
export type ReducedTransparencyType = "reduce" | "no-preference"

/**
 * Reactive prefers-reduced-transparency media query.
 *
 * @see https://vueuse.org/usePreferredReducedTransparency
 * @param [options]
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function usePreferredReducedTransparency(
  options?: ConfigurableWindow,
): ComputedRef<ReducedTransparencyType>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePreferredReducedTransparency/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/usePreferredReducedTransparency/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/usePreferredReducedTransparency/index.md)

## Contributors

* SerKo
* huiliangShen

## Changelog

* **v13.6.0** on 7/28/2025
  * `d32f8` - refactor: add @__NO_SIDE_EFFECTS__ annotations to all pure functions (#4907)
* **v12.2.0-beta.1** on 12/23/2024
  * `34cd7` - feat: add new function (#4201)
