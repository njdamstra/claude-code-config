# Note: useStoragePlain Does Not Exist

After searching VueUse documentation and web resources, **`useStoragePlain` is not a real VueUse composable**.

## Available Storage Composables

VueUse provides these storage-related composables:

1. **`useStorage`** - Reactive LocalStorage/SessionStorage with automatic serialization
2. **`useStorageAsync`** - Async version of useStorage for async storage backends
3. **`useLocalStorage`** - Convenience wrapper for useStorage with localStorage
4. **`useSessionStorage`** - Convenience wrapper for useStorage with sessionStorage

## If You Need "Plain" Storage

If you need storage without automatic parsing/serialization, you can configure `useStorage` with a custom serializer:

```ts
import { useStorage } from '@vueuse/core'

// Plain string storage (no JSON parsing)
const value = useStorage('key', 'default', undefined, {
  serializer: {
    read: (v: string) => v,  // Return as-is
    write: (v: string) => v  // Store as-is
  }
})
```

Or use the built-in `StorageSerializers.string`:

```ts
import { useStorage, StorageSerializers } from '@vueuse/core'

const value = useStorage('key', 'default', undefined, {
  serializer: StorageSerializers.string
})
```

## References

- [useStorage Documentation](https://vueuse.org/core/useStorage/)
- [useStorageAsync Documentation](https://vueuse.org/core/useStorageAsync/)
