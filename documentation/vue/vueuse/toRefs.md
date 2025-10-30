# toRefs

**Category:** Reactivity
**Export Size:** 285 B
**Last Changed:** 6 months ago

Extended [`toRefs`](https://vuejs.org/api/reactivity-utilities.html#torefs) that also accepts refs of an object.

## Usage

```ts
import { toRefs } from '@vueuse/core'
import { reactive, ref } from 'vue'

const objRef = ref({ a: 'a', b: 0 })
const arrRef = ref(['a', 0])

const { a, b } = toRefs(objRef)
const [a2, b2] = toRefs(arrRef)

const obj = reactive({ a: 'a', b: 0 })
const arr = reactive(['a', 0])

const { a: a3, b: b3 } = toRefs(obj)
const [a4, b4] = toRefs(arr)
```

## Use Cases

### Destructuring a props object

```vue
<script lang="ts">
import { toRefs, toRef } from '@vueuse/core'

export default {
  setup(props) {
    const data = toRefs(toRef(props, 'data'))

    console.log(data.a.value) // props.data.a

    data.a.value = 'a' // emit('update:data', { ...props.data, a: 'a' })

    return { ...data }
  }
}
</script>

<template>
  <div>
    <input v-model="a" type="text">
    <input v-model="b" type="text">
  </div>
</template>
```

## Type Declarations

```ts
export interface ToRefsOptions {
  /**
   * Replace the original ref with a copy on property update.
   *
   * @default true
   */
  replaceRef?: MaybeRefOrGetter<boolean>
}

/**
 * Extended `toRefs` that also accepts refs of an object.
 *
 * @see https://vueuse.org/toRefs
 * @param objectRef A ref or normal object or array.
 * @param options Options
 */
export declare function toRefs<T extends object>(
  objectRef: MaybeRef<T>,
  options?: ToRefsOptions
): ToRefs<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/toRefs/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/toRefs/index.md)
