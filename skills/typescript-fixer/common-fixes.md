# Common TypeScript Error Fixes

## "Object is possibly 'undefined'"

```typescript
// ❌ Error
const name = user.name

// ✅ Fix: Optional chaining
const name = user?.name

// ✅ Fix: With default
const name = user?.name ?? 'Guest'

// ✅ Fix: Type guard
if (user) {
  const name = user.name
}
```

## "Property does not exist on type"

```typescript
// ❌ Error
const name = user.fullName

// ✅ Fix: Add to type
interface User {
  fullName: string
}

// ✅ Fix: Use existing property
const name = user.name
```

## "Type 'X' is not assignable to type 'Y'"

```typescript
// ❌ Error
const age: number = "25"

// ✅ Fix: Convert type
const age: number = parseInt("25")

// ✅ Fix: Parse and validate
const age = z.number().parse(input)
```

## "Cannot find name 'X'"

```typescript
// ❌ Error
const result = someFunction()

// ✅ Fix: Import
import { someFunction } from './module'

// ✅ Fix: Define
function someFunction() { ... }
```
