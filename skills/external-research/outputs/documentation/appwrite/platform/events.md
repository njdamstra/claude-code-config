[Skip to content](https://appwrite.io/docs/advanced/platform/events#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Appwrite provides a variety of events that allows your application to react to changes as they happen. A event will fire when a change occurs in your Appwrite project, like when a new user registers or a new file is uploaded to Appwrite. You can subscribe to these events with Appwrite [Functions](https://appwrite.io/docs/products/functions), [Realtime](https://appwrite.io/docs/apis/realtime), or [Webhooks](https://appwrite.io/docs/advanced/platform/webhooks).

You can subscribe to events for specific resources using their ID or subscribe to changes of all resources of the same type by using a wildcard character \* instead of an ID. You can also filter for events of specific actions like create, update, upsert, or delete.

You can find a list of events for Storage, Databases, Functions, and Authentication services below.

- Authentication




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

- Databases




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

- Storage




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

- Functions




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

- Messaging




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


## [Known limitations](https://appwrite.io/docs/advanced/platform/events\#known-limitations)

When events fire, only existing subscriptions for that event will receive the update. If your client or server side integrations lose network connection temporarily, delivery of the event is not guaranteed.

For self-hosted instances, when the Appwrite containers are shut down and restarted, events with pending webhooks and subscription updates will not be delivered.

A change to a resource can cause multiple events to fire. For example adding a new row with ID `"lion-king"` to a table with the ID `"movies"` will cause all of the below events to fire.

```web-code json line-numbers
{
  "events": [\
      "databases.default.tables.movies.rows.lion-king.create",\
      "databases.*.tables.*.rows.*.create",\
      "databases.default.tables.*.rows.lion-king.create",\
      "databases.*.tables.*.rows.lion-king.create",\
      "databases.*.tables.movies.rows.lion-king.create",\
      "databases.default.tables.movies.rows.*.create",\
      "databases.*.tables.movies.rows.*.create",\
      "databases.default.tables.*.rows.*.create",\
      "databases.default.tables.movies.rows.lion-king",\
      "databases.*.tables.*.rows.*",\
      "databases.default.tables.*.rows.lion-king",\
      "databases.*.tables.*.rows.lion-king",\
      "databases.*.tables.movies.rows.lion-king",\
      "databases.default.tables.movies.rows.*",\
      "databases.*.tables.movies.rows.*",\
      "databases.default.tables.*.rows.*",\
      "databases.default.tables.movies",\
      "databases.*.tables.*",\
      "databases.default.tables.*",\
      "databases.*.tables.movies",\
      "databases.default",\
      "databases.*"\
  ]
}

```
