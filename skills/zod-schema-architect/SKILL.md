---
name: Zod Schema Architect
description: Design and implement Zod validation schemas with proper organization, composition patterns, and type safety. Use when creating API schemas, database validation, form validation, or runtime type checking. Covers schema organization (base schemas, composition, discriminated unions), validation error handling, Appwrite schema alignment, type inference patterns, and reusable schema composition. Prevents duplication through schema composition (extend, pick, omit, merge) and provides standardized validation patterns across frontend, backend, and Appwrite functions.
version: 1.0.0
tags: [zod, validation, schemas, typescript, type-safety, runtime-validation, composition, error-handling, appwrite-alignment, api-validation]
---

# Zod Schema Architect

## When to Use This Skill

✅ **Use this skill when:**
- Creating new validation schemas (API, database, forms)
- Organizing schemas in `src/schemas/` directory
- Composing reusable schema patterns
- Aligning Zod schemas with Appwrite collection attributes
- Handling validation errors consistently
- Type inference from schemas (`z.infer<>`)
- Creating discriminated unions for polymorphic data
- Validating API requests/responses
- Form validation integration

❌ **Don't use this skill for:**
- Writing Vue components → use **vue-component-builder**
- Creating stores → use **nanostore-builder**
- API route implementation → use **astro-routing**
- Appwrite database operations → use **soc-appwrite-integration**

---

## Quick Decision Tree: Schema Organization

```
What are you validating?

├─ Appwrite Collection Document?
│  └─ ✅ Create in src/schemas/ + align with collection attributes
│     └─ Match $id, $createdAt, $updatedAt patterns
│
├─ API Request/Response?
│  └─ ✅ Create in src/schemas/[domain]/
│     └─ Use discriminated unions for polymorphic data
│
├─ Social Platform API?
│  └─ ✅ Create in src/schemas/providers/[platform]/
│     └─ Organize by resource type (posts, media, etc.)
│
├─ Form Validation?
│  └─ ✅ Reuse existing schemas with .partial() or .pick()
│
└─ Shared Validation Logic?
   └─ ✅ Create base schema, extend in specific schemas
```

---

## Core Patterns

### 1. Schema Organization

#### Directory Structure

```
src/schemas/
├── posts/              # Post-related schemas
│   ├── genericPost.ts  # Platform-agnostic post schema
│   └── posts.ts        # Platform-specific schemas
├── providers/          # Social platform schemas
│   ├── facebook/
│   │   ├── facebookApiParams.ts
│   │   └── posts.ts
│   ├── instagram/
│   ├── linkedin/
│   └── pinterest/
├── workflows/          # Workflow schemas
├── analytics/          # Analytics schemas
├── emails/             # Email schemas
└── billing/            # Billing schemas
```

#### Naming Conventions

```typescript
// ✅ Good: Descriptive, domain-specific
export const FacebookPhotoPostSchema = z.object({ ... })
export const GenericPostSchema = z.object({ ... })
export const MediaSchema = z.object({ ... })

// ❌ Bad: Generic, unclear
export const PostSchema = z.object({ ... })  // Which platform?
export const DataSchema = z.object({ ... })   // What data?
```

#### File Organization Pattern

```typescript
// src/schemas/posts/genericPost.ts

import { z } from 'zod'

// 1. Nested/Reusable Schemas First
export const MediaSchema = z.object({
  id: z.string().optional(),
  bucketId: z.string().optional(),
  url: z.string().url().optional(),
  type: z.enum(['image', 'video', 'file']),
  size: z.number().optional(),
  altText: z.string().optional(),
})

export const PollSchema = z.object({
  options: z.array(z.string()).min(2, 'At least two options required'),
  duration: z.number().min(1),
  multiple: z.boolean().optional().default(false),
})

// 2. Main Schema Using Nested Schemas
export const GenericPostSchema = z.object({
  id: z.string().optional(),
  platform: z.string(),
  postType: z.enum(['text', 'caption-image', 'caption-video', 'carousel', 'story']),
  title: z.string().optional(),
  text: z.string().optional(),
  media: z.array(MediaSchema).optional(),
  poll: PollSchema.optional(),
  platformData: z.record(z.any()).optional(),
})

// 3. Type Exports Last
export type GenericPost = z.infer<typeof GenericPostSchema>
export type Media = z.infer<typeof MediaSchema>
export type Poll = z.infer<typeof PollSchema>
```

