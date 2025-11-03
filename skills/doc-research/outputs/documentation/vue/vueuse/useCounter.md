# useCounter

Category: Utilities

Export Size: 265 B

Basic counter with utility functions.

## Basic Usage

```ts
import { useCounter } from '@vueuse/core'

const { count, inc, dec, set, reset } = useCounter()
```

## Usage with options

```ts
import { useCounter } from '@vueuse/core'

const { count, inc, dec, set, reset } = useCounter(1, { min: 0, max: 16 })
```
