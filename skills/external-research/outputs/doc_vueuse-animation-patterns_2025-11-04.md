# VueUse Animation Performance Patterns

**Generated:** 2025-11-04
**Purpose:** Performance-aware animation patterns for Socialaize Theater System
**Sources:** VueUse Core (useRafFn, useFps, useBattery), VueUse Motion

---

## useRafFn - Throttled RAF Loop

### Core Concept
Managed `requestAnimationFrame` loop with built-in controls, FPS limiting, and delta time tracking.

### Key Features

**1. Pausable Controls**
```typescript
const { pause, resume, isActive } = useRafFn(() => {
  // Animation logic
}, { immediate: true })

// pause() - Stop animation loop
// resume() - Restart animation loop
// isActive - Ref<boolean> indicating running state
```

**2. FPS Limiting (Reactive)**
```typescript
const targetFps = ref(30)

useRafFn(() => {
  updateGameLogic()
}, { fpsLimit: targetFps })

// Change FPS dynamically based on performance
targetFps.value = 60
```

**3. Delta Time Calculation**
```typescript
useRafFn(({ delta, timestamp }) => {
  // delta: ms since last frame
  // timestamp: DOMHighResTimeStamp since page load

  // Frame-independent movement
  position.value += velocity.value * (delta / 1000)
})
```

**4. Execute Once**
```typescript
useRafFn(() => {
  performInitialAnimation()
}, { once: true }) // Runs once on next frame, then stops
```

### When to Use vs Raw RAF

**Use `useRafFn` when:**
- ✅ Need pause/resume controls
- ✅ FPS limiting required
- ✅ Delta time needed for physics
- ✅ Managing multiple animation loops
- ✅ Want cleanup handled automatically

**Use raw RAF when:**
- ❌ Simple one-off animation
- ❌ Library already managing RAF (GSAP, Popmotion)
- ❌ Maximum performance critical (zero abstraction)

### Pattern: Adaptive FPS Based on Performance

```typescript
import { useRafFn } from '@vueuse/core'
import { useFps } from '@vueuse/core'

const fps = useFps({ every: 10 })
const targetFps = ref(60)

// Degrade FPS if actual FPS drops
watch(fps, (currentFps) => {
  if (currentFps < 30) {
    targetFps.value = 30 // Limit to 30fps
  } else if (currentFps > 50) {
    targetFps.value = 60 // Restore to 60fps
  }
})

useRafFn(() => {
  updateComplexAnimation()
}, { fpsLimit: targetFps })
```

---

## useFps - Performance Monitoring

### Core Concept
Reactive FPS counter that calculates frames per second with configurable sampling.

### API

```typescript
import { useFps } from '@vueuse/core'

const fps = useFps({ every: 10 }) // Calculate every 10 frames
// Returns: Ref<number> (current FPS)
```

### Options

- **`every`** (default: 10) - Calculate FPS on every X frames
  - Lower = more frequent updates, higher overhead
  - Higher = less overhead, slower reaction time

### Sampling Strategies

**Frequent (every: 5-10)** - Real-time monitoring
```typescript
const fps = useFps({ every: 5 })
// Use for: Live performance dashboards, debugging
```

**Balanced (every: 10-30)** - Adaptive quality
```typescript
const fps = useFps({ every: 15 })
// Use for: Dynamic quality adjustment
```

**Infrequent (every: 60)** - Long-term averages
```typescript
const fps = useFps({ every: 60 })
// Use for: Background monitoring, analytics
```

### Pattern: FPS-Based Quality Degradation

```typescript
import { useFps } from '@vueuse/core'
import { ref, watch } from 'vue'

const fps = useFps({ every: 10 })
const qualityLevel = ref<'high' | 'medium' | 'low'>('high')

watch(fps, (currentFps) => {
  if (currentFps < 20) {
    qualityLevel.value = 'low'
  } else if (currentFps < 40) {
    qualityLevel.value = 'medium'
  } else {
    qualityLevel.value = 'high'
  }
})

// Use qualityLevel to toggle features
const particleCount = computed(() => {
  return qualityLevel.value === 'high' ? 100
    : qualityLevel.value === 'medium' ? 50
    : 20
})
```

### Pattern: Throttled FPS Checks (Avoid Over-Reaction)

```typescript
import { useFps } from '@vueuse/core'
import { watchThrottled } from '@vueuse/core'

const fps = useFps({ every: 10 })
const qualityLevel = ref('high')

// Only check every 2 seconds to avoid jitter
watchThrottled(fps, (currentFps) => {
  // Adjust quality based on sustained FPS
  if (currentFps < 30) {
    qualityLevel.value = 'low'
  }
}, { throttle: 2000 })
```

---

