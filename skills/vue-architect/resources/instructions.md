# Instructions

### Step 1: Analyze State Characteristics

For each piece of state, answer these questions:

1. **Scope:** Where is it used?
   - [ ] Single component only
   - [ ] Multiple related components (parent + children)
   - [ ] Multiple unrelated components
   - [ ] Entire application

2. **Lifetime:** How long should it exist?
   - [ ] Component lifecycle only
   - [ ] Navigation session (persists across routes)
   - [ ] Application lifetime (persists across reloads)

3. **Source:** Where does data originate?
   - [ ] Parent component (via props)
   - [ ] User input (forms)
   - [ ] API/server
   - [ ] Derived from other state

4. **Ownership:** Who controls mutations?
   - [ ] Component itself
   - [ ] Parent component
   - [ ] Multiple components collaboratively
   - [ ] Background processes (timers, websockets)

5. **Performance:** How expensive is it?
   - [ ] Simple primitives (string, number, boolean)
   - [ ] Small objects (< 10 properties)
   - [ ] Large arrays (100+ items)
   - [ ] Deep nested objects

### Step 2: Choose State Pattern

Based on answers above, choose pattern:

#### Pattern 1: Local Component State

**Use when:**
- State used by single component only
- State is ephemeral (doesn't persist navigation)
- Component owns the data (not passed from parent)

**Implementation:**
```vue
<script setup lang="ts">
import { ref, reactive } from 'vue'

// Primitives: use ref
const count = ref(0)
const isOpen = ref(false)
const username = ref('')

// Objects: use reactive
const form = reactive({
  name: '',
  email: '',
  age: 0
})

// Large lists: use shallowRef
const products = shallowRef<Product[]>([])
</script>
```

**When to choose ref vs reactive:**
- **ref:** Primitives, arrays, single values
- **reactive:** Objects with multiple properties
- **shallowRef:** Large arrays/objects that change wholesale

#### Pattern 2: Composables (Reusable Logic)

**Use when:**
- Multiple components need same **behavior** (not same data)
- Logic involves lifecycle hooks or watchers
- State should be **isolated per component instance**

**Important:** Each component gets its own state copy (not shared).

**Implementation:**
```typescript
// composables/usePagination.ts
export function usePagination(itemsPerPage = 10) {
  // New state instance per component
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

// Usage in component
const productPagination = usePagination(20)
const userPagination = usePagination(50) // Separate state
```

**Key Insight:** Composables provide **logic reuse**, not **state sharing**. For shared state, use stores.

#### Pattern 3: Nanostores (Global State)

**Use when:**
- State is truly global (auth, user profile, app config)
- State persists across navigation
- 3+ unrelated components need access
- State requires server synchronization
- Need framework-agnostic state (works outside Vue)

**Nanostores Types:**
- **atom** - Single value store (`atom<T>`)
- **map** - Object store with nested updates (`map<T>`)
- **computed** - Derived from other stores
- **persistentAtom** - Auto-syncs with localStorage

**Implementation:**
```typescript
// stores/user.ts
import { atom, computed } from 'nanostores'
import { persistentAtom } from '@nanostores/persistent'

// State atoms
export const $currentUser = atom<User | null>(null)
export const $isLoading = atom(false)

// Computed stores (getters)
export const $isAuthenticated = computed($currentUser, (user) => !!user)
export const $displayName = computed($currentUser, (user) => user?.name || 'Guest')

// Actions (plain functions)
export async function login(credentials: Credentials) {
  $isLoading.set(true)
  try {
    const user = await authApi.login(credentials)
    $currentUser.set(user)
  } finally {
    $isLoading.set(false)
  }
}

export function logout() {
  $currentUser.set(null)
}
```

**Vue Integration with @nanostores/vue:**
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $currentUser, $isAuthenticated, login } from '@/stores/user'

// Subscribe to stores
const currentUser = useStore($currentUser)
const isAuthenticated = useStore($isAuthenticated)
</script>

<template>
  <div v-if="isAuthenticated">
    {{ currentUser.name }}
  </div>
</template>
```

**Persistent State:**
```typescript
import { persistentAtom } from '@nanostores/persistent'

// Auto-syncs with localStorage
export const $theme = persistentAtom<'light' | 'dark'>('theme', 'light')
export const $preferences = persistentAtom('preferences', {
  notifications: true,
  autoSave: false
})
```

**Store Size Guidelines:**
- Keep stores small (< 200 lines)
- Split by feature domain (user, products, cart)
- Don't consolidate unrelated state
- One atom per concern (not one giant atom)

#### Pattern 4: Provide/Inject (Component Subtree)

**Use when:**
- State scoped to feature/section (not global)
- Multiple descendants need access
- Avoiding prop drilling through intermediaries
- Parent controls the state, descendants consume

**Implementation:**
```vue
<!-- Provider (Parent) -->
<script setup lang="ts">
import { provide, ref, readonly, type InjectionKey, type Ref } from 'vue'

interface DashboardTheme {
  current: Ref<'light' | 'dark'>
  toggle: () => void
}

const DashboardThemeKey = Symbol() as InjectionKey<DashboardTheme>

const theme = ref<'light' | 'dark'>('light')

function toggleTheme() {
  theme.value = theme.value === 'light' ? 'dark' : 'light'
}

