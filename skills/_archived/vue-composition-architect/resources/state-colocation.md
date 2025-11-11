# State Colocation Principle

### Core Philosophy

**"Colocate state as close as possible to where it's used"**

```
Is the state used by multiple unrelated components?
├─ YES → Use Nanostore (global shared state)
└─ NO
   └─ Is the state reusable logic shared by related components?
      ├─ YES → Use composable (isolated state per instance)
      └─ NO
         └─ Is the state used by a component subtree?
            ├─ YES → Use provide/inject
            └─ NO → Keep as local component state (ref/reactive)
```

### Anti-Pattern: State Too High

```vue
<!-- ❌ BAD: State in App.vue but only ProductList uses it -->
<template>
  <AppLayout>
    <ProductList :filters="filters" />
    <OtherSection /> <!-- Doesn't need filters -->
  </AppLayout>
</template>

<script setup>
// State too high in tree
const filters = ref<Filters>({ category: 'all', price: null })
</script>
```

### Pattern: State Colocated

```vue
<!-- ✅ GOOD: State colocated in feature wrapper -->
<template>
  <div class="products-section">
    <ProductFilters v-model:filters="filters" />
    <ProductList :filters="filters" />
  </div>
</template>

<script setup>
// State lives where it's used
const filters = ref<Filters>({ category: 'all', price: null })
</script>
```
