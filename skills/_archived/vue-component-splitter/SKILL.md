---
name: Vue Component Splitter
description: |
  Systematically split large Vue components and composables using size metrics,
  single responsibility principle, and state colocation patterns. Use when
  refactoring 300+ line components/composables, reducing complexity, extracting
  reusable logic, or improving testability. Works with .vue files and composable
  .ts files. Use for "split component", "refactor large component", "extract logic",
  "composable too big", "component complexity", "single responsibility".
version: 1.0.0
tags: [vue, refactoring, composables, single-responsibility, state-colocation]
---

# Vue Component Splitter

## Quick Start
- Identify split triggers: size (300+ lines), SRP violations, reusability mismatches
- Apply state colocation principle (keep state close to usage)
- Extract composables for behavior, lift state only when needed
- Validate with decision frameworks before splitting

## Core Philosophy

**"Colocate state as close as possible to where it's used"**

Split components/composables when:
1. **Single Responsibility Violation** - Handles unrelated concerns
2. **Size** - 300+ lines indicates multiple responsibilities
3. **Reusability Differs** - Parts used independently in different contexts
4. **Lifecycle Mismatch** - Different parts need different lifecycle hooks
5. **Testing Isolation** - Parts should be testable independently

## Size-Based Guidelines

### Small Component/Composable (< 100 lines)
- Single concern, highly focused
- Examples: `useMouse`, `useCounter`, `Button.vue`
- **Action:** Keep as single file

### Medium Component/Composable (100-300 lines)
- Multiple related functions
- Examples: `useFetch`, `useLocalStorage`, `FormInput.vue`
- **Action:** Organize by sections (state, computed, methods, lifecycle)

### Large Component/Composable (300-500 lines)
- Complex feature with multiple sub-concerns
- Examples: `useVirtualList`, `DataTable.vue`
- **Action:** **Consider splitting** OR use clear sectioning

### Very Large Component/Composable (500+ lines)
- Multiple features that could be independent
- Examples: `useOnboardingFlow` (1675 lines in codebase)
- **Action:** **SPLIT into multiple composables** with composition

## Split Decision Framework

```
Does the component/composable handle multiple unrelated concerns?
├─ YES → SPLIT into separate files
└─ NO → Can parts be used independently?
   ├─ YES → SPLIT for reusability
   └─ NO → Is state tightly coupled?
      ├─ YES → KEEP consolidated
      └─ NO → Consider splitting for testing/maintenance
```

## Pattern 1: Component Splitting by Responsibility

### Before: Monolithic Component (400+ lines)

```vue
<!-- UserProfile.vue - TOO LARGE -->
<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'

// User data state
const user = ref<User | null>(null)
const isLoading = ref(false)
const error = ref<string | null>(null)

// Form state
const editMode = ref(false)
const form = ref({
  name: '',
  email: '',
  bio: ''
})
const formErrors = ref<Record<string, string>>({})

// Avatar upload state
const uploadingAvatar = ref(false)
const avatarPreview = ref<string | null>(null)

// Settings state
const settings = ref({
  notifications: true,
  theme: 'light',
  language: 'en'
})

// ... 300+ more lines of methods, computed, watchers
</script>

<template>
  <!-- 100+ lines of mixed UI -->
</template>
```

### After: Split into Focused Components

```vue
<!-- UserProfile.vue - ORCHESTRATOR (50 lines) -->
<script setup lang="ts">
import UserProfileHeader from './UserProfileHeader.vue'
import UserProfileForm from './UserProfileForm.vue'
import UserAvatar from './UserAvatar.vue'
import UserSettings from './UserSettings.vue'

const props = defineProps<{ userId: string }>()

// Only coordination logic here
const { user, isLoading, error, refetch } = useUserData(props.userId)
</script>

<template>
  <div class="user-profile">
    <UserProfileHeader :user="user" :loading="isLoading" />
    <UserAvatar :user="user" @update="refetch" />
    <UserProfileForm :user="user" @save="handleSave" />
    <UserSettings :user="user" />
  </div>
</template>
```

