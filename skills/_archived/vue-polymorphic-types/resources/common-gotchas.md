# Common Gotchas

### Gotcha 1: Union-Typed Emits Break Handlers

**Problem:** Component emits `A | B`, handler expects only `A`

```vue
<!-- ❌ TYPE ERROR -->
<Component @event="handleA" />

<script setup>
// Handler only accepts A
function handleA(payload: A) { /* ... */ }
</script>
```

**Solution:** Use generic component

```vue
<script setup lang="ts" generic="T">
defineEmits<{ (e: 'event', data: T): void }>()
</script>
```

### Gotcha 2: XOR Utility Types Fail `vue-tsc`

**Problem:** Complex utility types don't work with `vue-tsc`

```typescript
// ❌ Fails vue-tsc
type XOR<T, U> = (T & { [K in keyof U]?: never }) | (U & { [K in keyof T]?: never })
type Props = XOR<A, B>
```

**Solution:** Use manual `never` annotations

```typescript
// ✅ Works with vue-tsc
type A = { propA: string; propB?: never }
type B = { propB: number; propA?: never }
type Props = A | B
```

### Gotcha 3: Generic Ref Forwarding Without Constraint

**Problem:** Template refs lose type information

```vue
<script setup lang="ts" generic="T">
const elementRef = ref<T | null>(null)

onMounted(() => {
  elementRef.value?.focus() // ❌ Error: T might not have focus()
})
</script>
```

**Solution:** Add `extends HTMLElement` constraint

```vue
<script setup lang="ts" generic="T extends HTMLElement">
const elementRef = ref<T | null>(null)

onMounted(() => {
  elementRef.value?.focus() // ✅ Works: T extends HTMLElement
})
</script>
```

### Gotcha 4: Forgetting `generic="T"` with Discriminated Unions

**Problem:** Discriminated unions don't work without generic

```vue
<!-- ❌ May fail type checking -->
<script setup lang="ts">
type Props = VariantA | VariantB
defineProps<Props>()
</script>
```

**Solution:** Add `generic="T"` (even if not using T)

```vue
<!-- ✅ Works with vue-tsc -->
<script setup lang="ts" generic="T">
type Props = VariantA | VariantB
defineProps<Props>()
</script>
```
