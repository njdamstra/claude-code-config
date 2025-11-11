[Skip to content](https://appwrite.io/docs/products/databases/order#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

You can order results returned by Appwrite Databases by using an order query. For best performance, create an [index](https://appwrite.io/docs/products/databases/tables#indexes) on the column you plan to order by.

## [Ordering one column](https://appwrite.io/docs/products/databases/order\#one-column)

When querying using the [listRows](https://appwrite.io/docs/references/cloud/client-web/tables#listRows) endpoint, you can specify the order of the rows returned using the `Query.orderAsc()` and `Query.orderDesc()` query methods.

```web-code client-web line-numbers
import { Client, Query, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

tablesDB.listRows({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    queries: [\
        Query.orderAsc('title'),\
    ]
});

```

## [Multiple columns](https://appwrite.io/docs/products/databases/order\#multiple-columns)

To sort based on multiple columns, simply provide multiple query methods. For better performance, create an index on the first column that you order by.

In the example below, the movies returned will be first sorted by `title` in ascending order, then sorted by `year` in descending order.

```web-code js line-numbers
// Web SDK code example for sorting based on multiple columns
// ...

// List rows and sort based on multiple columns
tablesDB.listRows({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    queries: [\
        Query.orderAsc('title'), // Order first by title in ascending order\
        Query.orderDesc('year'), // Then, order by year in descending order\
    ]
});

```

## [Ordering by sequence](https://appwrite.io/docs/products/databases/order\#sequence-ordering)

For numeric ordering based on insertion order, you can use the `$sequence` field, which Appwrite automatically adds to all rows. This field increments with each new insert.

```web-code client-web line-numbers
import { Client, Query, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

tablesDB.listRows({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    queries: [\
        Query.orderAsc('$sequence'),\
    ]
});

```

The `$sequence` field is useful when you need:

- Consistent ordering for pagination, especially with high-frequency inserts
- Reliable insertion order tracking when timestamps might not be precise enough
- Simple numeric ordering without managing custom counter fields

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
