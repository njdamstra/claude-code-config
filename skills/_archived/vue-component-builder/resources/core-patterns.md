# Core Patterns

### CRITICAL RULES (NEVER BREAK)
1. ⚠️ **PREFER** Tailwind CSS classes (scoped styles ONLY for transitions/animations)
2. ❌ **NEVER** use inline styles
3. ✅ **ALWAYS** include `dark:` prefix for all color classes
4. ✅ **ALWAYS** use `useMounted()` for client-only code (SSR safety)
5. ✅ **ALWAYS** use TypeScript with `withDefaults()` for props
6. ✅ **ALWAYS** use `defineModel()` for v-model bindings (Vue 3.4+)
7. ✅ **ALWAYS** add ARIA labels to interactive elements
8. ✅ **ALWAYS** check for existing components before creating new ones

### Tech Stack
- **Vue 3.4+** Composition API with `<script setup lang="ts">`
- **TypeScript** Strict mode with interface-based props
- **Tailwind CSS** Primary styling method (utilities only)
- **VueUse** For common utilities (useMounted, onClickOutside, etc.)
- **HeadlessUI** For accessible components (Dialog, Popover, etc.)
- **Iconify** For all icons (`@iconify/vue`)
- **Floating UI** For popovers/tooltips (`@floating-ui/vue`)
- **ECharts** For charts (`vue-echarts`)

## Base Component Template

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'
import { useMounted } from '@vueuse/core'

// Props with TypeScript interface (STANDARD PATTERN)
const props = withDefaults(
  defineProps<{
    title: string
    variant?: 'primary' | 'secondary'
    disabled?: boolean
  }>(),
  {
    variant: 'primary',
    disabled: false
  }
)

// Emits (typed)
const emit = defineEmits<{
  (e: 'click'): void
  (e: 'change', value: string): void
}>()

// SSR-safe mounting
const mounted = useMounted()

// Reactive state
const isActive = ref(false)

// Computed properties
const buttonClasses = computed(() => {
  const base = 'px-4 py-2 rounded-lg transition-colors font-medium'
  const variants = {
    primary: 'bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600',
    secondary: 'bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600'
  }
  const disabled = props.disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'
  return `${base} ${variants[props.variant]} ${disabled}`
})

// Methods
function handleClick() {
  if (!props.disabled) {
    emit('click')
  }
}
</script>

<template>
  <div v-if="mounted">
    <button
      :class="buttonClasses"
      class="text-white dark:text-gray-100"
      @click="handleClick"
      :disabled="props.disabled"
      role="button"
      :aria-label="props.title"
      :aria-disabled="props.disabled"
    >
      {{ props.title }}
    </button>
  </div>
</template>
```

### Modern v-model Pattern (Vue 3.4+)

Use `defineModel()` for reactive two-way binding:

```vue
<script setup lang="ts">
import { computed } from 'vue'

// Simple v-model
const modelValue = defineModel<string>({ default: '' })

// Named v-model with required
const open = defineModel<boolean>('open', { required: true })

// Multiple v-models
const search = defineModel<string>('search', { default: '' })
const selected = defineModel<string[]>('selected', { default: () => [] })

// Computed wrapper for transformation
const lowercaseValue = computed({
  get: () => modelValue.value.toLowerCase(),
  set: (val) => { modelValue.value = val }
})
</script>

<template>
  <!-- Direct usage (no .value needed in templates) -->
  <input v-model="modelValue" />

  <!-- Or use computed wrapper -->
  <input v-model="lowercaseValue" />
</template>
```

**Why defineModel():**
- Simpler than `props + emit('update:modelValue')`
- Auto-generates proper TypeScript types
- Standard in Vue 3.4+ (modern pattern)
- Used in 100+ components in this codebase
