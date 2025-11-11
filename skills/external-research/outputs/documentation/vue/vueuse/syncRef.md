# syncRef

**Category:** Reactivity
**Export Size:** 637 B
**Last Changed:** 10 months ago
**Related:** [`syncRefs`](https://vueuse.org/shared/syncRefs/)

Two-way refs synchronization.

## Usage

```ts
import { syncRef } from '@vueuse/core'

const a = ref('a')
const b = ref('b')

const stop = syncRef(a, b)

console.log(a.value) // a

b.value = 'foo'

console.log(a.value) // foo

a.value = 'bar'

console.log(b.value) // bar
```

### One directional

```ts
import { syncRef } from '@vueuse/core'

const a = ref('a')
const b = ref('b')

const stop = syncRef(a, b, { direction: 'rtl' })
```

### Custom Transform

```ts
import { syncRef } from '@vueuse/core'

const a = ref(10)
const b = ref(2)

const stop = syncRef(a, b, {
  transform: {
    ltr: left => left * 2,
    rtl: right => right / 2
  }
})

console.log(b.value) // 20

a.value = 30

console.log(b.value) // 15
```

## Type Declarations

```ts
type Direction = "ltr" | "rtl" | "both"

export interface SyncRefOptions<L, R, Direction extends SyncDirection> {
  flush?: WatchOptions['flush']
  deep?: boolean
  immediate?: boolean
  direction?: Direction
  transform?: {
    ltr?: (left: L) => R
    rtl?: (right: R) => L
  }
}

/**
 * Two-way refs synchronization.
 * From the set theory perspective to restrict the option's type
 * Check in the following order:
 * 1. L = R
 * 2. L ∩ R ≠ ∅
 * 3. L ⊆ R
 * 4. L ∩ R = ∅
 */
export declare function syncRef<L, R, Direction extends SyncDirection = "both">(
  left: Ref<L>,
  right: Ref<R>,
  ...[options]: // complex overloads
): () => void
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/syncRef/index.ts)
- [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/syncRef/demo.vue)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/syncRef/index.md)
