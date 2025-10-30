# Micro-Interactions & Feedback States: Modern UI Guide 2024-2025

**Research Date:** October 24, 2025
**Focus:** CSS/JavaScript micro-interactions, animations, and feedback patterns for contemporary UI design

---

## Executive Summary

Micro-interactions are the small, functional animations and visual feedback elements that confirm user actions and provide real-time guidance. In 2024-2025, best practices emphasize:

1. **Purposeful animations** - Every micro-interaction serves a function, not just decoration
2. **Immediate feedback** - Users perceive 30% faster loading with skeleton screens vs spinners
3. **Performance-first** - GPU-accelerated transforms/opacity, not width/height
4. **Accessibility-critical** - Reduced motion support, keyboard-friendly states
5. **AI-enhanced** - Predictive interactions anticipating user needs
6. **Gesture-native** - Voice, haptic, and touch feedback expanding beyond clicks

---

## 1. LOADING STATES & PERCEIVED PERFORMANCE

### 1.1 Skeleton Screens (Most Effective)

**Why:** Users perceive up to 30% faster loading vs traditional spinners

**Best Practices:**
- Use for wait times < 10 seconds
- Match actual content layout exactly
- Animate with subtle pulse (1.5-2s cycle)
- Use for container-based components (cards, lists, grids, tables)

**CSS Implementation:**

```css
/* Design system approach */
@keyframes skeleton-pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.skeleton {
  background-color: theme('colors.surface-tertiary');
  border-radius: theme('borderRadius.md');
  animation: skeleton-pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
  /* Alternative: use shimmer for more sophisticated feel */
}

/* Shimmer effect (more premium) */
@keyframes shimmer {
  0% {
    background-position: -1200px 0;
  }
  100% {
    background-position: calc(1200px + 100%) 0;
  }
}

.skeleton-shimmer {
  background: linear-gradient(
    90deg,
    theme('colors.surface-tertiary') 0%,
    theme('colors.surface-secondary') 50%,
    theme('colors.surface-tertiary') 100%
  );
  background-size: 1200px 100%;
  animation: shimmer 2s infinite;
}

/* Tailwind utility (Tailwind v4) */
@apply animate-pulse;  /* Built-in pulse animation */
```

**Vue 3 Component:**

```vue
<template>
  <div v-if="isLoading" class="space-y-4">
    <!-- Card skeleton -->
    <div class="space-y-3">
      <div class="h-12 w-3/4 rounded skeleton"></div>
      <div class="space-y-2">
        <div class="h-4 rounded skeleton"></div>
        <div class="h-4 w-5/6 rounded skeleton"></div>
      </div>
    </div>
  </div>
  <div v-else class="space-y-4">
    <!-- Actual content -->
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

const isLoading = ref(true)

onMounted(async () => {
  // Simulate API call
  await new Promise(resolve => setTimeout(resolve, 1500))
  isLoading.value = false
})
</script>
```

---

### 1.2 Spinner Variations

**When to use:** Indeterminate wait times (> 10 seconds), page-level transitions

**Circular Spinner (CSS):**

```css
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  width: 2rem;
  height: 2rem;
  border: 3px solid theme('colors.surface-tertiary');
  border-top-color: theme('colors.primary-500');
  border-radius: 50%;
  animation: spin 1s linear infinite;
  will-change: transform; /* Enable GPU acceleration */
}

/* Optimized: Use opacity + transform, not rotation */
@keyframes pulse-ring {
  0% {
    box-shadow: 0 0 0 0 theme('colors.primary-500');
  }
  70% {
    box-shadow: 0 0 0 10px rgba(0, 124, 137, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(0, 124, 137, 0);
  }
}

.spinner-pulse {
  width: 2rem;
  height: 2rem;
  border-radius: 50%;
  background: theme('colors.primary-500');
  animation: pulse-ring 2s infinite;
  will-change: box-shadow;
}
```

**Dots Spinner:**

```css
@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.spinner-dots {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.spinner-dots span {
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 50%;
  background: theme('colors.primary-500');
  animation: bounce 1.4s infinite;
  will-change: transform;
}

.spinner-dots span:nth-child(1) { animation-delay: -0.32s; }
.spinner-dots span:nth-child(2) { animation-delay: -0.16s; }
.spinner-dots span:nth-child(3) { animation-delay: 0s; }
```

---

### 1.3 Progress Indicators

**Determinate (known duration):**

```vue
<template>
  <div class="w-full bg-surface-tertiary rounded-full h-2 overflow-hidden">
    <div
      class="bg-gradient-to-r from-primary-500 to-primary-600 h-full transition-all duration-300 ease-out"
      :style="{ width: `${progress}%` }"
    ></div>
  </div>
  <p class="text-sm text-secondary mt-2">{{ progress }}%</p>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

const progress = ref(0)

onMounted(() => {
  const interval = setInterval(() => {
    progress.value = Math.min(progress.value + Math.random() * 30, 90)
  }, 500)

  // Simulate completion
  setTimeout(() => {
    progress.value = 100
    clearInterval(interval)
  }, 3000)
})
</script>
```

**Circular Progress (SVG):**

```vue
<template>
  <div class="relative inline-flex items-center justify-center">
    <svg class="w-16 h-16 -rotate-90" viewBox="0 0 100 100">
      <!-- Background circle -->
      <circle cx="50" cy="50" r="45" fill="none"
              stroke="currentColor" stroke-width="2"
              class="text-surface-tertiary" />

      <!-- Progress circle -->
      <circle cx="50" cy="50" r="45" fill="none"
              stroke="currentColor" stroke-width="2"
              class="text-primary-500 transition-all duration-500"
              :style="{
                strokeDasharray: `${283 * progress / 100} 283`,
                strokeLinecap: 'round'
              }" />
    </svg>

    <!-- Center text -->
    <div class="absolute text-center">
      <div class="text-lg font-semibold">{{ progress }}%</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const progress = ref(0)

// Circle: circumference = 2πr = 2π(45) ≈ 283
</script>
```

---

### 1.4 Loading Button States

**Best Practice:** Show spinner inside button, disable interactions