## useBattery - Resource Awareness

### Core Concept
Reactive Battery Status API access for power-aware applications.

### API

```typescript
import { useBattery } from '@vueuse/core'

const { isSupported, charging, chargingTime, dischargingTime, level } = useBattery()

// charging: Ref<boolean> - Is device charging?
// level: Ref<number> - 0-1 battery level (0.5 = 50%)
// dischargingTime: Ref<number> - Seconds until dead
// chargingTime: Ref<number> - Seconds until full
```

### Battery Level Thresholds

**Critical (< 20%)** - Aggressive power saving
```typescript
if (level.value < 0.2 && !charging.value) {
  // Disable all non-essential features
  disableAnimations()
  disableBackgroundSync()
  disableAutoplay()
}
```

**Low (20-50%)** - Moderate power saving
```typescript
if (level.value < 0.5 && !charging.value) {
  // Reduce animation quality
  reduceParticleCount()
  lowerFpsLimit()
}
```

**Normal (> 50%)** - Full features
```typescript
if (level.value > 0.5 || charging.value) {
  // Enable all features
  enableFullQuality()
}
```

### Pattern: Battery-Aware Animation Degradation

```typescript
import { useBattery } from '@vueuse/core'
import { computed } from 'vue'

const { level, charging } = useBattery()

const animationQuality = computed(() => {
  // Always full quality when charging
  if (charging.value) return 'high'

  // Battery-based degradation
  if (level.value < 0.2) return 'none'      // < 20%: No animations
  if (level.value < 0.5) return 'low'       // < 50%: Minimal animations
  return 'medium'                            // > 50%: Balanced
})

const shouldAnimate = computed(() => animationQuality.value !== 'none')
const particleCount = computed(() => {
  switch (animationQuality.value) {
    case 'high': return 200
    case 'medium': return 100
    case 'low': return 30
    case 'none': return 0
  }
})
```

### Use Cases from VueUse Docs

1. **Trigger battery saver dark mode**
2. **Stop auto-playing videos**
3. **Disable background workers**
4. **Limit network calls**
5. **Reduce CPU/Memory consumption**

---

## VueUse Motion - Alternative Approach

### Core Concept
Declarative animation library built on Popmotion with Vue reactivity integration.

### Installation

```bash
yarn add @vueuse/motion
```

### Two Usage Patterns

**1. Directive-Based (v-motion)**
```vue
<script setup>
import { MotionPlugin } from '@vueuse/motion'
// Install globally or per-component
</script>

<template>
  <div v-motion="{
    initial: { opacity: 0, y: 100 },
    enter: { opacity: 1, y: 0 }
  }">
    Content
  </div>
</template>
```

**2. Composable-Based (useMotion)**
```vue
<script setup>
import { useMotion } from '@vueuse/motion'

const target = ref<HTMLElement>()

const motionInstance = useMotion(target, {
  initial: { opacity: 0, y: 100 },
  enter: { opacity: 1, y: 0 }
})
</script>

<template>
  <div ref="target">Content</div>
</template>
```

### Performance Characteristics

**Pros:**
- ✅ Built on Popmotion (battle-tested animation engine)
- ✅ Declarative variants system
- ✅ Spring physics built-in
- ✅ SSR-safe (detects client-side)
- ✅ Vue reactivity integration
- ✅ Small bundle (~8KB gzipped)

**Cons:**
- ❌ Another dependency (vs custom RAF)
- ❌ Less control over RAF loop
- ❌ Harder to integrate with existing animation system

### When to Use VueUse Motion vs Custom

**Use VueUse Motion when:**
- ✅ Starting greenfield project
- ✅ Need spring physics
- ✅ Want declarative variants
- ✅ Prefer less code

**Use Custom System when:**
- ✅ Already invested in custom system (our case)
- ✅ Need tight RAF control
- ✅ Integrating with GSAP/other library
- ✅ Maximum bundle size optimization

---

## Application to Our Theater System

### Current System (src/components/vue/animations/)

**Architecture:**
```
useAnimation (2803 lines)
├── useAnimateElement (335 lines) - Simplified API
├── useAnimationPresets (216 lines) - Advanced patterns
└── constants/animations.ts - DURATION, EASING
```

### Recommended Integration

#### 1. Add Performance Monitoring Layer

