# Official Documentation: Vue 3 Headless & Compound Component Patterns

**Research Date:** 2025-11-06
**Sources:**
- Reka UI (Context7 ID: /llmstxt/reka-ui_llms-full_txt)
- Vue 3 Official Docs (Context7 ID: /vuejs/docs)
**Version:** Vue 3.3+, Reka UI (Radix Vue port)

## Summary

Headless UI components separate behavior/accessibility from presentation, while compound components coordinate multiple child components through shared context. Vue 3's provide/inject system with TypeScript's InjectionKey pattern forms the foundation for both architectures. Reka UI demonstrates production-grade implementation of these patterns with full accessibility compliance.

## Headless UI Architecture

### Core Philosophy

**Headless = Behavior without presentation**
- Components provide functionality (state, keyboard nav, focus management, ARIA)
- Zero styling opinions
- Maximum customization flexibility
- Accessibility built-in, not bolted-on

### Reka UI Primitives Pattern

Reka UI (Vue port of Radix) implements headless primitives:

```vue
<script setup lang="ts">
import { DialogRoot, DialogTrigger, DialogContent } from 'reka-ui'
</script>

<template>
  <DialogRoot>
    <DialogTrigger as-child>
      <button class="custom-styles">Open Dialog</button>
    </DialogTrigger>
    <DialogContent>
      <p>Your custom content with your styles</p>
    </DialogContent>
  </DialogRoot>
</template>
```

**Key Characteristics:**
- Unstyled components (`<DialogRoot>`, `<DialogTrigger>`, etc.)
- Compound component pattern (coordinated siblings)
- Context sharing via provide/inject
- `asChild` prop for composition without DOM wrappers
- Full WAI-ARIA compliance

### The `asChild` Pattern

Eliminates extra DOM wrappers by merging props/behavior into child:

```vue
<script setup lang="ts">
import { DialogTrigger, TooltipRoot, TooltipTrigger } from 'reka-ui'
</script>

<template>
  <DialogRoot>
    <!-- asChild: DialogTrigger merges props into TooltipRoot -->
    <DialogTrigger as-child>
      <TooltipRoot>
        <!-- asChild: TooltipTrigger merges props into button -->
        <TooltipTrigger as-child>
          <button class="icon-btn">Open</button>
        </TooltipTrigger>
        <TooltipContent>Click to open dialog</TooltipContent>
      </TooltipRoot>
    </DialogTrigger>

    <DialogContent>Dialog content</DialogContent>
  </DialogRoot>
</template>
```

**Result:** Single `<button>` element with:
- DialogTrigger behavior (opens dialog on click)
- TooltipTrigger behavior (shows tooltip on hover)
- Custom styles from `icon-btn`
- No wrapper divs

### Primitive Component

Foundation for all headless components - renders any HTML element:

```vue
<script setup lang="ts">
import { Primitive } from 'reka-ui'
</script>

<template>
  <!-- Render as button -->
  <Primitive as="button" class="my-button">
    Click me
  </Primitive>

  <!-- Render as anchor with asChild -->
  <Primitive as-child>
    <a href="/home">Link styled as button</a>
  </Primitive>
</template>
```

**Props:**
- `as` - HTML tag to render (`'button'`, `'div'`, `'span'`, etc.)
- `asChild` - Merge props into child instead of creating wrapper

## Compound Components

### Definition

Multiple components that work together as coordinated unit:
- Shared context between siblings
- Each component handles specific responsibility
- Parent coordinates state/behavior
- Children access context for conditional rendering/styling

### Reka UI Compound Pattern

**Example: Accordion**

```vue
<script setup lang="ts">
import {
  AccordionRoot,
  AccordionItem,
  AccordionTrigger,
  AccordionContent
} from 'reka-ui'
</script>

<template>
  <AccordionRoot type="single" collapsible>
    <AccordionItem value="item-1">
      <AccordionTrigger>Section 1</AccordionTrigger>
      <AccordionContent>Content for section 1</AccordionContent>
    </AccordionItem>

    <AccordionItem value="item-2">
      <AccordionTrigger>Section 2</AccordionTrigger>
      <AccordionContent>Content for section 2</AccordionContent>
    </AccordionItem>
  </AccordionRoot>
</template>
```

**Component Hierarchy:**
- `AccordionRoot` - Provides root context (type, open items)
- `AccordionItem` - Provides item context (value, isOpen)
- `AccordionTrigger` - Injects contexts to toggle item
- `AccordionContent` - Injects contexts to show/hide based on state

### Context Injection Pattern (Reka UI)

**Custom composables for context access:**

