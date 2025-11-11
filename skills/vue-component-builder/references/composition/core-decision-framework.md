# Core Decision Framework

### Problem → Solution Matrix

| Problem | Solution Pattern | When to Use |
|---------|-----------------|-------------|
| **Props passed through 3+ levels** | Provide/Inject | Component subtree needs data, intermediaries don't |
| **Multiple coordinated siblings** | Compound Components | Accordion, Dialog, Select, Tabs |
| **Full design control needed** | Headless UI + asChild | Building design system primitives |
| **Parent controls child behavior** | Scoped Slots | Parent provides data/functions to child via slot props |
| **Reusable logic without UI** | Renderless Components | Extract behavior (FetchData, MouseTracker) |
| **300+ line component** | Split by Responsibility | Extract focused sub-components with orchestrator |
| **500+ line composable** | Split by Concern | Extract focused composables with orchestrator |

### Composition Patterns Hierarchy

```
Level 1: Props + Events (Direct parent-child, 1-2 levels)
   ↓
Level 2: Slots (Content injection, 2-3 levels)
   ↓
Level 3: Scoped Slots (Data passing back to parent)
   ↓
Level 4: Provide/Inject (Component subtree, 3+ levels)
   ↓
Level 5: Compound Components (Coordinated siblings via context)
   ↓
Level 6: Headless UI (Behavior without presentation)
```

**Rule:** Start at Level 1, only move down when you hit the specific problem that level solves.

### State Placement Hierarchy

```
Component receives props/state from parent?
├─ YES → Can keep state local in this component?
│  ├─ YES → Local state (ref/reactive)
│  └─ NO → Multiple siblings need this state?
│     ├─ YES → Provide/Inject (if same feature) OR Nanostore (if unrelated)
│     └─ NO → Props from parent
└─ NO → Is this reusable behavior (not data)?
   ├─ YES → Composable (isolated state per instance)
   └─ NO → Is state shared across unrelated components (3+)?
      ├─ YES → Nanostore (global state)
      └─ NO → Local state (ref/reactive)
```
