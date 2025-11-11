# Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Async Lifecycle Hooks

**Problem:** Registering lifecycle hooks asynchronously won't work

```typescript
// ❌ WRONG - Won't work
setTimeout(() => {
  onMounted(() => {
    // This won't be associated with the component
  })
}, 100)

// ✅ CORRECT - Synchronous registration
onMounted(() => {
  // Can have async operations inside
  setTimeout(() => {
    // This is fine
  }, 100)
})
```

### ❌ Anti-Pattern 2: Forgetting Cleanup

**Problem:** Memory leaks from event listeners

```typescript
// ❌ WRONG - No cleanup
export function useMouse() {
  const x = ref(0)
  onMounted(() => {
    window.addEventListener('mousemove', update)
  })
  return { x }
}

// ✅ CORRECT - With cleanup
export function useMouse() {
  const x = ref(0)
  onMounted(() => {
    window.addEventListener('mousemove', update)
  })
  onUnmounted(() => {
    window.removeEventListener('mousemove', update)
  })
  return { x }
}
```

### ❌ Anti-Pattern 3: Not Returning Destructurable Objects

```typescript
// ❌ WRONG - Nested object
export function useMouse() {
  return { position: { x: ref(0), y: ref(0) } }
}

// ✅ CORRECT - Flat object
export function useMouse() {
  const x = ref(0)
  const y = ref(0)
  return { x, y }
}
```

### ❌ Anti-Pattern 4: Using ref for Large Objects

```typescript
// ❌ SUBOPTIMAL - Deep reactivity overhead
const data = ref<Product[]>(largeArray)

// ✅ BETTER - Shallow reactivity
const data = shallowRef<Product[]>(largeArray)
```
