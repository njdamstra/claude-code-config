# Performance Optimization for Nanostores

Real-world patterns for optimizing nanostore performance from this codebase.

---

## 1. Auto-Save Patterns

### Problem: Too Frequent Saves

**Bad:**
```typescript
// ❌ Saves on every keystroke
userPrefs.subscribe(value => {
  localStorage.setItem('prefs', JSON.stringify(value));
});
```

### Solution: Debounced Auto-Save

**Good:**
```typescript
import { debounce } from 'lodash-es';

const debouncedSave = debounce((value) => {
  localStorage.setItem('prefs', JSON.stringify(value));
}, 500); // Save 500ms after last change

userPrefs.subscribe(debouncedSave);
```

### Solution: Interval-Based Auto-Save

```typescript
// workflowStore.ts pattern
export const workflowAutoSaveConfig = atom({
  enabled: true,
  interval: 10000, // 10 seconds
  onStepChange: true,
  onDataChange: true,
});

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
```

**Benefits:**
- Saves only when needed
- Configurable interval
- Checks for changes before saving
- Can be disabled

---

## 2. Checkpoint Strategy

### Pattern: Time-Based Checkpoints

```typescript
// floatingPanelStore.ts pattern
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

**Key Features:**
- Only creates checkpoint every 30 seconds
- Prevents excessive checkpoint creation
- Simple time-based throttling

### Pattern: Change-Based Checkpoints

```typescript
function autoSaveWorkflowState(): void {
  const context = workflowExecutionContext.get();

  try {
    saveWorkflowState({
      workflowId: context.workflowId,
      currentStep: context.currentStep,
      stepData: context.steps.reduce((acc, step) => {
        acc[step.stepId] = step.data;
        return acc;
      }, {}),
      lastUpdated: Date.now(),
      sessionId: context.sessionId,
    });

    workflowExecutionContext.set({
      ...context,
      hasUnsavedChanges: false, // Mark as saved
      lastAutoSave: Date.now(),
    });
  } catch (error) {
    console.error("Failed to auto-save:", error);
  }
}
```

**Benefits:**
- Tracks `hasUnsavedChanges` flag
- Only saves when needed
- Records last save timestamp
- Error handling

---

## 3. Conditional Persistence

### Pattern: Check Availability Before Persisting

```typescript
export const updatePanelPosition = (id: string, position: Position): void => {
  updatePanel(id, { position, snapEdge: null });

  // Only persist if:
  // 1. Not SSR
  // 2. Storage is available
  // 3. Persistence manager is initialized
  if (import.meta.env.SSR) return;

  const configs = panelConfigs.get();
  const panel = configs[id];
  if (panel && storageStatus.get().available && persistenceManagerInstance) {
    persistenceManager.savePanelPosition(id, position, panel.size);
  }
};
```

**Checks:**
- SSR guard (performance + safety)
- Storage availability (quota, private mode)
- Persistence manager ready

---

## 4. Optimized Computed Stores

### Pattern: Single-Source Computed

```typescript
// ✅ GOOD - Computed from single source
export const visiblePanels = computed(panelConfigs, (configs) =>
  Object.values(configs).filter(panel => panel.isVisible)
);
```

### Pattern: Multi-Source Computed

```typescript
// ✅ GOOD - Computed from multiple sources
export const canProceedToNextStep = computed(
  [currentWorkflowStep, hasValidationErrors],
  (currentStep, hasErrors) => {
    return currentStep?.isComplete && !hasErrors;
  }
);
```

### ❌ Avoid: Nested Computed Chains

```typescript
// ❌ BAD - Too many layers of computation
const filtered = computed(allItems, items => items.filter(i => i.active));
const sorted = computed(filtered, items => items.sort((a, b) => a.name.localeCompare(b.name)));
const sliced = computed(sorted, items => items.slice(0, 10));

// ✅ BETTER - Single computation
const processedItems = computed(allItems, items =>
  items
    .filter(i => i.active)
    .sort((a, b) => a.name.localeCompare(b.name))
    .slice(0, 10)
);
```

---

## 5. Selective Reactivity

### Pattern: Update Only Changed Fields

```typescript
export const updateStoredValue = (value: Partial<z.infer<T>>) => {
  const current = this.storedValue;

  // ✅ Skip update if no change
  if (JSON.stringify(current) === JSON.stringify(value)) return;

  this.atom.set({
    ...current,
    ...value,
  });
};
```

### Pattern: Batch Updates

```typescript
// ❌ BAD - Multiple individual updates
panelConfigs.setKey('panel1', { ...config1, isVisible: true });
panelConfigs.setKey('panel2', { ...config2, isVisible: true });
panelConfigs.setKey('panel3', { ...config3, isVisible: true });

// ✅ BETTER - Single batch update
const configs = panelConfigs.get();
panelConfigs.set({
  ...configs,
  panel1: { ...configs.panel1, isVisible: true },
  panel2: { ...configs.panel2, isVisible: true },
  panel3: { ...configs.panel3, isVisible: true },
});
```

---

## 6. Lazy Loading Patterns

### Pattern: Lazy Initialize Expensive Resources

```typescript
// baseStore.ts pattern
private ulidInstance: ULIDFactory | null = null;

getUlidFactory = async (): Promise<ULIDFactory> => {
  if (!this.ulidInstance) {
    const { ulidFactory } = await import("ulid-workers");
    this.ulidInstance = ulidFactory();
  }
  return this.ulidInstance;
};
```

**Benefits:**
- Only loads when needed
- Caches after first load
- Async import for code splitting

### Pattern: Lazy Persistence Initialization

```typescript
let persistenceManagerInstance: ReturnType<typeof usePersistenceManager> | null = null;

