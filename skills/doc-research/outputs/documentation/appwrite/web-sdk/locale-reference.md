[Skip to content](https://appwrite.io/docs/references/cloud/client-web/locale#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Locale service allows you to customize your app based on your users' location. Using this service, you can get your users' location, IP address, list of countries and continents names, phone codes, currencies, and more. Country codes returned follow the [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) standard.

The user service supports multiple locales. This feature allows you to fetch countries and continents information in your app language. To switch locales, all you need to do is pass the 'X-Appwrite-Locale' header or set the 'setLocale' method using any of our available SDKs. [View here the list of available locales](https://github.com/appwrite/appwrite/blob/master/app/config/locale/codes.php).

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Get the current user location based on IP. Returns an object with user country code, country name, continent name, continent code, ip address and suggested currency. You can use the locale header to get the data in a supported language.

( [IP Geolocation by DB-IP](https://db-ip.com/))

- Response









  - - [Locale](https://appwrite.io/docs/references/cloud/models/locale)



```web-code text
GET /locale

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.get();

console.log(result);

```

List of all continents. You can use the locale header to get the data in a supported language.

- Response









  - - [Continents List](https://appwrite.io/docs/references/cloud/models/continentList)



```web-code text
GET /locale/continents

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.listContinents();

console.log(result);

```

List of all countries. You can use the locale header to get the data in a supported language.

- Response









  - - [Countries List](https://appwrite.io/docs/references/cloud/models/countryList)



```web-code text
GET /locale/countries

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.listCountries();

console.log(result);

```

List of all countries phone codes. You can use the locale header to get the data in a supported language.

- Response









  - - [Phones List](https://appwrite.io/docs/references/cloud/models/phoneList)



```web-code text
GET /locale/countries/phones

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.listCountriesPhones();

console.log(result);

```

List of all currencies, including currency symbol, name, plural, and decimal digits for all major and minor currencies. You can use the locale header to get the data in a supported language.

- Response









  - - [Currencies List](https://appwrite.io/docs/references/cloud/models/currencyList)



```web-code text
GET /locale/currencies

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.listCurrencies();

console.log(result);

```

List of all countries that are currently members of the EU. You can use the locale header to get the data in a supported language.

- Response









  - - [Countries List](https://appwrite.io/docs/references/cloud/models/countryList)



```web-code text
GET /locale/countries/eu

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.listCountriesEU();

console.log(result);

```

List of all languages classified by ISO 639-1 including 2-letter code, name in English, and name in the respective language.

- Response









  - - [Languages List](https://appwrite.io/docs/references/cloud/models/languageList)



```web-code text
GET /locale/languages

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.listLanguages();

console.log(result);

```

List of all locale codes in [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).

- Response









  - - [Locale codes list](https://appwrite.io/docs/references/cloud/models/localeCodeList)



```web-code text
GET /locale/codes

```

```web-code client-web
import { Client, Locale } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const locale = new Locale(client);

const result = await locale.listCodes();

console.log(result);

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Locale API Reference - Docs - Appwrite