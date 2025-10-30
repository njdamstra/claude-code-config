# provideLocal

**Category**: State
**Export Size**: 226 B
**Last Changed**: last week

Extended provide with ability to call injectLocal to obtain the value in the same component.

## USAGE

```vue
<script setup>
import {
injectLocal,
provideLocal
} from '@vueuse/core'


provideLocal('MyInjectionKey', 1)
const injectedValue = injectLocal('MyInjectionKey') // injectedValue === 1
</script>
```

## TYPE DECLARATIONS

```ts
export type ProvideLocalReturn = void
/**
 * On the basis of `provide`, it is allowed to directly call inject to obtain the value after call provide in the same component.
 *
 * @example
 * ```ts
 * provideLocal('MyInjectionKey', 1)
 * const injectedValue = injectLocal('MyInjectionKey') // injectedValue === 1
 * ```
 */
export declare function provideLocal<
T,
K = LocalProvidedKey<T>
>(
  key: K,
  value: K extends InjectionKey<infer V> ? V : T,
): ProvideLocalReturn
```

## SOURCE

Source • Docs

## CONTRIBUTORS

* ZHAO Jin-Xiang
* Zhaokun
* Arthur Darkstone
* Robin
* Anthony Fu

## CHANGELOG

Pending for release...
* 51872 - fix(shared): support provideLocal/injectLocal in vapor mode (#5050)

v13.1.0 on
* c1d6e - feat(shared): ensure return types exists (#4659)

v12.0.0-beta.1 on
* 0a9ed - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

v10.5.0 on
* cf757 - fix: vue 2 support for provideLocal and injectLocal (#3464)
* 5d948 - feat(createInjectionState): allow provide and inject in same component (#3387)