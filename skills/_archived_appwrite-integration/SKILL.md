---
name: Appwrite Integration
description: Integrate Appwrite SDK for databases, authentication, file storage, and serverless functions with proper error handling and permissions. Use when creating auth flows (OAuth, JWT), querying collections with Query patterns, uploading files with validation, subscribing to realtime updates, or calling server functions. Handles error codes (401=permission denied, 400=schema mismatch), schema validation, environment variables (PUBLIC_APPWRITE_API_KEY, DATABASE_ID, COLLECTION_ID). Use for "auth", "database query", "upload", "Appwrite", "permission", "realtime", "webhook". Prevents security issues with permission checks.
version: 2.0.0
tags: [appwrite, backend, databases, authentication, storage, file-upload, serverless-functions, permissions, error-handling, realtime, webhooks, environment-variables]
---

# Appwrite Integration

## Setup & Configuration

### Environment Variables
```typescript
// .env (at project root)
PUBLIC_APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
PUBLIC_APPWRITE_PROJECT_ID=your_project_id
PUBLIC_APPWRITE_DATABASE_ID=your_database_id

// Collection IDs
PUBLIC_APPWRITE_USERS_COLLECTION_ID=users
PUBLIC_APPWRITE_POSTS_COLLECTION_ID=posts
PUBLIC_APPWRITE_COMMENTS_COLLECTION_ID=comments

// Storage bucket IDs
PUBLIC_APPWRITE_AVATARS_BUCKET_ID=avatars
PUBLIC_APPWRITE_UPLOADS_BUCKET_ID=uploads
```

### Client Setup
```typescript
// src/lib/appwrite.ts
import { Client, Databases, Account, Storage, Functions } from 'appwrite'

const client = new Client()
  .setEndpoint(import.meta.env.PUBLIC_APPWRITE_ENDPOINT)
  .setProject(import.meta.env.PUBLIC_APPWRITE_PROJECT_ID)

export const databases = new Databases(client)
export const account = new Account(client)
export const storage = new Storage(client)
export const functions = new Functions(client)

export { client }
```

## Database Operations

### Create Document
```typescript
import { databases } from '@/lib/appwrite'
import { ID } from 'appwrite'

// Create with auto-generated ID
const document = await databases.createDocument(
  import.meta.env.PUBLIC_APPWRITE_DATABASE_ID,
  import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
  ID.unique(),  // Auto-generate ID
  {
    name: 'John Doe',
    email: 'john@example.com'
  }
)

// Create with specific ID
const document = await databases.createDocument(
  import.meta.env.PUBLIC_APPWRITE_DATABASE_ID,
  import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
  'user-123',  // Specific ID
  data
)
```

### Read Document
```typescript
const document = await databases.getDocument(
  import.meta.env.PUBLIC_APPWRITE_DATABASE_ID,
  import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
  'user-123'
)
```

### List Documents (with Queries)
```typescript
import { Query } from 'appwrite'

const documents = await databases.listDocuments(
  import.meta.env.PUBLIC_APPWRITE_DATABASE_ID,
  import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
  [
    Query.equal('role', 'admin'),
    Query.greaterThan('age', 18),
    Query.orderDesc('$createdAt'),
    Query.limit(10),
    Query.offset(0)
  ]
)
```

### Update Document
```typescript
const updated = await databases.updateDocument(
  import.meta.env.PUBLIC_APPWRITE_DATABASE_ID,
  import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
  'user-123',
  {
    name: 'Jane Doe'  // Only fields to update
  }
)
```

### Delete Document
```typescript
await databases.deleteDocument(
  import.meta.env.PUBLIC_APPWRITE_DATABASE_ID,
  import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
  'user-123'
)
```

## Authentication

### Email/Password
```typescript
import { account } from '@/lib/appwrite'
import { ID } from 'appwrite'

// Create account
const user = await account.create(
  ID.unique(),
  'user@example.com',
  'password123',
  'John Doe'
)

// Create session (login)
const session = await account.createEmailSession(
  'user@example.com',
  'password123'
)

// Get current session
const session = await account.getSession('current')

// Get current user
const user = await account.get()

// Logout (delete session)
await account.deleteSession('current')

// Logout all sessions
await account.deleteSessions()
```

