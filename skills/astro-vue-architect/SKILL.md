---
name: Astro + Vue Architect
description: Design and implement Astro + Vue applications with SSR capabilities, focusing on integration architecture, data flow patterns, performance optimization, and hybrid rendering strategies. Use when making architectural decisions (.astro vs Vue components), setting up appEntrypoint configuration, optimizing client directives, integrating View Transitions with Vue islands, or composing hybrid layouts. Provides decision frameworks, server ↔ client data strategies, and performance patterns. NOT for writing Vue components (vue-component-builder), creating composables (vue-composable-builder), or basic routing (astro-routing).
version: 1.0.0
tags: [astro, vue, ssr, architecture, integration, performance, view-transitions, appentrypoint, hybrid-rendering, client-directives, data-flow]
---

# Astro + Vue Architect

## When to Use This Skill

✅ **Use this skill when:**
- Making architectural decisions (.astro vs Vue component)
- Setting up global Vue configuration (appEntrypoint)
- Optimizing client directive usage (load vs visible vs idle)
- Integrating View Transitions with Vue islands
- Managing server → client data flow
- Composing hybrid layouts (Astro + Vue)
- Performance optimization strategies
- Deciding between SSR, partial hydration, and client-only rendering

❌ **Don't use this skill for:**
- Writing Vue components → use **vue-component-builder**
- Creating composables → use **vue-composable-builder**
- Using VueUse composables → use **vueuse-expert**
- Managing stores → use **nanostore-builder**
- Basic page/API routes → use **astro-routing**

---

## Quick Decision Tree: .astro vs Vue Component

```
What are you building?

├─ Mostly static content (blog post, landing page)?
│  └─ ✅ Use .astro component (zero JavaScript)
│
├─ Interactive but simple (accordion, tabs)?
│  ├─ Will it be reused across pages?
│  │  ├─ YES → ✅ Use Vue component
│  │  └─ NO → ✅ Use .astro component with <script>
│  └─ Need state management?
│     └─ ✅ Use Vue component
│
├─ Complex interactivity (forms, real-time, animations)?
│  └─ ✅ Use Vue component
│
├─ Navigation/header/footer?
│  ├─ Static → ✅ .astro component
│  └─ Interactive (dropdowns, user menu) → ✅ Vue component
│
└─ Data fetching?
   ├─ Server-only → ✅ Fetch in .astro, pass props to Vue
   └─ Client-side → ✅ Vue component with composable
```

---

## Core Architecture Patterns

### 1. Component Decision Framework

#### Use .astro Components When:

✅ **Content is mostly static**
```astro
---
// src/components/BlogPost.astro
const { title, content, date } = Astro.props
---
<article class="prose dark:prose-invert">
  <h1>{title}</h1>
  <time>{date}</time>
  <div set:html={content} />
</article>
```

✅ **Server-only data fetching**
```astro
---
// src/pages/users/[id].astro
import { userStore } from '@/stores/user'
const { id } = Astro.params
const user = await userStore.get(id)
---
<Layout>
  <h1>{user.name}</h1>
  <p>{user.bio}</p>
</Layout>
```

✅ **SEO-critical content** (no hydration delay)

✅ **Layouts and wrappers** (structural components)

#### Use Vue Components When:

✅ **Complex client-side interactivity**
```vue
<!-- src/components/vue/SearchBox.vue -->
<script setup lang="ts">
import { ref } from 'vue'
import { watchDebounced } from '@vueuse/core'

const query = ref('')
const results = ref([])

watchDebounced(query, async (q) => {
  results.value = await fetch(`/api/search?q=${q}`)
}, { debounce: 500 })
</script>
```

✅ **State management required** (forms, dashboards, etc.)

✅ **Reusable across multiple pages** (DRY principle)

✅ **Real-time updates** (WebSocket, polling, etc.)

✅ **Animations and transitions** (using @vueuse/motion)

#### Performance Implications

| Approach | Bundle Size | Time to Interactive | SEO |
|----------|-------------|---------------------|-----|
| `.astro` | ~0 KB | Instant | Excellent |
| `Vue (client:load)` | ~50-100 KB | ~200ms | Good |
| `Vue (client:visible)` | ~50-100 KB | When visible | Good |
| `Vue (client:idle)` | ~50-100 KB | ~500ms | Good |

**Rule of Thumb:** Start with `.astro`, upgrade to Vue only when needed.

---

### 2. Data Flow Architecture

