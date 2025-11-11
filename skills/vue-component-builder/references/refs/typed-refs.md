# Typed Template Refs

TypeScript support for template refs in Vue 3.

## Basic Typed Ref

```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'

const inputRef = ref<HTMLInputElement | null>(null)

onMounted(() => {
  inputRef.value?.focus() // TypeScript knows .focus() exists
})
</script>

<template>
  <input ref="inputRef" />
</template>
```

## Component Instance Types

```vue
<!-- ChildComponent.vue -->
<script setup lang="ts">
const count = ref(0)
defineExpose({ count })
</script>
```

```vue
<!-- ParentComponent.vue -->
<script setup lang="ts">
import { ref } from 'vue'
import ChildComponent from './ChildComponent.vue'

// Type based on component instance
const childRef = ref<InstanceType<typeof ChildComponent> | null>(null)

// TypeScript knows exposed properties
childRef.value?.count
</script>

<template>
  <ChildComponent ref="childRef" />
</template>
```

## Generic Component Refs

```vue
<!-- GenericList.vue -->
<script setup lang="ts" generic="T">
import { ref } from 'vue'

const listRef = ref<HTMLElement | null>(null)

defineExpose({
  scrollToTop: () => listRef.value?.scrollTo({ top: 0 })
})
</script>
```

## Ref Arrays

```vue
<script setup lang="ts">
import { ref } from 'vue'

const itemRefs = ref<(HTMLElement | null)[]>([])

function setRef(el: HTMLElement | null, index: number) {
  itemRefs.value[index] = el
}

function focusItem(index: number) {
  itemRefs.value[index]?.focus()
}
</script>

<template>
  <div
    v-for="(item, index) in items"
    :key="item.id"
    :ref="(el) => setRef(el as HTMLElement, index)"
  >
    {{ item.name }}
  </div>
</template>
```

## Dynamic Component Refs

```vue
<script setup lang="ts">
import { ref, shallowRef } from 'vue'
import ComponentA from './ComponentA.vue'
import ComponentB from './ComponentB.vue'

const currentComponent = ref('A')
const componentRef = shallowRef<InstanceType<typeof ComponentA> | InstanceType<typeof ComponentB> | null>(null)

const components = {
  A: ComponentA,
  B: ComponentB
}
</script>

<template>
  <component
    :is="components[currentComponent]"
    ref="componentRef"
  />
</template>
```

## References

- [Vue 3 Official: Template Refs](https://vuejs.org/guide/essentials/template-refs.html)