### OAuth2
```typescript
// Redirect to OAuth provider
account.createOAuth2Session(
  'google',  // provider: google, github, facebook, etc.
  'http://localhost:4321/auth/callback',  // success URL
  'http://localhost:4321/auth/failure'    // failure URL
)
```

### Email Verification
```typescript
// Send verification email
await account.createVerification(
  'http://localhost:4321/verify'  // redirect URL
)

// Verify email
await account.updateVerification(
  userId,
  secret  // from verification email URL
)
```

## Storage (File Uploads)

### Upload File
```typescript
import { storage } from '@/lib/appwrite'
import { ID } from 'appwrite'

// Upload file
const file = await storage.createFile(
  import.meta.env.PUBLIC_APPWRITE_AVATARS_BUCKET_ID,
  ID.unique(),  // File ID
  fileObject    // File object from input
)

// Get file URL
const url = storage.getFileView(
  import.meta.env.PUBLIC_APPWRITE_AVATARS_BUCKET_ID,
  file.$id
)
```

### Complete Upload Example (Vue)
```vue
<script setup lang="ts">
import { ref } from 'vue'
import { storage } from '@/lib/appwrite'
import { ID } from 'appwrite'

const uploading = ref(false)
const fileUrl = ref<string | null>(null)
const error = ref<string | null>(null)

async function handleFileUpload(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]

  if (!file) return

  // Validate file
  const maxSize = 5 * 1024 * 1024 // 5MB
  if (file.size > maxSize) {
    error.value = 'File too large (max 5MB)'
    return
  }

  const allowedTypes = ['image/jpeg', 'image/png', 'image/webp']
  if (!allowedTypes.includes(file.type)) {
    error.value = 'Only JPEG, PNG, and WebP images allowed'
    return
  }

  uploading.value = true
  error.value = null

  try {
    // Upload file
    const uploaded = await storage.createFile(
      import.meta.env.PUBLIC_APPWRITE_AVATARS_BUCKET_ID,
      ID.unique(),
      file
    )

    // Get file URL
    fileUrl.value = storage.getFileView(
      import.meta.env.PUBLIC_APPWRITE_AVATARS_BUCKET_ID,
      uploaded.$id
    )

  } catch (e) {
    error.value = 'Upload failed'
    console.error(e)
  } finally {
    uploading.value = false
  }
}
</script>

<template>
  <div>
    <input
      type="file"
      accept="image/*"
      @change="handleFileUpload"
      :disabled="uploading"
      class="dark:bg-gray-800"
    />

    <div v-if="uploading">Uploading...</div>
    <div v-if="error" class="text-red-500">{{ error }}</div>
    <img v-if="fileUrl" :src="fileUrl" alt="Uploaded" class="mt-4 max-w-sm" />
  </div>
</template>
```

### Delete File
```typescript
await storage.deleteFile(
  import.meta.env.PUBLIC_APPWRITE_AVATARS_BUCKET_ID,
  fileId
)
```

## Realtime Subscriptions

```typescript
import { client } from '@/lib/appwrite'

// Subscribe to collection changes
const unsubscribe = client.subscribe(
  `databases.${import.meta.env.PUBLIC_APPWRITE_DATABASE_ID}.collections.${import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID}.documents`,
  (response) => {
    if (response.events.includes('databases.*.collections.*.documents.*.create')) {
      console.log('New document created:', response.payload)
    }

    if (response.events.includes('databases.*.collections.*.documents.*.update')) {
      console.log('Document updated:', response.payload)
    }

    if (response.events.includes('databases.*.collections.*.documents.*.delete')) {
      console.log('Document deleted:', response.payload)
    }
  }
)

// Unsubscribe when done
unsubscribe()
```

## Error Handling

### Common Errors

