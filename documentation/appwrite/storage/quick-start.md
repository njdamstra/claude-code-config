# Storage Quick Start

[Skip to content](https://appwrite.io/docs/products/storage/quick-start#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

You can create your first bucket, upload, and download your first file in minutes.

## [Create bucket](https://appwrite.io/docs/products/storage/quick-start\#create-bucket)

You can create a bucket in the Appwrite Console by navigating to **Storage** \> **Create bucket**.

In your bucket, navigate to **Settings** \> **Permissions**, then add a new **Any** role with **CREATE** and **READ** permissions. This allows anyone to create and read files in this bucket.

## [Create file](https://appwrite.io/docs/products/storage/quick-start\#create-file)

To upload a file, add this to your app. For web apps, you can use the File object directly. For Node.js apps, use the InputFile class.

```web-code client-web line-numbers
import { Client, Storage } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
    .setProject('<PROJECT_ID>');

const storage = new Storage(client);

const promise = storage.createFile({
    bucketId: '<BUCKET_ID>',
    fileId: ID.unique(),
    file: document.getElementById('uploader').files[0]
});

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

## [Download file](https://appwrite.io/docs/products/storage/quick-start\#download-file)

To download a file, use the `getFileDownload` method.

```web-code client-web line-numbers
import { Client, Storage } from "appwrite";

const client = new Client();

const storage = new Storage(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;

const result = storage.getFileDownload({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>'
});

console.log(result); // Resource URL

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
