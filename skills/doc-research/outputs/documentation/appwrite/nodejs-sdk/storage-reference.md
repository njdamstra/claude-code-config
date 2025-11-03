[Skip to content](https://appwrite.io/docs/references/cloud/server-nodejs/storage#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Storage service allows you to manage your project files. Using the Storage service, you can upload, view, download, and query all your project files.

Files are managed using buckets. Storage buckets are similar to Tables we have in our [Databases](https://appwrite.io/docs/products/databases) service. The difference is, buckets also provide more power to decide what kinds of files, what sizes you want to allow in that bucket, whether or not to encrypt the files, scan with antivirus and more.

Using Appwrite permissions architecture, you can assign read or write access to each bucket or file in your project for either a specific user, team, user role, or even grant it with public access ( `any`). You can learn more about [how Appwrite handles permissions and access control](https://appwrite.io/docs/advanced/platform/permissions).

The preview endpoint allows you to generate preview images for your files. Using the preview endpoint, you can also manipulate the resulting image so that it will fit perfectly inside your app in terms of dimensions, file size, and style. The preview endpoint also allows you to change the resulting image file format for better compression or image quality for better delivery over the network.

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Create a new storage bucket.

- Request









- Unique Id. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Bucket name

- An array of permission strings. By default, no user is granted with any permissions. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Enables configuring permissions for individual file. A user needs one of file or bucket level permissions to access a file. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Is bucket enabled? When set to 'disabled', users cannot access the files in this bucket but Server SDKs with and API key can still access the bucket. No files are lost when this is toggled.

- Maximum file size allowed in bytes. Maximum allowed value is 30MB.

- Allowed file extensions. Maximum of 100 extensions are allowed, each 64 characters long.

- Compression algorithm choosen for compression. Can be one of none, [gzip](https://en.wikipedia.org/wiki/Gzip), or [zstd](https://en.wikipedia.org/wiki/Zstd), For file size above 20MB compression is skipped even if it's enabled

- Is encryption enabled? For file size above 20MB encryption is skipped even if it's enabled

- Is virus scanning enabled? For file size above 20MB AntiVirus scanning is skipped even if it's enabled


- Response









  - - [Bucket](https://appwrite.io/docs/references/cloud/models/bucket)



```web-code text
POST /storage/buckets

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const storage = new sdk.Storage(client);

const result = await storage.createBucket({
    bucketId: '<BUCKET_ID>',
    name: '<NAME>',
    permissions: ["read(\"any\")"], // optional
    fileSecurity: false, // optional
    enabled: false, // optional
    maximumFileSize: 1, // optional
    allowedFileExtensions: [], // optional
    compression: sdk..None, // optional
    encryption: false, // optional
    antivirus: false // optional
});

```

Get a storage bucket by its unique ID. This endpoint response returns a JSON object with the storage bucket metadata.

- Request









- Bucket unique ID.


- Response









  - - [Bucket](https://appwrite.io/docs/references/cloud/models/bucket)



```web-code text
GET /storage/buckets/{bucketId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const storage = new sdk.Storage(client);

const result = await storage.getBucket({
    bucketId: '<BUCKET_ID>'
});

```

Get a list of all the storage buckets. You can use the query params to filter your results.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: enabled, name, fileSecurity, maximumFileSize, encryption, antivirus

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Buckets List](https://appwrite.io/docs/references/cloud/models/bucketList)



```web-code text
GET /storage/buckets

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const storage = new sdk.Storage(client);

const result = await storage.listBuckets({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update a storage bucket by its unique ID.

- Request









- Bucket unique ID.

- Bucket name

- An array of permission strings. By default, the current permissions are inherited. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Enables configuring permissions for individual file. A user needs one of file or bucket level permissions to access a file. [Learn more about permissions](https://appwrite.io/docs/permissions).

- Is bucket enabled? When set to 'disabled', users cannot access the files in this bucket but Server SDKs with and API key can still access the bucket. No files are lost when this is toggled.

- Maximum file size allowed in bytes. Maximum allowed value is 30MB.

- Allowed file extensions. Maximum of 100 extensions are allowed, each 64 characters long.

- Compression algorithm choosen for compression. Can be one of none, [gzip](https://en.wikipedia.org/wiki/Gzip), or [zstd](https://en.wikipedia.org/wiki/Zstd), For file size above 20MB compression is skipped even if it's enabled

- Is encryption enabled? For file size above 20MB encryption is skipped even if it's enabled

- Is virus scanning enabled? For file size above 20MB AntiVirus scanning is skipped even if it's enabled


- Response









  - - [Bucket](https://appwrite.io/docs/references/cloud/models/bucket)



```web-code text
PUT /storage/buckets/{bucketId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const storage = new sdk.Storage(client);

const result = await storage.updateBucket({
    bucketId: '<BUCKET_ID>',
    name: '<NAME>',
    permissions: ["read(\"any\")"], // optional
    fileSecurity: false, // optional
    enabled: false, // optional
    maximumFileSize: 1, // optional
    allowedFileExtensions: [], // optional
    compression: sdk..None, // optional
    encryption: false, // optional
    antivirus: false // optional
});

```

Delete a storage bucket by its unique ID.

- Request









- Bucket unique ID.


- Response


```web-code text
DELETE /storage/buckets/{bucketId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setKey('<YOUR_API_KEY>'); // Your secret API key

const storage = new sdk.Storage(client);

const result = await storage.deleteBucket({
    bucketId: '<BUCKET_ID>'
});

```

Create a new file. Before using this route, you should create a new bucket resource using either a [server integration](https://appwrite.io/docs/server/storage#storageCreateBucket) API or directly from your Appwrite console.

Larger files should be uploaded using multiple requests with the [content-range](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Range) header to send a partial request with a maximum supported chunk of `5MB`. The `content-range` header values should always be in bytes.

When the first request is sent, the server will return the **File** object, and the subsequent part request must include the file's **id** in `x-appwrite-id` header to allow the server to know that the partial upload is for the existing file and not for a new one.

If you're creating a new file using one of the Appwrite SDKs, all the chunking logic will be managed by the SDK internally.

- Request









- Storage bucket unique ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- File ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Binary file. Appwrite SDKs provide helpers to handle file input. [Learn about file input](https://appwrite.io/docs/products/storage/upload-download#input-file).

- An array of permission strings. By default, only the current user is granted all permissions. [Learn more about permissions](https://appwrite.io/docs/permissions).


- Response









  - - [File](https://appwrite.io/docs/references/cloud/models/file)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 60 requests | IP + METHOD + URL + USER ID + |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /storage/buckets/{bucketId}/files

```

```web-code server-nodejs
const sdk = require('node-appwrite');
const fs = require('fs');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.createFile({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>',
    file: InputFile.fromPath('/path/to/file', 'filename'),
    permissions: ["read(\"any\")"] // optional
});

```

Get a file by its unique ID. This endpoint response returns a JSON object with the file metadata.

- Request









- Storage bucket unique ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- File ID.


- Response









  - - [File](https://appwrite.io/docs/references/cloud/models/file)



```web-code text
GET /storage/buckets/{bucketId}/files/{fileId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.getFile({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>'
});

```

Get a file content by its unique ID. The endpoint response return with a 'Content-Disposition: attachment' header that tells the browser to start downloading the file to user downloads directory.

- Request









- Storage bucket ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- File ID.

- File token for accessing this file.


- Response


```web-code text
GET /storage/buckets/{bucketId}/files/{fileId}/download

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.getFileDownload({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>',
    token: '<TOKEN>' // optional
});

```

Get a file content by its unique ID. This endpoint is similar to the download method but returns with no 'Content-Disposition: attachment' header.

- Request









- Storage bucket unique ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- File ID.

- File token for accessing this file.


- Response


```web-code text
GET /storage/buckets/{bucketId}/files/{fileId}/view

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.getFileView({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>',
    token: '<TOKEN>' // optional
});

```

Get a file preview image. Currently, this method supports preview for image files (jpg, png, and gif), other supported formats, like pdf, docs, slides, and spreadsheets, will return the file icon image. You can also pass query string arguments for cutting and resizing your preview image. Preview is supported only for image files smaller than 10MB.

- Request









- Storage bucket unique ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- File ID

- Resize preview image width, Pass an integer between 0 to 4000.

- Resize preview image height, Pass an integer between 0 to 4000.

- Image crop gravity. Can be one of center,top-left,top,top-right,left,right,bottom-left,bottom,bottom-right

- Preview image quality. Pass an integer between 0 to 100. Defaults to keep existing image quality.

- Preview image border in pixels. Pass an integer between 0 to 100. Defaults to 0.

- Preview image border color. Use a valid HEX color, no # is needed for prefix.

- Preview image border radius in pixels. Pass an integer between 0 to 4000.

- Preview image opacity. Only works with images having an alpha channel (like png). Pass a number between 0 to 1.

- Preview image rotation in degrees. Pass an integer between -360 and 360.

- Preview image background color. Only works with transparent images (png). Use a valid HEX color, no # is needed for prefix.

- Output format type (jpeg, jpg, png, gif and webp).

- File token for accessing this file.


- Response


```web-code text
GET /storage/buckets/{bucketId}/files/{fileId}/preview

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.getFilePreview({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>',
    width: 0, // optional
    height: 0, // optional
    gravity: sdk.ImageGravity.Center, // optional
    quality: -1, // optional
    borderWidth: 0, // optional
    borderColor: '', // optional
    borderRadius: 0, // optional
    opacity: 0, // optional
    rotation: -360, // optional
    background: '', // optional
    output: sdk.ImageFormat.Jpg, // optional
    token: '<TOKEN>' // optional
});

```

Get a list of all the user files. You can use the query params to filter your results.

- Request









- Storage bucket unique ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, signature, mimeType, sizeOriginal, chunksTotal, chunksUploaded

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Files List](https://appwrite.io/docs/references/cloud/models/fileList)



```web-code text
GET /storage/buckets/{bucketId}/files

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.listFiles({
    bucketId: '<BUCKET_ID>',
    queries: [], // optional
    search: '<SEARCH>' // optional
});

```

Update a file by its unique ID. Only users with write permissions have access to update this resource.

- Request









- Storage bucket unique ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- File unique ID.

- Name of the file

- An array of permission string. By default, the current permissions are inherited. [Learn more about permissions](https://appwrite.io/docs/permissions).


- Response









  - - [File](https://appwrite.io/docs/references/cloud/models/file)


- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 60 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
PUT /storage/buckets/{bucketId}/files/{fileId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.updateFile({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>',
    name: '<NAME>', // optional
    permissions: ["read(\"any\")"] // optional
});

```

Delete a file by its unique ID. Only users with write permissions have access to delete this resource.

- Request









- Storage bucket unique ID. You can create a new storage bucket using the Storage service [server integration](https://appwrite.io/docs/server/storage#createBucket).

- File ID.


- Response

- Rate limits













This endpoint is not limited when using Server SDKs with API keys. If you are
using SSR with `setSession`, these rate limits will still apply. [Learn more about SSR rate limits.](https://appwrite.io/docs/products/auth/server-side-rendering#rate-limits)



The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 1 minutes | 60 requests | IP + METHOD + URL + USER ID |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
DELETE /storage/buckets/{bucketId}/files/{fileId}

```

```web-code server-nodejs
const sdk = require('node-appwrite');

const client = new sdk.Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>') // Your project ID
    .setSession(''); // The user session to authenticate with

const storage = new sdk.Storage(client);

const result = await storage.deleteFile({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>'
});

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Storage API Reference - Docs - Appwrite
