# useCloned

Category: Utilities

Export Size: 289 B

Reactive clone of a ref. By default, it use `JSON.parse(JSON.stringify())` to do the clone.

## Usage

```ts
import { useCloned } from '@vueuse/core'

const original = ref({ key: 'value' })

const { cloned } = useCloned(original)

cloned.value.key = 'some new value'

console.log(original.value.key) // 'value'
```

## Manual cloning

```ts
import { useCloned } from '@vueuse/core'

const original = ref({ key: 'value' })

const { cloned, sync } = useCloned(original, { manual: true })

cloned.value.key = 'manual'

console.log(original.value.key) // 'value'

sync()

console.log(original.value.key) // 'manual'
```

## Custom Clone Function

Using [`klona`](https://www.npmjs.com/package/klona) for example:

```ts
import { useCloned } from '@vueuse/core'
import { klona } from 'klona'

const original = ref({ key: 'value' })

const { cloned, sync, isModified } = useCloned(original, { clone: klona })
```
