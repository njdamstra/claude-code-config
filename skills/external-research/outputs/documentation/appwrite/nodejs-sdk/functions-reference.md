[Skip to content](https://appwrite.io/docs/references/cloud/server-nodejs/functions#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Functions service allows you to create custom behaviour that can be triggered by any supported Appwrite system events or by a predefined schedule.

Appwrite Cloud Functions lets you automatically run backend code in response to events triggered by Appwrite or by setting it to be executed in a predefined schedule. Your code is stored in a secure way on your Appwrite instance and is executed in an isolated environment.

You can learn more by following our [Cloud Functions tutorial](https://appwrite.io/docs/products/functions).

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Create a new function. You can pass a list of [permissions](https://appwrite.io/docs/permissions) to allow different project users or team with access to execute the function using the client API.

- Request









- Function ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Function name. Max length: 128 chars.

- Execution runtime.

- An array of role strings with execution permissions. By default no user is granted with any execute permissions. [learn more about roles](https://appwrite.io/docs/permissions#permission-roles). Maximum of 100 roles are allowed, each 64 characters long.

- Events list. Maximum of 100 events are allowed.

- Schedule CRON syntax.

- Function maximum execution time in seconds.

- Is function enabled? When set to 'disabled', users cannot access the function but Server SDKs with and API key can still access the function. No data is lost when this is toggled.

- When disabled, executions will exclude logs and errors, and will be slightly faster.

- Entrypoint File. This path is relative to the "providerRootDirectory".

- Build Commands.

- List of scopes allowed for API key auto-generated for every execution. Maximum of 100 scopes are allowed.

- Appwrite Installation ID for VCS (Version Control System) deployment.

- Repository ID of the repo linked to the function.

- Production branch for the repo linked to the function.

- Is the VCS (Version Control System) connection in silent mode for the repo linked to the function? In silent mode, comments will not be made on commits and pull requests.

- Path to function code in the linked repo.

- Runtime specification for the function and builds.


- Response









  - - [Function](https://appwrite.io/docs/references/cloud/models/function)



```web-code text
POST /functions

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.create({
    functionId: '<FUNCTION_ID>',
    name: '<NAME>',
    runtime: sdk..Node145,
    execute: ["any"], // optional
    events: [], // optional
    schedule: '', // optional
    timeout: 1, // optional
    enabled: false, // optional
    logging: false, // optional
    entrypoint: '<ENTRYPOINT>', // optional
    commands: '<COMMANDS>', // optional
    scopes: [], // optional
    installationId: '<INSTALLATION_ID>', // optional
    providerRepositoryId: '<PROVIDER_REPOSITORY_ID>', // optional
    providerBranch: '<PROVIDER_BRANCH>', // optional
    providerSilentMode: false, // optional
    providerRootDirectory: '<PROVIDER_ROOT_DIRECTORY>', // optional
    specification: '' // optional
});

```

Get a function by its unique ID.

- Request









- Function ID.


- Response









  - - [Function](https://appwrite.io/docs/references/cloud/models/function)



```web-code text
GET /functions/{functionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.get({
    functionId: '<FUNCTION_ID>'
});

```

Get a list of all the project's functions. You can use the query params to filter your results.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, enabled, runtime, deploymentId, schedule, scheduleNext, schedulePrevious, timeout, entrypoint, commands, installationId

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Functions List](https://appwrite.io/docs/references/cloud/models/functionList)



```web-code text
GET /functions

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.list({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update function by its unique ID.

- Request









- Function ID.

- Function name. Max length: 128 chars.

- Execution runtime.

- An array of role strings with execution permissions. By default no user is granted with any execute permissions. [learn more about roles](https://appwrite.io/docs/permissions#permission-roles). Maximum of 100 roles are allowed, each 64 characters long.

- Events list. Maximum of 100 events are allowed.

- Schedule CRON syntax.

- Maximum execution time in seconds.

- Is function enabled? When set to 'disabled', users cannot access the function but Server SDKs with and API key can still access the function. No data is lost when this is toggled.

- When disabled, executions will exclude logs and errors, and will be slightly faster.

- Entrypoint File. This path is relative to the "providerRootDirectory".

- Build Commands.

- List of scopes allowed for API Key auto-generated for every execution. Maximum of 100 scopes are allowed.

- Appwrite Installation ID for VCS (Version Controle System) deployment.

- Repository ID of the repo linked to the function

- Production branch for the repo linked to the function

- Is the VCS (Version Control System) connection in silent mode for the repo linked to the function? In silent mode, comments will not be made on commits and pull requests.

- Path to function code in the linked repo.

- Runtime specification for the function and builds.


- Response









  - - [Function](https://appwrite.io/docs/references/cloud/models/function)



```web-code text
PUT /functions/{functionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.update({
    functionId: '<FUNCTION_ID>',
    name: '<NAME>',
    runtime: sdk..Node145, // optional
    execute: ["any"], // optional
    events: [], // optional
    schedule: '', // optional
    timeout: 1, // optional
    enabled: false, // optional
    logging: false, // optional
    entrypoint: '<ENTRYPOINT>', // optional
    commands: '<COMMANDS>', // optional
    scopes: [], // optional
    installationId: '<INSTALLATION_ID>', // optional
    providerRepositoryId: '<PROVIDER_REPOSITORY_ID>', // optional
    providerBranch: '<PROVIDER_BRANCH>', // optional
    providerSilentMode: false, // optional
    providerRootDirectory: '<PROVIDER_ROOT_DIRECTORY>', // optional
    specification: '' // optional
});

```

Update the function active deployment. Use this endpoint to switch the code deployment that should be used when visitor opens your function.

- Request









- Function ID.

- Deployment ID.


- Response









  - - [Function](https://appwrite.io/docs/references/cloud/models/function)



```web-code text
PATCH /functions/{functionId}/deployment

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.updateFunctionDeployment({
    functionId: '<FUNCTION_ID>',
    deploymentId: '<DEPLOYMENT_ID>'
});

```

Delete a function by its unique ID.

- Request









- Function ID.


- Response


```web-code text
DELETE /functions/{functionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.delete({
    functionId: '<FUNCTION_ID>'
});

```

Get a list of all runtimes that are currently active on your instance.

- Response









  - - [Runtimes List](https://appwrite.io/docs/references/cloud/models/runtimeList)



```web-code text
GET /functions/runtimes

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.listRuntimes();

```

List allowed function specifications for this instance.

- Response









  - - [Specifications List](https://appwrite.io/docs/references/cloud/models/specificationList)



```web-code text
GET /functions/specifications

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.listSpecifications();

```

Create a new function code deployment. Use this endpoint to upload a new version of your code function. To execute your newly uploaded code, you'll need to update the function's deployment to use your new deployment UID.

This endpoint accepts a tar.gz file compressed with your code. Make sure to include any dependencies your code has within the compressed file. You can learn more about code packaging in the [Appwrite Cloud Functions tutorial](https://appwrite.io/docs/functions).

Use the "command" param to set the entrypoint used to execute your code.

- Request









- Function ID.

- Gzip file with your code package. When used with the Appwrite CLI, pass the path to your code directory, and the CLI will automatically package your code. Use a path that is within the current directory.

- Automatically activate the deployment when it is finished building.

- Entrypoint File.

- Build Commands.


- Response









  - - [Deployment](https://appwrite.io/docs/references/cloud/models/deployment)



```web-code text
POST /functions/{functionId}/deployments

```

```web-code server-nodejs
const sdk = require('node-appwrite');
const fs = require('fs');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.createDeployment({
    functionId: '<FUNCTION_ID>',
    code: InputFile.fromPath('/path/to/file', 'filename'),
    activate: false,
    entrypoint: '<ENTRYPOINT>', // optional
    commands: '<COMMANDS>' // optional
});

```

Create a new build for an existing function deployment. This endpoint allows you to rebuild a deployment with the updated function configuration, including its entrypoint and build commands if they have been modified. The build process will be queued and executed asynchronously. The original deployment's code will be preserved and used for the new build.

- Request









- Function ID.

- Deployment ID.

- Build unique ID.


- Response









  - - [Deployment](https://appwrite.io/docs/references/cloud/models/deployment)



```web-code text
POST /functions/{functionId}/deployments/duplicate

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.createDuplicateDeployment({
    functionId: '<FUNCTION_ID>',
    deploymentId: '<DEPLOYMENT_ID>',
    buildId: '<BUILD_ID>' // optional
});

```

Create a deployment based on a template.

Use this endpoint with combination of [listTemplates](https://appwrite.io/docs/server/functions#listTemplates) to find the template details.

- Request









- Function ID.

- Repository name of the template.

- The name of the owner of the template.

- Path to function code in the template repo.

- Version (tag) for the repo linked to the function template.

- Automatically activate the deployment when it is finished building.


- Response









  - - [Deployment](https://appwrite.io/docs/references/cloud/models/deployment)



```web-code text
POST /functions/{functionId}/deployments/template

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.createTemplateDeployment({
    functionId: '<FUNCTION_ID>',
    repository: '<REPOSITORY>',
    owner: '<OWNER>',
    rootDirectory: '<ROOT_DIRECTORY>',
    version: '<VERSION>',
    activate: false // optional
});

```

Create a deployment when a function is connected to VCS.

This endpoint lets you create deployment from a branch, commit, or a tag.

- Request









- Function ID.

- Type of reference passed. Allowed values are: branch, commit

- VCS reference to create deployment from. Depending on type this can be: branch name, commit hash

- Automatically activate the deployment when it is finished building.


- Response









  - - [Deployment](https://appwrite.io/docs/references/cloud/models/deployment)



```web-code text
POST /functions/{functionId}/deployments/vcs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.createVcsDeployment({
    functionId: '<FUNCTION_ID>',
    type: sdk.VCSDeploymentType.Branch,
    reference: '<REFERENCE>',
    activate: false // optional
});

```

Get a function deployment by its unique ID.

- Request









- Function ID.

- Deployment ID.


- Response









  - - [Deployment](https://appwrite.io/docs/references/cloud/models/deployment)



```web-code text
GET /functions/{functionId}/deployments/{deploymentId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.getDeployment({
    functionId: '<FUNCTION_ID>',
    deploymentId: '<DEPLOYMENT_ID>'
});

```

Get a function deployment content by its unique ID. The endpoint response return with a 'Content-Disposition: attachment' header that tells the browser to start downloading the file to user downloads directory.

- Request









- Function ID.

- Deployment ID.

- Deployment file to download. Can be: "source", "output".


- Response


```web-code text
GET /functions/{functionId}/deployments/{deploymentId}/download

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.getDeploymentDownload({
    functionId: '<FUNCTION_ID>',
    deploymentId: '<DEPLOYMENT_ID>',
    type: sdk.DeploymentDownloadType.Source // optional
});

```

Get a list of all the function's code deployments. You can use the query params to filter your results.

- Request









- Function ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: buildSize, sourceSize, totalSize, buildDuration, status, activate, type

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Deployments List](https://appwrite.io/docs/references/cloud/models/deploymentList)



```web-code text
GET /functions/{functionId}/deployments

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.listDeployments({
    functionId: '<FUNCTION_ID>',
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Cancel an ongoing function deployment build. If the build is already in progress, it will be stopped and marked as canceled. If the build hasn't started yet, it will be marked as canceled without executing. You cannot cancel builds that have already completed (status 'ready') or failed. The response includes the final build status and details.

- Request









- Function ID.

- Deployment ID.


- Response









  - - [Deployment](https://appwrite.io/docs/references/cloud/models/deployment)



```web-code text
PATCH /functions/{functionId}/deployments/{deploymentId}/status

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.updateDeploymentStatus({
    functionId: '<FUNCTION_ID>',
    deploymentId: '<DEPLOYMENT_ID>'
});

```

Delete a code deployment by its unique ID.

- Request









- Function ID.

- Deployment ID.


- Response


```web-code text
DELETE /functions/{functionId}/deployments/{deploymentId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.deleteDeployment({
    functionId: '<FUNCTION_ID>',
    deploymentId: '<DEPLOYMENT_ID>'
});

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

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const functions = new sdk.Functions(client);

const result = await functions.createExecution({
    functionId: '<FUNCTION_ID>',
    body: '<BODY>', // optional
    async: false, // optional
    path: '<PATH>', // optional
    method: sdk.ExecutionMethod.GET, // optional
    headers: {}, // optional
    scheduledAt: '<SCHEDULED_AT>' // optional
});

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

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const functions = new sdk.Functions(client);

const result = await functions.getExecution({
    functionId: '<FUNCTION_ID>',
    executionId: '<EXECUTION_ID>'
});

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

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const functions = new sdk.Functions(client);

const result = await functions.listExecutions({
    functionId: '<FUNCTION_ID>',
    queries: [] // optional
});

```

Delete a function execution by its unique ID.

- Request









- Function ID.

- Execution ID.


- Response


```web-code text
DELETE /functions/{functionId}/executions/{executionId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.deleteExecution({
    functionId: '<FUNCTION_ID>',
    executionId: '<EXECUTION_ID>'
});

```

Create a new function environment variable. These variables can be accessed in the function at runtime as environment variables.

- Request









- Function unique ID.

- Variable key. Max length: 255 chars.

- Variable value. Max length: 8192 chars.

- Secret variables can be updated or deleted, but only functions can read them during build and runtime.


- Response









  - - [Variable](https://appwrite.io/docs/references/cloud/models/variable)



```web-code text
POST /functions/{functionId}/variables

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.createVariable({
    functionId: '<FUNCTION_ID>',
    key: '<KEY>',
    value: '<VALUE>',
    secret: false // optional
});

```

Get a variable by its unique ID.

- Request









- Function unique ID.

- Variable unique ID.


- Response









  - - [Variable](https://appwrite.io/docs/references/cloud/models/variable)



```web-code text
GET /functions/{functionId}/variables/{variableId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.getVariable({
    functionId: '<FUNCTION_ID>',
    variableId: '<VARIABLE_ID>'
});

```

Get a list of all variables of a specific function.

- Request









- Function unique ID.


- Response









  - - [Variables List](https://appwrite.io/docs/references/cloud/models/variableList)



```web-code text
GET /functions/{functionId}/variables

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.listVariables({
    functionId: '<FUNCTION_ID>'
});

```

Update variable by its unique ID.

- Request









- Function unique ID.

- Variable unique ID.

- Variable key. Max length: 255 chars.

- Variable value. Max length: 8192 chars.

- Secret variables can be updated or deleted, but only functions can read them during build and runtime.


- Response









  - - [Variable](https://appwrite.io/docs/references/cloud/models/variable)



```web-code text
PUT /functions/{functionId}/variables/{variableId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.updateVariable({
    functionId: '<FUNCTION_ID>',
    variableId: '<VARIABLE_ID>',
    key: '<KEY>',
    value: '<VALUE>', // optional
    secret: false // optional
});

```

Delete a variable by its unique ID.

- Request









- Function unique ID.

- Variable unique ID.


- Response


```web-code text
DELETE /functions/{functionId}/variables/{variableId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const functions = new sdk.Functions(client);

const result = await functions.deleteVariable({
    functionId: '<FUNCTION_ID>',
    variableId: '<VARIABLE_ID>'
});

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Functions API Reference - Docs - Appwrite
