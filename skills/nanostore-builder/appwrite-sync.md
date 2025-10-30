# Keeping Zod and Appwrite in Sync

## The Problem

Zod schemas and Appwrite collection schemas can drift apart.

## The Solution

### 1. Define Zod Schema First

```typescript
const UserSchema = z.object({
  name: z.string(),
  email: z.string().email(),
  age: z.number().int().optional()
})
```

### 2. Match in Appwrite Console

Create collection attributes:
- `name` - String, required
- `email` - String, required
- `age` - Integer, optional

### 3. Validate on Write

```typescript
const validated = UserSchema.parse(data)
await databases.createDocument(dbId, collId, ID.unique(), validated)
```

## Migration Checklist

When changing schema:
1. Update Zod schema in code
2. Update Appwrite collection attributes
3. Migrate existing documents if needed
4. Test with sample data
5. Deploy changes
