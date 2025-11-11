# Transition Component

Vue's `<Transition>` component provides enter/leave animations.

## Basic Transition

```vue
<script setup lang="ts">
import { ref } from 'vue'

const show = ref(false)
</script>

<template>
  <button @click="show = !show">Toggle</button>
  
  <Transition name="fade">
    <p v-if="show">Hello Vue!</p>
  </Transition>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
```

## Transition Classes

Vue automatically applies these classes:

- `v-enter-from` - Start state for enter
- `v-enter-active` - Active state during enter
- `v-enter-to` - End state for enter
- `v-leave-from` - Start state for leave
- `v-leave-active` - Active state during leave
- `v-leave-to` - End state for leave

## Custom Transition Name

```vue
<Transition name="slide">
  <div v-if="show">Content</div>
</Transition>

<style>
.slide-enter-active {
  transition: all 0.3s ease-out;
}

.slide-leave-active {
  transition: all 0.3s ease-in;
}

.slide-enter-from {
  transform: translateX(-20px);
  opacity: 0;
}

.slide-leave-to {
  transform: translateX(20px);
  opacity: 0;
}
</style>
```

## Transition Modes

```vue
<!-- out-in: Old element leaves first, then new enters -->
<Transition name="fade" mode="out-in">
  <component :is="currentComponent" />
</Transition>

<!-- in-out: New element enters first, then old leaves -->
<Transition name="fade" mode="in-out">
  <component :is="currentComponent" />
</Transition>
```

## JavaScript Hooks

```vue
<Transition
  @before-enter="onBeforeEnter"
  @enter="onEnter"
  @after-enter="onAfterEnter"
  @enter-cancelled="onEnterCancelled"
  @before-leave="onBeforeLeave"
  @leave="onLeave"
  @after-leave="onAfterLeave"
  @leave-cancelled="onLeaveCancelled"
>
  <div v-if="show">Content</div>
</Transition>

<script setup lang="ts">
function onBeforeEnter(el: Element) {
  // Before enter animation starts
}

function onEnter(el: Element, done: () => void) {
  // Enter animation
  // Call done() when animation completes
  setTimeout(done, 300)
}

function onAfterEnter(el: Element) {
  // After enter animation completes
}
</script>
```

## CSS-Only Transitions

```vue
<Transition name="fade" :css="false">
  <div v-if="show">Content</div>
</Transition>
```

## References

- [Vue 3 Official: Transition](https://vuejs.org/guide/built-ins/transition.html)

