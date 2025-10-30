# Web SDK Quick Start

[Skip to content](https://appwrite.io/docs/quick-starts/web#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Learn how to add Appwrite to your web apps.

Head to the [Appwrite Console](https://cloud.appwrite.io/console).

![Create project screen](https://appwrite.io/images/docs/quick-starts/dark/create-project.png)

![Create project screen](https://appwrite.io/images/docs/quick-starts/create-project.png)

If this is your first time using Appwrite, create an account and create your first project.

Then, under **Add a platform**, add a **Web app**. The **Hostname** should be `localhost` or the domain on which you're hosting your web app.

![Add a platform](https://appwrite.io/images/docs/quick-starts/dark/add-platform.png)

![Add a platform](https://appwrite.io/images/docs/quick-starts/add-platform.png)

You can skip optional steps.

You can install the Appwrite Web SDK using a package manager.

```web-code sh line-numbers
npm install appwrite

```

You can also add the Appwrite Web SDK using CDN by adding a script tag to your HTML file. The SDK will be available globally through the `Appwrite` namespace.

```web-code html line-numbers
<script src="https://cdn.jsdelivr.net/npm/appwrite@17.0.0"></script>

```

If you installed via npm, you can import `Client` and `Account` from the Appwrite SDK.

```web-code client-web line-numbers
import { Client, Account } from 'appwrite';

export const client = new Client();

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>'); // Replace with your project ID

export const account = new Account(client);
export { ID } from 'appwrite';

```

If you're using CDN, the library loads directly in your browser as a global object, so you access it through Appwrite instead of imports.

```web-code js line-numbers
const client = new Appwrite.Client()

client
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>') // Replace with your project ID

const account = new Appwrite.Account(client)
const tablesDB = new Appwrite.TablesDB(client)

```

If you prefer TypeScript, you can import TypeScript models from the Appwrite SDK.

```web-code ts line-numbers
// appwrite.ts

import { Client, TablesDB, Account } from "appwrite";
// Import type models for Appwrite
import { type Models } from 'appwrite';

const client: Client = new Client();

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>'); // Replace with your project ID

export const account: Account = new Account(client);
export const tablesDB: TablesDB = new TablesDB(client);

// You then use the imported type definitions like this
const authUser: Models.Session = await account.createEmailPasswordSession({
  email,
  password
});

```

Sometimes you'll need to extend TypeScript models with your own type definitions.

For example, when you fetch a list of rows from a table, you can define the expected structure of the rows like this.

```web-code ts line-numbers
interface Idea extends Models.Row {
    title: string;
    description: string;
    userId: string;
}

```

When you fetch rows, you can use this new `Idea` interface like this.

```web-code ts line-numbers
const response = await tablesDB.listRows({
    databaseId: ideasDatabaseId,
    tableId: ideasTableId,
    queries: [Query.orderDesc("$createdAt"), Query.limit(queryLimit)]
});
const ideas = response.rows as Idea[];

```

The Appwrite SDK works with your favorite Web frameworks.

Learn to use Appwrite by adding authentication to a simple web app.

[Get started with Appwrite and Next.js](https://appwrite.io/docs/quick-starts/nextjs) [Get started with Appwrite and React](https://appwrite.io/docs/quick-starts/react) [Get started with Appwrite and Vue.js](https://appwrite.io/docs/quick-starts/vue) [Get started with Appwrite and Nuxt](https://appwrite.io/docs/quick-starts/nuxt) [Get started with Appwrite and SvelteKit](https://appwrite.io/docs/quick-starts/sveltekit) [Get started with Appwrite and Angular](https://appwrite.io/docs/quick-starts/angular)

Learn to use Appwrite by building an idea tracker app.

[Get started with Appwrite and React](https://appwrite.io/docs/tutorials/react) [Get started with Appwrite and Vue.js](https://appwrite.io/docs/tutorials/vue) [Get started with Appwrite and Nuxt](https://appwrite.io/docs/tutorials/nuxt) [Get started with Appwrite and SvelteKit](https://appwrite.io/docs/tutorials/sveltekit)

### [Type safety with TypeScript](https://appwrite.io/docs/quick-starts/web\#type-safety-with-typescript)

For better type safety in TypeScript projects, define interfaces and use generics:

```web-code typescript line-numbers
interface User {
    name: string;
    email: string;
    isVerified: boolean;
}

import { Client, TablesDB } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const databases = new TablesDB(client);

// Type-safe database operations
try {
    const users = await databases.listRows<User>({
        databaseId: '[DATABASE_ID]',
        tableId: '[TABLE_ID]'
    });

    users.rows.forEach(user => {
        console.log(`User: ${user.name} (${user.email})`);
    });
} catch (error) {
    console.log(error);
}

```

##### Generate types automatically

Use the [Appwrite CLI](https://appwrite.io/docs/products/databases/type-generation) to generate TypeScript interfaces automatically: `appwrite types ./types`

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
