[Skip to content](https://appwrite.io/docs/products/databases/tables#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Appwrite uses tables as containers of rows. Each tables contains many rows identical in structure. The terms tables and rows are used because the Appwrite JSON REST API resembles the API of a traditional NoSQL database, making it intuitive and user-friendly, even though Appwrite uses SQL under the hood.

That said, Appwrite is designed to support both SQL and NoSQL database adapters like MariaDB, MySQL, or MongoDB in future versions.

## [Create table](https://appwrite.io/docs/products/databases/tables\#create-table)

You can create tables using the Appwrite Console, a [Server SDK](https://appwrite.io/docs/sdks#server), or using the [CLI](https://appwrite.io/docs/tooling/command-line/installation).

ConsoleServer SDKCLI

ConsoleServer SDK
More

CLI

You can create a table by heading to the **Databases** page, navigate to a [database](https://appwrite.io/docs/products/databases/databases), and click **Create table**.

You can also create tables programmatically using a [Server SDK](https://appwrite.io/docs/sdks#server). Appwrite [Server SDKs](https://appwrite.io/docs/sdks#server) require an [API key](https://appwrite.io/docs/advanced/platform/api-keys).

```web-code server-nodejs line-numbers
const sdk = require('node-appwrite');

// Init SDK
const client = new sdk.Client();

const tablesDB = new sdk.TablesDB(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
    .setKey('919c2d18fb5d4...a2ae413da83346ad2') // Your secret API key
;

const promise = tablesDB.createTable({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    name: '<NAME>'
});

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});

```

You can also configure **permissions** in the `createTable` method, learn more about the `createTable` in the [API references](https://appwrite.io/docs/references).

##### Before proceeding

Ensure you [**install**](https://appwrite.io/docs/tooling/command-line/installation#getting-started) the CLI, [**log in**](https://appwrite.io/docs/tooling/command-line/installation#login) to your Appwrite account, and [**initialize**](https://appwrite.io/docs/tooling/command-line/installation#initialization) your Appwrite project.

To create your table using the CLI, first use the `appwrite init tables` command to initialize your table.

```web-code sh line-numbers
appwrite init tables

```

Then push your table using the `appwrite push tables` command.

```web-code sh line-numbers
appwrite push tables

```

This will create your table in the Console with all of your `appwrite.json` configurations.

[Learn more about the CLI tables commands](https://appwrite.io/docs/tooling/command-line/tables#commands)

## [Permissions](https://appwrite.io/docs/products/databases/tables\#permissions)

Appwrite uses permissions to control data access. For security, only users that are granted permissions can access a resource. This helps prevent accidental data leaks by forcing you to make more conscious decisions around permissions.

By default, Appwrite doesn't grant permissions to any users when a new table is created. This means users can't create new rows or read, update, and delete existing rows.

[Learn about configuring permissions](https://appwrite.io/docs/products/databases/permissions).

## [Columns](https://appwrite.io/docs/products/databases/tables\#columns)

All rows in a table follow the same structure. Columns are used to define the structure of your rows and help the Appwrite's API validate your users' input. Add your first column by clicking the **Add column** button.

You can choose between the following types.

| Column | Description |
| --- | --- |
| `string` | String column. |
| `integer` | Integer column. |
| `float` | Float column. |
| `boolean` | Boolean column. |
| `datetime` | Datetime column formatted as an ISO 8601 string. |
| `enum` | Enum column. |
| `ip` | IP address column for IPv4 and IPv6. |
| `email` | Email address column. |
| `url` | URL column. |
| `point` | Geographic point specified as `[longitude, latitude]`. |
| `line` | Geographic line represented by an ordered list of coordinates. |
| `polygon` | Geographic polygon representing a closed area; supports interior holes. |
| `relationship` | Relationship column relates one table to another. [Learn more about relationships.](https://appwrite.io/docs/products/databases/relationships) |

If an column must be populated in all rows, set it as `required`. If not, you may optionally set a default value. Additionally, decide if the column should be a single value or an array of values.

If needed, you can change an column's key, default value, size (for strings), and whether it is required or not after creation.

You can increase a string column's size without any restrictions. When decreasing size, you must ensure that your existing data is less than or equal to the new size, or the operation will fail.

## [Indexes](https://appwrite.io/docs/products/databases/tables\#indexes)

Databases use indexes to quickly locate data without having to search through every row for matches. To ensure the best performance, Appwrite recommends an index for every column queried. If you plan to query multiple columns in a single query, creating an index with **all** queried columns will yield optimal performance.

The following indexes are currently supported:

| Type | Description |
| --- | --- |
| `key` | Plain Index to allow queries. |
| `unique` | Unique Index to disallow duplicates. |
| `fulltext` | For searching within string columns. Required for the [search query method](https://appwrite.io/docs/products/databases/queries#query-class). |

You can create an index by navigating to your table's **Indexes** tab or by using your favorite [Server SDK](https://appwrite.io/docs/sdks#server).

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
