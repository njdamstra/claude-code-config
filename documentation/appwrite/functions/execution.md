[Skip to content](https://appwrite.io/docs/products/functions/execute#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Appwrite Functions can be executed in several ways. Executions can be invoked through the Appwrite SDK and visiting its REST endpoint. Functions can also be triggered by events and scheduled executions. Here are all the different ways to consume your Appwrite Functions.

## [Domains](https://appwrite.io/docs/products/functions/execute\#domains)

You can execute a function through HTTP requests, using a browser or by sending an HTTP request.

1. In the Appwrite Console's sidebar, click **Functions**.
2. Under **Execute access**, set the access to `Any` so that anyone can execute the function. You will use [JWTs](https://appwrite.io/docs/products/auth/jwt) to authenticate users.
3. Under the **Domains** tab, you'll find the generated domain from Appwrite and your custom domains. [Learn about adding a custom domain](https://appwrite.io/docs/products/functions/domains).

```web-code bash line-numbers
https://64d4d22db370ae41a32e.appwrite.global

```

When requests are made to this domain, whether through a browser or through an HTTP requests, the request information like request URL, request headers, and request body will be passed to the function.

```web-code bash line-numbers
curl -X POST https://64d4d22db370ae41a32e.appwrite.global \
-H "X-Custom-Header: 123" \
-H "x-appwrite-user-jwt: <YOUR_JWT_KEY>" \
-H "Content-Type: application/json" \
-d '{"data":"this is json data"}'

```

Notice how a `x-appwrite-user-jwt` header is passed in the request, you will use this to authenticate users. [Learn more about JWTs](https://appwrite.io/docs/products/auth/jwt).

This unlocks ability for you to develop custom HTTP endpoints with Appwrite Functions. It also allows accepting incoming webhooks for handling online payments, hosting social platform bots, and much more.

## [SDK](https://appwrite.io/docs/products/functions/execute\#sdk)

You can invoke your Appwrite Functions directly from the [Appwrite SDKs](https://appwrite.io/docs/sdks).

Client SDKsServer SDKs

Client SDKsServer SDKs

```web-code client-web line-numbers
import { Client, Functions } from "appwrite";

const client = new Client();

const functions = new Functions(client);

client
    .setProject('<PROJECT_ID>') // Your project ID
;

const promise = functions.createExecution({
    functionId: '<FUNCTION_ID>',
    body: '<BODY>',  // optional
    async: false,  // optional
    xpath: '<PATH>',  // optional
    method: 'GET',  // optional
    headers: {} // optional
});

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

```web-code server-nodejs line-numbers
const sdk = require('node-appwrite');

// Init SDK
const client = new sdk.Client();

const functions = new sdk.Functions(client);

client
    .setProject('<PROJECT_ID>') // Your project ID
;

const promise = functions.createExecution({
    functionId: '<FUNCTION_ID>',
    body: '<BODY>',  // optional
    async: false,  // optional
    path: '<PATH>',  // optional
    method: 'GET',  // optional
    headers: {} // optional
});

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

## [Console](https://appwrite.io/docs/products/functions/execute\#console)

Another easy way to test a function is directly in the Appwrite Console. You test a function by hitting the **Execute now** button, which will display with modal below.

You'll be able to mock executions by configuring the path, method, headers, and body.

![Create project screen](https://appwrite.io/images/docs/functions/execution/dark/execute-function.png)

![Create project screen](https://appwrite.io/images/docs/functions/execution/execute-function.png)

## [Events](https://appwrite.io/docs/products/functions/execute\#events)

Changes in Appwrite emit events. You can configure Functions to be executed in response to these events.

1. In Appwrite Console, navigate to **Functions**.
2. Click to open a function you wish to configure.
3. Under the **Settings** tab, navigate to **Events**.
4. Add one or multiple events as triggers for the function.
5. Be careful to avoid selecting events that can be caused by the function itself. This can cause the function to trigger its own execution, resulting in infinite recursions.

In these executions, the event that triggered the function will be passed as the header `x-appwrite-event` to the function. The `request.body` parameter will contain the event data. [Learn more about events](https://appwrite.io/docs/advanced/platform/events).

You can use one of the following events.

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


## [Schedule](https://appwrite.io/docs/products/functions/execute\#schedule)

Appwrite supports scheduled function executions. You can schedule executions using [cron expressions](https://en.wikipedia.org/wiki/Cron) in the settings of your function. Cron supports recurring executions as frequently as **every minute**.

Here are some cron expressions for common intervals:

| Cron Expression | Schedule |
| --- | --- |
| `*/15 * * * *` | Every 15 minutes |
| `0 * * * *` | Every Hour |
| `0 0 * * *` | Every day at 00:00 |
| `0 0 * * 1` | Every Monday at 00:00 |

## [Delayed executions](https://appwrite.io/docs/products/functions/execute\#delayed-executions)

You can also delay function executions, which trigger the function only once at a future date and time. You can schedule a function execution using the Appwrite Console, a Client SDK, or a Server SDK.

ConsoleClient SDKServer SDK

ConsoleClient SDK
More

Server SDK

To schedule an execution, navigate to **Your function** \> **Executions** \> **Execute now** \> **Schedule** in the Appwrite Console.

![Scheduled execution details screen](https://appwrite.io/images/docs/functions/execution/dark/scheduled-execution-function.png)

![Scheduled execution details screen](https://appwrite.io/images/docs/functions/execution/scheduled-execution-function.png)

You can also schedule your function executions using a supported [Client SDK](https://appwrite.io/docs/sdks/#client).

```web-code client-web line-numbers
import { Client, Functions, ExecutionMethod } from "appwrite";

const client = new Client()
    .setProject('<PROJECT_ID>'); // Your project ID

const functions = new Functions(client);

const result = await functions.createExecution({
    functionId: '<FUNCTION_ID>',
    body: '<BODY>', // optional
    async: true, // Scheduled executions need to be async
    xpath: '<PATH>', // optional
    method: ExecutionMethod.GET, // optional
    headers: {}, // optional
    scheduledAt: '2020-10-15T06:38:00.000+00:00' // Schedule execution (optional)
});

console.log(result);

```

You can also schedule your function executions using a supported [Server SDK](https://appwrite.io/docs/sdks/#server).

```web-code server-nodejs line-numbers
const sdk = require('node-appwrite');

// Init SDK
const client = new sdk.Client();

const functions = new sdk.Functions(client);

client
    .setProject('<PROJECT_ID>') // Your project ID
;

const promise = functions.createExecution(
        '<FUNCTION_ID>', // functionId
        '<BODY>', // body (optional)
        true, // Scheduled executions need to be async
        '<PATH>', // path (optional)
        ExecutionMethod.GET, // method (optional)
        {}, // headers (optional)
        '2020-10-15T06:38:00.000+00:00' // Schedule execution (optional)
    );

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

## [Permissions](https://appwrite.io/docs/products/functions/execute\#permission)

Appwrite Functions can be executed using Client or Server SDKs. Client SDKs must be authenticated with an account that has been granted execution [permissions](https://appwrite.io/docs/advanced/platform/permissions) on the function's settings page. Server SDKs require an API key with the correct scopes.

If your function has a generated or custom domain, executions are not authenticated. Anyone visiting the configured domains will be considered a guest, so make sure to give `Any` execute permission in order for domain executions to work. If you need to enforce permissions for functions with a domain, use authentication methods like JWT.

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
