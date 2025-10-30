---
name: Nanostore Builder
description: Comprehensive Nanostores guide covering BaseStore (Appwrite CRUD), persistentAtom/Map (client state), computed (derived state), and hybrid patterns. CRITICAL decision framework - BaseStore for collections, persistentAtom for UI state, atom for runtime, computed for derived. Includes SSR safety, factory patterns, multi-atom orchestration, performance optimization. Always search existing stores first. Use for "store", "state", "persistence", "reactive", "database", "CRUD", "UI state".
version: 3.0.0
tags: [nanostores, state-management, appwrite, basestore, zod, crud, persistence, reactivity, ssr, computed, factory-pattern]
---

# Nanostore Builder

## 🎯 Store Type Decision Framework

**CRITICAL: Choose the right store type FIRST, then implement**

```
What are you storing?
├─ Appwrite Collection Data (CRUD operations)?
│  └─ ✅ Use: BaseStore<T>
│     └─ Examples: chatStore, postContainerStore, teamStore
│
├─ Persistent Client State (survives page reload)?
│  ├─ Single Value?
│  │  └─ ✅ Use: persistentAtom<T>
│  │     └─ Examples: curUser, selectedTeam, jwtCache
│  └─ Multiple Key-Value Pairs?
│     └─ ✅ Use: persistentMap<T>
│        └─ Example: floatingPanelStore (panel configs by ID)
│
├─ Derived/Computed State (calculated from other stores)?
│  └─ ✅ Use: computed()
│     └─ Examples: visiblePanels, workflowProgress, canProceed
│
├─ Ephemeral Runtime State (reset on page reload)?
│  └─ ✅ Use: atom<T>
│     └─ Examples: navigationState, runtimePanelState, isDragging
│
└─ Complex Multi-State Orchestration?
   └─ ✅ Use: Hybrid Approach (combine multiple types)
      └─ Examples: workflowStore, floatingPanelStore, authStore

💡 **Cleanup Pattern:** When resetting multiple stores (logout, user switch), use the **Coordinated Cleanup Pattern** from useAuth - clears stores in dependency order with race condition prevention.
```

### When NOT to Use BaseStore ❌

**Don't use BaseStore for:**
- UI state (modal open/closed, active tab)
- Client-only data (drag positions, scroll state)
- Computed values (derived from other stores)
- Non-Appwrite data sources
- Session-only state (reset on logout)

**Use raw nanostores instead!**

## BaseStore Pattern (Appwrite Collections)

### BEFORE Creating Store

**CRITICAL CHECKS:**
1. ❗ Search for existing store: `grep -r "BaseStore" src/stores/`
2. ❗ Check if collection already has store
3. ❗ Verify Appwrite collection exists and schema matches
4. ❗ Look for similar state management patterns

### When to Create Store

✅ Create new store when:
- Managing Appwrite collection data
- Need persistence with local state
- Require CRUD operations with validation
- State needs to be shared across components

❌ Don't create store when:
- Simple local component state (use ref/reactive)
- One-time data fetch (use composable)
- Store already exists for this collection

## BaseStore Extension Template

```typescript
import { BaseStore } from './baseStore'
import { z } from 'zod'
import type { Models } from 'appwrite'

// 1. Zod Schema (matches Appwrite collection attributes)
export const UserSchema = z.object({
  $id: z.string().optional(),
  $createdAt: z.string().datetime().optional(),
  $updatedAt: z.string().datetime().optional(),
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email'),
  avatar: z.string().url().optional(),
  bio: z.string().max(500).optional(),
  role: z.enum(['user', 'admin']).default('user')
})

// 2. Type inference from schema
export type User = z.infer<typeof UserSchema>

// 3. Store class extending BaseStore
export class UserStore extends BaseStore<typeof UserSchema> {
  constructor() {
    super(
      import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID, // Collection ID from env
      UserSchema,                                           // Zod schema
      'user',                                               // Atom key (for persistence)
      import.meta.env.PUBLIC_APPWRITE_DATABASE_ID          // Database ID from env
    )
  }

  // Custom methods beyond CRUD

  /**
   * Get currently authenticated user
   */
  async getCurrentUser(): Promise<User | null> {
    try {
      const account = await this.account.get()
      return await this.get(account.$id)
    } catch {
      return null
    }
  }

  /**
   * Update user profile with validation
   */
  async updateProfile(userId: string, data: Partial<User>): Promise<User> {
    // Validate partial data
    const validated = UserSchema.partial().parse(data)

    // Update using BaseStore method
    return await this.update(userId, validated)
  }

  /**
   * Search users by name
   */
  async searchByName(query: string): Promise<User[]> {
    const users = await this.list([
      Query.search('name', query),
      Query.limit(10)
    ])
    return users
  }

  /**
   * Get users by role
   */
  async getUsersByRole(role: 'user' | 'admin'): Promise<User[]> {
    return await this.list([
      Query.equal('role', role)
    ])
  }
}

// 4. Export singleton instance
export const userStore = new UserStore()

// 5. Export atom for Vue reactivity
export const $user = userStore.atom
```

## BaseStore Methods (Inherited)

Your stores automatically have these methods from BaseStore:

```typescript
// Create
await store.create(data, documentId?)

// Read
await store.get(documentId)
await store.list(queries?)

// Update
await store.update(documentId, data)

// Delete
await store.delete(documentId)

// Upsert (create or update)
await store.upsert(documentId, data)

// Count
await store.count(queries?)

// Realtime subscription
store.subscribe((document) => {
  // Handle realtime updates
})
```

## Vue Integration

