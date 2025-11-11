# Error Handling

### Standard Error Handling Pattern

```typescript
export function useDataFetcher<T>(url: string) {
  const data = ref<T | null>(null)
  const isLoading = ref(false)
  const error = ref<Error | null>(null)

  async function fetch() {
    isLoading.value = true
    error.value = null
    try {
      const response = await window.fetch(url)
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`)
      }
      data.value = await response.json()
    } catch (err) {
      error.value = err instanceof Error ? err : new Error('Unknown error')
      console.error('Fetch error:', err)
    } finally {
      isLoading.value = false
    }
  }

  return {
    data: readonly(data),
    isLoading: readonly(isLoading),
    error: readonly(error),
    fetch,
    retry: fetch // Alias for retry
  }
}
```
