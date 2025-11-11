[Skip to content](https://appwrite.io/docs/quick-starts/node#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Learn how to setup your first Node.js project powered by Appwrite.

Head to the [Appwrite Console](https://cloud.appwrite.io/console).

If this is your first time using Appwrite, create an account and create your first project.

![Create project screen](https://appwrite.io/images/docs/quick-starts/dark/create-project.png)

![Create project screen](https://appwrite.io/images/docs/quick-starts/create-project.png)

Then, under **Integrate with your server**, add an **API Key** with the following scopes.

![Create project screen](https://appwrite.io/images/docs/quick-starts/dark/integrate-server.png)

![Create project screen](https://appwrite.io/images/docs/quick-starts/integrate-server.png)

| Category | Required scopes | Purpose |
| --- | --- | --- |
| Database | `databases.write` | Allows API key to create, update, and delete [databases](https://appwrite.io/docs/products/databases/databases). |
|  | `tables.write` | Allows API key to create, update, and delete [tables](https://appwrite.io/docs/products/databases/tables). |
|  | `columns.write` | Allows API key to create, update, and delete [columns](https://appwrite.io/docs/products/databases/tables#columns). |
|  | `rows.read` | Allows API key to read [rows](https://appwrite.io/docs/products/databases/rows). |
|  | `rows.write` | Allows API key to create, update, and delete [rows](https://appwrite.io/docs/products/databases/rows). |

Other scopes are optional.

Create a Node.js CLI application.

```web-code sh line-numbers
mkdir my-app
cd my-app
npm init

```

Install the Node.js Appwrite SDK.

```web-code sh line-numbers
npm install node-appwrite

```

Find your project ID in the **Settings** page. Also, click on the **View API Keys** button to find the API key that was created earlier.

![Project settings screen](https://appwrite.io/images/docs/quick-starts/dark/project-id.png)

![Project settings screen](https://appwrite.io/images/docs/quick-starts/project-id.png)

Create a new file `app.js` and initialize the Appwrite Client. Replace `<PROJECT_ID>` with your project ID and `<YOUR_API_KEY>` with your API key.

```web-code js line-numbers
const sdk = require("node-appwrite");

const client = new sdk.Client();

client
    .setEndpoint("https://<REGION>.cloud.appwrite.io/v1")
    .setProject("<PROJECT_ID>")
    .setKey("<YOUR_API_KEY>");

```

Once the Appwrite Client is initialized, create a function to configure a todo table.

```web-code js line-numbers
const tablesDB = new sdk.TablesDB(client);

var todoDatabase;
var todoTable;

async function prepareDatabase() {
    todoDatabase = await tablesDB.create({
        databaseId: sdk.ID.unique(),
        name: 'TodosDB'
    });

    todoTable = await tablesDB.createTable({
        databaseId: todoDatabase.$id,
        tableId: sdk.ID.unique(),
        name: 'Todos'
    });

    await tablesDB.createStringColumn({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        key: 'title',
        size: 255,
        required: true
    });

    await tablesDB.createStringColumn({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        key: 'description',
        size: 255,
        required: false,
        default: 'This is a test description'
    });

    await tablesDB.createBooleanColumn({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        key: 'isComplete',
        required: true
    });
}

```

Create a function to add some mock data into your new table.

```web-code js line-numbers
async function seedDatabase() {
    var testTodo1 = {
        title: 'Buy apples',
        description: 'At least 2KGs',
        isComplete: true
    };

    var testTodo2 = {
        title: 'Wash the apples',
        isComplete: true
    };

    var testTodo3 = {
        title: 'Cut the apples',
        description: 'Don\'t forget to pack them in a box',
        isComplete: false
    };

    await tablesDB.createRow({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        rowId: sdk.ID.unique(),
        data: testTodo1
    });
    await tablesDB.createRow({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        rowId: sdk.ID.unique(),
        data: testTodo2
    });
    await tablesDB.createRow({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        rowId: sdk.ID.unique(),
        data: testTodo3
    });
}

```

Create a function to retrieve the mock todo data and a function to execute the requests in order. Run the functions to by calling `runAllTasks();`.

```web-code js line-numbers
const { Query } = require('node-appwrite');

async function getTodos() {
    // Retrieve rows (default limit is 25)
    var todos = await tablesDB.listRows({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id
    });

    console.log("Todos:");
    todos.rows.forEach(todo => {
        console.log(`Title: ${todo.title}\nDescription: ${todo.description}\nIs Todo Complete: ${todo.isComplete}\n\n`);
    });
}

async function getCompletedTodos() {
    // Use queries to filter completed todos with pagination
    var todos = await tablesDB.listRows({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        queries: [\
            Query.equal("isComplete", true),\
            Query.orderDesc("$createdAt"),\
            Query.limit(5)\
        ]
    });

    console.log("Completed todos (limited to 5):");
    todos.rows.forEach(todo => {
        console.log(`Title: ${todo.title}\nDescription: ${todo.description}\nIs Todo Complete: ${todo.isComplete}\n\n`);
    });
}

async function getIncompleteTodos() {
    // Query for incomplete todos
    var todos = await tablesDB.listRows({
        databaseId: todoDatabase.$id,
        tableId: todoTable.$id,
        queries: [\
            Query.equal("isComplete", false),\
            Query.orderAsc("title")\
        ]
    });

    console.log("Incomplete todos (ordered by title):");
    todos.rows.forEach(todo => {
        console.log(`Title: ${todo.title}\nDescription: ${todo.description}\nIs Todo Complete: ${todo.isComplete}\n\n`);
    });
}

async function runAllTasks() {
    await prepareDatabase();
    await seedDatabase();
    await getTodos();
    await getCompletedTodos();
    await getIncompleteTodos();
}
runAllTasks();

```

For better type safety in TypeScript Node.js projects, define interfaces and use generics:

```web-code typescript line-numbers
interface Todo {
    title: string;
    description: string;
    isComplete: boolean;
}

import { Client, TablesDB } from 'node-appwrite';

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const tablesDB = new TablesDB(client);

// Type-safe database operations
async function getTodos() {
    const todos = await tablesDB.listRows<Todo>({
        databaseId: '<DATABASE_ID>',
        tableId: '<TABLE_ID>'
    });

    todos.rows.forEach(todo => {
        console.log(`Title: ${todo.title} - Complete: ${todo.isComplete}`);
    });
}

```

##### Generate types automatically

Use the [Appwrite CLI](https://appwrite.io/docs/products/databases/type-generation) to generate TypeScript interfaces automatically: `appwrite types ./types`

Run your project with `node app.js` and view the response in your console.

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
