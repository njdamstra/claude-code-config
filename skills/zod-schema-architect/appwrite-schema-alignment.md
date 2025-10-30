# Appwrite Schema Alignment

Guide to aligning Zod schemas with Appwrite collection attributes.

## Critical Alignment Rules

**See SKILL.md Section 5** for complete alignment patterns.

## Appwrite System Fields

Always include these in document schemas:

```typescript
$id: z.string().optional()
$createdAt: z.string().datetime().optional()
$updatedAt: z.string().datetime().optional()
```

## Attribute Type Mapping

| Appwrite | Zod |
|----------|-----|
| string | `z.string()` |
| integer | `z.number().int()` |
| float | `z.number()` |
| boolean | `z.boolean()` |
| datetime | `z.string().datetime()` |
| email | `z.string().email()` |
| url | `z.string().url()` |
| enum | `z.enum([...])` |
| relationship | `z.string()` (document ID) |

## BaseStore Integration

```typescript
export class Store extends BaseStore<typeof Schema> {
  constructor() {
    super(collectionId, Schema, 'key', databaseId)
  }
}
```

Schema must match collection attributes exactly!

## Validation Flow

1. Frontend validates with schema
2. API validates with schema
3. BaseStore validates before Appwrite
4. Appwrite validates attributes

**All layers must align!**
