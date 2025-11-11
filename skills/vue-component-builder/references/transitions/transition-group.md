# TransitionGroup Component

Animate lists of elements entering/leaving the DOM.

## Basic List Transition

```vue
<script setup lang="ts">
import { ref } from 'vue'

interface Item {
  id: number
  name: string
}

const items = ref<Item[]>([
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' }
])

function addItem() {
  items.value.push({
    id: Date.now(),
    name: `Item ${items.value.length + 1}`
  })
}

function removeItem(id: number) {
  items.value = items.value.filter(item => item.id !== id)
}
</script>

<template>
  <button @click="addItem">Add Item</button>
  
  <TransitionGroup name="list" tag="ul">
    <li v-for="item in items" :key="item.id">
      {{ item.name }}
      <button @click="removeItem(item.id)">Remove</button>
    </li>
  </TransitionGroup>
</template>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}

.list-enter-from {
  opacity: 0;
  transform: translateX(-30px);
}

.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

/* Keep leaving items in layout during animation */
.list-leave-active {
  position: absolute;
}
</style>
```

## Move Transitions

```vue
<TransitionGroup name="list" tag="div">
  <div v-for="item in sortedItems" :key="item.id">
    {{ item.name }}
  </div>
</TransitionGroup>

<style>
.list-move, /* Apply transition to moving elements */
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

/* Ensure leaving items are taken out of layout flow */
.list-leave-active {
  position: absolute;
}
</style>
```

## Staggered Animations

```vue
<TransitionGroup
  name="stagger"
  tag="ul"
  :css="false"
  @before-enter="onBeforeEnter"
  @enter="onEnter"
  @leave="onLeave"
>
  <li v-for="(item, index) in items" :key="item.id" :data-index="index">
    {{ item.name }}
  </li>
</TransitionGroup>

<script setup lang="ts">
function onBeforeEnter(el: Element) {
  ;(el as HTMLElement).style.opacity = '0'
  ;(el as HTMLElement).style.transform = 'translateY(-20px)'
}

function onEnter(el: Element, done: () => void) {
  const index = parseInt((el as HTMLElement).dataset.index || '0')
  
  gsap.to(el, {
    opacity: 1,
    y: 0,
    duration: 0.5,
    delay: index * 0.1, // Stagger delay
    onComplete: done
  })
}

function onLeave(el: Element, done: () => void) {
  gsap.to(el, {
    opacity: 0,
    y: -20,
    duration: 0.3,
    onComplete: done
  })
}
</script>
```

## References

- [Vue 3 Official: TransitionGroup](https://vuejs.org/guide/built-ins/transition-group.html)

