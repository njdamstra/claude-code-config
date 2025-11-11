# Best Practices

### ✅ DO:

1. **Name with "use" prefix** (`useMouse`, `useFetch`)
2. **Return plain objects** (easy destructuring)
3. **Use MaybeRefOrGetter** for flexible parameters
4. **Clean up side effects** in `onUnmounted`
5. **Make SSR-safe** with window checks or `useMounted()`
6. **Use shallowRef** for large data
7. **Compose focused composables** (< 300 lines each)
8. **Document with TSDoc comments**
9. **Import stores, don't create them**
10. **Use VueUse for common patterns**

### ❌ DON'T:

1. **Don't register lifecycle hooks async**
2. **Don't return nested reactive objects**
3. **Don't use ref for large objects** (use shallowRef)
4. **Don't forget cleanup**
5. **Don't consolidate unrelated logic**
6. **Don't access `this`**
7. **Don't mutate props**
8. **Don't skip TypeScript types**
9. **Don't create BaseStore instances**
10. **Don't handle UI rendering**
