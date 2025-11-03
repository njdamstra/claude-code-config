# useOnline

**Category:** Sensors
**Export Size:** 979 B
**Last Changed:** 2 months ago

Reactive online state. A wrapper of [`useNetwork`](https://vueuse.org/core/useNetwork/).

## Demo

Disconnect your network to see changes

Status: **Online**

## Usage

```ts
import { useOnline } from '@vueuse/core'

const online = useOnline()
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseOnline v-slot="{ isOnline }">
    Is Online: {{ isOnline }}
  </UseOnline>
</template>
```

## Type Declarations

```ts
/**
 * Reactive online state.
 *
 * @see https://vueuse.org/useOnline
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useOnline(
  options?: ConfigurableWindow,
): Readonly<Ref<boolean>>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useOnline/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useOnline/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useOnline/index.md)
