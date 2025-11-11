# Best Practices

### ✅ DO:

1. **Start local, lift when needed**
2. **Use "prop down, event up" pattern**
3. **Keep stores small** (< 200 lines)
4. **Use computed for derived state**
5. **Use shallowRef for large data**
6. **Validate before committing form state**
7. **Document state ownership clearly**
8. **Use TypeScript for type safety**

### ❌ DON'T:

1. **Don't mutate props**
2. **Don't over-abstract to stores**
3. **Don't destructure reactive objects**
4. **Don't use event buses** (deprecated)
5. **Don't expect composables to share state**
6. **Don't provide non-reactive primitives**
7. **Don't skip local draft for forms**
8. **Don't create god stores** (keep focused)
