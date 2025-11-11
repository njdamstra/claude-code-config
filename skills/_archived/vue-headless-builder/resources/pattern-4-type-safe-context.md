# Pattern 4: Type-Safe Context Creation

Reka UI pattern using helper function:

```typescript
// shared/context.ts
import { inject, provide, type InjectionKey } from 'vue'

export function createContext<T>(componentName: string) {
  const key = Symbol() as InjectionKey<T>

  const provideContext = (contextValue: T) => {
    provide(key, contextValue)
  }

  const injectContext = (fallback?: T) => {
    const context = inject(key, fallback)
    if (!context && !fallback) {
      throw new Error(`${componentName} context must be provided`)
    }
    return context
  }

  return [injectContext, provideContext] as const
}
```

**Usage:**

```typescript
// AccordionRoot.vue
interface AccordionContext {
  openItems: Ref<Set<string>>
  toggle: (value: string) => void
}

export const [injectAccordionContext, provideAccordionContext] =
  createContext<AccordionContext>('Accordion')

// In component
provideAccordionContext({ openItems, toggle })
```