```vue
<!-- UserProfileForm.vue - FOCUSED (80 lines) -->
<script setup lang="ts">
import { useFormValidation } from '@/composables/useFormValidation'

const props = defineProps<{ user: User }>()
const emit = defineEmits<{ save: [User] }>()

// Form-specific logic only
const { form, errors, validate } = useFormValidation(props.user)

async function handleSubmit() {
  if (await validate()) {
    emit('save', form.value)
  }
}
</script>

<template>
  <!-- Form UI only -->
</template>
```

**Split Criteria Met:**
- ✅ SRP: Each component has single responsibility
- ✅ Size: All components < 100 lines
- ✅ Reusability: UserAvatar reusable elsewhere
- ✅ Testing: Each component independently testable

## Pattern 2: Composable Splitting by Concern

### Before: Monolithic Composable (1675 lines)

```typescript
// useOnboardingFlow.ts - TOO LARGE
export function useOnboardingFlow() {
  // Data CRUD (200 lines)
  const onboarding = ref<Onboarding | null>(null)
  async function fetchOnboarding() { /* ... */ }
  async function updateOnboarding() { /* ... */ }

  // Navigation (150 lines)
  const currentStep = ref(1)
  function nextStep() { /* ... */ }
  function prevStep() { /* ... */ }
  function goToStep(n: number) { /* ... */ }

  // OAuth connections (300 lines)
  const connectedProviders = ref<Provider[]>([])
  async function connectProvider() { /* ... */ }
  async function disconnectProvider() { /* ... */ }
  function getOAuthUrl() { /* ... */ }

  // Billing/limits (250 lines)
  const limits = ref<Limits | null>(null)
  function checkLimit() { /* ... */ }
  function calculateUsage() { /* ... */ }

  // Validation (200 lines)
  const errors = ref<Record<string, string>>({})
  function validateStep() { /* ... */ }
  function validateField() { /* ... */ }

  // AI suggestions (300 lines)
  const suggestions = ref<Suggestion[]>([])
  async function generateSuggestions() { /* ... */ }

  // ... 275+ more lines

  return {
    // 50+ exported properties/methods
  }
}
```

### After: Split into Focused Composables

```typescript
// useOnboardingData.ts - DATA CRUD (150 lines)
export function useOnboardingData(userId: string) {
  const onboarding = ref<Onboarding | null>(null)
  const isLoading = ref(false)

  async function fetch() { /* ... */ }
  async function update(data: Partial<Onboarding>) { /* ... */ }
  async function create() { /* ... */ }

  return { onboarding, isLoading, fetch, update, create }
}
```

```typescript
// useOnboardingNavigation.ts - NAVIGATION (100 lines)
export function useOnboardingNavigation(totalSteps: number) {
  const currentStep = ref(1)

  const canGoNext = computed(() => currentStep.value < totalSteps)
  const canGoPrev = computed(() => currentStep.value > 1)

  function next() {
    if (canGoNext.value) currentStep.value++
  }

  function prev() {
    if (canGoPrev.value) currentStep.value--
  }

  function goTo(step: number) {
    if (step >= 1 && step <= totalSteps) {
      currentStep.value = step
    }
  }

  return { currentStep, canGoNext, canGoPrev, next, prev, goTo }
}
```

```typescript
// useOnboardingOAuth.ts - OAUTH (200 lines)
export function useOnboardingOAuth(userId: string) {
  const connectedProviders = ref<Provider[]>([])
  const isConnecting = ref(false)

  async function connect(provider: string) { /* ... */ }
  async function disconnect(providerId: string) { /* ... */ }
  function getAuthUrl(provider: string): string { /* ... */ }

  return {
    connectedProviders,
    isConnecting,
    connect,
    disconnect,
    getAuthUrl
  }
}
```

```typescript
// useOnboardingValidation.ts - VALIDATION (120 lines)
export function useOnboardingValidation() {
  const errors = ref<Record<string, string>>({})

  function validateStep(step: number, data: unknown) { /* ... */ }
  function validateField(field: string, value: unknown) { /* ... */ }
  function clearErrors() { /* ... */ }

  return { errors, validateStep, validateField, clearErrors }
}
```

```typescript
// useOnboardingBilling.ts - BILLING (150 lines)
export function useOnboardingBilling(userId: string) {
  const limits = ref<Limits | null>(null)
  const usage = ref<Usage | null>(null)

  async function checkLimit(feature: string): Promise<boolean> { /* ... */ }
  function calculateUsage() { /* ... */ }

  return { limits, usage, checkLimit, calculateUsage }
}
```

