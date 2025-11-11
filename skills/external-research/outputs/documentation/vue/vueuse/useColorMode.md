# useColorMode

Category: [Browser](https://vueuse.org/functions#category=Browser)

Export Size: 3.14 kB

Reactive color mode (dark / light / customs) with auto data persistence.

## Basic Usage

```ts
import { useColorMode } from '@vueuse/core'

const mode = useColorMode() // Ref<'dark' | 'light'>
```

By default, it will match with users' browser preference using `usePreferredDark` (a.k.a `auto` mode). When reading the ref, it will by default return the current color mode ( `dark`, `light` or your custom modes). The `auto` mode can be included in the returned modes by enabling the `emitAuto` option. When writing to the ref, it will trigger DOM updates and persist the color mode to local storage (or your custom storage). You can pass `auto` to set back to auto mode.

```ts
mode.value // 'dark' | 'light'

mode.value = 'dark' // change to dark mode and persist

mode.value = 'auto' // change to auto mode
```

## Config

```ts
import { useColorMode } from '@vueuse/core'

const mode = useColorMode({
  attribute: 'theme',
  modes: {
    // custom colors
    dim: 'dim',
    cafe: 'cafe',
  },
}) // Ref<'dark' | 'light' | 'dim' | 'cafe'>
```

## Advanced Usage

You can also explicit access to the system preference and storaged user override mode.

```ts
import { useColorMode } from '@vueuse/core'

const { store, system } = useColorMode()

system.value // 'dark' | 'light'

store.value // 'dark' | 'light' | 'auto'

const preferredMode = computed(() =>
  store.value === 'auto' ? system.value : store.value
)
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseColorMode v-slot="{ mode }">
    <button @click="mode.mode = mode.mode === 'dark' ? 'light' : 'dark'">
      Mode {{ mode.mode }}
    </button>
  </UseColorMode>
</template>
```

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useColorMode/index.ts)
