[Skip to content](https://appwrite.io/docs/products/databases/atomic-numeric-operations#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Atomic numeric operations allow you to safely increase or decrease numeric fields without fetching the full row. This eliminates race conditions and reduces bandwidth usage when updating any numeric values that need to be modified atomically, such as counters, scores, balances, and other fast-moving numeric data.

## [How atomic operations work](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#how-atomic-operations-work)

Instead of the traditional read-modify-write pattern, atomic numeric operations use dedicated methods to modify values directly on the server. The server applies the change atomically under concurrency control and returns the new value.

**Traditional approach:**

1. Fetch row → `{ likes: 42 }`
2. Update client-side → `likes: 43`
3. Write back → `{ likes: 43 }`

**Atomic approach:**

1. Call `incrementRowColumn()` with the column name and the value to increment by
2. Server applies atomically → `likes: 43`

## [When to use atomic operations](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#when-to-use-atomic-operations)

Atomic numeric operations work well for:

- **Social features**: Likes, follows, comment counts
- **Usage metering**: API credits, storage quotas, request limits
- **Game state**: Scores, lives, currency, experience points
- **E-commerce**: Stock counts, inventory levels
- **Workflow tracking**: Retry counts, progress indicators
- **Rate limiting**: Request counters, usage tracking

## [Perform atomic operations](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#perform-atomic-operations)

Use the `incrementRowColumn` and `decrementRowColumn` methods to perform atomic numeric operations. The server will apply these changes atomically under concurrency control.

### [Increment a field](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#increment-field)

```web-code client-web line-numbers
import { Client, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const tablesDB = new TablesDB(client);

const result = await tablesDB.incrementRowColumn({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: '<ROW_ID>',
    column: 'likes', // column
    value: 1 // value
});

```

### [Decrement a field](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#decrement-field)

Use the `decrementRowColumn` method to decrease numeric fields:

```web-code client-web line-numbers
import { Client, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const tablesDB = new TablesDB(client);

const result = await tablesDB.decrementRowColumn({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: '<ROW_ID>',
    column: 'credits', // column
    value: 5 // value
});

```

## [Set constraints and bounds](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#set-constraints-and-bounds)

You can set minimum and maximum bounds for individual operations to prevent invalid values. Use the optional `min` and `max` parameters to ensure the final value stays within acceptable limits:

### [Example with constraints](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#example-with-constraints)

```web-code client-web line-numbers
// Increment with maximum constraint
const result = await tablesDB.incrementRowColumn({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: '<ROW_ID>',
    column: 'credits', // column
    value: 100, // value
    max: 1000 // max (optional)
});

// Decrement with minimum constraint
const result2 = await tablesDB.decrementRowColumn({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: '<ROW_ID>',
    column: 'credits', // column
    value: 50, // value
    min: 0 // min (optional)
});

```

## [Follow best practices](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#follow-best-practices)

### [Use for high-concurrency scenarios](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#use-for-high-concurrency-scenarios)

Atomic numeric operations are most beneficial when multiple users or processes might update the same numeric field simultaneously.

### [Combine with regular updates](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#combine-with-regular-updates)

For complex updates that include both atomic operations and regular field changes, you'll need to use separate API calls:

```web-code client-web line-numbers
// First, increment the likes atomically
const likeResult = await tablesDB.incrementRowColumn(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    '<ROW_ID>',
    'likes', // column
    1 // value
);

// Then, update other fields
const updateResult = await tablesDB.updateRow(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    '<ROW_ID>',
    {
        lastLikedBy: userId,
        lastLikedAt: new Date().toISOString()
    }
);

```

### [Explore related features](https://appwrite.io/docs/products/databases/atomic-numeric-operations\#explore-related-features)

- [Bulk operations](https://appwrite.io/docs/products/databases/bulk-operations) \- Update multiple rows at once
- [Permissions](https://appwrite.io/docs/products/databases/permissions) \- Control access to rows
- [Queries](https://appwrite.io/docs/products/databases/queries) \- Find rows to update
- [Relationships](https://appwrite.io/docs/products/databases/relationships) \- Update related rows

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
