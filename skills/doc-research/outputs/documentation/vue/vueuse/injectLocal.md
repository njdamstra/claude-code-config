# injectLocal | VueUse

**Category:** State
**Export Size:** 246 B
**Last Changed:** last week

Extended `inject` with ability to call `provideLocal` to provide the value in the same component.

## Usage

```vue
<script setup>
import { injectLocal, provideLocal } from '@vueuse/core'

provideLocal('MyInjectionKey', 1)
const injectedValue = injectLocal('MyInjectionKey') // injectedValue === 1
</script>
```

## Type Declarations

```ts
/**
 * On the basis of `inject`, it is allowed to directly call inject to obtain the value after call provide in the same component.
 *
 * @example
 * ```ts
 * injectLocal('MyInjectionKey', 1)
 * const injectedValue = injectLocal('MyInjectionKey') // injectedValue === 1
 * ```
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare const injectLocal: typeof inject
```

## Source

[Source](https://vueuse.org/shared/injectLocal/) • [Docs](https://vueuse.org/shared/injectLocal/)

## Contributors

* Anthony Fu
* ZHAO Jin-Xiang
* Zhaokun
* Arthur Darkstone
* SerKo

## Changelog

*   **Pending for release...**
    *   `51872` - fix(shared): support provideLocal/injectLocal in vapor mode (#5050)
*   **v13.6.0 on 7/28/2025**
    *   `d32f8` - refactor: add @__NO_SIDE_EFFECTS__ annotations to all pure functions (#4907)
*   **v12.1.0 on 12/22/2024**
    *   `b08a9` - fix: allow inject to app context
*   **v12.0.0-beta.1 on 11/21/2024**
    *   `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
*   **v10.5.0 on 10/7/2023**
    *   `cf757` - fix: vue 2 support for provideLocal and injectLocal (#3464)
    *   `5d948` - feat(createInjectionState): allow provide and inject in same component (#3387)