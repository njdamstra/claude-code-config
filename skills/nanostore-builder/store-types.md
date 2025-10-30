# Store Types Guide

Comprehensive guide to all nanostore types with real-world examples from this codebase.

## Overview

| Store Type | Purpose | Persists? | Use Case |
|------------|---------|-----------|----------|
| `BaseStore<T>` | Appwrite CRUD | ✅ DB | Database collections |
| `persistentAtom<T>` | Single value | ✅ localStorage | User preferences, current selection |
| `persistentMap<T>` | Key-value pairs | ✅ localStorage | Multiple items by ID |
| `atom<T>` | Runtime state | ❌ | UI state, flags, temporary data |
| `computed()` | Derived state | ❌ | Calculated from other stores |

---

## 1. BaseStore<T> - Appwrite Collections

**When to use:**
- Managing Appwrite collection data
- Need CRUD operations with validation
- Require realtime subscriptions
- Data needs to sync with database

### Example: ChatStore

```typescript
import { BaseStore } from "./baseStore";
import { ChatSchema, type Chat } from "@appwrite/schemas/chat";
import { APPWRITE_COLL_CHAT } from "astro:env/client";

class ChatStore extends BaseStore<typeof ChatSchema> {
  constructor() {
    super(APPWRITE_COLL_CHAT, ChatSchema, "chat", "artificial_int");
  }

  async createChat({
    title,
    modelId,
    context,
    teamId,
    userId,
  }: {
    title: string;
    modelId: string;
    context?: string;
    teamId: string;
    userId: string;
  }) {
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
}

export const chatStore = new ChatStore();
```

**Key Features:**
- Automatic Zod validation
- Built-in CRUD methods
- Collection-specific queries
- Type-safe operations

---

## 2. persistentAtom<T> - Single Persistent Values

**When to use:**
- Single piece of client state
- Needs to survive page reloads
- User preferences or selections
- Authentication tokens (with expiry)

### Example: Current User

```typescript
import { persistentAtom } from "@nanostores/persistent";
import type { Models } from "appwrite";

export const curUser = persistentAtom<Models.User<Models.Preferences> | null>(
  "curUser",
  null,
  {
    encode: JSON.stringify,
    decode: (value) => {
      try {
        return JSON.parse(value);
      } catch {
        return null;
      }
    },
  }
);

// Usage
export const setCurrentUser = (user: Models.User<Models.Preferences>) => {
  curUser.set(user);
};

export const clearCurrentUser = () => {
  curUser.set(null);
};
```

### Example: JWT Cache with Expiry

```typescript
interface JwtStore {
  jwt: string;
  expiresAt: number;
}

export const curUserJwt = persistentAtom<JwtStore | null>("curUserJwt", null, {
  encode: JSON.stringify,
  decode: (value: string) => {
    try {
      const parsed = JSON.parse(value);
      // Validate not expired
      if (parsed.expiresAt > Date.now()) {
        return parsed;
      }
      return null;
    } catch {
      return null;
    }
  },
});
```

**Best Practices:**
- Always provide default values
- Handle JSON parse errors
- Validate data on decode
- Use TypeScript for type safety

---

## 3. persistentMap<T> - Multiple Key-Value Pairs

**When to use:**
- Multiple related items stored by ID
- Each item needs independent persistence
- Frequent updates to individual items
- Dynamic collection of client state

### Example: Panel Configurations

```typescript
import { persistentMap } from '@nanostores/persistent';

export interface FloatingPanelConfig {
  id: string;
  position: { x: number; y: number };
  size: { width: number; height: number };
  isVisible: boolean;
  isMinimized: boolean;
  zIndex: number;
}

export const panelConfigs = persistentMap<Record<string, FloatingPanelConfig>>(
  'floating-panels:',  // Prefix for localStorage keys
  {},
  {
    encode: JSON.stringify,
    decode: (value) => {
      try {
        return JSON.parse(value);
      } catch {
        return {};
      }
    }
  }
);

// Update individual panel
export const updatePanel = (id: string, updates: Partial<FloatingPanelConfig>) => {
  const configs = panelConfigs.get();
  const existing = configs[id];

  if (existing) {
    panelConfigs.setKey(id, {
      ...existing,
      ...updates,
      lastUpdated: Date.now()
    });
  }
};
```

**Key Benefits:**
- Each key stored separately in localStorage
- Update one item without re-saving all
- Easy to add/remove items
- Good for dynamic collections

---

## 4. atom<T> - Ephemeral Runtime State

**When to use:**
- UI state that resets on page reload
- Temporary flags or toggles
- Drag/drop state
- Modal open/closed state

