# useSupported

**Category**: Utilities
**Export Size**: 101 B
**Last Changed**: 2 weeks ago

Reactively checks if a browser feature is supported.

## Usage

`useSupported` is a utility for gracefully handling browser APIs that may not be available in all environments. It takes a callback function that checks for the presence of an API and returns a reactive boolean `isSupported` ref.

This is especially useful for ensuring SSR compatibility.

```ts
import { useSupported } from '@vueuse/core'

// Check for Geolocation API support
const isGeolocationSupported = useSupported(() => 'geolocation' in navigator)

if (isGeolocationSupported.value) {
  // Use the Geolocation API
} else {
  // Handle the case where the API is not supported
}
```

The callback is only executed on the client-side, making it safe for server-side rendering. On the server, `isSupported` will always be `false`.

## Example with `usePermission`

```vue
<script setup lang="ts">
import { useSupported } from '@vueuse/core'
import { usePermission } from '@vueuse/core'

const isPermissionSupported = useSupported(() => navigator && 'permissions' in navigator)

let microphone, state
if (isPermissionSupported.value) {
  ({ microphone, state } = usePermission('microphone'))
}
</script>
```

## Type Declarations

```ts
/**
 * SSR-safe utility to check if a browser feature is supported.
 *
 * @see https://vueuse.org/useSupported
 * @param callback The callback to check for feature support.
 */
export declare function useSupported(
  callback: () => unknown,
  sync?: boolean,
): Readonly<Ref<boolean>>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useSupported/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useSupported/index.md)
