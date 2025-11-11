# Instructions

### Step 1: Identify Use Case

**Use Generics When:**
- ✅ Data-driven components (lists, tables, selects)
- ✅ Reusable event-emitting components
- ✅ Type-safe wrapper components
- ✅ Need to preserve type through props → emits → handlers

**Use Discriminated Unions When:**
- ✅ Components with mutually exclusive states (success/error)
- ✅ Variant-based styling (primary/secondary/danger)
- ✅ Form components with different validation rules
- ✅ Prevent invalid prop combinations at compile time

### Step 2: Write Type Definitions

**For Generics:**

```vue
<script setup lang="ts" generic="T extends ConstraintType">
// Use T in props, emits, computed, etc.
</script>
```

**For Discriminated Unions:**

```typescript
// 1. Define base props
type BaseProps = { /* shared props */ }

// 2. Define each variant with never for excluded props
type VariantA = BaseProps & {
  variantProp: 'a'
  propA: string
  propB?: never  // Exclude propB
}

type VariantB = BaseProps & {
  variantProp: 'b'
  propB: number
  propA?: never  // Exclude propA
}

// 3. Union the variants
type Props = VariantA | VariantB
```

### Step 3: Handle Template Runtime Checks

Discriminated unions require runtime checks in templates:

```vue
<template>
  <!-- Use 'in' operator for runtime checks -->
  <div v-if="'message' in props">{{ message }}</div>
  <div v-if="'errorCode' in props">{{ errorCode }}</div>
</template>
```

### Step 4: Test Type Safety

```typescript
// Test that invalid combinations fail at compile time
<Component
  variant="success"
  message="Valid"
  error-code="Invalid" // ❌ Should show type error
/>
```

### Step 5: Document Variants

```typescript
/**
 * Notification Component
 *
 * @example
 * // Success variant
 * <Notification variant="primary" message="Success" :duration="3000" />
 *
 * @example
 * // Error variant
 * <Notification variant="danger" error-code="ERR_401" :retryable="true" />
 */
```
