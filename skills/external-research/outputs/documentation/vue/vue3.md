# Vue 3

This document provides a summary of the most relevant Vue 3 features for this project.

## Reactivity Fundamentals

Vue's reactivity system is what allows it to automatically update the view when data changes. The core of this system is the `ref` and `reactive` functions.

### `ref`

A `ref` is a reactive data source that holds a single value. This value can be a primitive (like a string or number) or an object.

To access the value of a ref, you need to use the `.value` property.

```javascript
import { ref } from 'vue';

const count = ref(0);

console.log(count.value); // 0

count.value++;

console.log(count.value); // 1
```

When a ref is used in a template, it is automatically unwrapped, so you don't need to use `.value`.

```vue
<template>
  <div>{{ count }}</div>
</template>

<script setup>
import { ref } from 'vue';

const count = ref(0);
</script>
```

### `reactive`

The `reactive` function takes an object and returns a reactive proxy of the original object. This means that any changes to the properties of the object will be tracked by Vue.

```javascript
import { reactive } from 'vue';

const state = reactive({ count: 0 });

state.count++;
```

**Limitations of `reactive`:**

*   It only works for object types (objects, arrays, and collection types).
*   You cannot replace the entire object, as this will break the reactivity.
*   It is not destructure-friendly.

For these reasons, it is recommended to use `ref` as the primary API for declaring reactive state.

### `computed`

A computed property is a value that is derived from other reactive data. It is automatically updated when its dependencies change.

```javascript
import { ref, computed } from 'vue';

const count = ref(0);
const double = computed(() => count.value * 2);

console.log(double.value); // 0

count.value++;

console.log(double.value); // 2
```

### `watch`

The `watch` function can be used to perform side effects in response to changes in reactive data.

```javascript
import { ref, watch } from 'vue';

const count = ref(0);

watch(count, (newValue, oldValue) => {
  console.log(`count changed from ${oldValue} to ${newValue}`);
});

count.value++; // logs "count changed from 0 to 1"
```

## Component Registration

Components need to be registered before they can be used. There are two ways to register components: global and local.

### Global Registration

Globally registered components can be used in the template of any component within the application.

```javascript
import { createApp } from 'vue';
import MyComponent from './MyComponent.vue';

const app = createApp({});

app.component('MyComponent', MyComponent);
```

### Local Registration

Locally registered components are only available in the component where they are registered. This is the recommended approach for most applications, as it makes dependency relationships more explicit and is more "tree-shaking" friendly.

When using Single-File Components (SFCs) with `<script setup>`, imported components can be used directly without explicit registration.

```vue
<script setup>
import ComponentA from './ComponentA.vue';
</script>

<template>
  <ComponentA />
</template>
```

In non-`<script setup>` contexts, you need to use the `components` option:

```javascript
import ComponentA from './ComponentA.js';

export default {
  components: {
    ComponentA,
  },
  setup() {
    // ...
  },
};
```

## Template Syntax

Vue uses an HTML-based template syntax that allows you to declaratively bind the rendered DOM to the underlying component instance's data.

### Text Interpolation

The most basic form of data binding is text interpolation using the "Mustache" syntax (double curly braces):

```vue
<span>Message: {{ msg }}</span>
```

### `v-if`

The `v-if` directive is used to conditionally render a block. The block will only be rendered if the directive's expression returns a truthy value.

```vue
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else>
  C
</div>
```

### `v-for`

The `v-for` directive is used to render a list of items based on an array.

```vue
<ul id="example-1">
  <li v-for="item in items" :key="item.message">
    {{ item.message }}
  </li>
</ul>
```

### `v-bind`

The `v-bind` directive is used to reactively update an HTML attribute. The shorthand is a colon (`:`).

```vue
<div :class="{ active: isActive }"></div>
```

### `v-on`

The `v-on` directive is used to listen to DOM events. The shorthand is the at symbol (`@`).

```vue
<button @click="doSomething">Click me</button>
```

## Lifecycle Hooks

Each Vue component instance goes through a series of initialization steps when it's created. You can use lifecycle hooks to run code at specific stages of a component's lifecycle.

### `onMounted`

The `onMounted` hook is called after the component has been mounted to the DOM. This is a good place to perform any DOM-related operations.

```vue
<script setup>
import { ref, onMounted } from 'vue';

const el = ref(null);

onMounted(() => {
  el.value.focus();
});
</script>

<template>
  <input ref="el" />
</template>
```

### `onUpdated`

The `onUpdated` hook is called after the component has updated its DOM tree due to a reactive state change.

```vue
<script setup>
import { ref, onUpdated } from 'vue';

const count = ref(0);

onUpdated(() => {
  console.log(`The count is now: ${count.value}`);
});
</script>

<template>
  <button @click="count++">{{ count }}</button>
</template>
```

### `onUnmounted`

The `onUnmounted` hook is called just before a component instance is unmounted. This is a good place to clean up any side effects, such as timers or event listeners.

```vue
<script setup>
import { onMounted, onUnmounted } from 'vue';

let intervalId;

onMounted(() => {
  intervalId = setInterval(() => {
    // ...
  }, 1000);
});

onUnmounted(() => clearInterval(intervalId));
</script>

## Composition API

The Composition API is a set of APIs that allows us to author Vue components using imported functions instead of declaring options. It is a more flexible and reusable way to organize component logic.

### `setup` Function

The `setup` function is a new component option that serves as the entry point for the Composition API. It is executed before the component instance is created, and it receives the component's `props` and `context` as arguments.

**Key Aspects:**

*   **Execution Timing:** `setup` is called before the `beforeCreate` and `created` hooks.
*   **`this` is not available:** Since `setup` is called before the component instance is created, `this` is not available inside `setup`.
*   **Arguments:**
    *   `props`: A reactive object containing the component's props.
    *   `context`: An object that exposes `attrs`, `slots`, and `emit`.
*   **Return Value:** The `setup` function should return an object. The properties of this object will be merged into the component's render context and will be accessible in the template.

**Usage with `<script setup>`:**

For Single-File Components (SFCs), it is recommended to use the `<script setup>` syntax, which is a compile-time syntactic sugar that greatly improves the ergonomics of the Composition API.

```vue
<script setup>
import { ref, onMounted } from 'vue';

// reactive state
const count = ref(0);

// functions
function increment() {
  count.value++;
}

// lifecycle hooks
onMounted(() => {
  console.log(`The initial count is ${count.value}.`);
});
</script>

<template>
  <button @click="increment">{{ count }}</button>
</template>
```
```
