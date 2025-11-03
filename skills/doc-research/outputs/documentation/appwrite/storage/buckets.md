[Skip to content](https://appwrite.io/docs/products/storage/buckets#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Storage buckets are a group of files, similar to tables in Appwrite Databases. Buckets let you limit file size and extensions, whether or not to encrypt the files, and more.

## [Create Bucket](https://appwrite.io/docs/products/storage/buckets\#create-bucket)

You can create your bucket from the Appwrite Console, a [Server SDK](https://appwrite.io/docs/sdks#server), or the [CLI](https://appwrite.io/docs/tooling/command-line/buckets).

ConsoleServer SDKCLI

ConsoleServer SDK
More

CLI

You can create a bucket by heading to the **Storage** page and clicking **Create bucket**.

![Create bucket on console](https://appwrite.io/images/docs/storage/dark/create-bucket.png)

![Create bucket on console](https://appwrite.io/images/docs/storage/create-bucket.png)

You can also create tables programmatically using a [Server SDK](https://appwrite.io/docs/sdks#server). Appwrite [Server SDKs](https://appwrite.io/docs/sdks#server) require an [API key](https://appwrite.io/docs/advanced/platform/api-keys).

```web-code server-nodejs line-numbers
const sdk = require('node-appwrite');

// Init SDK
const client = new sdk.Client();

const storage = new sdk.Storage(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
    .setKey('919c2d18fb5d4...a2ae413da83346ad2') // Your secret API key
;

const promise = storage.createBucket({
    bucketId: '<BUCKET_ID>',
    name: '<NAME>'
});

promise.then(function (response) {
    console.log(response);
}, function (error) {
    console.log(error);
});

```

You can also configure permission, file size and extension restrictions, and more in the `createBucket` method, learn more about the `createBucket` in the [API references](https://appwrite.io/docs/references/cloud/server-nodejs/storage#createBucket).

Create a bucket using the CLI command `appwrite init buckets`.

```web-code sh line-numbers
appwrite init buckets

```

This will initialize your bucket in your `appwrite.config.json` file. To push your initialized bucket, use the `appwrite push buckets`.

```web-code sh line-numbers
appwrite push buckets

```

This will create your bucket in the Console with all of your `appwrite.config.json` configurations.

[Learn more about the CLI buckets commands](https://appwrite.io/docs/tooling/command-line/buckets#commands)

## [Permissions](https://appwrite.io/docs/products/storage/buckets\#permissions)

Appwrite uses permissions to control file access. For security, only users that are granted permissions can access a file. This helps prevent accidental data leaks by forcing you to make more concious decisions around permissions.

By default, Appwrite doesn't grants permissions to any users when a new bucket is created. This means users can't create new files or read, update, and delete existing files.

[Learn about configuring permissions](https://appwrite.io/docs/products/storage/permissions).

## [Encryption](https://appwrite.io/docs/products/storage/buckets\#encryption)

Appwrite provides added security settings for your buckets. Enable encryption under your bucket's **Settings** \> **Security settings**. You can enable encryption to encrypt files in your buckets. If your files are leaked, encrypted files cannot be read by the malicious actor. Files bigger than 20MB cannot be encrypted.

## [Compression](https://appwrite.io/docs/products/storage/buckets\#compression)

Appwrite allows you to compress your files. Two algorithms are available, which are [gzip](https://www.gzip.org/) and [zstd](https://github.com/facebook/zstd). You can enable compress under your bucket's **Settings** \> **Compression**. For files larger than 20MB, compression will be skipped even when enabled.

## [Maximum file size](https://appwrite.io/docs/products/storage/buckets\#max-size)

Limit the maximum file size allowed in the bucket to prevent abuse. You can configure maximum file size under your bucket's **Settings** \> **Maximum file size**.

## [File extensions](https://appwrite.io/docs/products/storage/buckets\#extensions)

Limit the file extensions allowed in the bucket to prevent abuse. A maximum of 100 file extensions can be added. Leave blank to allow all file types. You can configure maximum file size under your bucket's **Settings** \> **File extensions**.

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
