# useCycleList

Category: Utilities

Export Size: 444 B

Cycle through a list of items.

## Usage

```ts
import { useCycleList } from '@vueuse/core'

const { state, next, prev, go } = useCycleList([
  'Dog',
  'Cat',
  'Lizard',
  'Shark',
  'Whale',
  'Dolphin',
  'Octopus',
  'Seal',
])

console.log(state.value) // 'Dog'

next()

console.log(state.value) // 'Seal'

go(3)

console.log(state.value) // 'Shark'
```
