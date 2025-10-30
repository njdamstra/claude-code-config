# Database Query Patterns

## Common Queries

```typescript
import { Query } from 'appwrite'

// Equal
Query.equal('status', 'active')

// Not equal
Query.notEqual('status', 'deleted')

// Greater than / Less than
Query.greaterThan('age', 18)
Query.lessThan('price', 100)

// Search (full-text)
Query.search('title', 'keyword')

// Order
Query.orderAsc('$createdAt')
Query.orderDesc('$createdAt')

// Limit and offset (pagination)
Query.limit(10)
Query.offset(20)
```

## Pagination

```typescript
const page = 1
const limit = 10
const offset = (page - 1) * limit

const results = await databases.listDocuments(dbId, collId, [
  Query.limit(limit),
  Query.offset(offset)
])

const total = await databases.listDocuments(dbId, collId, [
  Query.limit(1)
]).then(r => r.total)
```
