---
name: Vue 3 Component Builder
description: Build Vue 3 components using Composition API, script setup syntax, TypeScript strict mode, and Tailwind CSS. Use when creating/modifying .vue SFCs, building form components, modals with Teleport, or integrating third-party libraries (HeadlessUI, Iconify, ECharts). CRITICAL RULES enforced: Tailwind preferred, always dark: mode classes, useMounted for SSR safety, TypeScript prop validation with withDefaults, ARIA labels for accessibility. Prevents common mistakes (missing dark mode, SSR hydration errors, inaccessible components). Use for ".vue", "component", "modal", "form", "icon", "chart".
version: 3.0.0
tags: [vue3, script-setup, composition-api, typescript, tailwind, dark-mode, ssr, accessibility, modals, forms, defineModel, headlessui, iconify]
---

# Vue 3 Component Builder

## Core Patterns (User's Projects)

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

## Common Patterns

### SSR-Safe Patterns

**Pattern 1: useMounted for Conditional Rendering**
```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core'
import { ref, watch } from 'vue'

const mounted = useMounted()
const theme = ref('light')

// CORRECT: Access browser APIs after mount
watch(mounted, (isMounted) => {
  if (isMounted) {
    // Safe to access localStorage
    theme.value = localStorage.getItem('theme') ?? 'light'
  }
})

// INCORRECT: ❌ Direct access
// const theme = localStorage.getItem('theme') // Crashes on SSR
</script>

<template>
  <!-- Pattern A: Conditional content -->
  <div v-if="mounted">
    <Icon icon="mdi:home" /> <!-- Safe: Icon only renders client-side -->
  </div>

  <!-- Pattern B: Wrap entire component -->
  <template v-if="mounted">
    <!-- All client-only content -->
  </template>
</template>
```

**Pattern 2: useSupported for Feature Detection**
```vue
<script setup lang="ts">
import { useSupported } from '@vueuse/core'

// Returns false on server, true/false on client
const isGeolocationSupported = useSupported(() => 'geolocation' in navigator)
const isWebGLSupported = useSupported(() => 'WebGLRenderingContext' in window)
</script>

<template>
  <div v-if="isGeolocationSupported">
    <!-- Show map component -->
  </div>
  <div v-else>
    Geolocation not supported
  </div>
</template>
```

**Pattern 3: SSR-Safe Initialization**
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'

const data = ref<string | null>(null)

// CORRECT: Initialize in onMounted
onMounted(() => {
  data.value = localStorage.getItem('key')
})

// INCORRECT: ❌ Direct initialization
// const data = ref(localStorage.getItem('key')) // Crashes on SSR
</script>
```

### Form Validation Pattern

For form validation, use Zod schemas in API routes and composables (not in component props). Components handle UI validation:

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'

// Form state
const email = defineModel<string>('email', { default: '' })
const password = defineModel<string>('password', { default: '' })

// Validation errors
const emailError = ref<string | null>(null)
const passwordError = ref<string | null>(null)

// Custom validation functions
function validateEmail(): boolean {
  if (!email.value) {
    emailError.value = 'Email is required'
    return false
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
    emailError.value = 'Invalid email address'
    return false
  }
  emailError.value = null
  return true
}

function validatePassword(): boolean {
  if (!password.value) {
    passwordError.value = 'Password is required'
    return false
  }
  if (password.value.length < 8) {
    passwordError.value = 'Password must be at least 8 characters'
    return false
  }
  passwordError.value = null
  return true
}

const isValid = computed(() => {
  return email.value && password.value && !emailError.value && !passwordError.value
})

async function handleSubmit() {
  const emailValid = validateEmail()
  const passwordValid = validatePassword()

  if (emailValid && passwordValid) {
    // Submit to API (Zod validation happens on server)
    await submitForm({ email: email.value, password: password.value })
  }
}
</script>

<template>
  <form @submit.prevent="handleSubmit" class="space-y-4">
    <div>
      <label
        for="email"
        class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
      >
        Email
      </label>
      <input
        id="email"
        v-model="email"
        type="email"
        @blur="validateEmail"
        class="w-full px-4 py-2 border rounded-lg dark:bg-gray-800 dark:border-gray-600 dark:text-white"
        :class="{
          'border-red-500 dark:border-red-400': emailError,
          'border-gray-300 dark:border-gray-600': !emailError
        }"
        aria-required="true"
        :aria-invalid="!!emailError"
        :aria-describedby="emailError ? 'email-error' : undefined"
      />
      <p
        v-if="emailError"
        id="email-error"
        class="text-red-500 dark:text-red-400 text-sm mt-1"
        role="alert"
      >
        {{ emailError }}
      </p>
    </div>

    <button
      type="submit"
      :disabled="!isValid"
      class="w-full px-4 py-2 bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600 text-white rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
      aria-label="Submit form"
    >
      Submit
    </button>
  </form>
</template>
```

