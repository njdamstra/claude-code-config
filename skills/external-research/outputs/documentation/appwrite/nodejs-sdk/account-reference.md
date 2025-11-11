[Skip to content](https://appwrite.io/docs/references/cloud/server-nodejs/account#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Account service allows you to authenticate and manage a user account. You can use the account service to update user information, retrieve the user sessions across different devices, and fetch the user security logs with his or her recent activity.

Register new user accounts with the [Create Account](https://appwrite.io/docs/references/cloud/client-web/account#create), [Create Magic URL session](https://appwrite.io/docs/references/cloud/client-web/account#createMagicURLToken), or [Create Phone session](https://appwrite.io/docs/references/cloud/client-web/account#createPhoneToken) endpoint. You can authenticate the user account by using multiple sign-in methods available. Once the user is authenticated, a new session object will be created to allow the user to access his or her private data and settings.

This service also exposes an endpoint to save and read the [user preferences](https://appwrite.io/docs/references/cloud/client-web/account#updatePrefs) as a key-value object. This feature is handy if you want to allow extra customization in your app. Common usage for this feature may include saving the user's preferred locale, timezone, or custom app theme.

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Use this endpoint to allow a new user to register a new account in your project. After the user registration completes successfully, you can use the [/account/verfication](https://appwrite.io/docs/references/cloud/client-web/account#createVerification) route to start verifying the user email address. To allow the new user to login to their new account, you need to create a new [account session](https://appwrite.io/docs/references/cloud/client-web/account#createEmailSession).

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- User email.

- New user password. Must be between 8 and 256 chars.

- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.create({
    userId: '<USER_ID>',
    email: 'email@example.com',
    password: '',
    name: '<NAME>' // optional
});

```

Get the currently logged in user.

- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
GET /account

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.get();

```

Get the preferences as a key-value object for the currently logged in user.

- Response









  - - [Preferences](https://appwrite.io/docs/references/cloud/models/preferences)



```web-code text
GET /account/prefs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.getPrefs();

```

Update currently logged in user account email address. After changing user address, the user confirmation status will get reset. A new confirmation email is not sent automatically however you can use the send confirmation email endpoint again to send the confirmation email. For security measures, user password is required to complete this request.
This endpoint can also be used to convert an anonymous account to a normal one, by passing an email address and a new password.

- Request









- User email.

- User password. Must be at least 8 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /account/email

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateEmail({
    email: 'email@example.com',
    password: 'password'
});

```

Update currently logged in user account name.

- Request









- User name. Max length: 128 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /account/name

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateName({
    name: '<NAME>'
});

```

Update currently logged in user password. For validation, user is required to pass in the new password, and the old password. For users created with OAuth, Team Invites and Magic URL, oldPassword is optional.

- Request









- New user password. Must be at least 8 chars.

- Current user password. Must be at least 8 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /account/password

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updatePassword({
    password: '',
    oldPassword: 'password' // optional
});

```

Update the currently logged in user's phone number. After updating the phone number, the phone verification status will be reset. A confirmation SMS is not sent automatically, however you can use the [POST /account/verification/phone](https://appwrite.io/docs/references/cloud/client-web/account#createPhoneVerification) endpoint to send a confirmation SMS.

- Request









- Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.

- User password. Must be at least 8 chars.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /account/phone

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updatePhone({
    phone: '+12065550100',
    password: 'password'
});

```

Update currently logged in user account preferences. The object you pass is stored as is, and replaces any previous value. The maximum allowed prefs size is 64kB and throws error if exceeded.

- Request









- Prefs key-value JSON object.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /account/prefs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updatePrefs({
    prefs: {
        "language": "en",
        "timezone": "UTC",
        "darkTheme": true
    }
});

```

Block the currently logged in user account. Behind the scene, the user record is not deleted but permanently blocked from any access. To completely delete a user, use the Users API instead.

- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /account/status

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateStatus();

```

Use this endpoint to allow a new user to register an anonymous account in your project. This route will also create a new session for the user. To allow the new user to convert an anonymous account to a normal account, you need to update its [email and password](https://appwrite.io/docs/references/cloud/client-web/account#updateEmail) or create an [OAuth2 session](https://appwrite.io/docs/references/cloud/client-web/account#CreateOAuth2Session).

- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 50 requests | IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/sessions/anonymous

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createAnonymousSession();

```

Allow the user to login into their account by providing a valid email and password combination. This route will create a new session for the user.

A user is limited to 10 active sessions at a time by default. [Learn more about session limits](https://appwrite.io/docs/authentication-security#limits).

- Request









- User email.

- User password. Must be at least 8 chars.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + EMAIL |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/sessions/email

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createEmailPasswordSession({
    email: 'email@example.com',
    password: 'password'
});

```

Use this endpoint to create a session from token. Provide the **userId** and **secret** parameters from the successful response of authentication flows initiated by token creation. For example, magic URL and phone login.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Secret of a token generated by login methods. For example, the `createMagicURLToken` or `createPhoneToken` methods.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | IP + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/sessions/token

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createSession({
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

```

Use this endpoint to get a logged in user's session using a Session ID. Inputting 'current' will return the current session being used.

- Request









- Session ID. Use the string 'current' to get the current device session.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)



```web-code text
GET /account/sessions/{sessionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.getSession({
    sessionId: '<SESSION_ID>'
});

```

Get the list of active sessions across different devices for the currently logged in user.

- Response









  - - [Sessions List](https://appwrite.io/docs/references/cloud/models/sessionList)



```web-code text
GET /account/sessions

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.listSessions();

```

Use this endpoint to create a session from token. Provide the **userId** and **secret** parameters from the successful response of authentication flows initiated by token creation. For example, magic URL and phone login.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Valid verification token.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | IP + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PUT /account/sessions/magic-url

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.updateMagicURLSession({
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

```

Use this endpoint to create a session from token. Provide the **userId** and **secret** parameters from the successful response of authentication flows initiated by token creation. For example, magic URL and phone login.

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Valid verification token.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | IP + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PUT /account/sessions/phone

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.updatePhoneSession({
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

```

Use this endpoint to extend a session's length. Extending a session is useful when session expiry is short. If the session was created using an OAuth provider, this endpoint refreshes the access token from the provider.

- Request









- Session ID. Use the string 'current' to update the current device session.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PATCH /account/sessions/{sessionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateSession({
    sessionId: '<SESSION_ID>'
});

```

Logout the user. Use 'current' as the session ID to logout on this device, use a session ID to logout on another device. If you're looking to logout the user on all devices, use [Delete Sessions](https://appwrite.io/docs/references/cloud/client-web/account#deleteSessions) instead.

- Request









- Session ID. Use the string 'current' to delete the current device session.


- Response

- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 100 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
DELETE /account/sessions/{sessionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.deleteSession({
    sessionId: '<SESSION_ID>'
});

```

Delete all sessions from the user account and remove any sessions cookies from the end client.

- Response

- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 100 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
DELETE /account/sessions

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.deleteSessions();

```

Sends the user an email with a secret key for creating a session. If the email address has never been used, a **new account is created** using the provided `userId`. Otherwise, if the email address is already attached to an account, the **user ID is ignored**. Then, the user will receive an email with the one-time password. Use the returned user ID and secret and submit a request to the [POST /v1/account/sessions/token](https://appwrite.io/docs/references/cloud/client-web/account#createSession) endpoint to complete the login process. The secret sent to the user's email is valid for 15 minutes.

A user is limited to 10 active sessions at a time by default. [Learn more about session limits](https://appwrite.io/docs/authentication-security#limits).

- Request









- User ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars. If the email address has never been used, a new account is created using the provided userId. Otherwise, if the email address is already attached to an account, the user ID is ignored.

- User email.

- Toggle for security phrase. If enabled, email will be send with a randomly generated phrase and the phrase will also be included in the response. Confirming phrases match increases the security of your authentication flow.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + EMAIL |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/tokens/email

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createEmailToken({
    userId: '<USER_ID>',
    email: 'email@example.com',
    phrase: false // optional
});

```

Use this endpoint to create a JSON Web Token. You can use the resulting JWT to authenticate on behalf of the current user when working with the Appwrite server-side API and SDKs. The JWT secret is valid for 15 minutes from its creation and will be invalid if the user will logout in that time frame.

- Response









  - - [JWT](https://appwrite.io/docs/references/cloud/models/jwt)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 100 requests | URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/jwts

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createJWT();

```

Sends the user an email with a secret key for creating a session. If the provided user ID has not been registered, a new user will be created. When the user clicks the link in the email, the user is redirected back to the URL you provided with the secret key and userId values attached to the URL query string. Use the query string parameters to submit a request to the [POST /v1/account/sessions/token](https://appwrite.io/docs/references/cloud/client-web/account#createSession) endpoint to complete the login process. The link sent to the user's email address is valid for 1 hour.

A user is limited to 10 active sessions at a time by default. [Learn more about session limits](https://appwrite.io/docs/authentication-security#limits).

- Request









- Unique Id. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars. If the email address has never been used, a new account is created using the provided userId. Otherwise, if the email address is already attached to an account, the user ID is ignored.

- User email.

- URL to redirect the user back to your app from the magic URL login. Only URLs from hostnames in your project platform list are allowed. This requirement helps to prevent an [open redirect](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html) attack against your project API.

- Toggle for security phrase. If enabled, email will be send with a randomly generated phrase and the phrase will also be included in the response. Confirming phrases match increases the security of your authentication flow.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 60 requests | URL + EMAIL |
| 60 minutes | 60 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/tokens/magic-url

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createMagicURLToken({
    userId: '<USER_ID>',
    email: 'email@example.com',
    url: 'https://example.com', // optional
    phrase: false // optional
});

```

Allow the user to login to their account using the OAuth2 provider of their choice. Each OAuth2 provider should be enabled from the Appwrite console first. Use the success and failure arguments to provide a redirect URL's back to your app when login is completed.

If authentication succeeds, `userId` and `secret` of a token will be appended to the success URL as query parameters. These can be used to create a new session using the [Create session](https://appwrite.io/docs/references/cloud/client-web/account#createSession) endpoint.

A user is limited to 10 active sessions at a time by default. [Learn more about session limits](https://appwrite.io/docs/authentication-security#limits).

- Request









- OAuth2 Provider. Currently, supported providers are: amazon, apple, auth0, authentik, autodesk, bitbucket, bitly, box, dailymotion, discord, disqus, dropbox, etsy, facebook, figma, github, gitlab, google, linkedin, microsoft, notion, oidc, okta, paypal, paypalSandbox, podio, salesforce, slack, spotify, stripe, tradeshift, tradeshiftBox, twitch, wordpress, yahoo, yammer, yandex, zoho, zoom.

- URL to redirect back to your app after a successful login attempt. Only URLs from hostnames in your project's platform list are allowed. This requirement helps to prevent an [open redirect](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html) attack against your project API.

- URL to redirect back to your app after a failed login attempt. Only URLs from hostnames in your project's platform list are allowed. This requirement helps to prevent an [open redirect](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html) attack against your project API.

- A list of custom OAuth2 scopes. Check each provider internal docs for a list of supported scopes. Maximum of 100 scopes are allowed, each 4096 characters long.


- Response

- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 50 requests | IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
GET /account/tokens/oauth2/{provider}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createOAuth2Token({
    provider: sdk.OAuthProvider.Amazon,
    success: 'https://example.com', // optional
    failure: 'https://example.com', // optional
    scopes: [] // optional
});

```

Sends the user an SMS with a secret key for creating a session. If the provided user ID has not be registered, a new user will be created. Use the returned user ID and secret and submit a request to the [POST /v1/account/sessions/token](https://appwrite.io/docs/references/cloud/client-web/account#createSession) endpoint to complete the login process. The secret sent to the user's phone is valid for 15 minutes.

A user is limited to 10 active sessions at a time by default. [Learn more about session limits](https://appwrite.io/docs/authentication-security#limits).

- Request









- Unique Id. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars. If the phone number has never been used, a new account is created using the provided userId. Otherwise, if the phone number is already attached to an account, the user ID is ignored.

- Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + PHONE |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/tokens/phone

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createPhoneToken({
    userId: '<USER_ID>',
    phone: '+12065550100'
});

```

Get the list of latest security activity logs for the currently logged in user. Each log returns user IP address, location and date and time of log.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Only supported methods are limit and offset


- Response









  - - [Logs List](https://appwrite.io/docs/references/cloud/models/logList)



```web-code text
GET /account/logs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.listLogs({
    queries: [] // optional
});

```

Sends the user an email with a temporary secret key for password reset. When the user clicks the confirmation link he is redirected back to your app password reset URL with the secret key and email address values attached to the URL query string. Use the query string params to submit a request to the [PUT /account/recovery](https://appwrite.io/docs/references/cloud/client-web/account#updateRecovery) endpoint to complete the process. The verification link sent to the user's email address is valid for 1 hour.

- Request









- User email.

- URL to redirect the user back to your app from the recovery email. Only URLs from hostnames in your project platform list are allowed. This requirement helps to prevent an [open redirect](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html) attack against your project API.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + EMAIL |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/recovery

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.createRecovery({
    email: 'email@example.com',
    url: 'https://example.com'
});

```

Use this endpoint to complete the user account password reset. Both the **userId** and **secret** arguments will be passed as query parameters to the redirect URL you have provided when sending your request to the [POST /account/recovery](https://appwrite.io/docs/references/cloud/client-web/account#createRecovery) endpoint.

Please note that in order to avoid a [Redirect Attack](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.md) the only valid redirect URLs are the ones from domains you have set when adding your platforms in the console interface.

- Request









- User ID.

- Valid reset token.

- New user password. Must be between 8 and 256 chars.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PUT /account/recovery

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateRecovery({
    userId: '<USER_ID>',
    secret: '<SECRET>',
    password: ''
});

```

Use this endpoint to send a verification message to your user email address to confirm they are the valid owners of that address. Both the **userId** and **secret** arguments will be passed as query parameters to the URL you have provided to be attached to the verification email. The provided URL should redirect the user back to your app and allow you to complete the verification process by verifying both the **userId** and **secret** parameters. Learn more about how to [complete the verification process](https://appwrite.io/docs/references/cloud/client-web/account#updateVerification). The verification link sent to the user's email address is valid for 7 days.

Please note that in order to avoid a [Redirect Attack](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.md), the only valid redirect URLs are the ones from domains you have set when adding your platforms in the console interface.

- Request









- URL to redirect the user back to your app from the verification email. Only URLs from hostnames in your project platform list are allowed. This requirement helps to prevent an [open redirect](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html) attack against your project API.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/verification

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.createVerification({
    url: 'https://example.com'
});

```

Use this endpoint to send a verification SMS to the currently logged in user. This endpoint is meant for use after updating a user's phone number using the [accountUpdatePhone](https://appwrite.io/docs/references/cloud/client-web/account#updatePhone) endpoint. Learn more about how to [complete the verification process](https://appwrite.io/docs/references/cloud/client-web/account#updatePhoneVerification). The verification code sent to the user's phone number is valid for 15 minutes.

- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + USER ID |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/verification/phone

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.createPhoneVerification();

```

Use this endpoint to complete the user email verification process. Use both the **userId** and **secret** parameters that were attached to your app URL to verify the user email ownership. If confirmed this route will return a 200 status code.

- Request









- User ID.

- Valid verification token.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PUT /account/verification

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateVerification({
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

```

Use this endpoint to complete the user phone verification process. Use the **userId** and **secret** that were sent to your user's phone number to verify the user email ownership. If confirmed this route will return a 200 status code.

- Request









- User ID.

- Valid verification token.


- Response









  - - [Token](https://appwrite.io/docs/references/cloud/models/token)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PUT /account/verification/phone

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updatePhoneVerification({
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

```

Add an authenticator app to be used as an MFA factor. Verify the authenticator using the [verify authenticator](https://appwrite.io/docs/references/cloud/client-web/account#updateMfaAuthenticator) method.

- Request









- Type of authenticator. Must be `totp`


- Response









  - - [MFAType](https://appwrite.io/docs/references/cloud/models/mfaType)



```web-code text
POST /account/mfa/authenticators/{type}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.createMFAAuthenticator({
    type: sdk.AuthenticatorType.Totp
});

```

Begin the process of MFA verification after sign-in. Finish the flow with [updateMfaChallenge](https://appwrite.io/docs/references/cloud/client-web/account#updateMfaChallenge) method.

- Request









- Factor used for verification. Must be one of following: `email`, `phone`, `totp`, `recoveryCode`.


- Response









  - - [MFA Challenge](https://appwrite.io/docs/references/cloud/models/mfaChallenge)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /account/mfa/challenge

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const account = new sdk.Account(client);

const result = await account.createMFAChallenge({
    factor: sdk.AuthenticationFactor.Email
});

```

Generate recovery codes as backup for MFA flow. It's recommended to generate and show then immediately after user successfully adds their authehticator. Recovery codes can be used as a MFA verification type in [createMfaChallenge](https://appwrite.io/docs/references/cloud/client-web/account#createMfaChallenge) method.

- Response









  - - [MFA Recovery Codes](https://appwrite.io/docs/references/cloud/models/mfaRecoveryCodes)



```web-code text
POST /account/mfa/recovery-codes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.createMFARecoveryCodes();

```

List the factors available on the account to be used as a MFA challange.

- Response









  - - [MFAFactors](https://appwrite.io/docs/references/cloud/models/mfaFactors)



```web-code text
GET /account/mfa/factors

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.listMFAFactors();

```

Get recovery codes that can be used as backup for MFA flow. Before getting codes, they must be generated using [createMfaRecoveryCodes](https://appwrite.io/docs/references/cloud/client-web/account#createMfaRecoveryCodes) method. An OTP challenge is required to read recovery codes.

- Response









  - - [MFA Recovery Codes](https://appwrite.io/docs/references/cloud/models/mfaRecoveryCodes)



```web-code text
GET /account/mfa/recovery-codes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.getMFARecoveryCodes();

```

Verify an authenticator app after adding it using the [add authenticator](https://appwrite.io/docs/references/cloud/client-web/account#createMfaAuthenticator) method.

- Request









- Type of authenticator.

- Valid verification token.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PUT /account/mfa/authenticators/{type}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateMFAAuthenticator({
    type: sdk.AuthenticatorType.Totp,
    otp: '<OTP>'
});

```

Enable or disable MFA on an account.

- Request









- Enable or disable MFA.


- Response









  - - [User](https://appwrite.io/docs/references/cloud/models/user)



```web-code text
PATCH /account/mfa

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateMFA({
    mfa: false
});

```

Complete the MFA challenge by providing the one-time password. Finish the process of MFA verification by providing the one-time password. To begin the flow, use [createMfaChallenge](https://appwrite.io/docs/references/cloud/client-web/account#createMfaChallenge) method.

- Request









- ID of the challenge.

- Valid verification token.


- Response









  - - [Session](https://appwrite.io/docs/references/cloud/models/session)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PUT /account/mfa/challenge

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateMFAChallenge({
    challengeId: '<CHALLENGE_ID>',
    otp: '<OTP>'
});

```

Regenerate recovery codes that can be used as backup for MFA flow. Before regenerating codes, they must be first generated using [createMfaRecoveryCodes](https://appwrite.io/docs/references/cloud/client-web/account#createMfaRecoveryCodes) method. An OTP challenge is required to regenreate recovery codes.

- Response









  - - [MFA Recovery Codes](https://appwrite.io/docs/references/cloud/models/mfaRecoveryCodes)



```web-code text
PATCH /account/mfa/recovery-codes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.updateMFARecoveryCodes();

```

Delete an authenticator for a user by ID.

- Request









- Type of authenticator.


- Response


```web-code text
DELETE /account/mfa/authenticators/{type}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.deleteMFAAuthenticator({
    type: sdk.AuthenticatorType.Totp
});

```

Get the list of identities for the currently logged in user.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: userId, provider, providerUid, providerEmail, providerAccessTokenExpiry


- Response









  - - [Identities List](https://appwrite.io/docs/references/cloud/models/identityList)



```web-code text
GET /account/identities

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.listIdentities({
    queries: [] // optional
});

```

Delete an identity by its unique ID.

- Request









- Identity ID.


- Response


```web-code text
DELETE /account/identities/{identityId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const account = new sdk.Account(client);

const result = await account.deleteIdentity({
    identityId: '<IDENTITY_ID>'
});

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
