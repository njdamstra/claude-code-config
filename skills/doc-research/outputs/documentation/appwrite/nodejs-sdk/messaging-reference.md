[Skip to content](https://appwrite.io/docs/references/cloud/server-nodejs/messaging#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Appwrite Messaging helps you communicate with your users through push notifications, emails, and SMS text messages.
Sending personalized communication for marketing, updates, and realtime alerts can increase user engagement and retention.
You can also use Appwrite Messaging to implement security checks and custom authentication flows.

You can find guides and examples on using the Messaging API in the [Appwrite Messaging product pages](https://appwrite.io/docs/products/messaging).

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Create a new Apple Push Notification service provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- APNS authentication key.

- APNS authentication key ID.

- APNS team ID.

- APNS bundle ID.

- Use APNS sandbox environment.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/apns

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createAPNSProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    authKey: '<AUTH_KEY>', // optional
    authKeyId: '<AUTH_KEY_ID>', // optional
    teamId: '<TEAM_ID>', // optional
    bundleId: '<BUNDLE_ID>', // optional
    sandbox: false, // optional
    enabled: false // optional
});

```

Create a new Firebase Cloud Messaging provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- FCM service account JSON.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/fcm

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createFCMProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    serviceAccountJSON: {}, // optional
    enabled: false // optional
});

```

Create a new Mailgun provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- Mailgun API Key.

- Mailgun Domain.

- Set as EU region.

- Sender Name.

- Sender email address.

- Name set in the reply to field for the mail. Default value is sender name. Reply to name must have reply to email as well.

- Email set in the reply to field for the mail. Default value is sender email. Reply to email must have reply to name as well.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/mailgun

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createMailgunProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    apiKey: '<API_KEY>', // optional
    domain: '<DOMAIN>', // optional
    isEuRegion: false, // optional
    fromName: '<FROM_NAME>', // optional
    fromEmail: 'email@example.com', // optional
    replyToName: '<REPLY_TO_NAME>', // optional
    replyToEmail: 'email@example.com', // optional
    enabled: false // optional
});

```

Create a new MSG91 provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- Msg91 template ID

- Msg91 sender ID.

- Msg91 auth key.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/msg91

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createMsg91Provider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    templateId: '<TEMPLATE_ID>', // optional
    senderId: '<SENDER_ID>', // optional
    authKey: '<AUTH_KEY>', // optional
    enabled: false // optional
});

```

Create a new Sendgrid provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- Sendgrid API key.

- Sender Name.

- Sender email address.

- Name set in the reply to field for the mail. Default value is sender name.

- Email set in the reply to field for the mail. Default value is sender email.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/sendgrid

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createSendgridProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    apiKey: '<API_KEY>', // optional
    fromName: '<FROM_NAME>', // optional
    fromEmail: 'email@example.com', // optional
    replyToName: '<REPLY_TO_NAME>', // optional
    replyToEmail: 'email@example.com', // optional
    enabled: false // optional
});

```

Create a new SMTP provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- SMTP hosts. Either a single hostname or multiple semicolon-delimited hostnames. You can also specify a different port for each host such as `smtp1.example.com:25;smtp2.example.com`. You can also specify encryption type, for example: `tls://smtp1.example.com:587;ssl://smtp2.example.com:465"`. Hosts will be tried in order.

- The default SMTP server port.

- Authentication username.

- Authentication password.

- Encryption type. Can be omitted, 'ssl', or 'tls'

- Enable SMTP AutoTLS feature.

- The value to use for the X-Mailer header.

- Sender Name.

- Sender email address.

- Name set in the reply to field for the mail. Default value is sender name.

- Email set in the reply to field for the mail. Default value is sender email.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/smtp

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createSMTPProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    host: '<HOST>',
    port: 1, // optional
    username: '<USERNAME>', // optional
    password: '<PASSWORD>', // optional
    encryption: sdk.SmtpEncryption.None, // optional
    autoTLS: false, // optional
    mailer: '<MAILER>', // optional
    fromName: '<FROM_NAME>', // optional
    fromEmail: 'email@example.com', // optional
    replyToName: '<REPLY_TO_NAME>', // optional
    replyToEmail: 'email@example.com', // optional
    enabled: false // optional
});

