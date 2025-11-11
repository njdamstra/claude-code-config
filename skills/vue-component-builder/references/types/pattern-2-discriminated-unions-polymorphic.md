# Pattern 2: Discriminated Unions with `never`

### Variant Props Pattern

Create mutually exclusive prop combinations:

```vue
<script setup lang="ts" generic="T">
// Base props shared across variants
type BaseProps = {
  title: string
}

// Success variant - explicitly marks error props as never
type SuccessProps = BaseProps & {
  variant: 'primary' | 'secondary'
  message: string
  duration: number
  // Prevent error props
  errorCode?: never
  retryable?: never
}

// Error variant - explicitly marks success props as never
type ErrorProps = BaseProps & {
  variant: 'danger' | 'warning'
  errorCode: string
  retryable: boolean
  // Prevent success props
  message?: never
  duration?: never
}

// Final union type - only one variant allowed
type Props = SuccessProps | ErrorProps

const props = defineProps<Props>()
</script>

<template>
  <div :class="['notification', `variant-${variant}`]">
    <h2>{{ title }}</h2>

    <!-- Runtime checks still needed in template -->
    <p v-if="'message' in props">{{ message }}</p>
    <p v-if="'errorCode' in props">Error: {{ errorCode }}</p>

    <button v-if="'retryable' in props && retryable">
      Retry
    </button>
  </div>
</template>
```

**Compile-Time Safety:**

```vue
<template>
  <!-- ✅ VALID -->
  <Notification
    variant="primary"
    title="Success"
    message="Operation completed"
    :duration="3000"
  />

  <!-- ✅ VALID -->
  <Notification
    variant="danger"
    title="Error"
    error-code="ERR_401"
    :retryable="true"
  />

  <!-- ❌ TYPE ERROR: Can't mix success + error props -->
  <Notification
    variant="primary"
    title="Mixed"
    message="Success message"
    error-code="ERR_500"
  />
</template>
```

### Why `generic="T"` is Required

Due to current `defineComponent` limitation, discriminated unions need `generic="T"` to bypass the limitation:

```vue
<script setup lang="ts" generic="T">
// ✅ Works with vue-tsc

type Props = SuccessProps | ErrorProps
defineProps<Props>()
</script>
```

Without `generic="T"`, `vue-tsc` may fail to properly validate discriminated unions.

### Why Manual `never` (Not XOR Utility)

```typescript
// ❌ DOESN'T WORK with vue-tsc
type Without<T, U> = { [P in Exclude<keyof T, keyof U>]?: never }
type XOR<T, U> = T | U extends object
  ? (Without<T, U> & U) | (Without<U, T> & T)
  : T | U

type Props = XOR<SuccessProps, ErrorProps> // vue-tsc error!
```

```typescript
// ✅ WORKS with vue-tsc
type SuccessProps = {
  variant: 'success'
  message: string
  errorCode?: never  // Manual exclusion
  retryable?: never  // Manual exclusion
}

type ErrorProps = {
  variant: 'error'
  errorCode: string
  retryable: boolean
  message?: never    // Manual exclusion
  duration?: never   // Manual exclusion
}

type Props = SuccessProps | ErrorProps // ✅ Works!
```
