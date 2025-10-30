# createReusableTemplate

**Category:** Component
**Export Size:** 593 B

Define and reuse template inside the component scope.

## Motivation

It's common to have the need to reuse some part of the template. For example:

```vue
<template>
  <Dialog v-if="showInDialog">
    <!-- something complex -->
  </Dialog>
  <Card v-else>
    <!-- something complex -->
  </Card>
</template>
```

We'd like to reuse our code as much as possible. So normally we might need to extract those duplicated parts into a component. However, in a separated component you lose the ability to access the local bindings. Defining props and emits for them can be tedious sometimes.

So this function is made to provide a way for defining and reusing templates inside the component scope.

## Usage

In the previous example, we could refactor it to:

```vue
<script setup lang="ts">
import { createReusableTemplate } from '@vueuse/core'

const [DefineTemplate, ReuseTemplate] = createReusableTemplate()
</script>

<template>
  <DefineTemplate>
    <!-- something complex -->
  </DefineTemplate>

  <Dialog v-if="showInDialog">
    <ReuseTemplate />
  </Dialog>
  <Card v-else>
    <ReuseTemplate />
  </Card>
</template>
```

- `<DefineTemplate>` will register the template and renders nothing.
- `<ReuseTemplate>` will render the template provided by `<DefineTemplate>`.
- `<DefineTemplate>` must be used before `<ReuseTemplate>`.

> **Note**: It's recommended to extract as separate components whenever possible. Abusing this function might lead to bad practices for your codebase.

### Options API

When using with Options API, you will need to define `createReusableTemplate` outside of the component setup and pass to the `components` option in order to use them in the template.

```vue
<script>
import { createReusableTemplate } from '@vueuse/core'
import { defineComponent } from 'vue'

const [DefineTemplate, ReuseTemplate] = createReusableTemplate()

export default defineComponent({
  components: {
    DefineTemplate,
    ReuseTemplate,
  },
  setup() {
    // ...
  },
})
</script>

<template>
  <DefineTemplate v-slot="{ data, msg, anything }">
    <div>{{ msg }} passed from usage</div>
  </DefineTemplate>

  <ReuseTemplate :data="data" :msg="The first usage" />
</template>
```

### Passing Data

You can also pass data to the template using slots:

- Use `v-slot="..."` to access the data on `<DefineTemplate>`
- Directly bind the data on `<ReuseTemplate>` to pass them to the template

```vue
<script setup lang="ts">
import { createReusableTemplate } from '@vueuse/core'

const [DefineTemplate, ReuseTemplate] = createReusableTemplate()
</script>

<template>
  <DefineTemplate v-slot="{ data, msg, anything }">
    <div>{{ msg }} passed from usage</div>
  </DefineTemplate>

  <ReuseTemplate :data="data" :msg="The first usage" />
  <ReuseTemplate :data="anotherData" :msg="The second usage" />
  <ReuseTemplate v-bind="{ data: something, msg: 'The third' }" />
</template>
```

### TypeScript Support

`createReusableTemplate` accepts a generic type to provide type support for the data passed to the template:

```vue
<script setup lang="ts">
import { createReusableTemplate } from '@vueuse/core'

// Comes with pair of `DefineTemplate` and `ReuseTemplate`
const [DefineTemplate, ReuseTemplate] = createReusableTemplate<{
  msg: string
}>()

// You can create multiple reusable templates
const [DefineFoo, ReuseFoo] = createReusableTemplate<{
  list: string[]
}>()
</script>

<template>
  <DefineFoo v-slot="{ msg }">
    <!-- `msg` is typed as `string` -->
    <div>Hello {{ msg.toUpperCase() }}</div>
  </DefineFoo>

  <ReuseFoo :msg="World" />

  <!-- @ts-expect-error Type Error! -->
  <ReuseFoo :msg="1" />
</template>
```

Optionally, if you are not a fan of array destructuring, the following usages are also legal:

```vue
<script setup lang="ts">
import { createReusableTemplate } from '@vueuse/core'

const { define: DefineFoo, reuse: ReuseFoo } = createReusableTemplate<{
  msg: string
}>()
</script>

<template>
  <DefineFoo v-slot="{ msg }">
    <div>Hello {{ msg.toUpperCase() }}</div>
  </DefineFoo>

  <ReuseFoo :msg="World" />
</template>
```

```vue
<script setup lang="ts">
import { createReusableTemplate } from '@vueuse/core'

const TemplateFoo = createReusableTemplate<{ msg: string }>()
</script>

<template>
  <TemplateFoo.define v-slot="{ msg }">
    <div>Hello {{ msg.toUpperCase() }}</div>
  </TemplateFoo.define>

  <TemplateFoo.reuse :msg="World" />
</template>
```

