[Skip to content](https://appwrite.io/docs/products/databases/rows#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Each piece of data or information in Appwrite Databases is a row. Rows have a structure defined by the parent table.

## [Create rows](https://appwrite.io/docs/products/databases/rows\#create-rows)

##### Permissions required

You must grant _create_ permissions to users at the _table level_ before users can create rows. [Learn more about permissions](https://appwrite.io/docs/products/databases/rows#permissions)

In most use cases, you will create rows programmatically.

```web-code client-web line-numbers
import { Client, ID, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

const promise = tablesDB.createRow({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: ID.unique(),
    data: {}
});

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});

```

During testing, you might prefer to create rows in the Appwrite Console. To do so, navigate to the **Rows** tab of your table and click the **Add row** button.

## [List rows](https://appwrite.io/docs/products/databases/rows\#list-rows)

##### Permissions required

You must grant _read_ permissions to users at the _table level_ before users can read rows. [Learn more about permissions](https://appwrite.io/docs/products/databases/rows#permissions)

Rows can be retrieved using the [List Row](https://appwrite.io/docs/references/cloud/client-web/tables#listRows) endpoint.

Results can be filtered, sorted, and paginated using Appwrite's shared set of query methods. You can find a full guide on querying in the [Queries Guide](https://appwrite.io/docs/products/databases/queries).

By default, results are limited to the _first 25 items_. You can change this through [pagination](https://appwrite.io/docs/products/databases/pagination).

```web-code client-web line-numbers
import { Client, Query, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint("https://<REGION>.cloud.appwrite.io/v1")
    .setProject("<PROJECT_ID>")

const tablesDB = new TablesDB(client);

let promise = tablesDB.listRows({
    databaseId: "<DATABASE_ID>",
    tableId: "<TABLE_ID>",
    queries: [\
        Query.equal('title', 'Avatar')\
    ]
});

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});

```

## [Update row](https://appwrite.io/docs/products/databases/rows\#update-row)

##### Permissions required

You must grant _update_ permissions to users at the _table level_ or _row level_ before users can update rows. [Learn more about permissions](https://appwrite.io/docs/products/databases/rows#permissions)

In most use cases, you will update rows programmatically.

```web-code client-web line-numbers
import { Client, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

const promise = tablesDB.updateRow(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    '<ROW_ID>',
    { title: 'Updated Title' }
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});

```

## [Upsert rows](https://appwrite.io/docs/products/databases/rows\#upsert-rows)

Upsert is a combination of "update" and "insert" operations. It creates a new row if one doesn't exist with the given ID, or updates an existing row if it does exist.

In most use cases, you will upsert rows programmatically.

##### Permissions required

You must grant _create_ permissions to users at the _table level_, and _update_ permissions to users at the _table_ or _row_ level before users can upsert rows. [Learn more about permissions](https://appwrite.io/docs/products/databases/rows#permissions)

```web-code client-web line-numbers
import { Client, ID, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

const promise = tablesDB.upsertRow(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    ID.unique(),
    {}
);

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});

```

## [Type safety with models](https://appwrite.io/docs/products/databases/rows\#type-safety)

Mobile and native SDKs provide type safety when working with rows through the `nestedType` parameter. This allows you to specify custom model types for complete auto-completion and type safety.

### [Define your model](https://appwrite.io/docs/products/databases/rows\#define-your-model)

Create a data class or struct that matches your table structure:

Kotlin/JavaSwiftWeb/Node

Kotlin/JavaSwift
More

Web/Node

```web-code kotlin line-numbers
data class Book(
    val title: String,
    val author: String,
    val publishedYear: Int? = null,
    val genre: List<String>? = null,
    val isAvailable: Boolean = true
)

```

```web-code swift line-numbers
struct Book: Codable {
    let title: String
    let author: String
    let publishedYear: Int?
    let genre: [String]?
    let isAvailable: Bool
}

```

```web-code typescript line-numbers
interface Book {
    title: string;
    author: string;
    publishedYear?: number;
    genre?: string[];
    isAvailable: boolean;
}

```

### [Using type-safe operations](https://appwrite.io/docs/products/databases/rows\#using-type-safe-operations)

Use the `nestedType` parameter for full type safety in native SDKs, or generics in web SDKs:

```web-code client-web line-numbers
const tablesDB = new TablesDB(client);

try {
    // Create with generics
    const newBook = await tablesDB.createRow<Book>({
        databaseId: '<DATABASE_ID>',
        tableId: '<TABLE_ID>',
        rowId: ID.unique(),
        data: {
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            isAvailable: true
        }
    });

    // List with generics
    const books = await tablesDB.listRows<Book>({
        databaseId: '<DATABASE_ID>',
        tableId: '<TABLE_ID>'
    });

    // TypeScript provides full type safety
    books.rows.forEach(book => {
        console.log(`Book: ${book.title} by ${book.author}`);
        if (book.isAvailable) {
            console.log("Available for checkout");
        }
    });
} catch (error) {
    console.log(error);
}

```

### [Model methods](https://appwrite.io/docs/products/databases/rows\#model-methods)

Models returned by native SDKs include helpful utility methods:

Kotlin/JavaSwift

Kotlin/JavaSwift

```web-code kotlin line-numbers
val book = books.rows.first()

// Convert model to Map for debugging or manual manipulation
val bookMap = book.toMap()
Log.d("Appwrite", "Book data: ${bookMap}")

// Create model instance from Map data
val bookData = mapOf(
    "title" to "1984",
    "author" to "George Orwell",
    "isAvailable" to false
)
val newBook = Book.from(bookData, Book::class.java)

// JSON serialization using Gson (used internally by SDK)
import com.google.gson.Gson
val gson = Gson()
val jsonString = gson.toJson(book)
val bookFromJson = gson.fromJson(jsonString, Book::class.java)

```

```web-code swift line-numbers
let book = books.rows.first!

// Convert model to dictionary for debugging
let bookMap = book.toMap()
print("Book data: \(bookMap)")

// Create model instance from dictionary
let bookData: [String: Any] = [\
    "title": "1984",\
    "author": "George Orwell",\
    "isAvailable": false\
]
let newBook = Book.from(map: bookData)

// JSON encoding using Swift's Codable
let jsonData = try JSONEncoder().encode(book)
let jsonString = String(data: jsonData, encoding: .utf8)

// JSON decoding
if let jsonString = jsonString,
   let data = jsonString.data(using: .utf8) {
    let bookFromJson = try JSONDecoder().decode(Book.self, from: data)
}

```

##### Generate types automatically

You can automatically generate model definitions for your tables using the [Appwrite CLI](https://appwrite.io/docs/products/databases/type-generation). Run `appwrite types collection` to generate types based on your database schema.

## [Permissions](https://appwrite.io/docs/products/databases/rows\#permissions)

In Appwrite, permissions can be granted at the table level and the row level. Before a user can create a row, you need to grant create permissions to the user.

Read, update, and delete permissions can be granted at both the table and row level. Users only need to be granted access at either the table or row level to access rows.

[Learn about configuring permissions](https://appwrite.io/docs/products/databases/permissions).

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
