# @vueuse/motion Documentation

Complete documentation for @vueuse/motion package scraped from https://motion.vueuse.org

## Overview

@vueuse/motion is a Vue composables library for putting components in motion with:
- Smooth animations based on Popmotion
- Declarative API inspired by Framer Motion
- 20+ built-in presets
- SSR Ready
- First-class Nuxt 3 support
- Written in TypeScript
- Lightweight (<20kb bundle size)

## Documentation Files

### Getting Started
- `motion-home.md` - Package overview and features
- `motion-introduction.md` - Installation and plugin setup
- `motion-nuxt.md` - Nuxt-specific usage and SSR support

### Core Concepts
- `motion-directive-usage.md` - Using v-motion directive in templates
- `motion-composable-usage.md` - Using useMotion composable in setup
- `motion-components.md` - <Motion> and <MotionGroup> components
- `motion-motion-instance.md` - Motion instance API (variant, apply, stop)
- `motion-variants.md` - Variant system (initial, enter, visible, hovered, etc.)
- `motion-motion-properties.md` - Animatable properties (style & transform)
- `motion-transition-properties.md` - Transition configuration (spring, keyframes, etc.)
- `motion-presets.md` - 20+ built-in animation presets

### Composables (API)
- `motion-useMotion.md` - Core composable for creating animations
- `motion-useMotions.md` - Access named motion instances from templates
- `motion-useSpring.md` - Spring animation composable
- `motion-useMotionProperties.md` - Motion properties management
- `motion-useMotionVariants.md` - Variant state management
- `motion-useMotionTransitions.md` - Animation transitions management
- `motion-useMotionControls.md` - Motion control functions (apply, set, stop)
- `motion-useMotionFeatures.md` - Feature registration (lifecycle, visibility, events)

### Utilities
- `motion-useElementStyle.md` - Sync reactive object to element CSS style
- `motion-useElementTransform.md` - Sync reactive object to element CSS transform
- `motion-reactiveStyle.md` - Create reactive style object
- `motion-reactiveTransform.md` - Create reactive transform object

## Quick Reference

### Directive Usage
```vue
<div
  v-motion
  :initial="{ opacity: 0, y: 100 }"
  :enter="{ opacity: 1, y: 0 }"
  :visible="{ scale: 1.1 }"
  :hovered="{ scale: 1.2 }"
/>
```

### Composable Usage
```vue
<script setup>
import { useMotion } from '@vueuse/motion'

const target = ref()
const { variant } = useMotion(target, {
  initial: { opacity: 0 },
  enter: { opacity: 1 }
})
</script>
```

### Component Usage
```vue
<Motion
  is="p"
  preset="slideVisibleLeft"
  :delay="200"
>
  Text in Motion!
</Motion>
```

## Common Patterns

### Lifecycle Variants
- `initial` - Applied before mount
- `enter` - Applied after mount
- `leave` - Applied when leaving DOM

### Visibility Variants
- `visible` - Applied when in viewport (resets when out)
- `visible-once` - Applied once when entering viewport

### Event Variants
- `hovered` - Applied on hover
- `focused` - Applied on focus
- `tapped` - Applied on click/tap

### Transition Types
- **Spring** - Natural physics-based animations (stiffness, damping, mass)
- **Keyframes** - Duration-based animations (duration, ease)

### Presets
All presets available as `v-motion-[preset-name]`:
- fade, pop, slide-[direction], roll-[direction]
- Add `-visible` or `-visible-once` suffix for viewport triggers
- Directions: left, right, top, bottom

## Installation

```bash
yarn add @vueuse/motion
```

### Global Plugin
```js
import { MotionPlugin } from '@vueuse/motion'
app.use(MotionPlugin)
```

### Nuxt Module
```js
// nuxt.config.js
modules: ['@vueuse/motion/nuxt']
```

## Resources
- GitHub: https://github.com/vueuse/motion
- Documentation: https://motion.vueuse.org
- Based on: Popmotion.io
