<script setup lang="ts">
import { computed, ref } from 'vue'
import { useMounted } from '@vueuse/core'

// Component name: [ComponentName]
// Purpose: [Brief description of what this component does]

/**
 * Props interface with proper TypeScript validation
 */
interface Props {
  /**
   * Example prop with documentation
   */
  title?: string
  /**
   * Example required prop
   */
  userId: string
  /**
   * Example optional prop with default
   */
  size?: 'small' | 'medium' | 'large'
}

const props = withDefaults(defineProps<Props>(), {
  title: 'Default Title',
  size: 'medium',
})

/**
 * Emits interface for type-safe events
 */
interface Emits {
  (e: 'update', value: string): void
  (e: 'close'): void
}

const emit = defineEmits<Emits>()

// SSR safety: Only run client-side code after mount
const isMounted = useMounted()

// Local state
const isLoading = ref(false)
const error = ref<string | null>(null)

// Computed properties
const sizeClasses = computed(() => {
  switch (props.size) {
    case 'small':
      return 'px-2 py-1 text-sm'
    case 'large':
      return 'px-6 py-3 text-lg'
    default:
      return 'px-4 py-2 text-base'
  }
})

// Methods
async function handleAction() {
  isLoading.value = true
  error.value = null

  try {
    // Your logic here
    emit('update', 'new value')
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Unknown error'
  } finally {
    isLoading.value = false
  }
}

function handleClose() {
  emit('close')
}
</script>

<template>
  <div
    class="component-wrapper rounded-lg bg-white p-4 shadow-md dark:bg-gray-800"
    role="region"
    :aria-label="props.title"
  >
    <!-- Header -->
    <div class="mb-4 flex items-center justify-between">
      <h2 class="text-xl font-semibold text-gray-900 dark:text-gray-100">
        {{ props.title }}
      </h2>
      <button
        type="button"
        class="rounded-full p-2 hover:bg-gray-100 dark:hover:bg-gray-700"
        aria-label="Close"
        @click="handleClose"
      >
        <span class="sr-only">Close</span>
        <svg
          class="h-5 w-5 text-gray-500 dark:text-gray-400"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M6 18L18 6M6 6l12 12"
          />
        </svg>
      </button>
    </div>

    <!-- Content -->
    <div class="space-y-4">
      <!-- Loading state -->
      <div
        v-if="isLoading"
        class="flex items-center justify-center py-8"
        role="status"
        aria-live="polite"
      >
        <div
          class="h-8 w-8 animate-spin rounded-full border-4 border-gray-300 border-t-blue-600 dark:border-gray-600 dark:border-t-blue-400"
        />
        <span class="sr-only">Loading...</span>
      </div>

      <!-- Error state -->
      <div
        v-else-if="error"
        class="rounded-md bg-red-50 p-4 dark:bg-red-900/20"
        role="alert"
        aria-live="assertive"
      >
        <div class="flex">
          <svg
            class="h-5 w-5 text-red-400"
            fill="currentColor"
            viewBox="0 0 20 20"
            aria-hidden="true"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
              clip-rule="evenodd"
            />
          </svg>
          <div class="ml-3">
            <p class="text-sm text-red-800 dark:text-red-200">
              {{ error }}
            </p>
          </div>
        </div>
      </div>

      <!-- Main content -->
      <div v-else class="text-gray-700 dark:text-gray-300">
        <slot>
          <!-- Default slot content -->
          <p>Component content goes here</p>
        </slot>
      </div>

      <!-- Action button -->
      <button
        type="button"
        :class="sizeClasses"
        class="w-full rounded-lg bg-blue-600 font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 dark:bg-blue-500 dark:hover:bg-blue-600 dark:focus:ring-offset-gray-800"
        :disabled="isLoading"
        aria-label="Perform action"
        @click="handleAction"
      >
        <span v-if="isLoading">Processing...</span>
        <span v-else>Action Button</span>
      </button>
    </div>

    <!-- Footer slot -->
    <div v-if="$slots.footer" class="mt-4 border-t border-gray-200 pt-4 dark:border-gray-700">
      <slot name="footer" />
    </div>
  </div>
</template>

<style scoped>
/*
 * IMPORTANT: Avoid scoped styles when possible
 * Use Tailwind utility classes instead
 * Only use scoped styles for complex animations or truly unique cases
 */

/* Example animation that can't be done with Tailwind alone */
@keyframes custom-fade {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.component-wrapper {
  animation: custom-fade 0.3s ease-out;
}
</style>