### Orchestrator Pattern (Composition)

```typescript
// useOnboardingFlow.ts - ORCHESTRATOR (150 lines)
export function useOnboardingFlow(userId: string) {
  const totalSteps = 5

  // Compose focused composables
  const data = useOnboardingData(userId)
  const navigation = useOnboardingNavigation(totalSteps)
  const oauth = useOnboardingOAuth(userId)
  const validation = useOnboardingValidation()
  const billing = useOnboardingBilling(userId)

  // Orchestration logic only
  watchEffect(() => {
    if (navigation.currentStep === 3 && !oauth.connectedProviders.value.length) {
      // Show OAuth prompts
    }
  })

  async function handleNext() {
    const isValid = await validation.validateStep(
      navigation.currentStep,
      data.onboarding.value
    )

    if (isValid) {
      await data.update({ currentStep: navigation.currentStep + 1 })
      navigation.next()
    }
  }

  return {
    // Expose selected APIs from each composable
    ...data,
    ...navigation,
    ...oauth,
    validation: {
      errors: validation.errors,
      validateField: validation.validateField
    },
    billing,
    handleNext
  }
}
```

**Split Criteria Met:**
- ✅ SRP: Each composable has single responsibility
- ✅ Size: All composables < 200 lines
- ✅ Reusability: useOnboardingNavigation reusable for any stepper
- ✅ Testing: Each composable independently testable
- ✅ Lifecycle: OAuth cleanup in useOnboardingOAuth only

## Pattern 3: State Colocation

### Principle: Keep State As Close As Possible

```vue
<!-- ❌ BAD: State too high (in App.vue) -->
<template>
  <AppLayout>
    <ProductList :filters="filters" />
    <OtherSection /> <!-- Doesn't need filters -->
  </AppLayout>
</template>

<script setup>
const filters = ref<Filters>({ category: 'all', price: null })
</script>
```

```vue
<!-- ✅ GOOD: State colocated in feature component -->
<template>
  <div>
    <ProductFilters v-model:filters="filters" />
    <ProductList :filters="filters" />
  </div>
</template>

<script setup>
const filters = ref<Filters>({ category: 'all', price: null })
</script>
```

### State Placement Hierarchy

```
Is the state used by multiple unrelated components?
├─ YES → Use Nanostore (global shared state)
└─ NO
   └─ Is the state reusable logic shared by related components?
      ├─ YES → Use composable (isolated state per instance)
      └─ NO
         └─ Is the state used by a component subtree?
            ├─ YES → Use provide/inject
            └─ NO → Keep as local component state (ref/reactive)
```

## Pattern 4: Form Component Pattern (Local Draft)

Forms should maintain **local draft copy**, commit on submit:

```vue
<!-- UserForm.vue -->
<script setup lang="ts">
import { ref, watch } from 'vue'

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
- Native HTML validation works
- Users can cancel without affecting parent
- Intuitive mental model (forms are drafts)

## Pattern 5: Extract Behavior, Not State

### Composables for Shared Logic (Not Data)

```typescript
// ✅ GOOD: Composable for behavior (isolated state per component)
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

