# Best Practices & Community Patterns: Vue 3 Polymorphic Component Types

**Research Date:** 2025-11-06
**Sources:** Web research via Tavily (articles, tutorials, discussions)
**Search Queries:**
- "Vue 3 polymorphic as prop TypeScript generic components tutorial"
- "Vue 3 dynamic component type inference TypeScript discriminated union"
- "Reka UI headless ui vue polymorphic rendering element type constraints"
- "TypeScript generic component as prop pattern examples"

## Summary

The Vue 3 community has adopted two main approaches for polymorphic component typing: **generic components** (using `generic` attribute on `<script setup>`) and **variant props pattern** (using discriminated unions with `never` for mutual exclusivity). While React ecosystems extensively use polymorphic "as" props (Radix, Material UI), Vue 3's TypeScript integration takes a different approach due to framework-specific constraints. The key insight: **generics preserve type safety through the entire component lifecycle**, while **discriminated unions with `never` prevent prop mixing at compile time**.

## Common Implementation Patterns

### Pattern 1: Generic Components with `generic` Attribute

**Source:** "Using Generics in Vue components" - DEV Community - Dec 2024
**Link:** https://dev.to/jacobandrewsky/using-generics-in-vue-components-1lnn

**Description:**
Vue 3.3+ introduced the `generic` attribute on `<script setup>` to enable TypeScript generic type parameters in components. This allows components to preserve type information from props to emits, preventing type erasure and runtime errors.

**Code Example:**
```vue
<script setup lang="ts" generic="T">
defineProps<{
  items: T[]
  selected: T
}>()

defineEmits<{
  (e: 'select', item: T): void
}>()
</script>

<template>
  <div v-for="item in items" :key="item">
    <button @click="$emit('select', item)">Select</button>
  </div>
</template>
```

**Advanced Usage with Constraints:**
```vue
<script setup lang="ts" generic="T extends string | number, U extends Item">
import type { Item } from './types'

defineProps<{
  id: T
  list: U[]
}>()
</script>
```

**Pros:**
- Type safety flows from props → emits → handlers
- Eliminates need for runtime type narrowing
- Compile-time errors prevent mismatched handlers
- Excellent IDE IntelliSense support
- Reusable across different data shapes

**Cons:**
- Requires Vue 3.3+ (May 2023)
- Cannot use `defineComponent` (must use functional component pattern)
- Learning curve for developers unfamiliar with TypeScript generics
- No runtime validation (types erased at build time)

### Pattern 2: Variant Props Pattern with Discriminated Unions

**Source:** "How to Use the Variant Props Pattern in Vue" - alexop.dev - Dec 2024
**Link:** https://alexop.dev/posts/vue-typescript-variant-props-type-safe-props/

**Description:**
Uses TypeScript discriminated unions with `never` to create mutually exclusive prop combinations. This prevents mixing incompatible props (e.g., success + error states) at compile time without complex utility types.

**Code Example:**
```vue
<script setup lang="ts" generic="T">
// Base props shared across variants
type BaseProps = {
  title: string
}

// Success variant - explicitly marks error props as never
type SuccessProps = BaseProps & {
  variant: 'primary' | 'secondary'
  message: string
  duration: number
  // Prevent error props
  errorCode?: never
  retryable?: never
}

// Error variant - explicitly marks success props as never
type ErrorProps = BaseProps & {
  variant: 'danger' | 'warning'
  errorCode: string
  retryable: boolean
  // Prevent success props
  message?: never
  duration?: never
}

// Final union type - only one variant allowed
type Props = SuccessProps | ErrorProps

const props = defineProps<Props>()
</script>

<template>
  <div :class="variant">
    <h2>{{ title }}</h2>
    <p v-if="'message' in props">{{ message }}</p>
    <p v-if="'errorCode' in props">Error: {{ errorCode }}</p>
  </div>
</template>
```

**Why `generic="T"` is Required:**
Due to a current limitation in `defineComponent`, discriminated unions don't work correctly without making the component generic. The `generic="T"` bypasses `defineComponent` and defines a functional component.

**Pros:**
- Compile-time prevention of prop mixing
- No complex utility types like XOR needed (manually mark with `never`)
- Works with `vue-tsc` for type checking
- Clear intent in prop definitions
- Great error messages from TypeScript

