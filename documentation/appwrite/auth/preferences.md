[Skip to content](https://appwrite.io/docs/products/auth/preferences-storage#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Preferences allow users to customize their experience in your application. You can save settings like theme choice, language selection, or notification preferences. Appwrite provides multiple ways to store these preferences, depending on your needs.

There are four main options for storing user preferences in applications using Appwrite:

## [Browser localStorage](https://appwrite.io/docs/products/auth/preferences-storage\#localstorage)

The browser's localStorage API is a standard web technology that persists data in the user's browser.

- Device-specific: Settings are only available on the current device
- Simple key-value storage
- No server-side processing required
- Data persists even after browser sessions end
- Limited to 5MB per origin in most browsers

```web-code javascript line-numbers
// Store a preference using the browser's built-in localStorage API
localStorage.setItem('darkMode', 'true');

// Retrieve a preference
const darkMode = localStorage.getItem('darkMode');

```

## [User preferences](https://appwrite.io/docs/products/auth/preferences-storage\#user-preferences)

Appwrite provides a built-in user preferences system through the Account API, allowing you to store preferences directly on the user object.

- Persists across all user devices
- Stored as a JSON object
- Limited to 64kB of data
- Simple API for updating and retrieving

```web-code client-web line-numbers
import { Client, Account } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const account = new Account(client);

// Update preferences
const promise = account.updatePrefs({
    darkTheme: true,
    language: 'en',
    notificationsEnabled: true
});

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

// Get preferences
const getPrefs = account.getPrefs();

getPrefs.then(function (prefs) {
    console.log(prefs); // { darkTheme: true, language: 'en', notificationsEnabled: true }
}, function (error) {
    console.log(error);
});

```

[Learn more about user preferences](https://appwrite.io/docs/products/auth/user-preferences)

## [Team preferences](https://appwrite.io/docs/products/auth/preferences-storage\#team-preferences)

Team preferences let you store settings that apply to an entire team of users, well-suited for collaborative features.

- Shared across all team members
- Useful for team-wide settings like theme, notification preferences, or feature toggles
- Stored as a JSON object in the team
- Limited to 64kB of data

```web-code client-web line-numbers
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const teams = new Teams(client);

// Update team preferences
const promise = teams.updatePrefs(
    '<TEAM_ID>',
    {
        theme: 'corporate',
        notificationsEnabled: true,
        defaultView: 'kanban'
    }
);

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

// Get team preferences
const promise = teams.getPrefs('<TEAM_ID>');

promise.then(function (prefs) {
    console.log(prefs); // Team preferences
}, function (error) {
    console.log(error);
});

```

[Learn more about team preferences](https://appwrite.io/docs/products/auth/user-preferences)

## [Appwrite Databases](https://appwrite.io/docs/products/auth/preferences-storage\#appwrite-databases)

For complex preference structures or when storing larger amounts of data, Appwrite Databases offer a flexible solution.

- Schema validation for structured data
- Support for complex data types and relationships
- Unlimited storage capacity (subject to project limits)
- Advanced querying capabilities
- Fine-grained access control

```web-code client-web line-numbers
import { Client, TablesDB, ID, Query } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>');                 // Your project ID

const tablesDB = new TablesDB(client);

// Store user preferences in a database
const promise = tablesDB.createRow(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    ID.unique(),
    {
        userId: '<USER_ID>',
        theme: {
            mode: 'dark',
            primaryColor: '#3498db',
            fontSize: 'medium'
        },
        dashboard: {
            layout: 'grid',
            widgets: ['calendar', 'tasks', 'notes'],
            defaultView: 'week'
        },
        notifications: {
            email: true,
            push: true,
            frequency: 'daily'
        }
    }
);

// Retrieve user preferences
const getUserPrefs = tablesDB.listRows(
    '<DATABASE_ID>',
    '<TABLE_ID>',
    [\
        Query.equal('userId', '<USER_ID>')\
    ]
);

```

[Learn more about Appwrite Databases](https://appwrite.io/docs/products/databases)

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
