[Skip to content](https://appwrite.io/docs/references/cloud/client-web/functions#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Functions service allows you to create custom behaviour that can be triggered by any supported Appwrite system events or by a predefined schedule.

Appwrite Cloud Functions lets you automatically run backend code in response to events triggered by Appwrite or by setting it to be executed in a predefined schedule. Your code is stored in a secure way on your Appwrite instance and is executed in an isolated environment.

You can learn more by following our [Cloud Functions tutorial](https://appwrite.io/docs/products/functions).

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Trigger a function execution. The returned object will return you the current execution status. You can ping the `Get Execution` endpoint to get updates on the current execution status. Once this endpoint is called, your function execution process will start asynchronously.

- Request









- Function ID.

- HTTP body of execution. Default value is empty string.

- Execute code in the background. Default value is false.

- HTTP path of execution. Path can include query params. Default value is /

- HTTP method of execution. Default value is POST.

- HTTP headers of execution. Defaults to empty.

- Scheduled execution time in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. DateTime value must be in future with precision in minutes.


- Response


```web-code text
POST /functions/{functionId}/executions

```

```web-code client-web
import { Client, Functions, ExecutionMethod } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const functions = new Functions(client);

const result = await functions.createExecution({
    functionId: '<FUNCTION_ID>',
    body: '<BODY>', // optional
    async: false, // optional
    path: '<PATH>', // optional
    method: ExecutionMethod.GET, // optional
    headers: {}, // optional
    scheduledAt: '<SCHEDULED_AT>' // optional
});

console.log(result);

```

Get a function execution log by its unique ID.

- Request









- Function ID.

- Execution ID.


- Response









  - - [Execution](https://appwrite.io/docs/references/cloud/models/execution)



```web-code text
GET /functions/{functionId}/executions/{executionId}

```

```web-code client-web
import { Client, Functions } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const functions = new Functions(client);

const result = await functions.getExecution({
    functionId: '<FUNCTION_ID>',
    executionId: '<EXECUTION_ID>'
});

console.log(result);

```

Get a list of all the current user function execution logs. You can use the query params to filter your results.

- Request









- Function ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: trigger, status, responseStatusCode, duration, requestMethod, requestPath, deploymentId


- Response









  - - [Executions List](https://appwrite.io/docs/references/cloud/models/executionList)



```web-code text
GET /functions/{functionId}/executions

```

```web-code client-web
import { Client, Functions } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const functions = new Functions(client);

const result = await functions.listExecutions({
    functionId: '<FUNCTION_ID>',
    queries: [] // optional
});

console.log(result);

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Functions API Reference - Docs - Appwrite