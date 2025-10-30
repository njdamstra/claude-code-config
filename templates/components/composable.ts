import { computed, ref, watch, onUnmounted, type Ref } from 'vue'
import { useMounted, useSupported, whenever } from '@vueuse/core'

/**
 * Composable: use[ComposableName]
 *
 * Purpose: [Brief description of what this composable does]
 *
 * Usage:
 * ```typescript
 * const { state, isReady, doAction } = useComposableName({ option: 'value' })
 * ```
 *
 * @param options - Configuration options
 * @returns Reactive state and methods
 */

// ============================================================================
// Types and Interfaces
// ============================================================================

interface ComposableOptions {
  /**
   * Example option with documentation
   */
  initialValue?: string
  /**
   * Whether to automatically initialize
   */
  autoInit?: boolean
  /**
   * Callback when state changes
   */
  onStateChange?: (newState: string) => void
}

interface ComposableReturn {
  // Reactive state
  state: Ref<string>
  isLoading: Ref<boolean>
  error: Ref<Error | null>

  // Computed properties
  isReady: Ref<boolean>

  // Methods
  doAction: (input: string) => Promise<void>
  reset: () => void
}

// ============================================================================
// Main Composable
// ============================================================================

export function useComposableName(
  options: ComposableOptions = {}
): ComposableReturn {
  const {
    initialValue = '',
    autoInit = true,
    onStateChange,
  } = options

  // ============================================================================
  // State
  // ============================================================================

  const state = ref<string>(initialValue)
  const isLoading = ref(false)
  const error = ref<Error | null>(null)

  // SSR safety: Only run client-side code after mount
  const isMounted = useMounted()

  // Feature detection for browser APIs
  const isSupported = useSupported(() => {
    // Check if required browser API is available
    return typeof window !== 'undefined' && 'someAPI' in window
  })

  // ============================================================================
  // Computed Properties
  // ============================================================================

  const isReady = computed(() => {
    return isMounted.value && isSupported.value && !isLoading.value
  })

  // ============================================================================
  // Methods
  // ============================================================================

  async function doAction(input: string): Promise<void> {
    // Guard clause for SSR
    if (!isMounted.value) {
      console.warn('[useComposableName] Cannot run action during SSR')
      return
    }

    isLoading.value = true
    error.value = null

    try {
      // Your async logic here
      await new Promise(resolve => setTimeout(resolve, 1000))
      state.value = input
    } catch (err) {
      error.value = err instanceof Error ? err : new Error('Unknown error')
      console.error('[useComposableName] Action failed:', err)
    } finally {
      isLoading.value = false
    }
  }

  function reset(): void {
    state.value = initialValue
    isLoading.value = false
    error.value = null
  }

  // ============================================================================
  // Side Effects and Watchers
  // ============================================================================

  // Watch state changes and call callback
  whenever(
    () => state.value,
    (newValue) => {
      if (onStateChange) {
        onStateChange(newValue)
      }
    }
  )

  // Auto-initialize if option is enabled
  whenever(
    isReady,
    () => {
      if (autoInit) {
        // Initialization logic here
        console.log('[useComposableName] Auto-initialized')
      }
    },
    { immediate: true }
  )

  // ============================================================================
  // Cleanup
  // ============================================================================

  onUnmounted(() => {
    // Clean up subscriptions, event listeners, timers, etc.
    console.log('[useComposableName] Cleaning up')
  })

  // ============================================================================
  // Return API
  // ============================================================================

  return {
    // State
    state,
    isLoading,
    error,

    // Computed
    isReady,

    // Methods
    doAction,
    reset,
  }
}

// ============================================================================
// Additional Utility Functions (if needed)
// ============================================================================

/**
 * Helper function for composable
 * @internal
 */
function helperFunction(value: string): string {
  return value.trim().toLowerCase()
}

// ============================================================================
// Type Exports
// ============================================================================

export type { ComposableOptions, ComposableReturn }
