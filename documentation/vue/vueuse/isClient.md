# isClient

**Category:** Utilities (Internal Constant)
**Location:** `@vueuse/shared/utils`

A boolean constant that checks if the code is running in a browser environment (client-side).

## Definition

```ts
export const isClient = typeof window !== 'undefined' && typeof document !== 'undefined'
```

## Usage

```ts
import { isClient } from '@vueuse/core'

if (isClient) {
  // Safe to use window, document, and other browser APIs
  console.log('Running in browser')
  document.title = 'My App'
} else {
  // Running in SSR/Node environment
  console.log('Running on server')
}
```

## Use Cases

- **SSR Safety**: Check if browser APIs are available before using them
- **Conditional Imports**: Load browser-only modules conditionally
- **Environment Detection**: Determine execution context at runtime

## Example with Astro SSR

```ts
import { isClient } from '@vueuse/core'

// Safe for SSR
const title = isClient ? document.title : 'Default Title'

// Conditional API calls
if (isClient) {
  window.localStorage.setItem('key', 'value')
}
```

## Related

- **isWorker**: Check if running in a Web Worker context
- **isDef**: Check if a value is defined
- For server-side detection, use `!isClient` or check `typeof window === 'undefined'`

## Notes

- This is a **constant**, not a function - use it without calling `()`
- Evaluated once at module load time
- Part of VueUse's internal utilities, exported from main package
- Safe to use in SSR environments (Astro, Nuxt, etc.)

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/utils/is.ts)
