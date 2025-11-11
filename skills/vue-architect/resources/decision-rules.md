# Decision Rules Summary

### The "3 Unrelated Components" Rule

**Before creating a store, ask:**
> Can I name 3 unrelated components that need this state?

- **No:** Keep local or use composable
- **Yes:** Create store

### The "Single Responsibility" Rule

**Before adding to existing store, ask:**
> Does this belong to the same concern?

- **No:** Create separate store
- **Yes:** Add to existing

### The "Prop Drilling" Threshold

**Before using provide/inject, ask:**
> Are props passing through 3+ levels?

- **No:** Use props
- **Yes:** Use provide/inject or store

### The "Reusability" Test

**Before extracting to composable, ask:**
> Is this logic used in 2+ components?

- **No:** Keep inline
- **Yes:** Extract to composable
