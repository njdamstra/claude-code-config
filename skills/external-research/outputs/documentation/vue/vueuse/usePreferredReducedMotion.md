# usePreferredReducedMotion

Category: Browser

Export Size: 1.22 kB

Reactive [prefers-reduced-motion](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion) media query.

## Usage

```ts
import { usePreferredReducedMotion } from '@vueuse/core'

const preferredReducedMotion = usePreferredReducedMotion()
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UsePreferredReducedMotion v-slot="{ preferredReducedMotion }">
    Preferred Reduced Motion: {{ preferredReducedMotion }}
  </UsePreferredReducedMotion>
</template>
```

## Type Declarations

```ts
export type ReducedMotionType = "reduce" | "no-preference"

/**
 * Reactive prefers-reduced-motion media query.
 *
 * @see https://vueuse.org/usePreferredReducedMotion
 * @param [options]
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function usePreferredReducedMotion(
  options?: ConfigurableWindow,
): Ref<ReducedMotionType>
```
