# Animation Performance Resilience Research
**Date:** 2025-11-04
**Topic:** Performance-resilient animation systems under resource pressure
**Focus:** Preventing cascade restarts, RAF best practices, adaptive degradation

---

## Executive Summary

Animation theater systems randomly restarting under load is caused by:
1. **RAF cascade loops** - Multiple restarts triggering each other
2. **Environment detection thrashing** - FPS monitoring causing excessive restarts
3. **Timing race conditions** - Timeout vs RAF coordination failures
4. **Frame budget violations** - Work exceeding 16.67ms budget

**Key Solution Patterns:**
- Centralized animation manager with single RAF loop
- Hysteresis thresholds for performance state transitions
- Frame synchronization with delta time compensation
- Priority queue system for animation scheduling
- Graceful degradation with adaptive quality levels

---

## 1. Cascade Prevention Patterns

### Problem: Multiple RAF Loops Triggering Simultaneously

When performance drops, environment detection fires change events → multiple theaters restart → more performance pressure → more restarts = **cascade loop**.

### Solution 1: Request Gating Pattern

Use a flag to prevent multiple RAF callbacks from queueing:

```javascript
let scheduledAnimationFrame = false;

function scheduleUpdate() {
  if (scheduledAnimationFrame) return; // Early exit

  scheduledAnimationFrame = true;
  requestAnimationFrame(() => {
    scheduledAnimationFrame = false; // Reset after execution
    update();
  });
}

// Safe to call multiple times rapidly
window.addEventListener('resize', scheduleUpdate);
performanceMonitor.on('change', scheduleUpdate);
```

**Why this works:** RAF callbacks are added to the **next** callback loop, not the current one. Without gating, hundreds of requests can queue up even if one is already running.

### Solution 2: Centralized Animation Manager

Instead of each theater managing its own RAF loop, use a single shared manager:

```javascript
class AnimationManager {
  constructor() {
    this.tasks = new Set();
    this.isRunning = false;
  }

  register(task) {
    this.tasks.add(task);
    if (!this.isRunning) this.start();
  }

  unregister(task) {
    this.tasks.delete(task);
    if (this.tasks.size === 0) this.stop();
  }

  start() {
    this.isRunning = true;
    this.loop();
  }

  stop() {
    this.isRunning = false;
    if (this.rafId) cancelAnimationFrame(this.rafId);
  }

  loop() {
    if (!this.isRunning) return;

    this.tasks.forEach(task => task());
    this.rafId = requestAnimationFrame(() => this.loop());
  }
}

const animationManager = new AnimationManager();

// Theaters register instead of creating independent loops
theater.onMount(() => {
  animationManager.register(() => theater.update());
});
```

**Benefits:**
- Single RAF callback → minimal overhead
- Automatic lifecycle management
- No cascade risk from multiple loops
- Easier to throttle globally

### Solution 3: Debouncing Environment Changes

Add hysteresis to performance state transitions:

```javascript
class PerformanceMonitor {
  constructor() {
    this.currentState = 'high';
    this.consecutiveFrames = 0;
    this.THRESHOLD_FRAMES = 5; // Require 5 frames before changing state
  }

  update(fps) {
    const newState = this.calculateState(fps);

    if (newState === this.currentState) {
      this.consecutiveFrames = 0;
    } else {
      this.consecutiveFrames++;

      // Only transition after sustained change
      if (this.consecutiveFrames >= this.THRESHOLD_FRAMES) {
        this.currentState = newState;
        this.consecutiveFrames = 0;
        this.emit('stateChange', newState);
      }
    }
  }

  calculateState(fps) {
    // Hysteresis: different thresholds for upward vs downward transitions
    if (this.currentState === 'high' && fps < 45) return 'medium';
    if (this.currentState === 'medium' && fps > 50) return 'high';
    if (this.currentState === 'medium' && fps < 25) return 'low';
    if (this.currentState === 'low' && fps > 30) return 'medium';
    return this.currentState;
  }
}
```

**Why hysteresis matters:** Without it, FPS hovering around a threshold (e.g., 29-31) causes rapid state oscillation → restart cascades. The 5-frame buffer + separate up/down thresholds prevent thrashing.

---

## 2. RAF Best Practices Under Load

### Delta Time vs Fixed Timestep

**Problem:** High refresh rate displays (120Hz) run RAF 120x/sec vs 60x/sec on standard displays. Without time-based logic, animations run 2x faster on 120Hz monitors.

**Solution: Delta Time Pattern**

