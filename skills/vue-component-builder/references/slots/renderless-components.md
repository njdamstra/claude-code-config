# Renderless Components

Components that provide logic without prescribing UI.

## Basic Renderless Component

```vue
<!-- MouseTracker.vue -->
<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const x = ref(0)
const y = ref(0)

function updatePosition(e: MouseEvent) {
  x.value = e.clientX
  y.value = e.clientY
}

onMounted(() => {
  window.addEventListener('mousemove', updatePosition)
})

onUnmounted(() => {
  window.removeEventListener('mousemove', updatePosition)
})

defineSlots<{
  default(props: { x: number; y: number }): any
}>()
</script>

<template>
  <slot :x="x" :y="y" />
</template>
```

```vue
<!-- Usage -->
<template>
  <MouseTracker>
    <template #default="{ x, y }">
      <p>Mouse position: {{ x }}, {{ y }}</p>
    </template>
  </MouseTracker>
</template>
```

## Data Fetching Renderless Component

```vue
<!-- FetchData.vue -->
<script setup lang="ts">
import { ref, onMounted } from 'vue'

const props = defineProps<{
  url: string
}>()

const data = ref<any>(null)
const loading = ref(true)
const error = ref<Error | null>(null)

onMounted(async () => {
  try {
    const response = await fetch(props.url)
    data.value = await response.json()
  } catch (e) {
    error.value = e as Error
  } finally {
    loading.value = false
  }
})

defineSlots<{
  default(props: { data: any; loading: boolean; error: Error | null }): any
  loading?(): any
  error?(props: { error: Error }): any
}>()
</script>

<template>
  <slot v-if="loading" name="loading" />
  <slot v-else-if="error" name="error" :error="error" />
  <slot v-else :data="data" :loading="loading" :error="error" />
</template>
```

## Form Validation Renderless Component

```vue
<!-- FormValidator.vue -->
<script setup lang="ts">
import { ref, computed } from 'vue'
import { z } from 'zod'

const props = defineProps<{
  schema: z.ZodSchema
}>()

const formData = ref<Record<string, any>>({})
const errors = ref<Record<string, string>>({})

const isValid = computed(() => {
  const result = props.schema.safeParse(formData.value)
  if (!result.success) {
    errors.value = result.error.flatten().fieldErrors as Record<string, string>
    return false
  }
  errors.value = {}
  return true
})

function validate() {
  return isValid.value
}

defineExpose({
  validate,
  formData,
  errors,
  isValid
})

defineSlots<{
  default(props: {
    formData: Ref<Record<string, any>>
    errors: Ref<Record<string, string>>
    isValid: ComputedRef<boolean>
    validate: () => boolean
  }): any
}>()
</script>

<template>
  <slot
    :form-data="formData"
    :errors="errors"
    :is-valid="isValid"
    :validate="validate"
  />
</template>
```

## References

- [Vue 3 Official: Renderless Components](https://vuejs.org/guide/components/slots.html#renderless-components)

