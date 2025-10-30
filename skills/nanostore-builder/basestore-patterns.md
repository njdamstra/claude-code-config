# BaseStore Patterns

## Core Concept

BaseStore provides CRUD operations with:
- Zod schema validation
- Appwrite integration
- Reactive atoms (Nanostores)
- Type safety

## Inheritance Pattern

```typescript
export class UserStore extends BaseStore<typeof UserSchema> {
  constructor() {
    super(
      collectionId,  // Appwrite collection ID
      schema,        // Zod schema
      atomKey,       // Key for nanostore atom
      databaseId     // Appwrite database ID
    )
  }

  // Add custom methods here
}
```

## Custom Methods

Add domain-specific methods:

```typescript
async getCurrentUser(): Promise<User | null> {
  const account = await this.account.get()
  return await this.get(account.$id)
}

async searchByName(query: string): Promise<User[]> {
  return await this.list([Query.search('name', query)])
}
```
