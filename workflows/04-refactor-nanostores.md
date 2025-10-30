---
name: Refactor Component to Use Nanostores
type: state-management
status: production-ready
updated: 2025-10-16
---

# Workflow: Refactor Component to Use Nanostores

**Goal**: Remove prop drilling by moving state to Nanostores for cross-component sharing

**Duration**: 1-3 hours
**Complexity**: Medium-High
**Pain Point**: Too many props being drilled through component hierarchy

---

## Steps

### 1. Analyze Current State
Use Gemini to analyze component tree:

**Command**:
```
mcp__gemini-cli__ask-gemini "@src/components/vue/... analyze prop drilling"
```

**What to identify:**
- Which props are passed through multiple levels
- How many components affected
- Data flow patterns
- Shared vs local state

### 2. Create Store
Use `/store create featureStore`

**Agent**: `nanostore-state-architect` designs store structure

**Implements:**
- Atom stores for simple values
- Map stores for complex objects
- Actions for state mutations
- TypeScript typing

**Example:**
```typescript
// stores/postStore.ts
import { map } from 'nanostores';
import type { Post } from '@/types';

export interface PostState {
  posts: Post[];
  selectedPost: Post | null;
  loading: boolean;
}

export const postStore = map<PostState>({
  posts: [],
  selectedPost: null,
  loading: false,
});

// Actions
export function setPosts(posts: Post[]) {
  postStore.setKey('posts', posts);
}

export function selectPost(post: Post | null) {
  postStore.setKey('selectedPost', post);
}

export function setLoading(loading: boolean) {
  postStore.setKey('loading', loading);
}
```

### 3. Refactor Components
Use `/component refactor ComponentA`

**Agent**: `vue-architect` removes props and adds store usage

**Pattern - Before:**
```vue
<script setup lang="ts">
const props = defineProps<{
  posts: Post[];
  selectedPost: Post | null;
  onSelect: (post: Post) => void;
}>();
</script>

<template>
  <div>
    <PostList :posts="props.posts" @select="props.onSelect" />
    <PostDetail v-if="props.selectedPost" :post="props.selectedPost" />
  </div>
</template>
```

**Pattern - After:**
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue';
import { postStore, selectPost } from '@/stores/postStore';

// Reactive access (triggers re-render)
const state = useStore(postStore);

// Event handler
function handleSelect(post: Post) {
  selectPost(post);
}
</script>

<template>
  <div>
    <PostList :posts="state.posts" @select="handleSelect" />
    <PostDetail v-if="state.selectedPost" :post="state.selectedPost" />
  </div>
</template>
```

### 4. Update Tests
Use `vue-testing-specialist` to update component tests

**Tests to update:**
- Store integration tests
- Reactive update tests
- Component behavior with store

### 5. Validate SSR Compatibility
Final validation:

**Agent**: `ssr-debugger` checks for hydration issues

**What to verify:**
- Store initialization same on server and client
- No hydration mismatches
- State hydrates correctly
- Client-side updates work

---

## Agent Orchestration

```
code-reuser-scout (analyze) → nanostore-state-architect (design) →
vue-architect (refactor) → vue-testing-specialist (test) →
ssr-debugger (validate)
```

---

## Store Architecture Patterns

### Simple Atom Store
```typescript
import { atom } from 'nanostores';

export const darkMode = atom<boolean>(false);

// Toggle
darkMode.set(!darkMode.get());
```

### Map Store with Actions
```typescript
import { map } from 'nanostores';

export const userStore = map<{ user: User | null; loading: boolean }>({
  user: null,
  loading: false,
});

export async function loginUser(email: string, password: string) {
  userStore.setKey('loading', true);
  try {
    const user = await authenticateUser(email, password);
    userStore.set({ user, loading: false });
  } catch (error) {
    userStore.setKey('loading', false);
    throw error;
  }
}
```

### Computed Store
```typescript
import { computed } from 'nanostores';
import { userStore } from './userStore';

export const isAuthenticated = computed(
  userStore,
  (state) => state.user !== null
);
```

### Persistent Store
```typescript
import { persistentAtom } from '@nanostores/persistent';

export const userPreferences = persistentAtom<Preferences>(
  'user_prefs',
  defaultPreferences,
  {
    encode: JSON.stringify,
    decode: JSON.parse,
  }
);
```

---

## Usage Patterns

### Reactive Access (For Template)
```vue
<script setup>
import { useStore } from '@nanostores/vue';
import { userStore } from '@/stores/userStore';

// Reactive - triggers re-render
const user = useStore(userStore);
</script>

<template>
  <!-- Auto-unwraps: user.value.name -->
  <p>{{ user.value?.name }}</p>
</template>
```

### Non-Reactive Access (For Events)
```vue
<script setup>
import { userStore } from '@/stores/userStore';

function handleClick() {
  // Get current value - no reactivity needed
  const current = userStore.get();
  console.log(current);
}
</script>
```

### Watching Store
```vue
<script setup>
import { watch } from 'vue';
import { useStore } from '@nanostores/vue';
import { userStore } from '@/stores/userStore';

const user = useStore(userStore);

watch(user, (newUser) => {
  if (newUser) {
    console.log('User logged in:', newUser.name);
  }
});
</script>
```

---

## Migration Checklist

- [ ] Identify all prop drilling
- [ ] Design store structure
- [ ] Create store with actions
- [ ] Refactor components to use store
- [ ] Remove unused props
- [ ] Update component tests
- [ ] Test reactive updates work
- [ ] Test SSR hydration
- [ ] No hydration mismatches
- [ ] Performance acceptable
- [ ] Build passes all checks

---

## Common Pitfalls

### ❌ Wrong: Calling .get() in template
```vue
<template>
  <!-- Never do this -->
  {{ store.get().value }}
</template>
```

### ✅ Right: Use useStore() in script
```vue
<script setup>
const state = useStore(store);
</script>

<template>
  {{ state.value }}
</template>
```

### ❌ Wrong: Mutating store state directly
```typescript
const state = userStore.get();
state.user.name = "New Name"; // Won't trigger reactivity
```

### ✅ Right: Use store actions
```typescript
userStore.setKey('user', { ...user, name: "New Name" });
```

---

## Related Workflows

- [Create Feature Page](./01-create-feature-page.md)
- [Debug Existing Feature](./07-debug-existing-feature.md)
- [Test-Driven Development](./08-test-driven-development.md)

---

**Time Estimate**: 1-3 hours | **Complexity**: Medium-High | **Status**: ✅ Production Ready
