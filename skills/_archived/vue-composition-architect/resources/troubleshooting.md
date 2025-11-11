# Troubleshooting

### Issue: Child can't find injected context

**Symptoms:** `inject()` returns `undefined`, error "context not found"

**Solutions:**
1. Verify provider is ancestor (not sibling)
2. Check injection key matches
3. Ensure provide() called before inject()
4. Add default value: `inject(key, defaultValue)`

### Issue: Context updates don't trigger reactivity

**Symptoms:** UI doesn't update when context value changes

**Solutions:**
1. Use `ref()` or `reactive()` for provided values
2. Don't destructure: `const { value } = inject(key)` breaks reactivity
3. Use computed for derived state: `computed(() => context.value.property)`

### Issue: Tight coupling remains after refactor

**Symptoms:** Child components still assume parent structure

**Solutions:**
1. Use InjectionKey with TypeScript interface (not implicit keys)
2. Document required context in component
3. Add validation: throw error if context missing
4. Make context requirements explicit

### Issue: Performance degrades with provide/inject

**Symptoms:** Unnecessary re-renders, slow updates

**Solutions:**
1. Use `readonly()` for read-only state
2. Split context into smaller pieces (UI state vs data state)
3. Use `shallowRef` for large objects
4. Memoize expensive computations with `computed()`

### Issue: Testing becomes difficult

**Symptoms:** Hard to test components in isolation

**Solutions:**
1. Create test providers: `provideTestContext(overrides)`
2. Use factory functions for context creation
3. Accept context as optional prop for testing
4. Mock injection in tests

### Issue: Over-Splitting

**Problem:** Split too granularly, creating maintenance burden

**Symptoms:**
- Many tiny files (< 50 lines each)
- Difficult to navigate codebase
- No clear benefit from split

**Solutions:**
1. Only split when 2+ split triggers present
2. Group related concerns (don't split every 10 lines)
3. Validate: Does split improve testability/reusability?

**Example:**
```typescript
// ❌ TOO GRANULAR: 3 composables for one concern
const data = useData()
const loading = useLoading()
const error = useError()

// ✅ APPROPRIATE: Consolidated related state
const { data, isLoading, error } = useFetch()
```

### Issue: Premature Store Abstraction

**Problem:** Lift state to Nanostore too early

**Symptoms:**
- Store used by only 1-2 components
- State could be local or composable
- Global state for component-specific concern

**Solutions:**
1. Start local, lift only when 3+ unrelated components need it
2. Use "3 Unrelated Components" rule
3. Prefer composables for reusable logic (isolated state)

**Example:**
```typescript
// ❌ PREMATURE: Store for component-specific state
export const $modalOpen = atom(false)
// Only Modal.vue uses this

// ✅ APPROPRIATE: Local state in component
const isOpen = ref(false)
```

### Issue: State Too High in Tree

**Problem:** State lives in parent but only child uses it

**Symptoms:**
- Props passed down but not used by intermediaries
- State changes trigger unnecessary parent re-renders
- State conceptually belongs to child feature

**Solutions:**
1. Apply state colocation principle
2. Move state to closest common ancestor
3. Use provide/inject if 3+ levels, local state if 1 level
