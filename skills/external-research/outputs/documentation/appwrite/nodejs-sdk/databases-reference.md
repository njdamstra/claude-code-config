[Skip to content](https://appwrite.io/docs/references/cloud/server-nodejs/databases#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Databases service allows you to create structured collection of documents, query and filter lists of documents, and manage an advanced set of read and write access permissions.

All data returned by the Databases service are represented as structured JSON documents.

The Databases service can contain multiple databases, each database can contain multiple collections. A collection is a group of similarly structured documents. The accepted structure of documents is defined by [collection attributes](https://appwrite.io/docs/products/databases/legacy/collections#attributes). The collection attributes help you ensure all your user-submitted data is validated and stored according to the collection structure.

Using Appwrite permissions architecture, you can assign read or write access to each collection or document in your project for either a specific user, team, user role, or even grant it with public access ( `any`). You can learn more about [how Appwrite handles permissions and access control](https://appwrite.io/docs/products/databases/legacy/permissions).

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Create a new Collection. Before using this route, you should create a new database resource using either a [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection) API or directly from your database console.

- Request









- Database ID.

- Unique Id. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Collection name. Max length: 128 chars.

- An array of permissions strings. By default, no user is granted with any permissions. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Enables configuring permissions for individual documents. A user needs one of document or collection level permissions to access a document. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Is collection enabled? When set to 'disabled', users cannot access the collection but Server SDKs with and API key can still read and write to the collection. No data is lost when this is toggled.


- Response









  - - [Collection](https://appwrite.io/docs/references/cloud/models/collection)



```web-code text
POST /databases/{databaseId}/collections

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createCollection({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    name: '<NAME>',
    permissions: ["read(\"any\")"], // optional
    documentSecurity: false, // optional
    enabled: false // optional
});

```

Get a collection by its unique ID. This endpoint response returns a JSON object with the collection metadata.

- Request









- Database ID.

- Collection ID.


- Response









  - - [Collection](https://appwrite.io/docs/references/cloud/models/collection)



```web-code text
GET /databases/{databaseId}/collections/{collectionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.getCollection({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>'
});

```

Get a list of all collections that belong to the provided databaseId. You can use the search parameter to filter your results.

- Request









- Database ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, enabled, documentSecurity

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Collections List](https://appwrite.io/docs/references/cloud/models/collectionList)



```web-code text
GET /databases/{databaseId}/collections

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.listCollections({
    databaseId: '<DATABASE_ID>',
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update a collection by its unique ID.

- Request









- Database ID.

- Collection ID.

- Collection name. Max length: 128 chars.

- An array of permission strings. By default, the current permissions are inherited. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Enables configuring permissions for individual documents. A user needs one of document or collection level permissions to access a document. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Is collection enabled? When set to 'disabled', users cannot access the collection but Server SDKs with and API key can still read and write to the collection. No data is lost when this is toggled.


- Response









  - - [Collection](https://appwrite.io/docs/references/cloud/models/collection)



```web-code text
PUT /databases/{databaseId}/collections/{collectionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateCollection({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    name: '<NAME>',
    permissions: ["read(\"any\")"], // optional
    documentSecurity: false, // optional
    enabled: false // optional
});

```

Delete a collection by its unique ID. Only users with write permissions have access to delete this resource.

- Request









- Database ID.

- Collection ID.


- Response


```web-code text
DELETE /databases/{databaseId}/collections/{collectionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.deleteCollection({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>'
});

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

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const databases = new sdk.Databases(client);

const result = await databases.getDocument({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    queries: [] // optional
});

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

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const databases = new sdk.Databases(client);

const result = await databases.listDocuments({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    queries: [] // optional
});

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













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 120 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/documents/{documentId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const databases = new sdk.Databases(client);

const result = await databases.updateDocument({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    data: {}, // optional
    permissions: ["read(\"any\")"] // optional
});

```

Update all documents that match your queries, if no queries are submitted then all documents are updated. You can pass only specific fields to be updated.

- Request









- Database ID.

- Collection ID.

- Document data as JSON object. Include only attribute and value pairs to be updated.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long.


- Response









  - - [Documents List](https://appwrite.io/docs/references/cloud/models/documentList)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 120 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/documents

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateDocuments({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    data: {}, // optional
    queries: [] // optional
});

```

Delete a document by its unique ID.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Document ID.


- Response

- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 60 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
DELETE /databases/{databaseId}/collections/{collectionId}/documents/{documentId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const databases = new sdk.Databases(client);

const result = await databases.deleteDocument({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>'
});

```

Bulk delete documents using queries, if no queries are passed then all documents are deleted.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long.


- Response









  - - [Documents List](https://appwrite.io/docs/references/cloud/models/documentList)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 60 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
DELETE /databases/{databaseId}/collections/{collectionId}/documents

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.deleteDocuments({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    queries: [] // optional
});

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













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 120 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/documents/{documentId}/{attribute}/increment

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const databases = new sdk.Databases(client);

const result = await databases.incrementDocumentAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    attribute: '',
    value: null, // optional
    max: null // optional
});

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













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 120 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/documents/{documentId}/{attribute}/decrement

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const databases = new sdk.Databases(client);

const result = await databases.decrementDocumentAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    documentId: '<DOCUMENT_ID>',
    attribute: '',
    value: null, // optional
    min: null // optional
});

```

Create a boolean attribute.

- Request









- Database ID.

- Collection ID. You can create a new table using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- Is attribute an array?


- Response









  - - [AttributeBoolean](https://appwrite.io/docs/references/cloud/models/attributeBoolean)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/boolean

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createBooleanAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: false, // optional
    array: false // optional
});

```

Create a date time attribute according to the ISO 8601 standard.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#createCollection).

- Attribute Key.

- Is attribute required?

- Default value for the attribute in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. Cannot be set when attribute is required.

- Is attribute an array?


- Response









  - - [AttributeDatetime](https://appwrite.io/docs/references/cloud/models/attributeDatetime)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/datetime

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createDatetimeAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '', // optional
    array: false // optional
});

```

Create an email attribute.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- Is attribute an array?


- Response









  - - [AttributeEmail](https://appwrite.io/docs/references/cloud/models/attributeEmail)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/email

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createEmailAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: 'email@example.com', // optional
    array: false // optional
});

```

Create an enum attribute. The `elements` param acts as a white-list of accepted values for this attribute.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Array of enum values.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- Is attribute an array?


- Response









  - - [AttributeEnum](https://appwrite.io/docs/references/cloud/models/attributeEnum)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/enum

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createEnumAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    elements: [],
    required: false,
    default: '<DEFAULT>', // optional
    array: false // optional
});

```

Create a float attribute. Optionally, minimum and maximum values can be provided.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Minimum value.

- Maximum value.

- Default value. Cannot be set when required.

- Is attribute an array?


- Response









  - - [AttributeFloat](https://appwrite.io/docs/references/cloud/models/attributeFloat)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/float

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createFloatAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    min: null, // optional
    max: null, // optional
    default: null, // optional
    array: false // optional
});

```

Create an integer attribute. Optionally, minimum and maximum values can be provided.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Minimum value

- Maximum value

- Default value. Cannot be set when attribute is required.

- Is attribute an array?


- Response









  - - [AttributeInteger](https://appwrite.io/docs/references/cloud/models/attributeInteger)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/integer

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createIntegerAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    min: null, // optional
    max: null, // optional
    default: null, // optional
    array: false // optional
});

```

Create IP address attribute.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value. Cannot be set when attribute is required.

- Is attribute an array?


- Response









  - - [AttributeIP](https://appwrite.io/docs/references/cloud/models/attributeIp)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/ip

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createIpAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '', // optional
    array: false // optional
});

```

Create a geometric line attribute.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided, two-dimensional array of coordinate pairs, \[\[longitude, latitude\], \[longitude, latitude\], …\], listing the vertices of the line in order. Cannot be set when attribute is required.


- Response









  - - [AttributeLine](https://appwrite.io/docs/references/cloud/models/attributeLine)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/line

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createLineAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '' // optional
});

```

Create a geometric 2d point attribute.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided, array of two numbers \[longitude, latitude\], representing a single coordinate. Cannot be set when attribute is required.


- Response









  - - [AttributePoint](https://appwrite.io/docs/references/cloud/models/attributePoint)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/point

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createPointAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '' // optional
});

```

Create a geometric polygon attribute.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided, three-dimensional array where the outer array holds one or more linear rings, \[\[\[longitude, latitude\], …\], …\], the first ring is the exterior boundary, any additional rings are interior holes, and each ring must start and end with the same coordinate pair. Cannot be set when attribute is required.


- Response









  - - [AttributePolygon](https://appwrite.io/docs/references/cloud/models/attributePolygon)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/polygon

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createPolygonAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '' // optional
});

```

Create relationship attribute. [Learn more about relationship attributes](https://appwrite.io/docs/databases-relationships#relationship-attributes).

- Request









- Database ID.

- Collection ID.

- Related Collection ID.

- Relation type

- Is Two Way?

- Attribute Key.

- Two Way Attribute Key.

- Constraints option


- Response









  - - [AttributeRelationship](https://appwrite.io/docs/references/cloud/models/attributeRelationship)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/relationship

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createRelationshipAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    relatedCollectionId: '<RELATED_COLLECTION_ID>',
    type: sdk.RelationshipType.OneToOne,
    twoWay: false, // optional
    key: '', // optional
    twoWayKey: '', // optional
    onDelete: sdk.RelationMutate.Cascade // optional
});

```

Create a string attribute.

- Request









- Database ID.

- Collection ID. You can create a new table using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Attribute Key.

- Attribute size for text attributes, in number of characters.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- Is attribute an array?

- Toggle encryption for the attribute. Encryption enhances security by not storing any plain text values in the database. However, encrypted attributes cannot be queried.


- Response









  - - [AttributeString](https://appwrite.io/docs/references/cloud/models/attributeString)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/string

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createStringAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    size: 1,
    required: false,
    default: '<DEFAULT>', // optional
    array: false, // optional
    encrypt: false // optional
});

```

Create a URL attribute.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- Is attribute an array?


- Response









  - - [AttributeURL](https://appwrite.io/docs/references/cloud/models/attributeUrl)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/attributes/url

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createUrlAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: 'https://example.com', // optional
    array: false // optional
});

```

Get attribute by ID.

- Request









- Database ID.

- Collection ID.

- Attribute Key.


- Response









  - - [AttributeBoolean](https://appwrite.io/docs/references/cloud/models/attributeBoolean)
- [AttributeInteger](https://appwrite.io/docs/references/cloud/models/attributeInteger)
- [AttributeFloat](https://appwrite.io/docs/references/cloud/models/attributeFloat)
- [AttributeEmail](https://appwrite.io/docs/references/cloud/models/attributeEmail)
- [AttributeEnum](https://appwrite.io/docs/references/cloud/models/attributeEnum)
- [AttributeURL](https://appwrite.io/docs/references/cloud/models/attributeUrl)
- [AttributeIP](https://appwrite.io/docs/references/cloud/models/attributeIp)
- [AttributeDatetime](https://appwrite.io/docs/references/cloud/models/attributeDatetime)
- [AttributeRelationship](https://appwrite.io/docs/references/cloud/models/attributeRelationship)
- [AttributeString](https://appwrite.io/docs/references/cloud/models/attributeString)

```web-code text
GET /databases/{databaseId}/collections/{collectionId}/attributes/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.getAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: ''
});

```

List attributes in the collection.

- Request









- Database ID.

- Collection ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: key, type, size, required, array, status, error


- Response









  - - [Attributes List](https://appwrite.io/docs/references/cloud/models/attributeList)



```web-code text
GET /databases/{databaseId}/collections/{collectionId}/attributes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.listAttributes({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    queries: [] // optional
});

```

Update a boolean attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#createCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- New attribute key.


- Response









  - - [AttributeBoolean](https://appwrite.io/docs/references/cloud/models/attributeBoolean)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/boolean/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateBooleanAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: false,
    newKey: '' // optional
});

```

Update a date time attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- New attribute key.


- Response









  - - [AttributeDatetime](https://appwrite.io/docs/references/cloud/models/attributeDatetime)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/datetime/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateDatetimeAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '',
    newKey: '' // optional
});

