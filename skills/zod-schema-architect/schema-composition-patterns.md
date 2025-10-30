# Schema Composition Patterns

Advanced Zod schema composition and reuse patterns.

## Composition Techniques

### 1. Base + Extend
**See SKILL.md Section 2 Pattern 1** for complete examples.

### 2. Discriminated Unions  
**See SKILL.md Section 2 Pattern 2** for polymorphic data patterns.

### 3. Pick, Omit, Partial
**See SKILL.md Section 2 Pattern 3** for schema variations.

### 4. Merge
**See SKILL.md Section 2 Pattern 4** for combining schemas.

## When to Use Each

| Pattern | Use Case |
|---------|----------|
| `.extend()` | Add fields to base schema |
| `discriminatedUnion()` | Polymorphic data with type field |
| `.pick()` | Select specific fields |
| `.omit()` | Exclude specific fields |
| `.partial()` | Make all fields optional |
| `.merge()` | Combine two schemas |

## DRY Principle

✅ Extract common patterns
✅ Reuse via composition
✅ Avoid copy-paste

**See SKILL.md for detailed examples.**
