---
name: Debug SSR Hydration Issues
type: frontend-debugging
status: production-ready
updated: 2025-10-16
---

# Workflow: Debug SSR Hydration Issues

**Goal**: Fix hydration mismatch warnings and client-server state sync issues

**Duration**: 30 minutes - 2 hours
**Complexity**: Medium
**Problem Indicators**:
- Hydration mismatch warnings in console
- Content flickering on page load
- State differs between server and client render
- Performance issues in SSR mode

---

## Steps

### 1. Identify Issue
Use `/ssr-debug "hydration mismatch in [component name]"`

**Agent**: `ssr-debugger` analyzes server vs client rendering

**What to analyze:**
- Exact location of mismatch
- Which component is affected
- What differs between renders
- Whether it's state or DOM structure
- Performance impact

### 2. Fix Component (if Browser API Issue)
If the problem is browser API usage in SSR:

**Agent**: `ssr-debugger` identifies and wraps with `useMounted()`

**Pattern:**
```vue
<script setup>
import { useMounted } from '@vueuse/core';

const isMounted = useMounted();
const windowWidth = ref(0);

watch(isMounted, (mounted) => {
  if (mounted) {
    windowWidth.value = window.innerWidth;
  }
});
</script>

<template>
  <div v-if="isMounted">
    <!-- Client-only content -->
  </div>
</template>
```

### 3. Fix State (if State Sync Issue)
If problem is state differing between server and client:

**Agent**: `nanostore-state-architect` fixes state initialization

**Pattern:**
```typescript
// Ensure store is initialized same way on server and client
export const userStore = persistentAtom<User | null>(
  'user',
  null, // Same initial value everywhere
  {
    encode: JSON.stringify,
    decode: JSON.parse,
  }
);

// On server: Populate with server data
// On client: Will hydrate from HTML
```

### 4. Validate
Build and test in production mode:

```bash
npm run build
npm run preview
# Check browser console for warnings
```

**Agent**: `ssr-debugger` verifies both SSR and client render match

**What to verify:**
- No hydration warnings
- State consistent between renders
- No content flickering
- Performance acceptable
- All features work

---

## Agent Orchestration

```
ssr-debugger → [nanostore-state-architect if state-related] → validation
```

---

## Common Causes & Solutions

### 1. Browser API in Setup
```vue
<!-- ❌ Bad - runs on server too -->
<script setup>
const width = window.innerWidth;
</script>

<!-- ✅ Good - only runs on client -->
<script setup>
import { useMounted } from '@vueuse/core';
const isMounted = useMounted();
const width = ref(0);
watch(isMounted, () => {
  if (isMounted.value) width.value = window.innerWidth;
});
</script>
```

### 2. Random Content
```vue
<!-- ❌ Bad - different on server and client -->
<div>{{ Math.random() }}</div>

<!-- ✅ Good - same on both -->
<div v-if="isMounted">{{ clientRandom }}</div>
```

### 3. Different Data
```typescript
// ❌ Bad - server passes different initial data
const data = props.items.slice(0, 5); // Server: 5 items
// Client: might have different count

// ✅ Good - same data on both
const data = computed(() => props.items.slice(0, 5));
```

### 4. State Not Syncing
```typescript
// ❌ Bad - state created fresh on client
export const store = atom({ count: 0 });

// ✅ Good - pass initial state from server
// In Astro page:
// <Component client:load initialState={serverState} />

// In component:
export const store = atom(props.initialState);
```

---

## Debug Techniques

### 1. Check Build Output
```bash
npm run build 2>&1 | grep -i "hydration\|mismatch"
```

### 2. Compare Renders
In browser DevTools:
1. Right-click → Inspect
2. Look for `<!--[`...`]-->` markers (hydration boundaries)
3. Check if DOM matches between server and client

### 3. Test in SSR Mode
```bash
npm run build
npm run preview
# Disable JavaScript in DevTools
# Reload page - should still work
# Re-enable JavaScript - should hydrate smoothly
```

### 4. Use Astro Debug Output
```bash
ASTRO_DEBUG=* npm run build
```

---

## Prevention Checklist

- [ ] No `window`/`document` access in `<script setup>`
- [ ] All browser APIs wrapped with `useMounted()`
- [ ] Store initialization identical on server and client
- [ ] Props match between server HTML and client state
- [ ] No random/dynamic content without `v-if="isMounted"`
- [ ] No timezone/locale differences causing mismatches
- [ ] CSS-in-JS server-rendered properly
- [ ] Async components handled correctly

---

## Related Workflows

- [Create Feature Page](./01-create-feature-page.md)
- [Refactor to Nanostores](./04-refactor-nanostores.md)
- [Debug Existing Feature](./07-debug-existing-feature.md)

---

**Time Estimate**: 30 min - 2 hours | **Complexity**: Medium | **Status**: ✅ Production Ready