**See also:** [schema-organization-patterns.md] for complete organization guide

---

### 2. Schema Composition Patterns

#### Pattern 1: Base Schema + Extension

**Use when:** Multiple schemas share common fields (Facebook posts, Instagram posts)

```typescript
// Base schema with common fields
const SocialMediaBasePostSchema = z.object({
  message: z.string().optional(),
  published: z.boolean().default(true),
  scheduled_publish_time: z.string().or(z.number()).optional(),
  targeting: z.object({
    geo_locations: z.object({
      countries: z.array(z.string()).optional(),
      cities: z.array(z.object({ key: z.string(), name: z.string() })).optional(),
    }),
  }).optional(),
})

// Extend for specific post types
export const FacebookTextPostSchema = SocialMediaBasePostSchema.extend({
  link: z.string().optional().describe('The link to post'),
})

export const FacebookPhotoPostSchema = SocialMediaBasePostSchema.extend({
  url: z.string().describe('Photo URL'),
  caption: z.string().optional(),
})

export const FacebookVideoPostSchema = SocialMediaBasePostSchema.extend({
  file_url: z.string().describe('Video URL'),
  title: z.string().optional(),
  description: z.string().optional(),
})
```

**Why this works:**
- ✅ DRY principle (Don't Repeat Yourself)
- ✅ Consistent validation across variants
- ✅ Easy to update common fields
- ✅ Clear inheritance hierarchy

#### Pattern 2: Discriminated Unions

**Use when:** Polymorphic data with type field (posts, media, events)

```typescript
// Individual schemas
const TextPostSchema = z.object({
  type: z.literal('text'),
  data: FacebookTextPostSchema,
})

const PhotoPostSchema = z.object({
  type: z.literal('photo'),
  data: FacebookPhotoPostSchema,
})

const VideoPostSchema = z.object({
  type: z.literal('video'),
  data: FacebookVideoPostSchema,
})

// Discriminated union on 'type' field
export const FacebookPostObjectSchema = z.discriminatedUnion('type', [
  TextPostSchema,
  PhotoPostSchema,
  VideoPostSchema,
])

// TypeScript now narrows types automatically
function processPost(post: z.infer<typeof FacebookPostObjectSchema>) {
  if (post.type === 'photo') {
    // TypeScript knows: post.data is FacebookPhotoPost
    console.log(post.data.url)
  }
}
```

**Benefits:**
- ✅ Type-safe runtime type checking
- ✅ Automatic TypeScript narrowing
- ✅ Better error messages (knows which variant failed)

#### Pattern 3: Pick, Omit, Partial

**Use when:** Creating variations of existing schemas

```typescript
// Full schema
const UserSchema = z.object({
  $id: z.string(),
  $createdAt: z.string().datetime(),
  $updatedAt: z.string().datetime(),
  name: z.string().min(1),
  email: z.string().email(),
  avatar: z.string().url().optional(),
  role: z.enum(['user', 'admin']),
})

// API create request (omit Appwrite fields)
export const CreateUserSchema = UserSchema.omit({
  $id: true,
  $createdAt: true,
  $updatedAt: true,
})

// API update request (partial + omit IDs)
export const UpdateUserSchema = UserSchema.omit({
  $id: true,
  $createdAt: true,
  $updatedAt: true,
}).partial()

// Public profile (pick only safe fields)
export const PublicUserSchema = UserSchema.pick({
  $id: true,
  name: true,
  avatar: true,
})

// Form validation (pick + partial)
export const UserProfileFormSchema = UserSchema.pick({
  name: true,
  avatar: true,
}).partial()
```

#### Pattern 4: Merge Schemas

**Use when:** Combining multiple schemas into one

```typescript
const BaseMetadataSchema = z.object({
  createdBy: z.string(),
  updatedBy: z.string(),
})

const TimestampSchema = z.object({
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
})

// Merge both
export const AuditSchema = BaseMetadataSchema.merge(TimestampSchema)

// Or merge with main schema
export const AuditedPostSchema = GenericPostSchema.merge(AuditSchema)
```

**See also:** [schema-composition-patterns.md] for advanced composition

---

### 3. Type Inference Patterns

#### Basic Type Inference

```typescript
// Schema
export const UserSchema = z.object({
  name: z.string(),
  email: z.string().email(),
  age: z.number().optional(),
})

// Infer TypeScript type
export type User = z.infer<typeof UserSchema>

// Now TypeScript knows:
const user: User = {
  name: 'John',
  email: 'john@example.com',
  // age is optional
}
```

#### Input vs Output Types

```typescript
const TransformSchema = z.object({
  count: z.string().transform(Number), // Input: string, Output: number
  active: z.boolean().default(true),   // Input: boolean | undefined, Output: boolean
})

// Input type (before validation/transform)
type Input = z.input<typeof TransformSchema>
// { count: string, active?: boolean }

// Output type (after validation/transform)
type Output = z.output<typeof TransformSchema>
// { count: number, active: boolean }

// Infer gives output type by default
type Same = z.infer<typeof TransformSchema>
// { count: number, active: boolean }
```

#### Extracting Types from Discriminated Unions

```typescript
const PostUnion = z.discriminatedUnion('type', [
  z.object({ type: z.literal('text'), data: TextSchema }),
  z.object({ type: z.literal('photo'), data: PhotoSchema }),
])

// Extract all possible types
type Post = z.infer<typeof PostUnion>

// Extract specific variant
type TextPost = Extract<Post, { type: 'text' }>
type PhotoPost = Extract<Post, { type: 'photo' }>
```

---

### 4. Validation Error Handling

#### Pattern 1: Try-Catch with ZodError

```typescript
import { z } from 'zod'

function validateUser(data: unknown) {
  try {
    const user = UserSchema.parse(data)
    return { success: true, data: user }
  } catch (error) {
    if (error instanceof z.ZodError) {
      // Structured error information
      return {
        success: false,
        errors: error.errors.map(err => ({
          path: err.path.join('.'),
          message: err.message,
          code: err.code,
        }))
      }
    }
    throw error // Re-throw unexpected errors
  }
}
```

#### Pattern 2: SafeParse (No Exceptions)

```typescript
function validateUserSafe(data: unknown) {
  const result = UserSchema.safeParse(data)

  if (result.success) {
    // result.data is typed as User
    return { success: true, data: result.data }
  } else {
    // result.error is ZodError
    return {
      success: false,
      errors: result.error.errors
    }
  }
}
```

#### Pattern 3: API Route Error Response

```typescript
// src/pages/api/users.json.ts
import type { APIRoute } from 'astro'
import { z } from 'zod'

export const POST: APIRoute = async ({ request }) => {
  try {
    const body = await request.json()
    const validated = CreateUserSchema.parse(body)

    // Create user...
    return new Response(JSON.stringify({ success: true }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' }
    })

  } catch (error) {
    // Zod validation error
    if (error instanceof z.ZodError) {
      return new Response(
        JSON.stringify({
          success: false,
          errors: error.errors.map(err => ({
            field: err.path.join('.'),
            message: err.message,
          }))
        }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        }
      )
    }

    // Other errors
    return new Response(
      JSON.stringify({ success: false, message: 'Internal error' }),
      { status: 500 }
    )
  }
}
```

#### Pattern 4: User-Friendly Error Messages

```typescript
const UserSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Please enter a valid email address'),
  age: z.number()
    .int('Age must be a whole number')
    .min(18, 'You must be at least 18 years old')
    .max(120, 'Please enter a valid age'),
  password: z.string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
    .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
    .regex(/[0-9]/, 'Password must contain at least one number'),
})
```

**See also:** [validation-error-handling.md] for complete error patterns

---

### 5. Appwrite Schema Alignment

#### Critical Pattern: Match Appwrite Attributes Exactly

```typescript
// Appwrite Collection Attributes:
// - $id (string)
// - $createdAt (datetime)
// - $updatedAt (datetime)
// - name (string, required)
// - email (string, required)
// - verified (boolean, default: false)

// Matching Zod Schema:
export const UserSchema = z.object({
  $id: z.string().optional(),           // Appwrite generates
  $createdAt: z.string().datetime().optional(), // Appwrite generates
  $updatedAt: z.string().datetime().optional(), // Appwrite generates
  name: z.string().min(1),              // Required
  email: z.string().email(),            // Required, validated
  verified: z.boolean().default(false), // Default matches Appwrite
})
```

#### Enum Alignment

```typescript
// Appwrite enum attribute: role (enum: user, admin, moderator)

// Zod schema (must match exactly)
const UserSchema = z.object({
  role: z.enum(['user', 'admin', 'moderator']).default('user'),
})

// ❌ Bad: Mismatch will cause runtime errors
role: z.enum(['member', 'admin']) // Different values!
```

#### Relationship Fields

```typescript
// Appwrite: userId (relationship to Users collection)

const PostSchema = z.object({
  $id: z.string().optional(),
  userId: z.string(), // Foreign key to Users collection
  title: z.string(),
  content: z.string(),
})
```

#### BaseStore Integration

```typescript
// src/stores/userStore.ts
import { BaseStore } from './baseStore'
import { UserSchema } from '@/schemas/users'

export class UserStore extends BaseStore<typeof UserSchema> {
  constructor() {
    super(
      import.meta.env.PUBLIC_APPWRITE_USERS_COLLECTION_ID,
      UserSchema, // Schema aligns with collection
      'user',
      import.meta.env.PUBLIC_APPWRITE_DATABASE_ID
    )
  }
}
```

**See also:** [appwrite-schema-alignment.md] for complete alignment guide

---

### 6. Common Schema Patterns

#### Email Validation

```typescript
const EmailSchema = z.string().email().toLowerCase()

// With custom error message
const EmailSchemaCustom = z.string()
  .email('Please enter a valid email address')
  .toLowerCase()
  .transform(email => email.trim())
```

#### URL Validation

```typescript
const URLSchema = z.string().url()

// Optional URL (empty string allowed)
const OptionalURLSchema = z.string().url().or(z.literal(''))

// URL with specific protocol
const HTTPSURLSchema = z.string()
  .url()
  .refine(url => url.startsWith('https://'), {
    message: 'URL must use HTTPS'
  })
```

#### Date/DateTime Validation

```typescript
// ISO datetime string
const DateTimeSchema = z.string().datetime()

// Date object
const DateObjectSchema = z.date()

// Transform string to Date
const StringToDateSchema = z.string().transform(str => new Date(str))

// Unix timestamp (number)
const TimestampSchema = z.number().int().positive()
```

#### Enum with Descriptions

```typescript
const PostStatusSchema = z.enum(['draft', 'scheduled', 'published', 'failed'])
  .describe('Current status of the post')

// With default
const PostStatusWithDefaultSchema = z.enum(['draft', 'scheduled', 'published', 'failed'])
  .default('draft')
```

#### Array Validation

```typescript
// Array of strings
const TagsSchema = z.array(z.string()).min(1, 'At least one tag required')

// Array of objects
const MediaArraySchema = z.array(MediaSchema)
  .min(1, 'At least one media item required')
  .max(10, 'Maximum 10 media items allowed')

// Non-empty array
const NonEmptyArraySchema = z.array(z.string()).nonempty('Array cannot be empty')
```

#### Record/Dictionary Validation

```typescript
// Record with any values
const PlatformDataSchema = z.record(z.any())

// Record with specific value type
const MetricsSchema = z.record(z.number())

// Record with specific keys and values
const ConfigSchema = z.record(
  z.enum(['apiKey', 'apiSecret', 'accessToken']),
  z.string()
)
```

#### Optional vs Nullable vs Nullish

```typescript
const Schema = z.object({
  // Can be undefined (not provided)
  optional: z.string().optional(),

  // Can be null
  nullable: z.string().nullable(),

  // Can be null OR undefined
  nullish: z.string().nullish(),

  // Has default value if undefined
  withDefault: z.string().default('default value'),
})

// Types inferred:
// optional?: string
// nullable: string | null
// nullish?: string | null
// withDefault: string (never undefined)
```

---

### 7. Advanced Patterns

#### Conditional Validation (Superrefine)

```typescript
const PostSchema = z.object({
  postType: z.enum(['text', 'photo', 'video']),
  text: z.string().optional(),
  mediaUrl: z.string().url().optional(),
}).superrefine((data, ctx) => {
  // If photo/video, mediaUrl is required
  if ((data.postType === 'photo' || data.postType === 'video') && !data.mediaUrl) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: `Media URL is required for ${data.postType} posts`,
      path: ['mediaUrl'],
    })
  }

  // If text post, text is required
  if (data.postType === 'text' && !data.text) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Text is required for text posts',
      path: ['text'],
    })
  }
})
```

#### Transform Data

```typescript
// String to number
const CountSchema = z.string().transform(Number)

// Trim whitespace
const TrimmedStringSchema = z.string().transform(str => str.trim())

// Parse JSON string
const JSONStringSchema = z.string().transform(str => JSON.parse(str))

// Normalize email
const NormalizedEmailSchema = z.string()
  .email()
  .toLowerCase()
  .transform(email => email.trim())
```

#### Recursive Schemas

```typescript
// Recursive type for nested comments
type Comment = {
  id: string
  text: string
  replies?: Comment[]
}

const CommentSchema: z.ZodType<Comment> = z.lazy(() => z.object({
  id: z.string(),
  text: z.string(),
  replies: z.array(CommentSchema).optional(),
}))
```

#### Schema Preprocessing

```typescript
// Convert empty string to undefined
const OptionalStringSchema = z.preprocess(
  (val) => val === '' ? undefined : val,
  z.string().optional()
)

// Convert string to number
const NumberFromStringSchema = z.preprocess(
  (val) => typeof val === 'string' ? Number(val) : val,
  z.number()
)
```

---

## Schema Checklist

Before finalizing a schema:

- [ ] Named descriptively (domain-specific)
- [ ] Organized in proper `src/schemas/[domain]/` directory
- [ ] Base schemas extracted for reusable patterns
- [ ] Discriminated unions used for polymorphic data
- [ ] Type inference exports (`export type X = z.infer<typeof XSchema>`)
- [ ] Appwrite schema alignment verified (if applicable)
- [ ] Custom error messages for user-facing validation
- [ ] Optional/nullable/default patterns used correctly
- [ ] Validation logic tested with sample data
- [ ] No duplication (reused via composition)

---

## Cross-References

For related patterns, see:

- **nanostore-builder** - BaseStore pattern, Zod schema integration with Appwrite stores
- **soc-appwrite-integration** - Appwrite collection schemas, BaseStore extension
- **astro-routing** - API route validation with Zod schemas
- **vue-component-builder** - Form validation integration
- **typescript-fixer** - Type inference, fixing Zod-related TypeScript errors

---

## Common Patterns Summary

| Use Case | Pattern | Example |
|----------|---------|---------|
| Appwrite document | Base schema + Appwrite fields | `UserSchema` with `$id`, `$createdAt` |
| API request | Omit Appwrite fields | `CreateUserSchema = UserSchema.omit(...)` |
| API update | Partial + Omit IDs | `UpdateUserSchema = UserSchema.omit(...).partial()` |
| Form validation | Pick + Partial | `FormSchema = UserSchema.pick(...).partial()` |
| Polymorphic data | Discriminated union | `PostSchema = z.discriminatedUnion('type', [...])` |
| Shared fields | Base + Extend | `BaseSchema.extend({ ... })` |
| Optional field | `.optional()` | `z.string().optional()` |
| Default value | `.default()` | `z.boolean().default(false)` |
| Transform data | `.transform()` | `z.string().transform(Number)` |
| Custom validation | `.refine()` or `.superrefine()` | Conditional validation |

---

## Quick Start Guide

**1. Create a new schema:**
```bash
# Determine domain
src/schemas/[domain]/[resourceType].ts
```

**2. Use composition pattern:**
```typescript
// Base schema
const BaseSchema = z.object({ /* common fields */ })

// Extend for variants
export const VariantASchema = BaseSchema.extend({ /* A-specific */ })
export const VariantBSchema = BaseSchema.extend({ /* B-specific */ })

// Export types
export type VariantA = z.infer<typeof VariantASchema>
export type VariantB = z.infer<typeof VariantBSchema>
```

**3. Align with Appwrite (if applicable):**
```typescript
// Match collection attributes exactly
const Schema = z.object({
  $id: z.string().optional(),
  $createdAt: z.string().datetime().optional(),
  $updatedAt: z.string().datetime().optional(),
  // ... your fields matching Appwrite attributes
})
```

**4. Use in API routes:**
```typescript
try {
  const validated = Schema.parse(data)
  // Use validated data
} catch (error) {
  if (error instanceof z.ZodError) {
    // Handle validation errors
  }
}
```

---

## Further Reading

See supporting files for detailed patterns:
- **[schema-organization-patterns.md]** - Complete directory structure, naming, organization
- **[schema-composition-patterns.md]** - Advanced composition, discriminated unions, reuse patterns
- **[validation-error-handling.md]** - Error handling strategies, user-friendly messages
- **[appwrite-schema-alignment.md]** - Appwrite collection alignment, BaseStore integration

---

**Architecture principle:** Organize schemas by domain, compose via base schemas + extension, align with Appwrite collections, use discriminated unions for polymorphic data, handle validation errors consistently, export inferred types.
