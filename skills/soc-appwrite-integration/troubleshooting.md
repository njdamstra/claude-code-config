# Troubleshooting

## Common Errors

### Permission Errors

#### Error 401: Unauthorized

**Symptom**: `AppwriteException: User (role: guest) missing scope (account)`

**Causes**:
- Session expired
- Session not set in client
- User logged out in another tab

**Solutions**:
```typescript
// Check if session exists
const { checkAuthStatus, clearSession } = useAppwriteClient()

try {
  const user = await checkAuthStatus()
} catch (error) {
  if (error.code === 401) {
    // Session expired - clear and redirect
    clearSession()
    router.push('/login')
  }
}
```

#### Error 403: Forbidden

**Symptom**: `AppwriteException: User is missing write permission for this resource`

**Causes**:
- User doesn't have write permission on document
- Permission array missing required roles
- Team role not included in permissions

**Solutions**:
```typescript
// Debug: Check document permissions
const doc = await postContainerStore.get(postId)
console.log("Document permissions:", doc.$permissions)

// Verify user has permission
const userId = user.$id
const hasPermission = doc.$permissions.some(p =>
  p.includes(`write("user:${userId}")`) ||
  p.includes(`write("team:${teamId}/owner")`)
)

if (!hasPermission) {
  console.error("User lacks write permission")
}

// Solution: Use getClientSidePermissions()
import { getClientSidePermissions } from '@utils/appwriteUtils'

const permissions = getClientSidePermissions(
  ownerId,
  userRoles,
  oauthAccount
)
```

### Schema & Validation Errors

#### Zod Validation Failed

**Symptom**: `ZodError: Validation error`

**Causes**:
- Data doesn't match schema
- Missing required fields
- Wrong data types

**Solutions**:
```typescript
import { PostContainerSchema } from '@appwrite/schemas/postContainer'

try {
  const validated = PostContainerSchema.parse(data)
} catch (error) {
  if (error instanceof z.ZodError) {
    console.error("Validation errors:", error.errors)
    // errors: [
    //   { path: ['title'], message: 'Required' },
    //   { path: ['content'], message: 'String must contain at most 10000 character(s)' }
    // ]

    // Show user-friendly errors
    error.errors.forEach(err => {
      console.log(`${err.path.join('.')}: ${err.message}`)
    })
  }
}
```

#### Schema-Attribute Mismatch

**Symptom**: `AppwriteException: Attribute 'xyz' not found in collection`

**Causes**:
- Schema has field that doesn't exist in Appwrite collection
- YAML definition not synced with Appwrite
- Schema not regenerated after YAML change

**Solutions**:
```bash
# 1. Regenerate schemas from YAML
npm run generate:schemas

# 2. Verify Appwrite collection has the attribute
# Check in Appwrite console: Databases → Collection → Attributes

# 3. If attribute missing, add to YAML and regenerate
# collections/PostContainer.yaml
attributes:
  - key: newField
    type: string
    size: 255
    required: false

# Then regenerate
npm run generate:schemas
```

### Session Management Errors

#### Session Not Persisting After Page Reload

**Symptom**: User logged out after hard refresh

**Causes**:
- Dual cookie fallback not set
- LocalStorage cleared
- Session expired

**Solutions**:
```typescript
// Check if session exists in storage
const { refreshClientSession, checkAuthStatus } = useAppwriteClient()

onMounted(async () => {
  // 1. Try to restore session from storage
  refreshClientSession()

  // 2. Verify session is still valid
  const user = await checkAuthStatus()

  if (!user) {
    console.log("No valid session - redirect to login")
    router.push('/login')
  }
})
```

#### Session Out of Sync Between Tabs

**Symptom**: User logged in one tab, logged out in another

**Causes**:
- localStorage events not handled
- Session not synchronized across tabs

**Solutions**:
```typescript
// Listen for storage changes (logout in other tabs)
window.addEventListener('storage', (event) => {
  if (event.key === 'cookieFallback' && !event.newValue) {
    // Session cleared in another tab
    console.log("Logged out in another tab")
    clearLocalState()
    router.push('/login')
  }
})
```

### Database & Query Errors

#### Database Not Found

**Symptom**: `AppwriteException: Database 'xyz' not found`

**Causes**:
- Wrong database ID in BaseStore constructor
- Database doesn't exist in Appwrite
- Environment variable mismatch

