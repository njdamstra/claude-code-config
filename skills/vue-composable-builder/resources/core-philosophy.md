# Core Philosophy

### Composables = Behavior Reuse, NOT Data Sharing

**CRITICAL DISTINCTION:**

```typescript
// ✅ Composable: Each call = NEW state instance (isolated)
export function useCounter() {
  const count = ref(0) // New count per component
  return { count, increment: () => count.value++ }
}

// Component A
const counterA = useCounter() // count = 0

// Component B
const counterB = useCounter() // NEW count = 0 (isolated!)
```

```typescript
// ✅ Store: Shared singleton state across all components
import { atom } from 'nanostores'

export const $count = atom(0)

// Component A and B share same count
```

### Business Logic Layer

Composables sit between components and stores:

```
Components → UI + user interaction
    ↓
Composables → Business logic + orchestration + side effects
    ↓
Stores → Data structure + CRUD + persistence
    ↓
Infrastructure → Appwrite SDK + sessions + BaseStore
```

**Composables SHOULD:**
- Import store atoms and methods
- Add loading/error states
- Orchestrate multiple stores
- Handle side effects (API calls, events, timers)
- Manage browser API access
- Provide component-friendly APIs
- Use VueUse for common patterns
- Clean up on unmount

**Composables SHOULD NOT:**
- Create BaseStore instances (use nanostore-builder)
- Define Zod schemas (use stores or API routes)
- Render UI elements (use vue-component-builder)
- Handle Tailwind styling (use components)
- Configure Appwrite collections (use appwrite-integration)
