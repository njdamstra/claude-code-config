[Skip to content](https://appwrite.io/docs/advanced/platform/api-keys#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

API keys are secrets used by Appwrite [Server SDKs](https://appwrite.io/docs/sdks#server) and the Appwrite CLI to prove their identity. What can be accessed each API key is restricted by [scopes](https://appwrite.io/docs/advanced/platform/api-keys#scopes) instead of permissions.

##### Best practice

It is a best practice to grant only the scopes you need to meet your project's goals to an API key. API keys should be treated as a secret. Never share the API key and keep API keys out of client applications.

## [Create API key](https://appwrite.io/docs/advanced/platform/api-keys\#create-api-key)

![Project settings screen](https://appwrite.io/images/docs/platform/dark/create-api-key.png)

![Project settings screen](https://appwrite.io/images/docs/platform/create-api-key.png)

To create a new API key, navigate to **Overview** \> **Integration** \> **API keys** and click **Create API key**.

When adding a new API Key, you can choose which [scopes](https://appwrite.io/docs/advanced/platform/api-keys#scopes) to grant your application. If you need to replace your API Key, create a new key, update your app credentials and, once ready, delete your old key.

## [Scopes](https://appwrite.io/docs/advanced/platform/api-keys\#scopes)

| Name | Description |
| --- | --- |
| `users.read` | Access to read your project's users |
| `users.write` | Access to create, update, and delete your project's users |
| `teams.read` | Access to read your project's teams |
| `teams.write` | Access to create, update, and delete your project's teams |
| `databases.read` | Access to read your project's databases |
| `databases.write` | Access to create, update, and delete your project's databases |
| `tables.read` | Access to read your project's database tables |
| `tables.write` | Access to create, update, and delete your project's database tables |
| `columns.read` | Access to read your project's database table's columns |
| `columns.write` | Access to create, update, and delete your project's database table's columns |
| `indexes.read` | Access to read your project's database table's indexes |
| `indexes.write` | Access to create, update, and delete your project's database table's indexes |
| `rows.read` | Access to read your project's database rows |
| `rows.write` | Access to create, update, and delete your project's database rows |
| `files.read` | Access to read your project's storage files and preview images |
| `files.write` | Access to create, update, and delete your project's storage files |
| `buckets.read` | Access to read your project's storage buckets |
| `buckets.write` | Access to create, update, and delete your project's storage buckets |
| `functions.read` | Access to read your project's functions and code deployments |
| `functions.write` | Access to create, update, and delete your project's functions and code deployments |
| `execution.read` | Access to read your project's execution logs |
| `execution.write` | Access to execute your project's functions |
| `locale.read` | Access to access your project's Locale service |
| `avatars.read` | Access to access your project's Avatars service |
| `health.read` | Access to read your project's health status |
| `rules.read` | Access to read your project's proxy rules |
| `rules.write` | Access to create, update, and delete your project's proxy rules |
| `migrations.read` | Access to read your project's migrations |
| `migrations.write` | Access to create, update, and delete your project's migrations |
| `vcs.read` | Access to read your project's VCS repositories |
| `vcs.write` | Access to create, update, and delete your project's VCS repositories |
| `assistant.read` | Access to read the Assistant service |

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