**Solutions**:
```typescript
// 1. Check BaseStore uses correct database ID
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  constructor() {
    super(
      APPWRITE_COLL_POST_CONTAINER,
      PostContainerSchema,
      "currentPostContainer",
      "socialaize_data"  // ← Verify this matches actual database ID
    )
  }
}

// 2. Check database exists in Appwrite console

// 3. Check environment variables
console.log("Database IDs:", DATABASE_IDS)
```

#### Query Limit Exceeded

**Symptom**: `AppwriteException: Query limit exceeded`

**Causes**:
- Query.equal() with more than 100 values
- Query.limit() exceeds maximum (5000)

**Solutions**:
```typescript
import { listDocumentsInBatches } from '@utils/appwriteUtils'

// ✅ Good - handles 100+ IDs automatically
const posts = await listDocumentsInBatches(
  client,
  'socialaize_data',
  APPWRITE_COLL_POST_CONTAINER,
  '$id',
  postIds  // 250 IDs
)

// ❌ Bad - fails if > 100 IDs
const posts = await postContainerStore.list([
  Query.equal('$id', postIds)  // Fails if postIds.length > 100
])
```

### SSR & Hydration Errors

#### Hydration Mismatch

**Symptom**: `Warning: Hydration mismatch`

**Causes**:
- Client-only state used in template during SSR
- isAuthenticated checked before mounted
- Date/time rendered differently on server vs client

**Solutions**:
```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core'

const mounted = useMounted()
const { isAuthenticated } = useAppwriteClient()

// ✅ Good - prevents hydration mismatch
const showAuth = computed(() => mounted.value && isAuthenticated.value)
</script>

<template>
  <!-- ✅ Waits for client-side mount -->
  <div v-if="showAuth">
    Auth content
  </div>

  <!-- ❌ Bad - can cause mismatch -->
  <div v-if="isAuthenticated">
    Auth content
  </div>
</template>
```

#### useAppwriteClient in .astro File

**Symptom**: `Error: useAppwriteClient is not defined`

**Causes**:
- Trying to use client composable in server context
- .astro frontmatter runs on server

**Solutions**:
```astro
---
// ❌ Bad - client composable in server context
import { useAppwriteClient } from '@composables/useAppwriteClient'
const { databases } = useAppwriteClient()  // Fails!

// ✅ Good - use AppwriteServer
import { AppwriteServer } from '@server/appwrite/AppwriteServer'
const appwrite = AppwriteServer.withSessionToken(Astro.cookies)
const posts = await appwrite.listDocuments({...})
---
```

### File Upload Errors

#### File Too Large

**Symptom**: `AppwriteException: File size exceeds allowed limit`

**Causes**:
- File exceeds bucket maximum (30MB for global_bucket)
- File not chunked properly

**Solutions**:
```typescript
// Validate file size before upload
const maxSize = 30 * 1024 * 1024  // 30MB

if (file.size > maxSize) {
  throw new Error(`File too large: ${file.size} bytes. Max: ${maxSize} bytes`)
}

// Upload (automatically chunked in 5MB pieces)
await storage.createFile('global_bucket', ID.unique(), file, permissions)
```

#### Upload Failed After Retry

**Symptom**: `AppwriteException: Upload failed after 3 retries`

**Causes**:
- Network issues
- Server timeout
- Permissions issue

**Solutions**:
```typescript
try {
  const uploaded = await storage.createFile(
    'global_bucket',
    ID.unique(),
    file,
    permissions
  )
} catch (error) {
  if (error.message.includes('retry')) {
    console.error("Upload failed after 3 retries. Check network connection.")
    // Show retry button to user
  } else if (error.code === 403) {
    console.error("Permission denied. Check file permissions.")
  } else {
    console.error("Upload failed:", error)
  }
}
```

### Function Execution Errors

#### Function Not Found

**Symptom**: `AppwriteException: Function 'xyz' not found`

**Causes**:
- Wrong function ID
- Function not deployed
- Environment mismatch

**Solutions**:
```typescript
// Check available functions
const availableFunctions = [
  'WorkflowManager',
  'PostManager',
  'InstagramApi',
  // ... see services.md for full list
]

// Verify function ID is correct
await functions.createExecution(
  'WorkflowManager',  // ← Check spelling matches exactly
  JSON.stringify(data)
)
```

#### Function Timeout

**Symptom**: `AppwriteException: Execution timed out`

**Causes**:
- Function takes too long (>15s default timeout)
- Infinite loop in function
- External API call hanging

**Solutions**:
```typescript
// Use async execution for long-running functions
await functions.createExecution(
  'VideoHandler',
  JSON.stringify({ fileId, action: 'transcode' }),
  true,  // ← async - don't wait for response
  '/process',
  ExecutionMethod.POST
)

// Poll for results later or use webhook
```

