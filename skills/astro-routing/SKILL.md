---
name: Astro Routing
description: Create Astro pages and API routes with proper SSR patterns. Use when building SSR pages (src/pages/[slug].astro), API endpoints (.json.ts pattern), or implementing client directives (client:load, client:visible, client:idle). Handles server-side data fetching, prop passing to Vue components, Zod validation in API routes. Prevents hydration mismatches by properly scoping server vs client code. Use for "Astro page", "API route", ".json.ts", "SSR", "client directive", "[dynamic]", "server component". Ensures client-only code doesn't run during build.
version: 2.0.0
tags: [astro, ssr, routing, pages, api-routes, dynamic-routes, json-api, client-directives, hydration, server-side-rendering]
---

# Astro Routing

## Page Creation

### Basic Page

```astro
---
// src/pages/index.astro
import Layout from '@/layouts/Layout.astro'
import Hero from '@/components/vue/Hero.vue'

// Server-side code (runs during build/SSR)
const title = 'Home Page'
const description = 'Welcome to our site'
---

<Layout title={title} description={description}>
  <Hero client:load />

  <main class="container mx-auto px-4 py-8">
    <h1 class="text-4xl font-bold text-gray-900 dark:text-gray-100">
      {title}
    </h1>
  </main>
</Layout>
```

### Dynamic Page

```astro
---
// src/pages/users/[id].astro
import Layout from '@/layouts/Layout.astro'
import UserProfile from '@/components/vue/UserProfile.vue'
import { userStore } from '@/stores/user'

// Get params from URL
const { id } = Astro.params

// Fetch data on server
const user = await userStore.get(id)

if (!user) {
  return Astro.redirect('/404')
}
---

<Layout title={`${user.name}'s Profile`}>
  <UserProfile
    client:load
    user={user}
  />
</Layout>
```

### Page with Data Fetching

```astro
---
// src/pages/blog/index.astro
import Layout from '@/layouts/Layout.astro'
import PostCard from '@/components/vue/PostCard.vue'
import { postStore } from '@/stores/post'
import { Query } from 'appwrite'

// Server-side data fetching
const posts = await postStore.list([
  Query.orderDesc('$createdAt'),
  Query.limit(10)
])
---

<Layout title="Blog">
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    {posts.map((post) => (
      <PostCard
        client:visible
        post={post}
      />
    ))}
  </div>
</Layout>
```

## Client Directives

```astro
<!-- Load component immediately -->
<Component client:load />

<!-- Load when component becomes visible -->
<Component client:visible />

<!-- Load when page is idle -->
<Component client:idle />

<!-- Load based on media query -->
<Component client:media="(max-width: 768px)" />

<!-- Only render on client, never on server -->
<Component client:only="vue" />
```

**When to use which:**
- `client:load` - Interactive immediately (navigation, auth)
- `client:visible` - Below fold (cards, images)
- `client:idle` - Nice to have (comments, related content)
- `client:media` - Responsive components
- `client:only` - Breaks SSR (charts, maps)

## API Routes

### Basic API Route

```typescript
// src/pages/api/hello.json.ts
import type { APIRoute } from 'astro'

export const GET: APIRoute = async ({ request }) => {
  return new Response(
    JSON.stringify({
      message: 'Hello World'
    }),
    {
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      }
    }
  )
}
```

### API Route with Validation

```typescript
// src/pages/api/users.json.ts
import type { APIRoute } from 'astro'
import { z } from 'zod'
import { userStore } from '@/stores/user'

// Request schema
const CreateUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  age: z.number().int().min(18).optional()
})

export const POST: APIRoute = async ({ request }) => {
  try {
    // Parse request body
    const body = await request.json()

    // Validate with Zod
    const validated = CreateUserSchema.parse(body)

    // Create user
    const user = await userStore.create(validated)

    // Return success
    return new Response(
      JSON.stringify({
        success: true,
        user
      }),
      {
        status: 201,
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )

  } catch (error) {
    // Handle Zod validation errors
    if (error instanceof z.ZodError) {
      return new Response(
        JSON.stringify({
          success: false,
          errors: error.errors
        }),
        {
          status: 400,
          headers: {
            'Content-Type': 'application/json'
          }
        }
      )
    }

    // Handle other errors
    return new Response(
      JSON.stringify({
        success: false,
        message: 'Internal server error'
      }),
      {
        status: 500,
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )
  }
}
```

### Dynamic API Route

```typescript
// src/pages/api/users/[id].json.ts
import type { APIRoute } from 'astro'
import { userStore } from '@/stores/user'

export const GET: APIRoute = async ({ params }) => {
  const { id } = params

  if (!id) {
    return new Response(
      JSON.stringify({ error: 'ID required' }),
      { status: 400 }
    )
  }

  const user = await userStore.get(id)

  if (!user) {
    return new Response(
      JSON.stringify({ error: 'User not found' }),
      { status: 404 }
    )
  }

  return new Response(
    JSON.stringify({ user }),
    { status: 200 }
  )
}

export const DELETE: APIRoute = async ({ params }) => {
  const { id } = params

  if (!id) {
    return new Response(
      JSON.stringify({ error: 'ID required' }),
      { status: 400 }
    )
  }

  await userStore.delete(id)

  return new Response(
    JSON.stringify({ success: true }),
    { status: 200 }
  )
}
```

### Complete CRUD API

```typescript
// src/pages/api/posts.json.ts
import type { APIRoute } from 'astro'
import { z } from 'zod'
import { postStore, PostSchema } from '@/stores/post'
import { Query } from 'appwrite'

// CREATE
export const POST: APIRoute = async ({ request }) => {
  try {
    const body = await request.json()
    const validated = PostSchema.parse(body)
    const post = await postStore.create(validated)

    return new Response(JSON.stringify({ post }), { status: 201 })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return new Response(
        JSON.stringify({ errors: error.errors }),
        { status: 400 }
      )
    }
    return new Response(
      JSON.stringify({ error: 'Internal error' }),
      { status: 500 }
    )
  }
}

// LIST
export const GET: APIRoute = async ({ url }) => {
  try {
    // Get query params
    const page = parseInt(url.searchParams.get('page') ?? '1')
    const limit = parseInt(url.searchParams.get('limit') ?? '10')
    const offset = (page - 1) * limit

    // Query posts
    const posts = await postStore.list([
      Query.orderDesc('$createdAt'),
      Query.limit(limit),
      Query.offset(offset)
    ])

    const total = await postStore.count()

    return new Response(
      JSON.stringify({
        posts,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      }),
      { status: 200 }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: 'Internal error' }),
      { status: 500 }
    )
  }
}
```

## Passing Props to Components

```astro
---
// Fetch data on server
const user = await userStore.getCurrentUser()
const posts = await postStore.list()

