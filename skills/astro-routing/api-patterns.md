# API Route Patterns

## RESTful Conventions

```
GET    /api/posts.json         - List all posts
POST   /api/posts.json         - Create new post
GET    /api/posts/[id].json    - Get single post
PUT    /api/posts/[id].json    - Update post
DELETE /api/posts/[id].json    - Delete post
```

## Response Structure

### Success Response
```typescript
return new Response(
  JSON.stringify({
    success: true,
    data: result
  }),
  { status: 200 }
)
```

### Error Response
```typescript
return new Response(
  JSON.stringify({
    success: false,
    error: 'Error message',
    details: errorDetails  // Optional
  }),
  { status: 400 }
)
```

## Pagination

```typescript
export const GET: APIRoute = async ({ url }) => {
  const page = parseInt(url.searchParams.get('page') ?? '1')
  const limit = parseInt(url.searchParams.get('limit') ?? '10')
  const offset = (page - 1) * limit

  const items = await store.list([
    Query.limit(limit),
    Query.offset(offset)
  ])

  const total = await store.count()

  return new Response(
    JSON.stringify({
      data: items,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    }),
    { status: 200 }
  )
}
```

## Authentication Check

```typescript
import { account } from '@/lib/appwrite'

export const POST: APIRoute = async ({ request }) => {
  // Check authentication
  try {
    const user = await account.get()
  } catch {
    return new Response(
      JSON.stringify({ error: 'Unauthorized' }),
      { status: 401 }
    )
  }

  // Proceed with authenticated operation
}
```

## Validation Pattern

```typescript
import { z } from 'zod'

const schema = z.object({
  title: z.string().min(1),
  content: z.string()
})

export const POST: APIRoute = async ({ request }) => {
  try {
    const body = await request.json()
    const validated = schema.parse(body)

    // Use validated data
    const result = await createPost(validated)

    return new Response(
      JSON.stringify({ success: true, data: result }),
      { status: 201 }
    )
  } catch (error) {
    if (error instanceof z.ZodError) {
      return new Response(
        JSON.stringify({
          success: false,
          errors: error.errors
        }),
        { status: 400 }
      )
    }

    return new Response(
      JSON.stringify({ error: 'Internal error' }),
      { status: 500 }
    )
  }
}
```