```

Create a new Telesign provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- Sender Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.

- Telesign customer ID.

- Telesign API key.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/telesign

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createTelesignProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    from: '+12065550100', // optional
    customerId: '<CUSTOMER_ID>', // optional
    apiKey: '<API_KEY>', // optional
    enabled: false // optional
});

```

Create a new Textmagic provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- Sender Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.

- Textmagic username.

- Textmagic apiKey.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/textmagic

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createTextmagicProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    from: '+12065550100', // optional
    username: '<USERNAME>', // optional
    apiKey: '<API_KEY>', // optional
    enabled: false // optional
});

```

Create a new Twilio provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- Sender Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.

- Twilio account secret ID.

- Twilio authentication token.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/twilio

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createTwilioProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    from: '+12065550100', // optional
    accountSid: '<ACCOUNT_SID>', // optional
    authToken: '<AUTH_TOKEN>', // optional
    enabled: false // optional
});

```

Create a new Vonage provider.

- Request









- Provider ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Provider name.

- Sender Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.

- Vonage API key.

- Vonage API secret.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
POST /messaging/providers/vonage

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createVonageProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>',
    from: '+12065550100', // optional
    apiKey: '<API_KEY>', // optional
    apiSecret: '<API_SECRET>', // optional
    enabled: false // optional
});

```

Get a provider by its unique ID.

- Request









- Provider ID.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
GET /messaging/providers/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.getProvider({
    providerId: '<PROVIDER_ID>'
});

```

Get the provider activity logs listed by its unique ID.

- Request









- Provider ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Only supported methods are limit and offset


- Response









  - - [Logs List](https://appwrite.io/docs/references/cloud/models/logList)



```web-code text
GET /messaging/providers/{providerId}/logs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listProviderLogs({
    providerId: '<PROVIDER_ID>',
    queries: [] // optional
});

```

Get a list of all providers from the current Appwrite project.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, provider, type, enabled

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Provider list](https://appwrite.io/docs/references/cloud/models/providerList)



```web-code text
GET /messaging/providers

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listProviders({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update a Apple Push Notification service provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- APNS authentication key.

- APNS authentication key ID.

- APNS team ID.

- APNS bundle ID.

- Use APNS sandbox environment.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/apns/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateAPNSProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    authKey: '<AUTH_KEY>', // optional
    authKeyId: '<AUTH_KEY_ID>', // optional
    teamId: '<TEAM_ID>', // optional
    bundleId: '<BUNDLE_ID>', // optional
    sandbox: false // optional
});

```

Update a Firebase Cloud Messaging provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- FCM service account JSON.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/fcm/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateFCMProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    serviceAccountJSON: {} // optional
});

```

Update a Mailgun provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Mailgun API Key.

- Mailgun Domain.

- Set as EU region.

- Set as enabled.

- Sender Name.

- Sender email address.

- Name set in the reply to field for the mail. Default value is sender name.

- Email set in the reply to field for the mail. Default value is sender email.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/mailgun/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateMailgunProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    apiKey: '<API_KEY>', // optional
    domain: '<DOMAIN>', // optional
    isEuRegion: false, // optional
    enabled: false, // optional
    fromName: '<FROM_NAME>', // optional
    fromEmail: 'email@example.com', // optional
    replyToName: '<REPLY_TO_NAME>', // optional
    replyToEmail: '<REPLY_TO_EMAIL>' // optional
});

```

Update a MSG91 provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- Msg91 template ID.

- Msg91 sender ID.

- Msg91 auth key.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/msg91/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateMsg91Provider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    templateId: '<TEMPLATE_ID>', // optional
    senderId: '<SENDER_ID>', // optional
    authKey: '<AUTH_KEY>' // optional
});

```

Update a Sendgrid provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- Sendgrid API key.

- Sender Name.

- Sender email address.

- Name set in the Reply To field for the mail. Default value is Sender Name.

- Email set in the Reply To field for the mail. Default value is Sender Email.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/sendgrid/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateSendgridProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    apiKey: '<API_KEY>', // optional
    fromName: '<FROM_NAME>', // optional
    fromEmail: 'email@example.com', // optional
    replyToName: '<REPLY_TO_NAME>', // optional
    replyToEmail: '<REPLY_TO_EMAIL>' // optional
});

```