// Complex data
const stats = {
  totalPosts: posts.length,
  totalViews: posts.reduce((sum, p) => sum + p.views, 0)
}
---

<!-- Pass as props -->
<UserProfile client:load user={user} />

<!-- Pass multiple props -->
<Dashboard
  client:load
  user={user}
  posts={posts}
  stats={stats}
/>

<!-- Serialize complex data -->
<DataVisualization
  client:load
  data={JSON.stringify(stats)}
/>
```

## Layouts

```astro
---
// src/layouts/Layout.astro
interface Props {
  title: string
  description?: string
}

const { title, description = 'Default description' } = Astro.props
---

<!DOCTYPE html>
<html lang="en" class="dark:bg-gray-900">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <meta name="description" content={description} />
    <title>{title}</title>
  </head>
  <body class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
    <!-- Teleport target for modals -->
    <div id="teleport-layer"></div>

    <slot />
  </body>
</html>
```

## Error Pages

```astro
---
// src/pages/404.astro
import Layout from '@/layouts/Layout.astro'
---

<Layout title="404 - Page Not Found">
  <div class="min-h-screen flex items-center justify-center">
    <div class="text-center">
      <h1 class="text-6xl font-bold text-gray-900 dark:text-gray-100">
        404
      </h1>
      <p class="text-xl text-gray-600 dark:text-gray-400 mt-4">
        Page not found
      </p>
      <a
        href="/"
        class="mt-8 inline-block px-6 py-3 bg-blue-600 dark:bg-blue-500 text-white rounded-lg"
      >
        Go Home
      </a>
    </div>
  </div>
</Layout>
```

## Best Practices

### 1. Server vs Client Code

```astro
---
// This runs on SERVER only (during build/SSR)
const data = await fetchData()
const computed = heavyComputation()

// Client-side code must be in <script> tag
---

<script>
  // This runs in BROWSER
  console.log('Client-side code')

  document.addEventListener('click', () => {
    // Handle clicks
  })
</script>

<template>
  <!-- This renders on SERVER, hydrates on CLIENT -->
  <Component client:load data={data} />
</template>
```

### 2. SEO-Friendly Pages

```astro
---
const page = {
  title: 'My Page',
  description: 'Description for SEO',
  image: '/og-image.jpg',
  url: Astro.url.href
}
---

<Layout title={page.title}>
  <Fragment slot="head">
    <!-- Open Graph -->
    <meta property="og:title" content={page.title} />
    <meta property="og:description" content={page.description} />
    <meta property="og:image" content={page.image} />
    <meta property="og:url" content={page.url} />

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content={page.title} />
    <meta name="twitter:description" content={page.description} />
    <meta name="twitter:image" content={page.image} />
  </Fragment>

  <!-- Page content -->
</Layout>
```

### 3. API Error Responses

Always include:
- Appropriate status code
- JSON response with error details
- Content-Type header

```typescript
// Error helper
function errorResponse(message: string, status: number = 400) {
  return new Response(
    JSON.stringify({
      success: false,
      error: message
    }),
    {
      status,
      headers: {
        'Content-Type': 'application/json'
      }
    }
  )
}

// Usage
if (!id) {
  return errorResponse('ID required', 400)
}
```

## Cross-References

For advanced patterns, see:
- **astro-vue-architect** - Astro + Vue integration architecture, component decisions (.astro vs Vue), appEntrypoint configuration, client directive optimization, View Transitions with Vue islands, hybrid layouts, performance strategies
- **zod-schema-architect** - API request/response validation with Zod, error handling patterns, schema organization

## Further Reading

See supporting files:
- [api-patterns.md] - REST API best practices
