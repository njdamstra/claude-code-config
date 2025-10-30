---
name: Create New Feature Page
type: frontend-architecture
status: production-ready
updated: 2025-10-16
---

# Workflow: Create New Feature Page

**Goal**: Create a new dashboard page with authentication, data fetching, and interactive Vue components

**Duration**: 2-4 hours (depending on complexity)
**Complexity**: Medium
**Requirements**: Astro page, Vue components, Appwrite integration, TypeScript

---

## Steps

### 1. Research
Use `/frontend-research "Astro SSR auth patterns"` to understand authentication patterns and best practices.

**What to learn:**
- How Astro handles authentication on the server
- Cookie/session management patterns
- Data fetching in SSR context
- Layout composition

### 2. Create Page
Use `/page create src/pages/dashboard/new-feature.astro`

**Agent**: `astro-architect` implements the page layout, auth check, and server-side data fetching.

**What to implement:**
- Authentication middleware/check
- Server-side data fetching with type safety
- Layout composition
- Props passing to Vue components
- Error handling and redirects

### 3. Create Components
Use `/component create FeatureWidget`

**Agent**: `vue-architect` creates Vue components to display the data.

**Implements:**
- TypeScript props with strong typing
- Consuming Nanostores for shared state
- Using VueUse composables for common patterns
- Event emissions and two-way binding
- SSR-safe patterns with `useMounted()`

### 4. Style
Use `/style src/components/vue/FeatureWidget.vue`

**Agent**: `tailwind-styling-expert` adds responsive styling with dark mode support.

**What to apply:**
- Mobile-first responsive design
- Dark mode variants (`dark:` utilities)
- Accessibility (ARIA, focus states)
- Consistent spacing and typography
- Smooth transitions and animations

### 5. Validate
Use `/fix-types src/pages/dashboard/new-feature.astro`

**Agent**: `typescript-validator` ensures type safety across the entire page.

**What to validate:**
- All TypeScript errors resolved
- Props properly typed end-to-end
- API responses validated with Zod
- No `any` types without justification
- Build passes with `npm run typecheck`

---

## Agent Orchestration

```
astro-architect → vue-architect → tailwind-styling-expert → typescript-validator
```

**Parallel Options:**
- While `vue-architect` builds components, run `tailwind-styling-expert` on base styles
- While waiting for data fetching, implement component logic

---

## Code Examples

### Page Structure (Astro)
```astro
---
import Layout from '@/layouts/MainLayout.astro';
import { getSSRClient } from '@/lib/appwrite';
import type { Post } from '@/types';

// Authentication check
const { cookies, redirect } = Astro;
const session = cookies.get('session');
if (!session) return redirect('/login');

// Server-side data fetching
const client = getSSRClient(cookies, undefined, true, false);
const posts = await fetchUserPosts(client, session.value);
---

<Layout title="Dashboard">
  <FeatureWidget client:load data={posts} />
</Layout>
```

### Component Structure (Vue)
```vue
<script setup lang="ts">
import { ref, computed } from 'vue';
import { useStore } from '@nanostores/vue';
import { useMounted } from '@vueuse/core';
import { userStore } from '@/stores/userStore';
import type { Post } from '@/types';

const props = defineProps<{ data: Post[] }>();
const emit = defineEmits<{
  (e: 'select', post: Post): void;
}>();

const user = useStore(userStore);
const isMounted = useMounted();

const sortedData = computed(() =>
  [...props.data].sort((a, b) => b.createdAt - a.createdAt)
);

function handleSelect(post: Post) {
  emit('select', post);
}
</script>

<template>
  <div class="widget p-6 bg-white dark:bg-gray-800 rounded-lg">
    <h2 class="text-2xl font-bold mb-4">{{ user.value?.name }}'s Posts</h2>
    <ul v-if="isMounted" class="space-y-4">
      <li
        v-for="post in sortedData"
        :key="post.id"
        @click="handleSelect(post)"
        class="cursor-pointer p-4 hover:bg-gray-100 dark:hover:bg-gray-700 rounded"
      >
        {{ post.title }}
      </li>
    </ul>
  </div>
</template>
```

### Styling Pattern (Tailwind)
```vue
<template>
  <div class="
    p-4 md:p-6 lg:p-8
    bg-white dark:bg-gray-800
    text-gray-900 dark:text-white
    border border-gray-200 dark:border-gray-700
    rounded-lg shadow-md
  ">
    <!-- Content -->
  </div>
</template>
```

---

## Validation Checklist

- [ ] Page creates successfully
- [ ] Authentication check working
- [ ] Data fetches on server
- [ ] Components render correctly
- [ ] No hydration mismatches
- [ ] Responsive design (mobile, tablet, desktop)
- [ ] Dark mode works
- [ ] All TypeScript checks pass
- [ ] No console errors or warnings
- [ ] Performance acceptable (Lighthouse 90+)

---

## Common Issues & Fixes

**Issue**: Hydration mismatch on page load
**Fix**: Use `useMounted()` wrapper around client-only content
```vue
<div v-if="isMounted">Client-only content</div>
```

**Issue**: Props not typed correctly
**Fix**: Use `defineProps<T>()` with TypeScript interface
```typescript
const props = defineProps<{ items: Item[] }>();
```

**Issue**: Appwrite data not available on server
**Fix**: Ensure client initialized with server credentials
```typescript
const client = getSSRClient(cookies, undefined, true, false);
```

**Issue**: Styling doesn't apply to dark mode
**Fix**: Use `dark:` prefix in Tailwind classes
```html
<div class="bg-white dark:bg-gray-800">Content</div>
```

---

## Related Workflows

- [Debug SSR Hydration Issues](./02-debug-ssr-hydration.md)
- [Add Dark Mode](./05-add-dark-mode.md)
- [Test-Driven Development](./08-test-driven-development.md)

---

**Time Estimate**: 2-4 hours | **Complexity**: Medium | **Status**: ✅ Production Ready
