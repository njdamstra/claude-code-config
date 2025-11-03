# usePreferredContrast

Category: Browser

Export Size: 1.24 kB

Reactive [prefers-contrast](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-contrast) media query.

## Usage

```ts
import { usePreferredContrast } from '@vueuse/core'

const preferredContrast = usePreferredContrast()
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UsePreferredContrast v-slot="{ preferredContrast }">
    Preferred Contrast: {{ preferredContrast }}
  </UsePreferredContrast>
</template>
```

## Type Declarations

```ts
export type ContrastType = "more" | "less" | "custom" | "no-preference"

/**
 * Reactive prefers-contrast media query.
 *
 * @see https://vueuse.org/usePreferredContrast
 * @param [options]
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function usePreferredContrast(
  options?: ConfigurableWindow,
): Ref<ContrastType>
```