### Example: Navigation State

```typescript
import { atom } from "nanostores";

export type NavigationMode = "chat" | "post" | null;

export interface NavigationState {
  lastActiveMode: NavigationMode;
  isChatOpen: boolean;
  isPostModalOpen: boolean;
}

export const navigationState = atom<NavigationState>({
  lastActiveMode: null,
  isChatOpen: false,
  isPostModalOpen: false,
});

// Actions
export const setChatOpen = (isOpen: boolean) => {
  navigationState.set({
    ...navigationState.get(),
    isChatOpen: isOpen,
    lastActiveMode: isOpen ? "chat" : navigationState.get().lastActiveMode,
  });
};

export const closeAllModals = () => {
  navigationState.set({
    ...navigationState.get(),
    isChatOpen: false,
    isPostModalOpen: false,
  });
};
```

**Perfect for:**
- Modal visibility
- Active tab/section
- Drag state
- Loading flags
- Temporary selections

---

## 5. computed() - Derived State

**When to use:**
- Value calculated from other stores
- Reactive transformations
- Filtered or sorted lists
- Aggregated data

### Example: Visible Panels

```typescript
import { computed } from 'nanostores';

// Source store
export const panelConfigs = persistentMap<Record<string, FloatingPanelConfig>>(...);

// Computed stores
export const visiblePanels = computed(panelConfigs, (configs) =>
  Object.values(configs).filter(panel => panel.isVisible)
);

export const visiblePanelIds = computed(visiblePanels, (panels) =>
  panels.map(panel => panel.id)
);

export const topPanel = computed(panelConfigs, (configs) => {
  const visible = Object.values(configs).filter(panel => panel.isVisible);
  if (visible.length === 0) return null;

  return visible.reduce((highest, panel) =>
    panel.zIndex > highest.zIndex ? panel : highest
  );
});
```

### Example: Workflow Progress

```typescript
export const workflowProgress = computed(
  workflowExecutionContext,
  (context) => {
    if (context.totalSteps === 0) return 0;
    const completedSteps = context.steps.filter((step) => step.isComplete).length;
    return Math.round((completedSteps / context.totalSteps) * 100);
  }
);

export const canProceedToNextStep = computed(
  [currentWorkflowStep, hasValidationErrors],
  (currentStep, hasErrors) => {
    return currentStep?.isComplete && !hasErrors;
  }
);
```

**Benefits:**
- Automatic reactivity
- No manual updates needed
- Cached until dependencies change
- Type-safe transformations

---

## Comparison Table

| Feature | BaseStore | persistentAtom | persistentMap | atom | computed |
|---------|-----------|----------------|---------------|------|----------|
| **Persistence** | Database | localStorage | localStorage | None | None |
| **Reactivity** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Server Sync** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Zod Validation** | ✅ | Manual | Manual | Manual | N/A |
| **CRUD Methods** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Best For** | DB data | Single value | Multiple items | UI state | Derived |
| **SSR Safe** | ⚠️ | ⚠️ | ⚠️ | ✅ | ✅ |

**Legend:**
- ✅ Yes, built-in
- ❌ No
- ⚠️ Requires guards (see ssr-safety.md)

---

## Decision Examples

### ❓ "I need to store user's theme preference"
→ **Use `persistentAtom<string>`** - Single value, needs to persist

### ❓ "I need to manage chat messages from Appwrite"
→ **Use `BaseStore<typeof ChatMessageSchema>`** - Database collection

### ❓ "I need to track which panels are open"
→ **Use `persistentMap<Record<string, PanelConfig>>`** - Multiple items by ID

### ❓ "I need to show if modal is open"
→ **Use `atom<boolean>`** - Temporary UI state

### ❓ "I need to show filtered list of users"
→ **Use `computed(users, filter => users.filter(...))`** - Derived from other stores

---

## Vue Integration

All store types work with `useStore()`:

```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue';
import { curUser } from '@/stores/authStore';
import { visiblePanels } from '@/stores/floatingPanelStore';
import { navigationState } from '@/stores/navigationStore';

const user = useStore(curUser);
const panels = useStore(visiblePanels);
const nav = useStore(navigationState);
</script>

<template>
  <div v-if="user">{{ user.name }}</div>
  <div>{{ panels.length }} panels open</div>
  <div v-if="nav.isChatOpen">Chat is open</div>
</template>
```

---

## Next Steps

- See **[advanced-patterns.md]** for factory patterns and hybrid stores
- See **[ssr-safety.md]** for client-side guards
- See **[performance.md]** for optimization strategies
