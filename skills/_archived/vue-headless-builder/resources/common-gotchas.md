# Common Gotchas

### Gotcha 1: Non-Reactive Primitives in Provide

```typescript
// ❌ WRONG: Primitives not reactive
provide('count', 0)

// ✅ CORRECT: Wrap in ref
provide('count', ref(0))
```

### Gotcha 2: Mutations Outside Provider

```typescript
// ❌ WRONG: Direct state mutation in consumer
const { count } = inject('store')
count.value++ // Scattered mutations

// ✅ CORRECT: Provide mutation methods
provide('store', {
  count,
  increment: () => count.value++
})
```

### Gotcha 3: Missing Context Validation

```typescript
// ❌ WRONG: No error if context missing
const context = inject('accordion')

// ✅ CORRECT: Validate required context
const context = inject('accordion')
if (!context) {
  throw new Error('<Item> must be used within <Root>')
}
```

### Gotcha 4: Symbol Keys Not Exported

```typescript
// ❌ WRONG: Symbol created in each file
const Key = Symbol() // Different symbol in each import

// ✅ CORRECT: Export symbol from one location
// AccordionRoot.vue
export const AccordionKey = Symbol() as InjectionKey<Context>
```