```typescript
import { AppwriteException } from 'appwrite'

try {
  const doc = await databases.getDocument(dbId, collId, docId)
} catch (error) {
  if (error instanceof AppwriteException) {
    switch (error.code) {
      case 401:
        // Unauthorized - user not logged in
        console.error('Please log in')
        break

      case 404:
        // Document not found
        console.error('Document not found')
        break

      case 400:
        // Bad request - validation error
        console.error('Invalid data:', error.message)
        break

      case 409:
        // Conflict - duplicate key
        console.error('Document already exists')
        break

      default:
        console.error('Appwrite error:', error.message)
    }
  } else {
    console.error('Unexpected error:', error)
  }
}
```

### Permission Errors

Most common permission error (401/403):

**Causes:**
1. User not authenticated
2. Collection permissions not set correctly
3. Document-level permissions not set

**Solutions:**
```typescript
// 1. Check if user is authenticated
try {
  const user = await account.get()
  console.log('User is logged in:', user)
} catch {
  console.log('User not logged in')
  // Redirect to login
}

// 2. Check collection permissions in Appwrite Console:
//    - Read: Any
//    - Create: Users
//    - Update: Users
//    - Delete: Users

// 3. Set document permissions on create:
await databases.createDocument(
  dbId,
  collId,
  ID.unique(),
  data,
  [
    Permission.read(Role.user(userId)),
    Permission.update(Role.user(userId)),
    Permission.delete(Role.user(userId))
  ]
)
```

## Schema Sync (Zod ↔ Appwrite)

### Keep Schemas in Sync

```typescript
// Step 1: Define Zod schema
const UserSchema = z.object({
  name: z.string(),
  email: z.string().email(),
  age: z.number().int().optional(),
  verified: z.boolean().default(false)
})

// Step 2: Appwrite collection attributes must match:
// In Appwrite Console:
// - name: String (required)
// - email: String (required)
// - age: Integer (optional)
// - verified: Boolean (default: false)

// Step 3: When creating/updating, validate with Zod first:
const validated = UserSchema.parse(data)
await databases.createDocument(dbId, collId, ID.unique(), validated)
```

### Migration Strategy

When changing schema:

1. **Update Zod schema** in code
2. **Update Appwrite** collection attributes (console or API)
3. **Migrate existing** documents if needed
4. **Test** with sample data

## Best Practices

### 1. Always Validate Before Saving
```typescript
// ✅ CORRECT
const validated = UserSchema.parse(data)
await databases.createDocument(dbId, collId, ID.unique(), validated)

// ❌ WRONG
await databases.createDocument(dbId, collId, ID.unique(), data)
```

### 2. Use Environment Variables
```typescript
// ✅ CORRECT
const dbId = import.meta.env.PUBLIC_APPWRITE_DATABASE_ID

// ❌ WRONG
const dbId = 'hardcoded-id'
```

### 3. Handle Errors Gracefully
```typescript
// ✅ CORRECT
try {
  const doc = await databases.getDocument(dbId, collId, docId)
  return doc
} catch (error) {
  if (error instanceof AppwriteException) {
    // Handle specific Appwrite errors
  }
  throw error
}

// ❌ WRONG
const doc = await databases.getDocument(dbId, collId, docId)
// No error handling
```

### 4. Check Auth State
```typescript
// ✅ CORRECT
async function protectedOperation() {
  try {
    await account.get()  // Verify auth
    // Proceed with operation
  } catch {
    // Redirect to login
  }
}

// ❌ WRONG
async function protectedOperation() {
  // Assume user is logged in
}
```

## Common Issues & Solutions

### Issue: Permission Denied (401)
**Cause:** User not authenticated or collection permissions wrong
**Solution:** Check auth state, verify collection permissions in console

### Issue: Schema Mismatch (400)
**Cause:** Zod schema doesn't match Appwrite attributes
**Solution:** Compare Zod schema with Appwrite collection attributes

### Issue: Document Not Found (404)
**Cause:** Document ID doesn't exist or was deleted
**Solution:** Verify document exists before accessing

### Issue: Realtime Not Working
**Cause:** Subscription string incorrect or permissions
**Solution:** Check subscription format and collection read permissions

## Further Reading

See supporting files:
- [auth-patterns.md] - Authentication flows
- [database-patterns.md] - Advanced queries
- [storage-patterns.md] - File upload patterns
- [schema-sync.md] - Keeping schemas aligned
