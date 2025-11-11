[Skip to content](https://appwrite.io/docs/references/cloud/server-nodejs/users#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Users service allows you to manage your project users. Use this service to search, block, and view your users' info, current sessions, and latest activity logs. You can also use the Users service to edit your users' preferences and personal info.

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Create a new user.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.

- Plain text user password. Must be at least 8 chars.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.create({
    userId: '<USER_ID>',
    email: 'email@example.com', // optional
    phone: '+12065550100', // optional
    password: '', // optional
    name: '<NAME>' // optional
});

```

Create a new user. Password provided must be hashed with the [Argon2](https://en.wikipedia.org/wiki/Argon2) algorithm. Use the [POST /users](https://appwrite.io/docs/server/users#usersCreate) endpoint to create users with a plain text password.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- User password hashed using Argon2.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users/argon2

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createArgon2User({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: 'password',
    name: '<NAME>' // optional
});

```

Create a new user. Password provided must be hashed with the [Bcrypt](https://en.wikipedia.org/wiki/Bcrypt) algorithm. Use the [POST /users](https://appwrite.io/docs/server/users#usersCreate) endpoint to create users with a plain text password.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- User password hashed using Bcrypt.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users/bcrypt

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createBcryptUser({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: 'password',
    name: '<NAME>' // optional
});

```

Create a new user. Password provided must be hashed with the [MD5](https://en.wikipedia.org/wiki/MD5) algorithm. Use the [POST /users](https://appwrite.io/docs/server/users#usersCreate) endpoint to create users with a plain text password.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- User password hashed using MD5.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users/md5

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createMD5User({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: 'password',
    name: '<NAME>' // optional
});

```

Create a new user. Password provided must be hashed with the [PHPass](https://www.openwall.com/phpass/) algorithm. Use the [POST /users](https://appwrite.io/docs/server/users#usersCreate) endpoint to create users with a plain text password.

- Request









- User ID. Choose a custom ID or pass the string `ID.unique()` to auto generate it. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- User password hashed using PHPass.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users/phpass

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createPHPassUser({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: 'password',
    name: '<NAME>' // optional
});

```

Create a new user. Password provided must be hashed with the [Scrypt Modified](https://gist.github.com/Meldiron/eecf84a0225eccb5a378d45bb27462cc) algorithm. Use the [POST /users](https://appwrite.io/docs/server/users#usersCreate) endpoint to create users with a plain text password.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- User password hashed using Scrypt Modified.

- Salt used to hash password.

- Salt separator used to hash password.

- Signer key used to hash password.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users/scrypt-modified

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createScryptModifiedUser({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: 'password',
    passwordSalt: '<PASSWORD_SALT>',
    passwordSaltSeparator: '<PASSWORD_SALT_SEPARATOR>',
    passwordSignerKey: '<PASSWORD_SIGNER_KEY>',
    name: '<NAME>' // optional
});

```

Create a new user. Password provided must be hashed with the [Scrypt](https://github.com/Tarsnap/scrypt) algorithm. Use the [POST /users](https://appwrite.io/docs/server/users#usersCreate) endpoint to create users with a plain text password.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- User password hashed using Scrypt.

- Optional salt used to hash password.

- Optional CPU cost used to hash password.

- Optional memory cost used to hash password.

- Optional parallelization cost used to hash password.

- Optional hash length used to hash password.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users/scrypt

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createScryptUser({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: 'password',
    passwordSalt: '<PASSWORD_SALT>',
    passwordCpu: null,
    passwordMemory: null,
    passwordParallel: null,
    passwordLength: null,
    name: '<NAME>' // optional
});

```

Create a new user. Password provided must be hashed with the [SHA](https://en.wikipedia.org/wiki/Secure_Hash_Algorithm) algorithm. Use the [POST /users](https://appwrite.io/docs/server/users#usersCreate) endpoint to create users with a plain text password.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- User password hashed using SHA.

- Optional SHA version used to hash password. Allowed values are: 'sha1', 'sha224', 'sha256', 'sha384', 'sha512/224', 'sha512/256', 'sha512', 'sha3-224', 'sha3-256', 'sha3-384', 'sha3-512'

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
POST /users/sha

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createSHAUser({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: 'password',
    passwordVersion: sdk.PasswordHash.Sha1, // optional
    name: '<NAME>' // optional
});

```

Get a user by its unique ID.

- Request









- User ID.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
GET /users/{userId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.get({
    userId: '<USER_ID>'
});

```

Get the user preferences by its unique ID.

- Request









- User ID.


- Response









  - - [Preferences](https://appwrite.io/docs/references/cloud/models/preferences)



```web-code text
GET /users/{userId}/prefs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.getPrefs({
    userId: '<USER_ID>'
});

```

Get a list of all the project's users. You can use the query params to filter your results.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, email, phone, status, passwordUpdate, registration, emailVerification, phoneVerification, labels

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Users List](https://appwrite.io/docs/references/cloud/models/userList)



```web-code text
GET /users

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.list({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update the user email by its unique ID.

- Request









- User ID.

- User email.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/email

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateEmail({
    userId: '<USER_ID>',
    email: 'email@example.com'
});

```

Update the user email verification status by its unique ID.

- Request









- User ID.

- User email verification status.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/verification

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateEmailVerification({
    userId: '<USER_ID>',
    emailVerification: false
});

```

Enable or disable MFA on a user account.

- Request









- User ID.

- Enable or disable MFA.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/mfa

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateMFA({
    userId: '<USER_ID>',
    mfa: false
});

```

Update the user name by its unique ID.

- Request









- User ID.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/name

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateName({
    userId: '<USER_ID>',
    name: '<NAME>'
});

```

Update the user password by its unique ID.

- Request









- User ID.

- New user password. Must be at least 8 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/password

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updatePassword({
    userId: '<USER_ID>',
    password: ''
});

```

Update the user phone by its unique ID.

- Request









- User ID.

- User phone number.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/phone

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updatePhone({
    userId: '<USER_ID>',
    number: '+12065550100'
});

```

Update the user phone verification status by its unique ID.

- Request









- User ID.

- User phone verification status.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/verification/phone

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updatePhoneVerification({
    userId: '<USER_ID>',
    phoneVerification: false
});

```

Update the user labels by its unique ID.

Labels can be used to grant access to resources. While teams are a way for user's to share access to a resource, labels can be defined by the developer to grant access without an invitation. See the [Permissions docs](https://appwrite.io/docs/permissions) for more info.

- Request









- User ID.

- Array of user labels. Replaces the previous labels. Maximum of 1000 labels are allowed, each up to 36 alphanumeric characters long.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PUT /users/{userId}/labels

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateLabels({
    userId: '<USER_ID>',
    labels: []
});

```

Update the user preferences by its unique ID. The object you pass is stored as is, and replaces any previous value. The maximum allowed prefs size is 64kB and throws error if exceeded.

- Request









- User ID.

- Prefs key-value JSON object.


- Response









  - - [Preferences](https://appwrite.io/docs/references/cloud/models/preferences)



```web-code text
PATCH /users/{userId}/prefs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updatePrefs({
    userId: '<USER_ID>',
    prefs: {}
});

```

Update the user status by its unique ID. Use this endpoint as an alternative to deleting a user if you want to keep user's ID reserved.

- Request









- User ID.

- User Status. To activate the user pass `true` and to block the user pass `false`.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /users/{userId}/status

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateStatus({
    userId: '<USER_ID>',
    status: false
});

```

Delete a user by its unique ID, thereby releasing it's ID. Since ID is released and can be reused, all user-related resources like documents or storage files should be deleted before user deletion. If you want to keep ID reserved, use the [updateStatus](https://appwrite.io/docs/server/users#usersUpdateStatus) endpoint instead.

- Request









- User ID.


- Response


```web-code text
DELETE /users/{userId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.delete({
    userId: '<USER_ID>'
});

```

Create a messaging target.

- Request









- User ID.

- Target ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- The target provider type. Can be one of the following: `email`, `sms` or `push`.

- The target identifier (token, email, phone etc.)

- Provider ID. Message will be sent to this target from the specified provider ID. If no provider ID is set the first setup provider will be used.

- Target name. Max length: 128 chars. For example: My Awesome App Galaxy S23.


- Response









  - - [Target](https://appwrite.io/docs/references/cloud/models/target)



```web-code text
POST /users/{userId}/targets

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createTarget({
    userId: '<USER_ID>',
    targetId: '<TARGET_ID>',
    providerType: sdk.MessagingProviderType.Email,
    identifier: '<IDENTIFIER>',
    providerId: '<PROVIDER_ID>', // optional
    name: '<NAME>' // optional
});

```

Get a user's push notification target by ID.

- Request









- User ID.

- Target ID.


- Response









  - - [Target](https://appwrite.io/docs/references/cloud/models/target)



```web-code text
GET /users/{userId}/targets/{targetId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.getTarget({
    userId: '<USER_ID>',
    targetId: '<TARGET_ID>'
});

```

List the messaging targets that are associated with a user.

- Request









- User ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: userId, providerId, identifier, providerType


- Response









  - - [Target list](https://appwrite.io/docs/references/cloud/models/targetList)



```web-code text
GET /users/{userId}/targets

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.listTargets({
    userId: '<USER_ID>',
    queries: [] // optional
});

```

Update a messaging target.

- Request









- User ID.

- Target ID.

- The target identifier (token, email, phone etc.)

- Provider ID. Message will be sent to this target from the specified provider ID. If no provider ID is set the first setup provider will be used.

- Target name. Max length: 128 chars. For example: My Awesome App Galaxy S23.


- Response









  - - [Target](https://appwrite.io/docs/references/cloud/models/target)



```web-code text
PATCH /users/{userId}/targets/{targetId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateTarget({
    userId: '<USER_ID>',
    targetId: '<TARGET_ID>',
    identifier: '<IDENTIFIER>', // optional
    providerId: '<PROVIDER_ID>', // optional
    name: '<NAME>' // optional
});

```

Delete a messaging target.

- Request









- User ID.

- Target ID.


- Response


```web-code text
DELETE /users/{userId}/targets/{targetId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.deleteTarget({
    userId: '<USER_ID>',
    targetId: '<TARGET_ID>'
});

```

Creates a session for a user. Returns an immediately usable session object.

If you want to generate a token for a custom authentication flow, use the [POST /users/{userId}/tokens](https://appwrite.io/docs/server/users#createToken) endpoint.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)



```web-code text
POST /users/{userId}/sessions

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createSession({
    userId: '<USER_ID>'
});

```

Returns a token with a secret key for creating a session. Use the user ID and secret and submit a request to the [PUT /account/sessions/token](https://appwrite.io/docs/references/cloud/client-web/account#createSession) endpoint to complete the login process.

- Request









- User ID.

- Token length in characters. The default length is 6 characters

- Token expiration period in seconds. The default expiration is 15 minutes.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)



```web-code text
POST /users/{userId}/tokens

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createToken({
    userId: '<USER_ID>',
    length: 4, // optional
    expire: 60 // optional
});

```

Use this endpoint to create a JSON Web Token for user by its unique ID. You can use the resulting JWT to authenticate on behalf of the user. The JWT secret will become invalid if the session it uses gets deleted.

- Request









- User ID.

- Session ID. Use the string 'recent' to use the most recent session. Defaults to the most recent session.

- Time in seconds before JWT expires. Default duration is 900 seconds, and maximum is 3600 seconds.


- Response









  - - [JWT](https://appwrite.io/docs/references/cloud/models/jwt)



```web-code text
POST /users/{userId}/jwts

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createJWT({
    userId: '<USER_ID>',
    sessionId: '<SESSION_ID>', // optional
    duration: 0 // optional
});

```

Get the user sessions list by its unique ID.

- Request









- User ID.


- Response









  - - [Sessions List](https://appwrite.io/docs/references/cloud/models/sessionList)



```web-code text
GET /users/{userId}/sessions

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.listSessions({
    userId: '<USER_ID>'
});

```

Delete a user sessions by its unique ID.

- Request









- User ID.

- Session ID.


- Response


```web-code text
DELETE /users/{userId}/sessions/{sessionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.deleteSession({
    userId: '<USER_ID>',
    sessionId: '<SESSION_ID>'
});

```

Delete all user's sessions by using the user's unique ID.

- Request









- User ID.


- Response


```web-code text
DELETE /users/{userId}/sessions

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.deleteSessions({
    userId: '<USER_ID>'
});

```

Get the user membership list by its unique ID.

- Request









- User ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: userId, teamId, invited, joined, confirm, roles

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Memberships List](https://appwrite.io/docs/references/cloud/models/membershipList)



```web-code text
GET /users/{userId}/memberships

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.listMemberships({
    userId: '<USER_ID>',
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Get the user activity logs list by its unique ID.

- Request









- User ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Only supported methods are limit and offset


- Response









  - - [Logs List](https://appwrite.io/docs/references/cloud/models/logList)



```web-code text
GET /users/{userId}/logs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.listLogs({
    userId: '<USER_ID>',
    queries: [] // optional
});

```

Get identities for all users.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: userId, provider, providerUid, providerEmail, providerAccessTokenExpiry

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Identities List](https://appwrite.io/docs/references/cloud/models/identityList)



```web-code text
GET /users/identities

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.listIdentities({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Delete an identity by its unique ID.

- Request









- Identity ID.


- Response


```web-code text
DELETE /users/identities/{identityId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.deleteIdentity({
    identityId: '<IDENTITY_ID>'
});

```

Generate recovery codes used as backup for MFA flow for User ID. Recovery codes can be used as a MFA verification type in [createMfaChallenge](https://appwrite.io/docs/references/cloud/client-web/account#createMfaChallenge) method by client SDK.

- Request









- User ID.


- Response









  - - [MFA Recovery Codes](https://appwrite.io/docs/references/cloud/models/mfaRecoveryCodes)



```web-code text
PATCH /users/{userId}/mfa/recovery-codes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.createMFARecoveryCodes({
    userId: '<USER_ID>'
});

```

Get recovery codes that can be used as backup for MFA flow by User ID. Before getting codes, they must be generated using [createMfaRecoveryCodes](https://appwrite.io/docs/references/cloud/client-web/account#createMfaRecoveryCodes) method.

- Request









- User ID.


- Response









  - - [MFA Recovery Codes](https://appwrite.io/docs/references/cloud/models/mfaRecoveryCodes)



```web-code text
GET /users/{userId}/mfa/recovery-codes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.getMFARecoveryCodes({
    userId: '<USER_ID>'
});

```

List the factors available on the account to be used as a MFA challange.

- Request









- User ID.


- Response









  - - [MFAFactors](https://appwrite.io/docs/references/cloud/models/mfaFactors)



```web-code text
GET /users/{userId}/mfa/factors

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.listMFAFactors({
    userId: '<USER_ID>'
});

```

Regenerate recovery codes that can be used as backup for MFA flow by User ID. Before regenerating codes, they must be first generated using [createMfaRecoveryCodes](https://appwrite.io/docs/references/cloud/client-web/account#createMfaRecoveryCodes) method.

- Request









- User ID.


- Response









  - - [MFA Recovery Codes](https://appwrite.io/docs/references/cloud/models/mfaRecoveryCodes)



```web-code text
PUT /users/{userId}/mfa/recovery-codes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.updateMFARecoveryCodes({
    userId: '<USER_ID>'
});

```

Delete an authenticator app.

- Request









- User ID.

- Type of authenticator.


- Response


```web-code text
DELETE /users/{userId}/mfa/authenticators/{type}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const users = new sdk.Users(client);

const result = await users.deleteMFAAuthenticator({
    userId: '<USER_ID>',
    type: sdk.AuthenticatorType.Totp
});

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Users API Reference - Docs - Appwrite
