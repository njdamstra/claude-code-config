# Data Flow Patterns

Complete guide to server ↔ client data flow in Astro + Vue applications.

## Table of Contents
1. [Server Fetch → Vue Props](#server-fetch--vue-props)
2. [Nanostores Integration](#nanostores-integration)
3. [Content Collections → Vue](#content-collections--vue)
4. [API Routes → Client Fetching](#api-routes--client-fetching)
5. [Hybrid Patterns](#hybrid-patterns)

## Server Fetch → Vue Props

**When:** Initial page load, SEO-critical data, reduce client requests

**Pattern:**
```astro
---
// Fetch on server
const data = await fetchData()
---
<VueComponent client:load :data="data" />
```

**See SKILL.md Section 2 Pattern 1 for complete examples.**

## Nanostores Integration

**When:** Shared state, real-time updates, cross-component communication

**See SKILL.md Section 2 Pattern 2 for implementation.**

## Content Collections → Vue

**When:** Blog posts, docs, structured content with Vue interactivity

**See SKILL.md Section 2 Pattern 3 for examples.**

## API Routes → Client Fetching

**When:** User-triggered data, infinite scroll, search, pagination

**See SKILL.md Section 2 Pattern 4 for client-side patterns.**

## Hybrid Patterns

Combine server fetch (initial) + client updates (reactive):

```astro
---
const initialPosts = await postStore.list([Query.limit(10)])
---
<PostList client:load :initialPosts="initialPosts" />
```

```vue
<script setup lang="ts">
const props = defineProps<{ initialPosts: Post[] }>()
const posts = ref(props.initialPosts)

async function loadMore() {
  // Client-side pagination
}
</script>
```
