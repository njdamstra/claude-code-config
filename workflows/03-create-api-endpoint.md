---
name: Create API Endpoint with Validation
type: backend-development
status: production-ready
updated: 2025-10-16
---

# Workflow: Create API Endpoint with Validation

**Goal**: Create new API route with authentication, Zod validation, and Appwrite integration

**Duration**: 1-2 hours
**Complexity**: Medium
**Tech**: Astro API routes, Zod schemas, Appwrite, TypeScript

---

## Steps

### 1. Design Route Structure
Use `/api create src/pages/api/resources/[id].ts`

**Agent**: `astro-architect` designs and implements the API route structure.

**What to design:**
- HTTP method (GET, POST, PATCH, DELETE)
- URL parameters and query strings
- Request body format
- Response format
- Status codes
- Error cases

### 2. Implement Authentication
Use `/appwrite auth`

**Agent**: `appwrite-integration-specialist` implements authentication

**Patterns:**
- Cookie-based session
- JWT header authentication
- OAuth integration
- API key validation

**Implementation:**
```typescript
export const POST: APIRoute = async ({ request, cookies }) => {
  // Check authentication
  const session = cookies.get('session');
  if (!session) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
    });
  }

  // Validate user session
  const user = await validateSession(session.value);
  if (!user) {
    return new Response(JSON.stringify({ error: 'Invalid session' }), {
      status: 401,
    });
  }

  // Proceed with request...
};
```

### 3. Add Validation
Use `/fix-types src/pages/api/resources/[id].ts`

**Agent**: `typescript-validator` creates Zod schemas

**Implements:**
- Request body validation
- URL parameter validation
- Response typing
- Error handling

**Pattern:**
```typescript
import { z } from 'zod';

const RequestSchema = z.object({
  title: z.string().min(1, 'Title required'),
  content: z.string().min(10, 'Content too short'),
  tags: z.array(z.string()).optional(),
});

type Request = z.infer<typeof RequestSchema>;

// In route handler:
try {
  const body = await request.json();
  const validated = RequestSchema.parse(body);
  // Use validated data
} catch (error) {
  if (error instanceof z.ZodError) {
    return new Response(
      JSON.stringify({ error: 'Validation failed', details: error.errors }),
      { status: 422 }
    );
  }
}
```

### 4. Test Integration
Use `vue-testing-specialist` to write integration tests

**Agent**: `vue-testing-specialist` writes tests for API endpoints, request validation, response handling

**What to test:**
- Authenticated requests work
- Unauthenticated requests rejected
- Invalid data rejected with proper errors
- Valid data accepted and processed
- Response format correct
- Error cases handled

---

## Agent Orchestration

```
astro-architect → appwrite-integration-specialist → typescript-validator → vue-testing-specialist
```

---

## Complete Example

### API Route: `src/pages/api/posts/[id].ts`