```vue
<template>
  <button
    :disabled="isLoading || isDisabled"
    :aria-busy="isLoading"
    :aria-label="isLoading ? 'Loading...' : label"
    class="px-4 py-2 rounded-md font-medium transition-all duration-200"
    :class="{
      'bg-primary-500 text-white hover:bg-primary-600 active:scale-95': !isLoading && !isDisabled,
      'bg-primary-300 text-white cursor-not-allowed opacity-60': isLoading || isDisabled,
    }"
  >
    <div class="flex items-center gap-2 justify-center min-h-6">
      <!-- Spinner (hidden when not loading) -->
      <div v-if="isLoading" class="w-4 h-4">
        <svg class="animate-spin" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10" fill="none"
                  stroke="currentColor" stroke-width="2"
                  opacity="0.25" />
          <path fill="currentColor"
                d="M4 12a8 8 0 018-8v0a8 8 0 100 16v0a8 8 0 01-8-8z" />
        </svg>
      </div>

      <!-- Text -->
      <span>{{ isLoading ? 'Loading...' : label }}</span>
    </div>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface Props {
  label: string
  isLoading?: boolean
  isDisabled?: boolean
  onClick?: () => Promise<void>
}

const props = withDefaults(defineProps<Props>(), {
  isLoading: false,
  isDisabled: false
})

const isLoading = ref(props.isLoading)
const isDisabled = ref(props.isDisabled)

const handleClick = async () => {
  if (props.onClick) {
    isLoading.value = true
    try {
      await props.onClick()
    } finally {
      isLoading.value = false
    }
  }
}
</script>
```

---

### 1.5 Optimistic UI Updates

**Pattern:** Update UI immediately, revert if API fails

```vue
<template>
  <div class="space-y-4">
    <div v-for="item in items" :key="item.id" class="flex items-center gap-3">
      <input
        type="checkbox"
        :checked="item.completed"
        @change="toggleItem(item.id)"
        class="w-4 h-4"
      />
      <span :class="{ 'line-through opacity-50': item.completed }">
        {{ item.title }}
      </span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface Item {
  id: string
  title: string
  completed: boolean
}

const items = ref<Item[]>([])

const toggleItem = async (id: string) => {
  // Find original state for rollback
  const item = items.value.find(i => i.id === id)
  if (!item) return

  const originalState = item.completed

  // Optimistic update
  item.completed = !item.completed

  try {
    // API call
    const response = await fetch(`/api/items/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ completed: item.completed })
    })

    if (!response.ok) {
      // Rollback on failure
      item.completed = originalState
    }
  } catch (error) {
    // Rollback on error
    item.completed = originalState
  }
}
</script>
```

---

## 2. SUCCESS & ERROR FEEDBACK

### 2.1 Success Animations

**Checkmark Animation:**

```css
@keyframes checkmark-draw {
  0% {
    stroke-dashoffset: 50;
  }
  100% {
    stroke-dashoffset: 0;
  }
}

@keyframes success-circle-fill {
  0% {
    fill: transparent;
    transform: scale(0);
  }
  50% {
    fill: transparent;
  }
  100% {
    fill: currentColor;
    transform: scale(1);
  }
}

.success-checkmark {
  width: 3rem;
  height: 3rem;
}

.success-checkmark circle {
  stroke: theme('colors.success-500');
  animation: success-circle-fill 0.6s ease-out forwards;
}

.success-checkmark path {
  stroke: theme('colors.success-500');
  stroke-dasharray: 50;
  stroke-dashoffset: 50;
  animation: checkmark-draw 0.6s ease-out 0.3s forwards;
}
```

**SVG Success Checkmark:**

```vue
<template>
  <div v-if="showSuccess" class="flex flex-col items-center gap-4">
    <svg class="w-16 h-16 success-checkmark" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="45" fill="none" stroke-width="2" />
      <path
        d="M 35 50 L 45 60 L 65 40"
        fill="none"
        stroke-width="4"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    <p class="text-success-600 font-medium">{{ successMessage }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const showSuccess = ref(false)
const successMessage = ref('Success!')

const triggerSuccess = (message: string = 'Success!') => {
  showSuccess.value = true
  successMessage.value = message

  setTimeout(() => {
    showSuccess.value = false
  }, 3000)
}

defineExpose({ triggerSuccess })
</script>
```

**Confetti Effect (Premium):**

```css
@keyframes confetti-fall {
  to {
    transform: translateY(100vh) rotate(360deg);
    opacity: 0;
  }
}

.confetti {
  position: fixed;
  width: 10px;
  height: 10px;
  background: theme('colors.primary-500');
  pointer-events: none;
  animation: confetti-fall 3s ease-in forwards;
}

.confetti:nth-child(odd) {
  background: theme('colors.success-500');
}
```

**JavaScript Trigger:**

```typescript
function triggerConfetti() {
  for (let i = 0; i < 50; i++) {
    const confetti = document.createElement('div')
    confetti.className = 'confetti'
    confetti.style.left = Math.random() * 100 + '%'
    confetti.style.delay = Math.random() * 0.5 + 's'
    confetti.style.transform = `rotate(${Math.random() * 360}deg)`
    document.body.appendChild(confetti)

    setTimeout(() => confetti.remove(), 3500)
  }
}
```

---

### 2.2 Error Shake Animation

```css
@keyframes shake {
  0%, 100% {
    transform: translateX(0);
  }
  10%, 30%, 50%, 70%, 90% {
    transform: translateX(-5px);
  }
  20%, 40%, 60%, 80% {
    transform: translateX(5px);
  }
}

.shake {
  animation: shake 0.5s cubic-bezier(0.36, 0.07, 0.19, 0.97);
  will-change: transform;
}

/* Subtle pulse alternative */
@keyframes error-pulse {
  0%, 100% {
    box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7);
  }
  50% {
    box-shadow: 0 0 0 6px rgba(239, 68, 68, 0);
  }
}

.error-field {
  animation: error-pulse 0.6s;
  border-color: theme('colors.error-500');
}
```

**Vue Component:**

```vue
<template>
  <div class="space-y-2">
    <input
      v-model="value"
      type="text"
      class="w-full px-3 py-2 border rounded-md transition-colors"
      :class="[
        error ? 'border-error-500 shake' : 'border-surface-tertiary',
        'focus:outline-none focus:border-primary-500'
      ]"
      @blur="validate"
    />
    <p v-if="error" class="text-sm text-error-500 flex items-center gap-1">
      <Icon icon="mdi:alert-circle" class="w-4 h-4" />
      {{ error }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Icon } from '@iconify/vue'

const value = ref('')
const error = ref('')

