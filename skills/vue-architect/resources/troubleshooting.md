# Troubleshooting

### Issue: State updates don't trigger re-renders

**Symptoms:** UI doesn't update when state changes

**Solutions:**
1. Use `ref()` or `reactive()` for state
2. Don't destructure reactive objects
3. Mutate refs with `.value`
4. Use `triggerRef()` for manual updates with shallowRef

### Issue: Composable state is shared when it shouldn't be

**Symptoms:** Multiple components share same state unexpectedly

**Solutions:**
1. Verify composable creates new state per call
2. Don't use module-level state in composables
3. Use stores for intentional state sharing

### Issue: Performance degrades with large lists

**Symptoms:** Slow renders, memory issues

**Solutions:**
1. Use `shallowRef` for large arrays
2. Use `computed` for derived state
3. Implement virtual scrolling
4. Paginate large datasets

### Issue: Form updates parent immediately

**Symptoms:** Parent data changes before Submit

**Solutions:**
1. Create local draft copy with `structuredClone()`
2. Only commit draft to parent on submit
3. Watch parent for updates to sync draft

### Issue: Need to reset Nanostore state

**Symptoms:** How to reset atom to initial value

**Solutions:**
```typescript
const INITIAL_VALUE = { count: 0, name: '' }

export const $state = atom(INITIAL_VALUE)

export function reset() {
  $state.set(INITIAL_VALUE)
}
```
