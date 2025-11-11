[Skip to content](https://appwrite.io/docs/products/auth/mfa#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Multi-factor authentication (MFA) greatly increases the security of your apps by adding additional layers of protection. When MFA is enabled, a malicious actor needs to compromise multiple authentication factors to gain unauthorized access. Appwrite Authentication lets you easily implement MFA in your apps, letting you build more securely and quickly.

##### Looking for MFA on your Console account?

This page covers MFA for your app's end-users. If you are looking for MFA on your Appwrite Console account, please refer to the [Console MFA page](https://appwrite.io/docs/advanced/security/mfa).

Appwrite currently allows two factors of authentication. More factors of authentication will be available soon.

Here are the steps to implement MFA in your application.

Initialize your Appwrite SDK's `Client`, `Account`, and `Avatars`. You'll use Avatars API to generate a QR code for the TOTP authenticator app, you can skip this import if you're not using TOTP.

```web-code client-web line-numbers
import { Client, Account, Avatars } from "appwrite";

const client = new Client();

const account = new Account(client);
const avatars = new Avatars(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;

```

Before enabling MFA, you should display recovery codes to the user. The codes are single use passwords the user can use to access their account if they lose access to their MFA email, phone, or authenticator app. These codes can **only be generated once**, warn the users to save them.

The code will look like this, display them to the user and remind them to save the codes in a secure place.

```web-code json line-numbers
{
    "recoveryCodes": [\
        "b654562828",\
        "a97c13d8c0",\
        "311580b5f3",\
        "c4262b3f88",\
        "7f6761afb4",\
        "55a09989be",\
    ]
}

```

These codes can be used to complete the [Complete challenge](https://appwrite.io/docs/products/auth/mfa#complete-challenge) step if the user loses access to their MFA factors. Generate the recovery codes by calling `account.createMfaRecoveryCodes()`.

```web-code client-web line-numbers
const response = await account.createMfaRecoveryCodes();
console.log(response.recoveryCodes);

```

Any verified email, phone number, or TOTP authenticator app can be used as a factor for MFA. Before they can be used as a factor, they need to be verified.

EmailPhoneAuthenticator

EmailPhone
More

Authenticator

First, set your user's email if they haven't already.

```web-code client-web line-numbers
const response = await account.updateEmail({
    email: 'email@example.com',
    password: 'password'
});

```

Then, initiate verification for the email by calling `account.createEmailVerification()`. Calling `createEmailVerification` will send a verification email to the user's email address with a link with the query parameter `userId` and `secret`.

```web-code client-web line-numbers
const res = await account.createVerification({
    url: 'https://example.com/verify-email'
});

```

After the user clicks the link in the email, they will be redirected to your site with the query parameters `userId` and `secret`. If you're on a mobile platform, you will need to create the appropriate deep link to handle the verification.

Finally, verify the email by calling `account.updateVerification()` with `userId` and `secret`.

```web-code client-web line-numbers
const response = await account.updateVerification({
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

```

First, set your user's phone number if they haven't already.

```web-code client-web line-numbers
const response = await account.updatePhone({
    phone: '+12065550100',
    password: 'password'
});

```

Then, initiate verification for the phone number by calling `account.createPhoneVerification()`.

```web-code client-web line-numbers
const response = await account.createPhoneVerification();

```

After the user receives the verification code, they can verify their phone number by calling `account.updatePhoneVerification()`.

```web-code client-web line-numbers
const response = await account.updatePhoneVerification({
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

```

First, add a TOTP authenticator to the user's account by calling `account.addAuthenticator()`.

```web-code client-web line-numbers
const { secret, uri } = await account.createMfaAuthenticator({
    type: 'totp'
});

```

This will create a secret and a URI. The URI is a URL that can be used to generate a QR code for the user to scan with their TOTP authenticator app.

You can generate a QR code for the user to scan by calling `avatars.getQR()`.

```web-code client-web line-numbers
const result = await avatars.getQR({
    text: uri,
    size: 800,  // optional
    margin: 0,  // optional
    download: false // optional
});

console.log(result); // Resource URL

```

If the user is unable to scan QR codes, you can display the `secret` to the user.

Finally prompt the user to enter a TOTP from their authenticator app, then verify the authenticator by calling `account.verifyMfaAuthenticator()`.

```web-code client-web line-numbers
const promise = account.updateMfaAuthenticator({
    type: 'totp',
    otp: '<OTP>'
});

```

You can enable MFA on your account by calling `account.updateMFA()`. You will need to have added more than 1 factors of authentication to an account before the MFA is enforced.

```web-code client-web line-numbers
const result = await account.updateMFA({
    enabled: true
});

```

Begin your login flow with the default authentication method used by your app, for example, email password.

```web-code client-web line-numbers
const session = await account.createEmailPasswordSession({
    email: 'email@example.com',
    password: 'password'
});

```

Upon successful login in the first authentication step, check the status of the login by calling `account.get()`. If more than one factors are required, you will receive the error `user_more_factors_required`. Redirect the user in your app to perform the MFA challenge.

```web-code client-web line-numbers
try {
    const response = await account.get();
    console.log(response);
} catch (error) {
    console.log(error);
    if (error.type === `user_more_factors_required`){
        // redirect to perform MFA
    }
    else {
        // handle other errors
    }
}

```

You can check which factors are enabled for an account using `account.listMfaFactors()`. The returned object will be formatted like this.

```web-code client-web line-numbers
{
    totp: true, // time-based one-time password
    email: false, // email
    phone: true // phone
}

```

```web-code client-web line-numbers
const factors = await account.listMfaFactors();
// redirect based on factors returned.

```

Based on the factors available, initialize an additional auth step. Calling these methods will send a challenge to the user. You will need to save the challenge ID to complete the challenge in a later step.

EmailPhoneTOTP

EmailPhone
More

TOTP

Appwrite will use a verified email on the user's account to send the challenge code via email. Note that this is only valid as a second factor if the user did not initialize their login with email OTP.

```web-code client-web line-numbers
const challenge = await account.createMfaChallenge({
    factor: 'email'
});

// Save the challenge ID to complete the challenge later
const challengeId = challenge.$id;

```

Appwrite will use a verified phone number on the user's account to send the challenge code via SMS. You cannot use this method if the user initialized their login with phone OTP.

```web-code client-web line-numbers
const challenge = await account.createMfaChallenge({
    factor: 'phone'
});

// Save the challenge ID to complete the challenge later
const challengeId = challenge.$id;

```

Initiate a challenge for users to complete using an authenticator app.

```web-code client-web line-numbers
const challenge = await account.createMfaChallenge({
    factor: AuthenticationFactor.Totp
});

// Save the challenge ID to complete the challenge later
const challengeId = challenge.$id;

```

Once the user receives the challenge code, you can pass the code back to Appwrite to complete the challenge.

```web-code client-web line-numbers
const response = await account.updateMfaChallenge({
    challengeId: '<CHALLENGE_ID>',
    otp: '<OTP>'
});

```

After completing the challenge, the user is now authenticated and all requests will be authorized. You can confirm this by running `account.get()`

In case your user needs to recover their account, they can use the recovery codes generated in the first step with the recovery code factor. Initialize the challenge by calling `account.createMfaChallenge()` with the factor `recoverycode`.

```web-code client-web line-numbers
const challenge = await account.createMfaChallenge({
    factor: AuthenticationFactor.Recoverycode
});

// Save the challenge ID to complete the challenge later
const challengeId = challenge.$id;

```

Then complete the challenge by calling `account.updateMfaChallenge()` with the challenge ID and the recovery code.

```web-code client-web line-numbers
const response = await account.updateMfaChallenge({
    challengeId: '<CHALLENGE_ID>',
    otp: '<RECOVERY_CODE>'
});

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
