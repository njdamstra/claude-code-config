[Skip to content](https://appwrite.io/docs/advanced/platform/webhooks#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Webhooks allow you to build or set up integrations which subscribe to certain events on Appwrite. When one of those events is triggered, we'll send an HTTP POST payload to the webhook's configured URL. Webhooks can be used to purge cache from CDN, calculate data or send a Slack notification. You're only limited by your imagination.

## [Getting started](https://appwrite.io/docs/advanced/platform/webhooks\#getting-started)

You can set your webhook by adding it from your Appwrite project dashboard. You can access your webhooks settings from your project dashboard or on the left navigation panel. Click the 'Add Webhook' button and choose your webhook name and the events that should trigger it. You can also set an optional basic HTTP authentication username and password to protect your endpoint from unauthorized access.

## [Payload](https://appwrite.io/docs/advanced/platform/webhooks\#payload)

Each event type has a specific payload format with the relevant event information. All event payloads mirror the payloads for the API payload which parallel to the [event types](https://appwrite.io/docs/advanced/platform/events).

## [Headers](https://appwrite.io/docs/advanced/platform/webhooks\#headers)

HTTP requests made to your webhook's configured URL endpoint will contain several special headers.

| Header | Description |
| --- | --- |
| X-Appwrite-Webhook-Id | The ID of the Webhook who triggered the event. |
| X-Appwrite-Webhook-Events | Names of the events that triggered this delivery. |
| X-Appwrite-Webhook-Name | Name of the webhook as specified in your app settings and [events list](https://appwrite.io/docs/advanced/platform/events). |
| X-Appwrite-Webhook-User-Id | The user ID of the user who triggered the event. Returns an empty string if an API key triggered the event. Note that events like `account.create` or `account.sessions.create` are performed by guest users and will not return any user ID. If you still need the user ID for these events, you can find it in the event payload. |
| X-Appwrite-Webhook-Project-Id | The ID of the project who owns the Webhook and API call. |
| X-Appwrite-Webhook-Signature | The HMAC-SHA1 signature of the payload. This is used to verify the authenticity of the payload. |
| User-Agent | Each request made by Appwrite will be 'Appwrite-Server'. |

## [Verification](https://appwrite.io/docs/advanced/platform/webhooks\#verification)

Webhooks can be verified by using the [X-Appwrite-Webhook-Signature](https://appwrite.io/docs/advanced/platform/webhooks#headers) header. This is the HMAC-SHA1 signature of the payload. You can find the signature key in your webhooks properties in the dashboard. To generate this hash you append the payload to the end of webhook URL (make sure there are no spaces in between) and then use the HMAC-SHA1 algorithm to generate the signature. After you've generated the signature, compare it to the `X-Appwrite-Webhook-Signature` header value. If they match, the payload is valid and you can trust it came from your Appwrite instance.

## [Events](https://appwrite.io/docs/advanced/platform/webhooks\#events)

Appwrite has events that fire when a resource changes. These events cover all Appwrite resources and can reflect create, update, and delete actions. You can specify one or many events to subscribe to with webhooks.

- Authentication events




| Name | Description |
| --- | --- |
| `teams.*` | This event triggers on any teams event. Returns [Team Object](https://appwrite.io/docs/references/cloud/models/team) |
| `teams.*.create` | This event triggers when a team is created. Returns [Team Object](https://appwrite.io/docs/references/cloud/models/team) |
| `teams.*.delete` | This event triggers when a team is deleted. Returns [Team Object](https://appwrite.io/docs/references/cloud/models/team) |
| `teams.*.memberships.*` | This event triggers on any team memberships event. Returns [Membership Object](https://appwrite.io/docs/references/cloud/models/membership) |
| `teams.*.memberships.*.create` | This event triggers when a membership is created. Returns [Membership Object](https://appwrite.io/docs/references/cloud/models/membership) |
| `teams.*.memberships.*.delete` | This event triggers when a membership is deleted. Returns [Membership Object](https://appwrite.io/docs/references/cloud/models/membership) |
| `teams.*.memberships.*.update` | This event triggers when a membership is updated. Returns [Membership Object](https://appwrite.io/docs/references/cloud/models/membership) |
| `teams.*.memberships.*.update.status` | This event triggers when a team memberships status is updated. Returns [Membership Object](https://appwrite.io/docs/references/cloud/models/membership) |
| `teams.*.update` | This event triggers when a team is updated. Returns [Team Object](https://appwrite.io/docs/references/cloud/models/team) |
| `teams.*.update.prefs` | This event triggers when a team's preferences are updated. Returns [Team Object](https://appwrite.io/docs/references/cloud/models/team) |
| `users.*` | This event triggers on any user's event. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.create` | This event triggers when a user is created. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.delete` | This event triggers when a user is deleted. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.recovery.*` | This event triggers on any user's recovery token event. Returns [Token Object](https://appwrite.io/docs/references/cloud/models/token) |
| `users.*.recovery.*.create` | This event triggers when a recovery token for a user is created. Returns [Token Object](https://appwrite.io/docs/references/cloud/models/token) |
| `users.*.recovery.*.update` | This event triggers when a recovery token for a user is validated. Returns [Token Object](https://appwrite.io/docs/references/cloud/models/token) |
| `users.*.sessions.*` | This event triggers on any user's sessions event. Returns [Session Object](https://appwrite.io/docs/references/cloud/models/session) |
| `users.*.sessions.*.create` | This event triggers when a session for a user is created. Returns [Session Object](https://appwrite.io/docs/references/cloud/models/session) |
| `users.*.sessions.*.delete` | This event triggers when a session for a user is deleted. Returns [Session Object](https://appwrite.io/docs/references/cloud/models/session) |
| `users.*.update` | This event triggers when a user is updated. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.update.email` | This event triggers when a user's email address is updated. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.update.name` | This event triggers when a user's name is updated. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.update.password` | This event triggers when a user's password is updated. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.update.prefs` | This event triggers when a user's preferences is updated. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.update.status` | This event triggers when a user's status is updated. Returns [User Object](https://appwrite.io/docs/references/cloud/models/user) |
| `users.*.verification.*` | This event triggers on any user's verification token event. Returns [Token Object](https://appwrite.io/docs/references/cloud/models/token) |
| `users.*.verification.*.create` | This event triggers when a verification token for a user is created. Returns [Token Object](https://appwrite.io/docs/references/cloud/models/token) |
| `users.*.verification.*.update` | This event triggers when a verification token for a user is validated. Returns [Token Object](https://appwrite.io/docs/references/cloud/models/token) |

- Databases events




| Name | Description |
| --- | --- |
| `databases.*` | This event triggers on any database event. Returns [Database Object](https://appwrite.io/docs/references/cloud/models/database) |
| `databases.*.tables.*` | This event triggers on any table event. Returns [Table Object](https://appwrite.io/docs/references/cloud/models/table) |
| `databases.*.tables.*.columns.*` | This event triggers on any columns event. Returns [Column Object](https://appwrite.io/docs/references/cloud/models/columnList) |
| `databases.*.tables.*.columns.*.create` | This event triggers when an column is created. Returns [Column Object](https://appwrite.io/docs/references/cloud/models/columnList) |
| `databases.*.tables.*.columns.*.delete` | This event triggers when an column is deleted. Returns [Column Object](https://appwrite.io/docs/references/cloud/models/columnList) |
| `databases.*.tables.*.create` | This event triggers when a table is created. Returns [Table Object](https://appwrite.io/docs/references/cloud/models/table) |
| `databases.*.tables.*.delete` | This event triggers when a table is deleted. Returns [Table Object](https://appwrite.io/docs/references/cloud/models/table) |
| `databases.*.tables.*.rows.*` | This event triggers on any rows event. Returns [Row Object](https://appwrite.io/docs/references/cloud/models/row) |
| `databases.*.tables.*.rows.*.create` | This event triggers when a row is created. Returns [Row Object](https://appwrite.io/docs/references/cloud/models/row) |
| `databases.*.tables.*.rows.*.delete` | This event triggers when a row is deleted. Returns [Row Object](https://appwrite.io/docs/references/cloud/models/row) |
| `databases.*.tables.*.rows.*.update` | This event triggers when a row is updated. Returns [Row Object](https://appwrite.io/docs/references/cloud/models/row) |
| `databases.*.tables.*.row.*.upsert` | This event triggers when a row is upserted. Returns [Document Object](https://appwrite.io/docs/references/cloud/models/document) |
| `databases.*.tables.*.indexes.*` | This event triggers on any indexes event. Returns [Index Object](https://appwrite.io/docs/references/cloud/models/index) |
| `databases.*.tables.*.indexes.*.create` | This event triggers when an index is created. Returns [Index Object](https://appwrite.io/docs/references/cloud/models/index) |
| `databases.*.tables.*.indexes.*.delete` | This event triggers when an index is deleted. Returns [Index Object](https://appwrite.io/docs/references/cloud/models/index) |
| `databases.*.tables.*.update` | This event triggers when a table is updated. Returns [Table Object](https://appwrite.io/docs/references/cloud/models/table) |
| `databases.*.create` | This event triggers when a database is created. Returns [Database Object](https://appwrite.io/docs/references/cloud/models/database) |
| `databases.*.delete` | This event triggers when a database is deleted. Returns [Database Object](https://appwrite.io/docs/references/cloud/models/database) |
| `databases.*.update` | This event triggers when a database is updated. Returns [Database Object](https://appwrite.io/docs/references/cloud/models/database) |

- Storage events




| Name | Description |
| --- | --- |
| `buckets.*` | This event triggers on any buckets event. Returns [Bucket Object](https://appwrite.io/docs/references/cloud/models/bucket) |
| `buckets.*.create` | This event triggers when a bucket is created. Returns [Bucket Object](https://appwrite.io/docs/references/cloud/models/bucket) |
| `buckets.*.delete` | This event triggers when a bucket is deleted. Returns [Bucket Object](https://appwrite.io/docs/references/cloud/models/bucket) |
| `buckets.*.files.*` | This event triggers on any files event. Returns [File Object](https://appwrite.io/docs/references/cloud/models/file) |
| `buckets.*.files.*.create` | Since the Appwrite SDK chunks files in 5MB increments, this event will trigger for each 5MB chunk. A file is fully uploaded when `chunksTotal` equals `chunksUploaded`. Returns [File Object](https://appwrite.io/docs/references/cloud/models/file) |
| `buckets.*.files.*.delete` | This event triggers when a file is deleted. Returns [File Object](https://appwrite.io/docs/references/cloud/models/file) |
| `buckets.*.files.*.update` | This event triggers when a file is updated. Returns [File Object](https://appwrite.io/docs/references/cloud/models/file) |
| `buckets.*.update` | This event triggers when a bucket is updated. Returns [Bucket Object](https://appwrite.io/docs/references/cloud/models/bucket) |

- Functions events




| Name | Description |
| --- | --- |
| `functions.*` | This event triggers on any functions event. Returns [Function Object](https://appwrite.io/docs/references/cloud/models/function) |
| `functions.*.create` | This event triggers when a function is created. Returns [Function Object](https://appwrite.io/docs/references/cloud/models/function) |
| `functions.*.delete` | This event triggers when a function is deleted. Returns [Function Object](https://appwrite.io/docs/references/cloud/models/function) |
| `functions.*.deployments.*` | This event triggers on any deployments event. Returns [Deployment Object](https://appwrite.io/docs/references/cloud/models/deployment) |
| `functions.*.deployments.*.create` | This event triggers when a deployment is created. Returns [Deployment Object](https://appwrite.io/docs/references/cloud/models/deployment) |
| `functions.*.deployments.*.delete` | This event triggers when a deployment is deleted. Returns [Deployment Object](https://appwrite.io/docs/references/cloud/models/deployment) |
| `functions.*.deployments.*.update` | This event triggers when a deployment is updated. Returns [Deployment Object](https://appwrite.io/docs/references/cloud/models/deployment) |
| `functions.*.executions.*` | This event triggers on any executions event. Returns [Execution Object](https://appwrite.io/docs/references/cloud/models/execution) |
| `functions.*.executions.*.create` | This event triggers when an execution is created. Returns [Execution Object](https://appwrite.io/docs/references/cloud/models/execution) |
| `functions.*.executions.*.delete` | This event triggers when an execution is deleted. Returns [Execution Object](https://appwrite.io/docs/references/cloud/models/execution) |
| `functions.*.executions.*.update` | This event triggers when an execution is updated. Returns [Execution Object](https://appwrite.io/docs/references/cloud/models/execution) |
| `functions.*.update` | This event triggers when a function is updated. Returns [Function Object](https://appwrite.io/docs/references/cloud/models/function) |

- Messaging events




| Name | Description |
| --- | --- |
| `providers.*` | This event triggers on any providers event. Returns [Provider Object](https://appwrite.io/docs/references/cloud/models/provider) |
| `providers.*.create` | This event triggers when a provider is created. Returns [Provider Object](https://appwrite.io/docs/references/cloud/models/provider) |
| `providers.*.delete` | This event triggers when a provider is deleted. Returns [Provider Object](https://appwrite.io/docs/references/cloud/models/provider) |
| `providers.*.update` | This event triggers when a provider is updated. Returns [Provider Object](https://appwrite.io/docs/references/cloud/models/provider) |
| `topics.*` | This event triggers on any topic event. Returns [Topic Object](https://appwrite.io/docs/references/cloud/models/topic) |
| `topics.*.create` | This event triggers when a topic is created. Returns [Topic Object](https://appwrite.io/docs/references/cloud/models/topic) |
| `topics.*.delete` | This event triggers when a topic is deleted. Returns [Topic Object](https://appwrite.io/docs/references/cloud/models/topic) |
| `topics.*.update` | This event triggers when a topic is updated. Returns [Topic Object](https://appwrite.io/docs/references/cloud/models/topic) |
| `topics.*.subscribers.*.create` | This event triggers when a subscriber to a topic is created. Returns [Topic Object](https://appwrite.io/docs/references/cloud/models/topic) |
| `topics.*.subscribers.*.delete` | This event triggers when a subscriber to a topic is deleted. Returns [Topic Object](https://appwrite.io/docs/references/cloud/models/topic) |
| `messages.*` | This event triggers on any message event. Returns [Message Object](https://appwrite.io/docs/references/cloud/models/message) |
| `messages.*.create` | This event triggers when a message is created. Returns [Message Object](https://appwrite.io/docs/references/cloud/models/message) |
| `messages.*.delete` | This event triggers when a message is deleted. Returns [Message Object](https://appwrite.io/docs/references/cloud/models/message) |
| `messages.*.update` | This event triggers when a message is updated. Returns [Message Object](https://appwrite.io/docs/references/cloud/models/message) |


[Learn more about events](https://appwrite.io/docs/advanced/platform/api-keys)
