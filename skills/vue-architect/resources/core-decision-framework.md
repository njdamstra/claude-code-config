# Core Decision Framework

### The State Placement Hierarchy

**Start at the top, only move down when you hit a specific problem:**

```
Level 1: Local Component State (ref/reactive)
   ↓ Problem: Multiple related components need same behavior
Level 2: Composables (useX pattern)
   ↓ Problem: Multiple unrelated components need same data
Level 3: Provide/Inject (component subtree)
   ↓ Problem: Truly global state needed everywhere
Level 4: Nanostore (global singleton state)
```

**The Iron Law:**

```
COLOCATE STATE AS CLOSE AS POSSIBLE TO WHERE IT'S USED
```

Only lift state when you have **concrete evidence** multiple unrelated components need access.

### State Type Decision Matrix

| Question | Answer | Pattern |
|----------|--------|---------|
| Does parent need to control this? | Yes → | **Props (controlled)** |
| Does parent need to read/write? | Yes → | **v-model (two-way)** |
| Is state temporary/ephemeral? | Yes → | **Local state** |
| Is state reusable behavior? | Yes → | **Composable** |
| Used by component subtree? | Yes → | **Provide/inject** |
| Used by 3+ unrelated components? | Yes → | **Nanostore** |
| Is state persistent? | Yes → | **Nanostores persistentAtom** |

### Component State vs Props Decision Tree

```
Is data passed from parent?
├─ YES → Use props
│  └─ Does parent need updates?
│     ├─ YES → Use v-model (two-way binding)
│     └─ NO → Use props + emit pattern
│
└─ NO → Is data component-specific?
   ├─ YES → Local state (ref/reactive)
   └─ NO → Is it reusable logic?
      ├─ YES → Composable (useX)
      └─ NO → Nanostore (atom/map)
```
