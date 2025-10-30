# Schema Organization Patterns

Complete guide to organizing Zod schemas in the codebase.

## Directory Structure Best Practices

**See SKILL.md Section 1 for complete directory structure.**

## Naming Conventions

✅ **Good Naming:**
- `FacebookPhotoPostSchema` - Platform + Type + Purpose
- `GenericPostSchema` - Clear scope
- `MediaSchema` - Reusable component

❌ **Bad Naming:**
- `PostSchema` - Too generic
- `DataSchema` - Unclear purpose
- `Schema1`, `Schema2` - No meaning

## File Organization

**Pattern:** Nested schemas first, main schemas second, type exports last

```typescript
// 1. Reusable nested schemas
export const NestedSchema = z.object({ ... })

// 2. Main schema using nested
export const MainSchema = z.object({
  nested: NestedSchema,
})

// 3. Type exports
export type Main = z.infer<typeof MainSchema>
export type Nested = z.infer<typeof NestedSchema>
```

## When to Create New Schema File

✅ Create new file when:
- New domain/resource type
- 3+ related schemas
- Reused across multiple files

❌ Keep in existing file when:
- Single schema
- Only used in one place
- Tightly coupled to existing schema
