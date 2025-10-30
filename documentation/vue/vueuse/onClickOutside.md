# onClickOutside

Category: Sensors

Export Size: 1.27 kB

Listen for clicks outside of an element. Useful for modal or dropdown.

## Usage

```vue
<script setup lang="ts">
import { onClickOutside } from '@vueuse/core'
import { ref } from 'vue'

const target = ref<HTMLElement>('target')

onClickOutside(target, event => console.log(event))
</script>

<template>
  <div ref="target">
    Hello world
  </div>
  <div>Outside element</div>
</template>
```

If you need more control over triggering the handler, you can use the `controls` option.

```ts
const { trigger, cancel } = onClickOutside(
  modalRef,
  (event) => {
    modal.value = false
  },
  { controls: true },
)

useEventListener('pointermove', (event) => {
  trigger()
  // or
  trigger(event)
})
```

If you want to ignore certain elements, you can use the `ignore` option. Provide the elements to ignore as an array of Refs or CSS Selectors.

```ts
const ignoreElRef = useTemplateRef('ignoreEl')
const ignoreElSelector = '.ignore-el'

onClickOutside(
  target,
  event => console.log(event),
  { ignore: [ignoreElRef, ignoreElSelector] },
)
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <OnClickOutside :options="{ ignore: [/* ... */] }" @trigger="count++">
    <div>
      Click Outside of Me
    </div>
  </OnClickOutside>
</template>
```

## Directive Usage

> This function also provides a directive version via the `@vueuse/components` package.

```vue
<script setup lang="ts">
import { vOnClickOutside } from '@vueuse/components'
import { ref } from 'vue'

const modal = ref(false)
function closeModal() {
  modal.value = false
}
</script>

<template>
  <button @click="modal = true">
    Open Modal
  </button>
  <div v-if="modal" v-on-click-outside="closeModal">
    Hello World
  </div>
</template>
```
