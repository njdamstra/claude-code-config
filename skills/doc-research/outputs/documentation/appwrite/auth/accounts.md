[Skip to content](https://appwrite.io/docs/products/auth/accounts#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Appwrite Account API is used for user signup and login in client applications. Users can be organized into teams and be given labels, so they can be given different permissions and access different resources.

##### Account vs Users API

The Account API is the API you should use in your **client applications** with [Client SDKs](https://appwrite.io/docs/sdks#client) like web, Flutter, mobile, and native apps. Account API creates sessions, which represent an authenticated user and is attached to a user's [account](https://appwrite.io/docs/products/auth/accounts). Sessions respect [permissions](https://appwrite.io/docs/advanced/platform/permissions), which means users can only access resources if they have been granted the correct permissions.

The Users API is a dedicated API for managing users from an admin's perspective. It should be used with backend or server-side applications with [Server SDKs](https://appwrite.io/docs/sdks#server). Users API uses API keys instead of sessions. This means they're not restricted by permissions, but by the scopes granted to the API key used.

## [Signup and login](https://appwrite.io/docs/products/auth/accounts\#signup-login)

You can signup and login a user with an account create through [email password](https://appwrite.io/docs/products/auth/email-password), [phone (SMS)](https://appwrite.io/docs/products/auth/phone-sms), [Anonymous](https://appwrite.io/docs/products/auth/anonymous), [magic URL](https://appwrite.io/docs/products/auth/magic-url), and [OAuth 2](https://appwrite.io/docs/products/auth/oauth2) authentication.

## [Permissions](https://appwrite.io/docs/products/auth/accounts\#permissions)

You can grant permissions to all users using the `Role.users(<STATUS>)` role or individual users using the `Role.user(<USER_ID>, <STATUS>)` role.

| Description | Role |
| --- | --- |
| Verified users | `Role.users('verified')` |
| Unverified users | `Role.users('unverified')` |
| Verified user | `Role.user(<USER_ID>, 'verified')` |
| Unverified user | `Role.user(<USER_ID>, 'unverified')` |

[Learn more about permissions](https://appwrite.io/docs/advanced/platform/permissions)

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