// Usage: Each component gets its own state instance
const productPagination = usePagination(20)
const userPagination = usePagination(50)
```

## Instructions

### Step 1: Measure Complexity

1. **Line Count:**
   - Component: Count `<script setup>` lines
   - Composable: Count function body lines
   - Template: Count `<template>` lines

2. **Responsibility Count:**
   - List all distinct concerns (data, navigation, validation, etc.)
   - If > 3 concerns, consider splitting

3. **Dependency Count:**
   - Count imported modules
   - If > 10 imports, indicates high complexity

### Step 2: Identify Split Triggers

Check for these violations:

- [ ] **Size Violation:** 300+ lines
- [ ] **SRP Violation:** Handles 3+ unrelated concerns
- [ ] **Reusability Mismatch:** Parts used independently elsewhere
- [ ] **Lifecycle Mismatch:** Different parts need different hooks
- [ ] **Testing Difficulty:** Hard to test in isolation
- [ ] **State Over-Lifting:** State higher than needed

If **2+ violations**, proceed to split.

### Step 3: Plan Split Strategy

**For Components:**
1. Group UI sections by responsibility
2. Extract each section to focused component
3. Create orchestrator component for coordination
4. Pass data via props/events, not global state

**For Composables:**
1. Group functions by concern
2. Extract each concern to focused composable
3. Create orchestrator composable that composes others
4. Expose selective APIs from composed composables

### Step 4: Execute Split

1. **Create new files** for each focused unit
2. **Move code** to new files
3. **Update orchestrator** to compose new files
4. **Test each unit** independently
5. **Verify integration** in orchestrator

### Step 5: Validate Split

- [ ] All units < 200 lines
- [ ] Each unit has single responsibility
- [ ] No duplicate code
- [ ] All tests pass
- [ ] State is colocated (not over-lifted)

## Decision Rules

### "3 Unrelated Components" Rule

> "If you can't name 3 unrelated components that need this state, it doesn't belong in a store."

- 1-2 components → Local state or composable
- 3+ unrelated components → Nanostore

### "200 Lines" Rule

> "Keep composables < 200 lines each."

- Forces single responsibility
- Improves testability
- Enhances reusability

### "Props vs Provide/Inject" Rule

- **Props:** Direct parent-child (1 level)
- **Provide/inject:** Parent → descendants (2+ levels, same feature)
- **Nanostore:** Any component → any other component (global)

## Common Gotchas

### Gotcha 1: Over-Splitting

**Problem:** Split too granularly, creating maintenance burden

**Solution:** Split only when 2+ split triggers present

```typescript
// ❌ TOO GRANULAR: 3 composables for one concern
const data = useData()
const loading = useLoading()
const error = useError()

// ✅ APPROPRIATE: Consolidated related state
const { data, isLoading, error } = useFetch()
```

### Gotcha 2: Premature Store Abstraction

**Problem:** Lift state to Nanostore too early

**Solution:** Start local, lift only when 3+ unrelated components need it

```typescript
// ❌ PREMATURE: Store for component-specific state
export const $modalOpen = atom(false)

// ✅ APPROPRIATE: Local state in component
const isOpen = ref(false)
```

### Gotcha 3: Splitting Without Composition

**Problem:** Split components/composables but don't create orchestrator

**Solution:** Always create orchestrator to coordinate split units

### Gotcha 4: Duplicate Logic After Split

**Problem:** Same logic repeated across split units

**Solution:** Extract common logic to shared utility composable

## Examples

### Example 1: Split by Size (500+ lines)

```typescript
// Before: useComplexFeature (500+ lines)

// After: 5 focused composables (100 lines each)
export function useComplexFeature() {
  const data = useFeatureData()
  const ui = useFeatureUI()
  const sync = useFeatureSync()
  const validation = useFeatureValidation()
  const analytics = useFeatureAnalytics()

  // Orchestration logic
  watchEffect(() => {
    if (data.changed) {
      sync.save(data.current)
      analytics.track('data_changed')
    }
  })

  return { data, ui, validation, analytics }
}
```

### Example 2: Split by Responsibility

```vue
<!-- Before: ProductCard.vue (300 lines) -->
<!-- Handles: display, cart actions, wishlist, quick view -->

<!-- After: Split into focused components -->
<template>
  <div class="product-card">
    <ProductImage :product="product" @click="showQuickView" />
    <ProductInfo :product="product" />
    <ProductActions
      :product="product"
      @add-to-cart="handleAddToCart"
      @add-to-wishlist="handleAddToWishlist"
    />
  </div>
</template>

<script setup>
// Only coordination logic
const { showQuickView } = useQuickView()
const { handleAddToCart } = useCart()
const { handleAddToWishlist } = useWishlist()
</script>
```

## References

For detailed patterns and community consensus:
- `/Users/natedamstra/.claude/skills/external-research/outputs/doc_vue-composable-consolidation_2025-11-04.md`
- `/Users/natedamstra/.claude/skills/external-research/outputs/web_vue-state-colocation-patterns_2025-11-06.md`

Related skills:
- **vue-state-architect** - Decide where state should live (component/composable/store)
- **vue-composition-architect** - Solve prop drilling with provide/inject
- **vue-composable-factory** - Design composables with proper lifecycle management
