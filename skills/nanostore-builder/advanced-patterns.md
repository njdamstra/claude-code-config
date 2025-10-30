# Advanced Nanostore Patterns

Real-world patterns from this codebase for complex state management scenarios.

---

## 1. Factory Pattern

**Problem:** Exporting both store instance AND all methods for convenience

**Solution:** Create factory function that binds all methods

### Example: ChatStore Factory

```typescript
class ChatStore extends BaseStore<typeof ChatSchema> {
  constructor() {
    super(APPWRITE_COLL_CHAT, ChatSchema, "chat", "artificial_int");
  }

  async createChat({ title, modelId, context, teamId, userId }) {
    return this.create({
      title,
      modelId,
      context,
      status: "active",
      lastMessageAt: new Date().toISOString(),
      teamId,
      userId,
    } as any);
  }

  async getActiveChats() {
    return this.list([
      Query.equal("status", "active"),
      Query.orderDesc("lastMessageAt"),
    ]);
  }

  async markAsArchived(chatId: string) {
    return this.update(chatId, { status: "archived" });
  }
}

// Factory function - creates instance and exports bound methods
const createChatStore = () => {
  const store = new ChatStore();
  return {
    store,                                    // Access store instance
    createChat: store.createChat.bind(store), // Bound methods
    getActiveChats: store.getActiveChats.bind(store),
    markAsArchived: store.markAsArchived.bind(store),
  };
};

// Single export with everything
export const {
  store: chatStore,
  createChat,
  getActiveChats,
  markAsArchived,
} = createChatStore();
```

**Benefits:**
- Clean import: `import { createChat } from '@/stores/chatStore'`
- No need to access: `chatStore.createChat()`
- Type-safe method exports
- Singleton pattern enforcement

**Usage:**
```typescript
// ✅ Clean
import { createChat, getActiveChats } from '@/stores/chatStore';
await createChat({ title: "New Chat", ... });

// ❌ Verbose
import { chatStore } from '@/stores/chatStore';
await chatStore.createChat({ title: "New Chat", ... });
```

---

## 2. Hybrid Store Pattern

**Problem:** Need both BaseStore CRUD AND custom database operations

**Solution:** Mix BaseStore methods with direct database calls

### Example: WorkflowStore (Mixed Approach)

```typescript
import { atom, computed } from "nanostores";
import { persistentAtom } from "@nanostores/persistent";
import { Databases, Query } from "appwrite";

// Some state uses plain atoms
export const currentWorkflow = persistentAtom<WorkflowNode | null>(
  "currentWorkflow",
  null,
  {
    encode: JSON.stringify,
    decode: JSON.parse,
  }
);

// Other state uses computed
export const workflowExecutionContext = atom<WorkflowExecutionContext>({
  startTime: Date.now(),
  currentStep: 0,
  steps: [],
  // ...
});

export const workflowProgress = computed(
  workflowExecutionContext,
  (context) => {
    if (context.totalSteps === 0) return 0;
    const completed = context.steps.filter(step => step.isComplete).length;
    return Math.round((completed / context.totalSteps) * 100);
  }
);

// Some operations use direct database access
export const getWorkflow = async (workflowId: string) => {
  const { client } = useAppwriteClient();
  const databases = new Databases(client);
  return databases.getDocument(
    "workflows",
    APPWRITE_COLL_WORKFLOWS,
    workflowId
  );
};

export const createWorkflow = async (name: string, ownerId: string) => {
  const { client } = useAppwriteClient();
  const databases = new Databases(client);
  const ulid = ulidFactory();
  return databases.createDocument(
    "workflows",
    APPWRITE_COLL_WORKFLOWS,
    ulid(),
    { name, ownerId, isActive: false }
  );
};
```

**Why Hybrid?**
- Different data needs different handling
- Some state is client-only (execution context)
- Some data is database-only (workflow definitions)
- Computed values derived from both

**When to Use:**
- Complex feature with multiple data sources
- Mix of persistent and ephemeral state
- Need both CRUD and custom operations
- Different lifecycle requirements

