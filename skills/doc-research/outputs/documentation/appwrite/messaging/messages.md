[Skip to content](https://appwrite.io/docs/products/messaging/messages#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Each time you send or schedule a push notification, email, or SMS text, it's recorded in Appwrite as a **message** is displayed in the **Messages** tab.

![Add a target](https://appwrite.io/images/docs/messaging/messages/dark/messages-overview.png)

![Add a target](https://appwrite.io/images/docs/messaging/messages/messages-overview.png)

## [Messages](https://appwrite.io/docs/products/messaging/messages\#messages)

Each message displays with the following information.

| Column | Description |
| --- | --- |
| Message ID | The unique ID of the message. |
| Description | The developer defined description of the message. End users do not see this description. |
| Message | The message delivered to end users. |
| Type | Type of message, either `Push`, `Email`, and `SMS`. |
| Status | Indicates the status of the message, can be one of `draft`, `scheduled`, `processing`, `failed`, `success`. |
| Scheduled at | Indicates the scheduled delivery time of the message. |
| Delivered at | Indicates the time at which the message was successfully delivered. |

## [Messages types](https://appwrite.io/docs/products/messaging/messages\#messages-types)

There are three types of messages

| Message type | Description |
| --- | --- |
| Push notifications | Push notifications are alerts that show up on a user device's notification center. This can be used to deliver messages to the user whether their application is open or not. |
| Emails | Emails let you deliver rich content to a users' inbox. Appwrite allows you to send customized HTML email messages so you can include links, styling, and more. |
| SMS | SMS messages let you deliver text messages to your user's phone. This helps you reach your user, even when their device do not have internet access. |

## [Messages lifecycle](https://appwrite.io/docs/products/messaging/messages\#messages-lifecycle)

Messages can begin as a `draft`, or proceed directly to `processing` if it's sent immediately. If the message is scheduled to be sent later, its status is set to `scheduled`, then to `processing` at schedule time. After attempted delivery, it is marked as `sent` or `failed` depending on if the message was successfully delivered.

![Message lifecycle](https://appwrite.io/images/docs/messaging/dark/message-status.png)

![Message lifecycle](https://appwrite.io/images/docs/messaging/message-status.png)

## [Choosing a message type](https://appwrite.io/docs/products/messaging/messages\#choosing-a-message-type)

Choosing the right type of notification to reach your audience is important for your app's success. Here are some common factors to consider when deciding what type of message should be sent.

| Message type | Description |
| --- | --- |
| Time-sensitive messages | Push notifications or SMS messages are ideal for time-sensitive messages, as they are typically checked frequently and opened within minutes, ensuring prompt attention. |
| Guaranteed delivery | Emails and SMS messages are more reliable for guaranteed delivery of important messages like invoices and order confirmations, as push notifications can be easily missed. |
| Content-rich messages | Emails are best suited for delivering content-rich messages like promotional letters, detailed updates, and newsletters, thanks to support for HTML, allowing for rich text, links, and styling. |
| Increasing engagement | Push notifications are effective for increasing engagement with users, as they can be clicked on to link directly to your app, promoting immediate interaction. |
| Accessibility and reach | Emails and SMS messages allow you to reach users even before they have installed your app, making them suitable for announcement-type messages that require broad accessibility. |

## [Composing messages](https://appwrite.io/docs/products/messaging/messages\#composing-messages)

Different types of messages have different content and configurable options. Here are the different components that make up a message.

Push notificationsEmailsSMS

Push notificationsEmails
More

SMS

| Parameter | Required | Description |
| --- | --- | --- |
| `messageId` | required | The title of the push notification. This is the headline text that recipients see first. |
| `title` | optional | The title of the push notification. This is the headline text that recipients see first. Can be omitted for background notifications. |
| `body` | optional | The main content or body of the push notification. Provides the details or message you want to convey. Can be omitted for background notifications. |
| `data` | optional | Extra key-value pairs that apps can use to handle the notification more effectively, such as directing users to a specific part of the app. |
| `action` | optional | Specifies which activity or view controller to open within the app when the notification is tapped. |
| `icon` | optional | Sets the icon of the notification, used only for Android devices. This can help in branding the notification. |
| `sound` | optional | Sets the sound to use for the notification. For Android, the sound file must be located in `/res/raw`; for Apple devices, it must be in the app's main bundle or the `Library/Sounds` folder of the app container. |
| `color` | optional | Specifies a color tint for the notification icon, used only for Android devices. This can be used to align with brand colors. |
| `tag` | optional | Can be used to replace an existing notification with the same tag, used only for Android devices. Useful for updating or canceling notifications. |
| `badge` | optional | Sets the number to display next to the app's icon, indicating the number of notifications or updates. Setting to 0 removes any existing badge. Must be an integer. For Apple devices only. |
| `contentAvailable` | optional | For iOS devices only. When set, wakes up the app in the background without showing a notification. Used to update app data remotely. Requires priority to be set to normal. **Note:** APNS may throttle if sending more than 2-3 background notifications per hour. For Android, similar functionality can be achieved by sending a data-only notification without title and body. |
| `critical` | optional | For iOS devices only. Marks the notification as critical to bypass silent and do not disturb settings. Requires the app to have the critical notification entitlement from Apple. |
| `priority` | optional | Sets notification priority to normal or high. Normal priority delivers at the most convenient time based on battery life and may group notifications. High priority delivers immediately. |
| `draft` | optional | If the message is a draft, can be `true` or `false`. |
| `scheduledAt` | optional | An ISO date time string specifying when the push notification should be sent. |

| Parameter | Required | Description |
| --- | --- | --- |
| `subject` | required | The subject line of the email. This is what recipients see first in their inbox. |
| `content` | required | The main content of the email. This can be plain text or HTML, depending on the `html` flag. |
| `cc` | optional | An array of target IDs to be included in the carbon copy (CC) field. These recipients can see each other's email addresses. |
| `bcc` | optional | An array of target IDs to be included in the blind carbon copy (BCC) field. These recipients cannot see each other's email addresses. |
| `html` | optional | A boolean indicating whether the `content` is in HTML format. This allows for rich text, links, and styling in the email content. |
| `draft` | optional | If the message is a draft, can be `true` or `false`. |
| `scheduledAt` | optional | An ISO date time string specifying when the email should be sent. |

| Parameter | Required | Description |
| --- | --- | --- |
| `content` | required | The main content of the SMS. This should be concise and clear, as SMS messages have character limits. |
| `draft` | optional | If the message is a draft, can be `true` or `false`. |
| `scheduledAt` | optional | An ISO date time string specifying when the SMS should be sent. |

## [Sending a message](https://appwrite.io/docs/products/messaging/messages\#create-a-message)

You can create a message with a Server SDK. You can send a push notification like this.

```web-code server-nodejs line-numbers
const sdk = require('node-appwrite');

// Init SDK
const client = new sdk.Client();

const messaging = new sdk.Messaging(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>')                 // Your project ID
    .setKey('919c2d18fb5d4...a2ae413da83346ad2') // Your secret API key
;

const message = await messaging.createPush(
        '<MESSAGE_ID>',                          // messageId
        '<TITLE>',                               // title
        '<BODY>',                                // body
        [],                                      // topics (optional)
        [],                                      // users (optional)
        [],                                      // targets (optional)
        {},                                      // data (optional)
        '<ACTION>',                              // action (optional)
        '<ICON>',                                // icon (optional)
        '<SOUND>',                               // sound (optional)
        '<COLOR>',                               // color (optional)
        '<TAG>',                                 // tag (optional)
        1,                                       // badge (optional)
        false,                                   // contentAvailable (optional)
        false,                                   // critical (optional)
        'normal',                                // priority (optional)
        true,                                    // draft (optional)
        ''                                       // scheduledAt (optional)
    );

```

[Learn more about sending a push notification](https://appwrite.io/docs/products/messaging/send-push-notifications)

You can send an email like this.

```web-code server-nodejs line-numbers
const sdk = require('node-appwrite');

// Init SDK
const client = new sdk.Client();

const messaging = new sdk.Messaging(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>')                 // Your project ID
    .setKey('919c2d18fb5d4...a2ae413da83346ad2') // Your secret API key
;

const message - await messaging.createEmail(
        '<MESSAGE_ID>',                          // messageId
        '<SUBJECT>',                             // subject
        '<CONTENT>',                             // content
        [],                                      // topics (optional)
        [],                                      // users (optional)
        [],                                      // targets (optional)
        [],                                      // cc (optional)
        [],                                      // bcc (optional)
        true,                                    // draft (optional)
        false,                                   // html (optional)
        ''                                       // scheduledAt (optional)
    );

```

[Learn more about sending an email](https://appwrite.io/docs/products/messaging/send-email-messages)

You can send an SMS message like this.

```web-code server-nodejs line-numbers
const sdk = require('node-appwrite');

// Init SDK
const client = new sdk.Client();

const messaging = new sdk.Messaging(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>')                 // Your project ID
    .setKey('919c2d18fb5d4...a2ae413da83346ad2') // Your secret API key
;

const message = await messaging.createSms(
        '<MESSAGE_ID>',                          // messageId
        '<CONTENT>',                             // content
        [],                                      // topics (optional)
        [],                                      // users (optional)
        [],                                      // targets (optional)
        true,                                    // draft (optional)
        ''                                       // scheduledAt (optional)
    );

```

[Learn more about sending a SMS message](https://appwrite.io/docs/products/messaging/send-sms-messages)

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