#### Pattern 1: Server Fetch → Vue Props (Recommended)

**Best for:** Initial page load, SEO-critical data

```astro
---
// src/pages/dashboard.astro
import Dashboard from '@/components/vue/Dashboard.vue'
import { userStore } from '@/stores/user'
import { statsStore } from '@/stores/stats'

// Fetch on server
const user = await userStore.getCurrentUser()
const stats = await statsStore.getUserStats(user.$id)
---

<Layout title="Dashboard">
  <!-- Pass server-fetched data as props -->
  <Dashboard
    client:load
    :user="user"
    :stats="stats"
  />
</Layout>
```

**Why this works:**
- ✅ Faster initial render (data already in HTML)
- ✅ Better SEO (content in initial response)
- ✅ Reduced client-side requests
- ✅ Simpler error handling (server-side)

#### Pattern 2: Nanostores for Cross-Component State

**Best for:** Shared state, client-side updates

```astro
---
// src/layouts/AppLayout.astro
import Header from '@/components/vue/Header.vue'
import Sidebar from '@/components/vue/Sidebar.vue'
import { $user } from '@/stores/authStore'
---

<html>
  <body>
    <!-- Both components share $user store -->
    <Header client:load />
    <Sidebar client:visible />
    <main>
      <slot />
    </main>
  </body>
</html>
```

```vue
<!-- Both components access same store -->
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $user } from '@/stores/authStore'

const user = useStore($user) // Reactive shared state
</script>
```

#### Pattern 3: Content Collections → Vue Components

**Best for:** Blog posts, docs, structured content

```astro
---
// src/pages/blog/[...slug].astro
import { getCollection, getEntry } from 'astro:content'
import BlogPost from '@/components/vue/BlogPost.vue'

const entry = await getEntry('blog', Astro.params.slug)
const { Content } = await entry.render()
---

<Layout>
  <BlogPost
    client:load
    :title="entry.data.title"
    :date="entry.data.date"
    :tags="entry.data.tags"
  >
    <Content />
  </BlogPost>
</Layout>
```

#### Pattern 4: API Routes → Vue Client Fetching

**Best for:** User-triggered data, infinite scroll, search

```astro
---
// src/pages/api/posts.json.ts
import type { APIRoute } from 'astro'
import { postStore } from '@/stores/post'

export const GET: APIRoute = async ({ url }) => {
  const page = url.searchParams.get('page') ?? '1'
  const posts = await postStore.list([
    Query.limit(20),
    Query.offset((parseInt(page) - 1) * 20)
  ])

  return new Response(JSON.stringify(posts), {
    status: 200,
    headers: { 'Content-Type': 'application/json' }
  })
}
```

```vue
<!-- src/components/vue/PostList.vue -->
<script setup lang="ts">
import { ref, onMounted } from 'vue'

const posts = ref([])
const page = ref(1)

async function loadMore() {
  const response = await fetch(`/api/posts.json?page=${page.value}`)
  const newPosts = await response.json()
  posts.value.push(...newPosts)
  page.value++
}

onMounted(() => loadMore())
</script>
```

**See also:**
- [data-flow-patterns.md] - Complete data flow strategies
- **astro-routing** - API route patterns

---

### 3. appEntrypoint Configuration

The `appEntrypoint` option allows you to configure the Vue app instance globally before any components render.

#### Basic Setup

```js title="astro.config.mjs"
import { defineConfig } from 'astro/config'
import vue from '@astrojs/vue'

export default defineConfig({
  integrations: [
    vue({
      appEntrypoint: '/src/pages/_app'
    })
  ]
})
```

```ts title="src/pages/_app.ts"
import type { App } from 'vue'
import { MotionPlugin } from '@vueuse/motion'

export default (app: App) => {
  // Global plugins
  app.use(MotionPlugin)

  // Global components (use sparingly)
  // app.component('Icon', Icon)

  // Custom directives
  // app.directive('focus', { ... })
}
```

#### Common Use Cases

**1. VueUse Motion (Animations)**
```ts title="src/pages/_app.ts"
import { MotionPlugin } from '@vueuse/motion'

export default (app: App) => {
  app.use(MotionPlugin)
}
```

**2. i18n (Internationalization)**
```ts title="src/pages/_app.ts"
import { createI18n } from 'vue-i18n'

const i18n = createI18n({
  locale: 'en',
  messages: { /* ... */ }
})

export default (app: App) => {
  app.use(i18n)
}
```