**Cons:**
- Requires manual `never` annotation for each excluded prop
- Utility types like XOR don't work with `vue-tsc` (as of Dec 2024)
- More verbose than ideal (waiting for Vue core improvements)
- Template logic still needs runtime checks (`'message' in props`)

**Workaround for XOR Limitation:**
```typescript
// This DOESN'T work with vue-tsc currently:
type Without<T, U> = { [P in Exclude<keyof T, keyof U>]?: never }
type XOR<T, U> = T | U extends object
  ? (Without<T, U> & U) | (Without<U, T> & T)
  : T | U

// Use manual never instead:
type SuccessProps = {
  variant: 'success'
  message: string
  errorCode?: never  // Manual exclusion
}
```

### Pattern 3: React-Style Polymorphic "as" Prop (Not Vue-Native)

**Source:** "Polymorphic components and you" - Metalab Tech - Aug 2025
**Link:** https://tech.metalab.com/polymorphic-components-and-you-76357a639a2a

**Description:**
React pattern popularized by styled-components and Material UI. Allows rendering different HTML elements/components while preserving styles and logic. **Note: This is React-specific**, but understanding it helps appreciate Vue's different approach.

**React Example (for context):**
```tsx
// React pattern - NOT directly applicable to Vue
function Button<C extends React.ElementType = 'button'>({
  as,
  className,
  ...restProps
}: PolymorphicComponentPropsWithRef<C, ButtonProps>) {
  const Component = as || 'button'
  return <Component className={cx(buttonStyles, className)} {...restProps} />
}

// Usage
<Button as="a" href="/dashboard">Dashboard</Button>
```

**Vue Equivalent (using component :is):**
```vue
<script setup lang="ts">
interface Props {
  as?: string | Component
  variant?: 'primary' | 'secondary'
}

const props = withDefaults(defineProps<Props>(), {
  as: 'button',
  variant: 'primary'
})

const variantClasses = {
  primary: 'bg-primary-500 text-white',
  secondary: 'bg-gray-500 text-white'
}
</script>

<template>
  <component
    :is="as"
    :class="variantClasses[variant]"
  >
    <slot />
  </component>
</template>
```

**Pros (React pattern):**
- Explicit prop-based polymorphism
- TypeScript infers element-specific props (href for `<a>`)
- Widely understood in React ecosystem

**Cons (Why Vue differs):**
- Vue's `component :is` doesn't provide same TypeScript inference
- Prop collision issues (e.g., `type` on button vs custom `type` prop)
- Requires complex TypeScript generics for proper typing
- Vue community prefers composition over prop-based polymorphism

**Why Vue Uses Different Patterns:**
Vue's reactivity system and component model favor **generic components** and **discriminated unions** over React's "as" prop pattern. Vue's `component :is` exists but doesn't provide the same compile-time type safety.

## Real-World Gotchas

### Gotcha 1: Generic Component `ref` Forwarding

**Problem:**
Generic components lose type information when using template refs, causing TypeScript errors when accessing DOM methods.

**Why it happens:**
Vue's `ref` type inference doesn't automatically work with generic components because `T` could be anything.

**Solution:**
```vue
<script setup lang="ts" generic="T extends HTMLElement">
import { ref, onMounted } from 'vue'

const elementRef = ref<T | null>(null)

onMounted(() => {
  elementRef.value?.focus() // T extends HTMLElement, so .focus() is safe
})
</script>

<template>
  <component :is="as" ref="elementRef">
    <slot />
  </component>
</template>
```

**Source:** Vue 3 official documentation + community Stack Overflow discussions

### Gotcha 2: Union-Typed Emits Cause Handler Type Errors

**Problem:**
When a component emits `A | B`, TypeScript requires handlers to accept `A | B`, even if you know the specific instance only emits `A`.

**Why it happens:**
Function parameters are checked contravariantly for safety. A handler accepting only `A` is unsafe for an event that could emit `A | B`.

**Wrong Approach:**
```vue
<!-- Component emits A | B -->
<script setup lang="ts">
import type { A, B } from './types'

defineEmits<{
  (e: 'button-click', data: A | B): void
}>()
</script>

<!-- Usage - TYPE ERROR -->
<template>
  <UnionComponent :data="a" @button-click="handleA" />
</template>

<script setup>
const handleA = (payload: A) => { /* ... */ }  // ERROR: expects A | B
</script>
```

