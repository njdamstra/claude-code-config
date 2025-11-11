# reactivePick

**Category:** Reactivity
**Export Size:** 464 B
**Last Changed:** 2 weeks ago

Reactively pick fields from a reactive object.

## Usage

### Basic Usage

```ts
import { reactivePick } from '@vueuse/core'

const obj = reactive({
  x: 0,
  y: 0,
  elementX: 0,
  elementY: 0,
})

const picked = reactivePick(obj, 'x', 'elementX') // { x: number, elementX: number }
```

### Predicate Usage

```ts
import { reactivePick } from '@vueuse/core'

const obj = reactive({
  foo: 'foo',
  bar: 'bar',
  baz: 'baz',
  qux: true,
})

const picked = reactivePick(obj, (value, key) => key !== 'bar' && value !== true)
// { foo: string, baz: string }

obj.qux = false
// { foo: string, baz: string, qux: boolean }
```

### Scenarios

#### Selectively passing props to child

```vue
<script setup lang="ts">
import { reactivePick } from '@vueuse/core'

const props = defineProps<{
  value: string
  color?: string
  font?: string
}>()

const childProps = reactivePick(props, 'color', 'font')
</script>

<template>
  <div>
    <!-- only passes "color" and "font" props to child -->
    <ChildComp v-bind="childProps" />
  </div>
</template>
```

#### Selectively wrap reactive object

Instead of doing this:

```ts
import { useMouse } from '@vueuse/core'
import { reactive } from 'vue'

const { x, y } = useMouse() // object of refs
const mouse = reactive({ x, y })
```

Now we can just have this:

```ts
import { reactivePick, useMouse } from '@vueuse/core'

const mouse = reactivePick(useMouse(), 'height', 'width')
```

## Type Declarations

```ts
export type ReactivePickedValue<T extends object, K extends keyof T> = {
  [P in K]: UnwrapRef<T[P]>
}

export type ReactivePickPredicate<T> = (
  value: T[keyof T],
  key: keyof T
) => boolean

export declare function reactivePick<T extends object, K extends keyof T>(
  obj: T,
  ...keys: (K | K[])[]
): ReactivePickedValue<T, K>

export declare function reactivePick<T extends object>(
  obj: T,
  predicate: ReactivePickPredicate<T>
): ReactivePickedValue<T, keyof T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/reactivePick/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/reactivePick/index.md)
