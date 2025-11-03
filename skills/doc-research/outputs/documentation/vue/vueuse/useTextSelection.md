# useTextSelection

**Category**: Sensors
**Export Size**: 837 B
**Last Changed**: 2 weeks ago

Reactively track user text selection based on `Window.getSelection`.

## Usage

`useTextSelection` provides a reactive state that updates whenever the user selects or deselects text on the page.

```vue
<script setup lang="ts">
import { useTextSelection } from '@vueuse/core'

const state = useTextSelection()
</script>

<template>
  <div>
    <p>Select any text on this page.</p>
    <p v-if="state.text">
      Selected text: <strong>{{ state.text }}</strong>
    </p>
  </div>
</template>
```

## Reactive State

The `useTextSelection` function returns a reactive object with the following properties:

- `text`: A `ref` containing the selected text content as a string.
- `rects`: A `ref` containing an array of `DOMRect` objects representing the bounding rectangles of the selection.
- `ranges`: A `ref` containing an array of `Range` objects.
- `selection`: A `ref` to the raw `Selection` object.

## Component Usage

This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UseTextSelection v-slot="{ text }">
    Selected: {{ text }}
  </UseTextSelection>
</template>
```

## Type Declarations

```ts
export interface UseTextSelectionState {
  text: Ref<string>
  rects: Ref<DOMRect[]>
  ranges: Ref<Range[]>
  selection: Ref<Selection | null>
}

/**
 * Reactively track user text selection based on `Window.getSelection`.
 *
 * @see https://vueuse.org/useTextSelection
 * @param target The target element to track text selection. Defaults to `document`.
 * @param options
 */
export declare function useTextSelection(
  target?: MaybeRefOrGetter<HTMLElement | Document | undefined>,
  options?: ConfigurableWindow,
): UseTextSelectionState
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextSelection/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useTextSelection/index.md)