```javascript
const TARGET_FPS = 60;
const FRAME_INTERVAL_MS = 1000 / TARGET_FPS; // 16.67ms
let previousTimeMs = 0;

function update(currentTimeMs) {
  const deltaTimeMs = currentTimeMs - previousTimeMs;

  // Only update physics at target FPS
  if (deltaTimeMs >= FRAME_INTERVAL_MS) {
    updatePhysics(deltaTimeMs);

    // CRITICAL: Rewind clock to prevent drift
    previousTimeMs = currentTimeMs - (deltaTimeMs % FRAME_INTERVAL_MS);
  }

  // Always render (native refresh rate)
  draw();
  requestAnimationFrame(update);
}

requestAnimationFrame(update);
```

**Train Station Analogy:** If a frame takes 25ms (exceeds 16.67ms budget), the next frame is now 8.33ms behind schedule. Without the modulo compensation, delays cascade. The rewind prevents cumulative drift.

### Separating Update and Draw

**Decoupling pattern:**
- **Physics/logic** runs at fixed timestep (e.g., 60 FPS)
- **Rendering** runs at native refresh rate (60/120/144 Hz)

```javascript
let accumulator = 0;
const FIXED_TIMESTEP = 16.67; // ms

function gameLoop(currentTime) {
  const deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  accumulator += deltaTime;

  // Fixed updates: may run 0, 1, or multiple times per frame
  while (accumulator >= FIXED_TIMESTEP) {
    updatePhysics(FIXED_TIMESTEP);
    accumulator -= FIXED_TIMESTEP;
  }

  // Render with interpolation
  const alpha = accumulator / FIXED_TIMESTEP;
  render(alpha);

  requestAnimationFrame(gameLoop);
}
```

**Why this matters:** Complex scenes may cause frame drops (30 FPS). With fixed timestep, physics remains deterministic while rendering adapts. The `alpha` parameter allows smooth interpolation between physics states.

### Preventing Runaway RAF Loops

**Anti-pattern:**
```javascript
// BAD: Can queue infinite callbacks under load
function animate() {
  doWork();
  requestAnimationFrame(animate); // Always queues next frame
}
```

**Safe pattern with circuit breaker:**
```javascript
class SafeAnimator {
  constructor() {
    this.enabled = true;
    this.consecutiveSlowFrames = 0;
    this.MAX_SLOW_FRAMES = 10;
  }

  animate(timestamp) {
    if (!this.enabled) return;

    const startTime = performance.now();
    doWork();
    const duration = performance.now() - startTime;

    // Circuit breaker: stop if consistently exceeding budget
    if (duration > 16.67) {
      this.consecutiveSlowFrames++;
      if (this.consecutiveSlowFrames >= this.MAX_SLOW_FRAMES) {
        console.warn('Animation loop disabled due to excessive frame time');
        this.enabled = false;
        return;
      }
    } else {
      this.consecutiveSlowFrames = 0;
    }

    requestAnimationFrame((t) => this.animate(t));
  }
}
```

**Recovery mechanism:**
```javascript
// Re-enable after timeout
setTimeout(() => {
  if (!animator.enabled) {
    animator.enabled = true;
    animator.consecutiveSlowFrames = 0;
    requestAnimationFrame((t) => animator.animate(t));
  }
}, 5000);
```

### Input Handling Under Load

**Anti-pattern:**
```javascript
// BAD: Updates state outside RAF loop
document.addEventListener('keydown', (e) => {
  player.moveLeft(); // Runs at event frequency, not frame frequency
});
```

**Correct pattern:**
```javascript
const pressedKeys = new Set();

document.addEventListener('keydown', (e) => pressedKeys.add(e.key));
document.addEventListener('keyup', (e) => pressedKeys.delete(e.key));

function updatePhysics() {
  if (pressedKeys.has('ArrowLeft')) {
    player.moveLeft(); // Runs at consistent frame rate
  }
}

function gameLoop() {
  updatePhysics();
  render();
  requestAnimationFrame(gameLoop);
}
```

**Why:** Input events fire at unpredictable rates. Processing them inside the game loop ensures time-consistent behavior even under load.

---

## 3. Resource-Aware Animation Strategies

### Adaptive Quality Levels

**Quality tier system:**