const validate = () => {
  if (!value.value) {
    error.value = 'This field is required'
  } else if (value.value.length < 3) {
    error.value = 'Must be at least 3 characters'
  } else {
    error.value = ''
  }
}
</script>
```

---

### 2.3 Toast/Snackbar Notifications

**CSS Foundation:**

```css
@keyframes slide-in-up {
  from {
    transform: translateY(100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

@keyframes slide-out-down {
  from {
    transform: translateY(0);
    opacity: 1;
  }
  to {
    transform: translateY(100%);
    opacity: 0;
  }
}

.toast {
  position: fixed;
  bottom: 1.5rem;
  right: 1.5rem;
  background: theme('colors.surface-secondary');
  border: 1px solid theme('colors.surface-tertiary');
  border-radius: theme('borderRadius.md');
  padding: 1rem;
  box-shadow: theme('boxShadow.lg');
  animation: slide-in-up 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  z-index: 1080; /* toast layer */
  max-width: 24rem;
}

.toast.removing {
  animation: slide-out-down 0.3s cubic-bezier(0.7, 0, 0.84, 0);
}

/* Variant classes */
.toast.success {
  border-left: 4px solid theme('colors.success-500');
}

.toast.error {
  border-left: 4px solid theme('colors.error-500');
}

.toast.warning {
  border-left: 4px solid theme('colors.warning-500');
}

/* Progress bar for auto-dismiss */
@keyframes progress-shrink {
  from {
    width: 100%;
  }
  to {
    width: 0%;
  }
}

.toast-progress {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 2px;
  background: theme('colors.primary-500');
  border-radius: 0 0 theme('borderRadius.md') 0;
  animation: progress-shrink linear;
}
```

**Vue 3 Toast Component:**

```vue
<template>
  <Teleport to="#teleport-layer">
    <Transition
      enter-active-class="transition-all duration-300"
      leave-active-class="transition-all duration-300"
      enter-from-class="opacity-0 translate-y-full"
      leave-to-class="opacity-0 translate-y-full"
    >
      <div v-if="toasts.length > 0" class="fixed bottom-6 right-6 space-y-3 z-toast">
        <div
          v-for="toast in toasts"
          :key="toast.id"
          class="flex items-start gap-3 p-4 rounded-md shadow-lg max-w-sm"
          :class="{
            'bg-success-50 border border-success-200': toast.type === 'success',
            'bg-error-50 border border-error-200': toast.type === 'error',
            'bg-warning-50 border border-warning-200': toast.type === 'warning',
            'bg-info-50 border border-info-200': toast.type === 'info',
          }"
        >
          <!-- Icon -->
          <Icon
            :icon="getIcon(toast.type)"
            class="w-5 h-5 flex-shrink-0 mt-0.5"
            :class="{
              'text-success-600': toast.type === 'success',
              'text-error-600': toast.type === 'error',
              'text-warning-600': toast.type === 'warning',
              'text-info-600': toast.type === 'info',
            }"
          />

          <!-- Content -->
          <div class="flex-1">
            <p v-if="toast.title" class="font-medium">{{ toast.title }}</p>
            <p class="text-sm text-secondary">{{ toast.message }}</p>
          </div>

          <!-- Close button -->
          <button
            @click="removeToast(toast.id)"
            class="text-secondary hover:text-primary transition-colors flex-shrink-0"
            :aria-label="`Dismiss: ${toast.message}`"
          >
            <Icon icon="mdi:close" class="w-5 h-5" />
          </button>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Icon } from '@iconify/vue'

interface Toast {
  id: string
  type: 'success' | 'error' | 'warning' | 'info'
  title?: string
  message: string
  duration?: number
}

const toasts = ref<Toast[]>([])

const addToast = (toast: Omit<Toast, 'id'>) => {
  const id = Math.random().toString(36).substr(2, 9)
  const duration = toast.duration ?? (toast.type === 'error' ? 5000 : 3000)

  toasts.value.push({ ...toast, id })

  if (duration > 0) {
    setTimeout(() => removeToast(id), duration)
  }
}

const removeToast = (id: string) => {
  toasts.value = toasts.value.filter(t => t.id !== id)
}

const getIcon = (type: string) => {
  const icons = {
    success: 'mdi:check-circle',
    error: 'mdi:alert-circle',
    warning: 'mdi:alert',
    info: 'mdi:information'
  }
  return icons[type as keyof typeof icons]
}

defineExpose({ addToast, removeToast })
</script>
```

**Global Composable:**

```typescript
// composables/useToast.ts
import { useTemplateRef } from 'vue'

export function useToast() {
  const toastRef = useTemplateRef('toast')

  return {
    success: (message: string, title?: string) =>
      toastRef.value?.addToast({ type: 'success', message, title }),

    error: (message: string, title?: string) =>
      toastRef.value?.addToast({ type: 'error', message, title }),

    warning: (message: string, title?: string) =>
      toastRef.value?.addToast({ type: 'warning', message, title }),

    info: (message: string, title?: string) =>
      toastRef.value?.addToast({ type: 'info', message, title })
  }
}
```

---

### 2.4 Inline Form Validation

**Best Practice:** Real-time validation reduces form abandonment

```vue
<template>
  <form @submit.prevent="submit" class="space-y-6">
    <!-- Email field with inline validation -->
    <div class="space-y-2">
      <label for="email" class="block text-sm font-medium">Email</label>
      <div class="relative">
        <input
          id="email"
          v-model="form.email"
          type="email"
          placeholder="you@example.com"
          @blur="validateField('email')"
          @input="validateField('email')"
          class="w-full px-3 py-2 border rounded-md transition-all duration-200"
          :class="{
            'border-error-500 bg-error-50': errors.email,
            'border-success-500 bg-success-50': validFields.email && !errors.email,
            'border-surface-tertiary focus:border-primary-500': !errors.email && !validFields.email
          }"
          aria-describedby="email-error"
        />

        <!-- Validation icons -->
        <div class="absolute right-3 top-1/2 -translate-y-1/2">
          <Icon
            v-if="validFields.email && !errors.email"
            icon="mdi:check-circle"
            class="w-5 h-5 text-success-500 animate-pop-in"
          />
          <Icon
            v-else-if="errors.email"
            icon="mdi:alert-circle"
            class="w-5 h-5 text-error-500 animate-bounce"
          />
        </div>
      </div>

      <!-- Error message with animation -->
      <Transition
        enter-active-class="transition-all duration-200"
        leave-active-class="transition-all duration-200"
        enter-from-class="opacity-0 -translate-y-2"
        leave-to-class="opacity-0 -translate-y-2"
      >
        <p
          v-if="errors.email"
          id="email-error"
          class="text-sm text-error-500 flex items-center gap-1"
        >
          {{ errors.email }}
        </p>
      </Transition>
    </div>

    <!-- Password field with requirements -->
    <div class="space-y-2">
      <label for="password" class="block text-sm font-medium">Password</label>
      <input
        id="password"
        v-model="form.password"
        type="password"
        @input="validateField('password')"
        class="w-full px-3 py-2 border rounded-md transition-colors"
        :class="errors.password ? 'border-error-500' : 'border-surface-tertiary'"
      />

      <!-- Requirements checklist -->
      <div class="space-y-2 mt-3">
        <div
          v-for="req in passwordRequirements"
          :key="req.id"
          class="flex items-center gap-2 text-sm transition-colors"
          :class="req.met ? 'text-success-600' : 'text-secondary'"
        >
          <Icon
            :icon="req.met ? 'mdi:check-circle' : 'mdi:circle-outline'"
            class="w-4 h-4"
          />
          <span>{{ req.label }}</span>
        </div>
      </div>
    </div>

    <button
      type="submit"
      :disabled="!isFormValid || isSubmitting"
      class="w-full px-4 py-2 rounded-md font-medium transition-all"
      :class="{
        'bg-primary-500 text-white hover:bg-primary-600 active:scale-95': isFormValid && !isSubmitting,
        'bg-surface-tertiary text-tertiary cursor-not-allowed opacity-50': !isFormValid || isSubmitting
      }"
    >
      {{ isSubmitting ? 'Submitting...' : 'Sign Up' }}
    </button>
  </form>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Icon } from '@iconify/vue'