**Create:** `src/composables/useAnimationEnvironment.ts`
```typescript
import { useFps } from '@vueuse/core'
import { useBattery } from '@vueuse/core'
import { computed, ref } from 'vue'

export function useAnimationEnvironment() {
  const fps = useFps({ every: 15 })
  const { level: batteryLevel, charging } = useBattery()

  const qualityLevel = computed(() => {
    // Battery critical - no animations
    if (batteryLevel.value < 0.2 && !charging.value) {
      return 'none'
    }

    // Low FPS - degrade
    if (fps.value < 20) return 'low'
    if (fps.value < 40) return 'medium'

    // Battery low - cap at medium
    if (batteryLevel.value < 0.5 && !charging.value) {
      return 'medium'
    }

    return 'high'
  })

  const getRecommendedDuration = (baseDuration: number) => {
    switch (qualityLevel.value) {
      case 'none': return 0
      case 'low': return baseDuration * 0.5
      case 'medium': return baseDuration * 0.75
      case 'high': return baseDuration
    }
  }

  const shouldUseReducedMotion = computed(() => {
    return qualityLevel.value === 'none' ||
      window.matchMedia('(prefers-reduced-motion: reduce)').matches
  })

  return {
    qualityLevel,
    fps,
    batteryLevel,
    charging,
    getRecommendedDuration,
    shouldUseReducedMotion
  }
}
```

#### 2. Integrate with Existing useAnimation

**Update:** `src/components/vue/animations/composables/useAnimation.ts`
```typescript
import { useAnimationEnvironment } from '@/composables/useAnimationEnvironment'

export function useAnimation(element, options) {
  const env = useAnimationEnvironment()

  // Adjust duration based on environment
  const adjustedDuration = computed(() => {
    const base = options.duration ?? ANIMATION_DURATION.NORMAL
    return env.getRecommendedDuration(base)
  })

  // Skip animations if reduced motion
  const shouldSkip = computed(() => env.shouldUseReducedMotion.value)

  // ... rest of implementation
}
```

#### 3. Add FPS-Limited RAF for Heavy Animations

**Create:** `src/composables/useAnimationLoop.ts`
```typescript
import { useRafFn } from '@vueuse/core'
import { useAnimationEnvironment } from '@/composables/useAnimationEnvironment'

export function useAnimationLoop(callback: (args: { delta: number }) => void) {
  const env = useAnimationEnvironment()

  // Adaptive FPS limiting
  const targetFps = computed(() => {
    switch (env.qualityLevel.value) {
      case 'high': return undefined // No limit
      case 'medium': return 60
      case 'low': return 30
      case 'none': return 0
    }
  })

  const { pause, resume, isActive } = useRafFn(callback, {
    fpsLimit: targetFps,
    immediate: true
  })

  // Auto-pause when quality is 'none'
  watch(() => env.qualityLevel.value, (level) => {
    if (level === 'none') pause()
    else if (!isActive.value) resume()
  })

  return { pause, resume, isActive }
}
```

#### 4. Update Animation Presets

**Update:** `src/components/vue/animations/composables/useAnimationPresets.ts`
```typescript
import { useAnimationEnvironment } from '@/composables/useAnimationEnvironment'

export function useAnimationPresets() {
  const env = useAnimationEnvironment()

  const orbitingIcon = async (element, options) => {
    // Skip if reduced motion
    if (env.shouldUseReducedMotion.value) {
      return Promise.resolve()
    }

    // Adjust duration based on environment
    const duration = env.getRecommendedDuration(options.duration ?? 3000)

    // ... rest of implementation
  }

  return { orbitingIcon, fadeInUp, pulseLoop, ... }
}
```

### Migration Strategy

**Phase 1: Add Monitoring (Non-Breaking)**
1. Install VueUse Core: `pnpm add @vueuse/core`
2. Create `useAnimationEnvironment` composable
3. Add to existing components (opt-in)

**Phase 2: Integrate with Existing System**
1. Update `useAnimation` to respect environment
2. Update `useAnimateElement` to check reduced motion
3. Add `useAnimationLoop` for RAF-heavy animations

**Phase 3: Optimize Heavy Animations**
1. Identify particle systems, complex sequences
2. Migrate to `useAnimationLoop` with FPS limiting
3. Add battery-aware degradation

**Phase 4: Bundle Size Audit**
1. Measure impact of VueUse Core
2. Tree-shake unused composables
3. Consider unbuild for smaller bundles

### Decision Matrix

| Feature | Custom RAF | useRafFn | VueUse Motion |
|---------|-----------|----------|---------------|
| Bundle Size | ~0KB | ~0.5KB | ~8KB |
| FPS Limiting | Manual | Built-in | N/A |
| Pause/Resume | Manual | Built-in | Built-in |
| Delta Time | Manual | Built-in | N/A |
| Spring Physics | Manual | Manual | Built-in |
| Declarative | No | No | Yes |
| RAF Control | Full | Full | Limited |
| Learning Curve | High | Low | Medium |

### Recommendation

**Keep existing animation system** (useAnimation, useAnimateElement, useAnimationPresets) but **enhance with VueUse utilities**:

