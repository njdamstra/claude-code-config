[Skip to content](https://appwrite.io/docs/references/cloud/client-web/databases#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Databases service allows you to create structured collection of documents, query and filter lists of documents, and manage an advanced set of read and write access permissions.

All data returned by the Databases service are represented as structured JSON documents.

The Databases service can contain multiple databases, each database can contain multiple collections. A collection is a group of similarly structured documents. The accepted structure of documents is defined by [collection attributes](https://appwrite.io/docs/products/databases/legacy/collections#attributes). The collection attributes help you ensure all your user-submitted data is validated and stored according to the collection structure.

Using Appwrite permissions architecture, you can assign read or write access to each collection or document in your project for either a specific user, team, user role, or even grant it with public access ( `any`). You can learn more about [how Appwrite handles permissions and access control](https://appwrite.io/docs/products/databases/legacy/permissions).

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Get a document by its unique ID. This endpoint response returns a JSON object with the document data.

- Request

- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Document ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long.


- Response

  - - [Document](https://appwrite.io/docs/references/cloud/models/document)



```web-code text
GET /databases/{databaseId}/collections/{collectionId}/documents/{documentId}

```

```web-code client-web
import { Client, Databases } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const databases = new Databases(client);

const result = await databases.getDocument({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    queries: [] // optional
});

console.log(result);

```

Get a list of all the user's documents in a given collection. You can use the query params to filter your results.

- Request

- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long.


- Response

  - - [Documents List](https://appwrite.io/docs/references/cloud/models/documentList)



```web-code text
GET /databases/{databaseId}/collections/{collectionId}/documents

```

```web-code client-web
import { Client, Databases } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const databases = new Databases(client);

const result = await databases.listDocuments({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    queries: [] // optional
});

console.log(result);

```

Update a document by its unique ID. Using the patch method you can pass only specific fields that will get updated.

- Request

- Database ID.

- Collection ID.

- Document ID.

- Document data as JSON object. Include only attribute and value pairs to be updated.

- An array of permissions strings. By default, the current permissions are inherited. [Learn more about permissions](https://appwrite.io/docs/permissions).


- Response

  - - [Document](https://appwrite.io/docs/references/cloud/models/document)


- Rate limits

This endpoint is rate limited. You can only make a limited number of request to
his endpoint within a specific time frame.


The limit is applied for each unique limit key.




| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 120 requests | IP + METHOD + URL + USER ID |




[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/documents/{documentId}

```

```web-code client-web
import { Client, Databases } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const databases = new Databases(client);

const result = await databases.updateDocument({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    data: {}, // optional
    permissions: ["read(\"any\")"] // optional
});

console.log(result);

```

Delete a document by its unique ID.

- Request

- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Document ID.


- Response

- Rate limits

This endpoint is rate limited. You can only make a limited number of request to
his endpoint within a specific time frame.


The limit is applied for each unique limit key.




| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 60 requests | IP + METHOD + URL + USER ID |




[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
DELETE /databases/{databaseId}/collections/{collectionId}/documents/{documentId}

```

```web-code client-web
import { Client, Databases } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const databases = new Databases(client);

const result = await databases.deleteDocument({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>'
});

console.log(result);

```

Increment a specific attribute of a document by a given value.

- Request

- Database ID.

- Collection ID.

- Document ID.

- Attribute key.

- Value to increment the attribute by. The value must be a number.

- Maximum value for the attribute. If the current value is greater than this value, an error will be thrown.


- Response

  - - [Document](https://appwrite.io/docs/references/cloud/models/document)


- Rate limits

This endpoint is rate limited. You can only make a limited number of request to
his endpoint within a specific time frame.


The limit is applied for each unique limit key.




| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 120 requests | IP + METHOD + URL + USER ID |




[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/documents/{documentId}/{attribute}/increment

```

```web-code client-web
import { Client, Databases } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const databases = new Databases(client);

const result = await databases.incrementDocumentAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    attribute: '',
    value: null, // optional
    max: null // optional
});

console.log(result);

```

Decrement a specific attribute of a document by a given value.

- Request

- Database ID.

- Collection ID.

- Document ID.

- Attribute key.

- Value to increment the attribute by. The value must be a number.

- Minimum value for the attribute. If the current value is lesser than this value, an exception will be thrown.


- Response

  - - [Document](https://appwrite.io/docs/references/cloud/models/document)


- Rate limits

This endpoint is rate limited. You can only make a limited number of request to
his endpoint within a specific time frame.


The limit is applied for each unique limit key.




| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 120 requests | IP + METHOD + URL + USER ID |




[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/documents/{documentId}/{attribute}/decrement

```

```web-code client-web
import { Client, Databases } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const databases = new Databases(client);

const result = await databases.decrementDocumentAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    attribute: '',
    value: null, // optional
    min: null // optional
});

console.log(result);

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
