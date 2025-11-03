# Start with Databases - Quick Start

Head to your [Appwrite Console](https://cloud.appwrite.io/console/) and create a database and name it `Oscar`. Optionally, add a custom database ID.

Create a table and name it `My books`. Optionally, add a custom table ID.

Navigate to **Columns** and create columns by clicking **Create column** and select **String**. Columns define the structure of your table's rows. Enter **Column key** and **Size**. For example, `title` and `100`.

Navigate to **Settings** > **Permissions** and add a new role **Any**. Check the **CREATE** and **READ** permissions, so anyone can create and read rows.

## Create a Row

To create a row use the `createRow` method.

In the **Settings** menu, find your project ID and replace `<PROJECT_ID>` in the example.

Navigate to the `Oscar` database, copy the database ID, and replace `<DATABASE_ID>`. Then, in the `My books` table, copy the table ID, and replace `<TABLE_ID>`.

```javascript
import { Client, ID, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

const promise = tablesDB.createRow({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: ID.unique(),
    data: { title: "Hamlet" }
});

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
```

The response should look similar to this:

```json
{
    "title": "Hamlet",
    "$id": "65013138dcd8618e80c4",
    "$permissions": [],
    "$createdAt": "2023-09-13T03:49:12.905+00:00",
    "$updatedAt": "2023-09-13T03:49:12.905+00:00",
    "$databaseId": "650125c64b3c25ce4bc4",
    "$tableId": "650125cff227cf9f95ad"
}
```

## Query Data

To read and query data from your table, use the `listRows` endpoint.

Like the previous step, replace `<PROJECT_ID>`, `<DATABASE_ID>`, and `<TABLE_ID>` with their respective IDs.

```javascript
import { Client, Query, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint("https://<REGION>.cloud.appwrite.io/v1")
    .setProject("<PROJECT_ID>")

const tablesDB = new TablesDB(client);

const promise = tablesDB.listRows({
    databaseId: "<DATABASE_ID>",
    tableId: "<TABLE_ID>",
    queries: [
        Query.equal('title', 'Hamlet')
    ]
});

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});
```

## Type Safety with Generics

For added type safety and better development experience, mobile and native SDKs support custom model types with the `nestedType` parameter.

Define a data class or model that matches your table structure:

```typescript
// Web SDK supports generics for type safety
interface Book {
    title: string;
    author?: string;
    pages?: number;
    isAvailable: boolean;
}

const tablesDB = new TablesDB(client);

try {
    const books = await tablesDB.listRows<Book>({
        databaseId: '<DATABASE_ID>',
        tableId: '<TABLE_ID>'
    });

    books.rows.forEach(book => {
        console.log(`Book: ${book.title} by ${book.author}`);
    });
} catch (error) {
    console.log(error);
}
```

### Automatic Type Generation

You can automatically generate type definitions for your tables using the [Appwrite CLI type generation](https://appwrite.io/docs/products/databases/type-generation) feature. Run `appwrite types collection` to generate models for your collections.
