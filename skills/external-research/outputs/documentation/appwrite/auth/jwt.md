[Skip to content](https://appwrite.io/docs/products/auth/jwt#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

You can extend Appwrite's APIs by building backend apps using [Server SDKs](https://appwrite.io/docs/sdks#server). To secure your backend app's APIs, client apps must prove their identity against your backend app before accessing sensitive information. You can secure these APIs and enforce access permissions in your backend app by using JWT authentication.

If you are already authenticated on your client-side app and need your backend app to **act on behalf of the user**, this guide will walk you through the process.

## [Proof of Identity](https://appwrite.io/docs/products/auth/jwt\#proof-of-identity)

Before making requests to your backend APIs, your client application needs to first create a session **directly with Appwrite** using the account service. This session will act like an ID card for the user and can be used to access resources in Appwrite. The client will **only receive information accessible to the user** based on the resources' [permissions](https://appwrite.io/docs/advanced/platform/permissions).

When you build backend APIs to extend Appwrite's functionality, these APIs should still **respect access permissions** to keep user data secure. Appwrite's backend SDKs allow you to securely act on behalf of a user with the same permissions by using JWT authentication.

## [JWT Authentication](https://appwrite.io/docs/products/auth/jwt\#jwt)

[JSON Web Tokens](https://jwt.io/introduction) (JWTs) are a secure means to transfer information or claims between two parties. JWTs act like temporary copies of the user's ID card that allow Appwrite's Server SDKs to access information on behalf of a user.

You need to create a session using the Client SDKs **before** generating a JWT. The JWT will be a stateless proof of claim for the identity of the authenticated user and expire after 15 minutes or when the session is deleted.

You can generate a JWT like this on a [Client SDK](https://appwrite.io/docs/sdks#client).

```web-code client-web line-numbers
import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const user = await account.createJWT();

```

Your server application can use the JWT to act on behalf of the user by creating a `Client` instance with the JWT for **each request it receives**. To keep your API secure, **discard the client object** after each request.

Use JWTs tokens like this in a [Server SDK](https://appwrite.io/docs/sdks#server).

```web-code js line-numbers
const { Client } = require('node-appwrite');

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>')                  // Your project ID
    .setJWT('eyJJ9.eyJ...886ca');                // Your secret JSON Web Token

```

## [When should I use JWTs?](https://appwrite.io/docs/products/auth/jwt\#when-to-use)

JWT auth is useful when you need your backend app's Server SDK to be restricted by the same set of permissions.

If your backend app's Server SDK is using an [API key](https://appwrite.io/docs/advanced/platform/api-keys), it will fetch **all resources** regardless of permissions. This means the Server SDK might fetch files and rows your user should not be able to see, which is not helpful when you need to act on behalf of a user.

If your backend app's Server SDK is using a **JWT**, it will only fetch resources your user has permissions to access.

## [Example](https://appwrite.io/docs/products/auth/jwt\#when-to-use-example)

Here's an example table of birthdays with the following rows. Notice how they all have **different permissions**.

| $id | name | birthday | $permissions |
| --- | --- | --- | --- |
| ac5fc866ad1e | Kevin | 2012-02-03 | "read("user:user-a")" |
| bc7fc866ad1e | Laura | 1999-09-22 | "read("user:user-b")" |
| cc2fc886ad1e | Bob | 1982-05-11 | "read("user:user-c")" |

If you're authenticated on the client-side as `user-a` and created a JWT `'eyJJ9.eyJ...886ca'`, you can pass this JWT to a Server SDK on the backend server to fetch only the birthdays `user-a` can read.

```web-code js line-numbers
const { Client } = require('node-appwrite');

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>')                  // Your project ID
    .setJWT('eyJJ9.eyJ...886ca');                // Your secret JSON Web Token

const tablesDB = new sdk.TablesDB(client);

const rows = await tablesDB.listRows({
    databaseId: '642f358bf4084c662590',
    tableId: '642f3592aa5fc856ad1e'
});
// ... More code to manipulate the results

```

Only Kevin's birthday is returned and rows where `user-A` has no permissions to access are not returned.

```web-code js line-numbers
{
  "total": 1,
  "rows": [\
    {\
      "name": "Kevin",\
      "birthday": "2012-02-03T00:00:00.000+00:00",\
      "$id": "ac5fc866ad1e",\
      "$permissions": [\
        "read(\"user:user-a\")"\
      ],\
      "$tableId": "642f3592aa5fc856ad1e",\
      "$databaseId": "642f358bf4084c662590",\
      ...\
    }\
  ]
}

```

If the same request is made where the [Server SDK](https://appwrite.io/docs/sdks#server)'s `client` is authenticated with an API key instead of a JWT, the results returned will be different.

```web-code js line-numbers
const { Client } = require('node-appwrite');

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>')                  // Your project ID
    .setKey('98fd4...a2ad2');                    // Your secret API key

const tablesDB = new sdk.TablesDB(client);

const rows = await tablesDB.listRows({
    databaseId: '642f358bf4084c662590',
    tableId: '642f3592aa5fc856ad1e'
});
// ... More code to manipulate the results

```

This will return every row regardless of permissions, which could lead to privacy and security problems.

```web-code json line-numbers
{
  "total": 3,
  "rows": [\
    {\
      "name": "Kevin",\
      "birthday": "2012-02-03T00:00:00.000+00:00",\
      "$id": "ac5fc866ad1e",\
      "$permissions": [\
        "read(\"user:user-a\")"\
      ],\
      "$tableId": "642f3592aa5fc856ad1e",\
      "$databaseId": "642f358bf4084c662590",\
      ...\
    },\
    {\
      "name": "Laura",\
      "birthday": "1999-09-22T11:21:23.334+00:00",\
      "$id": "bc7fc866ad1e",\
      "$permissions": [\
        "read(\"user:user-b\")"\
      ],\
      "$tableId": "642f3592aa5fc856ad1e",\
      "$databaseId": "642f358bf4084c662590",\
      ...\
    },\
    {\
      "name": "Bob",\
      "birthday": "1982-05-11T12:31:39.381+00:00",\
      "$id": "cc2fc886ad1e",\
      "$permissions": [\
        "read(\"user:user-c\")"\
      ],\
      "$tableId": "642f3592aa5fc856ad1e",\
      "$databaseId": "642f358bf4084c662590",\
      ...\
    }\
  ]
}

```

If you're integrating existing backend services with Appwrite or adding backend endpoints to perform more complex logic, JWT authentication helps them behave similarly to actual Appwrite endpoints.

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