**Note:** Zod validation belongs in API routes and composables for runtime data validation, not component props.

### Modal Pattern
```vue
<script setup lang="ts">
import { onClickOutside, onKeyStroke } from '@vueuse/core'
import { ref } from 'vue'

const props = defineProps<{
  modelValue: boolean
  title?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
}>()

const modalRef = ref<HTMLElement>()

// Close on click outside
onClickOutside(modalRef, () => {
  emit('update:modelValue', false)
})

// Close on escape key
onKeyStroke('Escape', () => {
  emit('update:modelValue', false)
})

function close() {
  emit('update:modelValue', false)
}
</script>

<template>
  <Teleport to="#teleport-layer" :disabled="!mounted">
    <Transition
      enter-active-class="transition-opacity duration-200"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity duration-200"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="modelValue"
        class="fixed inset-0 bg-black/50 dark:bg-black/70 flex items-center justify-center z-50 p-4"
        @click.self="close"
        role="dialog"
        aria-modal="true"
        :aria-labelledby="title ? 'modal-title' : undefined"
      >
        <div
          ref="modalRef"
          class="bg-white dark:bg-gray-800 rounded-lg shadow-2xl max-w-md w-full p-6"
        >
          <!-- Header -->
          <div v-if="title" class="flex items-center justify-between mb-4">
            <h2
              id="modal-title"
              class="text-xl font-bold text-gray-900 dark:text-gray-100"
            >
              {{ title }}
            </h2>
            <button
              @click="close"
              class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
              aria-label="Close modal"
            >
              ✕
            </button>
          </div>

          <!-- Content slot -->
          <div class="text-gray-700 dark:text-gray-300">
            <slot />
          </div>

          <!-- Footer slot -->
          <div v-if="$slots.footer" class="mt-6 pt-4 border-t border-gray-200 dark:border-gray-700">
            <slot name="footer" :close="close" />
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>
```

### Nanostores Integration
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $user, userStore } from '@/stores/user'
import { computed } from 'vue'

// Use store (reactive)
const user = useStore($user)

// Computed based on store
const displayName = computed(() => {
  return user.value?.name ?? 'Guest'
})

// Store methods
async function updateProfile(name: string) {
  if (user.value?.$id) {
    await userStore.updateProfile(user.value.$id, { name })
  }
}
</script>

<template>
  <div v-if="user" class="p-4 bg-white dark:bg-gray-800 rounded-lg">
    <p class="text-gray-900 dark:text-gray-100">
      Welcome, {{ displayName }}
    </p>
    <button
      @click="updateProfile('New Name')"
      class="mt-2 px-4 py-2 bg-blue-600 dark:bg-blue-500 text-white rounded-lg"
    >
      Update Profile
    </button>
  </div>
</template>
```

## Third-Party Library Integration

This codebase heavily relies on several third-party libraries. **ALWAYS use these patterns** when integrating them.

### Iconify (@iconify/vue) - 256+ Components Use This

**Standard Icon Pattern:**
```vue
<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { useMounted } from '@vueuse/core'

const mounted = useMounted()
</script>

<template>
  <!-- ALWAYS wrap icons in useMounted for SSR safety -->
  <template v-if="mounted">
    <Icon icon="mdi:home" class="w-6 h-6 text-blue-600 dark:text-blue-400" />
    <Icon icon="mdi:close" class="w-4 h-4" />
    <Icon icon="heroicons:user-circle-20-solid" />
  </template>
</template>
```

**Icon Collections Used:**
- `mdi:*` - Material Design Icons (most common)
- `heroicons:*` - Heroicons
- `lucide:*` - Lucide icons
- `ri:*` - Remix Icon

**Why useMounted Required:** Icon component uses browser APIs that crash during SSR.

---

### HeadlessUI (@headlessui/vue) - 11+ Components

**Accessible Modal Pattern:**
```vue
<script setup lang="ts">
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'

const open = defineModel<boolean>('open', { required: true })
</script>

