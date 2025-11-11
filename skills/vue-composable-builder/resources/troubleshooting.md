# Troubleshooting

### Issue: Composable state shared between components

**Symptoms:** Multiple components share same state unexpectedly

**Solutions:**
1. Verify composable creates new state per call (not module-level)
2. Use store for intentional state sharing
3. Check for accidental module-level refs

### Issue: Memory leaks

**Symptoms:** Performance degrades over time

**Solutions:**
1. Add `onUnmounted` cleanup for event listeners
2. Clear intervals/timeouts
3. Stop watchers if created manually: `stopWatch()`

### Issue: SSR hydration mismatches

**Symptoms:** Warning about server/client content mismatch

**Solutions:**
1. Use `useMounted()` before accessing browser APIs
2. Guard with `if (window)` checks
3. Use `<ClientOnly>` for client-only content

### Issue: Type inference fails

**Symptoms:** TypeScript can't infer return types

**Solutions:**
1. Add explicit return type annotation
2. Use `as Ref<T>` for complex refs
3. Define interfaces for return objects