import { useToast } from '@/composables/useToast'

const { success: successToast, error: errorToast } = useToast()

const form = ref({
  email: '',
  password: ''
})

const validFields = ref<Record<string, boolean>>({
  email: false,
  password: false
})

const errors = ref<Record<string, string>>({
  email: '',
  password: ''
})

const isSubmitting = ref(false)

const passwordRequirements = computed(() => [
  {
    id: 'length',
    label: 'At least 8 characters',
    met: form.value.password.length >= 8
  },
  {
    id: 'uppercase',
    label: 'One uppercase letter',
    met: /[A-Z]/.test(form.value.password)
  },
  {
    id: 'lowercase',
    label: 'One lowercase letter',
    met: /[a-z]/.test(form.value.password)
  },
  {
    id: 'number',
    label: 'One number',
    met: /\d/.test(form.value.password)
  }
])

const isFormValid = computed(
  () => Object.values(errors.value).every(e => !e) &&
        Object.values(validFields.value).every(v => v)
)

const validateField = (field: 'email' | 'password') => {
  if (field === 'email') {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!form.value.email) {
      errors.value.email = 'Email is required'
      validFields.value.email = false
    } else if (!emailRegex.test(form.value.email)) {
      errors.value.email = 'Invalid email format'
      validFields.value.email = false
    } else {
      errors.value.email = ''
      validFields.value.email = true
    }
  } else if (field === 'password') {
    const allMet = passwordRequirements.value.every(r => r.met)
    errors.value.password = allMet ? '' : 'Password does not meet requirements'
    validFields.value.password = allMet
  }
}

const submit = async () => {
  isSubmitting.value = true
  try {
    // API call
    await new Promise(resolve => setTimeout(resolve, 2000))
    successToast('Account created successfully!')
  } catch (error) {
    errorToast('Failed to create account', 'Error')
  } finally {
    isSubmitting.value = false
  }
}
</script>
```

---

## 3. BUTTON STATES & INTERACTIONS

### 3.1 Complete Button State System

```vue
<template>
  <div class="space-y-4">
    <!-- Primary button with all states -->
    <button
      :disabled="isLoading || isDisabled"
      :aria-busy="isLoading"
      class="relative px-4 py-2 rounded-md font-medium transition-all duration-200 overflow-hidden group"
      :class="getButtonClass()"
      @mouseenter="showRipple"
      @click="handleClick"
    >
      <!-- Ripple effect container -->
      <div
        v-for="ripple in ripples"
        :key="ripple.id"
        class="absolute rounded-full bg-white/30 pointer-events-none animate-ripple"
        :style="{
          width: ripple.size + 'px',
          height: ripple.size + 'px',
          left: ripple.x + 'px',
          top: ripple.y + 'px'
        }"
      ></div>

      <!-- Content -->
      <div class="relative flex items-center justify-center gap-2">
        <Icon
          v-if="icon"
          :icon="icon"
          class="w-4 h-4 transition-transform group-hover:scale-110"
        />
        <span>{{ label }}</span>
      </div>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Icon } from '@iconify/vue'

interface Props {
  label: string
  icon?: string
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost'
  size?: 'xs' | 'sm' | 'md' | 'lg'
  isLoading?: boolean
  isDisabled?: boolean
  onClick?: () => Promise<void>
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md'
})

const isLoading = ref(props.isLoading)
const isDisabled = ref(props.isDisabled)
const ripples = ref<Array<{ id: string; x: number; y: number; size: number }>>([])

const getButtonClass = () => {
  const variants = {
    primary: 'bg-primary-500 text-white hover:bg-primary-600 active:scale-95 disabled:opacity-60',
    secondary: 'bg-surface-secondary text-primary hover:bg-surface-tertiary active:scale-95',
    outline: 'border border-primary-500 text-primary-500 hover:bg-primary-50 active:scale-95',
    ghost: 'text-primary-500 hover:bg-surface-secondary active:scale-95'
  }

  const sizes = {
    xs: 'text-xs px-2 py-1',
    sm: 'text-sm px-3 py-1.5',
    md: 'text-base px-4 py-2',
    lg: 'text-lg px-6 py-3'
  }

  return `${variants[props.variant]} ${sizes[props.size]}`
}

const showRipple = (event: MouseEvent) => {
  const button = event.currentTarget as HTMLElement
  const rect = button.getBoundingClientRect()
  const x = event.clientX - rect.left
  const y = event.clientY - rect.top

  const ripple = {
    id: Math.random().toString(36).substr(2, 9),
    x,
    y,
    size: 0
  }

  ripples.value.push(ripple)

  // Animate ripple
  let size = 0
  const interval = setInterval(() => {
    size += 5
    ripple.size = size

    if (size > 100) {
      clearInterval(interval)
      ripples.value = ripples.value.filter(r => r.id !== ripple.id)
    }
  }, 16)
}

const handleClick = async () => {
  if (props.onClick) {
    isLoading.value = true
    try {
      await props.onClick()
    } finally {
      isLoading.value = false
    }
  }
}
</script>

