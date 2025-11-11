# Motion Library (@vueuse/motion)

### Installation

```bash
npm install @vueuse/motion
```

**Plugin Setup (in main.ts or _vueEntrypoint.ts):**
```typescript
import { MotionPlugin } from '@vueuse/motion'
import { createApp } from 'vue'

const app = createApp(App)
app.use(MotionPlugin) // Global v-motion directive
app.mount('#app')
```

---

### Directive Usage (v-motion)

**Basic Pattern:**
```vue
<template>
  <div
    v-motion
    :initial="{ opacity: 0, y: 100 }"
    :enter="{ opacity: 1, y: 0 }"
    :leave="{ opacity: 0, y: -100 }"
  >
    Animated content
  </div>
</template>
```

**With Variants:**
```vue
<script setup>
const variants = {
  initial: { opacity: 0, scale: 0.8 },
  enter: {
    opacity: 1,
    scale: 1,
    transition: {
      duration: 300,
      ease: 'easeOut'
    }
  },
  leave: { opacity: 0, scale: 0.8 }
}
</script>

<template>
  <div v-motion :variants="variants">
    Animated with variants
  </div>
</template>
```

---

### Composable Usage (useMotion)

**Programmatic Control:**
```vue
<script setup>
import { useMotion } from '@vueuse/motion'
import { ref } from 'vue'

const target = ref()

const { variant, apply } = useMotion(target, {
  initial: { opacity: 0, x: -100 },
  enter: { opacity: 1, x: 0 },
  hovered: { scale: 1.1 },
  tapped: { scale: 0.95 }
})

function handleHover() {
  variant.value = 'hovered'
}

function handleMouseLeave() {
  variant.value = 'enter'
}
</script>

<template>
  <div
    ref="target"
    @mouseenter="handleHover"
    @mouseleave="handleMouseLeave"
  >
    Animated with programmatic control
  </div>
</template>
```

---

### Presets

**Built-in Animation Presets:**
```vue
<template>
  <div v-motion-fade>Fade in</div>
  <div v-motion-slide-left>Slide from left</div>
  <div v-motion-slide-right>Slide from right</div>
  <div v-motion-slide-top>Slide from top</div>
  <div v-motion-slide-bottom>Slide from bottom</div>
  <div v-motion-pop>Pop in</div>
  <div v-motion-roll-left>Roll from left</div>
</template>
```

**Docs:** [motion-presets.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-presets.md)

---

### Spring Physics (useSpring)

**Natural Motion:**
```vue
<script setup>
import { useSpring } from '@vueuse/motion'
import { ref } from 'vue'

const x = ref(0)
const springX = useSpring(x, {
  stiffness: 100,
  damping: 10,
  mass: 1
})

function moveRight() {
  x.value = 300 // Spring animates to new value
}
</script>

<template>
  <div
    :style="{ transform: `translateX(${springX}px)` }"
    @click="moveRight"
  >
    Click to move with spring physics
  </div>
</template>
```

---

### Scroll-Based Animations

**Trigger animations on scroll:**
```vue
<script setup>
import { useElementVisibility } from '@vueuse/core'
import { useMotion } from '@vueuse/motion'
import { ref, watch } from 'vue'

const target = ref()
const isVisible = useElementVisibility(target)

const { variant } = useMotion(target, {
  initial: { opacity: 0, y: 100 },
  visible: { opacity: 1, y: 0 }
})

watch(isVisible, (visible) => {
  variant.value = visible ? 'visible' : 'initial'
})
</script>

<template>
  <div ref="target">
    Animates when scrolled into view
  </div>
</template>
```

---

### Motion + Accessibility

**Respect user preferences:**
```vue
<script setup>
import { usePreferredReducedMotion } from '@vueuse/core'
import { computed } from 'vue'

const prefersReducedMotion = usePreferredReducedMotion()

const motionVariants = computed(() => {
  if (prefersReducedMotion.value === 'reduce') {
    // Disable animations
    return {
      initial: { opacity: 1 },
      enter: { opacity: 1 }
    }
  }

  // Full animations
  return {
    initial: { opacity: 0, y: 100 },
    enter: { opacity: 1, y: 0 }
  }
})
</script>

<template>
  <div v-motion :variants="motionVariants">
    Respects user motion preferences
  </div>
</template>
```

**Motion Docs:**
- [motion-introduction.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-introduction.md)
- [motion-directive-usage.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-directive-usage.md)
- [motion-variants.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/motion-variants.md)
- [useMotion.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useMotion.md)
- [useSpring.md](file:///Users/natedamstra/.claude/documentation/vue/vueuse/useSpring.md)
