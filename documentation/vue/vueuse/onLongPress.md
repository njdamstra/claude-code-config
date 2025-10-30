# onLongPress

**Category:** Sensors
**Export Size:** 1.04 kB

Listen for a long press on an element.

Function provides modifiers in options:
- stop
- once
- prevent
- capture
- self

## Usage

```vue
<script setup lang="ts">
import { onLongPress } from '@vueuse/core'
import { shallowRef, useTemplateRef } from 'vue'

const htmlRefHook = useTemplateRef<HTMLElement>('htmlRefHook')
const longPressedHook = shallowRef(false)

function onLongPressCallbackHook(e: PointerEvent) {
  longPressedHook.value = true
}
function resetHook() {
  longPressedHook.value = false
}

onLongPress(
  htmlRefHook,
  onLongPressCallbackHook,
  {
    modifiers: {
      prevent: true
    }
  }
)
</script>

<template>
  <p>Long Pressed: {{ longPressedHook }}</p>

  <button ref="htmlRefHook" class="ml-2 button small">
    Press long
  </button>

  <button class="ml-2 button small" @click="resetHook">
    Reset
  </button>
</template>
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<script setup lang="ts">
import { OnLongPress } from '@vueuse/components'
import { shallowRef } from 'vue'

const longPressedComponent = shallowRef(false)

function onLongPressCallbackComponent(e: PointerEvent) {
  longPressedComponent.value = true
}
function resetComponent() {
  longPressedComponent.value = false
}
</script>

<template>
  <p>Long Pressed: {{ longPressedComponent }}</p>

  <OnLongPress
    as="button"
    class="ml-2 button small"
    @trigger="onLongPressCallbackComponent"
  >
    Press long
  </OnLongPress>

  <button class="ml-2 button small" @click="resetComponent">
    Reset
  </button>
</template>
```

## Directive Usage

> This function also provides a directive version via the `@vueuse/components` package.

```vue
<script setup lang="ts">
import { vOnLongPress } from '@vueuse/components'
import { shallowRef } from 'vue'

const longPressedDirective = shallowRef(false)

function onLongPressCallbackDirective(e: PointerEvent) {
  longPressedDirective.value = true
}
function resetDirective() {
  longPressedDirective.value = false
}
</script>

<template>
  <p>Long Pressed: {{ longPressedDirective }}</p>

  <button
    v-on-long-press="onLongPressCallbackDirective"
    class="ml-2 button small"
  >
    Press long
  </button>

  <button
    v-on-long-press="[onLongPressCallbackDirective, { delay: 1000 }]"
    class="ml-2 button small"
  >
    Press long (with options)
  </button>

  <button class="ml-2 button small" @click="resetDirective">
    Reset
  </button>
</template>
```

## Type Declarations

```ts
export interface OnLongPressOptions {
  /**
   * Time in ms till `longpress` gets called
   *
   * @default 500
   */
  delay?: number | ((evt: PointerEvent) => number)
  modifiers?: OnLongPressModifiers
  /**
   * Allowance of moving distance in pixels,
   * The action will get canceled When moving too far from the pointerdown position.
   * @default 10
   */
  distanceThreshold?: number | false
  /**
   * Function called when the ref element is released.
   * @param duration how long the element was pressed in ms
   * @param distance distance from the pointerdown position
   * @param isLongPress whether the action was a long press or not
   */
  onMouseUp?: (duration: number, distance: number, isLongPress: boolean) => void
}

export interface OnLongPressModifiers {
  stop?: boolean
  once?: boolean
  prevent?: boolean
  capture?: boolean
  self?: boolean
}

export declare function onLongPress(
  target: MaybeRefOrGetter<any>,
  handler: (evt: PointerEvent) => void,
  options?: OnLongPressOptions,
): () => void

export type OnLongPressReturn = ReturnType<typeof onLongPress>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/onLongPress/index.ts)
- [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/onLongPress/demo.vue)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/onLongPress/index.md)
