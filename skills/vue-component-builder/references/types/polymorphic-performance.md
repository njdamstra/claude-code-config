# Performance Notes

**All TypeScript types are erased at build time:**
- Generic components: Zero runtime overhead
- Discriminated unions: Zero runtime overhead
- Purely compile-time safety

**Benchmarks:**
- Generic component: Same runtime performance as non-generic
- Discriminated unions: No runtime cost
- Runtime validation (Zod): ~5-15% overhead for complex schemas

## Compatibility

### Vue Version Requirements

**Generics (`generic` attribute):**
- Requires Vue 3.3+ (May 2023)
- Works with `vue-tsc` 1.6+
- Vite 4+ recommended

**Discriminated Unions:**
- Works with Vue 3.0+ (TypeScript 4.5+)
- Requires `vue-tsc` 1.0+ for template type checking
- `never` pattern works in all modern TypeScript versions

### Browser Compatibility

All patterns compile to standard JavaScript—no browser constraints beyond Vue 3's base requirements (ES2015+).
