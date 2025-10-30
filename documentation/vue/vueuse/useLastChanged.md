# useLastChanged

**Category**: State
**Export Size**: 188 B
**Last Changed**: 6 months ago

Records the timestamp of the last change

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useLastChanged/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNks1qwzAQhF9l5JIlSfu+RVG6BfZA2GQr1oNYlrZgZctG8hD5752kQdqlBwZ758x4Z3Y2H6l61T5mG5IapqtGg3FrKxBZLLLCFEpZLaqudGqhhWtuWflVSKXzo+DQwVmrC0Q7lHCGJ0xpXk3gpsxFUdcdP49QRCKCSqakcSBVAckEFkfRYsgZ5TTj8/Qas0O+hco3wj/qU265wQrZQ38xlXCTefbPB7ItxLh51eTCcVhmcHgt0Sk/gVVAyVPbdJRQKg+LQGjhLJwpNxCZb8ki6DAaOjg7yWylJDDBcx0voL2XuslnsPax+7UMInTeTcgudP4Xe7mcI3unp97qQJjZjzGK7kLityZAh32jYpr0a8al4sfySy2QjT+A9FQ120/P2ECLu+vH33Vp4hMBcXTWYjc7Jir2hefRGwgn4qv2rQRk0kNnNCZyY5CFy8GRU3LXmdkb5cIecTX/yI4qYRcje8/xkh9IPU0PL6nQ+rsq0iS8btFa8y3596fpzfurm9tkVqT7ARogHJ)

Last changed: 5 minutes ago (1758912241394)

## Usage

```ts
import { useLastChanged } from '@vueuse/core'
import { nextTick } from 'vue'

const a = ref(0)
const lastChanged = useLastChanged(a)

a.value = 1
await nextTick()

console.log(lastChanged.value) // 1704709379457
```

By default the change is recorded on the next tick ( watch() with flush: 'post' ). If you want to record the change immediately, pass flush: 'sync' as the second argument.

```ts
import { useLastChanged } from '@vueuse/core'

const a = ref(0)
const lastChanged = useLastChanged(a, { flush: 'sync' })

a.value = 1

console.log(lastChanged.value) // 1704709379457
```

## Type Declarations

```ts
export interface UseLastChangedOptions<Immediate extends boolean, InitialValue extends number | null | undefined = undefined> extends WatchOptions<Immediate> {
  initialValue?: InitialValue
}

export type UseLastChangedReturn = | Readonly<ShallowRef<number | null>> | Readonly<ShallowRef<number>>

/**
 * Records the timestamp of the last change
 *
 * @see https://vueuse.org/useLastChanged
 */
export declare function useLastChanged(
  source: WatchSource,
  options?: UseLastChangedOptions<false>,
): Readonly<ShallowRef<number | null>>

export declare function useLastChanged(
  source: WatchSource,
  options: UseLastChangedOptions<true> | UseLastChangedOptions<boolean, number>,
): Readonly<ShallowRef<number>>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useLastChanged/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/useLastChanged/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useLastChanged/index.md)

## Contributors

* Anthony Fu
* Robin
* IlyaL
* James Garbutt
* yaoyin
* Jady Dragon
* Alex Kozack

## Changelog

### v13.1.0 on 4/8/2025
- `c1d6e` - feat(shared): ensure return types exists (#4659)

### v12.0.0-beta.1 on 11/21/2024
- `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