Update a SMTP provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- SMTP hosts. Either a single hostname or multiple semicolon-delimited hostnames. You can also specify a different port for each host such as `smtp1.example.com:25;smtp2.example.com`. You can also specify encryption type, for example: `tls://smtp1.example.com:587;ssl://smtp2.example.com:465"`. Hosts will be tried in order.

- SMTP port.

- Authentication username.

- Authentication password.

- Encryption type. Can be 'ssl' or 'tls'

- Enable SMTP AutoTLS feature.

- The value to use for the X-Mailer header.

- Sender Name.

- Sender email address.

- Name set in the Reply To field for the mail. Default value is Sender Name.

- Email set in the Reply To field for the mail. Default value is Sender Email.

- Set as enabled.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/smtp/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateSMTPProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    host: '<HOST>', // optional
    port: 1, // optional
    username: '<USERNAME>', // optional
    password: '<PASSWORD>', // optional
    encryption: sdk.SmtpEncryption.None, // optional
    autoTLS: false, // optional
    mailer: '<MAILER>', // optional
    fromName: '<FROM_NAME>', // optional
    fromEmail: 'email@example.com', // optional
    replyToName: '<REPLY_TO_NAME>', // optional
    replyToEmail: '<REPLY_TO_EMAIL>', // optional
    enabled: false // optional
});

```

Update a Telesign provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- Telesign customer ID.

- Telesign API key.

- Sender number.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/telesign/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateTelesignProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    customerId: '<CUSTOMER_ID>', // optional
    apiKey: '<API_KEY>', // optional
    from: '<FROM>' // optional
});

```

Update a Textmagic provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- Textmagic username.

- Textmagic apiKey.

- Sender number.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/textmagic/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateTextmagicProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    username: '<USERNAME>', // optional
    apiKey: '<API_KEY>', // optional
    from: '<FROM>' // optional
});

```

Update a Twilio provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- Twilio account secret ID.

- Twilio authentication token.

- Sender number.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/twilio/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateTwilioProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    accountSid: '<ACCOUNT_SID>', // optional
    authToken: '<AUTH_TOKEN>', // optional
    from: '<FROM>' // optional
});

```

Update a Vonage provider by its unique ID.

- Request









- Provider ID.

- Provider name.

- Set as enabled.

- Vonage API key.

- Vonage API secret.

- Sender number.