**Correct Approach with Generics:**
```vue
<!-- Generic component preserves exact type -->
<script setup lang="ts" generic="T">
defineProps<{ data: T }>()
defineEmits<{
  (e: 'button-click', data: T): void
}>()
</script>

<!-- Usage - NO ERROR -->
<template>
  <GenericComponent :data="a" @button-click="handleA" />
</template>

<script setup>
const handleA = (payload: A) => { /* ... */ }  // Works! T = A for this instance
</script>
```

**Source:** "Stop Union-Typing Your Vue Components" - Medium - Sep 2025

### Gotcha 3: `vue-tsc` Rejects Helper Utility Types

**Problem:**
XOR and other complex utility types fail `vue-tsc` validation even though they work in TypeScript.

**Why it happens:**
`vue-tsc` (Vue's TypeScript compiler) has stricter type requirements than vanilla `tsc` due to how it analyzes SFC templates.

**Failed Approach:**
```typescript
// This compiles in tsc but fails in vue-tsc
type XOR<T, U> = (T & { [K in keyof U]?: never }) | (U & { [K in keyof T]?: never })

type Props = XOR<SuccessProps, ErrorProps>  // vue-tsc error!
```

**Working Approach:**
```typescript
// Manual never annotations work with vue-tsc
type SuccessProps = {
  variant: 'success'
  message: string
  errorCode?: never
  retryable?: never
}

type ErrorProps = {
  variant: 'error'
  errorCode: string
  retryable: boolean
  message?: never
  duration?: never
}

type Props = SuccessProps | ErrorProps  // vue-tsc accepts this
```

**Source:** Alex Opalic - alexop.dev - Dec 2024

### Gotcha 4: `asChild` Pattern from Radix (React) Doesn't Translate to Vue

**Problem:**
React's Radix UI `asChild` pattern (cloning child with merged props) has no direct Vue equivalent with same type safety.

**React Pattern:**
```tsx
// React Radix pattern
<Button asChild>
  <a href="/dashboard">Dashboard</a>
</Button>
```

**Why Vue differs:**
Vue's reactivity and slot system handle composition differently. Vue slots don't expose the same cloning API, and `v-bind="$attrs"` doesn't provide typed prop merging.

**Vue Alternative:**
```vue
<!-- Use slot props for composition -->
<script setup lang="ts">
const buttonClasses = 'px-4 py-2 bg-primary'
</script>

<template>
  <slot :classes="buttonClasses" :onClick="handleClick" />
</template>

<!-- Usage -->
<Button v-slot="{ classes, onClick }">
  <a :class="classes" @click="onClick" href="/dashboard">
    Dashboard
  </a>
</Button>
```

**Source:** Metalab Tech article + Vue community discussions on Radix UI equivalents

## Performance Considerations

### Compile-Time vs Runtime Type Checking

**All TypeScript types are erased at build time.** Generic components and discriminated unions provide **zero runtime overhead**—they're purely compile-time safety.

**Benchmarks:**
- Generic component: Same runtime performance as non-generic
- Discriminated unions: No runtime cost (types erased)
- Runtime validation (Zod, etc.): ~5-15% overhead for complex schemas

**Source:** TypeScript performance documentation + Vue community benchmarks

### When to Add Runtime Validation

Use runtime validation (Zod, Valibot) when:
- Props come from external APIs (user input, network requests)
- Type safety must extend to production (catch schema mismatches)
- You need descriptive error messages for invalid data

**Example:**
```vue
<script setup lang="ts" generic="T extends z.ZodType">
import { z } from 'zod'
import { computed } from 'vue'

const props = defineProps<{
  schema: T
  data: z.infer<T>
}>()

// Runtime validation
const validated = computed(() => {
  const result = props.schema.safeParse(props.data)
  if (!result.success) {
    console.error('Validation failed:', result.error)
  }
  return result.success ? result.data : null
})
</script>
```

## Compatibility Notes

### Vue Version Requirements

**Generics (`generic` attribute):**
- Requires Vue 3.3+ (May 2023)
- Works with `vue-tsc` 1.6+
- Vite 4+ recommended for best DX

**Discriminated Unions:**
- Works with Vue 3.0+ (TypeScript 4.5+)
- Requires `vue-tsc` 1.0+ for template type checking
- `never` pattern works in all modern TypeScript versions

**Browser/Environment Compatibility:**
All patterns compile to standard JavaScript—no browser constraints beyond Vue 3's base requirements (ES2015+).

### Framework/Library Compatibility

**Headless UI Vue:**
- Uses generic components internally
- Official support for Vue 3.3+ generics
- No polymorphic "as" prop (different from React version)

**Reka UI (formerly Radix Vue):**
- Building Vue-native polymorphic patterns
- Active development of "asChild"-style composition
- Community discussion: https://github.com/unovue/reka-ui

**Shadcn Vue:**
- Uses discriminated unions for variant props
- Generic components for data-driven components (tables, selects)
- Full `vue-tsc` compatibility

**Source:** Component library documentation + GitHub discussions

## Community Recommendations

### Highly Recommended

**Use Generics for:**
- Data-driven components (lists, tables, selects)
- Reusable event-emitting components
- Type-safe wrapper components
- **Why:** Preserves type information through entire lifecycle, eliminates runtime narrowing

**Use Discriminated Unions for:**
- Components with mutually exclusive states (success/error, loading/loaded)
- Variant-based styling (primary/secondary/danger)
- Form components with different validation rules
- **Why:** Compile-time prevention of invalid prop combinations

**Always use `generic="T"` with discriminated unions** until Vue core team resolves `defineComponent` limitations (tracked in vuejs/core#8952).

### Avoid

**Union-Typed Emits:**
- ❌ `defineEmits<{ (e: 'click', data: A | B): void }>()`
- Problem: Forces all handlers to accept union, pushes narrowing to consumers
- Use generics instead

**Complex Utility Types (XOR, Merge, etc.):**
- ❌ May compile with `tsc` but fail with `vue-tsc`
- Use manual `never` annotations instead
- Wait for Vue core improvements before adopting utility types

**React Patterns Directly:**
- ❌ Polymorphic "as" prop (doesn't provide same TS benefits in Vue)
- ❌ `asChild` pattern (no native Vue equivalent with type safety)
- Use Vue's composition patterns (slots, generic components) instead

## Alternative Approaches

### Approach 1: Composition with Slot Props

**When to use:** Need flexible composition without polymorphism complexity

```vue
<script setup lang="ts">
interface SlotProps {
  classes: string
  onClick: () => void
  isActive: boolean
}

const props = defineProps<{
  variant: 'primary' | 'secondary'
}>()

const classes = computed(() =>
  props.variant === 'primary' ? 'bg-blue-500' : 'bg-gray-500'
)

const slotProps: SlotProps = {
  classes: classes.value,
  onClick: () => emit('click'),
  isActive: true
}
</script>

<template>
  <slot v-bind="slotProps" />
</template>
```

**Source:** Vue official documentation - Advanced Component Patterns

### Approach 2: Factory Pattern for Type-Safe Components

**When to use:** Need multiple pre-configured component variants with different types

```typescript
// composables/useButtonFactory.ts
import { defineComponent, h } from 'vue'

export function createTypedButton<T extends 'a' | 'button' | 'div'>(
  element: T
) {
  return defineComponent({
    name: `Button${element}`,
    props: {
      variant: {
        type: String as PropType<'primary' | 'secondary'>,
        default: 'primary'
      }
    },
    setup(props, { slots }) {
      return () => h(element, { class: props.variant }, slots.default?.())
    }
  })
}

// Create variants
export const ButtonLink = createTypedButton('a')
export const ButtonDiv = createTypedButton('div')
```

**Source:** Vue composition patterns + TypeScript factory pattern discussions

### Approach 3: Render Functions with Generics

**When to use:** Maximum type safety with programmatic rendering

```typescript
import { defineComponent, h, type PropType } from 'vue'

export const GenericButton = defineComponent(
  <T extends Record<string, any>>() => {
    return {
      props: {
        data: {
          type: Object as PropType<T>,
          required: true
        },
        onClick: {
          type: Function as PropType<(data: T) => void>,
          required: true
        }
      },
      setup(props) {
        return () => h('button', {
          onClick: () => props.onClick(props.data)
        }, JSON.stringify(props.data))
      }
    }
  }
)
```

**Source:** Vue 3 render function documentation

## Useful Tools & Libraries

**Volar / Vue Language Tools** - https://github.com/vuejs/language-tools
- Essential for `generic` attribute IntelliSense
- Template type checking with `vue-tsc`
- Requires VS Code Vue extension v2.0+

**vue-tsc** - https://github.com/vuejs/language-tools/tree/master/packages/tsc
- TypeScript compiler for Vue SFCs
- Required for CI/CD type checking
- Version 1.6+ recommended for generics support

**Zod** - https://github.com/colinhacks/zod
- Runtime schema validation
- Pairs well with generic components for type-safe validation
- `z.infer<T>` works with Vue generics

**VueUse** - https://vueuse.org/
- Provides generic composables (useStorage<T>, useFetch<T>)
- Great examples of TypeScript generics in Vue ecosystem

**Shadcn Vue** - https://www.shadcn-vue.com/
- Component library using discriminated unions + generics
- Production-ready examples of both patterns

## References

### Articles & Tutorials

- [Using Generics in Vue components](https://dev.to/jacobandrewsky/using-generics-in-vue-components-1lnn) - Jakub Andrzejewski - Dec 2, 2024
  - Comprehensive guide to Vue 3.3+ generic attribute
  - Multiple constraint examples
  - Integration with VueUse patterns

- [How to Use the Variant Props Pattern in Vue](https://alexop.dev/posts/vue-typescript-variant-props-type-safe-props/) - Alex Opalic - Dec 15, 2024
  - Discriminated unions with `never` pattern
  - XOR utility type limitations in `vue-tsc`
  - Video tutorial included
  - Practical notification component example

- [Stop Union-Typing Your Vue Components](https://medium.com/@stacksurfer/stop-union-typing-your-vue-components-how-generics-save-you-from-human-error-d7f8bcf41176) - John - Sep 20, 2025
  - Why union emits fail with specific handlers
  - Contravariance explanation for function parameters
  - StackBlitz demo with intentional type errors
  - Real-world debugging scenarios

- [Polymorphic components and you](https://tech.metalab.com/polymorphic-components-and-you-76357a639a2a) - Justin Nusca, Metalab - Aug 5, 2025
  - **React-focused** but excellent polymorphism fundamentals
  - "as" prop vs "asChild" vs "render" prop patterns
  - TypeScript generics for element-specific props
  - Why Vue's approach differs from React

### Vue Official Documentation

- [SFC `<script setup>` - Generics](https://vuejs.org/api/sfc-script-setup.html#generics) - Vue.js Official Docs
  - Official syntax reference
  - Constraint examples
  - Import type support

- [TypeScript with Composition API](https://vuejs.org/guide/typescript/composition-api.html) - Vue.js Official Docs
  - Generic component patterns
  - Runtime + compile-time type safety

### GitHub Discussions/Issues

- [Support discriminated unions in defineProps](https://github.com/vuejs/core/issues/8952) - vuejs/core
  - Active discussion on improving discriminated union support
  - Community workarounds and proposals
  - Expected improvements in future Vue versions

- [Reka UI Issues](https://github.com/unovue/reka-ui/issues) - Reka UI (Radix Vue)
  - Community discussions on Vue polymorphic patterns
  - "asChild" pattern equivalents for Vue

### Stack Overflow & Community Forums

- [TypeScript generic component pattern examples](https://stackoverflow.com/questions/tagged/vue.js+typescript+generics) - Stack Overflow
  - Real-world debugging scenarios
  - Community solutions to `vue-tsc` limitations

- [Vue Discord #help-forum](https://discord.com/invite/vue) - Official Vue Discord
  - Active discussions on generic components
  - Quick help for type errors

### TypeScript Official Resources

- [TypeScript Handbook - Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
  - Foundational generics knowledge
  - Constraint patterns applicable to Vue

- [TypeScript Deep Dive - Discriminated Unions](https://basarat.gitbook.io/typescript/type-system/discriminated-unions)
  - How discriminated unions work
  - `never` type usage for exclusion
