# Server-Side Integration

## Overview

The `AppwriteServer` class provides server-side Appwrite operations for:
- ✅ **Astro SSR pages** - data fetching during server rendering
- ✅ **API routes** - backend operations with session context
- ✅ **Multiple auth modes** - admin key, session token, JWT
- ✅ **Type-safe helpers** - generic document operations
- ✅ **Function execution** - serverless backend calls

**Location**: `src/server/appwrite/AppwriteServer.ts`

## Class Structure

```typescript
export class AppwriteServer {
  private client: Client
  private account: Account
  private databases: Databases
  private storage: Storage
  private users: Users
  private functions: Functions
  private teams: Teams

  constructor(
    sessionToken?: AstroCookies | string,
    jwt?: string,
    useSessionToken: boolean = false,
    isAdmin: boolean = false
  )
}
```

## Factory Methods

### Admin Mode (Full Access)

```typescript
const appwrite = AppwriteServer.withAdminKey()

// ✅ Can perform any operation
// ✅ Bypasses permission checks
// ⚠️ Use carefully - has full access
```

### Session Mode (User Context)

```typescript
const appwrite = AppwriteServer.withSessionToken(Astro.cookies)

// ✅ Operates with user's permissions
// ✅ Reads session from cookies automatically
// ✅ Respects permission rules
```

### JWT Mode (Token Auth)

```typescript
const jwt = await account.createJWT()
const appwrite = AppwriteServer.withSessionToken(undefined, jwt)

// ✅ Uses JWT for authentication
// ✅ Useful for API-to-API calls
```

## Helper Methods

### List Documents

```typescript
async listDocuments<T = Models.Document>({
  databaseId,
  collectionId,
  queries = []
}: {
  databaseId: string
  collectionId: string
  queries?: string[]
}): Promise<Models.DocumentList<T>>
```

**Usage**:
```typescript
const posts = await appwrite.listDocuments({
  databaseId: 'socialaize_data',
  collectionId: APPWRITE_COLL_POST_CONTAINER,
  queries: [Query.limit(10)]
})
```

### Get Document

```typescript
async getDocument<T = Models.Document>({
  databaseId,
  collectionId,
  documentId
}: {
  databaseId: string
  collectionId: string
  documentId: string
}): Promise<T>
```

**Usage**:
```typescript
const post = await appwrite.getDocument({
  databaseId: 'socialaize_data',
  collectionId: APPWRITE_COLL_POST_CONTAINER,
  documentId: postId
})
```

### Create Document

```typescript
async createDocument<T = Models.Document>({
  databaseId,
  collectionId,
  documentId,
  data,
  permissions
}: {
  databaseId: string
  collectionId: string
  documentId?: string
  data: Omit<T, keyof Models.Document>
  permissions?: string[]
}): Promise<T>
```

**Usage**:
```typescript
const newPost = await appwrite.createDocument({
  databaseId: 'socialaize_data',
  collectionId: APPWRITE_COLL_POST_CONTAINER,
  documentId: ID.unique(),
  data: {
    title: "My Post",
    content: "Post content",
    userId: user.$id
  },
  permissions: [
    Permission.read(Role.user(user.$id)),
    Permission.write(Role.user(user.$id))
  ]
})
```

### Update Document

```typescript
async updateDocument<T = Models.Document>({
  databaseId,
  collectionId,
  documentId,
  data,
  permissions
}: {
  databaseId: string
  collectionId: string
  documentId: string
  data: Partial<Omit<T, keyof Models.Document>>
  permissions?: string[]
}): Promise<T>
```

**Usage**:
```typescript
const updated = await appwrite.updateDocument({
  databaseId: 'socialaize_data',
  collectionId: APPWRITE_COLL_POST_CONTAINER,
  documentId: postId,
  data: {
    title: "Updated Title"
  }
})
```

### Delete Document

```typescript
async deleteDocument({
  databaseId,
  collectionId,
  documentId
}: {
  databaseId: string
  collectionId: string
  documentId: string
}): Promise<void>
```

**Usage**:
```typescript
await appwrite.deleteDocument({
  databaseId: 'socialaize_data',
  collectionId: APPWRITE_COLL_POST_CONTAINER,
  documentId: postId
})
```

### Execute Function

