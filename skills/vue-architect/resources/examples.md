# Examples

### Example 1: Choosing State Pattern for Modal

**Scenario:** Modal component needs open/closed state.

**Analysis:**
1. **Scope:** Single component
2. **Lifetime:** Component lifecycle only
3. **Source:** User interaction (button click)
4. **Ownership:** Component itself

**Decision:** Local component state

**Implementation:**
```vue
<script setup lang="ts">
const isOpen = ref(false)

function open() { isOpen.value = true }
function close() { isOpen.value = false }
</script>

<template>
  <button @click="open">Open Modal</button>
  <Teleport to="body">
    <div v-if="isOpen" class="modal">
      <div class="modal-content">
        <slot />
        <button @click="close">Close</button>
      </div>
    </div>
  </Teleport>
</template>
```

**Why not a store?** Only this component cares. No reason to lift.

### Example 2: Fixing Over-Abstracted Store

**Before (Premature Store):**
```typescript
// ❌ ANTI-PATTERN
export const useModalStore = defineStore('modal', () => {
  const isOpen = ref(false) // Used by single component
  return { isOpen }
})
```

**After (Local State):**
```vue
<script setup lang="ts">
// ✅ CORRECT: Local state
const isOpen = ref(false)
</script>
```

**Lesson:** Don't create stores "just in case." Start local, lift when needed.

### Example 3: Composable vs Store for Pagination

**Scenario:** Multiple unrelated lists need pagination.

**Analysis:**
- **Behavior:** Same (page tracking logic)
- **Data:** Different (each list has own page state)
- **Sharing:** No (lists don't coordinate)

**Decision:** Composable (isolated state per instance)

**Implementation:**
```typescript
// composables/usePagination.ts
export function usePagination(itemsPerPage = 10) {
  // Each call = new state instance
  const currentPage = ref(1)
  const totalItems = ref(0)

  const totalPages = computed(() =>
    Math.ceil(totalItems.value / itemsPerPage)
  )

  return { currentPage, totalItems, totalPages }
}

// ProductList.vue
const productPagination = usePagination(20)

// UserList.vue
const userPagination = usePagination(50) // Separate state
```

**Why not a store?** Each list needs independent pagination state. Store would share state globally (incorrect).

### Example 4: Form with Draft State

**Scenario:** User profile editing form.

**Requirements:**
- Don't update parent until Submit
- Allow Cancel without side effects
- Validate before committing

**Implementation:**
```vue
<script setup lang="ts">
interface User {
  name: string
  email: string
  bio: string
}

const modelValue = defineModel<User>()

// Local draft (copy of parent data)
const draft = ref<User>(structuredClone(modelValue.value))

watch(modelValue, (newValue) => {
  draft.value = structuredClone(newValue)
}, { deep: true })

const errors = ref<string[]>([])

function validate() {
  errors.value = []
  if (!draft.value.name) errors.value.push('Name required')
  if (!draft.value.email) errors.value.push('Email required')
  return errors.value.length === 0
}

function handleSubmit() {
  if (!validate()) return

  // Commit to parent
  modelValue.value = structuredClone(draft.value)
  alert('Saved!')
}

function handleCancel() {
  // Reset to parent value
  draft.value = structuredClone(modelValue.value)
  errors.value = []
}
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <div v-if="errors.length" class="errors">
      <p v-for="error in errors" :key="error">{{ error }}</p>
    </div>

    <input v-model="draft.name" placeholder="Name" required />
    <input v-model="draft.email" type="email" placeholder="Email" required />
    <textarea v-model="draft.bio" placeholder="Bio"></textarea>

    <button type="submit">Save</button>
    <button type="button" @click="handleCancel">Cancel</button>
  </form>
</template>
```

**Benefits:**
- Parent data untouched until submit
- Cancel works correctly
- Native validation enabled

### Example 5: Store Composition

**Scenario:** Cart depends on product prices and user discounts.

**Implementation:**
```typescript
// stores/products.ts
import { atom } from 'nanostores'

export const $products = atom<Product[]>([])

export async function fetchProducts() {
  const products = await api.getProducts()
  $products.set(products)
}

export function getPrice(id: string) {
  const products = $products.get()
  return products.find(p => p.id === id)?.price || 0
}

// stores/user.ts
import { atom, computed } from 'nanostores'

export const $user = atom<User | null>(null)
export const $discountRate = computed($user, (user) => user?.discountRate || 0)

// stores/cart.ts
import { atom, computed } from 'nanostores'
import { $products } from './products'
import { $discountRate } from './user'

export const $cartItems = atom<CartItem[]>([])

// Compose other stores via computed
export const $cartTotal = computed(
  [$cartItems, $products, $discountRate],
  (items, products, discountRate) => {
    return items.reduce((sum, item) => {
      const product = products.find(p => p.id === item.productId)
      const price = product?.price || 0
      const discount = price * discountRate
      return sum + (price - discount) * item.quantity
    }, 0)
  }
)
```

**Pattern:** Computed stores can depend on multiple atom stores for composition.
