# tryOnBeforeMount

**Category**: Component
**Export Size**: 163 B
**Last Changed**: 2 days ago

Safe `onBeforeMount`. Call `onBeforeMount()` if it's inside a component lifecycle, if not, just call the function

## Usage

```ts
import { tryOnBeforeMount } from '@vueuse/core'

tryOnBeforeMount(() => { })
```

## Type Declarations

```ts
/**
 * Call onBeforeMount() if it's inside a component lifecycle, if not, just call the function
 *
 * @param fn
 * @param sync if set to false, it will run in the nextTick() of Vue
 * @param target
 */
export declare function tryOnBeforeMount(
  fn: Fn,
  sync?: boolean,
  target?: ComponentInternalInstance | null,
): void
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/tryOnBeforeMount/index.ts) • [Docs](https://vueuse.org/shared/tryOnBeforeMount/)

## Contributors

* Anthony Fu
* Arthur Darkstone
* SerKo
* Anthony Fu
* Doctorwu
* qiang
* Eureka

## Changelog

* **Pending for release...**
  * `a49a3` - fix: update parameter types to use ComponentInternalInstance in lifec… (#5060)
* **v12.3.0** on 1/2/2025
  * `59f75` - feat(toValue): deprecate toValue from @vueuse/shared in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.7.1** on 12/27/2023
  * `ce420` - fix: fix tryOnMounted in vue2 (#3658)
* **v10.7.0** on 12/5/2023
  * `f2aeb` - feat(tryOnMounted): support target arguement (#3185)
