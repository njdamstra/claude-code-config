[Skip to content](https://appwrite.io/docs/products/auth/anonymous#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Anonymous sessions allow you to implement **guest** users. Guest users let you store user information like items in their cart or theme preferences before they create an account. This reduces the friction for your users to get started with your app.

**If a user later creates an account**, their information will be inherited by the newly created account.

## [Create anonymous session](https://appwrite.io/docs/products/auth/anonymous\#createSession)

Create an anonymous session with [Create Anonymous Session](https://appwrite.io/docs/references/cloud/client-web/account#createAnonymousSession) method.

```web-code client-web line-numbers
import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

const promise = account.createAnonymousSession();

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

## [Attaching an account](https://appwrite.io/docs/products/auth/anonymous\#attach-account)

Anonymous users cannot sign back in. If the session expires, they move to another computer, or they clear their browser data, they won't be able to log in again. Remember to prompt the user to create an account to not lose their data.

Create an account with any of these methods to transition from an anonymous session to a user account session.

[Email and password](https://appwrite.io/docs/products/auth/email-password) [Phone (SMS)](https://appwrite.io/docs/products/auth/phone-sms) [Magic URL](https://appwrite.io/docs/products/auth/magic-url) [OAuth2](https://appwrite.io/docs/products/auth/oauth2)

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
