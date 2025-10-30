# Zod Validation Patterns

## Basic Types

```typescript
z.string()              // Required string
z.number()              // Required number
z.boolean()             // Required boolean
z.date()                // Date object
z.undefined()           // Only undefined
z.null()                // Only null
```

## String Validation

```typescript
z.string().min(3)                    // Min length
z.string().max(100)                  // Max length
z.string().email()                   // Email format
z.string().url()                     // URL format
z.string().uuid()                    // UUID format
z.string().regex(/^[A-Z]+$/)         // Custom regex
```

## Number Validation

```typescript
z.number().int()                     // Integer only
z.number().positive()                // > 0
z.number().nonnegative()             // >= 0
z.number().min(0).max(100)           // Range
```

## Optional and Nullable

```typescript
z.string().optional()                // string | undefined
z.string().nullable()                // string | null
z.string().nullish()                 // string | null | undefined
z.string().default('default')        // Has default value
```

## Objects

```typescript
const UserSchema = z.object({
  name: z.string(),
  email: z.string().email(),
  age: z.number().optional()
})

type User = z.infer<typeof UserSchema>
```

## Arrays

```typescript
z.array(z.string())                  // String array
z.array(UserSchema)                  // User array
z.array(z.string()).min(1)           // At least 1 item
z.array(z.string()).max(10)          // At most 10 items
```

## Enums

```typescript
z.enum(['active', 'pending', 'inactive'])
z.nativeEnum(MyEnum)                 // TypeScript enum
```