- Response









  - - [Provider](https://appwrite.io/docs/references/cloud/models/provider)



```web-code text
PATCH /messaging/providers/vonage/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateVonageProvider({
    providerId: '<PROVIDER_ID>',
    name: '<NAME>', // optional
    enabled: false, // optional
    apiKey: '<API_KEY>', // optional
    apiSecret: '<API_SECRET>', // optional
    from: '<FROM>' // optional
});

```

Delete a provider by its unique ID.

- Request









- Provider ID.


- Response

```web-code text
DELETE /messaging/providers/{providerId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.deleteProvider({
    providerId: '<PROVIDER_ID>'
});

```

Create a new topic.

- Request









- Topic ID. Choose a custom Topic ID or a new Topic ID.

- Topic Name.

- An array of role strings with subscribe permission. By default all users are granted with any subscribe permission. [learn more about roles](https://appwrite.io/docs/permissions#permission-roles). Maximum of 100 roles are allowed, each 64 characters long.


- Response









  - - [Topic](https://appwrite.io/docs/references/cloud/models/topic)



```web-code text
POST /messaging/topics

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createTopic({
    topicId: '<TOPIC_ID>',
    name: '<NAME>',
    subscribe: ["any"] // optional
});

```

Get a topic by its unique ID.

- Request









- Topic ID.


- Response









  - - [Topic](https://appwrite.io/docs/references/cloud/models/topic)



```web-code text
GET /messaging/topics/{topicId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.getTopic({
    topicId: '<TOPIC_ID>'
});

```

Get the topic activity logs listed by its unique ID.

- Request









- Topic ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Only supported methods are limit and offset


- Response









  - - [Logs List](https://appwrite.io/docs/references/cloud/models/logList)



```web-code text
GET /messaging/topics/{topicId}/logs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listTopicLogs({
    topicId: '<TOPIC_ID>',
    queries: [] // optional
});

```

Get a list of all topics from the current Appwrite project.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, description, emailTotal, smsTotal, pushTotal

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Topic list](https://appwrite.io/docs/references/cloud/models/topicList)



```web-code text
GET /messaging/topics

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listTopics({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update a topic by its unique ID.

- Request









- Topic ID.

- Topic Name.

- An array of role strings with subscribe permission. By default all users are granted with any subscribe permission. [learn more about roles](https://appwrite.io/docs/permissions#permission-roles). Maximum of 100 roles are allowed, each 64 characters long.


- Response









  - - [Topic](https://appwrite.io/docs/references/cloud/models/topic)



```web-code text
PATCH /messaging/topics/{topicId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateTopic({
    topicId: '<TOPIC_ID>',
    name: '<NAME>', // optional
    subscribe: ["any"] // optional
});

```

Delete a topic by its unique ID.

- Request









- Topic ID.


- Response

```web-code text
DELETE /messaging/topics/{topicId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.deleteTopic({
    topicId: '<TOPIC_ID>'
});

```

Create a new subscriber.

- Request









- Topic ID. The topic ID to subscribe to.

- Subscriber ID. Choose a custom Subscriber ID or a new Subscriber ID.

- Target ID. The target ID to link to the specified Topic ID.


- Response









  - - [Subscriber](https://appwrite.io/docs/references/cloud/models/subscriber)



```web-code text
POST /messaging/topics/{topicId}/subscribers

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setJWT('<YOUR_JWT>'); // Your secret JSON Web Token

const messaging = new sdk.Messaging(client);

const result = await messaging.createSubscriber({
    topicId: '<TOPIC_ID>',
    subscriberId: '<SUBSCRIBER_ID>',
    targetId: '<TARGET_ID>'
});

```

Get a subscriber by its unique ID.

- Request









- Topic ID. The topic ID subscribed to.

- Subscriber ID.


- Response









  - - [Subscriber](https://appwrite.io/docs/references/cloud/models/subscriber)



```web-code text
GET /messaging/topics/{topicId}/subscribers/{subscriberId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.getSubscriber({
    topicId: '<TOPIC_ID>',
    subscriberId: '<SUBSCRIBER_ID>'
});

```

Get the subscriber activity logs listed by its unique ID.

- Request









- Subscriber ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Only supported methods are limit and offset


- Response









  - - [Logs List](https://appwrite.io/docs/references/cloud/models/logList)



```web-code text
GET /messaging/subscribers/{subscriberId}/logs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listSubscriberLogs({
    subscriberId: '<SUBSCRIBER_ID>',
    queries: [] // optional
});

```

Get a list of all subscribers from the current Appwrite project.

- Request









- Topic ID. The topic ID subscribed to.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, provider, type, enabled

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Subscriber list](https://appwrite.io/docs/references/cloud/models/subscriberList)



```web-code text
GET /messaging/topics/{topicId}/subscribers

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listSubscribers({
    topicId: '<TOPIC_ID>',
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Delete a subscriber by its unique ID.

- Request









- Topic ID. The topic ID subscribed to.

- Subscriber ID.


- Response

```web-code text
DELETE /messaging/topics/{topicId}/subscribers/{subscriberId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setJWT('<YOUR_JWT>'); // Your secret JSON Web Token

const messaging = new sdk.Messaging(client);

const result = await messaging.deleteSubscriber({
    topicId: '<TOPIC_ID>',
    subscriberId: '<SUBSCRIBER_ID>'
});

```

Create a new email message.

- Request









- Message ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Email Subject.

- Email Content.

- List of Topic IDs.

- List of User IDs.

- List of Targets IDs.

- Array of target IDs to be added as CC.

- Array of target IDs to be added as BCC.

- Array of compound ID strings of bucket IDs and file IDs to be attached to the email. They should be formatted as <BUCKET\_ID>:<FILE\_ID>.

- Is message a draft

- Is content of type HTML

- Scheduled delivery time for message in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. DateTime value must be in future.


- Response









  - - [Message](https://appwrite.io/docs/references/cloud/models/message)



```web-code text
POST /messaging/messages/email

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createEmail({
    messageId: '<MESSAGE_ID>',
    subject: '<SUBJECT>',
    content: '<CONTENT>',
    topics: [], // optional
    users: [], // optional
    targets: [], // optional
    cc: [], // optional
    bcc: [], // optional
    attachments: [], // optional
    draft: false, // optional
    html: false, // optional
    scheduledAt: '' // optional
});

```

Create a new push notification.

- Request









- Message ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Title for push notification.

- Body for push notification.

- List of Topic IDs.

- List of User IDs.

- List of Targets IDs.

- Additional key-value pair data for push notification.

- Action for push notification.

- Image for push notification. Must be a compound bucket ID to file ID of a jpeg, png, or bmp image in Appwrite Storage. It should be formatted as <BUCKET\_ID>:<FILE\_ID>.

- Icon for push notification. Available only for Android and Web Platform.

- Sound for push notification. Available only for Android and iOS Platform.

- Color for push notification. Available only for Android Platform.

- Tag for push notification. Available only for Android Platform.

- Badge for push notification. Available only for iOS Platform.

- Is message a draft

- Scheduled delivery time for message in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. DateTime value must be in future.

- If set to true, the notification will be delivered in the background. Available only for iOS Platform.

- If set to true, the notification will be marked as critical. This requires the app to have the critical notification entitlement. Available only for iOS Platform.

- Set the notification priority. "normal" will consider device state and may not deliver notifications immediately. "high" will always attempt to immediately deliver the notification.


- Response









  - - [Message](https://appwrite.io/docs/references/cloud/models/message)



```web-code text
POST /messaging/messages/push

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createPush({
    messageId: '<MESSAGE_ID>',
    title: '<TITLE>', // optional
    body: '<BODY>', // optional
    topics: [], // optional
    users: [], // optional
    targets: [], // optional
    data: {}, // optional
    action: '<ACTION>', // optional
    image: '[ID1:ID2]', // optional
    icon: '<ICON>', // optional
    sound: '<SOUND>', // optional
    color: '<COLOR>', // optional
    tag: '<TAG>', // optional
    badge: null, // optional
    draft: false, // optional
    scheduledAt: '', // optional
    contentAvailable: false, // optional
    critical: false, // optional
    priority: sdk.MessagePriority.Normal // optional
});

```

Create a new SMS message.

- Request









- Message ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- SMS Content.

- List of Topic IDs.

- List of User IDs.

- List of Targets IDs.

- Is message a draft

- Scheduled delivery time for message in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. DateTime value must be in future.


- Response









  - - [Message](https://appwrite.io/docs/references/cloud/models/message)



```web-code text
POST /messaging/messages/sms

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.createSMS({
    messageId: '<MESSAGE_ID>',
    content: '<CONTENT>',
    topics: [], // optional
    users: [], // optional
    targets: [], // optional
    draft: false, // optional
    scheduledAt: '' // optional
});

```

Get a message by its unique ID.

- Request









- Message ID.


- Response









  - - [Message](https://appwrite.io/docs/references/cloud/models/message)



```web-code text
GET /messaging/messages/{messageId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.getMessage({
    messageId: '<MESSAGE_ID>'
});

```

Get a list of the targets associated with a message.

- Request









- Message ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: userId, providerId, identifier, providerType


- Response









  - - [Target list](https://appwrite.io/docs/references/cloud/models/targetList)



```web-code text
GET /messaging/messages/{messageId}/targets

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listTargets({
    messageId: '<MESSAGE_ID>',
    queries: [] // optional
});

```

Get a list of all messages from the current Appwrite project.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: scheduledAt, deliveredAt, deliveredTotal, status, description, providerType

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Message list](https://appwrite.io/docs/references/cloud/models/messageList)



```web-code text
GET /messaging/messages

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listMessages({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update an email message by its unique ID. This endpoint only works on messages that are in draft status. Messages that are already processing, sent, or failed cannot be updated.

- Request









- Message ID.

- List of Topic IDs.

- List of User IDs.

- List of Targets IDs.

- Email Subject.

- Email Content.

- Is message a draft

- Is content of type HTML

- Array of target IDs to be added as CC.

- Array of target IDs to be added as BCC.

- Scheduled delivery time for message in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. DateTime value must be in future.

- Array of compound ID strings of bucket IDs and file IDs to be attached to the email. They should be formatted as <BUCKET\_ID>:<FILE\_ID>.


- Response









  - - [Message](https://appwrite.io/docs/references/cloud/models/message)



```web-code text
PATCH /messaging/messages/email/{messageId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateEmail({
    messageId: '<MESSAGE_ID>',
    topics: [], // optional
    users: [], // optional
    targets: [], // optional
    subject: '<SUBJECT>', // optional
    content: '<CONTENT>', // optional
    draft: false, // optional
    html: false, // optional
    cc: [], // optional
    bcc: [], // optional
    scheduledAt: '', // optional
    attachments: [] // optional
});

```

Update a push notification by its unique ID. This endpoint only works on messages that are in draft status. Messages that are already processing, sent, or failed cannot be updated.

- Request









- Message ID.

- List of Topic IDs.

- List of User IDs.

- List of Targets IDs.

- Title for push notification.

- Body for push notification.

- Additional Data for push notification.

- Action for push notification.

- Image for push notification. Must be a compound bucket ID to file ID of a jpeg, png, or bmp image in Appwrite Storage. It should be formatted as <BUCKET\_ID>:<FILE\_ID>.

- Icon for push notification. Available only for Android and Web platforms.

- Sound for push notification. Available only for Android and iOS platforms.

- Color for push notification. Available only for Android platforms.

- Tag for push notification. Available only for Android platforms.

- Badge for push notification. Available only for iOS platforms.

- Is message a draft

- Scheduled delivery time for message in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. DateTime value must be in future.

- If set to true, the notification will be delivered in the background. Available only for iOS Platform.

- If set to true, the notification will be marked as critical. This requires the app to have the critical notification entitlement. Available only for iOS Platform.

- Set the notification priority. "normal" will consider device battery state and may send notifications later. "high" will always attempt to immediately deliver the notification.


- Response









  - - [Message](https://appwrite.io/docs/references/cloud/models/message)



```web-code text
PATCH /messaging/messages/push/{messageId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updatePush({
    messageId: '<MESSAGE_ID>',
    topics: [], // optional
    users: [], // optional
    targets: [], // optional
    title: '<TITLE>', // optional
    body: '<BODY>', // optional
    data: {}, // optional
    action: '<ACTION>', // optional
    image: '[ID1:ID2]', // optional
    icon: '<ICON>', // optional
    sound: '<SOUND>', // optional
    color: '<COLOR>', // optional
    tag: '<TAG>', // optional
    badge: null, // optional
    draft: false, // optional
    scheduledAt: '', // optional
    contentAvailable: false, // optional
    critical: false, // optional
    priority: sdk.MessagePriority.Normal // optional
});

```

Update an SMS message by its unique ID. This endpoint only works on messages that are in draft status. Messages that are already processing, sent, or failed cannot be updated.

- Request









- Message ID.

- List of Topic IDs.

- List of User IDs.

- List of Targets IDs.

- Email Content.

- Is message a draft

- Scheduled delivery time for message in [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) format. DateTime value must be in future.


- Response









  - - [Message](https://appwrite.io/docs/references/cloud/models/message)



```web-code text
PATCH /messaging/messages/sms/{messageId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.updateSMS({
    messageId: '<MESSAGE_ID>',
    topics: [], // optional
    users: [], // optional
    targets: [], // optional
    content: '<CONTENT>', // optional
    draft: false, // optional
    scheduledAt: '' // optional
});

```

Delete a message. If the message is not a draft or scheduled, but has been sent, this will not recall the message.

- Request









- Message ID.


- Response

```web-code text
DELETE /messaging/messages/{messageId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.delete({
    messageId: '<MESSAGE_ID>'
});

```

Get the message activity logs listed by its unique ID.

- Request









- Message ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Only supported methods are limit and offset


- Response









  - - [Logs List](https://appwrite.io/docs/references/cloud/models/logList)



```web-code text
GET /messaging/messages/{messageId}/logs

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const messaging = new sdk.Messaging(client);

const result = await messaging.listMessageLogs({
    messageId: '<MESSAGE_ID>',
    queries: [] // optional
});

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Messaging API Reference - Docs - Appwrite