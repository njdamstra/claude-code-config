[Skip to content](https://appwrite.io/docs/references/cloud/client-web/messaging#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Appwrite Messaging helps you communicate with your users through push notifications, emails, and SMS text messages.
Sending personalized communication for marketing, updates, and realtime alerts can increase user engagement and retention.
You can also use Appwrite Messaging to implement security checks and custom authentication flows.

You can find guides and examples on using the Messaging API in the [Appwrite Messaging product pages](https://appwrite.io/docs/products/messaging).

```web-code text
https://<REGION>.cloud.appwrite.io/v1

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

```web-code client-web
import { Client, Messaging } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const messaging = new Messaging(client);

const result = await messaging.createSubscriber({
    topicId: '<TOPIC_ID>',
    subscriberId: '<SUBSCRIBER_ID>',
    targetId: '<TARGET_ID>'
});

console.log(result);

```

Delete a subscriber by its unique ID.

- Request









- Topic ID. The topic ID subscribed to.

- Subscriber ID.


- Response


```web-code text
DELETE /messaging/topics/{topicId}/subscribers/{subscriberId}

```

```web-code client-web
import { Client, Messaging } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const messaging = new Messaging(client);

const result = await messaging.deleteSubscriber({
    topicId: '<TOPIC_ID>',
    subscriberId: '<SUBSCRIBER_ID>'
});

console.log(result);

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Messaging API Reference - Docs - Appwrite