**WARNING:** Passing boolean props without `v-bind` is not supported. See the Caveats section for more details.

### Props and Attributes

By default, all props and attributes passed to `<ReuseTemplate>` will be passed to the template. If you don't want certain props to be passed to the DOM, you need to define the runtime props:

```ts
import { createReusableTemplate } from '@vueuse/core'

const [DefineTemplate, ReuseTemplate] = createReusableTemplate({
  props: {
    msg: String,
    data: Object,
  }
})
```

If you don't want to pass any props to the template, you can pass the `inheritAttrs` option:

```ts
import { createReusableTemplate } from '@vueuse/core'

const [DefineTemplate, ReuseTemplate] = createReusableTemplate({
  inheritAttrs: false,
})
```

### Passing Slots

It's also possible to pass slots back from `<ReuseTemplate>`. You can access the slots on `<DefineTemplate>` from `$slots`:

```vue
<script setup lang="ts">
import { createReusableTemplate } from '@vueuse/core'

const [DefineTemplate, ReuseTemplate] = createReusableTemplate()
</script>

<template>
  <DefineTemplate v-slot="{ $slots, msg }">
    <div some-layout>
      <!-- To render the slot -->
      <component :is="$slots.default" />
    </div>
  </DefineTemplate>

  <ReuseTemplate>
    <div>Some content</div>
  </ReuseTemplate>

  <ReuseTemplate>
    <div>Another content</div>
  </ReuseTemplate>
</template>
```

## Caveats

### Boolean props

As opposed to Vue's behavior, props defined as `boolean` that were passed without `v-bind` or absent will be resolved into an empty string or `undefined` respectively:

```vue
<script setup lang="ts">
import { createReusableTemplate } from '@vueuse/core'

const [DefineTemplate, ReuseTemplate] = createReusableTemplate<{
  bool?: boolean
}>()
</script>

<template>
  <DefineTemplate v-slot="{ bool }">
    {{ typeof bool }}: {{ bool }}
  </DefineTemplate>

  <ReuseTemplate :bool="true" />
  <!-- boolean: true -->

  <ReuseTemplate :bool="false" />
  <!-- boolean: false -->

  <ReuseTemplate bool />
  <!-- string: -->

  <ReuseTemplate />
  <!-- undefined: -->
</template>
```

## References

This function is migrated from [vue-reuse-template](https://github.com/antfu/vue-reuse-template).

Existing Vue discussions/issues about reusing template:

- [Discussion on Reusing Templates](https://github.com/vuejs/core/discussions/6898)

Alternative Approaches:

- [Vue Macros - `namedTemplate`](https://vue-macros.sxzz.moe/features/named-template.html)
- [`unplugin-vue-reuse-template`](https://github.com/liulinboyi/unplugin-vue-reuse-template)

## Type Declarations

```ts
type SlotData = Record<string, any> | undefined
type ExtractSlotData<T extends Record<string, any>> = {
  [K in keyof T]: Exclude<T[K]>
}
export type DefineComponent<
  Bindings extends Record<string, any>,
  Slots extends Record<string, any>,
> = Component & {
  new (): {
    $slots: {
      default: (
        bindings: Bindings & {
          $slots: ExtractSlotData<Slots>
        },
      ) => any
    }
  }
}
export type ReuseComponent<
  Bindings extends Record<string, any>,
  Slots extends Record<string, any>,
> = Component<Bindings> & {
  new (): {
    $slots: ExtractSlotData<Slots>
  }
}
export type ReusableTemplatePair<
  Bindings extends Record<string, any>,
  Slots extends Record<string, any>,
> = [
  DefineComponent<Bindings, Slots>,
  ReuseComponent<Bindings, Slots>,
] & {
  define: DefineComponent<Bindings, Slots>
  reuse: ReuseComponent<Bindings, Slots>
}
export interface CreateReusableTemplateOptions<
  Bindings extends Record<string, any>,
> {
  /**
   * Inherit attrs from reuse component.
   *
   * @default true
   */
  inheritAttrs?: boolean
  /**
   * Props definition for reuse component.
   */
  props?: ComponentProps<Bindings>
}
/**
 * This function creates `define` and `reuse` components in pair,
 * It also allow to pass a generic to bind with type.
 *
 * @see https://vueuse.org/createReusableTemplate
 */
export declare function createReusableTemplate<
  Bindings extends Record<string, any>,
  Slots extends Record<string, any> = Record<"default", undefined>,
>(
  options?: CreateReusableTemplateOptions<Bindings>,
): ReusableTemplatePair<Bindings, Slots>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/createReusableTemplate/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/createReusableTemplate/index.md)