<style scoped>
@keyframes ripple {
  to {
    transform: scale(4);
    opacity: 0;
  }
}

.animate-ripple {
  animation: ripple 600ms ease-out;
}
</style>
```

### 3.2 Focus Ring System

```css
/* Base focus ring */
.focus-ring {
  outline: none;
  box-shadow: 0 0 0 3px theme('colors.primary-500/10'),
              0 0 0 5px theme('colors.primary-500');
  transition: box-shadow 0.2s ease-out;
}

/* Variant focus rings */
.focus-ring-error {
  box-shadow: 0 0 0 3px theme('colors.error-500/10'),
              0 0 0 5px theme('colors.error-500');
}

.focus-ring-success {
  box-shadow: 0 0 0 3px theme('colors.success-500/10'),
              0 0 0 5px theme('colors.success-500');
}

/* Remove focus ring on non-keyboard interactions */
:focus:not(:focus-visible) {
  box-shadow: none;
}

/* Visible focus for accessibility */
:focus-visible {
  outline: none;
}

/* Apply universally */
button:focus-visible,
input:focus-visible,
select:focus-visible,
textarea:focus-visible,
[role="button"]:focus-visible {
  @apply focus-ring;
}
```

---

## 4. INPUT FEEDBACK & INTERACTIONS

### 4.1 Input States

```vue
<template>
  <div class="space-y-2">
    <label class="block text-sm font-medium">{{ label }}</label>
    <div class="relative">
      <input
        v-model="modelValue"
        :type="inputType"
        :disabled="disabled"
        :placeholder="placeholder"
        :aria-invalid="!!error"
        :aria-describedby="error ? `${id}-error` : undefined"
        class="w-full px-3 py-2 border rounded-md transition-all duration-200 pr-10"
        :class="[
          'focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500',
          {
            'border-error-500 bg-error-50': error,
            'border-success-500 bg-success-50': isTouched && !error && modelValue,
            'border-surface-tertiary': !error && !isTouched,
            'opacity-50 cursor-not-allowed bg-surface-secondary': disabled
          }
        ]"
        @blur="isTouched = true"
        @input="emit('update:modelValue', $event.target.value)"
      />

      <!-- State icon -->
      <div class="absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none">
        <Icon
          v-if="isTouched && !error && modelValue"
          icon="mdi:check-circle"
          class="w-5 h-5 text-success-500 animate-pop-in"
        />
        <Icon
          v-else-if="error"
          icon="mdi:alert-circle"
          class="w-5 h-5 text-error-500 animate-pulse"
        />
      </div>

      <!-- Reveal password toggle -->
      <button
        v-if="type === 'password'"
        type="button"
        class="absolute right-3 top-1/2 -translate-y-1/2 text-secondary hover:text-primary transition-colors"
        @click="togglePasswordReveal"
      >
        <Icon
          :icon="showPassword ? 'mdi:eye-off' : 'mdi:eye'"
          class="w-5 h-5"
        />
      </button>
    </div>

    <!-- Error message -->
    <Transition
      enter-active-class="transition-all duration-200"
      leave-active-class="transition-all duration-200"
      enter-from-class="opacity-0 -translate-y-1"
      leave-to-class="opacity-0 -translate-y-1"
    >
      <p
        v-if="error && isTouched"
        :id="`${id}-error`"
        class="text-sm text-error-500 flex items-center gap-1"
      >
        {{ error }}
      </p>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Icon } from '@iconify/vue'

interface Props {
  modelValue: string
  label: string
  type?: 'text' | 'email' | 'password' | 'number'
  placeholder?: string
  disabled?: boolean
  error?: string
  id?: string
}

const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  id: () => Math.random().toString(36).substr(2, 9)
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const isTouched = ref(false)
const showPassword = ref(false)

const inputType = computed(() => {
  if (props.type === 'password') {
    return showPassword.value ? 'text' : 'password'
  }
  return props.type
})

const togglePasswordReveal = () => {
  showPassword.value = !showPassword.value
}
</script>
```

### 4.2 Character Count with Animation

```vue
<template>
  <div class="space-y-2">
    <label class="block text-sm font-medium">Bio</label>
    <textarea
      v-model="value"
      maxlength="160"
      rows="4"
      class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary-500/20"
      placeholder="Tell us about yourself..."
    ></textarea>

    <!-- Character count with animation -->
    <div class="flex items-center justify-between">
      <p v-if="remaining < 20" class="text-xs text-warning-600">
        {{ remaining }} characters remaining
      </p>
      <div class="flex items-center gap-2">
        <div class="w-16 h-1 rounded-full bg-surface-tertiary overflow-hidden">
          <div
            class="h-full bg-gradient-to-r from-primary-500 to-primary-600 transition-all duration-300"
            :style="{ width: `${(value.length / 160) * 100}%` }"
          ></div>
        </div>
        <span
          class="text-xs tabular-nums font-medium transition-colors"
          :class="remaining < 20 ? 'text-warning-600' : 'text-secondary'"
        >
          {{ value.length }}/160
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const value = ref('')

const remaining = computed(() => 160 - value.value.length)
</script>
```

---

## 5. HOVER & FOCUS TRANSITIONS

### 5.1 Card Lift on Hover

```css
.card-hover-lift {
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  transform: translateY(0);
}

.card-hover-lift:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

/* With scale for extra polish */
.card-hover-scale {
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.card-hover-scale:hover {
  transform: translateY(-4px) scale(1.02);
}
```

### 5.2 Link Underline Animation

```css
@keyframes underline-grow {
  from {
    width: 0;
    left: 0;
  }
  to {
    width: 100%;
  }
}

.link-animated {
  position: relative;
  color: theme('colors.primary-500');
  text-decoration: none;
}

.link-animated::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background: theme('colors.primary-500');
  transition: width 0.3s ease-out;
}

.link-animated:hover::after {
  width: 100%;
}

/* Alternative: center-grow */
.link-animated-center::after {
  left: 50%;
  transform: translateX(-50%);
  transition: width 0.3s ease-out;
}

.link-animated-center:hover::after {
  width: 100%;
  left: 0;
  transform: translateX(0);
}
```

### 5.3 Image Zoom on Hover

```css
.image-zoom-container {
  overflow: hidden;
  border-radius: theme('borderRadius.lg');
}

.image-zoom {
  transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1);
  transform: scale(1);
}

.image-zoom-container:hover .image-zoom {
  transform: scale(1.05);
}

/* Slower zoom for gallery images */
.image-zoom-slow {
  transition: transform 0.6s ease-out;
}