```typescript
async executeFunction(
  functionId: string,
  data?: any,
  async?: boolean,
  method?: ExecutionMethod,
  path?: string,
  headers?: Record<string, string>
): Promise<Models.Execution>
```

**Usage**:
```typescript
const result = await appwrite.executeFunction(
  'WorkflowManager',
  { workflowId: '123', action: 'start' },
  false,  // sync
  ExecutionMethod.POST,
  '/execute'
)

const responseData = JSON.parse(result.responseBody)
```

## Usage in Astro Pages

### Pattern 1: SSR Data Fetching

```astro
---
// src/pages/dashboard/index.astro
import { AppwriteServer } from '@server/appwrite/AppwriteServer'
import { Query } from 'appwrite'
import { APPWRITE_COLL_POST_CONTAINER } from 'astro:env/client'

const appwrite = AppwriteServer.withSessionToken(Astro.cookies)

// Fetch data during SSR
const posts = await appwrite.listDocuments({
  databaseId: 'socialaize_data',
  collectionId: APPWRITE_COLL_POST_CONTAINER,
  queries: [
    Query.orderDesc('$createdAt'),
    Query.limit(10)
  ]
})
---

<div>
  <h1>Your Posts</h1>
  {posts.documents.map(post => (
    <article>
      <h2>{post.title}</h2>
      <p>{post.content}</p>
    </article>
  ))}
</div>
```

### Pattern 2: Auth Guard

```astro
---
import { AppwriteServer } from '@server/appwrite/AppwriteServer'

const appwrite = AppwriteServer.withSessionToken(Astro.cookies)

// Check if user is authenticated
try {
  const user = await appwrite.account.get()
} catch (error) {
  // Not authenticated - redirect
  return Astro.redirect('/login')
}

// User is authenticated - continue rendering
const teams = await appwrite.teams.list()
---

<div>
  <h1>Welcome, {user.name}!</h1>
  <!-- ... -->
</div>
```

### Pattern 3: Admin Operations

```astro
---
import { AppwriteServer } from '@server/appwrite/AppwriteServer'

// Admin mode for backend operations
const appwrite = AppwriteServer.withAdminKey()

// Can access any data
const allUsers = await appwrite.users.list()
const systemConfig = await appwrite.getDocument({
  databaseId: 'system_content',
  collectionId: 'config',
  documentId: 'main'
})
---
```

## Usage in API Routes

### Pattern 1: GET Endpoint

```typescript
// src/pages/api/posts.json.ts
import type { APIRoute } from 'astro'
import { AppwriteServer } from '@server/appwrite/AppwriteServer'
import { Query } from 'appwrite'

export const GET: APIRoute = async ({ cookies, request }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    const url = new URL(request.url)
    const limit = parseInt(url.searchParams.get('limit') || '25')

    const posts = await appwrite.listDocuments({
      databaseId: 'socialaize_data',
      collectionId: APPWRITE_COLL_POST_CONTAINER,
      queries: [Query.limit(limit)]
    })

    return new Response(JSON.stringify(posts), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}
```

### Pattern 2: POST Endpoint

```typescript
// src/pages/api/posts/create.json.ts
import type { APIRoute } from 'astro'
import { AppwriteServer } from '@server/appwrite/AppwriteServer'
import { ID, Permission, Role } from 'appwrite'
import { z } from 'zod'

const CreatePostSchema = z.object({
  title: z.string().min(1).max(255),
  content: z.string().max(10000),
  status: z.enum(['draft', 'published'])
})

export const POST: APIRoute = async ({ cookies, request }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    // Get authenticated user
    const user = await appwrite.account.get()

    // Parse and validate request body
    const body = await request.json()
    const validated = CreatePostSchema.parse(body)

    // Create document
    const newPost = await appwrite.createDocument({
      databaseId: 'socialaize_data',
      collectionId: APPWRITE_COLL_POST_CONTAINER,
      documentId: ID.unique(),
      data: {
        ...validated,
        userId: user.$id,
        createdAt: new Date().toISOString()
      },
      permissions: [
        Permission.read(Role.user(user.$id)),
        Permission.write(Role.user(user.$id))
      ]
    })

    return new Response(JSON.stringify(newPost), {
      status: 201,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return new Response(JSON.stringify({ error: 'Validation failed', details: error.errors }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}
```

### Pattern 3: Function Execution