---

## 3. Multi-Atom Orchestration

**Problem:** Complex feature needs coordinated state management across multiple atoms

**Solution:** Use multiple specialized stores with orchestration functions

### Example: FloatingPanelStore

```typescript
import { map, computed } from 'nanostores';
import { persistentAtom, persistentMap } from '@nanostores/persistent';

// 1. Persistent panel configurations (survives reload)
export const panelConfigs = persistentMap<Record<string, FloatingPanelConfig>>(
  'floating-panels:',
  {},
  { encode: JSON.stringify, decode: JSON.parse }
);

// 2. Persistent manager state (global settings)
export const panelManagerState = persistentAtom<PanelManagerState>(
  'panel-manager-state',
  {
    panelOrder: [],
    globalZIndex: 1000,
    settings: {
      enableAnimations: true,
      enableSnapping: true,
      snapThreshold: 50,
    }
  },
  { encode: JSON.stringify, decode: JSON.parse }
);

// 3. Runtime state (resets on reload)
export const runtimePanelState = map<Record<string, {
  isDragging: boolean;
  isResizing: boolean;
  element?: HTMLElement;
}>>({});

// 4. Computed values
export const visiblePanels = computed(panelConfigs, (configs) =>
  Object.values(configs).filter(panel => panel.isVisible)
);

export const topPanel = computed(panelConfigs, (configs) => {
  const visible = Object.values(configs).filter(panel => panel.isVisible);
  if (visible.length === 0) return null;
  return visible.reduce((highest, panel) =>
    panel.zIndex > highest.zIndex ? panel : highest
  );
});

// 5. Orchestration functions (coordinate multiple stores)
export const createPanel = (
  id: string,
  options: Partial<FloatingPanelConfig> = {}
): FloatingPanelConfig => {
  const state = panelManagerState.get();
  const configs = panelConfigs.get();

  // Create panel config
  const newPanel: FloatingPanelConfig = {
    id,
    position: options.position || state.settings.defaultPosition,
    size: options.size || state.settings.defaultSize,
    isVisible: options.isVisible ?? false,
    zIndex: state.globalZIndex + 1,
    lastUpdated: Date.now()
  };

  // Update configs
  panelConfigs.setKey(id, newPanel);

  // Update manager state
  panelManagerState.set({
    ...state,
    panelOrder: [...state.panelOrder, id],
    globalZIndex: newPanel.zIndex
  });

  return newPanel;
};

export const deletePanel = (id: string): void => {
  const configs = panelConfigs.get();
  const state = panelManagerState.get();

  // Remove from configs
  const newConfigs = { ...configs };
  delete newConfigs[id];
  panelConfigs.set(newConfigs);

  // Remove from runtime
  const runtimeState = runtimePanelState.get();
  const newRuntimeState = { ...runtimeState };
  delete newRuntimeState[id];
  runtimePanelState.set(newRuntimeState);

  // Update manager
  panelManagerState.set({
    ...state,
    activePanel: state.activePanel === id ? undefined : state.activePanel,
    panelOrder: state.panelOrder.filter(panelId => panelId !== id)
  });
};
```

**Key Patterns:**
- **Separation of Concerns:** Each atom has specific responsibility
- **Orchestration Functions:** Coordinate updates across atoms
- **Computed Derivations:** Reactive transformations
- **Mixed Persistence:** Some persistent, some ephemeral

**Benefits:**
- Clear data ownership
- Optimized persistence (only save what matters)
- Efficient reactivity (computed auto-updates)
- Easy to test individual pieces

---

## 4. API Integration Pattern

**Problem:** Want BaseStore benefits but also need API endpoint fallback

**Solution:** Try API first, fall back to BaseStore

### Example: ChatStore with API Integration