```vue
<script setup lang="ts">
import {
  injectAccordionRootContext,
  injectAccordionItemContext
} from 'reka-ui'

const accordionRootContext = injectAccordionRootContext()
const accordionItemContext = injectAccordionItemContext()

const isSingleOpen = computed(() =>
  accordionRootContext.isSingle.value && accordionItemContext.open.value
)
</script>

<template>
  <div :class="{ 'highlight': isSingleOpen }">
    Custom accordion content
  </div>
</template>
```

**Pattern:**
- Each component level provides context via `provide*()`
- Child components inject via `inject*()` functions
- Naming: `inject[Component]Context()` pattern
- Returns reactive refs/computed for state access

### Combobox Example (Complex Compound)

**Root Context Provider:**

```typescript
// ComboboxRoot.vue
const rootContext = {
  modelValue,
  multiple,
  disabled,
  open,
  onOpenChange,
  contentId,
  isUserInputted,
  inputElement,
  highlightedElement,
  onInputElementChange: (val) => inputElement.value = val,
  parentElement,
  allItems,
  allGroups,
  filterState,
  ignoreFilter
}

provideComboboxRootContext(rootContext)
```

**Item Context Injection:**

```typescript
// ComboboxItem.vue
import { injectComboboxRootContext } from './ComboboxRoot.vue'
import { injectComboboxGroupContext } from './ComboboxGroup.vue'

const rootContext = injectComboboxRootContext()
const groupContext = injectComboboxGroupContext(null) // null = optional

const isRender = computed(() =>
  rootContext.ignoreFilter.value
    ? true
    : rootContext.filterState.filtered.items.get(id)! > 0
)
```

**Multi-Level Injection:**
- Root context: Global combobox state
- Group context: Optional, for grouped items
- Item context: Individual item state
- Each level injects parent contexts as needed

## Provide/Inject Advanced Patterns

### Symbol-Based Injection Keys (Recommended)

**Why Symbols:**
- Prevent key collisions in large apps
- Type-safe with TypeScript
- Co-located with component logic

```typescript
// keys.ts
import type { InjectionKey } from 'vue'

export const myInjectionKey = Symbol() as InjectionKey<string>
```

```typescript
// Provider component
import { provide } from 'vue'
import { myInjectionKey } from './keys'

provide(myInjectionKey, 'hello')
```

```typescript
// Injector component
import { inject } from 'vue'
import { myInjectionKey } from './keys'

const value = inject(myInjectionKey) // type: string | undefined
```

### TypeScript Typing Strategies

**1. String Keys with Generic:**

```typescript
const foo = inject<string>('foo') // type: string | undefined
```

**2. InjectionKey for Type Safety:**

```typescript
import type { InjectionKey } from 'vue'

const key = Symbol() as InjectionKey<string>

provide(key, 'foo') // Error if not string
const foo = inject(key) // type: string | undefined
```

**3. Default Values Remove Undefined:**

```typescript
const foo = inject<string>('foo', 'default') // type: string
```

**4. Factory Functions for Expensive Defaults:**

```typescript
const baz = inject('factory', () => new ExpensiveObject(), true)
//                                                           ^^^^
//                                            treatDefaultAsFactory
```

### Reactive Provide/Inject

**Provide reactive ref:**

```vue
<script setup>
import { ref, provide } from 'vue'

const count = ref(0)
provide('count', count) // Injectors maintain reactivity
</script>
```

**Provide with mutation method (recommended):**

```vue
<!-- Provider -->
<script setup>
import { provide, ref } from 'vue'

const location = ref('North Pole')

function updateLocation() {
  location.value = 'South Pole'
}

provide('location', {
  location,
  updateLocation
})
</script>
```

```vue
<!-- Injector -->
<script setup>
import { inject } from 'vue'

const { location, updateLocation } = inject('location')
</script>

<template>
  <button @click="updateLocation">{{ location }}</button>
</template>
```

**Read-only pattern:**

```vue
<script setup>
import { ref, provide, readonly } from 'vue'

const count = ref(0)
provide('read-only-count', readonly(count))
</script>
```

### App-Level Provide

For plugins or global state:

```typescript
import { createApp } from 'vue'

const app = createApp({})

app.provide('globalMessage', 'Available everywhere')
```

## Reka UI Implementation Patterns

### Context Creation Utility

Reka UI uses `createContext` helper:

```typescript
import { createContext } from '@/shared'
import type { Ref } from 'vue'

interface ComboboxItemContext {
  isSelected: Ref<boolean>
}

export const [injectComboboxItemContext, provideComboboxItemContext] =
  createContext<ComboboxItemContext>('ComboboxItem')
```

**Returns tuple:**
- `[0]` - `inject*Context()` function
- `[1]` - `provide*Context()` function
- Type-safe, named for component

