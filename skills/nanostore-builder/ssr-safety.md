# SSR Safety for Nanostores

Complete guide to making nanostores work correctly in Astro's SSR environment.

---

## The SSR Problem

**What happens:**
- Server renders pages before sending to client
- Server has no `window`, `localStorage`, `document`
- Accessing browser APIs during SSR causes crashes
- Persistent stores try to read localStorage on server

**Solution:**
- Guard browser-only code with SSR checks
- Initialize persistence client-side only
- Use conditional persistence
- Handle hydration mismatches

---

## 1. Basic SSR Guards

### Check import.meta.env.SSR

```typescript
// ❌ WRONG - Crashes on SSR
export const theme = persistentAtom('theme', 'light');
theme.set('dark'); // Tries to write to localStorage on server

// ✅ CORRECT - Guarded
export const theme = persistentAtom('theme', 'light');

export function setTheme(value: string) {
  if (import.meta.env.SSR) return; // Skip on server
  theme.set(value);
}
```

### Check typeof window

```typescript
// ✅ Safe pattern
export function initializeStore() {
  if (typeof window === 'undefined') return;

  // Safe to use browser APIs here
  const saved = localStorage.getItem('data');
  if (saved) {
    store.set(JSON.parse(saved));
  }
}
```

---

## 2. Persistent Store Patterns

### Pattern: Safe Defaults

```typescript
// ✅ Always provide default, decode handles errors
export const curUser = persistentAtom<User | null>(
  "curUser",
  null, // Safe default
  {
    encode: JSON.stringify,
    decode: (value) => {
      try {
        return JSON.parse(value);
      } catch {
        return null; // Return default on error
      }
    },
  }
);
```

### Pattern: Conditional Persistence

```typescript
import { atom } from 'nanostores';
import { persistentAtom } from '@nanostores/persistent';

// ✅ Use persistent atom only on client
export const userPrefs = import.meta.env.SSR
  ? atom({ theme: 'light', lang: 'en' })
  : persistentAtom('userPrefs', { theme: 'light', lang: 'en' }, {
      encode: JSON.stringify,
      decode: JSON.parse,
    });
```

---

## 3. Initialization Patterns

### Pattern: Client-Only Initialization

```typescript
// floatingPanelStore.ts
let persistenceManagerInstance: ReturnType<typeof usePersistenceManager> | null = null;

/**
 * Initialize persistence (client-side only)
 * Call this in a Vue component's onMounted hook
 */
export async function initializePersistence() {
  if (import.meta.env.SSR) return;
  if (!persistenceManagerInstance) {
    persistenceManagerInstance = usePersistenceManager();
  }
  await persistenceManager.init();
  return persistenceManagerInstance;
}
```

**Usage in Vue Component:**

```vue
<script setup lang="ts">
import { onMounted } from 'vue';
import { initializePersistence } from '@/stores/floatingPanelStore';

onMounted(async () => {
  await initializePersistence();
});
</script>
```

### Pattern: Lazy Persistence

```typescript
export const updatePanelPosition = (id: string, position: Position): void => {
  updatePanel(id, { position });

  // Only save if client-side AND persistence available
  if (import.meta.env.SSR) return;

  const configs = panelConfigs.get();
  const panel = configs[id];
  if (panel && storageStatus.get().available && persistenceManagerInstance) {
    persistenceManager.savePanelPosition(id, position, panel.size);
  }
};
```

---

## 4. Real-World Examples

### Example: Auth Store (Multiple Guards)

```typescript
export const curUser = persistentAtom<Models.User | null>(
  "curUser",
  null,
  {
    encode: JSON.stringify,
    decode: (value) => {
      try {
        const parsed = JSON.parse(value);
        return parsed;
      } catch {
        return null;
      }
    },
  }
);

export const currentUser = async (): Promise<Models.User | null> => {
  try {
    // Guard 1: Check if logging out
    if (isLoggingOut.get()) {
      return null;
    }

    // Guard 2: Check existing user
    const existingUser = curUser.get();
    if (existingUser) {
      return existingUser;
    }

    // Safe to call API (works on both server and client)
    const userResponse = await fetch('/api/auth/verify.json', {
      method: "GET",
      credentials: "include",
    });

    if (userResponse.ok) {
      const data = await userResponse.json();

      // Guard 3: Only set if client-side
      if (!import.meta.env.SSR && data.user) {
        curUser.set(data.user);
      }

      return data.user;
    }

    return null;
  } catch {
    return null;
  }
};
```

### Example: Floating Panel Store (Viewport-Aware)

```typescript
export const centerPanel = (id: string): void => {
  // Use defaults on SSR or if window not available
  const viewport = {
    width: !import.meta.env.SSR && typeof window !== 'undefined'
      ? window.innerWidth
      : 1200, // SSR default
    height: !import.meta.env.SSR && typeof window !== 'undefined'
      ? window.innerHeight
      : 800  // SSR default
  };

  const configs = panelConfigs.get();
  const panel = configs[id];

  if (!panel) return;

  const position = {
    x: (viewport.width - panel.size.width) / 2,
    y: (viewport.height - panel.size.height) / 2
  };

  updatePanel(id, { position });
};
```