**3. Global Error Handler**
```ts title="src/pages/_app.ts"
export default (app: App) => {
  app.config.errorHandler = (err, instance, info) => {
    console.error('Global error:', err, info)
    // Send to error tracking service
  }
}
```

**4. DevTools (Development Only)**
```ts title="src/pages/_app.ts"
export default (app: App) => {
  if (import.meta.env.DEV) {
    app.config.performance = true
  }
}
```

**⚠️ Warning:** Don't register too many global components - use local imports instead for better tree-shaking.

**See also:**
- [appentrypoint-guide.md] - Complete appEntrypoint patterns
- Astro docs: [Vue Integration](https://docs.astro.build/en/guides/integrations-guide/vue/)

---

### 4. Client Directive Optimization

Client directives control **when and how** Vue components hydrate on the client.

#### The Directives

| Directive | Hydration | Use Case | Bundle Impact |
|-----------|-----------|----------|---------------|
| `client:load` | Immediately on page load | Critical interactive elements (nav, search) | High priority |
| `client:visible` | When scrolled into view | Below-fold content (cards, comments) | Lazy loaded |
| `client:idle` | After page becomes idle | Non-critical features (chat widget) | Deferred |
| `client:only` | Client-only (no SSR) | Components that break SSR (charts) | Client-only |
| `client:media` | When media query matches | Responsive components (mobile menu) | Conditional |

#### Performance Strategy

```astro
<!--- src/pages/index.astro --->
<Layout>
  <!-- 1. Hero: Immediate interaction -->
  <Hero client:load />

  <!-- 2. Features (above fold): Load immediately -->
  <Features client:load />

  <!-- 3. Testimonials (below fold): Lazy load -->
  <Testimonials client:visible />

  <!-- 4. Newsletter (below fold): Even more lazy -->
  <Newsletter client:idle />

  <!-- 5. Chat widget: Lowest priority -->
  <ChatWidget client:idle />

  <!-- 6. Analytics chart: Client-only (uses window) -->
  <AnalyticsChart client:only="vue" />

  <!-- 7. Mobile menu: Only on mobile -->
  <MobileMenu client:media="(max-width: 768px)" />
</Layout>
```

#### Bundle Size Impact Example

```
Without optimization:
- Total JS: 250 KB
- Time to Interactive: 1.2s

With optimization (client:visible + client:idle):
- Initial JS: 80 KB
- Time to Interactive: 400ms
- Remaining: Loaded on demand
```

#### Decision Matrix

```
Is this component visible on initial load?
├─ YES
│  ├─ Does user interact with it immediately?
│  │  ├─ YES → client:load (navigation, search)
│  │  └─ NO → client:visible (cards, images)
│  └─ Is it critical for functionality?
│     ├─ YES → client:load
│     └─ NO → client:visible
│
└─ NO (below fold)
   ├─ Is it important when visible?
   │  ├─ YES → client:visible (comments)
   │  └─ NO → client:idle (newsletter, chat)
   └─ Does it break SSR?
      └─ YES → client:only (charts using window)
```

**See also:**
- [client-directive-optimization.md] - Complete optimization guide
- **astro-routing** - Client directive syntax

---

### 5. View Transitions Integration

Astro's View Transitions enable SPA-like navigation with Vue islands.

#### Basic Setup

```astro title="src/layouts/Layout.astro"
---
import { ClientRouter } from 'astro:transitions'
---
<html>
  <head>
    <ClientRouter />
  </head>
  <body>
    <slot />
  </body>
</html>
```

#### Persisting Vue Islands Across Navigation

**Problem:** By default, Vue components reset state on navigation.

**Solution:** Use `transition:persist`

```astro title="src/components/Header.astro"
<Header client:load transition:persist />
```

```astro title="src/pages/page1.astro"
<Layout>
  <!-- Video continues playing across navigation -->
  <VideoPlayer
    client:load
    transition:persist="video-player"
    :videoId="123"
  />
</Layout>
```

```astro title="src/pages/page2.astro"
<Layout>
  <!-- Same video player, state preserved -->
  <VideoPlayer
    client:load
    transition:persist="video-player"
    :videoId="456"
  />
</Layout>
```

#### Persisting State with Nanostores

**Best practice:** Use Nanostores for state that needs to persist across navigation.

```vue
<!-- src/components/vue/ShoppingCart.vue -->
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $cart } from '@/stores/cartStore'

// Cart state persists across navigation (store is global)
const cart = useStore($cart)
</script>
```

```astro
<!-- Anywhere in your app -->
<ShoppingCart client:load transition:persist />
```

#### Animation Coordination

```astro
<div
  transition:name="hero"
  transition:animate="slide"
>
  <Hero client:load />
</div>
```

#### Lifecycle Events with Vue

```vue
<script setup lang="ts">
import { onMounted } from 'vue'

// Re-run on every navigation
onMounted(() => {
  document.addEventListener('astro:after-swap', () => {
    // Refresh component after page swap
    refreshData()
  })
})
</script>
```

**See also:**
- [view-transitions-vue.md] - Complete View Transitions patterns
- Astro docs: [View Transitions](https://docs.astro.build/en/guides/view-transitions/)

---

### 6. Hybrid Layout Patterns

Combine Astro's zero-JS layouts with Vue's interactivity for optimal performance.

#### Pattern 1: Astro Shell + Vue Islands

```astro title="src/layouts/AppLayout.astro"
---
import Header from '@/components/vue/Header.vue'
import Footer from '@/components/vue/Footer.vue'
const { title } = Astro.props
---
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>{title}</title>
  </head>
  <body class="bg-white dark:bg-gray-900">
    <!-- Interactive header (Vue island) -->
    <Header client:load />

    <!-- Static Astro content (zero JS) -->
    <main class="container mx-auto px-4 py-8">
      <slot />
    </main>

    <!-- Interactive footer (Vue island) -->
    <Footer client:visible />
  </body>
</html>
```

#### Pattern 2: Nested Layouts with Slot Composition

```astro title="src/layouts/BlogLayout.astro"
---
import AppLayout from './AppLayout.astro'
import Sidebar from '@/components/vue/Sidebar.vue'
const { frontmatter } = Astro.props
---
<AppLayout title={frontmatter.title}>
  <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
    <aside class="lg:col-span-1">
      <Sidebar client:visible />
    </aside>

    <article class="lg:col-span-3 prose dark:prose-invert">
      <slot />
    </article>
  </div>
</AppLayout>
```

#### Pattern 3: Conditional Vue Islands

```astro title="src/layouts/Layout.astro"
---
import AdminPanel from '@/components/vue/AdminPanel.vue'
const isAdmin = Astro.locals.user?.role === 'admin'
---
<html>
  <body>
    <slot />

    <!-- Only load admin panel for admins -->
    {isAdmin && (
      <AdminPanel client:load />
    )}
  </body>
</html>
```

#### Pattern 4: Props Drilling vs Composition

**❌ Bad: Props drilling through multiple layers**
```astro
<Layout user={user}>
  <Page user={user}>
    <Component user={user} />
  </Page>
</Layout>
```

**✅ Good: Use Nanostores for global state**
```astro
<Layout>
  <Page>
    <Component />  <!-- Accesses $user store directly -->
  </Page>
</Layout>
```

**See also:**
- [hybrid-layouts.md] - Complete hybrid layout patterns
- **astro-routing** - Layout basics

---

### 7. Performance Optimization Strategies

#### Strategy 1: Minimize Initial JavaScript Bundle

```astro
<!-- ❌ Bad: Everything loads immediately -->
<Hero client:load />
<Features client:load />
<Testimonials client:load />
<Newsletter client:load />
<Chat client:load />

<!-- ✅ Good: Progressive enhancement -->
<Hero client:load />           <!-- Critical: 40 KB -->
<Features />                   <!-- Static: 0 KB -->
<Testimonials client:visible /> <!-- Lazy: 30 KB -->
<Newsletter client:idle />     <!-- Deferred: 20 KB -->
<Chat client:idle />           <!-- Deferred: 25 KB -->

Total initial: 40 KB instead of 135 KB
```

#### Strategy 2: Use .astro for Static Content

```astro
<!-- ❌ Bad: Vue component for static content -->
<BlogPost client:load :title="title" :content="content" />
<!-- Adds ~50 KB Vue runtime + component code -->

<!-- ✅ Good: Astro component for static content -->
<BlogPost title={title} content={content} />
<!-- Adds 0 KB JavaScript -->
```

#### Strategy 3: Split Large Components

```vue
<!-- ❌ Bad: Monolithic component -->
<script setup lang="ts">
// 200 KB component with everything
import Chart from 'heavy-chart-library'
import Editor from 'heavy-editor-library'
import Calendar from 'heavy-calendar-library'
</script>
```

```astro
<!-- ✅ Good: Split by client directive -->
<DashboardStats client:load />      <!-- 20 KB, critical -->
<Chart client:visible />            <!-- 80 KB, lazy -->
<Editor client:idle />              <!-- 60 KB, deferred -->
<Calendar client:only="vue" />      <!-- 40 KB, client-only -->
```

#### Strategy 4: Avoid Global Components

```ts
// ❌ Bad: Global component registration
app.component('Icon', Icon)
app.component('Button', Button)
app.component('Card', Card)
// Bundles all components everywhere
```

```vue
<!-- ✅ Good: Local imports -->
<script setup lang="ts">
import { Icon } from '@iconify/vue'
import Button from '@/components/vue/ui/Button.vue'
// Tree-shaking removes unused components
</script>
```

#### Strategy 5: Monitor Bundle Size

```bash
# Build and analyze
npm run build

# Check bundle sizes
ls -lh dist/_astro/*.js
```

**Performance Budget:**
- Initial JS: < 100 KB
- Time to Interactive: < 500ms
- First Contentful Paint: < 1s

**See also:**
- [client-directive-optimization.md] - Detailed optimization guide
- Astro docs: [Performance](https://docs.astro.build/en/concepts/why-astro/#performance)

---

## Cross-References

For implementation details, see related skills:

### Routing & Pages
- **astro-routing** - Creating `.astro` pages, API routes (`/api/*.json.ts`), basic client directive syntax, dynamic routes `[slug].astro`, layouts, error pages (404/500)

### Vue Component Development
- **vue-component-builder** - Building Vue 3 SFCs with `<script setup>`, Composition API, TypeScript, Tailwind CSS, dark mode, SSR safety patterns, defineModel(), HeadlessUI, Iconify, Floating UI, ECharts integration

### State & Logic
- **vue-composable-builder** - Creating composables with proper architecture (state → computed → methods → lifecycle), VueUse integration, store orchestration, SSR-safe patterns, side effect management

- **vueuse-expert** - Using 160+ VueUse composables across 8 categories, SSR safety guide (useMounted, useSupported), motion library (@vueuse/motion), decision trees for composable selection

- **nanostore-builder** - State management with Nanostores, BaseStore pattern for Appwrite collections, persistentAtom/Map for client state, computed stores, SSR safety, factory patterns

---

## Common Patterns Summary

### When to Use What

| Scenario | Recommended Approach |
|----------|---------------------|
| Static blog post | `.astro` component (0 KB JS) |
| Interactive form | Vue component with `client:load` |
| Image gallery below fold | Vue component with `client:visible` |
| Chat widget | Vue component with `client:idle` |
| Chart using `window` | Vue component with `client:only` |
| Mobile-only menu | Vue component with `client:media` |
| Server data → client | Fetch in `.astro`, pass props to Vue |
| Shared state | Nanostores (`$store`) |
| Navigation persistence | View Transitions + `transition:persist` |
| Global Vue config | `appEntrypoint` pattern |

---

## Further Reading

See supporting files for detailed patterns:
- **[component-decision-tree.md]** - Complete .astro vs Vue analysis with examples
- **[data-flow-patterns.md]** - Server ↔ client data strategies, Content Collections integration
- **[appentrypoint-guide.md]** - Global Vue setup, plugin configuration, DevTools
- **[client-directive-optimization.md]** - Performance guide with bundle size analysis
- **[view-transitions-vue.md]** - Complete View Transitions integration with Vue islands
- **[hybrid-layouts.md]** - Advanced layout composition patterns with Astro + Vue

---

## Quick Start Checklist

When starting a new Astro + Vue project:

- [ ] Install integration: `npx astro add vue`
- [ ] Set up `appEntrypoint` if using global plugins
- [ ] Use `.astro` for static content (layouts, pages, wrappers)
- [ ] Use Vue for interactive components (forms, dashboards, etc.)
- [ ] Optimize with client directives (visible, idle, media)
- [ ] Add View Transitions if SPA-like navigation needed
- [ ] Use Nanostores for shared state across components
- [ ] Monitor bundle size and Time to Interactive
- [ ] Reference other skills for implementation details

**Architecture principle:** Start with zero JavaScript (`.astro`), add Vue only where interactivity is needed, optimize with client directives, use Nanostores for state, integrate View Transitions for smooth navigation.
