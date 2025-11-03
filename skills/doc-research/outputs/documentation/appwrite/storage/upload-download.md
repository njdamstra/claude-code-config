[Skip to content](https://appwrite.io/docs/products/storage/upload-download#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

You can upload and download files both programmatically using SDKs or through the Appwrite Console.

## [Create file](https://appwrite.io/docs/products/storage/upload-download\#create-file)

After you create a bucket or have navigated to bucket details, you can access the **Files** tab so you can upload, view, delete and update files in the bucket using the Appwrite project's dashboard. You can also perform all those operations from Appwrite's client SDK, server SDKs, and REST APIs as long as you have the proper permission.

When you are in the **Files** tab, you can click **Add File** and select a file to upload. If the bucket is configured to accept the file type and size you are uploading, your file will be uploaded, and you will see the file in the list of files.

You can also upload files programmatically using our SDKs:

```web-code client-web line-numbers
import { Client, Storage, ID } from "appwrite";

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

## [Large files](https://appwrite.io/docs/products/storage/upload-download\#large-files)

When you are trying to upload any files above 5MB, you will need to upload them in chunks for better reliability and performance. If you're using an Appwrite SDK, this is handled automatically. If you're not using an SDK, you can [learn more about REST API file handling](https://appwrite.io/docs/apis/rest#files).

## [InputFile](https://appwrite.io/docs/products/storage/upload-download\#input-file)

Every language and platform handles file inputs differently. This section rows the expected input type of each SDK. Where applicable, Appwrite provides an `InputFile` class to accept multiple file sources, like paths, buffers, or plain text.

## [Client SDKs](https://appwrite.io/docs/products/storage/upload-download\#client-sdks)

WebFlutterAndroidAppleReact Native

WebFlutter
More

AndroidAppleReact Native

The Appwrite Web SDK expects a [File](https://developer.mozilla.org/en-US/docs/Web/API/File) object for file creation. This is most commonly associated with DOM file inputs.

For example, for the input tag `<input type="file" id="uploader">`, you would call create file like this:

```web-code js line-numbers
const promise = storage.createFile({
    bucketId: '<BUCKET_ID>',
    fileId: ID.unique(),
    file: document.getElementById('uploader').files[0]
});

```

The Appwrite Flutter SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.fromPath(path: [PATH], filename: [NAME], contentType: [MIME TYPE])` | Used to upload files from a provided path, `filename` and `contentType` are optional. Used for Flutter apps on mobile and desktop. |
| `InputFile.fromBytes(bytes: [BYTE LIST], filename: [NAME], contentType: [MIME TYPE])` | Used to upload files from a byte list, `contentType` is optional. Used for Flutter apps on the web. |

The Appwrite Android SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.fromPath(path: String)` | Used to upload files from a provided path. |
| `InputFile.fromFile(file: File)` | Used to upload files from a [File](https://docs.oracle.com/javase/8/docs/api/java/io/File.html) object. |
| `InputFile.fromBytes(bytes: ByteArray, filename: String, mimeType: String)` | Used to upload files from a [ByteArray](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-byte-array/) object. Specify the file [MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) using the `mimeType` param. |

The Appwrite Apple SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.fromPath(_ path: String)` | Used to upload files from a provided path. |
| `InputFile.fromData(_ data: Data, filename: String, mimeType: String)` | Used to upload files from a [Data](https://developer.apple.com/documentation/foundation/data) object. Specify the file [MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) using the `mimeType` param. |
| `InputFile.fromBuffer(_ buffer: ByteBuffer, filename: String, mimeType: String)` | Used to upload files from a [NIO Buffer](https://swiftinit.org/reference/swift-nio/niocore/bytebuffer) object. Specify the file [MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) using the `mimeType` param. |

The Appwrite React Native SDK expects a file object with the following properties for file inputs:

| Property | Description |
| --- | --- |
| `name` | The name of the file. |
| `type` | The MIME type of the file. |
| `size` | The size of the file in bytes. |
| `uri` | The URI of the file on the device. |

This object structure aligns with what is typically returned from image picker libraries such as `react-native-image-picker`:

```web-code js line-numbers
// Example with react-native-image-picker
import { launchImageLibrary } from 'react-native-image-picker';

const pickImage = async () => {
  const result = await launchImageLibrary({
    mediaType: 'photo',
  });

  if (result.assets && result.assets[0]) {
    const fileInfo = result.assets[0];

    return {
      name: fileInfo.fileName,
      type: fileInfo.type,
      size: fileInfo.fileSize,
      uri: fileInfo.uri,
    };
  }
};

```

You can also use the file picker or row picker from Expo:

```web-code js line-numbers
// Example with expo-row-picker
import * as DocumentPicker from 'expo-row-picker';

const pickDocument = async () => {
  const result = await DocumentPicker.getRowAsync();

  if (result.assets && result.assets[0]) {
    return {
      name: result.assets[0].name,
      type: result.assets[0].mimeType,
      size: result.assets[0].size,
      uri: result.assets[0].uri,
    };
  }
};

```

## [Server SDKs](https://appwrite.io/docs/products/storage/upload-download\#server-sdks)

Node.jsPHPPythonRubyDenoDartKotlin
More

Swift.NET

Node.jsPHP
More

PythonRubyDenoDartKotlinSwift.NET

In browser environments, you can use the `File` object directly. For Node.js environments, import the `InputFile` class from 'node-appwrite/file'.

When using `InputFile`, the following methods are available:

| Method | Description |
| --- | --- |
| `InputFile.fromPath(filePath, filename)` | Used to upload files from a provided path. |
| `InputFile.fromBuffer(buffer, filename)` | Used to upload files from a [Buffer](https://nodejs.org/api/buffer.html#buffer) or [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) object. |
| `InputFile.fromPlainText(content, filename)` | Used to upload files in plain text. Expects a string encoded in UTF-8. |

The Appwrite PHP SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.withPath(string $path, ?string $mimeType = null, ?string $filename = null)` | Used to upload files from a provided path. |
| `InputFile.withData(string $data, ?string $mimeType = null, ?string $filename = null)` | Used to upload files from a string. |

The Appwrite Python SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.from_path(path)` | Used to upload files from a provided path. |
| `InputFile.from_bytes(bytes)` | Used to upload files from an array of bytes. |

The Appwrite Ruby SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.from_path(path)` | Used to upload files from a provided path. |
| `InputFile.from_string(string)` | Used to upload files from a String. |
| `InputFile.from_bytes(bytes)` | Used to upload files from an array of bytes. |

The Appwrite Deno SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.fromPath(filePath, filename)` | Used to upload files from a provided path. |
| `InputFile.fromBuffer(buffer, filename)` | Used to upload files from a [Uint8Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array) object. |
| `InputFile.fromPlainText(content, filename)` | Used to upload files in plain text. Expects a string encoded in UTF-8. |

The Appwrite Dart SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.fromPath(path: [PATH], filename: [NAME], contentType: [MIME TYPE])` | Used to upload files from a provided path, `filename` and `contentType` are optional. |
| `InputFile.fromBytes(bytes: [BYTE LIST], filename: [NAME], contentType: [MIME TYPE])` | Used to upload files from a byte list, `contentType` is optional. |

The Appwrite Kotlin SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.fromPath(path: String)` | Used to upload files from a provided path. |
| `InputFile.fromFile(file: File)` | Used to upload files from a [File](https://docs.oracle.com/javase/8/docs/api/java/io/File.html) object. |
| `InputFile.fromBytes(bytes: ByteArray, filename: String, mimeType: String)` | Used to upload files from a [ByteArray](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-byte-array/) object. Specify the file [MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) using the `mimeType` param. |

The Appwrite Swift SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.fromPath(_ path: String)` | Used to upload files from a provided path. |
| `InputFile.fromData(_ data: Data, filename: String, mimeType: String)` | Used to upload files from a [Data](https://developer.apple.com/documentation/foundation/data) object. Specify the file [MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) using the `mimeType` param. |
| `InputFile.fromBuffer(_ buffer: ByteBuffer, filename: String, mimeType: String)` | Used to upload files from a [NIO Buffer](https://swiftinit.org/reference/swift-nio/niocore/bytebuffer) object. Specify the file [MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) using the `mimeType` param. |

The Appwrite .NET SDK expects an `InputFile` class for file inputs.

| Method | Description |
| --- | --- |
| `InputFile.FromPath(string path)` | Used to upload files from a provided path. |
| `InputFile.FromBytes(byte[] bytes, string filename, string mimeType)` | Used to upload files from an array of bytes. Specify the file [MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) using the `mimeType` param. |

## [Get file](https://appwrite.io/docs/products/storage/upload-download\#get-file)

To get a metadata about a file, use the `getFile` method.

```web-code client-web line-numbers
import { Client, Storage } from "appwrite";

const client = new Client();

const storage = new Storage(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;

const promise = storage.getFile({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>'
});

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

## [Download file](https://appwrite.io/docs/products/storage/upload-download\#download-file)

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

## [Get File Preview](https://appwrite.io/docs/products/storage/upload-download\#get-file-preview)

To get a file preview image , use the `getFilePreview` method.

```web-code client-web line-numbers
import { Client, Storage } from "appwrite";

const client = new Client();

const storage = new Storage(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;

const result = storage.getFilePreview({
    bucketId: '<BUCKET_ID>',
    fileId: '<FILE_ID>'
});

console.log(result); // Resource URL

```

## [View File](https://appwrite.io/docs/products/storage/upload-download\#view-file)

To view a file, use the `getFileView` method.

```web-code client-web line-numbers
import { Client, Storage } from "appwrite";

const client = new Client();

const storage = new Storage(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;

const result = storage.getFileView({
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
