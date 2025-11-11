[Skip to content](https://vueuse.org/core/useElementHover/#VPContent)

On this page

# useElementHover [​](https://vueuse.org/core/useElementHover/\#useelementhover)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

1.17 kB

Last Changed

3 months ago

Reactive element's hover state.

## Demo [​](https://vueuse.org/core/useElementHover/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementHover/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqdUc1Og0AQfpWRy9akLcSDB0LrT2zSQ72Y3sTDlg6WuMyS3QXTEN7dKaDF2kQjt2Hn+5uv9u6KYlqV6IVeZBOTFQ4surIAJel1FnvOxt48piwvtHFQQ7VQmCO5pa7QQAOp0TmIW2YoLfqJ5j3iZysGGH75BWVwuG93Uin9/oTp+IBdY14o6ZDnLygjGRFTosk6QAWzk81ouX5c3ZfOaeq15yOBSlx+YjL7kBlMXFZh6wq3zHFUHqVSWRxsH5dO4oxQjdn0FpXcL8ihCeEqCMbdjxXKCkO4DgJomCwtiRU1gaYOu+tYQ9horVDSJdQxwRlz00qqElm9R8TUxBT5XWVcEA+uT88TQLRps4PBlFtE1bYI/EW2kDSv60GkGxDrnaQ32OvyQkAIouspRwFNwyIHREvqd6zfFKoJdteYtNZY7blP97ezvJyz9qOb/3iM/MFJvOYDVeYGpQ==)

Hover meHover me

## Usage [​](https://vueuse.org/core/useElementHover/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
<HTMLButtonElement>('myHoverableElement')
const
=
(
)
</script>

<template>
  <

="
">
    {{
}}
  </
>
</template>
```

## Directive Usage [​](https://vueuse.org/core/useElementHover/\#directive-usage)

> This function also provides a directive version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<script setup lang="ts">
import {
} from '@vueuse/components'
import {
} from 'vue'

const
=
(false)
function
(
: boolean) {

.
=


}
</script>

<template>
  <

er="
">
    {{
? 'Thank you!' : 'Hover me' }}
  </
>
</template>
```

You can also provide hover options:

vue

```
<script setup lang="ts">
import {
} from '@vueuse/components'
import {
} from 'vue'

const
=
(false)
function
(
: boolean) {

.
=


}
</script>

<template>
  <

er="

">
    <
>{{
? 'Thank you!' : 'Hover me' }}</
>
  </
>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useElementHover/\#type-declarations)

ts

```
export interface UseElementHoverOptions extends ConfigurableWindow {

?: number

?: number

?: boolean
}
export declare function
(

:
<EventTarget | null | undefined>,

?: UseElementHoverOptions,
):
<boolean>
```

## Source [​](https://vueuse.org/core/useElementHover/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementHover/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementHover/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementHover/index.md)