```

Update an email attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- New Attribute Key.


- Response









  - - [AttributeEmail](https://appwrite.io/docs/references/cloud/models/attributeEmail)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/email/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateEmailAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: 'email@example.com',
    newKey: '' // optional
});

```

Update an enum attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Updated list of enum values.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- New Attribute Key.


- Response









  - - [AttributeEnum](https://appwrite.io/docs/references/cloud/models/attributeEnum)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/enum/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateEnumAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    elements: [],
    required: false,
    default: '<DEFAULT>',
    newKey: '' // optional
});

```

Update a float attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value. Cannot be set when required.

- Minimum value.

- Maximum value.

- New Attribute Key.


- Response









  - - [AttributeFloat](https://appwrite.io/docs/references/cloud/models/attributeFloat)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/float/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateFloatAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: null,
    min: null, // optional
    max: null, // optional
    newKey: '' // optional
});

```

Update an integer attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value. Cannot be set when attribute is required.

- Minimum value

- Maximum value

- New Attribute Key.


- Response









  - - [AttributeInteger](https://appwrite.io/docs/references/cloud/models/attributeInteger)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/integer/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateIntegerAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: null,
    min: null, // optional
    max: null, // optional
    newKey: '' // optional
});

```

Update an ip attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value. Cannot be set when attribute is required.

- New Attribute Key.


- Response









  - - [AttributeIP](https://appwrite.io/docs/references/cloud/models/attributeIp)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/ip/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateIpAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '',
    newKey: '' // optional
});

```