export async function initializePersistence() {
  if (import.meta.env.SSR) return;
  if (!persistenceManagerInstance) {
    persistenceManagerInstance = usePersistenceManager();
  }
  await persistenceManager.init();
  return persistenceManagerInstance;
}
```

---

## 7. Event Listener Optimization

### Pattern: Passive Event Listeners

```typescript
// Use passive listeners for scroll/touch events
if (typeof window !== 'undefined') {
  window.addEventListener('scroll', handleScroll, { passive: true });
  window.addEventListener('touchmove', handleTouch, { passive: true });
}
```

### Pattern: Cleanup on Unload

```typescript
if (typeof document !== "undefined") {
  // Save before page unload
  const handleBeforeUnload = () => {
    const context = workflowExecutionContext.get();
    if (context.hasUnsavedChanges) {
      autoSaveWorkflowState();
    }
  };

  window.addEventListener("beforeunload", handleBeforeUnload);

  // Cleanup function (if using in component)
  // return () => window.removeEventListener("beforeunload", handleBeforeUnload);
}
```

---

## 8. localStorage Optimization

### Pattern: Structured Storage Keys

```typescript
// ✅ GOOD - Prefix for easy cleanup
persistentMap('floating-panels:', {}, { ... })
persistentAtom('panel-manager-state', {}, { ... })

// Easy to clear all related data
export const __clearPersistentStorage = (): void => {
  if (import.meta.env.SSR) return;

  Object.keys(localStorage).forEach(key => {
    if (key.startsWith('floating-panels:') || key === 'panel-manager-state') {
      localStorage.removeItem(key);
    }
  });
};
```

### Pattern: Compress Large Data

```typescript
import { compress, decompress } from 'lz-string';

export const largeData = persistentAtom('large-data', null, {
  encode: (value) => compress(JSON.stringify(value)),
  decode: (value) => {
    try {
      return JSON.parse(decompress(value));
    } catch {
      return null;
    }
  }
});
```

---

## 9. Subscription Management

### Pattern: Unsubscribe Pattern

```typescript
// Vue component
import { onMounted, onUnmounted } from 'vue';

onMounted(() => {
  const unsubscribe = myStore.subscribe(value => {
    console.log('Store updated:', value);
  });

  onUnmounted(() => {
    unsubscribe(); // Prevent memory leaks
  });
});
```

### Pattern: Single Subscription

```typescript
// ❌ BAD - Multiple subscriptions
myStore.subscribe(value => updateUI(value));
myStore.subscribe(value => logChange(value));
myStore.subscribe(value => syncToServer(value));

// ✅ BETTER - Single subscription with multiple handlers
myStore.subscribe(value => {
  updateUI(value);
  logChange(value);
  syncToServer(value);
});
```

---

## 10. Memory Management

### Pattern: Clear Unused Data

```typescript
export const clearWorkflowExecution = (): void => {
  workflowExecutionContext.set(DEFAULT_WORKFLOW_CONTEXT);
  workflowRecoveryData.set({ hasRecoverableWorkflow: false });

  // Clear from persistence
  try {
    saveWorkflowState({
      sessionId: currentSession.get().sessionId,
      lastUpdated: Date.now(),
      currentStep: 0,
      totalSteps: 0,
      stepData: {},
      selectedActions: [],
      selectedAccounts: [],
      configuration: {},
      isComplete: false,
    });
  } catch (error) {
    console.error("Failed to clear workflow:", error);
  }
};
```

### Pattern: Periodic Cleanup

```typescript
// Clear old data periodically
setInterval(() => {
  const recovery = workflowRecoveryData.get();

  // Clear if older than 24 hours
  if (recovery.lastExecutionTime) {
    const hoursSince = (Date.now() - recovery.lastExecutionTime) / (1000 * 60 * 60);
    if (hoursSince > 24) {
      clearWorkflowExecution();
    }
  }
}, 60 * 60 * 1000); // Check every hour
```

---

## Performance Checklist

- [ ] ✅ Auto-save is debounced/throttled
- [ ] ✅ Checkpoints are time-based (not on every change)
- [ ] ✅ Persistence checks availability before saving
- [ ] ✅ Computed stores avoid nested chains
- [ ] ✅ Updates skip unchanged values
- [ ] ✅ Batch updates when possible
- [ ] ✅ Expensive resources are lazy-loaded
- [ ] ✅ Event listeners are cleaned up
- [ ] ✅ localStorage keys are structured
- [ ] ✅ Subscriptions are unsubscribed
- [ ] ✅ Unused data is cleared

---

## Benchmarking Tips

### Measure localStorage Performance

```typescript
const start = performance.now();
localStorage.setItem('key', JSON.stringify(largeObject));
const duration = performance.now() - start;
console.log(`Save took ${duration}ms`);
```

### Measure Store Update Performance

```typescript
const start = performance.now();
myStore.set(newValue);
const duration = performance.now() - start;
console.log(`Update took ${duration}ms`);
```

### Monitor Subscription Overhead

```typescript
let updateCount = 0;
const unsubscribe = myStore.subscribe(() => {
  updateCount++;
  if (updateCount % 100 === 0) {
    console.log(`${updateCount} updates processed`);
  }
});
```

---

## Next Steps

- See **[ssr-safety.md]** for SSR-safe optimizations
- See **[advanced-patterns.md]** for optimized pattern variations
