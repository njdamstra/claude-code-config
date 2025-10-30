# Appwrite TypeScript Patterns

## Document Types

```typescript
import { Models } from 'appwrite'

// Use Appwrite types
const doc: Models.Document = await databases.getDocument(...)

// Extend with your schema
type UserDocument = Models.Document & User
```

## Parse Appwrite Responses

```typescript
// ❌ WRONG - No validation
const user = await databases.getDocument(dbId, collId, id)

// ✅ RIGHT - Validate with Zod
const doc = await databases.getDocument(dbId, collId, id)
const user = UserSchema.parse(doc)
```

## List Response Types

```typescript
const response: Models.DocumentList<Models.Document> =
  await databases.listDocuments(dbId, collId)

// Parse each document
const users = response.documents.map(doc => UserSchema.parse(doc))
```

## Error Types

```typescript
import { AppwriteException } from 'appwrite'

try {
  await databases.getDocument(dbId, collId, id)
} catch (error) {
  if (error instanceof AppwriteException) {
    console.log('Code:', error.code)
    console.log('Message:', error.message)
  }
}
```
