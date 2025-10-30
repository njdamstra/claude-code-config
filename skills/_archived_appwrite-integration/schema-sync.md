# Schema Synchronization

## The Process

### 1. Define Zod Schema (Code)

```typescript
const PostSchema = z.object({
  title: z.string().min(1).max(200),
  content: z.string(),
  published: z.boolean().default(false),
  authorId: z.string()
})
```

### 2. Create Matching Appwrite Collection

In Appwrite Console:
- Attribute: `title` - String (1-200 chars, required)
- Attribute: `content` - String (required)
- Attribute: `published` - Boolean (default: false)
- Attribute: `authorId` - String (required)

### 3. Validate Before Operations

```typescript
// Always parse before creating/updating
const validated = PostSchema.parse(data)
await databases.createDocument(dbId, collId, ID.unique(), validated)
```

## When Schemas Drift

If you get validation errors:
1. Compare Zod schema with Appwrite attributes
2. Identify mismatches (types, required fields, defaults)
3. Update either Zod or Appwrite to match
4. Test with sample data
