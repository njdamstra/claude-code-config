# Composable Checklist

Before finalizing a composable, verify:

- [ ] Clear function name starting with `use*`
- [ ] Follows structure: state → computed → methods → lifecycle → return
- [ ] SSR-safe (uses `useMounted()` or `useSupported()` for browser APIs)
- [ ] Imports stores (doesn't create them)
- [ ] Adds loading/error states if async
- [ ] Proper cleanup in `onUnmounted()`
- [ ] Returns clear API (state + methods)
- [ ] TypeScript types defined
- [ ] Uses VueUse for common patterns
- [ ] No UI rendering logic (that's for components)
- [ ] No store creation (that's for nanostore-builder)
- [ ] Parameters accept MaybeRefOrGetter where appropriate
- [ ] Returns plain destructurable object
