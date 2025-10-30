# onStartTyping

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 825 B

Last Changed: 7 months ago

Fires when users start typing on non-editable elements.

## Demo

Type anything

## Usage

```vue
<script setup lang="ts">
import { onStartTyping } from '@vueuse/core'
import { ref } from 'vue'

const input = ref('input')

onStartTyping(() => {
  if (!input.value.active)
    input.value.focus()
})
</script>

<template>
  <input
    ref="input"
    type="text"
    placeholder="Start typing to focus">
</template>
```

## Type Declarations

```ts
/**
 * Fires when users start typing on non-editable elements.
 *
 * @see https://vueuse.org/onStartTyping
 * @param callback
 * @param options
 */
export declare function onStartTyping(
  callback: (event: KeyboardEvent) => void,
  options?: ConfigurableDocument,
): void
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/onStartTyping/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/onStartTyping/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/onStartTyping/index.md)

## Contributors

- Anthony Fu
- SerKo
- Bernard Borg
- meenie-net
- 丶远方
- Alex Kozack
- Nurettin Kaya
- Antério Vieira
- Seifeldin Mahjoub

## Changelog

### v12.8.0 on 3/5/2025

`58a3b` - fix: Incorrect accepted valid characters (#4616)

### v10.7.0 on 12/4/2023

`fccf2` - feat: upgrade deps (#3614)