### Forward Refs Pattern

For non-single-root components to expose DOM element:

```vue
<script setup lang="ts">
import { useForwardExpose } from 'reka-ui'

const { forwardRef } = useForwardExpose()
</script>

<template>
  <span>
    <!-- Expose div as the template ref -->
    <div :ref="forwardRef">
      <slot />
    </div>
  </span>
</template>
```

**Use case:** Parent needs DOM element access for:
- Focus management
- Positioning (popovers, tooltips)
- Measurements

### Forward Props Pattern

Merge props from wrapper component to underlying primitive:

```vue
<script setup lang="ts">
import { useForwardProps } from 'reka-ui'
import { DialogRoot } from 'reka-ui'

interface Props {
  open?: boolean
  modal?: boolean
}

const props = defineProps<Props>()
const forwarded = useForwardProps(props)
</script>

<template>
  <DialogRoot v-bind="forwarded">
    <slot />
  </DialogRoot>
</template>
```

**Benefit:** Wrapper component accepts same props as primitive without manual binding.

### Primitive Element Hook

Access underlying DOM element and provide common primitives:

```typescript
import { usePrimitiveElement } from '@/Primitive'

const { primitiveElement, currentElement } = usePrimitiveElement()

// primitiveElement: ref for binding
// currentElement: resolved HTMLElement
```

**Usage in Combobox:**

```typescript
const { primitiveElement, currentElement } = usePrimitiveElement()

onMounted(() => {
  rootContext.allItems.value.set(
    id,
    props.textValue || currentElement.value.textContent
  )
})
```

## Decision Framework

### When to Use Headless Components

**Use headless when:**
- Need full design system control
- Building reusable component library
- Accessibility is critical requirement
- Multiple visual variants of same behavior
- Existing UI libraries too opinionated

**Don't use headless when:**
- Rapid prototyping with pre-styled components
- Design system already established
- Team unfamiliar with compound patterns
- Simple one-off components

### When to Use Compound Components

**Use compound pattern when:**
- Multiple coordinated sibling components
- Shared state between related components
- Complex component with distinct sub-responsibilities
- Need to expose composed API to users

**Example compound candidates:**
- Accordion (Root, Item, Trigger, Content)
- Dialog (Root, Trigger, Content, Close)
- Select (Root, Trigger, Content, Item, Group)
- Tabs (Root, List, Trigger, Content)

**Don't use compound when:**
- Single component with no sub-parts
- No shared state between siblings
- Props drilling is sufficient
- Simple parent-child relationship

### When to Use Provide/Inject vs Props

**Use provide/inject when:**
- Deep nesting (3+ levels)
- Multiple components need same data
- Component composition (compound components)
- Plugin architecture
- Avoiding props drilling through intermediate components

**Use props when:**
- Direct parent-child relationship
- Single level of communication
- Explicit data flow preferred
- Component is reusable across contexts

**Use props + provide/inject when:**
- Component accepts props for config
- Provides that config to descendants via inject
- Example: `<AccordionRoot type="single">` provides type to items

## Best Practices from Official Docs

### Naming Conventions (Reka UI)

**Pattern:**
- Components: `[Feature][Part]` (e.g., `DialogRoot`, `DialogTrigger`)
- Provide functions: `provide[Feature][Part]Context`
- Inject functions: `inject[Feature][Part]Context`

**Benefits:**
- Autocomplete friendly
- Clear component hierarchy
- Prevents naming collisions

### TypeScript Integration

**Component props extending primitives:**

```vue
<script setup lang="ts">
import { AccordionItem, type AccordionItemProps } from "reka-ui"

interface Props extends AccordionItemProps {
  foo: string
}

defineProps<Props>()
</script>

<template>
  <AccordionItem v-bind="$props">
    <slot />
  </AccordionItem>
</template>
```

**Context typing:**

```typescript
interface ComboboxRootContext {
  modelValue: Ref<string | string[]>
  multiple: Ref<boolean>
  disabled: Ref<boolean>
  open: Ref<boolean>
  onOpenChange: (open: boolean) => void
  // ... other properties
}

const [injectComboboxRootContext, provideComboboxRootContext] =
  createContext<ComboboxRootContext>('ComboboxRoot')
```

### Lifecycle Coordination

**Register items on mount:**

```typescript
const rootContext = injectComboboxRootContext()

onMounted(() => {
  rootContext.allItems.value.set(id, textContent)
})

onUnmounted(() => {
  rootContext.allItems.value.delete(id)
})
```

**Pattern ensures:**
- Root maintains registry of all items
- Items clean up on unmount
- Dynamic item lists supported

### Error Handling

**Validate required context:**

