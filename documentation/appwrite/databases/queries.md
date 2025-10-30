# Queries - Comprehensive Guide

Many list endpoints in Appwrite allow you to filter, sort, and paginate results using queries. Appwrite provides a common set of syntax to build queries.

## Query Class

Appwrite SDKs provide a `Query` class to help you build queries. The `Query` class has methods for each type of supported query operation.

## Building Queries

Queries are passed to an endpoint through the `queries` parameter as an array of query strings, which can be generated using the `Query` class.

Each query method is logically separated via `AND` operations. For `OR` operation, pass multiple values into the query method separated by commas. For example `Query.equal('title', ['Avatar', 'Lord of the Rings'])` will fetch the movies `Avatar` or `Lord of the Rings`.

**Default pagination behavior**: By default, results are limited to the **first 25 items**. You can change this through pagination.

```javascript
import { Client, Query, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

tablesDB.listRows({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    queries: [
        Query.equal('title', ['Avatar', 'Lord of the Rings']),
        Query.greaterThan('year', 1999)
    ]
});
```

## Query Operators

### Select

The `select` operator allows you to specify which columns should be returned from a row. This is essential for optimizing response size, controlling which relationship data loads, and only retrieving the data you need.

```javascript
Query.select(["name", "title"])
```

#### Select Relationship Data

With opt-in relationship loading, you must explicitly select relationship data. This gives you fine-grained control over performance and payload size.

**Get rows without relationships:**
```javascript
const doc = await tablesDB.getRow({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: '<ROW_ID>',
    queries: [Query.select(['name', 'age'])]
});
```

**Load all relationship data:**
```javascript
const doc = await tablesDB.getRow({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: '<ROW_ID>',
    queries: [Query.select(['*', 'reviews.*'])]
});
```

**Select specific relationship fields:**
```javascript
const doc = await tablesDB.getRow({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    rowId: '<ROW_ID>',
    queries: [Query.select(['name', 'age', 'reviews.author', 'reviews.rating'])]
});
```

**Load nested relationships:**
```javascript
Query.select(["*", "reviews.*", "reviews.author.*"])
```

### Comparison Operators

#### Equal
```javascript
Query.equal("title", ["Iron Man"])
```

#### Not Equal
```javascript
Query.notEqual("title", "Iron Man")
```

#### Less Than
```javascript
Query.lessThan("score", 10)
```

#### Less Than or Equal
```javascript
Query.lessThanEqual("score", 10)
```

#### Greater Than
```javascript
Query.greaterThan("score", 10)
```

#### Greater Than or Equal
```javascript
Query.greaterThanEqual("score", 10)
```

#### Between
```javascript
Query.between("price", 5, 10)
```

#### Not Between
```javascript
Query.notBetween("price", 5, 10)
```

### Null Checks

#### Is Null
```javascript
Query.isNull("name")
```

#### Is Not Null
```javascript
Query.isNotNull("name")
```

### String Operations

#### Starts With
```javascript
Query.startsWith("name", "Once upon a time")
```

#### Not Starts With
```javascript
Query.notStartsWith("name", "Once upon a time")
```

#### Ends With
```javascript
Query.endsWith("name", "happily ever after.")
```

#### Not Ends With
```javascript
Query.notEndsWith("name", "happily ever after.")
```

#### Contains
```javascript
// For arrays
Query.contains("ingredients", ['apple', 'banana'])

// For strings
Query.contains("name", "Tom")
```

#### Not Contains
```javascript
// For arrays
Query.notContains("ingredients", ['apple', 'banana'])

// For strings
Query.notContains("name", "Tom")
```

#### Search (Requires Full-Text Index)
```javascript
Query.search("text", "key words")
```

#### Not Search
```javascript
Query.notSearch("text", "key words")
```

### Logical Operators

#### AND
```javascript
Query.and([
    Query.lessThan("size", 10),
    Query.greaterThan("size", 5)
])
```

#### OR
```javascript
Query.or([
    Query.lessThan("size", 5),
    Query.greaterThan("size", 10)
])
```

### Ordering

#### Order Descending
```javascript
Query.orderDesc("column")
```

#### Order Ascending
```javascript
Query.orderAsc("column")
```

#### Order Random
```javascript
Query.orderRandom()
```

### Pagination

#### Limit
```javascript
Query.limit(25)
```

#### Offset
```javascript
Query.offset(0)
```

#### Cursor After
```javascript
Query.cursorAfter("62a7...f620")
```

#### Cursor Before
```javascript
Query.cursorBefore("62a7...a600")
```

## Time Helpers

Built-in helpers for filtering by creation and update timestamps using ISO 8601 date-time strings.

#### Created Before
```javascript
Query.createdBefore("2025-01-01T00:00:00Z")
```

#### Created After
```javascript
Query.createdAfter("2025-01-01T00:00:00Z")
```

#### Updated Before
```javascript
Query.updatedBefore("2025-01-01T00:00:00Z")
```

#### Updated After
```javascript
Query.updatedAfter("2025-01-01T00:00:00Z")
```

## Geo Queries and Spatial Operations

Geo queries enable geographic operations on spatial columns. Coordinates are specified as `[longitude, latitude]` arrays.

### Distance Equal
```javascript
Query.distanceEqual("location", [-73.9851, 40.7589], 200)
```

### Distance Not Equal
```javascript
Query.distanceNotEqual("location", [-73.9851, 40.7589], 200)
```

### Distance Greater Than
```javascript
Query.distanceGreaterThan("location", [-73.9851, 40.7589], 200)
```

### Distance Less Than
```javascript
Query.distanceLessThan("location", [-73.9851, 40.7589], 200)
```

### Intersects
```javascript
Query.intersects("area", [[-73.9851, 40.7589], [-73.9776, 40.7614], [-73.9733, 40.7505], [-73.9851, 40.7589]])
```

### Not Intersects
```javascript
Query.notIntersects("area", [[-73.9851, 40.7589], [-73.9776, 40.7614], [-73.9733, 40.7505], [-73.9851, 40.7589]])
```

### Overlaps
```javascript
Query.overlaps("zone", [[-73.9851, 40.7589], [-73.9776, 40.7614], [-73.9733, 40.7505], [-73.9851, 40.7589]])
```

### Touches
```javascript
Query.touches("boundary", [[-73.9851, 40.7589], [-73.9776, 40.7614], [-73.9733, 40.7505], [-73.9851, 40.7589]])
```

### Crosses
```javascript
Query.crosses("route", [[-73.9851, 40.7589], [-73.9776, 40.7614]])
```

## Complex Queries

You can create complex queries by combining AND and OR operations. For example, to find items that are either books under $20 or magazines under $10:

```javascript
const results = await tablesDB.listRows({
    databaseId: '<DATABASE_ID>',
    tableId: '<TABLE_ID>',
    queries: [
        Query.or([
            Query.and([
                Query.equal('category', ['books']),
                Query.lessThan('price', 20)
            ]),
            Query.and([
                Query.equal('category', ['magazines']),
                Query.lessThan('price', 10)
            ])
        ])
    ]
});
```

This example demonstrates how to combine `OR` and `AND` operations. The query uses `Query.or()` to match either condition: books under $20 OR magazines under $10.