1. **Use `useFps`** - Monitor performance
2. **Use `useBattery`** - Power-aware degradation
3. **Use `useRafFn`** - For new RAF loops (replace manual RAF)
4. **Skip VueUse Motion** - Too much overlap with existing system

This gives us:
- ✅ Best of both worlds (existing + monitoring)
- ✅ Minimal bundle impact (~1KB)
- ✅ Zero breaking changes
- ✅ Gradual migration path
- ✅ Resource-aware animations

---

## Code Examples

### Example 1: Adaptive Particle System

```typescript
import { useAnimationLoop } from '@/composables/useAnimationLoop'
import { useAnimationEnvironment } from '@/composables/useAnimationEnvironment'

export function useParticleSystem(canvas: Ref<HTMLCanvasElement>) {
  const env = useAnimationEnvironment()
  const ctx = computed(() => canvas.value?.getContext('2d'))

  const particleCount = computed(() => {
    switch (env.qualityLevel.value) {
      case 'high': return 200
      case 'medium': return 100
      case 'low': return 30
      case 'none': return 0
    }
  })

  const particles = ref<Particle[]>([])

  const { pause, resume } = useAnimationLoop(({ delta }) => {
    // Skip if no canvas
    if (!ctx.value) return

    // Adjust particle count dynamically
    while (particles.value.length < particleCount.value) {
      particles.value.push(createParticle())
    }
    while (particles.value.length > particleCount.value) {
      particles.value.pop()
    }

    // Update and render
    particles.value.forEach(p => {
      p.update(delta)
      p.render(ctx.value!)
    })
  })

  return { pause, resume, particleCount }
}
```

### Example 2: Battery-Aware Video Autoplay

```vue
<script setup lang="ts">
import { useBattery } from '@vueuse/core'
import { computed } from 'vue'

const { level, charging } = useBattery()

const shouldAutoplay = computed(() => {
  // Never autoplay on low battery
  if (level.value < 0.2 && !charging.value) return false

  // Cautious autoplay on medium battery
  if (level.value < 0.5 && !charging.value) return false

  return true
})
</script>

<template>
  <video :autoplay="shouldAutoplay" :muted="shouldAutoplay">
    <source src="video.mp4" type="video/mp4">
  </video>
</template>
```

### Example 3: FPS-Based Animation Quality

```typescript
import { useFps } from '@vueuse/core'
import { watchThrottled } from '@vueuse/core'
import { ANIMATION_DURATION } from '@/constants/animations'

export function useAdaptiveAnimations() {
  const fps = useFps({ every: 15 })
  const qualityLevel = ref<'high' | 'medium' | 'low'>('high')

  // Check FPS every 2 seconds
  watchThrottled(fps, (currentFps) => {
    if (currentFps < 20) qualityLevel.value = 'low'
    else if (currentFps < 40) qualityLevel.value = 'medium'
    else qualityLevel.value = 'high'
  }, { throttle: 2000 })

  const getDuration = (base: number) => {
    switch (qualityLevel.value) {
      case 'low': return base * 0.5
      case 'medium': return base * 0.75
      case 'high': return base
    }
  }

  return {
    qualityLevel,
    fps,
    getDuration,
    normalDuration: computed(() => getDuration(ANIMATION_DURATION.NORMAL)),
    fastDuration: computed(() => getDuration(ANIMATION_DURATION.FAST))
  }
}
```

---

## Performance Checklist

**Before deploying animations:**

- [ ] Monitor FPS with `useFps`
- [ ] Degrade quality when FPS < 30
- [ ] Check battery level with `useBattery`
- [ ] Disable heavy animations when battery < 20%
- [ ] Respect `prefers-reduced-motion`
- [ ] Use `useRafFn` with `fpsLimit` for heavy loops
- [ ] Provide delta time for frame-independent animations
- [ ] Pause animations when tab not visible
- [ ] Test on low-end devices (throttle CPU in DevTools)
- [ ] Measure bundle size impact (< 2KB for monitoring)

---

## References

- [VueUse Core - useRafFn](https://vueuse.org/core/useRafFn/)
- [VueUse Core - useFps](https://vueuse.org/core/useFps/)
- [VueUse Core - useBattery](https://vueuse.org/core/useBattery/)
- [VueUse Motion - Docs](https://motion.vueuse.org/)
- [Battery Status API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Battery_Status_API)
- [requestAnimationFrame - MDN](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame)

---

**Next Steps:**
1. Implement `useAnimationEnvironment` composable
2. Add FPS/battery monitoring to Theater System
3. Test degradation thresholds on real devices
4. Measure bundle size impact
5. Add performance monitoring dashboard (dev mode)
