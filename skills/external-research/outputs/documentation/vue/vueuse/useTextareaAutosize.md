# useTextareaAutosize

Category: Browser

Export Size: 922 B

Last Changed: 6 months ago

Automatically update the height of a textarea depending on the content.

## Usage

### Simple example

```vue
<script setup lang="ts">
import { useTextareaAutosize } from '@vueuse/core'

const { textarea, input } = useTextareaAutosize()
</script>

<template>
  <textarea
    ref="textarea"
    v-model="input"
    class="resize-none"
    placeholder="What's on your mind?"
  />
</template>
```

**INFO**: It's recommended to reset the scrollbar styles for the textarea element to avoid incorrect height values for large amounts of text.

```css
textarea {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

textarea::-webkit-scrollbar {
  display: none;
}
```

### With `rows` attribute

If you need support for the rows attribute on a textarea element, then you should set the `styleProp` option to `minHeight`.

```vue
<script setup lang="ts">
import { useTextareaAutosize } from '@vueuse/core'

const { textarea, input } = useTextareaAutosize({
  styleProp: 'minHeight'
})
</script>

<template>
  <textarea
    ref="textarea"
    v-model="input"
    class="resize-none"
    placeholder="What's on your mind?"
    rows="3"
  />
</template>
```

## Type Declarations

```ts
export interface UseTextareaAutosizeOptions extends ConfigurableWindow {
  /** Textarea element to autosize. */
  element?: MaybeRefOrGetter<HTMLTextAreaElement | undefined | null>
  /** Textarea content. */
  input?: MaybeRefOrGetter<string>
  /** Watch sources that should trigger a textarea resize. */
  watch?: WatchSource | WatchSource<any>[]
  /** Function called when the textarea size changes. */
  onResize?: () => void
  /** Specify style target to apply the height based on textarea content. If not provided it will use textarea it self. */
  styleTarget?: MaybeRefOrGetter<HTMLElement | undefined>
  /** Specify the style property that will be used to manipulate height. Can be `height | minHeight`. Default value is `height`. */
  styleProp?: "height" | "minHeight"
}

export declare function useTextareaAutosize(
  options?: UseTextareaAutosizeOptions,
): {
  textarea: Ref<HTMLTextAreaElement | null | undefined, HTMLTextAreaElement | null | undefined>
  input: Ref<string, string>
  triggerResize: () => void
}

export type UseTextareaAutosizeReturn = ReturnType<typeof useTextareaAutosize>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextareaAutosize/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextareaAutosize/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextareaAutosize/index.md)

## Changelog

### v12.8.0 on 3/5/2025
- feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native (#4636)

### v12.7.0 on 2/15/2025
- fix: improve resize handling with requestAnimationFrame (#4557)

### v12.3.0 on 1/2/2025
- feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

### v12.1.0 on 12/22/2024
- fix: make input required (#4129)

### v12.0.0-beta.1 on 11/21/2024
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v11.0.0-beta.2 on 7/17/2024
- fix: improve `triggerResize` triggering (#4074)

### v10.10.0 on 5/27/2024
- fix: onResize callback fires not only on resize (#3887)

### v10.8.0 on 2/20/2024
- feat: allow configuring `styleProp` to support native `rows` attribute (#3552)

### v10.2.0 on 6/16/2023
- fix: autosize error when changing `input` asynchronously (#3118)