// Provide state + mutation method
provide(DashboardThemeKey, {
  current: theme,
  toggle: toggleTheme
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
```

```vue
<!-- Consumer (Deep descendant) -->
<script setup lang="ts">
import { inject } from 'vue'
import { DashboardThemeKey } from './Dashboard.vue'

const theme = inject(DashboardThemeKey)
if (!theme) throw new Error('Must be used within Dashboard')
</script>

<template>
  <div :class="theme.current.value">
    <button @click="theme.toggle">Toggle Theme</button>
  </div>
</template>
```

**Benefits:**
- Scoped to feature (not global like stores)
- No prop drilling
- Type-safe with InjectionKey

**Trade-offs:**
- Implicit dependency
- Harder to test in isolation

### Step 3: Implement Props vs State Pattern

#### Controlled Components (Props)

**Use when:**
- Parent needs to control child behavior
- Child is reusable "dumb" component
- Building design system components

**Implementation:**
```vue
<!-- Child: Controlled Select -->
<script setup lang="ts">
interface Props {
  modelValue: string
  options: string[]
  disabled?: boolean
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()
</script>

<template>
  <select
    :value="props.modelValue"
    :disabled="props.disabled"
    @input="emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
  >
    <option v-for="opt in props.options" :key="opt" :value="opt">
      {{ opt }}
    </option>
  </select>
</template>
```

**Parent usage:**
```vue
<script setup>
const selected = ref('option1')
</script>

<template>
  <ControlledSelect v-model="selected" :options="['option1', 'option2']" />
</template>
```

#### Uncontrolled Components (Internal State)

**Use when:**
- Component manages its own behavior
- Parent doesn't need to know internal state
- Building self-contained components

**Implementation:**
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
    <button @click="toggle">
      {{ isOpen ? 'Close' : 'Open' }}
    </button>
    <div v-if="isOpen">
      <slot />
    </div>
  </div>
</template>
```

#### v-model Pattern (Hybrid)

**Use when:**
- Parent needs to read AND write value
- Two-way binding semantically correct (forms, toggles)
- Want controlled component with minimal boilerplate

**Implementation:**
```vue
<!-- Component -->
<script setup lang="ts">
const modelValue = defineModel<string>()
</script>

<template>
  <input v-model="modelValue" type="text" />
</template>
```

**Parent usage:**
```vue
<script setup>
const username = ref('')
</script>

<template>
  <FormInput v-model="username" />
  <p>You typed: {{ username }}</p>
</template>
```

### Step 4: Handle Form State (Local Draft Pattern)

**The Iron Law for Forms:**

```
FORMS MAINTAIN LOCAL DRAFT COPY, COMMIT ON SUBMIT ONLY
```

**Why:** Users expect forms to be "uncommitted" until Submit. Directly binding to parent state violates this expectation.

**Implementation:**
```vue
<!-- UserForm.vue -->
<script setup lang="ts">
import { ref, watch } from 'vue'

interface User {
  name: string
  email: string
}

const modelValue = defineModel<User>()

// Local draft copy
const form = ref<User>(structuredClone(modelValue.value))

// Sync draft when parent updates
watch(modelValue, (newValue) => {
  form.value = structuredClone(newValue)
}, { deep: true })

function handleSubmit() {
  // Validate
  if (!form.value.name || !form.value.email) {
    alert('Please fill all fields')
    return
  }

  // Commit to parent only on submit
  modelValue.value = structuredClone(form.value)
}

function handleCancel() {
  // Reset to parent value
  form.value = structuredClone(modelValue.value)
}
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <input v-model="form.name" required />
    <input v-model="form.email" type="email" required />
    <button type="submit">Submit</button>
    <button type="button" @click="handleCancel">Cancel</button>
  </form>
</template>
```

**Benefits:**
- Native HTML validation works
- Cancel doesn't affect parent
- Intuitive mental model

### Step 5: Optimize State Performance

#### Use shallowRef for Large Data

**When to use:**
- Large arrays (1000+ items)
- Deep nested objects you don't mutate individually
- Data that replaces entirely (API responses)

**Implementation:**
```typescript
import { shallowRef } from 'vue'

// ✅ GOOD: Large dataset that replaces entirely
const products = shallowRef<Product[]>([])

async function fetchProducts() {
  const data = await api.getProducts()
  products.value = data // Triggers reactivity once
}

// ❌ BAD: Deep reactivity on large dataset
const products = ref<Product[]>([]) // Vue tracks every nested property
```

**Why shallowRef:**
- Prevents deep reactivity tracking
- Reduces memory overhead
- Improves performance for data-heavy operations

#### Use computed for Derived State

**Always:**
```typescript
// ✅ GOOD: Computed - cached, only recalculates when dependencies change
const doubleCount = computed(() => count.value * 2)

// ❌ BAD: Function - recalculates every render
const doubleCount = () => count.value * 2
```

#### Use readonly for Unidirectional Flow

**Provide read-only state when consumers shouldn't mutate:**
```typescript
import { provide, readonly } from 'vue'

const count = ref(0)

// Prevent mutations from consumers
provide('count', readonly(count))
```

#### Split Large Stores

**Instead of one monolithic store:**
```typescript
// ❌ BAD: 1675-line store
export const useOnboardingFlow = defineStore('onboarding', () => {
  // 50+ state properties
  // 30+ actions
  // 20+ getters
})
```

**Split by responsibility:**
```typescript
// ✅ GOOD: Focused stores
export const useOnboardingData = defineStore('onboarding-data', () => {
  // Only data CRUD
})

export const useOnboardingNavigation = defineStore('onboarding-nav', () => {
  // Only next/prev/goTo logic
})

export const useOnboardingOAuth = defineStore('onboarding-oauth', () => {
  // Only connection management
})
```

**Store size limit:** Keep stores < 200 lines.
