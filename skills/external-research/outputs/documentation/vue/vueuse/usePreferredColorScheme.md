# usePreferredColorScheme

Category: Browser

Export Size: 1.24 kB

Reactive [prefers-color-scheme](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme) media query.

## Usage

```ts
import { usePreferredColorScheme } from '@vueuse/core'

const preferredColorScheme = usePreferredColorScheme()
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UsePreferredColorScheme v-slot="{ preferredColorScheme }">
    Preferred Color Scheme: {{ preferredColorScheme }}
  </UsePreferredColorScheme>
</template>
```

## Type Declarations

```ts
export type ColorSchemeType = "dark" | "light" | "no-preference"

/**
 * Reactive prefers-color-scheme media query.
 *
 * @see https://vueuse.org/usePreferredColorScheme
 * @param [options]
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function usePreferredColorScheme(
  options?: ConfigurableWindow,
): Ref<ColorSchemeType>
```
