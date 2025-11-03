# Vue 3 Development Memories

This file documents research findings, patterns, and solutions discovered while working with Vue 3.

---

## 2025-10-16 - Vue 3 + Astro: Displaying User Information in Navigation Headers

**Question**: What are the best existing solutions, libraries, and patterns for displaying user information in navigation headers in Vue 3 + Astro applications?

**Answer**: Use nanostores with `useStore()` from `@nanostores/vue` to access reactive user state from a central auth store, ensuring SSR-safe patterns with `onMounted()` hooks.

**Key Details**:
- **Best Pattern**: `const $curUser = useStore(curUser)` gives reactive access to user data
- **SSR Safety**: Never call authentication APIs in component setup; use `onMounted()` or server-side API routes
- **Hydration Pattern**: Start with `null` user state on server, hydrate on client with session verification
- **Loading States**: Use composables like `useAuth()` that provide `isLoading` alongside user data
- **Cookie-based Sessions**: Appwrite uses `a_session_<PROJECT_ID>` cookie for SSR authentication
- **Reactivity**: Nanostores automatically trigger Vue re-renders when store values change

**Implementation Pattern**:
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue';
import { curUser } from '@/stores/authStore';

const $curUser = useStore(curUser);
</script>

<template>
  <div v-if="$curUser" class="user-info">
    <span>Welcome, {{ $curUser.name }}</span>
  </div>
</template>
```

**Alternative with Loading State**:
```vue
<script setup lang="ts">
import { useAuth } from '@composables/useAuth';

const { user, isLoading } = useAuth();
</script>

<template>
  <div v-if="isLoading">Loading...</div>
  <div v-else-if="user">Welcome, {{ user.name }}</div>
</template>
```

**SSR Considerations**:
- Use `currentUser()` async function for SSR-safe user fetching
- Server should render default/unauthenticated state
- Client hydration updates UI after session check
- Appwrite session verification via `/api/auth/verify.json` endpoint

**Dependencies**:
- `nanostores` - Core store library
- `@nanostores/vue` - Vue 3 integration
- `@nanostores/persistent` - Persistent atom support
- `appwrite` - Authentication SDK

**Sources**:
- Local: `/Users/natedamstra/.claude/documentation/nano/vue-integration.md`
- Local: `/Users/natedamstra/.claude/documentation/nano/core-concepts.md`
- Local: `/Users/natedamstra/.claude/documentation/appwrite/auth/ssr.md`
- Local: `/Users/natedamstra/.claude/documentation/appwrite/auth/auth-status.md`
- Project: `src/stores/authStore.ts` (curUser atom, currentUser function)
- Project: `src/components/vue/global/Navbar.vue` (working implementation)
- Web: Gemini CLI search for Vue 3 + Astro SSR auth patterns (2025)

**Verified**: Both ✓ (Local docs + Web research + Project code analysis)

---

## 2025-10-16 - Vue + Astro SSR: Fixing Hydration Mismatches

**Question**: What are the best practices and solutions for fixing Vue hydration mismatches in Astro SSR applications?

**Answer**: Use the `useMounted()` composable pattern with `v-if` for optimal balance of performance, SEO, and user experience. This ensures server and client render identical initial output.

**Key Details**:
- **Root Cause**: Server renders `<!---->` (v-if=false) while client renders `<div>` (v-if=true) due to browser API access
- **Best Solution**: `useMounted()` composable - returns `false` on both server and initial client render, changes to `true` after mount
- **Anti-Pattern**: Using `isClient` constant in `v-if` CAUSES mismatches (evaluates differently on server vs client)
- **Astro Directive**: `client:only="vue"` skips SSR entirely - use sparingly (impacts SEO and performance)
- **VueUse Composables**: `useSupported()` for feature detection, `useMediaQuery()` requires `ssrWidth` option

**Solution Comparison**:
| Solution | Performance | SEO | Hydration Safety | Use Case |
|----------|-------------|-----|------------------|----------|
| `useMounted()` + `v-if` | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ Perfect | Default approach |
| `client:only` directive | ⭐⭐ Poor | ⭐ Poor | ✅ Perfect | Client-only components |
| `useSupported()` | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ Perfect | Feature detection |
| `isClient` in v-if | N/A | N/A | ❌ CAUSES MISMATCH | Never use |

**Implementation Pattern**:
```typescript
// src/composables/useMounted.ts
import { ref, onMounted } from 'vue';

export function useMounted() {
  const isMounted = ref(false);
  onMounted(() => { isMounted.value = true; });
  return { isMounted };
}
```

```vue
<script setup lang="ts">
import { useMounted } from '@/composables/useMounted';
const { isMounted } = useMounted();
</script>

<template>
  <div>
    <!-- Server + initial client render -->
    <div v-if="!isMounted" class="skeleton">Loading...</div>

    <!-- Only after client mount -->
    <div v-if="isMounted">
      {{ localStorage.getItem('data') }}
    </div>
  </div>
</template>
```

**Why This Works**:
- Server: `isMounted = false` → renders skeleton
- Client (initial): `isMounted = false` → renders skeleton (SAME as server!)
- Client (after mount): `isMounted = true` → renders actual content
- No mismatch because server and initial client output are identical

**Astro Client Directives**:
- `client:only="vue"` - No SSR, client-only render
- `client:load` - Hydrate immediately on page load
- `client:idle` - Hydrate when browser is idle
- `client:visible` - Hydrate when in viewport

**VueUse SSR-Safe Composables**:
- `useMounted()` - Client mount detection
- `useSupported(() => condition)` - Feature detection (always false on server)
- `isClient` - Constant (safe for direct checks, NOT in v-if)
- `useMediaQuery()` - Requires `{ ssrWidth: 768 }` option
- `useBreakpoints()` - Requires `ssrWidth` via `provideSSRWidth()`

**Performance Best Practices**:
- Render skeleton loaders with same dimensions as real content (prevents CLS)
- Minimize client-only content (maximize SSR benefits)
- Use `client:idle` or `client:visible` for non-critical components
- Always test with SSR enabled during development

**Sources**:
- Local: `/Users/natedamstra/.claude/documentation/vue/vueuse/useMounted.md`
- Local: `/Users/natedamstra/.claude/documentation/vue/vueuse/useSupported.md`
- Local: `/Users/natedamstra/.claude/documentation/vue/vueuse/isClient.md`
- Local: `/Users/natedamstra/.claude/documentation/astro/reference/directives-reference.md`
- Local: `/Users/natedamstra/.claude/documentation/astro/integrations/vue.md`
- Web: Gemini CLI - Vue 3 hydration mismatch Astro SSR best practices (2025)
- Project: Complete research report at `HYDRATION_MISMATCH_RESEARCH_REPORT.md`

**Verified**: Both ✓ (Local VueUse docs + Astro docs + Web research 2025)

---