```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $user, userStore, type User } from '@/stores/user'
import { ref } from 'vue'

// Reactive store value
const user = useStore($user)

// Loading state
const loading = ref(false)
const error = ref<string | null>(null)

// Load current user
async function loadUser() {
  loading.value = true
  error.value = null

  try {
    const currentUser = await userStore.getCurrentUser()
    // Store automatically updates $user atom
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

// Update profile
async function updateName(newName: string) {
  if (!user.value?.$id) return

  loading.value = true
  try {
    await userStore.updateProfile(user.value.$id, { name: newName })
    // $user atom automatically updates
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

// Search users
const searchResults = ref<User[]>([])

async function searchUsers(query: string) {
  if (!query) {
    searchResults.value = []
    return
  }

  loading.value = true
  try {
    searchResults.value = await userStore.searchByName(query)
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div>
    <!-- Display user -->
    <div v-if="user">
      <h2>{{ user.name }}</h2>
      <p>{{ user.email }}</p>
    </div>

    <!-- Update form -->
    <input
      v-model="newName"
      @blur="updateName(newName)"
      class="px-4 py-2 border rounded dark:bg-gray-800"
    />

    <!-- Search -->
    <input
      v-model="searchQuery"
      @input="searchUsers(searchQuery)"
      placeholder="Search users..."
      class="px-4 py-2 border rounded dark:bg-gray-800"
    />

    <div v-if="loading">Loading...</div>
    <div v-if="error" class="text-red-500">{{ error }}</div>
  </div>
</template>
```

## Zod Schema Best Practices

### Match Appwrite Attributes Exactly

```typescript
// Appwrite Collection Schema:
// - name (string, required)
// - email (string, required)
// - age (integer, optional)
// - verified (boolean, default: false)

// Matching Zod Schema:
const UserSchema = z.object({
  $id: z.string().optional(),           // Appwrite document ID
  $createdAt: z.string().optional(),    // Appwrite timestamp
  $updatedAt: z.string().optional(),    // Appwrite timestamp
  name: z.string(),                     // Required string
  email: z.string().email(),            // Required email
  age: z.number().int().optional(),     // Optional integer
  verified: z.boolean().default(false)  // Boolean with default
})
```

### Common Zod Patterns

```typescript
// Strings
z.string()                          // Required string
z.string().optional()               // Optional string
z.string().min(3)                   // Min length
z.string().max(100)                 // Max length
z.string().email()                  // Email validation
z.string().url()                    // URL validation
z.string().uuid()                   // UUID format

// Numbers
z.number()                          // Required number
z.number().int()                    // Integer only
z.number().positive()               // Must be positive
z.number().min(0).max(100)          // Range

// Booleans
z.boolean()                         // Boolean
z.boolean().default(false)          // With default

// Enums
z.enum(['active', 'pending', 'inactive'])

// Arrays
z.array(z.string())                 // String array
z.array(UserSchema)                 // Array of objects

// Dates
z.string().datetime()               // ISO datetime string
z.date()                            // Date object

// Optional fields
z.string().optional()               // May be undefined
z.string().nullable()               // May be null
z.string().nullish()                // May be null or undefined
```

## Environment Variables

Always use environment variables for IDs:

```typescript
// .env
PUBLIC_APPWRITE_DATABASE_ID=main_db
PUBLIC_APPWRITE_USERS_COLLECTION_ID=users
PUBLIC_APPWRITE_POSTS_COLLECTION_ID=posts

// In store
constructor() {
  super(
    import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
    UserSchema,
    'user',
    import.meta.env.PUBLIC_APPWRITE_DATABASE_ID
  )
}
```

## Error Handling

```typescript
// In custom store methods
async updateProfile(userId: string, data: Partial<User>): Promise<User> {
  try {
    // Validate before sending to Appwrite
    const validated = UserSchema.partial().parse(data)

    // Call BaseStore method (has built-in error handling)
    return await this.update(userId, validated)
  } catch (error) {
    if (error instanceof z.ZodError) {
      // Zod validation errors
      throw new Error(`Validation error: ${error.errors[0].message}`)
    }

    if (error instanceof AppwriteException) {
      // Appwrite errors
      if (error.code === 404) {
        throw new Error('User not found')
      } else if (error.code === 401) {
        throw new Error('Unauthorized')
      }
    }

    throw error
  }
}
```

## Store Checklist

Before creating a store:
- [ ] Searched for existing store with same purpose
- [ ] Verified Appwrite collection exists
- [ ] Ensured collection schema matches Zod schema
- [ ] Named store clearly (e.g., userStore, postStore)
- [ ] Used proper environment variables
- [ ] Extended BaseStore correctly
- [ ] Exported singleton instance
- [ ] Exported atom for reactivity
- [ ] Added custom methods if needed
- [ ] Included error handling

## Cross-References

For related patterns, see these skills:
- **zod-schema-architect** - Creating and organizing Zod schemas, Appwrite schema alignment, validation patterns
- **vue-composable-builder** - How to integrate stores in composables (use `useStore()`, never create stores in composables)
- **soc-appwrite-integration** - BaseStore pattern and Appwrite SDK integration
- **vue-component-builder** - How to use stores in Vue components

## Further Reading

See supporting files:
- **[store-types.md]** - Comprehensive guide to all nanostore types with examples
- **[advanced-patterns.md]** - Factory pattern, hybrid stores, multi-atom orchestration
- **[ssr-safety.md]** - SSR compatibility patterns and client-side guards
- **[performance.md]** - Auto-save, debouncing, and optimization strategies
- [basestore-patterns.md] - Deep dive into BaseStore
- [appwrite-sync.md] - Keeping Zod + Appwrite aligned
