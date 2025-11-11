# Astro Client Directives (Component-Level)

Basic client directive usage for Vue components in Astro. For architectural decisions, see **astro-vue-architect**.

## Available Directives

| Directive | When It Hydrates | Use Case |
|-----------|------------------|----------|
| `client:load` | Immediately on page load | Critical interactive elements |
| `client:visible` | When scrolled into view | Below-fold content |
| `client:idle` | After page becomes idle | Non-critical features |
| `client:only="vue"` | Client-only (no SSR) | Components that break SSR |
| `client:media="(max-width: 768px)"` | When media query matches | Responsive components |

## Basic Usage

```astro
---
// src/pages/index.astro
import SearchBox from '@/components/vue/SearchBox.vue'
import Chart from '@/components/vue/Chart.vue'
import Newsletter from '@/components/vue/Newsletter.vue'
---

<Layout>
  <!-- Critical: Load immediately -->
  <SearchBox client:load />
  
  <!-- Below fold: Load when visible -->
  <Chart client:visible />
  
  <!-- Non-critical: Load when idle -->
  <Newsletter client:idle />
</Layout>
```

## Passing Props

```astro
---
import UserProfile from '@/components/vue/UserProfile.vue'
const user = await getUser()
---

<UserProfile client:load :user="user" />
```

## Conditional Loading

```astro
---
import AdminPanel from '@/components/vue/AdminPanel.vue'
const isAdmin = Astro.locals.user?.role === 'admin'
---

{isAdmin && (
  <AdminPanel client:load />
)}
```

## Component-Level Considerations

- **SSR Safety**: Components with `client:only` skip SSR entirely
- **Props**: Pass server-fetched data as props for better performance
- **State**: Use Nanostores for shared state across components
- **Performance**: Use `client:visible` or `client:idle` for non-critical components

## References

- **astro-vue-architect** - For architectural decisions and optimization strategies
- [Astro Docs: Client Directives](https://docs.astro.build/en/reference/directives-reference/#client-directives)

