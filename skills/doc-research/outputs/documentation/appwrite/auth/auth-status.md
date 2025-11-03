[Skip to content](https://appwrite.io/docs/products/auth/checking-auth-status#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

One of the first things your application needs to do when starting up is to check if the user is authenticated. This is an important step in creating a great user experience, as it determines whether to show login screens or protected content.

## [Check auth with `account.get()`](https://appwrite.io/docs/products/auth/checking-auth-status\#check-auth-with-accountget)

The recommended approach for checking authentication status is to use the `account.get()` method when your application starts:

```web-code client-web line-numbers
import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const account = new Account(client);

// Check if user is logged in
async function checkAuthStatus() {
    try {
        // If successful, user is authenticated
        const user = await account.get();
        console.log("User is authenticated:", user);
        // Proceed with your authenticated app flow
        return user;
    } catch (error) {
        console.error("User is not authenticated:", error);
        // Redirect to login page or show login UI
        // window.location.href = '/login';
        return null;
    }
}

// Call this function when your app initializes
checkAuthStatus();

```

## [Missing scope error](https://appwrite.io/docs/products/auth/checking-auth-status\#missing-scope-error)

When a user is not authenticated and you call `account.get()`, you might see an error message like:

```web-code sh line-numbers
User (role: guests) missing scope (account)

```

This error is telling you that:

1. The current user has the role of "guest" (unauthenticated visitor)
2. This guest user does not have the required permission scope to access account information
3. This is the expected behavior when a user is not logged in

##### Authentication flow

In a typical application flow:

1. Call `account.get()` when your app starts
2. If successful → User is authenticated → Show the main app UI
3. If error → User is not authenticated → Redirect to login screen

## [Best practices](https://appwrite.io/docs/products/auth/checking-auth-status\#best-practices)

- Call `account.get()` early in your application lifecycle
- Handle both authenticated and unauthenticated states gracefully
- Show appropriate loading states while checking authentication
- Implement proper error handling to avoid showing error messages to users

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