```typescript
// src/pages/api/workflow/execute.json.ts
import type { APIRoute } from 'astro'
import { AppwriteServer } from '@server/appwrite/AppwriteServer'
import { ExecutionMethod } from 'appwrite'

export const POST: APIRoute = async ({ cookies, request }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    const { workflowId, data } = await request.json()

    // Execute serverless function
    const execution = await appwrite.executeFunction(
      'WorkflowManager',
      { workflowId, data },
      false,  // sync - wait for response
      ExecutionMethod.POST,
      '/execute'
    )

    const result = JSON.parse(execution.responseBody)

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}
```

## Common Patterns

### Pattern 1: Paginated API

```typescript
export const GET: APIRoute = async ({ cookies, request }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  const url = new URL(request.url)
  const page = parseInt(url.searchParams.get('page') || '0')
  const limit = 25
  const offset = page * limit

  const result = await appwrite.listDocuments({
    databaseId: 'socialaize_data',
    collectionId: APPWRITE_COLL_POST_CONTAINER,
    queries: [
      Query.limit(limit),
      Query.offset(offset),
      Query.orderDesc('$createdAt')
    ]
  })

  return new Response(JSON.stringify({
    data: result.documents,
    total: result.total,
    page,
    hasMore: (offset + limit) < result.total
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' }
  })
}
```

### Pattern 2: Admin-Only Endpoint

```typescript
export const POST: APIRoute = async ({ cookies }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    const user = await appwrite.account.get()

    // Check if user is admin (example: check prefs or team role)
    if (!user.prefs?.isAdmin) {
      return new Response(JSON.stringify({ error: 'Forbidden' }), {
        status: 403,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    // Admin-only operation
    const appwriteAdmin = AppwriteServer.withAdminKey()
    // ... perform admin operations
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 401,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}
```

### Pattern 3: File Upload Proxy

```typescript
export const POST: APIRoute = async ({ cookies, request }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    const user = await appwrite.account.get()
    const formData = await request.formData()
    const file = formData.get('file') as File

    const uploaded = await appwrite.storage.createFile(
      'global_bucket',
      ID.unique(),
      file,
      [
        Permission.read(Role.user(user.$id)),
        Permission.write(Role.user(user.$id))
      ]
    )

    return new Response(JSON.stringify({
      fileId: uploaded.$id,
      url: appwrite.storage.getFileView('global_bucket', uploaded.$id)
    }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}
```

## Error Handling

### Common Errors

| Error Code | Meaning | Solution |
|------------|---------|----------|
| 401 | Unauthorized | Session expired or invalid |
| 403 | Forbidden | User lacks permission |
| 404 | Not Found | Document/collection doesn't exist |
| 500 | Server Error | Appwrite service issue |

### Error Handling Pattern

```typescript
export const GET: APIRoute = async ({ cookies }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    const user = await appwrite.account.get()
    // ... operations
  } catch (error) {
    // Handle specific Appwrite errors
    if (error.code === 401) {
      return new Response(JSON.stringify({ error: 'Session expired' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    if (error.code === 404) {
      return new Response(JSON.stringify({ error: 'Resource not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    // Generic error
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}
```

## Best Practices

### ✅ Always Use Session Token in User-Facing Routes

```typescript
// ✅ Good - respects user permissions
const appwrite = AppwriteServer.withSessionToken(Astro.cookies)

// ❌ Bad - bypasses permissions (use only for admin operations)
const appwrite = AppwriteServer.withAdminKey()
```

### ✅ Validate Input with Zod

```typescript
const Schema = z.object({
  title: z.string().min(1),
  content: z.string()
})

const validated = Schema.parse(await request.json())
```

### ✅ Check Authentication Before Operations

```typescript
try {
  const user = await appwrite.account.get()
} catch (error) {
  return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 })
}
```

### ✅ Return Consistent Error Responses

```typescript
return new Response(JSON.stringify({ error: message }), {
  status: statusCode,
  headers: { 'Content-Type': 'application/json' }
})
```

## Summary

`AppwriteServer` provides:
- **Server-side wrapper** for Appwrite operations
- **Multiple auth modes** - admin, session, JWT
- **Type-safe helpers** for CRUD operations
- **SSR support** for Astro pages
- **API route integration** for backend endpoints
- **Function execution** for serverless operations

Next: See [permissions.md](./permissions.md) for team-based permission patterns.
