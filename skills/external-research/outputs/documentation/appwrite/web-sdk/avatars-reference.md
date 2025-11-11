[Skip to content](https://appwrite.io/docs/references/cloud/client-web/avatars#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Avatars service aims to help you complete everyday tasks related to your app image, icons, and avatars.

The Avatars service allows you to fetch country flags, browser icons, payment methods logos, remote websites favicons, generate QR codes, and manipulate remote image URLs.

All endpoints in this service allow you to resize, crop, and change the output image quality for maximum performance and visibility in your app.

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

You can use this endpoint to show different browser icons to your users. The code argument receives the browser code as it appears in your user [GET /account/sessions](https://appwrite.io/docs/references/cloud/client-web/account#getSessions) endpoint. Use width, height and quality arguments to change the output settings.

When one dimension is specified and the other is 0, the image is scaled with preserved aspect ratio. If both dimensions are 0, the API provides an image at source quality. If dimensions are not specified, the default size of image returned is 100x100px.

- Request





- Browser Code.

- Image width. Pass an integer between 0 to 2000. Defaults to 100.

- Image height. Pass an integer between 0 to 2000. Defaults to 100.

- Image quality. Pass an integer between 0 to 100. Defaults to keep existing image quality.


- Response


```web-code text
GET /avatars/browsers/{code}

```

```web-code client-web
import { Client, Avatars, Browser } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const avatars = new Avatars(client);

const result = avatars.getBrowser({
    code: Browser.AvantBrowser,
    width: 0, // optional
    height: 0, // optional
    quality: -1 // optional
});

console.log(result);

```

You can use this endpoint to show different country flags icons to your users. The code argument receives the 2 letter country code. Use width, height and quality arguments to change the output settings. Country codes follow the [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) standard.

When one dimension is specified and the other is 0, the image is scaled with preserved aspect ratio. If both dimensions are 0, the API provides an image at source quality. If dimensions are not specified, the default size of image returned is 100x100px.

- Request





- Country Code. ISO Alpha-2 country code format.

- Image width. Pass an integer between 0 to 2000. Defaults to 100.

- Image height. Pass an integer between 0 to 2000. Defaults to 100.

- Image quality. Pass an integer between 0 to 100. Defaults to keep existing image quality.


- Response


```web-code text
GET /avatars/flags/{code}

```

```web-code client-web
import { Client, Avatars, Flag } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const avatars = new Avatars(client);

const result = avatars.getFlag({
    code: Flag.Afghanistan,
    width: 0, // optional
    height: 0, // optional
    quality: -1 // optional
});

console.log(result);

```

The credit card endpoint will return you the icon of the credit card provider you need. Use width, height and quality arguments to change the output settings.

When one dimension is specified and the other is 0, the image is scaled with preserved aspect ratio. If both dimensions are 0, the API provides an image at source quality. If dimensions are not specified, the default size of image returned is 100x100px.

- Request





- Credit Card Code. Possible values: amex, argencard, cabal, cencosud, diners, discover, elo, hipercard, jcb, mastercard, naranja, targeta-shopping, unionpay, visa, mir, maestro, rupay.

- Image width. Pass an integer between 0 to 2000. Defaults to 100.

- Image height. Pass an integer between 0 to 2000. Defaults to 100.

- Image quality. Pass an integer between 0 to 100. Defaults to keep existing image quality.


- Response


```web-code text
GET /avatars/credit-cards/{code}

```

```web-code client-web
import { Client, Avatars, CreditCard } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const avatars = new Avatars(client);

const result = avatars.getCreditCard({
    code: CreditCard.AmericanExpress,
    width: 0, // optional
    height: 0, // optional
    quality: -1 // optional
});

console.log(result);

```

Use this endpoint to fetch the favorite icon (AKA favicon) of any remote website URL.

This endpoint does not follow HTTP redirects.

- Request





- Website URL which you want to fetch the favicon from.


- Response


```web-code text
GET /avatars/favicon

```

```web-code client-web
import { Client, Avatars } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const avatars = new Avatars(client);

const result = avatars.getFavicon({
    url: 'https://example.com'
});

console.log(result);

```

Use this endpoint to fetch a remote image URL and crop it to any image size you want. This endpoint is very useful if you need to crop and display remote images in your app or in case you want to make sure a 3rd party image is properly served using a TLS protocol.

When one dimension is specified and the other is 0, the image is scaled with preserved aspect ratio. If both dimensions are 0, the API provides an image at source quality. If dimensions are not specified, the default size of image returned is 400x400px.

This endpoint does not follow HTTP redirects.

- Request





- Image URL which you want to crop.

- Resize preview image width, Pass an integer between 0 to 2000. Defaults to 400.

- Resize preview image height, Pass an integer between 0 to 2000. Defaults to 400.


- Response


```web-code text
GET /avatars/image

```

```web-code client-web
import { Client, Avatars } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const avatars = new Avatars(client);

const result = avatars.getImage({
    url: 'https://example.com',
    width: 0, // optional
    height: 0 // optional
});

console.log(result);

```

Converts a given plain text to a QR code image. You can use the query parameters to change the size and style of the resulting image.

- Request





- Plain text to be converted to QR code image.

- QR code size. Pass an integer between 1 to 1000. Defaults to 400.

- Margin from edge. Pass an integer between 0 to 10. Defaults to 1.

- Return resulting image with 'Content-Disposition: attachment ' headers for the browser to start downloading it. Pass 0 for no header, or 1 for otherwise. Default value is set to 0.


- Response


```web-code text
GET /avatars/qr

```

```web-code client-web
import { Client, Avatars } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const avatars = new Avatars(client);

const result = avatars.getQR({
    text: '<TEXT>',
    size: 1, // optional
    margin: 0, // optional
    download: false // optional
});

console.log(result);

```

Use this endpoint to show your user initials avatar icon on your website or app. By default, this route will try to print your logged-in user name or email initials. You can also overwrite the user name if you pass the 'name' parameter. If no name is given and no user is logged, an empty avatar will be returned.

You can use the color and background params to change the avatar colors. By default, a random theme will be selected. The random theme will persist for the user's initials when reloading the same theme will always return for the same initials.

When one dimension is specified and the other is 0, the image is scaled with preserved aspect ratio. If both dimensions are 0, the API provides an image at source quality. If dimensions are not specified, the default size of image returned is 100x100px.

- Request





- Full Name. When empty, current user name or email will be used. Max length: 128 chars.

- Image width. Pass an integer between 0 to 2000. Defaults to 100.

- Image height. Pass an integer between 0 to 2000. Defaults to 100.

- Changes background color. By default a random color will be picked and stay will persistent to the given name.


- Response


```web-code text
GET /avatars/initials

```

```web-code client-web
import { Client, Avatars } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const avatars = new Avatars(client);

const result = avatars.getInitials({
    name: '<NAME>', // optional
    width: 0, // optional
    height: 0, // optional
    background: '' // optional
});

console.log(result);

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
