---
name: TypeScript Fixer
description: Fix TypeScript errors by tracing root cause, never using 'any' or assertions as shortcuts. Use when encountering type errors in .ts/.tsx files, component props validation, Zod schema mismatches, Appwrite type inference failures. CRITICAL PHILOSOPHY: Type errors indicate architectural issues, not just syntax problems. Fix source types (Zod schemas, API responses, component interfaces). Handles common patterns: Zod type inference, Vue component props, Appwrite response types, API client typing. Use for "type error", "TS error", "not assignable", "@ts-ignore", "inference".
version: 2.0.0
tags: [typescript, type-safety, errors, debugging, zod, type-inference, no-any, architecture, root-cause]
---

# TypeScript Fixer

## Philosophy

**Type errors are symptoms, not the disease.**

When you see a type error, it's usually telling you about a deeper issue:
- Wrong abstraction level
- Missing validation
- Incorrect data flow
- Lost type information

Fix the root cause, not the symptom.

## NEVER DO

❌ **Never use `any`**
```typescript
// ❌ WRONG - Hiding the problem
const data: any = await fetchUser()

// ✅ RIGHT - Fix the actual type
const data: User = await fetchUser()
```

❌ **Never use type assertions without understanding**
```typescript
// ❌ WRONG - Forcing incorrect type
const user = data as User  // Why isn't it already User?

// ✅ RIGHT - Validate and parse
const user = UserSchema.parse(data)  // Zod validates
```

❌ **Never use @ts-ignore or @ts-expect-error**
```typescript
// ❌ WRONG - Ignoring the error
// @ts-ignore
const value = user.name

// ✅ RIGHT - Fix the actual issue
const value = user?.name ?? 'Guest'
```

❌ **Never disable strict checks**
```typescript
// ❌ WRONG in tsconfig.json
{
  "strict": false,
  "strictNullChecks": false
}

// ✅ RIGHT - Keep strict mode
{
  "strict": true
}
```

## Systematic Approach

### Step 1: Read Error Completely

```
Example error:
Type 'string | undefined' is not assignable to type 'string'.
  Type 'undefined' is not assignable to type 'string'.
```

**Understand what it's saying:**
- Expected: `string` (always has a value)
- Received: `string | undefined` (might not have a value)
- Problem: Code doesn't handle the `undefined` case

### Step 2: Find Type Definition

Trace back to where the type is defined:

```typescript
// Where does this type come from?
const name: string = user.name
//                   ^^^^^^^^^
//                   What is user.name's type?

// Find the definition
interface User {
  name?: string  // ← Optional! Can be undefined
}
```

### Step 3: Trace Call Chain

Follow the data flow:

```typescript
// 1. Source
const response = await fetch('/api/user')

// 2. Parse
const data = await response.json()  // Type: any

// 3. Use
const user: User = data  // ← Type lost here
const name: string = user.name  // ← Error here
```

### Step 4: Fix at Source

Fix where the type is wrong, not where the error appears:

```typescript
// ❌ WRONG - Fix at error location
const name: string = user.name ?? 'Guest'
// Still have User with optional name everywhere

// ✅ RIGHT - Fix at source
const UserSchema = z.object({
  name: z.string()  // Required, not optional
})

const response = await fetch('/api/user')
const data = await response.json()
const user = UserSchema.parse(data)  // ← Type guaranteed here
const name: string = user.name  // ← No error
```

## Common Patterns (Your Stack)

### Zod Schema → TypeScript Type

```typescript
// ✅ CORRECT - Zod is source of truth
const UserSchema = z.object({
  name: z.string(),
  email: z.string().email(),
  age: z.number().optional()
})

type User = z.infer<typeof UserSchema>
//          ^^^^^ Inferred from schema

// ❌ WRONG - Separate type and schema
type User = {
  name: string
  email: string
  age?: number
}
const UserSchema = z.object({...})  // Can get out of sync
```

### Appwrite Response Types

```typescript
import { Models } from 'appwrite'

// ✅ CORRECT - Use SDK types + validate
const doc: Models.Document = await databases.getDocument(...)
const user = UserSchema.parse(doc)  // Validate + get typed
//           ^^^^^ Now type-safe User

// ❌ WRONG - Trust Appwrite response directly
const user = await databases.getDocument(...)  // Type: any
```

### Vue Component Props

```typescript
// ✅ CORRECT - Zod schema for props
const propsSchema = z.object({
  user: UserSchema,
  optional: z.string().optional(),
  withDefault: z.string().default('default')
})

const props = defineProps<z.infer<typeof propsSchema>>()

// ❌ WRONG - Just TypeScript interface
interface Props {
  user: User
  optional?: string
  withDefault?: string
}
const props = defineProps<Props>()  // No runtime validation
```

### Handling Optional/Nullable

```typescript
// When value might be undefined/null:

// ✅ CORRECT - Optional chaining + nullish coalescing
const name = user?.name ?? 'Guest'
const email = user?.email ?? 'no-email@example.com'

// ✅ CORRECT - Type guard
if (user && user.name) {
  // TypeScript knows user.name is string here
  console.log(user.name.toUpperCase())
}

// ✅ CORRECT - Early return
if (!user || !user.name) {
  return 'Guest'
}
// TypeScript knows user.name is string here
return user.name

// ❌ WRONG - Force with !
const name = user.name!  // Might crash at runtime

// ❌ WRONG - Type assertion
const name = user.name as string  // Lying to TypeScript
```