```typescript
class ChatStore extends BaseStore<typeof ChatSchema> {
  constructor() {
    super(APPWRITE_COLL_CHAT, ChatSchema, "chat", "artificial_int");
  }

  async createChat({ title, modelId, context, metadata, teamId, userId }) {
    // Try API endpoint first
    try {
      const response = await fetch('/api/chat/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({
          title,
          modelId,
          context,
          metadata,
          teamId,
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to create chat');
      }

      const { data: chat } = await response.json();
      return chat;
    } catch (error) {
      // Fallback to direct database access
      console.warn('Chat API failed, falling back to direct database:', error);
      return this.create({
        title,
        modelId,
        context,
        status: "active",
        lastMessageAt: new Date().toISOString(),
        metadata: metadata ? JSON.stringify(metadata) : undefined,
        teamId,
        userId,
      } as any);
    }
  }
}
```

**Why This Pattern?**
- API can handle complex business logic
- Server can enforce additional validation
- Fallback ensures resilience
- BaseStore provides consistent interface

**When to Use:**
- Complex creation logic on server
- Need server-side validation
- Want resilience if API unavailable
- Gradual migration to API endpoints

---

## 5. Singleton with Direct Client Access

**Problem:** Need both BaseStore CRUD and direct Appwrite SDK access

**Solution:** Expose client getters alongside BaseStore methods

### Example: TeamStore

```typescript
class TeamStore extends BaseStore<typeof TeamPrefsSchema> {
  constructor() {
    super(APPWRITE_COLL_MEMBERS, TeamPrefsSchema, "currentTeam", databaseId);
  }

  // BaseStore provides: db, storage, functions via getters

  async getTeamById(teamId: string) {
    // Direct Teams API access (not a database collection)
    return this.teams.get(teamId);
  }

  async listTeams(queries?: string[], search?: string) {
    // Use Teams API directly
    return this.teams.list(queries, search);
  }

  async createTeam(name: string, roles?: string[], id?: string) {
    const ulid = await this.getUlidFactory();
    let teamId = id ?? ulid();
    return this.teams.create(teamId, name, roles || TEAM_ROLES);
  }

  async updateTeamName(teamId: string, name: string) {
    const updatedTeam = await this.teams.updateName(teamId, name);
    // Also update persistent atom
    if (selectedUserTeam.get()?.$id === teamId) {
      setSelectedUserTeam(updatedTeam);
    }
    return updatedTeam;
  }

  // Mix BaseStore methods for member documents
  async getTeamPrefs(teamId: string): Promise<TeamPrefs> {
    const team = await this.getTeamById(teamId);
    return TeamPrefsSchema.parse(team.prefs);
  }
}
```

**Pattern Benefits:**
- Access Appwrite SDK directly when needed
- Still use BaseStore for member documents
- Coordinate updates across multiple APIs
- Type-safe through class methods

---

## 6. Session Recovery Pattern

**Problem:** Need to recover user's work after page reload or crash

**Solution:** Auto-save with checkpoints and recovery functions

### Example: Workflow Session Recovery

```typescript
// Persistent recovery metadata
export const workflowRecoveryData = persistentAtom<{
  hasRecoverableWorkflow: boolean;
  lastSessionId?: string;
  lastExecutionTime?: number;
  workflowId?: string;
  step?: number;
}>("workflow-recovery", { hasRecoverableWorkflow: false }, {
  encode: JSON.stringify,
  decode: JSON.parse,
});

// Auto-save function
function autoSaveWorkflowState(): void {
  const context = workflowExecutionContext.get();

  if (!storageStatus.get().available) return;

  try {
    const workflowState: Partial<WorkflowSessionState> = {
      workflowId: context.workflowId,
      currentStep: context.currentStep,
      stepData: context.steps.reduce((acc, step) => {
        acc[step.stepId] = step.data;
        return acc;
      }, {} as Record<string, any>),
      lastUpdated: Date.now(),
      sessionId: context.sessionId,
    };

    saveWorkflowState(workflowState);

    // Update recovery metadata
    workflowRecoveryData.set({
      hasRecoverableWorkflow: true,
      lastSessionId: context.sessionId,
      lastExecutionTime: Date.now(),
      workflowId: context.workflowId,
      step: context.currentStep,
    });
  } catch (error) {
    console.error("Failed to auto-save:", error);
  }
}

// Recovery function
export function loadWorkflowFromPersistence(): boolean {
  try {
    const storedState = loadWorkflowState();
    if (!storedState) return false;

    // Reconstruct context from stored data
    const context: WorkflowExecutionContext = {
      workflowId: storedState.workflowId,
      currentStep: storedState.currentStep || 0,
      steps: reconstructSteps(storedState.stepData),
      sessionId: currentSession.get().sessionId,
      // ...
    };

    workflowExecutionContext.set(context);
    return true;
  } catch (error) {
    console.error("Recovery failed:", error);
    return false;
  }
}

// Check for recoverable data
export function checkForRecoverableWorkflow() {
  const recovery = workflowRecoveryData.get();
  return {
    hasRecoverable: recovery.hasRecoverableWorkflow,
    lastTime: recovery.lastExecutionTime,
    workflowId: recovery.workflowId,
  };
}
```