Update a line attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#createCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided, two-dimensional array of coordinate pairs, \[\[longitude, latitude\], \[longitude, latitude\], …\], listing the vertices of the line in order. Cannot be set when attribute is required.

- New attribute key.


- Response









  - - [AttributeLine](https://appwrite.io/docs/references/cloud/models/attributeLine)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/line/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateLineAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '', // optional
    newKey: '' // optional
});

```

Update a point attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#createCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided, array of two numbers \[longitude, latitude\], representing a single coordinate. Cannot be set when attribute is required.

- New attribute key.


- Response









  - - [AttributePoint](https://appwrite.io/docs/references/cloud/models/attributePoint)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/point/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updatePointAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '', // optional
    newKey: '' // optional
});

```

Update a polygon attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#createCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided, three-dimensional array where the outer array holds one or more linear rings, \[\[\[longitude, latitude\], …\], …\], the first ring is the exterior boundary, any additional rings are interior holes, and each ring must start and end with the same coordinate pair. Cannot be set when attribute is required.

- New attribute key.


- Response









  - - [AttributePolygon](https://appwrite.io/docs/references/cloud/models/attributePolygon)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/polygon/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updatePolygonAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '', // optional
    newKey: '' // optional
});

```

Update relationship attribute. [Learn more about relationship attributes](https://appwrite.io/docs/databases-relationships#relationship-attributes).

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Constraints option

- New Attribute Key.


- Response









  - - [AttributeRelationship](https://appwrite.io/docs/references/cloud/models/attributeRelationship)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/{key}/relationship

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateRelationshipAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    onDelete: sdk.RelationMutate.Cascade, // optional
    newKey: '' // optional
});

```

