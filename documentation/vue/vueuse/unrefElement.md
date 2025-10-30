# unrefElement

**Category**: Component
**Export Size**: 102 B
**Last Changed**: 7 months ago

Retrieves the underlying DOM element from a Vue ref or component instance

## Usage

```vue
<script setup lang="ts">
import { unrefElement } from '@vueuse/core'
import { onMounted, useTemplateRef } from 'vue'

const div = useTemplateRef<HTMLElement>('div') // will be bound to the <div> element
const hello = useTemplateRef<Component>('hello') // will be bound to the HelloWorld Component

onMounted(() => {
  console.log(unrefElement(div)) // the <div> element
  console.log(unrefElement(hello)) // the root element of the HelloWorld Component
})
</script>

<template>
  <div ref="div" />
  <HelloWorld ref="hello" />
</template>
```

## Type Declarations

```ts
export type VueInstance = ComponentPublicInstance
export type MaybeElementRef < T extends MaybeElement = MaybeElement > = MaybeRef < T >
export type MaybeComputedElementRef < T extends MaybeElement = MaybeElement > = MaybeRefOrGetter < T >
export type MaybeElement = | HTMLElement | SVGElement | VueInstance | undefined | null
export type UnRefElementReturn < T extends MaybeElement = MaybeElement > = T extends VueInstance ? Exclude < MaybeElement , VueInstance > : T | undefined

/**
 * Get the dom element of a ref of element or Vue component instance
 *
 * @param elRef
 */
export declare function unrefElement < T extends MaybeElement >( elRef : MaybeComputedElementRef < T >, ): UnRefElementReturn < T >
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/unrefElement/index.ts) • [Docs](https://vueuse.org/core/unrefElement/)

## Contributors

* Anthony Fu
* IlyaL
* Anthony Fu
* SerKo
* Henrik Kampshoff
* Nebula
* Julian Meinking
* Jelf

## Changelog

* **v12.8.0** on 3/5/2025: `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.3.0** on 1/2/2025: `59f75` - feat(toValue): deprecate toValue from @vueuse/shared in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024: `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