### OAuth & Platform Errors

#### OAuth Account Not Found

**Symptom**: `AppwriteException: Document not found`

**Causes**:
- OAuth account ID incorrect
- Account deleted
- Database mismatch

**Solutions**:
```typescript
const oauthAccount = await oauthStore.get(accountId)

if (!oauthAccount) {
  console.error("OAuth account not found:", accountId)
  // Prompt user to reconnect account
  return
}

// Use account
const permissions = getClientSidePermissions(userId, roles, oauthAccount)
```

#### Platform API Rate Limit

**Symptom**: `Platform API returned 429 Too Many Requests`

**Causes**:
- Exceeded platform's rate limit (Instagram, Facebook, etc.)
- Too many requests in short time

**Solutions**:
```typescript
// Implement exponential backoff
async function publishWithRetry(data: any, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const result = await functions.createExecution(
        'InstagramApi',
        JSON.stringify(data),
        false
      )
      return result
    } catch (error) {
      if (error.message.includes('429') && i < maxRetries - 1) {
        const delay = Math.pow(2, i) * 1000  // Exponential backoff
        console.log(`Rate limited. Retrying in ${delay}ms...`)
        await new Promise(resolve => setTimeout(resolve, delay))
      } else {
        throw error
      }
    }
  }
}
```

## Debugging Tools

### Check Current Session

```typescript
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { account, isAuthenticated, sessionToken } = useAppwriteClient()

console.log("Is authenticated:", isAuthenticated.value)
console.log("Session token:", sessionToken.value)

try {
  const user = await account.get()
  console.log("Current user:", user)
} catch (error) {
  console.error("Not authenticated:", error)
}
```

### Check Document Permissions

```typescript
const doc = await postContainerStore.get(postId)

console.log("Document ID:", doc.$id)
console.log("Permissions:", doc.$permissions)

// Check if user has permission
const userId = user.$id
const canRead = doc.$permissions.some(p => p.includes(`read("user:${userId}")`))
const canWrite = doc.$permissions.some(p => p.includes(`write("user:${userId}")`))

console.log("Can read:", canRead)
console.log("Can write:", canWrite)
```

### Check Team Memberships

```typescript
const { teams } = useAppwriteClient()

const userTeams = await teams.list()
console.log("User's teams:", userTeams.teams)

for (const team of userTeams.teams) {
  const memberships = await teams.listMemberships(team.$id)
  const userMembership = memberships.memberships.find(m => m.userId === user.$id)
  console.log(`Team: ${team.name}, Roles:`, userMembership?.roles)
}
```

### Validate Schema

```typescript
import { PostContainerSchema } from '@appwrite/schemas/postContainer'

const testData = {
  title: "Test",
  content: "Content",
  userId: "user123",
  createdAt: new Date().toISOString()
}

try {
  const validated = PostContainerSchema.parse(testData)
  console.log("✅ Schema validation passed:", validated)
} catch (error) {
  console.error("❌ Schema validation failed:", error.errors)
}
```

## Getting Help

### Check Console Logs

```typescript
// Enable verbose logging
localStorage.setItem('debug', 'appwrite:*')

// Operations will now log detailed information
await postContainerStore.create({...})

// Disable verbose logging
localStorage.removeItem('debug')
```

### Verify Appwrite Console

1. **Check database exists**: Databases → [database-id]
2. **Check collection exists**: Collections → [collection-id]
3. **Check attributes match schema**: Attributes tab
4. **Check permissions**: Permissions tab
5. **Check indexes**: Indexes tab

### Common Checklist

- [ ] Schema regenerated after YAML changes?
- [ ] Collection ID matches environment variable?
- [ ] Database ID correct in BaseStore constructor?
- [ ] User has proper permissions (checked in Appwrite console)?
- [ ] Session is valid (not expired)?
- [ ] SSR guards in place (useMounted)?
- [ ] Input validated with Zod schema?
- [ ] Network connection stable?

## Summary

Common issues and solutions:
- **Permission errors** - Check session, verify permissions, use helper function
- **Schema errors** - Regenerate schemas, validate input, match attributes
- **Session issues** - Refresh from storage, handle cross-tab sync
- **Database errors** - Verify database ID, use batch operations
- **SSR errors** - Guard client code, use AppwriteServer in .astro
- **Upload errors** - Validate file size, handle retries
- **Function errors** - Verify function ID, use async for long tasks
- **OAuth errors** - Check account exists, handle rate limits

For additional help, see documentation files or check Appwrite console.