```typescript
const rootContext = injectComboboxRootContext()

if (!rootContext) {
  throw new Error(
    '<ComboboxItem> must be used within <ComboboxRoot>'
  )
}
```

**Validate required props:**

```typescript
if (!props.value) {
  throw new Error(
    'A <ComboboxItem> must have a value prop that is not an empty string.'
  )
}
```

### Optional vs Required Context

**Required context:**

```typescript
const rootContext = injectComboboxRootContext()
// Throws if not found
```

**Optional context:**

```typescript
const groupContext = injectComboboxGroupContext(null)
// Returns null if not found, no error

if (groupContext) {
  // Use group-specific logic
}
```

## Gotchas & Important Notes

### Provide/Inject Reactive Caveats

1. **Non-reactive by default for primitives:**
   ```typescript
   provide('count', 0) // NOT reactive
   provide('count', ref(0)) // Reactive
   ```

2. **Mutations should be co-located:**
   - Provide both state AND mutation methods
   - Prevents scattered state updates
   - Easier to trace data flow

3. **Symbol keys prevent collisions:**
   - Always use Symbols in reusable components
   - Prevents key conflicts in large apps

### SSR Considerations

**Not documented explicitly in Reka UI, but Vue notes:**
- Provide/inject works in SSR
- Context available during server render
- Hydration maintains context correctly

### Performance

**Provide/inject is efficient:**
- Direct reference, not prop chain traversal
- No re-renders of intermediate components
- Reactive updates only affect consumers

**Avoid over-providing:**
- Only provide what descendants need
- Split contexts if different consumers need different data
- Example: Root context vs Item context separation

### Headless Component Challenges

1. **Learning curve:**
   - Developers must understand compound patterns
   - More complex than styled components
   - Documentation critical

2. **Styling responsibility:**
   - No default styles to fall back on
   - Must implement all visual states
   - More initial setup time

3. **Accessibility understanding:**
   - Developers must understand ARIA
   - Easy to break accessibility if misused
   - Follow component documentation exactly

## Common Patterns Summary

### 1. Headless Primitive Component

```typescript
// Primitive.vue
<script setup lang="ts">
interface Props {
  as?: string
  asChild?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  as: 'div',
  asChild: false
})
</script>

<template>
  <component :is="as" v-if="!asChild" v-bind="$attrs">
    <slot />
  </component>
  <slot v-else />
</template>
```

### 2. Compound Component with Context

```vue
<!-- Root.vue -->
<script setup lang="ts">
import { provide, ref } from 'vue'

const open = ref(false)
const toggle = () => open.value = !open.value

provide('accordion-root', { open, toggle })
</script>

<template>
  <div><slot /></div>
</template>
```

```vue
<!-- Item.vue -->
<script setup lang="ts">
import { inject } from 'vue'

const { open, toggle } = inject('accordion-root')
</script>

<template>
  <button @click="toggle">
    {{ open ? 'Close' : 'Open' }}
  </button>
</template>
```

### 3. Type-Safe Context Creation

```typescript
import type { InjectionKey, Ref } from 'vue'

interface RootContext {
  open: Ref<boolean>
  toggle: () => void
}

export const RootKey = Symbol() as InjectionKey<RootContext>

// Provider
provide(RootKey, { open, toggle })

// Consumer
const context = inject(RootKey)
if (!context) throw new Error('Must be used within Root')
```

### 4. Forward Props Helper

```typescript
export function useForwardProps<T extends Record<string, any>>(
  props: T
): T {
  return new Proxy(props, {
    get(target, key) {
      return unref(target[key as keyof T])
    }
  })
}
```

### 5. Custom ID Generation

Headless UI allows custom ID injection (useful for SSR):

```vue
<script setup>
import { provideUseId } from '@headlessui/vue'

// Nuxt provides useId() globally
provideUseId(() => useId())
</script>
```

**Why needed:**
- SSR requires stable IDs
- Prevents hydration mismatches
- Temporary until Vue 3.5+ provides native `useId()`

## References

**Reka UI (Radix Vue):**
- Official Docs: https://reka-ui.com
- GitHub: https://github.com/unovue/reka-ui
- Component Examples: https://reka-ui.com/components

**Vue 3 Provide/Inject:**
- Guide: https://vuejs.org/guide/components/provide-inject
- API Reference: https://vuejs.org/api/composition-api-dependency-injection
- TypeScript Guide: https://vuejs.org/guide/typescript/composition-api

**Headless UI (React, for reference):**
- Official Site: https://headlessui.com
- Radix UI: https://radix-ui.com (Original React primitives)

**Related Topics:**
- Vue 3 Composition API
- TypeScript with Vue
- Component composition patterns
- Accessibility (WAI-ARIA) in Vue