```typescript
import type { APIRoute } from 'astro';
import { z } from 'zod';
import { getSSRClient } from '@/lib/appwrite';
import type { Post } from '@/types';

// Validation schemas
const UpdatePostSchema = z.object({
  title: z.string().min(1),
  content: z.string().min(10),
  tags: z.array(z.string()).optional(),
});

type UpdatePostRequest = z.infer<typeof UpdatePostSchema>;

// GET: Fetch single post
export const GET: APIRoute = async ({ params, cookies }) => {
  try {
    const { id } = params;
    if (!id) {
      return new Response(JSON.stringify({ error: 'Post ID required' }), {
        status: 400,
      });
    }

    // Initialize Appwrite client
    const client = getSSRClient(cookies, undefined, true, false);
    const database = client.database;

    // Fetch post
    const post = await database.getDocument('posts', id);

    return new Response(JSON.stringify(post), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('GET /posts/[id] error:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to fetch post' }),
      { status: 500 }
    );
  }
};

// PATCH: Update post
export const PATCH: APIRoute = async ({ request, params, cookies }) => {
  try {
    // Validate authentication
    const session = cookies.get('session');
    if (!session) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
      });
    }

    const { id } = params;
    if (!id) {
      return new Response(JSON.stringify({ error: 'Post ID required' }), {
        status: 400,
      });
    }

    // Validate request body
    const body = await request.json();
    const validated = UpdatePostSchema.parse(body);

    // Initialize Appwrite client
    const client = getSSRClient(cookies, undefined, true, false);
    const database = client.database;

    // Check ownership
    const post = await database.getDocument('posts', id);
    if (post.authorId !== session.value) {
      return new Response(JSON.stringify({ error: 'Forbidden' }), {
        status: 403,
      });
    }

    // Update post
    const updated = await database.updateDocument('posts', id, validated);

    return new Response(JSON.stringify(updated), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return new Response(
        JSON.stringify({
          error: 'Validation error',
          details: error.errors,
        }),
        { status: 422, headers: { 'Content-Type': 'application/json' } }
      );
    }

    console.error('PATCH /posts/[id] error:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to update post' }),
      { status: 500 }
    );
  }
};

// DELETE: Delete post
export const DELETE: APIRoute = async ({ params, cookies }) => {
  try {
    const session = cookies.get('session');
    if (!session) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
      });
    }

    const { id } = params;
    if (!id) {
      return new Response(JSON.stringify({ error: 'Post ID required' }), {
        status: 400,
      });
    }

    const client = getSSRClient(cookies, undefined, true, false);
    const database = client.database;

    const post = await database.getDocument('posts', id);
    if (post.authorId !== session.value) {
      return new Response(JSON.stringify({ error: 'Forbidden' }), {
        status: 403,
      });
    }

    await database.deleteDocument('posts', id);

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('DELETE /posts/[id] error:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to delete post' }),
      { status: 500 }
    );
  }
};
```

### Test File: `src/pages/api/posts/[id].test.ts`

```typescript
import { describe, it, expect } from 'vitest';
import type { APIRoute } from 'astro';

describe('POST /posts/[id]', () => {
  it('rejects unauthenticated requests', async () => {
    // Test implementation
  });

  it('validates request body', async () => {
    // Test validation
  });

  it('updates post successfully', async () => {
    // Test successful update
  });

  it('checks post ownership', async () => {
    // Test authorization
  });

  it('returns proper error responses', async () => {
    // Test error handling
  });
});
```

---

## HTTP Status Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| 200 | OK | Successful request |
| 201 | Created | Resource created |
| 400 | Bad Request | Missing/invalid parameters |
| 401 | Unauthorized | Authentication failed |
| 403 | Forbidden | Authorized but no permission |
| 404 | Not Found | Resource doesn't exist |
| 422 | Unprocessable Entity | Validation failed |
| 500 | Server Error | Unexpected error |

---

## Error Response Format

```typescript
// Validation error
{
  error: "Validation error",
  details: [
    {
      code: "too_small",
      minimum: 1,
      type: "string",
      path: ["title"],
      message: "String must contain at least 1 character(s)"
    }
  ]
}

// Auth error
{ error: "Unauthorized" }

// Success
{ id: "123", title: "New Post", ... }
```

---

## Validation Checklist

- [ ] Authentication implemented
- [ ] All inputs validated with Zod
- [ ] Proper HTTP status codes
- [ ] Error responses consistent
- [ ] Request/response typed
- [ ] Database operations error-handled
- [ ] Authorization checks (ownership, roles)
- [ ] Tests cover happy path and errors
- [ ] TypeScript passes all checks
- [ ] API documented (types exported)

---

## Related Workflows

- [Create Feature Page](./01-create-feature-page.md)
- [Test-Driven Development](./08-test-driven-development.md)
- [Debug Existing Feature](./07-debug-existing-feature.md)

---

**Time Estimate**: 1-2 hours | **Complexity**: Medium | **Status**: ✅ Production Ready
