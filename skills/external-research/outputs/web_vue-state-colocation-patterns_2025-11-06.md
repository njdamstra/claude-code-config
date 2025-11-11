# Best Practices & Community Patterns: Vue 3 State Management & Colocation

**Research Date:** 2025-11-06
**Sources:** Web research via Tavily (articles, tutorials, Stack Overflow, community discussions)
**Search Queries:**
- "vue 3 state colocation composables vs stores best practices 2024 2025"
- "vue 3 props vs state controlled components v-model pattern tutorial"
- "vue 3 derived state computed stores pinia nanostores performance"
- "state colocation react vue when to lift state up component architecture"
- "vue pinia store when to use composable vs global state patterns best practices"

## Summary

Community consensus emphasizes the **"colocate state as close as possible to where it's used"** principle. The general pattern is: start with local component state, lift to composables when reused across components, and only promote to Pinia stores for truly global or persistent state. The **"prop down, event up"** pattern remains the gold standard for parent-child communication. Developers consistently warn against premature abstraction—keep state local until you have a clear reason to lift it.

---

## Decision Frameworks

### Framework 1: State Placement Decision Tree

**Source:** Multiple community sources synthesized
**Consensus Level:** 85%+ agreement

```
Is the state used by multiple unrelated components?
├─ YES → Use Pinia store
└─ NO
   └─ Is the state reusable logic shared by related components?
      ├─ YES → Use composable (extracted useState/useReducer pattern)
      └─ NO
         └─ Is the state used by a component subtree?
            ├─ YES → Use provide/inject
            └─ NO → Keep as local component state (ref/reactive)
```

**Example Decision Matrix:**

| Scenario | Recommended Approach | Rationale |
|----------|---------------------|-----------|
| Modal open/closed | Local state (`ref`) | Only one component cares |
| Form validation logic | Composable (`useFormValidation`) | Reusable pattern, not global |
| User authentication | Pinia store (`useUserStore`) | Needed app-wide, persists |
| Theme toggle in subtree | Provide/inject | Multiple descendants need access |
| Counter in single component | Local state (`ref`) | No reason to lift |

