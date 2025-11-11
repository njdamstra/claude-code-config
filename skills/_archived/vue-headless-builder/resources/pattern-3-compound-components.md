# Pattern 3: Compound Components with Context

Multiple components coordinated through shared context:

### Root Component (Provider)

```vue
<!-- AccordionRoot.vue -->
<script setup lang="ts">
import { provide, ref, readonly, type InjectionKey } from 'vue'

interface AccordionContext {
  type: 'single' | 'multiple'
  openItems: Ref<Set<string>>
  toggle: (value: string) => void
}

const AccordionKey = Symbol() as InjectionKey<AccordionContext>

const props = defineProps<{
  type: 'single' | 'multiple'
  collapsible?: boolean
}>()

const openItems = ref<Set<string>>(new Set())

function toggle(value: string) {
  if (props.type === 'single') {
    openItems.value = new Set([value])
  } else {
    const newSet = new Set(openItems.value)
    if (newSet.has(value)) {
      newSet.delete(value)
    } else {
      newSet.add(value)
    }
    openItems.value = newSet
  }
}

provide(AccordionKey, {
  type: props.type,
  openItems: readonly(openItems),
  toggle
})
</script>

<template>
  <div>
    <slot />
  </div>
</template>
```

### Item Component (Consumer)

```vue
<!-- AccordionItem.vue -->
<script setup lang="ts">
import { provide, computed, inject, type InjectionKey } from 'vue'
import { AccordionKey } from './AccordionRoot.vue'

interface ItemContext {
  value: string
  isOpen: Ref<boolean>
}

const ItemKey = Symbol() as InjectionKey<ItemContext>

const props = defineProps<{
  value: string
}>()

const rootContext = inject(AccordionKey)
if (!rootContext) {
  throw new Error('AccordionItem must be used within AccordionRoot')
}

const isOpen = computed(() => rootContext.openItems.value.has(props.value))

provide(ItemKey, {
  value: props.value,
  isOpen
})
</script>

<template>
  <div :data-state="isOpen ? 'open' : 'closed'">
    <slot />
  </div>
</template>
```

### Trigger Component

```vue
<!-- AccordionTrigger.vue -->
<script setup lang="ts">
import { inject } from 'vue'
import { AccordionKey } from './AccordionRoot.vue'
import { ItemKey } from './AccordionItem.vue'

const rootContext = inject(AccordionKey)
const itemContext = inject(ItemKey)

function handleClick() {
  rootContext.toggle(itemContext.value)
}
</script>

<template>
  <button
    type="button"
    :aria-expanded="itemContext.isOpen"
    @click="handleClick"
  >
    <slot />
  </button>
</template>
```