**Pattern Features:**
- Auto-save on changes (debounced)
- Checkpoint recovery metadata
- Validate before restoring
- Clear API for recovery checks

---

## 7. Coordinated Cleanup Pattern (useAuth)

**Problem:** On logout, need to clear multiple stores in correct order to prevent race conditions

**Solution:** Orchestrated cleanup with specific ordering and timing

### Example: useAuth Logout

```typescript
// useAuth.ts composable
const logout = async () => {
  isLoading.value = true;
  error.value = null;
  try {
    // STEP 1: Set logout flags IMMEDIATELY (prevents auto-login during cleanup)
    const { isLoggingOut, recentLogout } = await import('@/stores/authStore');
    isLoggingOut.set(true);
    recentLogout.set(Date.now());

    // STEP 2: Clear core auth state FIRST
    clearCurUser(); // Clears: curUser, curUserSession, curUserJwt, isLoggingOut

    // STEP 3: Clear dependent stores in specific order
    // Team state (depends on user)
    clearSelectedUserTeam();
    clearCurrentUserMemberships();

    // Billing state (depends on user + team)
    clearBilling();
    clearBillingBonus();

    // Provider-specific state
    clearAllTiktokCreatorInfo();

    // Cached data
    clearOAuthCache();
    clearBillingCache();
    clearMediaCache();
    clearAllAnalyticsStores();

    // STEP 4: Call server-side logout (after client state cleared)
    await logoutUser(); // Deletes sessions, clears server cookies

    // STEP 5: Brief wait to ensure state propagation
    await new Promise((resolve) => setTimeout(resolve, 100));

    return true;
  } catch (err) {
    error.value = err instanceof Error ? err.message : "Logout failed";
    throw err;
  } finally {
    isLoading.value = false;
  }
};
```

### clearCurUser Implementation

```typescript
// authStore.ts
export const clearCurUser = () => {
  curUser.set(null);
  curUserSession.set(null);
  curUserJwt.set(null);
  isLoggingOut.set(false);

  // Also clear any cached session state
  clearFallbackCookies();
};
```

### Pattern Features

**1. Logout Flags (Prevent Race Conditions)**
```typescript
// Persistent atoms to prevent auto-login during logout
export const isLoggingOut = persistentAtom<boolean>("isLoggingOut", false, {
  encode: JSON.stringify,
  decode: (value) => {
    try {
      return JSON.parse(value);
    } catch {
      return false;
    }
  },
});

export const recentLogout = persistentAtom<number>("recentLogout", 0, {
  encode: JSON.stringify,
  decode: (value) => {
    try {
      return JSON.parse(value);
    } catch {
      return 0;
    }
  },
});

// Check in currentUser() to prevent auto-login
export const currentUser = async () => {
  // Block if actively logging out
  if (isLoggingOut.get()) {
    return null;
  }

  // Check if recently logged out (within 5 seconds)
  const lastLogout = recentLogout.get();
  if (Date.now() - lastLogout < 5000) {
    return null;
  }

  // Safe to proceed...
};
```

