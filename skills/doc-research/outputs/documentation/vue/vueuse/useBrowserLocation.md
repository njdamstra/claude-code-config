[Skip to content](https://vueuse.org/core/useBrowserLocation/#VPContent)

On this page

# useBrowserLocation [​](https://vueuse.org/core/useBrowserLocation/\#usebrowserlocation)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

884 B

Last Changed

2 months ago

Reactive browser location

> NOTE: If you're using Vue Router, use [`useRoute`](https://router.vuejs.org/guide/advanced/composition-api.html) provided by Vue Router instead.

## Demo [​](https://vueuse.org/core/useBrowserLocation/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useBrowserLocation/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNptUstugzAQ/JURlxCJJncEVR+XVmql9liJiwtLY9XYlh+kEeLfu0BIeujJ2t3ZGXvGQ3Jv7a6PlORJ4WsnbYCnEC2U0F9llQRfJbeVlp01LmCAI1EH2Z4yRE8Pzhw9uRdTiyCNxojWmQ6bOybk8b42jjaX5Y/715cz4CQ6xYNK10Z7VgxO6i9mRXkRSCsNpFLbGHIIfdqivJ0pdhf0Ms2Qfmfo5/kwLQGyRRpOlkyLHmVZYtNGzaxGb7YrBqwUotOIuqFWamqW/rgc52E/VWO2LnkWVvQeTaAcwUXKln6rzPHRKEWzyJtoGgbmaIXyC2Tc8rG9vlitlpX/+JgycIEF+gkMub543WNEsV/y4nS4CNRZJQJxBTxPvrBpDQ7CH3CUSuGTUB84U2ryCVLM3qG/6UxDioNemXfTSpVg8m/Kn2/AFXPXdDCqIcfNpxkySxXW0fpXplS5PQzLvcex2POUYcX+z/WS8RcOMdoE)

Input and hash will be changed:

```
trigger: load
state: {}
length: 2
origin: https://vueuse.org
hash: ''
host: vueuse.org
hostname: vueuse.org
href: https://vueuse.org/core/useBrowserLocation/
pathname: /core/useBrowserLocation/
port: ''
protocol: 'https:'
search: ''

```

## Usage [​](https://vueuse.org/core/useBrowserLocation/\#usage)

ts

```
import {
 } from '@vueuse/core'

const
 =
()
```

## Component Usage [​](https://vueuse.org/core/useBrowserLocation/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<UseBrowserLocation v-slot="location">
  Browser Location: {{ location }}
</UseBrowserLocation>
```

## Type Declarations [​](https://vueuse.org/core/useBrowserLocation/\#type-declarations)

Show Type Declarations

ts

```
export interface BrowserLocationState {
  readonly
: string
  readonly
?: any
  readonly
?: number
  readonly
?: string

?: string

?: string

?: string

?: string

?: string

?: string

?: string

?: string
}
/**
 * Reactive browser location.
 *
 * @see https://vueuse.org/useBrowserLocation
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
(
?:
):
<
  {
    readonly
: string
    readonly
?: any
    readonly
?: number | undefined
    readonly
?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined
  },
  | BrowserLocationState
  | {
      readonly
: string
      readonly
?: any
      readonly
?: number | undefined
      readonly
?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined

?: string | undefined
    }
>
export type
 =
<typeof
>
```

## Source [​](https://vueuse.org/core/useBrowserLocation/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useBrowserLocation/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useBrowserLocation/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useBrowserLocation/index.md)

## Contributors [​](https://vueuse.org/core/useBrowserLocation/\#contributors)

![](https://gravatar.com/avatar/616389b9fc3c3c92d244e2639418f0c5?d=retro) Anthony Fu

![](https://gravatar.com/avatar/b1f73ba4300d063a1ccc27a8e3068d57?d=retro) SerKo

![](https://gravatar.com/avatar/46f3527083016d732d6846ca84a8fb94?d=retro) IlyaL

![](https://gravatar.com/avatar/7a1806b5ad96f54dbdb5e593cef7cb51?d=retro) Robin

![](https://gravatar.com/avatar/fcf2fd60dd85e0c9c7c2c1e07b0e44b2?d=retro) Fernando Fernández

![](https://gravatar.com/avatar/10af285c4d864f57c5baefa1bcc05ed2?d=retro) Anthony Fu

![](https://gravatar.com/avatar/e2456e5a43aeb2bd86970a3837fd8496?d=retro) 三咲智子 Kevin Deng

![](https://gravatar.com/avatar/8bf1ff4343c98b9e31761fb7394f1794?d=retro) vaakian X

![](https://gravatar.com/avatar/02c04de0164b6c73eccbb26be7ab4af1?d=retro) Mike

![](https://gravatar.com/avatar/7f096f89bc8789129bbf280c14500a6c?d=retro) Eureka

![](https://gravatar.com/avatar/6cb1d60181c3acd1d52af8002c3f2e99?d=retro) Shinigami

![](https://gravatar.com/avatar/d2eccc131bb7a5815d1ef3695ad30b04?d=retro) wheat

![](https://gravatar.com/avatar/11e362516e144541907475ff1dbcea6b?d=retro) Alex Kozack

![](https://gravatar.com/avatar/77b8ac226fff6d2ac09e16d547cd9ac5?d=retro) Antério Vieira

## Changelog [​](https://vueuse.org/core/useBrowserLocation/\#changelog)

[`v14.0.0-alpha.0`](https://github.com/vueuse/vueuse/releases/tag/v14.0.0-alpha.0) on 9/1/2025

[`8c521`](https://github.com/vueuse/vueuse/commit/8c521d4e4cebc78f59db70cd137098b7095ed605) \- feat(components)!: refactor components and make them consistent ( [#4912](https://github.com/vueuse/vueuse/issues/4912))

[`v13.6.0`](https://github.com/vueuse/vueuse/releases/tag/v13.6.0) on 7/28/2025

[`d32f8`](https://github.com/vueuse/vueuse/commit/d32f80ca4e0f7600b68cbca05341b351e31563c1) \- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions ( [#4907](https://github.com/vueuse/vueuse/issues/4907))

[`v12.5.0`](https://github.com/vueuse/vueuse/releases/tag/v12.5.0) on 1/22/2025

[`eddbf`](https://github.com/vueuse/vueuse/commit/eddbf8f91e2218b01a3a18822096c0dfb15751fa) \- feat: more passive event handlers ( [#4484](https://github.com/vueuse/vueuse/issues/4484))

[`v12.0.0-beta.1`](https://github.com/vueuse/vueuse/releases/tag/v12.0.0-beta.1) on 11/21/2024

[`0a9ed`](https://github.com/vueuse/vueuse/commit/0a9ed589ab0e3a4aa8c7b7a4292757947378c14c) \- feat!: drop Vue 2 support, optimize bundles and clean up ( [#4349](https://github.com/vueuse/vueuse/issues/4349))