<template>
  <TransitionRoot :show="open" as="template">
    <Dialog @close="open = false" class="relative z-50">
      <!-- Backdrop -->
      <TransitionChild
        as="template"
        enter="duration-300 ease-out"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="duration-200 ease-in"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-black/50 dark:bg-black/70" />
      </TransitionChild>

      <!-- Modal Panel -->
      <div class="fixed inset-0 flex items-center justify-center p-4">
        <TransitionChild
          as="template"
          enter="duration-300 ease-out"
          enter-from="opacity-0 scale-95"
          enter-to="opacity-100 scale-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100 scale-100"
          leave-to="opacity-0 scale-95"
        >
          <DialogPanel class="max-w-md w-full bg-white dark:bg-gray-800 rounded-lg p-6 shadow-xl">
            <DialogTitle class="text-xl font-bold text-gray-900 dark:text-gray-100 mb-4">
              Modal Title
            </DialogTitle>

            <div class="text-gray-700 dark:text-gray-300">
              <!-- Modal content -->
            </div>

            <div class="mt-6 flex justify-end space-x-3">
              <button
                @click="open = false"
                class="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg"
              >
                Cancel
              </button>
              <button
                class="px-4 py-2 bg-blue-600 dark:bg-blue-500 text-white rounded-lg"
              >
                Confirm
              </button>
            </div>
          </DialogPanel>
        </TransitionChild>
      </div>
    </Dialog>
  </TransitionRoot>
</template>
```

**Why HeadlessUI:**
- Accessible by default (ARIA attributes built-in)
- Keyboard navigation handled automatically
- Focus management included
- Screen reader compatible
- Unstyled (use Tailwind for styling)

---

### Floating UI (@floating-ui/vue) - 14+ Components

**Dropdown/Popover Positioning:**
```vue
<script setup lang="ts">
import { useFloating, offset, flip, shift } from '@floating-ui/vue'
import { ref } from 'vue'

const referenceRef = ref<HTMLElement>()
const floatingRef = ref<HTMLElement>()

const { floatingStyles } = useFloating(referenceRef, floatingRef, {
  placement: 'bottom-start',
  middleware: [
    offset(8), // 8px offset from trigger
    flip(), // Flip if not enough space
    shift({ padding: 8 }) // Shift to stay in viewport
  ]
})

const isOpen = ref(false)
</script>

<template>
  <div>
    <!-- Trigger -->
    <button
      ref="referenceRef"
      @click="isOpen = !isOpen"
      class="px-4 py-2 bg-blue-600 text-white rounded-lg"
    >
      Toggle Dropdown
    </button>

    <!-- Floating Content -->
    <div
      v-if="isOpen"
      ref="floatingRef"
      :style="floatingStyles"
      class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg shadow-lg p-2 z-50"
    >
      <!-- Dropdown items -->
      <button class="w-full text-left px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
        Option 1
      </button>
      <button class="w-full text-left px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
        Option 2
      </button>
    </div>
  </div>
</template>
```

**Common Middleware:**
- `offset(px)` - Space between trigger and floating element
- `flip()` - Flip to opposite side if no space
- `shift()` - Move horizontally to stay in viewport
- `arrow()` - Position arrow element
- `autoUpdate()` - Update position on scroll/resize

---

### ECharts (vue-echarts) - 15+ Chart Components

**Base Chart Pattern:**
```vue
<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useMounted, useWindowSize } from '@vueuse/core'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'

// Register ECharts components (tree-shakeable)
use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

const props = defineProps<{
  data: { x: string; y: number }[]
  title?: string
}>()

const mounted = useMounted()
const { width } = useWindowSize()
const chartRef = ref<InstanceType<typeof VChart>>()

// ECharts option object
const option = computed(() => ({
  title: {
    text: props.title,
    textStyle: {
      color: '#374151', // Update based on theme
    }
  },
  tooltip: {
    trigger: 'axis'
  },
  xAxis: {
    type: 'category',
    data: props.data.map(d => d.x)
  },
  yAxis: {
    type: 'value'
  },
  series: [{
    type: 'line',
    data: props.data.map(d => d.y),
    smooth: true
  }]
}))

// Resize chart on window resize
watch(width, () => {
  chartRef.value?.resize()
})

onMounted(() => {
  // Initial resize after mount
  setTimeout(() => chartRef.value?.resize(), 100)
})
</script>

<template>
  <div v-if="mounted" class="w-full h-full">
    <VChart
      ref="chartRef"
      :option="option"
      :autoresize="true"
      class="w-full h-full"
    />
  </div>