**2. Specific Ordering (Dependencies)**
```
1. Auth state (base dependency)
   ↓
2. Team state (depends on user)
   ↓
3. Billing state (depends on user + team)
   ↓
4. Provider state (depends on auth)
   ↓
5. Cached data (depends on all above)
   ↓
6. Server cleanup (after client cleared)
```

**3. Timing Control**
```typescript
// Set logout flags with timestamp
isLoggingOut.set(true);
recentLogout.set(Date.now());

// Clear flags after cleanup
setTimeout(() => {
  isLoggingOut.set(false);
}, 2000); // 2 second delay

// Clear recent logout after grace period
setTimeout(() => {
  recentLogout.set(0);
}, 5000); // 5 second delay
```

### Why This Pattern Works

**Prevents Race Conditions:**
- Logout flags block `currentUser()` during cleanup
- Recent logout timestamp prevents immediate re-login
- Ordered clearing respects dependencies

**Complete Cleanup:**
- Clears client state before server
- Cascades through dependent stores
- Clears caches and temporary data

**Resilient:**
- Even if server call fails, client is cleared
- Timing delays prevent rapid re-authentication
- Guards in `currentUser()` provide safety net

### Other Store Clear Functions

```typescript
// teamStore.ts
export const clearSelectedUserTeam = () => {
  selectedUserTeam.set(null);
};

export const clearCurrentUserMemberships = () => {
  currentUserMemberships.set([]);
};

// billingStore.ts
export const clearBilling = () => {
  currentPricingTier.set(null);
  subscriptionStatus.set(null);
};

// tiktokStore.ts
export const clearAllTiktokCreatorInfo = () => {
  tiktokCreatorInfo.set({});
};

// analyticsStore.ts
export const clearAllAnalyticsStores = () => {
  Object.keys(analyticsStoreCache).forEach(key => {
    delete analyticsStoreCache[key];
  });
};
```

### Pattern Benefits

- **Coordinated:** Single function orchestrates all cleanup
- **Ordered:** Dependencies respected in clear sequence
- **Race-Safe:** Flags prevent concurrent operations
- **Complete:** All related state cleared
- **Resilient:** Handles failures gracefully
- **Timing-Aware:** Delays prevent immediate re-login

### When to Use This Pattern

- ✅ Authentication/logout flows
- ✅ Multiple dependent stores
- ✅ Need to prevent race conditions
- ✅ Order of operations matters
- ✅ State reset across features
- ✅ User switching scenarios

---

## Pattern Comparison

| Pattern | Complexity | Use Case | Best For |
|---------|-----------|----------|----------|
| **Factory** | Low | Clean exports | Single stores with many methods |
| **Hybrid** | Medium | Mixed data sources | Complex features |
| **Multi-Atom** | High | Coordinated state | Feature with multiple concerns |
| **API Integration** | Medium | Server logic | Gradual API migration |
| **Singleton + SDK** | Medium | Direct API access | Appwrite Teams, Storage APIs |
| **Session Recovery** | High | User work protection | Long-running workflows |
| **Coordinated Cleanup** | Medium | Multi-store reset | Logout, user switching, state reset |

---

## When to Use Each Pattern

### Factory Pattern
- ✅ Store has 5+ methods
- ✅ Want clean imports
- ✅ Singleton makes sense

### Hybrid Store
- ✅ Multiple data sources
- ✅ Mix of client/server state
- ✅ Different persistence needs

### Multi-Atom Orchestration
- ✅ Complex UI feature
- ✅ Multiple state concerns
- ✅ Need granular reactivity

### API Integration
- ✅ Server-side validation needed
- ✅ Complex creation logic
- ✅ Want fallback resilience

### Session Recovery
- ✅ Long-running processes
- ✅ User work is valuable
- ✅ Need crash recovery

### Coordinated Cleanup
- ✅ Multiple dependent stores
- ✅ Logout/reset flows
- ✅ Need race condition prevention
- ✅ Order matters for cleanup
- ✅ User switching

---

## Next Steps

- See **[ssr-safety.md]** for making these patterns SSR-safe
- See **[performance.md]** for optimizing auto-save and reactivity
