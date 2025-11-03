# createTemplatePromise

**Category**: Component
**Export Size**: 390 B
**Last Changed**: last week

Template as Promise. Useful for constructing custom Dialogs, Modals, Toasts, etc.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/createTemplatePromise/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXnfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

## Usage

### Vue

```vue
<script setup lang="ts">
import { createTemplatePromise } from '@vueuse/core'

const TemplatePromise = createTemplatePromise<ReturnType>()

async function open() {
  const result = await TemplatePromise.start() // button is clicked, result is 'ok'
}
</script>

<template>
  <TemplatePromise v-slot="{ promise, resolve, reject, args }">
    <!-- your UI -->
    <button @click="resolve('ok')"> OK </button>
  </TemplatePromise>
</template>
```

## Features

Programmatic - call your UI as a promise
Template - use Vue template to render, not a new DSL
TypeScript - full type safety via generic type
Renderless - you take full control of the UI
Transition - use support Vue transition

This function is migrated from vue-template-promise

## Usage

`createTemplatePromise` returns a Vue Component that you can directly use in your template with `<script setup>`

```ts
import { createTemplatePromise } from '@vueuse/core'

const TemplatePromise = createTemplatePromise()
const MyPromise = createTemplatePromise<boolean>() // with generic type
```

In template, use `v-slot` to access the promise and resolve functions.

```vue
<template>
  <TemplatePromise v-slot="{ promise, resolve, reject, args }">
    <!-- you can have anything -->
    <button @click="resolve('ok')"> OK </button>
  </TemplatePromise>
  <MyPromise v-slot="{ promise, resolve, reject, args }">
    <!-- another one -->
  </MyPromise>
</template>
```

The slot will not be rendered initially (similar to `v-if="false"` ), until you call the start method from the component.

```ts
const result = await TemplatePromise.start()
```

Once resolve or reject is called in the template, the promise will be resolved or rejected, returning the value you passed in. Once resolved, the slot will be removed automatically.

### Passing Arguments

You can pass arguments to the start with arguments.

```ts
import { createTemplatePromise } from '@vueuse/core'

const TemplatePromise = createTemplatePromise<boolean, [string, number]>()
```

And in the template slot, you can access the arguments via `args` property.

```vue
<template>
  <TemplatePromise v-slot="{ args, resolve }">
    <div>{{ args[0] }}</div>
    <!-- hello -->
    <div>{{ args[1] }}</div>
    <!-- 123 -->
    <button @click="resolve(true)"> OK </button>
  </TemplatePromise>
</template>
```

### Transition

You can use transition to animate the slot.

```vue
<script setup lang="ts">
const TemplatePromise = createTemplatePromise<ReturnType>({
  transition: {
    name: 'fade',
    appear: true,
  },
})
</script>

<template>
  <TemplatePromise v-slot="{ resolve }">
    <!-- your UI -->
    <button @click="resolve('ok')"> OK </button>
  </TemplatePromise>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.5s; }
.fade-enter, .fade-leave-to { opacity: 0; }
</style>
```

Learn more about [Vue Transition](https://vuejs.org/guide/built-ins/transition.html).

## Motivation

The common approach to call a dialog or a modal programmatically would be like this:

```ts
const dialog = useDialog()
const result = await dialog.open({
  title: 'Hello',
  content: 'World',
})
```

This would work by sending these information to the top-level component and let it render the dialog. However, it limits the flexibility you could express in the UI. For example, you could want the title to be red, or have extra buttons, etc. You would end up with a lot of options like:

```ts
const result = await dialog.open({
  title: 'Hello',
  titleClass: 'text-red',
  content: 'World',
  contentClass: 'text-blue text-sm',
  buttons: [ {
    text: 'OK',
    class: 'bg-red',
    onClick: () => {}
  }, {
    text: 'Cancel',
    class: 'bg-blue',
    onClick: () => {}
  }, ], // ...
})
```

Even this is not flexible enough. If you want more, you might end up with manual render function.

```ts
const result = await dialog.open({
  title: 'Hello',
  contentSlot: () => h(MyComponent, { content }),
})
```

This is like reinventing a new DSL in the script to express the UI template.

So this function allows expressing the UI in templates instead of scripts, where it is supposed to be, while still being able to be manipulated programmatically.

## Type Declarations

```ts
export interface TemplatePromiseProps < Return , Args extends any[] = []> {
  /**
   * The promise instance.
   */
  promise : Promise < Return > | undefined
  /**
   * Resolve the promise.
   */
  resolve : ( v : Return | Promise < Return >) => void
  /**
   * Reject the promise.
   */
  reject : ( v : any) => void
  /**
   * Arguments passed to TemplatePromise.start()
   */
  args : Args
  /**
   * Indicates if the promise is resolving.
   * When passing another promise to `resolve`, this will be set to `true` until the promise is resolved.
   */
  isResolving : boolean
  /**
   * Options passed to createTemplatePromise()
   */
  options : TemplatePromiseOptions
  /**
   * Unique key for list rendering.
   */
  key : number
}

export interface TemplatePromiseOptions {
  /**
   * Determines if the promise can be called only once at a time.
   *
   * @default false
   */
  singleton ?: boolean
  /**
   * Transition props for the promise.
   */
  transition ?: TransitionGroupProps
}

export type TemplatePromise < Return , Args extends any[] = [], > = DefineComponent <object> & {
  new (): {
    $slots : {
      default : ( _ : TemplatePromiseProps < Return , Args >) => any
    }
  }
} & {
  start : (... args : Args ) => Promise < Return >
}

/**
 * Creates a template promise component.
 *
 * @see https://vueuse.org/createTemplatePromise
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function createTemplatePromise < Return , Args extends any[] = []>( options ?: TemplatePromiseOptions, ): TemplatePromise < Return , Args >
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/createTemplatePromise/index.ts) • [Demo](https://vueuse.org/core/createTemplatePromise/#demo) • [Docs](https://vueuse.org/core/createTemplatePromise/)

## Contributors

* Anthony Fu
* Anthony Fu
* SerKo
* Arthur Darkstone
* Robin
* David Gonzalez
* ethmcc
* Aaron-zon
* Haoqun Jiang
* Bruce

## Changelog

* **v14.0.0-alpha.3** on 9/16/2025
  * `5fd3a` - fix: update return type of createReusableTemplate and createTemplateP… (#4962)
* **v13.6.0** on 7/28/2025
  * `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.8.0** on 2/20/2024
  * `a086e` - fix: stricter types
* **v10.1.1** on 5/1/2023
  * `fc8cf` - fix: temporarily work around the type error in vue 3.3 (#3042)
* **v10.0.0-beta.5** on 4/13/2023
  * `13169` - feat: new function (#2957)
