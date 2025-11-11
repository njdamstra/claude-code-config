# Dynamic Slots

Use dynamic slot names for flexible component composition.

## Dynamic Slot Names

```vue
<!-- Layout.vue -->
<script setup lang="ts">
const sections = ['header', 'main', 'footer']
</script>

<template>
  <div>
    <component
      v-for="section in sections"
      :key="section"
      :is="`slot-${section}`"
    >
      <slot :name="section" />
    </component>
  </div>
</template>
```

## Conditional Slot Names

```vue
<!-- TabPanel.vue -->
<script setup lang="ts">
const activeTab = ref('tab1')
</script>

<template>
  <div>
    <slot :name="`tab-${activeTab}`" />
  </div>
</template>
```

## Slot Name Binding

```vue
<!-- ParentComponent.vue -->
<script setup lang="ts">
const slotName = ref('default')
</script>

<template>
  <ChildComponent>
    <template #[slotName]>
      Dynamic slot content
    </template>
  </ChildComponent>
</template>
```

## References

- [Vue 3 Official: Dynamic Slot Names](https://vuejs.org/guide/components/slots.html#dynamic-slot-names)