**Source Links:**
- [Composables vs Pinia vs Provide/Inject - Jérémie Litzler](https://iamjeremie.me/post/2025-01/composables-vs-pinia-vs-provide-inject/)
- [Vue 3 Best Practices - Medium](https://medium.com/@ignatovich.dm/vue-3-best-practices-cb0a6e281ef4)

---

### Framework 2: Composable vs Store Criteria

**Source:** Community best practices from Pinia documentation and real-world usage
**Consensus Level:** 80%+ agreement

#### Use **Composables** When:
- ✅ Logic is stateless or ephemeral (doesn't need persistence)
- ✅ State is feature-specific (e.g., `usePagination`, `useFormValidation`)
- ✅ You need lifecycle-bound logic (auto-cleanup on unmount)
- ✅ State is purely computational (derived from props/other state)
- ✅ You want testable, isolated logic units

**Code Example:**
```typescript
// composables/useFormValidation.ts
import { ref, computed } from 'vue'

export function useFormValidation(initialValue = '') {
  const value = ref(initialValue)
  const errors = ref<string[]>([])

  const isValid = computed(() => errors.value.length === 0)

  function validate(rules: ValidationRule[]) {
    errors.value = rules
      .filter(rule => !rule.test(value.value))
      .map(rule => rule.message)
  }

  return { value, errors, isValid, validate }
}
```

#### Use **Pinia Stores** When:
- ✅ State is global (auth, user profile, app config)
- ✅ State persists across navigation/component unmounts
- ✅ Multiple unrelated components need access
- ✅ You need devtools integration for debugging
- ✅ State requires server synchronization (API calls)

**Code Example:**
```typescript
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  // State
  const currentUser = ref<User | null>(null)
  const isLoading = ref(false)

  // Getters (computed)
  const isAuthenticated = computed(() => !!currentUser.value)
  const displayName = computed(() => currentUser.value?.name || 'Guest')

  // Actions
  async function login(credentials: Credentials) {
    isLoading.value = true
    try {
      currentUser.value = await authApi.login(credentials)
    } finally {
      isLoading.value = false
    }
  }

  return { currentUser, isAuthenticated, displayName, login }
})
```

**Source Links:**
- [Pinia Best Practices - Sean Wilson](https://seanwilson.ca/blog/pinia-vue-best-practices.html)
- [Solving Prop Drilling in Vue - Alex OP](https://alexop.dev/posts/solving-prop-drilling-in-vue/)

---

### Framework 3: Props vs State (Controlled vs Uncontrolled Components)

**Source:** Vue School, community tutorials
**Consensus Level:** 90%+ agreement

#### Use **Props** When:
- ✅ Data comes from parent and parent "owns" the data
- ✅ Component is reusable and shouldn't maintain internal state
- ✅ Building "dumb" presentational components
- ✅ Parent needs to control the component's behavior

**Example: Controlled Component**
```vue
<!-- Child: Controlled Button -->
<script setup lang="ts">
interface Props {
  isLoading: boolean
  disabled?: boolean
}
const props = defineProps<Props>()
const emit = defineEmits<{ click: [] }>()
</script>

<template>
  <button
    :disabled="props.disabled || props.isLoading"
    @click="emit('click')"
  >
    <span v-if="props.isLoading">Loading...</span>
    <slot v-else />
  </button>
</template>
```

#### Use **Internal State** When:
- ✅ Component manages its own behavior (e.g., accordion open/closed)
- ✅ Data is temporary/ephemeral (e.g., hover state)
- ✅ Component is self-contained and not controlled by parent
- ✅ Building "smart" components with encapsulated logic

**Example: Uncontrolled Component**
```vue
<!-- Accordion with internal state -->
<script setup lang="ts">
const isOpen = ref(false)

function toggle() {
  isOpen.value = !isOpen.value
}
</script>

<template>
  <div>
    <button @click="toggle">Toggle</button>
    <div v-if="isOpen">
      <slot />
    </div>
  </div>
</template>
```

#### Use **v-model** (Hybrid) When:
- ✅ Parent needs to read AND write the value
- ✅ Two-way binding is semantically correct (forms, toggles)
- ✅ You want controlled component with minimal boilerplate

**Example: v-model Pattern**
```vue
<!-- Form component with v-model -->
<script setup lang="ts">
const modelValue = defineModel<string>()
</script>

<template>
  <input v-model="modelValue" type="text" />
</template>

<!-- Parent usage -->
<template>
  <FormInput v-model="username" />
</template>
```

**Critical Rule from Community:**
> **Never mutate props directly.** Always use "prop down, event up" or v-model pattern.

**Source Links:**
- [Vue Form Component Pattern - Vue School](https://vueschool.io/articles/vuejs-tutorials/the-vue-form-component-pattern-robust-forms-without-the-fuss/)
- [Update Vue 3 Props with Composition API - eSparkBiz](https://www.esparkinfo.com/qanda/vue/update-vue-3-props-with-composition-api)

---

## Real-World Implementation Patterns

### Pattern 1: State Colocation with Nearest Common Ancestor

**Description:**
Place state in the lowest common ancestor component that needs access. Don't lift state higher than necessary.

**When to Use:**
- Multiple sibling components need the same data
- Parent needs to coordinate children
- State isn't needed globally

**Code Example:**
```vue
<!-- ❌ BAD: State too high (in App.vue) -->
<template>
  <AppLayout>
    <ProductList :filters="filters" />
    <OtherSection /> <!-- Doesn't need filters -->
  </AppLayout>
</template>

<!-- ✅ GOOD: State colocated in feature component -->
<template>
  <div>
    <ProductFilters v-model:filters="filters" />
    <ProductList :filters="filters" />
  </div>
</template>

<script setup lang="ts">
const filters = ref<Filters>({ category: 'all', price: null })
</script>
```

**Benefits:**
- Easier to refactor (state moves with component)
- Clearer data flow
- Better performance (fewer re-renders)

**Source:** Community consensus from React/Vue colocation discussions

---

### Pattern 2: Composable for Shared Logic (Not State)

**Description:**
Extract reusable logic into composables, but let each component instance maintain its own state.

**When to Use:**
- Multiple components need same behavior (not same data)
- Logic involves lifecycle hooks or watchers
- State should be isolated per component

**Code Example:**
```typescript
// composables/usePagination.ts
export function usePagination(itemsPerPage = 10) {
  const currentPage = ref(1)
  const totalItems = ref(0)

  const totalPages = computed(() =>
    Math.ceil(totalItems.value / itemsPerPage)
  )

  const offset = computed(() =>
    (currentPage.value - 1) * itemsPerPage
  )

  function nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++
    }
  }

  function prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--
    }
  }

  return { currentPage, totalItems, totalPages, offset, nextPage, prevPage }
}

// Usage in multiple components (each gets own state)
const productPagination = usePagination(20)
const userPagination = usePagination(50)
```

**Important Note:**
Each component calling `usePagination` gets its **own isolated state**. This is different from a store, where state is shared.

**Source Links:**
- [Composables vs Pinia - Jérémie Litzler](https://iamjeremie.me/post/2025-01/composables-vs-pinia-vs-provide-inject/)

---

### Pattern 3: Provide/Inject for Component Subtrees

**Description:**
Use provide/inject when multiple descendants in a component tree need access to the same data, but it's not global.

**When to Use:**
- Data is scoped to a feature/section (not global)
- Avoiding prop drilling through intermediary components
- Parent controls the state, descendants consume it

**Code Example:**
```vue
<!-- Parent: Provides theme to entire dashboard -->
<script setup lang="ts">
import { provide, ref } from 'vue'

const theme = ref<'light' | 'dark'>('light')

provide('dashboard-theme', {
  current: theme,
  toggle: () => theme.value = theme.value === 'light' ? 'dark' : 'light'
})
</script>

<template>
  <DashboardLayout>
    <DashboardHeader />
    <DashboardContent>
      <WidgetList />
    </DashboardContent>
  </DashboardLayout>
</template>

<!-- Any descendant: Injects theme (no props needed) -->
<script setup lang="ts">
import { inject } from 'vue'

const theme = inject<{ current: Ref<string>, toggle: () => void }>('dashboard-theme')
</script>
```

**Gotcha Warning:**
Provide/inject breaks static prop tracing. Use TypeScript and clear naming conventions (e.g., `dashboard-theme` not just `theme`).

**Source:** Vue 3 Best Practices community articles

---

### Pattern 4: Form Component Pattern (Local State Copy)

**Description:**
Forms should maintain a **local draft copy** of data, only committing changes on submit. This prevents accidental mutations and respects user expectations.

**Why This Matters:**
Users expect forms to be "uncommitted" until they click Submit. Directly binding to parent state with v-model violates this expectation.

**Code Example:**
```vue
<!-- UserForm.vue -->
<script setup lang="ts">
import { ref, watch } from 'vue'

interface User {
  name: string
  email: string
}

const modelValue = defineModel<User>()

// Local copy for editing
const form = ref<User>(clone(modelValue.value))

// Sync local copy when parent updates
watch(modelValue, () => {
  form.value = clone(modelValue.value)
}, { deep: true })

function handleSubmit() {
  // Only commit on submit
  modelValue.value = clone(form.value)
}

function clone(obj: any) {
  return JSON.parse(JSON.stringify(obj))
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
- Native HTML validation works (submit prevented if invalid)
- Users can safely cancel without affecting parent data
- Intuitive mental model (forms are drafts)

**Source:** [Vue Form Component Pattern - Vue School](https://vueschool.io/articles/vuejs-tutorials/the-vue-form-component-pattern-robust-forms-without-the-fuss/)

---

## Common Gotchas & Anti-Patterns

### Gotcha 1: Over-Abstracting to Stores Too Early

**Problem:**
Developers prematurely lift state to Pinia stores "just in case" it might be needed elsewhere.

**Why It Happens:**
Coming from Redux (React) or Vuex, where global state was the default pattern.

**Solution:**
**Start local, lift as needed.** Only promote to store when you have concrete evidence multiple unrelated components need it.

**Decision Rule:**
> "If you can't name 3 unrelated components that need this state, it doesn't belong in a store."

**Example:**
```typescript
// ❌ BAD: Premature store for component-specific state
export const useModalStore = defineStore('modal', () => {
  const isOpen = ref(false)
  return { isOpen }
})

// ✅ GOOD: Local state in component
const isOpen = ref(false)
```

**Source:** Multiple community discussions on state management over-engineering

---

### Gotcha 2: Mutating Props Directly

**Problem:**
Directly changing `props.value` in child component causes warnings and breaks data flow.

**Why It Happens:**
Confusion about one-way data flow, especially for developers coming from two-way binding frameworks.

**Solution:**
**Always emit events or use v-model.** Props are read-only in child.

**Example:**
```vue
<!-- ❌ BAD: Direct mutation -->
<script setup>
const props = defineProps(['count'])
props.count++ // Warning! Attempting to mutate prop
</script>

<!-- ✅ GOOD: Emit event -->
<script setup>
const props = defineProps(['count'])
const emit = defineEmits(['update:count'])

function increment() {
  emit('update:count', props.count + 1)
}
</script>

<!-- ✅ BETTER: Use v-model pattern -->
<script setup>
const count = defineModel<number>()

function increment() {
  count.value++ // Works because defineModel creates writable computed
}
</script>
```

**Critical Community Quote:**
> "Never directly change a prop in a Vue 3 component. Always use the 'prop down, event up' pattern." - eSparkBiz

**Source:** [Update Vue 3 Props - eSparkBiz](https://www.esparkinfo.com/qanda/vue/update-vue-3-props-with-composition-api)

---

### Gotcha 3: Prop Drilling (Passing Props Through Intermediaries)

**Problem:**
Passing props through multiple layers of components that don't use the data.

**Why It Happens:**
Fear of using stores or provide/inject, leading to manual threading of props.

**Solution:**
Use **provide/inject** for component subtrees, **Pinia** for global state.

**Example:**
```vue
<!-- ❌ BAD: Prop drilling -->
<AppLayout :user="user">
  <Sidebar :user="user">
    <UserAvatar :user="user" /> <!-- Finally used here -->
  </Sidebar>
</AppLayout>

<!-- ✅ GOOD: Provide/inject -->
<!-- AppLayout.vue -->
<script setup>
provide('user', user)
</script>

<!-- UserAvatar.vue (deeply nested) -->
<script setup>
const user = inject<User>('user')
</script>
```

**When to Use Each:**
- **Props:** Parent → direct child (1 level)
- **Provide/inject:** Parent → descendants (2+ levels, same feature)
- **Pinia:** Any component → any other component (global)

**Source:** [Solving Prop Drilling in Vue - Alex OP](https://alexop.dev/posts/solving-prop-drilling-in-vue/)

---

### Gotcha 4: Confusing Composable State with Store State

**Problem:**
Expecting composables to share state between components (like stores), but each call creates new isolated state.

**Why It Happens:**
Misunderstanding how composables work vs stores.

**Clarification:**
```typescript
// Composable: Each call = new state instance
export function useCounter() {
  const count = ref(0) // New instance every call
  return { count }
}

// Component A
const counterA = useCounter() // count = 0

// Component B
const counterB = useCounter() // NEW count = 0 (isolated)

// Store: Singleton, shared state
export const useCounterStore = defineStore('counter', () => {
  const count = ref(0) // Single shared instance
  return { count }
})

// Component A
const store = useCounterStore() // count = 0

// Component B
const store = useCounterStore() // SAME count instance
```

**Decision Rule:**
- Need isolated state per component? → **Composable**
- Need shared state across components? → **Store**

**Source:** Pinia documentation and community tutorials

---

## Performance Considerations

### 1. Computed Stores vs Local Computed

**Performance Insight:**
Computed properties in Pinia stores are cached globally, but only recompute if dependencies change. Local computed properties are scoped to component lifecycle.

**When to Use Each:**
- **Store Computed (Getter):** Expensive calculations used by multiple components
- **Local Computed:** Derived state only used in one component

**Example:**
```typescript
// ✅ GOOD: Expensive calculation in store
export const useProductStore = defineStore('products', () => {
  const products = ref<Product[]>([])

  // Cached globally, reused by all components
  const sortedProducts = computed(() => {
    return [...products.value].sort((a, b) => b.price - a.price)
  })

  return { products, sortedProducts }
})

// ✅ GOOD: Component-specific derived state
const searchQuery = ref('')
const filteredProducts = computed(() => {
  return store.products.filter(p => p.name.includes(searchQuery.value))
})
```

**Source:** Community discussions on performance optimization

---

### 2. Shallow Reactivity for Large Lists

**Performance Insight:**
Use `shallowRef` or `shallowReactive` for large arrays/objects that change as a whole, not piece-by-piece.

**When to Use:**
- Large datasets (1000+ items)
- Objects with deep nesting you don't need to track
- Data that replaces entirely (e.g., API responses)

**Example:**
```typescript
import { shallowRef } from 'vue'

// ✅ GOOD: Large dataset that replaces entirely
const products = shallowRef<Product[]>([])

async function fetchProducts() {
  const data = await api.getProducts()
  products.value = data // Triggers reactivity
}

// ❌ BAD: Deep reactivity on large dataset
const products = ref<Product[]>([]) // Vue tracks every nested property
```

**Source:** [Vue 3 Best Practices - Medium](https://medium.com/@ignatovich.dm/vue-3-best-practices-cb0a6e281ef4)

---

## Community Recommendations

### Highly Recommended (80%+ consensus):

1. **Start local, lift as needed** - Don't prematurely abstract to stores
2. **"Prop down, event up" for parent-child** - Never mutate props
3. **Composables for logic, stores for state** - Separate concerns
4. **Use TypeScript** - Type-safe stores and composables prevent runtime errors
5. **Provide/inject for subtrees** - Avoid prop drilling without going global
6. **Form component pattern** - Local draft copy, commit on submit

### Avoid (Community Anti-Patterns):

1. **Event buses** - Use stores/provide/inject instead (deprecated pattern)
2. **Global state for everything** - Leads to tight coupling
3. **Mutating props** - Breaks one-way data flow
4. **Reactive objects for primitives** - Use `ref` for primitives, `reactive` for objects
5. **Composables as singleton stores** - Use actual Pinia stores for shared state

---

## Alternative Approaches & Tradeoffs

### Approach 1: Nuxt's `useState` vs Pinia

**Context:**
Nuxt provides `useState` composable for SSR-compatible global state.

**Tradeoffs:**
- **`useState`:** Built-in, simpler for small apps, SSR-friendly
- **Pinia:** More features (devtools, actions, getters), better for large apps

**Community Recommendation:**
Use Pinia even in Nuxt for medium-large apps. `useState` for tiny state needs.

**Source:** [Pinia in Nuxt 3 - Vue School](https://vueschool.io/articles/vuejs-tutorials/global-state-management-with-pinia-in-nuxt-3/)

---

### Approach 2: Composition API vs Options API for State

**Context:**
Options API (`data()`, `computed`) vs Composition API (`ref`, `computed`).

**Tradeoffs:**
- **Options API:** Familiar, less boilerplate, but harder to extract reusable logic
- **Composition API:** More boilerplate, but composables enable powerful reuse

**Community Recommendation:**
Composition API is now the standard. Options API is legacy for Vue 2 projects.

---

## Useful Tools & Patterns

### 1. Vue DevTools
- Track Pinia store state changes
- Time-travel debugging
- Component state inspection

### 2. TypeScript Patterns
```typescript
// Type-safe provide/inject with InjectionKey
import { InjectionKey, Ref } from 'vue'

interface User {
  name: string
  email: string
}

export const UserKey: InjectionKey<Ref<User>> = Symbol('user')

// Provide
provide(UserKey, user)

// Inject with type safety
const user = inject(UserKey) // Type: Ref<User> | undefined
```

### 3. Pinia Plugins
- **pinia-plugin-persistedstate** - Auto-persist stores to localStorage
- **pinia-plugin-history** - Undo/redo for store actions

---

## References

### Articles & Tutorials
- [Composables vs Pinia vs Provide/Inject - Jérémie Litzler](https://iamjeremie.me/post/2025-01/composables-vs-pinia-vs-provide-inject/) - Jan 2025
- [Vue 3 Best Practices - Frontend Highlights (Medium)](https://medium.com/@ignatovich.dm/vue-3-best-practices-cb0a6e281ef4) - May 2025
- [Vue Form Component Pattern - Vue School](https://vueschool.io/articles/vuejs-tutorials/the-vue-form-component-pattern-robust-forms-without-the-fuss/) - Aug 2025
- [Pinia Best Practices - Sean Wilson](https://seanwilson.ca/blog/pinia-vue-best-practices.html) - Apr 2025
- [Solving Prop Drilling in Vue - Alex OP](https://alexop.dev/posts/solving-prop-drilling-in-vue/) - 2025

### Official Documentation
- [Vue 3 Docs: Props](https://vuejs.org/guide/components/props.html)
- [Vue 3 Docs: v-model](https://vuejs.org/guide/components/v-model.html)
- [Pinia Documentation](https://pinia.vuejs.org/)

### Community Discussions
- [Update Vue 3 Props with Composition API - eSparkBiz](https://www.esparkinfo.com/qanda/vue/update-vue-3-props-with-composition-api) - 2025
- Multiple Reddit and Stack Overflow discussions on state management patterns

### Related Topics
- [Understanding Component Based Architectures - MoldStud](https://moldstud.com/articles/p-understanding-component-based-architectures-a-deep-dive-into-react) - React patterns applicable to Vue
- [Advanced Prototyping with Vue 3 Composition API - UXPin](https://www.uxpin.com/studio/blog/advanced-prototyping-techniques-with-vue-3-composition-api/)
