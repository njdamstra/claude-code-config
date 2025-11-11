# Instructions

### Step 1: Analyze Component Hierarchy

#### 1.1 Map Component Tree

```
Parent
├─ Intermediate1 (passes props, doesn't use)
│  └─ Intermediate2 (passes props, doesn't use)
│     └─ LeafComponent (finally uses props)
└─ SiblingComponent (needs same props)
```

#### 1.2 Measure Complexity

**Line Count:**
- Component: Count `<script setup>` + `<template>` lines
- Composable: Count function body lines
- **Threshold:** 300+ = consider split, 500+ = must split

**Responsibility Count:**
- List all distinct concerns (data, navigation, validation, OAuth, billing)
- **Threshold:** 3+ concerns = SRP violation

**Dependency Count:**
- Count imported modules
- **Threshold:** 10+ imports = high complexity

**Props Threading:**
- Count levels props pass through
- **Threshold:** 3+ levels = prop drilling problem

#### 1.3 Identify Problems

Check for these violations:

- [ ] **Size Violation:** 300+ lines
- [ ] **SRP Violation:** Handles 3+ unrelated concerns
- [ ] **Prop Drilling:** Props thread through 3+ levels
- [ ] **Tight Coupling:** Child assumes parent structure
- [ ] **Coordination:** Siblings need shared state
- [ ] **Reusability Mismatch:** Parts used independently elsewhere
- [ ] **Lifecycle Mismatch:** Different parts need different hooks
- [ ] **Testing Difficulty:** Hard to test in isolation
- [ ] **State Over-Lifting:** State higher than needed

**If 2+ violations:** Proceed to split/refactor.

### Step 2: Choose Composition Pattern

Select pattern based on identified problem:

#### Pattern 0: Split by Size/Responsibility (Orchestrator)

**Use when:**
- Component/composable exceeds 300 lines
- Handles 3+ unrelated concerns
- Parts have different reusability needs

**Strategy:**
1. Group code by concern/responsibility
2. Extract each group to focused file (< 200 lines)
3. Create orchestrator to compose extracted units
4. Expose selective APIs from orchestrator

**See:** Pattern 0 section below for detailed examples

#### Pattern 1: Provide/Inject (Prop Drilling Solution)

**Use when:**
- Props pass through 3+ levels
- Intermediate components don't use the data
- Component subtree scope (not global)

**Implementation:**
```vue
<!-- Provider (Parent) -->
<script setup lang="ts">
import { provide, readonly, type InjectionKey, type Ref } from 'vue'

// Type-safe injection key
interface ConfigContext {
  teamId: string
  allowSelection: boolean
  disableAddNew: boolean
}

const ConfigKey = Symbol() as InjectionKey<ConfigContext>

provide(ConfigKey, {
  teamId: props.teamId,
  allowSelection: props.allowSelection,
  disableAddNew: props.disableAddNew
})
</script>

<template>
  <div>
    <Intermediate>
      <DeepChild /> <!-- Accesses config directly -->
    </Intermediate>
  </div>
</template>
```

```vue
<!-- Consumer (Deep Child) -->
<script setup lang="ts">
import { inject } from 'vue'
import { ConfigKey } from './Provider.vue'

const config = inject(ConfigKey)
if (!config) throw new Error('Must be used within Provider')
</script>

<template>
  <div>{{ config.teamId }}</div>
</template>
```

**Benefits:**
- Eliminates intermediate prop passing
- Type-safe with InjectionKey
- Scoped to component subtree

**Trade-offs:**
- Implicit dependencies (harder to trace)
- Not visible in component props API

#### Pattern 2: Compound Components (Coordinated Siblings)

**Use when:**
- Multiple components work together as unit
- Siblings need shared state (Accordion items, Dialog parts)
- Building component libraries (Radix/Headless UI style)

**Example: Accordion**
```vue
<!-- AccordionRoot.vue -->
<script setup lang="ts">
import { provide, ref } from 'vue'

interface AccordionContext {
  openItems: Ref<Set<string>>
  toggle: (value: string) => void
}

const AccordionKey = Symbol() as InjectionKey<AccordionContext>

const openItems = ref<Set<string>>(new Set())

function toggle(value: string) {
  if (openItems.value.has(value)) {
    openItems.value.delete(value)
  } else {
    openItems.value.clear() // Single mode
    openItems.value.add(value)
  }
}

provide(AccordionKey, { openItems, toggle })
</script>

<template>
  <div><slot /></div>
</template>
```

```vue
<!-- AccordionItem.vue -->
<script setup lang="ts">
import { inject, computed } from 'vue'

const props = defineProps<{ value: string }>()
const accordion = inject(AccordionKey)

const isOpen = computed(() => accordion.openItems.value.has(props.value))
</script>

<template>
  <div>
    <button @click="accordion.toggle(props.value)">
      Toggle {{ value }}
    </button>
    <div v-if="isOpen">
      <slot />
    </div>
  </div>
</template>
```

**API:**
```vue
<AccordionRoot>
  <AccordionItem value="item-1">
    <template #trigger>Section 1</template>
    <template #content>Content 1</template>
  </AccordionItem>
  <AccordionItem value="item-2">
    <template #trigger>Section 2</template>
    <template #content>Content 2</template>
  </AccordionItem>
</AccordionRoot>
```