.image-zoom-container:hover .image-zoom-slow {
  transform: scale(1.08);
}
```

### 5.4 Tooltip with Delay

```vue
<template>
  <div class="relative inline-block group">
    <!-- Trigger element -->
    <button class="px-4 py-2 rounded-md bg-primary-500 text-white">
      Hover me
    </button>

    <!-- Tooltip -->
    <div
      class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-1.5 rounded-md bg-surface-secondary text-sm whitespace-nowrap pointer-events-none opacity-0 transition-all duration-200 translate-y-2 group-hover:opacity-100 group-hover:translate-y-0"
      role="tooltip"
    >
      Helpful information

      <!-- Arrow -->
      <div
        class="absolute top-full left-1/2 -translate-x-1/2 w-2 h-2 bg-surface-secondary rotate-45"
      ></div>
    </div>
  </div>
</template>

<style scoped>
/* Delay tooltip appearance */
button {
  transition: none; /* No delay on trigger */
}

/* Delayed tooltip */
div[role="tooltip"] {
  transition: all 0.2s ease-out 0.5s; /* 500ms delay */
}

/* Remove delay on dismiss */
:hover div[role="tooltip"] {
  transition-delay: 0s;
}
</style>
```

---

## 6. TRANSITION PATTERNS

### 6.1 Page Transitions

```css
/* Fade transition */
@keyframes fade-enter {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes fade-exit {
  from {
    opacity: 1;
  }
  to {
    opacity: 0;
  }
}

/* Slide transition */
@keyframes slide-enter-right {
  from {
    opacity: 0;
    transform: translateX(20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* Scale transition */
@keyframes scale-enter {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}
```

**Astro SSR-Safe Implementation:**

```vue
<template>
  <Transition
    enter-active-class="transition-all duration-300"
    leave-active-class="transition-all duration-300"
    enter-from-class="opacity-0 scale-95"
    leave-to-class="opacity-0 scale-95"
  >
    <div :key="route.path" class="min-h-screen">
      <slot />
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { Transition } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
</script>
```

### 6.2 Modal Enter/Exit

```vue
<template>
  <Teleport to="#modal-layer">
    <!-- Backdrop -->
    <Transition
      enter-active-class="transition-opacity duration-300"
      leave-active-class="transition-opacity duration-300"
      enter-from-class="opacity-0"
      leave-to-class="opacity-0"
    >
      <div
        v-if="open"
        class="fixed inset-0 bg-black/50 z-modal-backdrop"
        @click="close"
      ></div>
    </Transition>

    <!-- Modal -->
    <Transition
      enter-active-class="transition-all duration-300"
      leave-active-class="transition-all duration-300"
      enter-from-class="opacity-0 scale-95"
      leave-to-class="opacity-0 scale-95"
    >
      <div
        v-if="open"
        class="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-surface-primary rounded-lg shadow-2xl z-modal max-w-md w-full mx-4"
        @click.stop
      >
        <div class="p-6">
          <h2 class="text-lg font-semibold mb-4">{{ title }}</h2>
          <slot />
          <div class="flex gap-3 mt-6">
            <button
              @click="close"
              class="flex-1 px-4 py-2 rounded-md border border-surface-tertiary hover:bg-surface-secondary transition-colors"
            >
              Cancel
            </button>
            <button
              @click="submit"
              class="flex-1 px-4 py-2 rounded-md bg-primary-500 text-white hover:bg-primary-600 transition-colors"
            >
              Confirm
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
interface Props {
  open: boolean
  title: string
  onClose: () => void
  onSubmit: () => void
}

const props = defineProps<Props>()

const close = () => props.onClose()
const submit = () => props.onSubmit()
</script>
```

### 6.3 Accordion Expand/Collapse

```vue
<template>
  <div class="space-y-2">
    <div v-for="item in items" :key="item.id" class="border rounded-md">
      <button
        @click="toggle(item.id)"
        class="w-full flex items-center justify-between p-4 hover:bg-surface-secondary transition-colors"
        :aria-expanded="expanded[item.id]"
      >
        <span class="font-medium">{{ item.title }}</span>
        <Icon
          icon="mdi:chevron-down"
          class="w-5 h-5 transition-transform"
          :style="{ transform: expanded[item.id] ? 'rotate(180deg)' : 'rotate(0)' }"
        />
      </button>

      <Transition
        enter-active-class="transition-all duration-300 overflow-hidden"
        leave-active-class="transition-all duration-300 overflow-hidden"
        enter-from-class="max-h-0 opacity-0"
        enter-to-class="max-h-screen opacity-100"
        leave-from-class="max-h-screen opacity-100"
        leave-to-class="max-h-0 opacity-0"
      >
        <div v-if="expanded[item.id]" class="px-4 pb-4 border-t">
          {{ item.content }}
        </div>
      </Transition>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Icon } from '@iconify/vue'

interface Item {
  id: string
  title: string
  content: string
}

const props = defineProps<{
  items: Item[]
}>()

const expanded = ref<Record<string, boolean>>({})

const toggle = (id: string) => {
  expanded.value[id] = !expanded.value[id]
}
</script>
```

---

## 7. MICRO-ANIMATIONS

### 7.1 Icon Bounce

```css
@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-6px);
  }
}

.icon-bounce {
  animation: bounce 1s ease-in-out;
}

/* Interactive bounce on hover */
.icon-bounce-hover {
  transition: transform 0.2s ease-out;
}

.icon-bounce-hover:hover {
  animation: bounce 0.6s ease-out;
}
```

### 7.2 Number Counting Animation

```vue
<template>
  <div class="text-3xl font-bold">
    {{ displayValue }}
    <span v-if="suffix" class="text-lg">{{ suffix }}</span>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'

interface Props {
  value: number
  duration?: number
  suffix?: string
}

const props = withDefaults(defineProps<Props>(), {
  duration: 1000
})

const displayValue = ref(0)

const animateNumber = (target: number) => {
  const start = displayValue.value
  const difference = target - start
  const steps = Math.ceil(props.duration / 16) // 60fps
  let stepIndex = 0

  const interval = setInterval(() => {
    stepIndex++
    displayValue.value = Math.round(
      start + (difference * stepIndex) / steps
    )

    if (stepIndex >= steps) {
      displayValue.value = target
      clearInterval(interval)
    }
  }, 16)
}

onMounted(() => {
  animateNumber(props.value)
})