Update a string attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID. You can create a new table using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- Maximum size of the string attribute.

- New Attribute Key.


- Response









  - - [AttributeString](https://appwrite.io/docs/references/cloud/models/attributeString)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/string/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateStringAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: '<DEFAULT>',
    size: 1, // optional
    newKey: '' // optional
});

```

Update an url attribute. Changing the `default` value will not update already existing documents.

- Request









- Database ID.

- Collection ID.

- Attribute Key.

- Is attribute required?

- Default value for attribute when not provided. Cannot be set when attribute is required.

- New Attribute Key.


- Response









  - - [AttributeURL](https://appwrite.io/docs/references/cloud/models/attributeUrl)



```web-code text
PATCH /databases/{databaseId}/collections/{collectionId}/attributes/url/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.updateUrlAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    required: false,
    default: 'https://example.com',
    newKey: '' // optional
});

```

Deletes an attribute.

- Request









- Database ID.

- Collection ID.

- Attribute Key.


- Response


```web-code text
DELETE /databases/{databaseId}/collections/{collectionId}/attributes/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.deleteAttribute({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: ''
});

```

Creates an index on the attributes listed. Your index should include all the attributes you will query in a single request.
Attributes can be `key`, `fulltext`, and `unique`.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Index Key.

- Index type.

- Array of attributes to index. Maximum of 100 attributes are allowed, each 32 characters long.

- Array of index orders. Maximum of 100 orders are allowed.

- Length of index. Maximum of 100


- Response









  - - [Index](https://appwrite.io/docs/references/cloud/models/index)



```web-code text
POST /databases/{databaseId}/collections/{collectionId}/indexes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.createIndex({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: '',
    type: sdk.IndexType.Key,
    attributes: [],
    orders: [], // optional
    lengths: [] // optional
});

```

Get index by ID.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Index Key.


- Response









  - - [Index](https://appwrite.io/docs/references/cloud/models/index)



```web-code text
GET /databases/{databaseId}/collections/{collectionId}/indexes/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.getIndex({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: ''
});

```

List indexes in the collection.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: key, type, status, attributes, error


- Response









  - - [Indexes List](https://appwrite.io/docs/references/cloud/models/indexList)



```web-code text
GET /databases/{databaseId}/collections/{collectionId}/indexes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.listIndexes({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    queries: [] // optional
});

```

Delete an index.

- Request









- Database ID.

- Collection ID. You can create a new collection using the Database service [server integration](https://appwrite.io/docs/server/databases#databasesCreateCollection).

- Index Key.


- Response


```web-code text
DELETE /databases/{databaseId}/collections/{collectionId}/indexes/{key}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const databases = new sdk.Databases(client);

const result = await databases.deleteIndex({
    databaseId: '<DATABASE_ID>',
    collectionId: '<COLLECTION_ID>',
    key: ''
});

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Databases API Reference - Docs - Appwrite
