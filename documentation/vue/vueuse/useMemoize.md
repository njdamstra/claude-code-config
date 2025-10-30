# useMemoize

**Category**: Utilities
**Export Size**: 436 B
**Last Changed**: 2 weeks ago

Cache results of functions depending on arguments and keep it reactive.

## Usage

`useMemoize` is a powerful utility for performance optimization. It caches the result of a function based on its arguments. If the function is called again with the same arguments, the cached result is returned instead of re-executing the function.

### Synchronous Functions

```ts
import { useMemoize } from '@vueuse/core'

const compute = (a: number, b: number) => {
  console.log('Computing...')
  return a + b
}

const memoizedCompute = useMemoize(compute)

memoizedCompute(1, 2) // 'Computing...' is logged, returns 3
memoizedCompute(1, 2) // returns 3 from cache, no log
memoizedCompute(2, 3) // 'Computing...' is logged, returns 5
```

### Asynchronous Functions

`useMemoize` also works with async functions, reusing existing promises to prevent multiple simultaneous fetches for the same data.

```ts
import { useMemoize } from '@vueuse/core'
import axios from 'axios'

const getUser = useMemoize(async (id: number) => {
  console.log(`Fetching user ${id}`)
  const { data } = await axios.get(`https://jsonplaceholder.typicode.com/users/${id}`)
  return data
})

await getUser(1) // 'Fetching user 1' is logged, fetches data
await getUser(1) // returns cached promise, no new fetch
```

## Cache Management

The cache is not cleared automatically. You need to manage it manually to prevent memory leaks.

- `memoizedFn.delete(...args)`: Clear the cache for a specific set of arguments.
- `memoizedFn.clear()`: Clear the entire cache.

```ts
// Clear cache for a specific user
getUser.delete(1)

// Clear all cached users
getUser.clear()
```

## Custom Cache

You can provide a custom cache implementation (which must conform to the `Map` interface) via the options.

```ts
import { useMemoize } from '@vueuse/core'

const cache = new Map()
const memoized = useMemoize(myFunction, { cache })
```

## Type Declarations

```ts
export interface UseMemoizeOptions<T> {
  getKey?: (...args: any[]) => string
  cache?: Map<string, T>
}

export declare function useMemoize<T extends (...args: any[]) => any>(
  resolver: T,
  options?: UseMemoizeOptions<ReturnType<T>>,
): T & {
  clear: () => void
  delete: (...args: Parameters<T>) => void
}
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMemoize/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useMemoize/index.md)
