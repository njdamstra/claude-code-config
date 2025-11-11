# Form Validation Pattern

For form validation, use Zod schemas in API routes and composables (not in component props). Components handle UI validation:

## Zod Validation Pattern

```vue
<script setup lang="ts">
import { z } from 'zod'
import { ref } from 'vue'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

type FormData = z.infer<typeof schema>

const form = ref<FormData>({ email: '', password: '' })
const errors = ref<Record<string, string[]>>({})

function validate() {
  const result = schema.safeParse(form.value)
  if (!result.success) {
    errors.value = result.error.flatten().fieldErrors
    return false
  }
  errors.value = {}
  return true
}
</script>
```

## Form Input Component

Reusable input with error display, dark mode, and accessibility.

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