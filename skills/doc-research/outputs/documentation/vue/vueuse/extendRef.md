# extendRef

**Category:** Reactivity
**Export Size:** 207 B
**Last Changed:** 6 months ago

Add extra attributes to Ref.

> **Note:** Please note the extra attribute will not be accessible in Vue's template.

## Usage

```ts
import { extendRef } from '@vueuse/core'
import { ref } from 'vue'

const myRef = ref('content')

const extended = extendRef(myRef, { extra: 'extra data' })

extended.value === 'content'

extended.extra === 'extra data'
```

### Refs will be unwrapped and be reactive

```ts
const myRef = ref('content')
const extraRef = ref('extra')

const extended = extendRef(myRef, { extra: extraRef })

extended.value === 'content'

extended.extra === 'extra'

extraRef.value = 'new data' // will trigger update

extended.extra === 'new data'
```

## Type Declarations

```ts
export type ShallowUnwrapRef<T = any> = UnwrapRef<T>

export interface ExtendRefOptions<Unwrap extends boolean = boolean> {
  /**
   * Is the extends properties enumerable
   *
   * @default false
   */
  enumerable?: boolean

  /**
   * Unwrap for Ref properties
   *
   * @default true
   */
  unwrap?: Unwrap
}

/**
 * Overload 1: Unwrap set to false
 */
export declare function extendRef<
  R extends Ref<any>,
  Extend extends object,
  Options extends ExtendRefOptions<false>,
>(ref: R, extend: Extend, options?: Options): ShallowUnwrapRef<R> & Extend

/**
 * Overload 2: Unwrap unset or set to true
 */
export declare function extendRef<
  R extends Ref<any>,
  Extend extends object,
  Options extends ExtendRefOptions,
>(ref: R, extend: Extend, options?: Options): R & ShallowUnwrapRef<Extend>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/extendRef/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/extendRef/index.md)