### Example: Workflow Store (Event Listeners)

```typescript
// Auto-save configuration
let autoSaveInterval: ReturnType<typeof setInterval> | undefined;

workflowAutoSaveConfig.subscribe((config) => {
  if (autoSaveInterval) {
    clearInterval(autoSaveInterval);
  }

  if (config.enabled && config.interval > 0) {
    autoSaveInterval = setInterval(() => {
      const context = workflowExecutionContext.get();
      if (context.hasUnsavedChanges) {
        autoSaveWorkflowState();
      }
    }, config.interval);
  }
});

// Guard browser events
if (typeof document !== "undefined") {
  document.addEventListener("visibilitychange", () => {
    if (document.hidden) {
      const context = workflowExecutionContext.get();
      if (context.hasUnsavedChanges) {
        autoSaveWorkflowState();
      }
    }
  });

  window.addEventListener("beforeunload", () => {
    const context = workflowExecutionContext.get();
    if (context.hasUnsavedChanges) {
      autoSaveWorkflowState();
    }
  });
}
```

### Example: Conditional Subscription (Client-Only)

```typescript
// Auto-create checkpoints when panels change (client-side only)
let lastCheckpointTime = 0;
const CHECKPOINT_INTERVAL = 30000; // 30 seconds

if (!import.meta.env.SSR) {
  panelConfigs.subscribe(() => {
    const now = Date.now();
    if (now - lastCheckpointTime > CHECKPOINT_INTERVAL) {
      lastCheckpointTime = now;
      createPanelRecoveryCheckpoint();
    }
  });
}
```

---

## 5. Common SSR Pitfalls

### ❌ Pitfall: Accessing window directly

```typescript
// WRONG - Crashes on SSR
export const viewportWidth = atom(window.innerWidth);
```

**✅ Fix:**
```typescript
export const viewportWidth = atom(
  typeof window !== 'undefined' ? window.innerWidth : 1200
);
```

### ❌ Pitfall: localStorage in module scope

```typescript
// WRONG - Executes on server
const saved = localStorage.getItem('data');
export const data = atom(saved ? JSON.parse(saved) : null);
```

**✅ Fix:**
```typescript
export const data = atom(null);

// Initialize client-side only
export function initData() {
  if (import.meta.env.SSR) return;
  const saved = localStorage.getItem('data');
  if (saved) data.set(JSON.parse(saved));
}
```

### ❌ Pitfall: Subscribing in module scope

```typescript
// WRONG - Subscription runs on server
myStore.subscribe(value => {
  localStorage.setItem('key', JSON.stringify(value));
});
```

**✅ Fix:**
```typescript
if (!import.meta.env.SSR) {
  myStore.subscribe(value => {
    localStorage.setItem('key', JSON.stringify(value));
  });
}
```

### ❌ Pitfall: Document events in module scope

```typescript
// WRONG - No document on server
document.addEventListener('click', handleClick);
```

**✅ Fix:**
```typescript
if (typeof document !== 'undefined') {
  document.addEventListener('click', handleClick);
}
```

---

## 6. SSR Checklist

Before deploying stores:

- [ ] ✅ All persistent stores have safe defaults
- [ ] ✅ All decode functions handle errors
- [ ] ✅ Browser API access is guarded
- [ ] ✅ Event listeners are conditional
- [ ] ✅ Subscriptions check SSR context
- [ ] ✅ Initialization functions guard client-only code
- [ ] ✅ Viewport calculations have SSR defaults
- [ ] ✅ No module-scope localStorage/sessionStorage access

---

## 7. Testing SSR Safety

### Test in Development

```bash
# Build with SSR
npm run build

# Preview SSR build
npm run preview

# Watch for errors:
# - ReferenceError: window is not defined
# - ReferenceError: localStorage is not defined
# - ReferenceError: document is not defined
```

### Common Error Messages

| Error | Cause | Fix |
|-------|-------|-----|
| `window is not defined` | Accessing `window` on server | Guard with `typeof window !== 'undefined'` |
| `localStorage is not defined` | Accessing localStorage on server | Guard with `import.meta.env.SSR` |
| `document is not defined` | Accessing `document` on server | Guard with `typeof document !== 'undefined'` |
| Hydration mismatch | Different server/client initial state | Ensure consistent defaults |

---

## 8. Best Practices Summary

### ✅ DO:
- Use `import.meta.env.SSR` for Astro projects
- Provide safe defaults for all persistent stores
- Guard browser API access
- Initialize persistence in `onMounted()`
- Handle decode errors gracefully
- Use SSR-safe default values (1200x800 viewport, etc.)

### ❌ DON'T:
- Access `window`, `localStorage`, `document` in module scope
- Assume browser APIs are available
- Skip error handling in decode functions
- Initialize persistence in module scope
- Use browser-only features without guards

---

## Next Steps

- See **[performance.md]** for optimizing SSR-safe stores
- See **[advanced-patterns.md]** for SSR-safe pattern variations