watch(() => props.value, (newValue) => {
  animateNumber(newValue)
})
</script>
```

### 7.3 Like/Favorite Heart Animation

```vue
<template>
  <button
    @click="toggleLike"
    :aria-label="isLiked ? 'Unlike' : 'Like'"
    class="relative transition-transform"
    :class="{ 'scale-125': animating }"
  >
    <Icon
      :icon="isLiked ? 'mdi:heart' : 'mdi:heart-outline'"
      class="w-6 h-6 transition-all"
      :class="isLiked ? 'text-error-500' : 'text-secondary'"
    />

    <!-- Floating particles (optional) -->
    <div
      v-for="particle in particles"
      :key="particle.id"
      class="absolute pointer-events-none"
      :style="particleStyle(particle)"
    >
      <Icon icon="mdi:heart" class="w-2 h-2 text-error-500" />
    </div>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Icon } from '@iconify/vue'

const isLiked = ref(false)
const animating = ref(false)
const particles = ref<Array<{ id: string; x: number; y: number }>>([])

const toggleLike = () => {
  if (isLiked.value) {
    isLiked.value = false
  } else {
    isLiked.value = true
    playAnimation()
  }
}

const playAnimation = () => {
  animating.value = true

  // Create particles
  for (let i = 0; i < 5; i++) {
    particles.value.push({
      id: Math.random().toString(36).substr(2, 9),
      x: Math.random() * 40 - 20,
      y: Math.random() * 40 - 20
    })
  }

  setTimeout(() => {
    animating.value = false
  }, 200)

  // Remove particles after animation
  setTimeout(() => {
    particles.value = []
  }, 600)
}

const particleStyle = (particle: { x: number; y: number }) => ({
  left: particle.x + 'px',
  top: particle.y + 'px',
  animation: 'float-up 0.6s ease-out forwards'
})
</script>

<style scoped>
@keyframes float-up {
  to {
    transform: translateY(-30px);
    opacity: 0;
  }
}
</style>
```

---

## 8. GESTURE FEEDBACK

### 8.1 Pull-to-Refresh

```vue
<template>
  <div
    class="relative overflow-y-auto h-screen"
    @touchmove="handleTouchMove"
    @touchend="handleTouchEnd"
  >
    <!-- Refresh indicator -->
    <div
      class="absolute top-0 left-0 right-0 flex items-center justify-center h-16 transition-all"
      :style="{ transform: `translateY(${Math.min(pullDistance, 64)}px)` }"
    >
      <div
        v-if="pullDistance > 0"
        class="w-6 h-6 rounded-full border-2 border-primary-500 border-t-transparent"
        :style="{ transform: `rotate(${pullDistance * 5}deg)` }"
      ></div>
      <span v-if="pullDistance > 64" class="ml-2 text-sm font-medium">
        Release to refresh
      </span>
    </div>

    <!-- Content -->
    <div class="pt-4">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const pullDistance = ref(0)
let startY = 0
let isRefreshing = false

const emit = defineEmits<{
  refresh: []
}>()

const handleTouchMove = (event: TouchEvent) => {
  const scrollTop = (event.currentTarget as HTMLElement).scrollTop

  if (scrollTop === 0) {
    const currentY = event.touches[0].clientY
    if (startY === 0) startY = currentY

    pullDistance.value = Math.max(0, currentY - startY)
  }
}

const handleTouchEnd = () => {
  if (pullDistance.value > 64 && !isRefreshing) {
    isRefreshing = true
    emit('refresh')

    setTimeout(() => {
      pullDistance.value = 0
      startY = 0
      isRefreshing = false
    }, 1500)
  } else {
    pullDistance.value = 0
    startY = 0
  }
}
</script>
```

### 8.2 Drag & Drop Feedback

```vue
<template>
  <div class="space-y-4">
    <!-- Drop zone -->
    <div
      @dragover="dragActive = true"
      @dragleave="dragActive = false"
      @drop="handleDrop"
      class="border-2 border-dashed rounded-lg p-8 text-center transition-all"
      :class="{
        'border-primary-500 bg-primary-50': dragActive,
        'border-surface-tertiary': !dragActive
      }"
    >
      <Icon icon="mdi:cloud-upload" class="w-8 h-8 mx-auto text-secondary mb-2" />
      <p class="text-sm text-secondary">
        Drag files here or <button class="text-primary-500 hover:underline">click to browse</button>
      </p>
    </div>

    <!-- Draggable items -->
    <div class="space-y-2">
      <div
        v-for="file in files"
        :key="file.id"
        draggable
        @dragstart="startDrag(file)"
        class="flex items-center gap-3 p-3 rounded-md bg-surface-secondary cursor-move transition-all hover:shadow-md"
      >
        <Icon icon="mdi:file" class="w-5 h-5 text-secondary" />
        <span>{{ file.name }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Icon } from '@iconify/vue'

interface File {
  id: string
  name: string
}

const dragActive = ref(false)
const files = ref<File[]>([])

const startDrag = (file: File) => {
  // Handle drag start
}

const handleDrop = (event: DragEvent) => {
  event.preventDefault()
  dragActive.value = false

  const droppedFiles = event.dataTransfer?.files
  if (droppedFiles) {
    // Process files
  }
}
</script>
```

---

## 9. PERFORMANCE OPTIMIZATION

### 9.1 GPU Acceleration

**Best Practices:**

```css
/* Enable GPU acceleration with transform and opacity */
.gpu-accelerated {
  will-change: transform, opacity;
  transform: translate3d(0, 0, 0); /* Force GPU */
}