**Benefits:**
- Clean, composable API
- State coordination built-in
- Type-safe context sharing

#### Pattern 3: Headless UI + asChild (Design System Primitives)

**Use when:**
- Building design system primitives
- Need full styling control
- Accessibility is critical
- Multiple visual variants of same behavior

**Example: Primitive Component**
```vue
<!-- Primitive.vue -->
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
  <slot v-else /> <!-- Merge into child -->
</template>
```

**Usage:**
```vue
<Primitive as="button" class="custom-btn">
  Click me
</Primitive>

<!-- asChild merges props into child -->
<Primitive as-child>
  <RouterLink to="/home" class="btn">
    Home
  </RouterLink>
</Primitive>
<!-- Result: Single <a> with both behaviors -->
```

**Benefits:**
- Zero styling opinions
- Maximum flexibility
- No wrapper div pollution
- Accessibility built-in

#### Pattern 4: Scoped Slots (Parent Controls Child Content)

**Use when:**
- Parent needs to inject custom content
- Child provides data/functions to parent
- Building renderless components

**Example: Data List with Scoped Slots**
```vue
<!-- DataList.vue -->
<script setup lang="ts">
interface Item {
  id: number
  name: string
}

const items = ref<Item[]>([...])

defineSlots<{
  item(props: { item: Item; index: number }): any
  empty?(): any
}>()
</script>

<template>
  <div v-if="items.length">
    <div v-for="(item, i) in items" :key="item.id">
      <slot name="item" :item="item" :index="i" />
    </div>
  </div>
  <slot v-else name="empty" />
</template>
```

**Usage:**
```vue
<DataList>
  <template #item="{ item, index }">
    <div class="custom-card">
      {{ index + 1 }}. {{ item.name }}
    </div>
  </template>
  <template #empty>
    No items found
  </template>
</DataList>
```

**Benefits:**
- Full content control from parent
- Type-safe slot props
- Flexible rendering

#### Pattern 5: Renderless Components (Behavior Without UI)

**Use when:**
- Extract reusable logic (mouse tracking, data fetching)
- Need behavior without prescribing UI
- Building composable utilities

**Example:**
```vue
<!-- FetchData.vue -->
<script setup lang="ts">
const props = defineProps<{ url: string }>()

defineSlots<{
  default(props: {
    data: any
    loading: boolean
    error: Error | null
  }): any
}>()

const { data, loading, error } = useFetch(props.url)
</script>

<template>
  <slot :data="data" :loading="loading" :error="error" />
</template>
```

**Usage:**
```vue
<FetchData url="/api/users">
  <template #default="{ data, loading, error }">
    <div v-if="loading">Loading...</div>
    <div v-else-if="error">{{ error.message }}</div>
    <UserList v-else :users="data" />
  </template>
</FetchData>
```

#### Pattern 6: Form Component Pattern (Local Draft)

**Use when:**
- Building form components
- Need submit confirmation before parent state updates
- Want native HTML validation

**Example:**
```vue
<!-- UserForm.vue -->
<script setup lang="ts">
import { ref, watch } from 'vue'

const modelValue = defineModel<User>()

// Local copy for editing (draft)
const form = ref<User>(structuredClone(modelValue.value))

// Sync local copy when parent updates
watch(modelValue, () => {
  form.value = structuredClone(modelValue.value)
}, { deep: true })

function handleSubmit() {
  // Only commit on submit
  modelValue.value = structuredClone(form.value)
}
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <input v-model="form.name" required />
    <input v-model="form.email" type="email" required />
    <button>Submit</button>
  </form>
</template>
```

**Benefits:**
- Native HTML validation works
- Users can cancel without affecting parent
- Intuitive mental model (forms are drafts)

### Step 3: Refactor Implementation

1. **Identify affected components:**
   - Map current prop flow
   - List all components needing changes

2. **Create context/injection keys:**
   ```typescript
   // keys.ts
   import type { InjectionKey, Ref } from 'vue'

   interface MyContext {
     state: Ref<any>
     methods: { ... }
   }

   export const MyContextKey = Symbol() as InjectionKey<MyContext>
   ```

3. **Implement provider (root):**
   - Create context value
   - Use `provide(key, value)`
   - Ensure reactivity with refs/computed

4. **Implement consumers (children):**
   - Use `inject(key)`
   - Add error handling for missing context
   - Validate required props

5. **Remove intermediate prop passing:**
   - Delete props from transparent components
   - Update TypeScript interfaces

6. **Test coordination:**
   - Verify state synchronization
   - Test edge cases (missing provider)
   - Check TypeScript types

### Step 4: Validate Architecture

**Check these criteria:**

- [ ] **Reduced coupling:** Child components don't assume parent structure
- [ ] **Clear responsibilities:** Each component has single, clear purpose
- [ ] **Type safety:** All context injections use InjectionKey
- [ ] **Error handling:** Missing context throws helpful errors
- [ ] **Performance:** Avoid unnecessary re-renders (use `readonly()` for read-only state)
- [ ] **Testability:** Components testable in isolation
- [ ] **Documentation:** Context usage documented in component
- [ ] **State colocated:** State lives as close as possible to usage
- [ ] **Size appropriate:** All units < 200 lines
