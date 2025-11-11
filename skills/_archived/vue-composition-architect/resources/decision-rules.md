# Decision Rules

### "3 Unrelated Components" Rule

**Rule:** If you can't name 3 unrelated components that need this state, it doesn't belong in a store.

```
How many unrelated components need this state?
├─ 1-2 components → Local state or composable
└─ 3+ unrelated components → Nanostore
```

**Example:**
```typescript
// ❌ PREMATURE: Store for component-specific state
export const $modalOpen = atom(false)
// Only used by Modal.vue

// ✅ APPROPRIATE: Local state in component
const isOpen = ref(false)
```

### "200 Lines" Rule

**Rule:** Keep composables < 200 lines each.

- Forces single responsibility
- Improves testability
- Enhances reusability

**When to split:**
- 200+ lines = consider extraction
- 300+ lines = strong signal to split
- 500+ lines = must split

### "Props vs Provide/Inject" Rule

Choose based on component relationship:

- **Props:** Direct parent-child (1 level)
- **Provide/inject:** Parent → descendants (2+ levels, same feature)
- **Nanostore:** Any component → any other component (global)

```
How many levels does data travel?
├─ 1 level (parent → child) → Props
├─ 2+ levels (parent → grandchild+) → Provide/Inject
└─ Any → any (unrelated components) → Nanostore
```
