[Skip to content](https://appwrite.io/docs/products/functions/develop#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Appwrite Functions offer a familiar interface if you've developed REST endpoints. Each function is handled following a request and response pattern.

## [Lifecycle](https://appwrite.io/docs/products/functions/develop\#life-cycle)

There is a clear lifecycle for all Appwrite Functions, from beginning to end. Here's everything that happens during a function execution.

1. The function is invoked.
2. The active [deployment](https://appwrite.io/docs/products/functions/deployments)'s executor will handle the request.
3. The Executor passes in request information like headers, body or path through the `context.req` object of your exported function.
4. The runtime executes the code you defined, you can log through the `context.log()` or `context.error()` methods.
5. Function terminates when you return results using `return context.res.text()`, `return context.res.json()` or similar.

[Locally developed functions](https://appwrite.io/docs/products/functions/develop-locally) follow the same lifecycle on your local machine.

### [Entrypoint](https://appwrite.io/docs/products/functions/develop\#entrypoint)

You'll find all of these steps in a simple function like this. Notice the exported entry point that the executor will call.

```web-code server-nodejs line-numbers
import { Client } from 'node-appwrite';

// This is your Appwrite function
// It's executed each time we get a request
export default async ({ req, res, log, error }) => {
  // Why not try the Appwrite SDK?
  //
  // Set project and set API key
  // const client = new Client()
  //    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
  //    .setKey(req.headers['x-appwrite-key']);

  // You can log messages to the console
  log('Hello, Logs!');

  // If something goes wrong, log an error
  error('Hello, Errors!');

  // The `req` object contains the request data
  if (req.method === 'GET') {
    // Send a response with the res object helpers
    // `res.text()` dispatches a string back to the client
    return res.text('Hello, World!');
  }

  // `res.json()` is a handy helper for sending JSON
  return res.json({
    motto: 'Build like a team of hundreds_',
    learn: 'https://appwrite.io/docs',
    connect: 'https://appwrite.io/discord',
    getInspired: 'https://builtwith.appwrite.io',
  });
};

```

If you prefer to learn through more examples like this, explore the [examples page](https://appwrite.io/docs/products/functions/examples).

## [Context object](https://appwrite.io/docs/products/functions/develop\#context-object)

Context is an object passed into every function to handle communication to both the end users, and logging to the Appwrite Console. All input, output, and logging **must be handled through the context object** passed in.

You'll find these properties in the context object.

| Property | Description |
| --- | --- |
| req | Contains request information like method, body, and headers. See full examples [in the request section](https://appwrite.io/docs/products/functions/develop#request). |
| res | Contains methods to build a response and return information. See full examples [in the response section](https://appwrite.io/docs/products/functions/develop#response). |
| log() | Method to log information to the Appwrite Console, end users will not be able to see these logs. See full examples [in the logging section](https://appwrite.io/docs/products/functions/develop#logging). |
| error() | Method to log errors to the Appwrite Console, end users will not be able to see these errors. See full examples [in the logging section](https://appwrite.io/docs/products/functions/develop#logging). |

##### Depreciation notice

Use `req.bodyText` instead of `req.bodyRaw`. Use `res.text` instead of `res.send`. Use `req.bodyText` or `req.bodyJson` instead of `req.body` depending on the expected input data type.

#### [Destructuring assignment](https://appwrite.io/docs/products/functions/develop\#destructuring)

Some languages, namely JavaScript, support destructuring. You'll see us use destructuring in examples, which has the following syntax.

[Learn more about destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment).

```web-code server-nodejs line-numbers
// before destructuring
export default async function (context) {
    context.log("This is a log!");
    return context.res.text("This is a response!");
}

// after destructuring
export default async function ({ req, res, log, error }) {
    log("This is a log!");
    return res.text("This is a response!");
}

```

### [Request](https://appwrite.io/docs/products/functions/develop\#request)

If you pass data into an Appwrite Function, it'll be found in the request object. This includes all invocation inputs from Appwrite SDKs, HTTP calls, Appwrite events, or browsers visiting the configured domain. Explore the request object with the following function, which logs all request params to the Appwrite Console.

#### [Request types](https://appwrite.io/docs/products/functions/develop\#request-types)

| Request | Description |
| --- | --- |
| `req.bodyText` | Returns text that has been converted from binary data. |
| `req.bodyJson` | Parses the body text as JSON. |
| `req.bodyBinary` | Returns the binary body. |

```web-code server-nodejs line-numbers
export default async ({ req, res, log }) => {
    log(req.bodyText);                    // Raw request body, contains request data
    log(JSON.stringify(req.bodyJson));    // Object from parsed JSON request body, otherwise string
    log(JSON.stringify(req.headers));     // String key-value pairs of all request headers, keys are lowercase
    log(req.scheme);                      // Value of the x-forwarded-proto header, usually http or https
    log(req.method);                      // Request method, such as GET, POST, PUT, DELETE, PATCH, etc.
    log(req.url);                         // Full URL, for example: http://awesome.appwrite.io:8000/v1/hooks?limit=12&offset=50
    log(req.host);                        // Hostname from the host header, such as awesome.appwrite.io
    log(req.port);                        // Port from the host header, for example 8000
    log(req.path);                        // Path part of URL, for example /v1/hooks
    log(req.queryString);                 // Raw query params string. For example "limit=12&offset=50"
    log(JSON.stringify(req.query));       // Parsed query params. For example, req.query.limit

    return res.text("All the request parameters are logged to the Appwrite Console.");
};

```

#### [Headers](https://appwrite.io/docs/products/functions/develop\#headers)

Appwrite Functions will always receive a set of headers that provide meta data about the function execution. These are provided alongside any custom headers sent to the function.

| Variable | Description |
| --- | --- |
| `x-appwrite-trigger` | Describes how the function execution was invoked. Possible values are `http`, `schedule` or `event`. |
| `x-appwrite-event` | If the function execution was triggered by an event, describes the triggering event. |
| `x-appwrite-key` | The dynamic API key is used for server authentication. [Learn more about dynamic api keys](https://appwrite.io/docs/products/functions/develop#dynamic-api-key). |
| `x-appwrite-user-id` | If the function execution was invoked by an authenticated user, display the user ID. This doesn't apply to Appwrite Console users or API keys. |
| `x-appwrite-user-jwt` | JWT token generated from the invoking user's session. Used to authenticate Server SDKs to respect access permissions. [Learn more about JWT tokens](https://appwrite.io/docs/products/auth/jwt). |
| `x-appwrite-country-code` | Displays the country code of the configured locale. |
| `x-appwrite-continent-code` | Displays the continent code of the configured locale. |
| `x-appwrite-continent-eu` | Describes if the configured local is within the EU. |
| `x-appwrite-client-i` | Displays the IP of the client creating the execution. |
| `x-appwrite-execution-id` | Displays the ID of the current execution. |

### [Response](https://appwrite.io/docs/products/functions/develop\#response)

Use the response object to send a response to the function caller. This could be a user, client app, or an integration. The response information **will not be logged** to the Appwrite Console. There are several possible ways to send a response, explore them in the following Appwrite Function.

#### [Response types](https://appwrite.io/docs/products/functions/develop\#response-types)

| Response | Description |
| --- | --- |
| `empty` | Sends a response with a `code 204 No Content` status. |
| `json` | Converts the data into a JSON string and sets the content-type header to `application/json`. |
| `binary` | Packages binary bytes, the status code, and the headers into an object. |
| `redirect` | Redirects the client to the specified URL link. |
| `text` | Converts the body using UTF-8 encoding into a binary Buffer. |

```web-code server-nodejs line-numbers
const fs = require('fs');

export default async ({ req, res, log }) => {

    switch (req.query.type) {
        case 'empty':
            return res.empty();
        case 'json':
            return res.json({"type": "This is a JSON response"});
        case 'binary':
            const bytes = await fs.readFile('file.png');
            return res.binary(bytes);
        case 'redirect':
            return res.redirect("https://appwrite.io", 301);
        case 'html':
            return res.text(
                "<h1>This is an HTML response</h1>", 200, {
                    "content-type": "text/html"
                });
        default:
            return res.text("This is a text response");
    }
}

```

To get the different response types, set one of the following query parameters in the [generated domain](https://appwrite.io/docs/products/functions/domains) of your function.

| Type | Query Param | Example |
| --- | --- | --- |
| `text` | `/?type=text` | `https://64d4d22db370ae41a32e.appwrite.global/?type=text` |
| `json` | `/?type=json` | `https://64d4d22db370ae41a32e.appwrite.global/?type=json` |
| `redirect` | `/?type=redirect` | `https://64d4d22db370ae41a32e.appwrite.global/?type=redirect` |
| `html` | `/?type=html` | `https://64d4d22db370ae41a32e.appwrite.global/?type=html` |
| `empty` | `/` | `https://64d4d22db370ae41a32e.appwrite.global/` |

### [Logging](https://appwrite.io/docs/products/functions/develop\#logging)

To protect user privacy, the request and response objects are not logged to the Appwrite Console by default.

We support the spread operator across most of the languages, meaning you can write code that is more concise and flexible.

This means, to see logs or debug function executions you need to use the `log()` and `error()` methods. These logs are only visible to developers with access to the Appwrite Console.

Here's an example of using logs and errors.

```web-code server-nodejs line-numbers
export default async ({ req, res, log, error }) => {
    const message = "This is a log, use for logging information to console";
    log("Message: ", message);
    log(`This function was called with ${req.method} method`);
    const errorMessage = "This is an error, use for logging errors to console"
    error("Error: ", errorMessage);

    return res.text("Check the Appwrite Console to see logs and errors!");
};

```

You can access these logs through the following steps.

1. In Appwrite Console, navigate to Functions.
2. Click to open a function you wish to inspect.
3. Under the Executions tab, click on an execution.
4. In the Response section, you'll be able to view logs under the Logs and Errors tabs.

## [Accessing environment variables](https://appwrite.io/docs/products/functions/develop\#environment-variables)

If you need to pass constants or secrets to Appwrite Functions, you can use environment variables.

| Variable | Description | Available at Build and/or Run Time |
| --- | --- | --- |
| `APPWRITE_FUNCTION_API_ENDPOINT` | The API endpoint of the running function | Both |
| `APPWRITE_VERSION` | The Appwrite version used to run the function | Both |
| `APPWRITE_REGION` | The region where the function will run from | Both |
| `APPWRITE_FUNCTION_API_KEY` | The function API key is used for server authentication | Build time |
| `APPWRITE_FUNCTION_ID` | The ID of the running function. | Both |
| `APPWRITE_FUNCTION_NAME` | The Name of the running function. | Both |
| `APPWRITE_FUNCTION_DEPLOYMENT` | The deployment ID of the running function. | Both |
| `APPWRITE_FUNCTION_PROJECT_ID` | The project ID of the running function. | Both |
| `APPWRITE_FUNCTION_RUNTIME_NAME` | The runtime of the running function. | Both |
| `APPWRITE_FUNCTION_RUNTIME_VERSION` | The runtime version of the running function. | Both |

[Learn to add variables to you function](https://appwrite.io/docs/products/functions/functions#environment-variables)

You can access the environment variables through the systems library of each language.

```web-code server-nodejs line-numbers
export default async ({ req, res, log }) => {
    return res.text(process.env.MY_VAR);
}

```

## [Dependencies](https://appwrite.io/docs/products/functions/develop\#dependencies)

To install your dependencies before your function is built, you should add the relevant install command to the top your function's **Build setting** \> **Commands**. You can find this setting under **Functions** \> your function > **Settings** \> **Configuration** \> **Build settings**.

Make sure to include dependency files like `package.json`, `composer.json`, `requirements.txt`, etc. in your function's configured [root directory](https://appwrite.io/docs/products/functions/deploy-from-git#root-directory). Do not include the dependency folders like `node_modules`, `vendor`, etc. in your function's root directory. The dependencies installed for your local OS may not work in the executor environments

Your function's dependencies should be managed by the package manager of each language. By default, we include the following package managers in each runtime.

|  | Language | Package Manager | Commands |
| --- | --- | --- | --- |
| ![Node.js logo](https://appwrite.io/images/platforms/dark/nodejs.svg)![Node.js logo](https://appwrite.io/images/platforms/nodejs.svg) | Node.js | NPM | `npm install` |
| ![PHP logo](https://appwrite.io/images/platforms/dark/php.svg)![PHP logo](https://appwrite.io/images/platforms/php.svg) | PHP | Composer | `composer install` |
| ![Python logo](https://appwrite.io/images/platforms/dark/python.svg)![Python logo](https://appwrite.io/images/platforms/python.svg) | Python | pip | `pip install -r requirements.txt` |
| ![Ruby logo](https://appwrite.io/images/platforms/dark/ruby.svg)![Ruby logo](https://appwrite.io/images/platforms/ruby.svg) | Ruby | Bundler | `bundle install` |
| ![Deno logo](https://appwrite.io/images/platforms/dark/deno.svg)![Deno logo](https://appwrite.io/images/platforms/deno.svg) | Deno | deno | `deno cache <ENTRYPOINT_FILE>` |
| ![Go logo](https://appwrite.io/images/platforms/dark/go.svg)![Go logo](https://appwrite.io/images/platforms/go.svg) | Go | Go Modules | N/A |
| ![Dart logo](https://appwrite.io/images/platforms/dark/dart.svg)![Dart logo](https://appwrite.io/images/platforms/dart.svg) | Dart | pub | `pub get` |
| ![Swift logo](https://appwrite.io/images/platforms/dark/swift.svg)![Swift logo](https://appwrite.io/images/platforms/swift.svg) | Swift | Swift Package Manager | `swift package resolve` |
| ![.NET logo](https://appwrite.io/images/platforms/dark/dotnet.svg)![.NET logo](https://appwrite.io/images/platforms/dotnet.svg) | .NET | NuGet | `dotnet restore` |
| ![Bun logo](https://appwrite.io/images/platforms/dark/bun.svg)![Bun logo](https://appwrite.io/images/platforms/bun.svg) | Bun | bun | `bun install` |
| ![Kotlin logo](https://appwrite.io/images/platforms/dark/kotlin.svg)![Kotlin logo](https://appwrite.io/images/platforms/kotlin.svg) | Kotlin | Gradle | N/A |
| ![Java logo](https://appwrite.io/images/platforms/dark/java.svg)![Java logo](https://appwrite.io/images/platforms/java.svg) | Java | Gradle | N/A |
| ![C++ logo](https://appwrite.io/images/platforms/dark/c.svg)![C++ logo](https://appwrite.io/images/platforms/c.svg) | C++ | None | N/A |

## [Using Appwrite in a function](https://appwrite.io/docs/products/functions/develop\#using-appwrite)

Appwrite can be used in your functions by adding the relevant SDK to your function's dependencies. Authenticating with Appwrite is done via a dynamic API key or a JWT token.

### [Dynamic API key](https://appwrite.io/docs/products/functions/develop\#dynamic-api-key)

Dynamic API keys are the same as [API keys](https://appwrite.io/docs/advanced/platform/api-keys) but are automatically generated. They are generated in your functions per execution. However, you can only use dynamic API keys inside Appwrite functions.

During the build process, dynamic API keys are automatically provided as the environment variable `APPWRITE_FUNCTION_API_KEY`. This environment variable doesn't need to be initialized.

During execution, dynamic API keys are automatically provided in the `x-appwrite-key` [header](https://appwrite.io/docs/products/functions/develop#headers).

Dynamic API keys grant access and operate without sessions. They allow your function to act as an admin-type role instead of acting on behalf of a user. Update the function settings to configure the scopes of the function.

1. In Appwrite Console, navigate to **Functions**.
2. Click to open a function you wish to configure.
3. Under the **Settings** tab, navigate to **Scopes**.
4. Select the scopes you want to grant the dynamic key.
5. It is best practice to allow only necessary permissions.

```web-code server-nodejs line-numbers
import { Client, TablesDB, ID } from 'node-appwrite';

export default async ({ req, res, log, error }) => {
    // Set project and set API key
    const client = new Client()
       .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
       .setKey(req.headers['x-appwrite-key']);

    const tablesDB = new TablesDB(client);

    try {
        await tablesDB.createRow({
            databaseId: '<DATABASE_ID>',
            tableId: '<TABLE_ID>',
            rowId: ID.unique(),
            data: {}
        })
    } catch (e) {
        error("Failed to create row: " + e.message)
        return res.text("Failed to create row")
    }

    return res.text("Row created")
}

```

### [Using with JWT](https://appwrite.io/docs/products/functions/develop\#using-jwt)

JWTs allow you to act on behalf of an user in your Appwrite Function. When using JWTs, you will be able to access and change **only** the resources with the same permissions as the user account that signed the JWT. This preserves the permissions you configured on each resource.

If the Appwrite Function is invoked by an authenticated user, the `x-appwrite-user-jwt` header is automatically passed in.

```web-code server-nodejs line-numbers
import { Client, TablesDB, ID } from 'node-appwrite';

export default async ({ req, res, log }) => {
    const client = new Client()
        .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)

    if (req.headers['x-appwrite-user-jwt']) {
        client.setJWT(req.headers['x-appwrite-user-jwt'])
    } else {
        return res.text("Access denied: This function requires authentication. Please sign in to continue.");
    }

    const tablesDB = new TablesDB(client);

    try {
        await tablesDB.createRow({
            databaseId: '<DATABASE_ID>',
            tableId: '<TABLE_ID>',
            rowId: ID.unique(),
            data: {}
        })
    } catch (e) {
        log("Failed to create row: " + e.message)
        return res.text("Failed to create row")
    }

    return res.text("Row created")
}

```

## [Code structure](https://appwrite.io/docs/products/functions/develop\#code-structure)

As your functions grow, you may find yourself needing to split your code into multiple files. This helps you keep your codebase maintainable and easy to read. Here's how you can accomplish code splitting.

Node.jsPHPPythonRubyDenoGoDart
More

Swift.NETKotlinJava

Node.jsPHP
More

PythonRubyDenoGoDartSwift.NETKotlinJava

```web-code server-nodejs line-numbers
// src/utils.js
export function add(a, b) {
    return a + b;
}

```

```web-code server-nodejs line-numbers
// src/main.js
import { add } from './utils.js';

export default function ({ res }) {
    return res.text(add(1, 2));
}

```

```web-code php line-numbers
<?php
// src/utils.php
function add($a, $b) {
    return $a + $b;
}

```

```web-code php line-numbers
<?php
// src/main.php
require_once(__DIR__ . '/utils.php');

return function ($context) {
    return $context->res->text(add(1, 2));
};

```

```web-code python line-numbers
# src/utils.py
def add(a, b):
    return a + b

```

```web-code python line-numbers
# src/main.py
from .utils import add

def main(context):
    return context.res.text(add(1, 2))

```

```web-code ruby line-numbers
# lib/utils.rb
def add(a, b)
    return a + b
end

```

```web-code ruby line-numbers
# lib/main.rb
require_relative 'utils'

def main(context)
    return context.res.text(add(1, 2))
end

```

```web-code deno line-numbers
// src/utils.ts
export function add(a: number, b: number): number {
    return a + b;
}

```

```web-code deno line-numbers
// src/main.ts
import { add } from './utils.ts';

export default function ({res}: {res: any}) {
    return res.text(add(1, 2));
}

```

```web-code go line-numbers
// src/utils/go.mod
module example.com/utils

go 1.23.0

```

```web-code go line-numbers
// src/utils/utils.go
package utils

func Add(a int, b int) int {
	return a + b
}

```

```web-code go line-numbers
// src/main/go.mod
module example.com/main

go 1.23.0

replace example.com/utils => ../utils // Run go mod edit -replace example.com/go=../go

require example.com/utils v0.0.0-00010101000000-000000000000 // Run go mod tidy

```

```web-code go line-numbers
// src/main/main.go
package main

import "example.com/utils"

func main() {
	// Get a greeting message and print it.
	message := utils.Add(5, 4)
	print(message)
}

```

```web-code dart line-numbers
// lib/utils.dart
int add(int a, int b) {
    return a + b;
}

```

```web-code dart line-numbers
// lib/main.dart
import 'dart:async';

import 'package:package_name/utils.dart';

Future<dynamic> main(final context) async {
    return context.res.text(add(1, 2));
}

```

```web-code swift line-numbers
// Sources/utils.swift
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

```

```web-code swift line-numbers
// Sources/index.swift
import Foundation

func main(context: RuntimeContext) async throws -> RuntimeOutput {
    return context.res.text(add(1, 2))
}

```

```web-code csharp line-numbers
// src/Utils.cs
namespace DotNetRuntime
{
    public static class Utils
    {
        public static int Add(int a, int b)
        {
            return a + b;
        }
    }
}

```

```web-code csharp line-numbers
// src/Index.cs
namespace DotNetRuntime
{
    public class Handler {
        public async Task<RuntimeOutput> Main(RuntimeContext Context)
        {
            return Context.Res.Text(Utils.Add(1, 2));
        }
    }
}

```

```web-code kotlin line-numbers
// src/Utils.kt
package io.openruntimes.kotlin.src

object Utils {
    fun add(a: Int, b: Int): Int {
        return a + b
    }
}

```

```web-code kotlin line-numbers
// src/Main.kt
package io.openruntimes.kotlin.src

import io.openruntimes.kotlin.RuntimeContext
import io.openruntimes.kotlin.RuntimeOutput
import io.openruntimes.kotlin.Utils

class Main {
    fun main(context: RuntimeContext): RuntimeOutput {
        return context.res.text(Utils.add(1, 2))
    }
}

```

```web-code java line-numbers
// src/Utils.java
package io.openruntimes.java.src;

class Utils {
    public static int add(int a, int b) {
        return a + b;
    }
}

```

```web-code java line-numbers
package io.openruntimes.java.src;

import io.openruntimes.java.RuntimeContext;
import io.openruntimes.java.RuntimeOutput;
import io.openruntimes.java.Utils;

public class Main {
    public RuntimeOutput main(RuntimeContext context) throws Exception {
        return context.res.text(Utils.add(1, 2));
    }
}

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