## Error Categories & Fixes

### Category 1: Missing Property

```
Error: Property 'name' does not exist on type 'User'
```

**Cause:** Type definition doesn't have property
**Fix:** Add property to type/schema

```typescript
// ✅ FIX
const UserSchema = z.object({
  name: z.string(),  // ← Add missing property
  email: z.string()
})
```

### Category 2: Undefined/Null Not Handled

```
Error: Object is possibly 'undefined'
Error: Object is possibly 'null'
```

**Cause:** Value might not exist
**Fix:** Handle undefined/null case

```typescript
// ✅ FIX - Optional chaining
const name = user?.name

// ✅ FIX - Nullish coalescing
const name = user?.name ?? 'Guest'

// ✅ FIX - Type guard
if (user && user.name) {
  // use user.name
}
```

### Category 3: Wrong Type Inferred

```
Error: Type 'string' is not assignable to type 'number'
```

**Cause:** TypeScript inferred wrong type
**Fix:** Provide correct type annotation

```typescript
// ❌ WRONG - TypeScript infers string
const age = "25"  // Type: string

// ✅ FIX - Parse to number
const age = parseInt("25")  // Type: number

// ✅ FIX - Type annotation
const age: number = parseInt("25")
```

### Category 4: Union Type Not Narrowed

```
Error: Property 'x' does not exist on type 'A | B'
```

**Cause:** TypeScript doesn't know which type
**Fix:** Narrow the type

```typescript
type Response = SuccessResponse | ErrorResponse

// ❌ WRONG - Doesn't narrow
if (response.success) {  // Error: Property 'success' doesn't exist
  ...
}

// ✅ FIX - Type guard
function isSuccess(r: Response): r is SuccessResponse {
  return 'data' in r
}

if (isSuccess(response)) {
  // TypeScript knows it's SuccessResponse
  console.log(response.data)
}

// ✅ FIX - Discriminated union
type Response =
  | { type: 'success', data: string }
  | { type: 'error', message: string }

if (response.type === 'success') {
  // TypeScript knows it has 'data'
  console.log(response.data)
}
```

### Category 5: Generic Type Lost

```
Error: Argument of type 'unknown' is not assignable to parameter of type 'User'
```

**Cause:** Generic type information lost
**Fix:** Preserve generic through chain

```typescript
// ❌ WRONG - Type lost
async function fetchData(url: string) {
  const response = await fetch(url)
  return response.json()  // Type: any
}

// ✅ FIX - Generic type preserved
async function fetchData<T>(url: string, schema: z.ZodType<T>): Promise<T> {
  const response = await fetch(url)
  const data = await response.json()
  return schema.parse(data)  // Type: T
}

const user = await fetchData('/api/user', UserSchema)
// user is type User
```

## Debugging Workflow

### 1. Reproduce Error
- Open file with error
- Read full error message
- Note line number and exact error

### 2. Understand Current State
```typescript
// Add type checks
console.log('Type of user:', typeof user)
console.log('User value:', user)

// Check what TypeScript thinks
type UserType = typeof user
//   ^? Hover to see inferred type
```

### 3. Trace to Source
- Where is this value created?
- What's its type at source?
- Where does type information get lost?

### 4. Identify Root Cause
- Is type wrong at source?
- Is validation missing?
- Is optional/null not handled?
- Is generic type lost?

### 5. Apply Fix at Source
- Don't fix at error location
- Fix where type is wrong
- Ensure type flows correctly

### 6. Verify Fix
```bash
# Run type check
npm run typecheck

# Should show no errors
```

## TypeScript Configuration

Your `tsconfig.json` should have:

```json
{
  "compilerOptions": {
    "strict": true,                    // ✅ Enable all strict checks
    "strictNullChecks": true,          // ✅ Catch null/undefined
    "strictFunctionTypes": true,       // ✅ Function type safety
    "strictBindCallApply": true,       // ✅ Bind/call/apply safety
    "strictPropertyInitialization": true, // ✅ Class property init
    "noImplicitAny": true,             // ✅ No implicit any
    "noImplicitThis": true,            // ✅ No implicit this
    "alwaysStrict": true,              // ✅ Use strict mode

    "noUnusedLocals": true,            // ✅ Catch unused variables
    "noUnusedParameters": true,        // ✅ Catch unused parameters
    "noImplicitReturns": true,         // ✅ All code paths return
    "noFallthroughCasesInSwitch": true // ✅ No fallthrough cases
  }
}
```

## Checklist When Fixing Types

- [ ] Read full error message
- [ ] Trace type to its source
- [ ] Understand why type is wrong
- [ ] Fix at source, not at error location
- [ ] Never use `any`, `as`, or `@ts-ignore`
- [ ] Validate data with Zod when parsing
- [ ] Handle optional/null cases properly
- [ ] Run typecheck to verify fix
- [ ] Check related code for same issue

## Further Reading

See supporting files:
- [zod-patterns.md] - Zod validation patterns
- [common-fixes.md] - Common error solutions
- [appwrite-types.md] - Appwrite-specific types
