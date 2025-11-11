# Scoped Slots

Scoped slots allow child components to pass data back to parent components.

## Basic Scoped Slot

```vue
<!-- DataList.vue -->
<script setup lang="ts">
interface Item {
  id: number
  name: string
}

const items = ref<Item[]>([
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' }
])
</script>

<template>
  <ul>
    <li v-for="item in items" :key="item.id">
      <!-- Pass item data to parent -->
      <slot :item="item" :index="items.indexOf(item)" />
    </li>
  </ul>
</template>
```

```vue
<!-- ParentComponent.vue -->
<template>
  <DataList>
    <!-- Access item and index from child -->
    <template #default="{ item, index }">
      <div>
        {{ index + 1 }}. {{ item.name }}
      </div>
    </template>
  </DataList>
</template>
```

## Named Scoped Slots

```vue
<!-- Card.vue -->
<script setup lang="ts">
const user = ref({
  name: 'John',
  email: 'john@example.com'
})
</script>

<template>
  <div class="card">
    <header>
      <slot name="header" :user="user" />
    </header>
    <main>
      <slot :user="user" />
    </main>
    <footer>
      <slot name="footer" :user="user" />
    </footer>
  </div>
</template>
```

```vue
<!-- ParentComponent.vue -->
<template>
  <Card>
    <template #header="{ user }">
      <h2>{{ user.name }}</h2>
    </template>
    
    <template #default="{ user }">
      <p>{{ user.email }}</p>
    </template>
    
    <template #footer="{ user }">
      <button>Contact {{ user.name }}</button>
    </template>
  </Card>
</template>
```

## Typed Slot Props

```vue
<!-- DataTable.vue -->
<script setup lang="ts">
interface Row {
  id: number
  name: string
  status: string
}

const rows = ref<Row[]>([])

// Define slot props type
defineSlots<{
  default(props: { row: Row; index: number }): any
  header?(): any
  empty?(): any
}>()
</script>

<template>
  <table>
    <thead>
      <slot name="header" />
    </thead>
    <tbody>
      <template v-if="rows.length">
        <tr v-for="(row, index) in rows" :key="row.id">
          <slot :row="row" :index="index" />
        </tr>
      </template>
      <tr v-else>
        <slot name="empty" />
      </tr>
    </tbody>
  </table>
</template>
```

## Fallback Content

```vue
<!-- UserCard.vue -->
<script setup lang="ts">
const user = ref<User | null>(null)
</script>

<template>
  <div class="card">
    <slot :user="user">
      <!-- Fallback if no slot content provided -->
      <p>No user data</p>
    </slot>
  </div>
</template>
```

## Conditional Slot Rendering

```vue
<!-- ConditionalList.vue -->
<script setup lang="ts">
const items = ref<Item[]>([])
const isLoading = ref(false)
</script>

<template>
  <div>
    <slot v-if="isLoading" name="loading" />
    <slot v-else-if="items.length === 0" name="empty" />
    <slot v-else :items="items" />
  </div>
</template>
```

## References

- [Vue 3 Official: Slots](https://vuejs.org/guide/components/slots.html)

