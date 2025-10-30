# Start with Authentication - Quick Start

You can get up and running with Appwrite Authentication in minutes. You can add basic email and password authentication to your app with just a few lines of code.

You can use the Appwrite [Client SDKs](https://appwrite.io/docs/sdks#client) to create an account using email and password.

## Create Account

```javascript
import { Client, Account, ID } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const user = await account.create({
    userId: ID.unique(),
    email: 'email@example.com',
    password: 'password'
});
```

## Login

After you've created your account, users can be logged in using the [Create Email Session](https://appwrite.io/docs/references/cloud/client-web/account#createEmailPasswordSession) method.

```javascript
const session = await account.createEmailPasswordSession({
    email: email,
    password: password
});
```

## Check Authentication Status

After logging in, you can check the authentication state of the user.

Appwrite's SDKs are stateless, so you need to manage the session state in your app. You can use the [Get Account](https://appwrite.io/docs/references/cloud/client-web/account#get) method to check if the user is logged in.

```javascript
try {
    const user = await account.get();
    // Logged in
} catch (err) {
    // Not logged in
}
```

A common pattern is to use route guards to redirect users to the login page if they are not authenticated. You can check the authentication state on app launch and before entering a protected route by calling `get()`.

Route guard implementations are **opinionated** and depend on the platform and framework you are using.

[See full documentation for framework-specific examples](https://appwrite.io/docs/products/auth/quick-start)
