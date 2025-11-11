# Examples

### Example 1: Generic Data Table

```vue
<script setup lang="ts" generic="T extends Record<string, any>">
interface Props {
  data: T[]
  columns: Array<keyof T>
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'row-click', row: T): void
}>()
</script>

<template>
  <table>
    <thead>
      <tr>
        <th v-for="col in columns" :key="String(col)">
          {{ col }}
        </th>
      </tr>
    </thead>
    <tbody>
      <tr
        v-for="(row, idx) in data"
        :key="idx"
        @click="emit('row-click', row)"
      >
        <td v-for="col in columns" :key="String(col)">
          {{ row[col] }}
        </td>
      </tr>
    </tbody>
  </table>
</template>

<!-- Usage -->
<script setup lang="ts">
interface User {
  id: number
  name: string
  email: string
}

const users: User[] = [/* ... */]

// TypeScript knows row is User
function handleRowClick(row: User) {
  console.log(row.name)
}
</script>

<template>
  <DataTable
    :data="users"
    :columns="['name', 'email']"
    @row-click="handleRowClick"
  />
</template>
```

### Example 2: Alert with Discriminated Variants

```vue
<script setup lang="ts" generic="T">
type BaseProps = {
  title: string
  closable?: boolean
}

type SuccessProps = BaseProps & {
  type: 'success'
  message: string
  icon?: string
  // Exclude error props
  errorCode?: never
  retryAction?: never
}

type ErrorProps = BaseProps & {
  type: 'error'
  errorCode: string
  retryAction?: () => void
  // Exclude success props
  message?: never
  icon?: never
}

type Props = SuccessProps | ErrorProps

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'close'): void
}>()

const bgClass = props.type === 'success' ? 'bg-green-100' : 'bg-red-100'
</script>

<template>
  <div :class="['alert', bgClass]">
    <h3>{{ title }}</h3>

    <p v-if="'message' in props">
      <Icon v-if="icon" :name="icon" />
      {{ message }}
    </p>

    <div v-if="'errorCode' in props">
      <p>Error Code: {{ errorCode }}</p>
      <button v-if="retryAction" @click="retryAction">
        Retry
      </button>
    </div>

    <button v-if="closable" @click="emit('close')">
      Close
    </button>
  </div>
</template>

<!-- Usage -->
<template>
  <!-- ✅ Success variant -->
  <Alert
    type="success"
    title="Success!"
    message="Operation completed"
    icon="check"
  />

  <!-- ✅ Error variant -->
  <Alert
    type="error"
    title="Error"
    error-code="ERR_500"
    :retry-action="handleRetry"
  />

  <!-- ❌ TYPE ERROR: Can't mix variants -->
  <Alert
    type="success"
    message="Success"
    error-code="ERR_500"
  />
</template>
```

### Example 3: Generic Select Component

```vue
<script setup lang="ts" generic="T extends { id: string | number, label: string }">
interface Props {
  options: T[]
  modelValue: T | null
  placeholder?: string
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'update:modelValue', value: T): void
}>()
</script>

<template>
  <select
    :value="modelValue?.id"
    @change="(e) => {
      const selected = options.find(opt => opt.id == e.target.value)
      if (selected) emit('update:modelValue', selected)
    }"
  >
    <option value="" disabled>{{ placeholder || 'Select...' }}</option>
    <option
      v-for="option in options"
      :key="option.id"
      :value="option.id"
    >
      {{ option.label }}
    </option>
  </select>
</template>

<!-- Usage -->
<script setup lang="ts">
interface Country {
  id: number
  label: string
  code: string
}

const countries: Country[] = [
  { id: 1, label: 'USA', code: 'US' },
  { id: 2, label: 'Canada', code: 'CA' }
]

const selected = ref<Country | null>(null)

// TypeScript knows value is Country
watch(selected, (value) => {
  if (value) {
    console.log(value.code) // ✅ Type-safe access to code
  }
})
</script>

<template>
  <Select v-model="selected" :options="countries" />
</template>
```
