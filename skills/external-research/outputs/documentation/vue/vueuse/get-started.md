# Get Started

[Skip to content](https://vueuse.org/guide/#VPContent)

On this page

# Get Started [​](https://vueuse.org/guide/\#get-started)

[Learn VueUse with video](https://vueschool.io/courses/vueuse-for-everyone?friend=vueuse)

VueUse is a collection of utility functions based on [Composition API](https://vuejs.org/guide/extras/composition-api-faq.html). We assume you are already familiar with the basic ideas of [Composition API](https://vuejs.org/guide/extras/composition-api-faq.html) before you continue.

## Installation [​](https://vueuse.org/guide/\#installation)

> From v12.0, VueUse no longer supports Vue 2. Please use v11.x for Vue 2 support.

bash

```
npm i @vueuse/core
```

[Add ons](https://vueuse.org/add-ons) \| [Nuxt Module](https://vueuse.org/guide/#nuxt)

###### Demos [​](https://vueuse.org/guide/\#demos)

- [Vite + Vue 3](https://github.com/vueuse/vueuse-vite-starter)
- [Nuxt 3 + Vue 3](https://github.com/antfu/vitesse-nuxt3)
- [Webpack + Vue 3](https://github.com/vueuse/vueuse-vue3-example)

### CDN [​](https://vueuse.org/guide/\#cdn)

vue

```
<script src="https://unpkg.com/@vueuse/shared"></script>

<script src="https://unpkg.com/@vueuse/core"></script>
```

It will be exposed to global as `window.VueUse`

### Nuxt [​](https://vueuse.org/guide/\#nuxt)

From v7.2.0, we shipped a Nuxt module to enable auto importing for Nuxt 3 and Nuxt Bridge.

Install the vueuse module into your application using [@nuxt/cli](https://nuxt.com/docs/api/commands/module):

bash

```
npx nuxt@latest module add vueuse
```

Or use npm:

bash

```
npm i -D @vueuse/nuxt @vueuse/core
```

Nuxt 3

ts

```
// nuxt.config.ts
export default defineNuxtConfig({
  modules: [\
    '@vueuse/nuxt',\
  ],
})
```

And then use VueUse function anywhere in your Nuxt app. For example:

vue

```
<script setup lang="ts">
const {
,
 } =
()
</script>

<template>
  <
>pos: {{
 }}, {{
 }}</
>
</template>
```

## Usage Example [​](https://vueuse.org/guide/\#usage-example)

Simply importing the functions you need from `@vueuse/core`

vue

```
<script setup>
import {
,
,
 } from '@vueuse/core'

// tracks mouse position
const {
,
 } =
()

// is user prefers dark theme
const
 =
()

// persist state in localStorage
const
 =
(
  'my-storage',
  {

: 'Apple',

: 'red',
  },
)
</script>
```

Refer to [functions list](https://vueuse.org/functions) for more details.
