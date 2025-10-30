# Authentication Patterns

## Email/Password Auth

```typescript
import { account } from '@/lib/appwrite'
import { ID } from 'appwrite'

// Register
const user = await account.create(
  ID.unique(),
  email,
  password,
  name
)

// Login
const session = await account.createEmailSession(email, password)

// Get current user
const user = await account.get()

// Logout
await account.deleteSession('current')
```

## OAuth2 Flow

```typescript
// Redirect to provider
account.createOAuth2Session(
  'google',
  successUrl,
  failureUrl
)

// After redirect, get current session
const user = await account.get()
```

## Protected Routes

```typescript
// Check auth in Astro page
const user = await account.get().catch(() => null)
if (!user) {
  return Astro.redirect('/login')
}
```