/* Use for animations */
.animate-smooth {
  animation: slide 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

@keyframes slide {
  from {
    transform: translateX(-100%);
  }
  to {
    transform: translateX(0);
  }
}

/* DON'T animate these (CPU-heavy) */
.avoid-animating {
  /* width, height, left, right, top, bottom, box-shadow, background */
}

/* Instead, use these properties (GPU-friendly) */
.gpu-friendly {
  /* transform, opacity, filter */
}
```

### 9.2 Reduced Motion Support

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Component-level reduced motion */
.animation-reduced {
  @apply prefers-reduced-motion:animate-none;
}

.transition-reduced {
  @apply prefers-reduced-motion:transition-none;
}
```

**Vue Composable:**

```typescript
// composables/useReducedMotion.ts
import { ref, onMounted } from 'vue'

export function useReducedMotion() {
  const prefersReducedMotion = ref(false)

  onMounted(() => {
    const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)')
    prefersReducedMotion.value = mediaQuery.matches

    mediaQuery.addEventListener('change', (e) => {
      prefersReducedMotion.value = e.matches
    })
  })

  return { prefersReducedMotion }
}
```

### 9.3 Battery Optimization on Mobile

```typescript
// utils/animationOptimizer.ts
export function getAnimationQuality() {
  // Detect battery level
  if ('getBattery' in navigator) {
    (navigator as any).getBattery().then((battery: any) => {
      if (battery.level < 0.2) {
        document.documentElement.classList.add('battery-saver')
      }
    })
  }

  // Detect frame rate
  let frameCount = 0
  let lastTime = performance.now()

  const check = () => {
    frameCount++
    const now = performance.now()

    if (now - lastTime >= 1000) {
      if (frameCount < 30) {
        document.documentElement.classList.add('low-fps')
      }
      frameCount = 0
      lastTime = now
    }

    requestAnimationFrame(check)
  }

  check()
}
```

**CSS for Low Battery:**

```css
.battery-saver .skeleton {
  animation: none;
}

.battery-saver .animate-spin {
  animation: none;
}

.low-fps [data-intensive-animation] {
  will-change: auto;
  animation: none;
}
```

---

## 10. TIMING & EASING

### 10.1 Duration Best Practices

| Action | Duration | Use Case |
|--------|----------|----------|
| Instant | 100ms | Quick feedback, focus rings |
| Fast | 200ms | Button hover, selections, popups |
| Normal | 300ms | Standard transitions (default) |
| Slow | 500ms | Page transitions |
| Celebration | 2000ms | Success animations |

**Design System Constants:**

```typescript
// constants/animations.ts
export const ANIMATION_DURATION = {
  INSTANT: 100,      // 0.1s - Quick feedback
  FAST: 200,         // 0.2s - Button hovers
  NORMAL: 300,       // 0.3s - Standard (default)
  SLOW: 500,         // 0.5s - Page transitions
  CELEBRATION: 2000  // 2s - Success states
} as const

export const EASING = {
  EASE_OUT: 'cubic-bezier(0.16, 1, 0.3, 1)',      // Most common
  BOUNCE: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)', // Playful
  SMOOTH: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)',   // Ultra-smooth
  SHARP: 'cubic-bezier(0.4, 0, 0.2, 1)',            // Material design
  ELASTIC: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)' // Springy
} as const

export const TIMING_PRESETS = {
  button: {
    duration: ANIMATION_DURATION.FAST,
    easing: EASING.EASE_OUT
  },
  modal: {
    duration: ANIMATION_DURATION.NORMAL,
    easing: EASING.EASE_OUT
  },
  page: {
    duration: ANIMATION_DURATION.SLOW,
    easing: EASING.EASE_OUT
  }
} as const
```

### 10.2 Easing Functions

```css
/* Common easing functions */
.ease-instant { animation-timing-function: cubic-bezier(0.16, 1, 0.3, 1); }
.ease-smooth { animation-timing-function: cubic-bezier(0.25, 0.46, 0.45, 0.94); }
.ease-bounce { animation-timing-function: cubic-bezier(0.68, -0.55, 0.265, 1.55); }
.ease-elastic { animation-timing-function: cubic-bezier(0.175, 0.885, 0.32, 1.275); }

/* Spring physics (via easing) */
.spring-tight { animation-timing-function: cubic-bezier(0.34, 1.56, 0.64, 1); }
.spring-loose { animation-timing-function: cubic-bezier(0.34, 1.2, 0.64, 1); }
```

### 10.3 Stagger Animations

```vue
<template>
  <div class="space-y-2">
    <div
      v-for="(item, index) in items"
      :key="item.id"
      class="p-3 rounded-md bg-surface-secondary animate-fade-in"
      :style="{ animationDelay: `${index * 100}ms` }"
    >
      {{ item.title }}
    </div>
  </div>
</template>

<style scoped>
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fade-in 0.3s ease-out forwards;
  opacity: 0;
}
</style>
```

---

## 11. DESIGN SYSTEM EXAMPLES

### Stripe's Approach
- Ripple effects on interactions
- Subtle shadows for depth
- Clear loading states
- Focus rings for accessibility
- Smooth 300ms transitions

### Linear's Approach
- Minimal animations (mostly opacity)
- Instant visual feedback
- GPU-accelerated transforms
- Dark/light mode support
- Reduced motion compliance

### Framer's Approach
- Complex spring animations
- Gesture-driven interactions
- Rich micro-interactions
- Customizable easing
- Premium feel

---

## 12. ANTI-PATTERNS TO AVOID

### Don'ts:
- ❌ Animate width/height (use transform: scale instead)
- ❌ Disable animations universally (use prefers-reduced-motion)
- ❌ Use inline styles for animations (use CSS classes)
- ❌ Animate without will-change on heavy elements
- ❌ Use :not(:focus-visible) without fallback
- ❌ Ignore keyboard accessibility in hover states
- ❌ Nest animations without proper cleanup
- ❌ Use animations for non-functional elements
- ❌ Forget to test on low-end devices
- ❌ Skip error state feedback

### Do's:
- ✅ Use transform/opacity for GPU acceleration
- ✅ Respect prefers-reduced-motion
- ✅ Keep animations purposeful (under 500ms)
- ✅ Provide clear visual feedback
- ✅ Test on real devices
- ✅ Use will-change judiciously
- ✅ Implement focus-visible styles
- ✅ Combine color + icon for error states
- ✅ Provide loading states for async actions
- ✅ Test with keyboard navigation

---

## 13. REFERENCES & RESOURCES

**Official Documentation:**
- [Material Design 3 - Interactions](https://m3.material.io/foundations/interaction/overview)
- [Stripe Design System](https://design.stripe.com)
- [Linear UI Patterns](https://linear.app)
- [Web.dev - Animations & Performance](https://web.dev/animations/)

**Research Dates:**
- Micro-interactions trends: 2024-2025
- Loading states & skeleton screens: 2025
- CSS animations & GPU acceleration: 2024-2025
- Button interactions & ripple effects: 2025
- Form validation UX: 2024

---

## Summary

Modern micro-interactions combine:
1. **Purposeful design** - Every animation serves UX
2. **Performance-first** - GPU acceleration, reduced motion support
3. **Accessibility** - Keyboard navigation, ARIA labels, color + icons
4. **Immediate feedback** - Skeleton screens over spinners (30% faster perception)
5. **Mobile-aware** - Battery optimization, touch feedback, gesture support

The sweet spot: **300ms animations with ease-out easing, transform/opacity only, respecting user preferences.**

