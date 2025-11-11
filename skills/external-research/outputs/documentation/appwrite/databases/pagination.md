[Skip to content](https://appwrite.io/docs/products/databases/pagination#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

As your database grows in size, you'll need to paginate results returned. Pagination improves performance by returning a subset of results that match a query at a time, called a page.

By default, list operations return 25 items per page, which can be changed using the `Query.limit(25)` operator. There is no hard limit on the number of items you can request. However, beware that **large pages can degrade performance**.

## [Offset pagination](https://appwrite.io/docs/products/databases/pagination\#offset-pagination)

Offset pagination works by dividing rows into `M` pages containing `N` rows. Every page is retrieved by skipping `offset = M * (N - 1)` items and reading the following `M` pages.

Using `Query.limit()` and `Query.offset()` you can achieve offset pagination. With `Query.limit()` you can define how many rows can be returned from one request. The `Query.offset()` is number of records you wish to skip before selecting records.

```web-code client-web line-numbers
import { Client, Query, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

// Page 1
const page1 = await tablesDB.listRows(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    [\
        Query.limit(25),\
        Query.offset(0)\
    ]
);

// Page 2
const page2 = await tablesDB.listRows(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    [\
        Query.limit(25),\
        Query.offset(25)\
    ]
);

```

##### Drawbacks

While traditional offset pagination is familiar, it comes with some drawbacks. The request gets slower as the number of records increases because the database has to read up to the offset number `M * (N - 1)` of rows to know where it should start selecting data. If the data changes frequently, offset pagination will also produce **missing and duplicate** results.

## [Cursor pagination](https://appwrite.io/docs/products/databases/pagination\#cursor-pagination)

The cursor is a unique identifier for a row that points to where the next page should start. After reading a page of rows, pass the last row's ID into the `Query.cursorAfter(lastId)` query method to get the next page of rows. Pass the first row's ID into the `Query.cursorBefore(firstId)` query method to retrieve the previous page.

```web-code client-web line-numbers
import { Client, Query, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint("https://<REGION>.cloud.appwrite.io/v1")
    .setProject("<PROJECT_ID>");

const tablesDB = new TablesDB(client);

// Page 1
const page1 = await tablesDB.listRows(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    [\
        Query.limit(25),\
    ]
);

const lastId = page1.rows[page1.rows.length - 1].$id;

// Page 2
const page2 = await tablesDB.listRows(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    [\
        Query.limit(25),\
        Query.cursorAfter(lastId),\
    ]
);

```

## [When to use what?](https://appwrite.io/docs/products/databases/pagination\#when-to-use)

Offset pagination should be used for tables that rarely change. Offset pagination allow you to create indicator of the current page number and total page number. For example, a list with up to 20 pages or static data like a list of countries or currencies. Using offset pagination on large tables and frequently updated tables may result in slow performance and **missing and duplicate** results.

Cursor pagination should be used for frequently updated tablesDB. It is best suited for lazy-loaded pages with infinite scrolling. For example, a feed, comment section, chat history, or high volume datasets.

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