```javascript
const QUALITY_LEVELS = {
  none: {
    blur: 0,
    shadows: false,
    particles: 0,
    updateRate: Infinity // Never update
  },
  low: {
    blur: 4,
    shadows: false,
    particles: 10,
    updateRate: 30 // Every 2nd frame at 60fps
  },
  medium: {
    blur: 8,
    shadows: true,
    particles: 50,
    updateRate: 60
  },
  high: {
    blur: 12,
    shadows: true,
    particles: 200,
    updateRate: 60
  }
};

class AdaptiveAnimator {
  constructor() {
    this.currentQuality = 'high';
  }

  setQuality(level) {
    this.currentQuality = level;
    const config = QUALITY_LEVELS[level];

    // Apply configuration
    this.blurAmount = config.blur;
    this.enableShadows = config.shadows;
    this.maxParticles = config.particles;
    this.targetFrameRate = config.updateRate;
  }

  update(deltaTime) {
    const interval = 1000 / this.targetFrameRate;
    if (deltaTime < interval) return; // Skip frame

    // Render at reduced quality
    this.render();
  }
}
```

### Animation Budget Allocator

Inspired by game engine patterns (Unreal Engine's ABA):

```javascript
class AnimationBudgetAllocator {
  constructor(frameTimeBudgetMs = 16.67) {
    this.budget = frameTimeBudgetMs;
    this.animations = [];
  }

  register(animation, priority = 1) {
    this.animations.push({ animation, priority, significance: 0 });
    this.recomputeSignificance();
  }

  recomputeSignificance() {
    // Higher significance for:
    // - Higher priority
    // - Closer to viewport
    // - User focus
    this.animations.forEach(item => {
      item.significance =
        item.priority *
        item.animation.getViewportProximity() *
        (item.animation.isUserFocused() ? 2 : 1);
    });

    // Sort by significance
    this.animations.sort((a, b) => b.significance - a.significance);
  }

  update(deltaTime) {
    let remainingBudget = this.budget;

    for (const item of this.animations) {
      const estimatedCost = item.animation.estimateCost();

      if (remainingBudget < estimatedCost) {
        // Out of budget: reduce update rate
        item.animation.setUpdateRate(item.animation.updateRate + 1);
      } else {
        // Within budget: update normally
        item.animation.update(deltaTime);
        remainingBudget -= estimatedCost;
        item.animation.setUpdateRate(1); // Full frame rate
      }
    }
  }
}
```

**How it works:**
- Assigns significance scores (priority × distance × focus)
- Sorts animations by significance
- Allocates budget sequentially
- Less significant animations run at reduced frame rates (e.g., every 5th frame)
- Uses interpolation for skipped frames

### Battery-Aware Degradation

```javascript
class BatteryAwareAnimator {
  constructor() {
    this.quality = 'high';
    this.monitorBattery();
  }

  async monitorBattery() {
    if (!navigator.getBattery) return;

    const battery = await navigator.getBattery();

    const updateQuality = () => {
      if (battery.charging) {
        this.quality = 'high';
      } else if (battery.level < 0.20) {
        this.quality = 'low';
      } else if (battery.level < 0.50) {
        this.quality = 'medium';
      } else {
        this.quality = 'high';
      }

      this.applyQualitySettings();
    };

    battery.addEventListener('chargingchange', updateQuality);
    battery.addEventListener('levelchange', updateQuality);
    updateQuality();
  }

  applyQualitySettings() {
    switch (this.quality) {
      case 'low':
        this.targetFps = 30;
        this.enableBlur = false;
        this.enableShadows = false;
        break;
      case 'medium':
        this.targetFps = 45;
        this.enableBlur = true;
        this.enableShadows = false;
        break;
      case 'high':
        this.targetFps = 60;
        this.enableBlur = true;
        this.enableShadows = true;
        break;
    }
  }
}
```

**Research finding:** Battery-aware rendering can save up to **30% power** by reducing frame rates during scrolling or low-power states.

### Visibility-Based Optimization

```javascript
class VisibilityAwareAnimator {
  constructor(element) {
    this.element = element;
    this.isVisible = false;
    this.setupObserver();
  }

  setupObserver() {
    const observer = new IntersectionObserver(
      ([entry]) => {
        this.isVisible = entry.isIntersecting;

        if (this.isVisible) {
          this.start();
        } else {
          this.pause();
        }
      },
      { threshold: 0.1 } // 10% visible
    );

    observer.observe(this.element);
  }

  start() {
    if (!this.rafId) {
      this.rafId = requestAnimationFrame(() => this.update());
    }
  }

  pause() {
    if (this.rafId) {
      cancelAnimationFrame(this.rafId);
      this.rafId = null;
    }
  }
}
```

---

## 4. Performance Monitoring Integration

### FPS Tracking with Hysteresis

```javascript
class FPSMonitor {
  constructor() {
    this.frames = [];
    this.currentFps = 60;
    this.state = 'high';
    this.stateFrameCount = 0;

    // Hysteresis thresholds
    this.thresholds = {
      high: { down: 45, up: Infinity },
      medium: { down: 25, up: 50 },
      low: { down: -Infinity, up: 30 }
    };
  }

  recordFrame(timestamp) {
    this.frames.push(timestamp);

    // Calculate FPS over last 60 frames
    if (this.frames.length > 60) {
      this.frames.shift();
    }

    if (this.frames.length >= 2) {
      const elapsed = this.frames[this.frames.length - 1] - this.frames[0];
      this.currentFps = (this.frames.length - 1) / (elapsed / 1000);
    }

    this.updateState();
  }

  updateState() {
    const current = this.thresholds[this.state];
    let newState = this.state;

    // Check for state transitions
    if (this.currentFps < current.down) {
      // Downgrade
      if (this.state === 'high') newState = 'medium';
      else if (this.state === 'medium') newState = 'low';
    } else if (this.currentFps > current.up) {
      // Upgrade
      if (this.state === 'low') newState = 'medium';
      else if (this.state === 'medium') newState = 'high';
    }

    // Hysteresis: require sustained change
    if (newState !== this.state) {
      this.stateFrameCount++;

      if (this.stateFrameCount >= 5) { // 5 consecutive frames
        this.state = newState;
        this.stateFrameCount = 0;
        this.emit('stateChange', newState);
      }
    } else {
      this.stateFrameCount = 0;
    }
  }
}
```

**Key features:**
- Rolling 60-frame window for stable FPS calculation
- Separate up/down thresholds prevent oscillation
- 5-frame confirmation prevents transient spikes from causing state changes
- State machine: high (45-60+) → medium (25-50) → low (<30)

### Jank Detection

**Advanced metric:** Track **1% Low FPS** (99th percentile worst frame times):

```javascript
class JankDetector {
  constructor() {
    this.frameTimes = [];
    this.MAX_SAMPLES = 100;
  }

  recordFrame(deltaTime) {
    this.frameTimes.push(deltaTime);

    if (this.frameTimes.length > this.MAX_SAMPLES) {
      this.frameTimes.shift();
    }
  }

  getMetrics() {
    if (this.frameTimes.length === 0) return null;

    const sorted = [...this.frameTimes].sort((a, b) => b - a);
    const onePercentIndex = Math.floor(sorted.length * 0.01);

    return {
      average: this.frameTimes.reduce((a, b) => a + b) / this.frameTimes.length,
      onePercentLow: 1000 / sorted[onePercentIndex], // FPS of worst 1%
      max: Math.max(...this.frameTimes),
      min: Math.min(...this.frameTimes)
    };
  }

  hasJank() {
    const metrics = this.getMetrics();
    if (!metrics) return false;

    // Jank = worst 1% below 30 FPS
    return metrics.onePercentLow < 30;
  }
}
```

**Why 1% Low matters:** Average FPS can be 60, but if 1% of frames take 100ms, users perceive stuttering. This metric captures that.

### Prefers-Reduced-Motion Support

```javascript
class AccessibleAnimator {
  constructor() {
    this.prefersReducedMotion = this.checkMotionPreference();
    this.setupListener();
  }

  checkMotionPreference() {
    return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  }

  setupListener() {
    const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
    mediaQuery.addEventListener('change', (e) => {
      this.prefersReducedMotion = e.matches;
      this.updateAnimations();
    });
  }

  updateAnimations() {
    if (this.prefersReducedMotion) {
      // Instant transitions, no motion
      this.duration = 0;
      this.animations.forEach(a => a.pause());
    } else {
      // Normal animations
      this.duration = 300;
      this.animations.forEach(a => a.resume());
    }
  }
}
```

### Combined Performance + Visibility Monitor

```javascript
class SmartAnimationController {
  constructor(element) {
    this.element = element;
    this.isVisible = false;
    this.performanceState = 'high';
    this.shouldAnimate = true;

    this.setupVisibilityObserver();
    this.setupPerformanceMonitor();
  }

  setupVisibilityObserver() {
    const observer = new IntersectionObserver(([entry]) => {
      this.isVisible = entry.isIntersecting;
      this.updateAnimationState();
    });
    observer.observe(this.element);
  }

  setupPerformanceMonitor() {
    const monitor = new FPSMonitor();
    monitor.on('stateChange', (state) => {
      this.performanceState = state;
      this.updateAnimationState();
    });
  }

  updateAnimationState() {
    const wasAnimating = this.shouldAnimate;

    // Only animate if visible AND performance allows
    this.shouldAnimate =
      this.isVisible &&
      this.performanceState !== 'low' &&
      !document.hidden; // Page visibility API

    // Handle transitions
    if (this.shouldAnimate && !wasAnimating) {
      this.startAnimation();
    } else if (!this.shouldAnimate && wasAnimating) {
      this.pauseAnimation();
    }
  }
}
```

---

## 5. Recommended Patterns for Theater System

Based on research findings, here's how to fix the theater animation cascade issue:

### Architecture Redesign

**Current problem:**
```
Theater 1 → RAF loop → detects FPS drop → restarts
Theater 2 → RAF loop → detects FPS drop → restarts
Theater 3 → RAF loop → detects FPS drop → restarts
Performance Monitor → detects change → broadcasts → all restart again
```

**Solution architecture:**

```javascript
// 1. Single centralized animation manager
class TheaterAnimationManager {
  constructor() {
    this.theaters = new Map();
    this.performanceState = 'high';
    this.rafId = null;
    this.previousTime = 0;
    this.fpsMonitor = new FPSMonitor();

    this.setupPerformanceMonitoring();
  }

  setupPerformanceMonitoring() {
    this.fpsMonitor.on('stateChange', (newState) => {
      // Only notify if state actually changed (built-in debouncing)
      if (newState !== this.performanceState) {
        this.performanceState = newState;
        this.applyQualitySettings(newState);
      }
    });
  }

  register(theaterId, theater) {
    this.theaters.set(theaterId, {
      theater,
      priority: theater.priority || 1,
      lastUpdateTime: 0,
      updateInterval: 16.67 // Default 60fps
    });

    if (!this.rafId) this.start();
  }

  unregister(theaterId) {
    this.theaters.delete(theaterId);
    if (this.theaters.size === 0) this.stop();
  }

  start() {
    this.previousTime = performance.now();
    this.loop(this.previousTime);
  }

  stop() {
    if (this.rafId) {
      cancelAnimationFrame(this.rafId);
      this.rafId = null;
    }
  }

  loop(currentTime) {
    const deltaTime = currentTime - this.previousTime;
    this.previousTime = currentTime;

    // Record frame for FPS monitoring
    this.fpsMonitor.recordFrame(currentTime);

    // Update theaters based on priority and budget
    this.updateTheaters(deltaTime, currentTime);

    this.rafId = requestAnimationFrame((t) => this.loop(t));
  }

  updateTheaters(deltaTime, currentTime) {
    // Sort by priority (high priority first)
    const sorted = Array.from(this.theaters.entries())
      .sort(([, a], [, b]) => b.priority - a.priority);

    let budgetRemaining = 16.67; // ms

    for (const [id, data] of sorted) {
      const timeSinceLastUpdate = currentTime - data.lastUpdateTime;

      // Check if it's time to update this theater
      if (timeSinceLastUpdate >= data.updateInterval) {
        const startTime = performance.now();

        // Update theater
        data.theater.update(deltaTime);

        const updateDuration = performance.now() - startTime;
        budgetRemaining -= updateDuration;
        data.lastUpdateTime = currentTime;

        // If we're out of budget, increase interval for low-priority theaters
        if (budgetRemaining < 0 && data.priority < 5) {
          data.updateInterval = Math.min(data.updateInterval * 1.5, 100);
        }
      }
    }
  }

  applyQualitySettings(state) {
    // Apply globally to all theaters
    this.theaters.forEach(({ theater }) => {
      switch (state) {
        case 'high':
          theater.setQuality({ blur: 12, shadows: true });
          break;
        case 'medium':
          theater.setQuality({ blur: 8, shadows: false });
          break;
        case 'low':
          theater.setQuality({ blur: 4, shadows: false });
          break;
      }
    });
  }
}

// 2. Global instance
const globalTheaterManager = new TheaterAnimationManager();

// 3. Theater registration
class AnimationTheater {
  constructor(element, options = {}) {
    this.element = element;
    this.priority = options.priority || 1;
    this.id = crypto.randomUUID();

    // Register with global manager (NO local RAF loop)
    globalTheaterManager.register(this.id, this);
  }

  update(deltaTime) {
    // Theater-specific animation logic
    this.updateAnimations(deltaTime);
  }

  setQuality(settings) {
    // Apply quality settings
    this.blurAmount = settings.blur;
    this.enableShadows = settings.shadows;
  }

  destroy() {
    globalTheaterManager.unregister(this.id);
  }
}
```

### Key Improvements

1. **Single RAF loop** - Eliminates cascade risk from multiple independent loops
2. **Centralized performance monitoring** - One FPS tracker with built-in hysteresis
3. **Priority-based budget allocation** - High-priority theaters always update, low-priority degrade gracefully
4. **Automatic quality adaptation** - Global state changes apply to all theaters simultaneously
5. **No timeout race conditions** - All timing uses RAF delta time
6. **Graceful registration/unregistration** - Manager automatically starts/stops as needed

### Migration Strategy

**Step 1:** Create global manager instance
```javascript
// src/utils/theaterAnimationManager.ts
export const theaterManager = new TheaterAnimationManager();
```

**Step 2:** Remove RAF loops from individual theaters
```diff
- this.rafId = requestAnimationFrame(() => this.loop());
+ // Removed - manager handles this
```

**Step 3:** Register theaters on mount
```javascript
onMounted(() => {
  theaterManager.register(theater.id, theater);
});

onUnmounted(() => {
  theaterManager.unregister(theater.id);
});
```

**Step 4:** Remove local performance monitoring
```diff
- this.fpsMonitor = new FPSMonitor();
- this.fpsMonitor.on('change', () => this.restart());
+ // Removed - manager handles this
```

### Testing Checklist

- [ ] Multiple theaters animate without cascades
- [ ] Performance degradation is smooth (no abrupt restarts)
- [ ] FPS drops don't cause repeated state changes
- [ ] Low-priority theaters degrade first
- [ ] High-priority theaters maintain quality
- [ ] Page visibility properly pauses all theaters
- [ ] Battery level reduces quality globally
- [ ] No memory leaks from register/unregister cycles

---

## 6. References

### Primary Sources

1. **Aleksandr Hovhannisyan - JavaScript Game Loop**
   https://www.aleksandrhovhannisyan.com/blog/javascript-game-loop/
   Deep dive on delta time, fixed timestep, RAF synchronization, input handling

2. **DEV Community - Optimize requestAnimationFrame Like a Pro**
   https://dev.to/josephciullo/supercharge-your-web-animations-optimize-requestanimationframe-like-a-pro-22i5
   Centralized animation manager pattern, frame budget management, FPS throttling

3. **Spencer Ponte - Debouncing Scroll with RAF**
   https://blog.spencerponte.com/2015/04/debouncing-scroll-events-with-request-animation-frame/
   Preventing multiple RAF callbacks, gating pattern

4. **CSS-Tricks - Debouncing and Throttling Explained**
   https://css-tricks.com/debouncing-throttling-explained-examples/
   General debouncing patterns applicable to performance monitoring

### Secondary Sources

5. **Stack Overflow - Controlling FPS with RAF**
   https://stackoverflow.com/questions/19764018/controlling-fps-with-requestanimationframe
   Community solutions for FPS limiting

6. **Coconut Lizard - Animation Budget Allocator**
   https://www.coconutlizard.co.uk/blog/animation-budget-allocator/
   Priority-based animation scheduling

7. **Unity Documentation - Time and Frame Rate Management**
   https://docs.unity3d.com/2022.3/Documentation/Manual/TimeFrameManagement.html
   Fixed timestep principles from game engines

8. **Unreal Engine - Animation Budget Allocator**
   https://dev.epicgames.com/documentation/en-us/unreal-engine/animation-budget-allocator-in-unreal-engine
   Significance-based animation quality adaptation

### Additional Resources

9. **MDN Web Docs - requestAnimationFrame**
   https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame
   Official API documentation

10. **Web.dev - Rendering Performance**
    https://web.dev/rendering-performance/
    Browser rendering pipeline optimization

---

## Implementation Priority

**Immediate (Fix cascades):**
1. Implement request gating pattern in environment monitor
2. Add hysteresis to performance state transitions (5-frame buffer)
3. Remove timeouts, use RAF delta time exclusively

**Short-term (Optimize):**
4. Create centralized animation manager
5. Migrate theaters to registration pattern
6. Implement priority-based budget allocation

**Long-term (Polish):**
7. Add battery-aware quality adaptation
8. Implement 1% Low FPS jank detection
9. Add visibility-based pause/resume
10. Create performance dashboard for debugging

---

**End of Report**
