# reactifyObject

**Category**: Reactivity
**Export Size**: 384 B
**Last Changed**: 2 weeks ago

Apply `reactify` to an object.

## Usage

`reactifyObject` takes an object and returns a new object where the methods are "reactified". This means the methods will automatically unwrap any refs passed to them as arguments, so you don't need to use `.value`.

```ts
import { ref, watchEffect } from 'vue'
import { reactifyObject } from '@vueuse/core'

const reactifiedConsole = reactifyObject(console)

const a = ref('Hello')
const b = ref('World')

watchEffect(() => {
  // No need for .value, reactifiedConsole.log will unwrap a and b
  reactifiedConsole.log(a, b)
})

a.value = 'Hi' // This will trigger the watchEffect and log "Hi World"
```

This is useful for making existing objects or libraries more convenient to use within Vue's reactivity system.

## Options

You can provide an options object to control which properties are reactified.

```ts
const reactified = reactifyObject(myObject, {
  include: ['methodA', 'methodB'], // only reactify these methods
})
```

You can also include own properties of the object.

```ts
const reactified = reactifyObject(myObject, true) // reactify all own properties
```

## Type Declarations

```ts
export declare function reactifyObject<T extends object>(
  obj: T,
  options?: boolean | (keyof T)[] | ReactifyObjectOptions<keyof T>,
): Reactified<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/reactifyObject/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/reactifyObject/index.md)