</template>
```

**Why ECharts:**
- Tree-shakeable (import only what you use)
- Responsive with `useWindowSize()` hook
- Dark mode support via theme configuration
- 15+ chart types (Line, Bar, Pie, etc.)

---

### When to Use Each Library

| Library | Use Case | SSR Safety |
|---------|----------|------------|
| **Iconify** | All icons in UI | ⚠️ Requires `useMounted()` |
| **HeadlessUI** | Modals, popovers, dropdowns, tabs | ✅ SSR-safe |
| **Floating UI** | Advanced positioning (tooltips, dropdowns) | ⚠️ Requires `useMounted()` |
| **ECharts** | Data visualization and charts | ⚠️ Requires `useMounted()` |
| **VueUse** | Composable utilities | ✅ Most are SSR-safe |

**Critical Rule:** Always check if a library needs `useMounted()` for SSR safety. If it accesses `window`, `document`, or `navigator`, wrap it.

## File Naming & Organization

### File Names
- **PascalCase** for component files: `UserProfile.vue`, `LoginForm.vue`
- **Descriptive names**: Component name should indicate purpose

### Directory Structure
```
src/components/vue/
├── ui/                  # Reusable UI primitives (buttons, inputs, cards)
│   ├── Button.vue
│   ├── Input.vue
│   ├── Card.vue
│   └── Modal.vue
├── forms/               # Form-specific components
│   ├── LoginForm.vue
│   ├── SignupForm.vue
│   └── FormInput.vue
├── layout/              # Layout components
│   ├── Header.vue
│   ├── Footer.vue
│   └── Sidebar.vue
└── [domain]/            # Domain-specific components
    ├── auth/            # Auth-related
    ├── profile/         # Profile-related
    └── messaging/       # Messaging-related
```

## Dark Mode Best Practices

### Color Patterns
```
Background colors:
- Light: bg-white, bg-gray-50, bg-gray-100
- Dark:  dark:bg-gray-800, dark:bg-gray-900, dark:bg-black

Text colors:
- Light: text-gray-900, text-gray-800, text-gray-700
- Dark:  dark:text-gray-100, dark:text-gray-200, dark:text-gray-300

Border colors:
- Light: border-gray-200, border-gray-300
- Dark:  dark:border-gray-700, dark:border-gray-600

Hover states:
- Light: hover:bg-gray-100
- Dark:  dark:hover:bg-gray-700
```

### Always Pair Light + Dark
```vue
<!-- CORRECT: Both light and dark -->
<div class="bg-white dark:bg-gray-800">
  <p class="text-gray-900 dark:text-gray-100">Text</p>
</div>

<!-- INCORRECT: Only light ❌ -->
<div class="bg-white">
  <p class="text-gray-900">Text</p>
</div>
```

## Accessibility Checklist

- [ ] All interactive elements have ARIA labels
- [ ] Form inputs have associated labels
- [ ] Errors have role="alert"
- [ ] Modals have role="dialog" and aria-modal="true"
- [ ] Buttons have descriptive aria-label
- [ ] Keyboard navigation works (Tab, Enter, Escape)
- [ ] Focus visible on interactive elements
- [ ] Color contrast meets WCAG AA standards

## Before Creating Component

1. **Search for existing components** (use codebase-researcher skill)
2. **Check for similar patterns** in other components
3. **Identify reusable parts** (can you compose existing components?)
4. **Plan component API** (props, emits, slots)
5. **Consider SSR** (will this render on server?)

## Component Checklist

- [ ] TypeScript `<script setup lang="ts">`
- [ ] Props with `withDefaults(defineProps<{}>(), {})` pattern
- [ ] v-model with `defineModel()` (if applicable)
- [ ] `useMounted()` for client-only code (icons, browser APIs)
- [ ] Tailwind classes preferred (scoped styles only for transitions)
- [ ] Dark mode classes (`dark:`) on ALL colors
- [ ] Proper TypeScript types with no `any`
- [ ] ARIA labels on interactive elements
- [ ] `defineEmits<{}>()` properly typed
- [ ] Error handling present
- [ ] Responsive design (mobile-first with Tailwind breakpoints)
- [ ] Third-party libraries integrated correctly (HeadlessUI, Iconify, etc.)
- [ ] Existing components checked for reuse potential

## Cross-References

For related patterns, see these skills:
- **astro-vue-architect** - Astro + Vue integration architecture, when to use .astro vs Vue, client directive optimization, data flow patterns, appEntrypoint setup, View Transitions
- **vue-composable-builder** - Vue composable patterns and VueUse integration
- **nanostore-builder** - State management with Nanostores
- **soc-appwrite-integration** - Appwrite SDK usage for data operations

## Further Reading

See supporting files for detailed patterns:
- [ssr-patterns.md] - Complete SSR safety guide
- [form-patterns.md] - Advanced form handling
- [modal-patterns.md] - Modal best practices
- [tailwind-dark-mode.md] - Dark mode patterns
- [third-party-libraries.md] - HeadlessUI, Iconify, Floating UI, ECharts
