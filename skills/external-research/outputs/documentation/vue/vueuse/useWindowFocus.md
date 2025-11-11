# useWindowFocus

Category: Elements

Export Size: 681 B

Reactively track window focus with `window.onfocus` and `window.onblur` events.

## Usage

```vue
<script setup lang="ts">
import { useWindowFocus } from '@vueuse/core'

const focused = useWindowFocus()
</script>

<template>
  <div>{{ focused }}</div>
</template>
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package.

```vue
<template>
  <UseWindowFocus v-slot="{ focused }">
    Document Focus: {{ focused }}
  </UseWindowFocus>
</template>
```
