[Skip to content](https://appwrite.io/docs/references/cloud/client-web/teams#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

The Teams service allows you to group users of your project and share [read and write](https://appwrite.io/docs/advanced/platform/permissions) access to resources like database rows or storage files.

Each user who creates a team becomes the team owner and can delegate the ownership role by inviting a new team member. Only team owners can invite new users to their team.

```web-code text
https://<REGION>.cloud.appwrite.io/v1

```

Create a new team. The user who creates the team will automatically be assigned as the owner of the team. Only the users with the owner role can invite new members, add new owners and delete or update the team.

- Request









- Team ID. Choose a custom ID or generate a random ID with `ID.unique()`. Valid chars are a-z, A-Z, 0-9, period, hyphen, and underscore. Can't start with a special char. Max length is 36 chars.

- Team name. Max length: 128 chars.

- Array of strings. Use this param to set the roles in the team for the user who created it. The default role is **owner**. A role can be any string. Learn more about [roles and permissions](https://appwrite.io/docs/permissions). Maximum of 100 roles are allowed, each 32 characters long.


- Response









  - - [Team](https://appwrite.io/docs/references/cloud/models/team)



```web-code text
POST /teams

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.create({
    teamId: '<TEAM_ID>',
    name: '<NAME>',
    roles: [] // optional
});

console.log(result);

```

Get a team by its ID. All team members have read access for this resource.

- Request









- Team ID.


- Response









  - - [Team](https://appwrite.io/docs/references/cloud/models/team)



```web-code text
GET /teams/{teamId}

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.get({
    teamId: '<TEAM_ID>'
});

console.log(result);

```

Get the team's shared preferences by its unique ID. If a preference doesn't need to be shared by all team members, prefer storing them in [user preferences](https://appwrite.io/docs/references/cloud/client-web/account#getPrefs).

- Request









- Team ID.


- Response









  - - [Preferences](https://appwrite.io/docs/references/cloud/models/preferences)



```web-code text
GET /teams/{teamId}/prefs

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.getPrefs({
    teamId: '<TEAM_ID>'
});

console.log(result);

```

Get a list of all the teams in which the current user is a member. You can use the parameters to filter your results.

- Request









- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: name, total, billingPlan

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Teams List](https://appwrite.io/docs/references/cloud/models/teamList)



```web-code text
GET /teams

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.list({
    queries: [], // optional
    search: '<SEARCH>' // optional
});

console.log(result);

```

Update the team's name by its unique ID.

- Request









- Team ID.

- New team name. Max length: 128 chars.


- Response









  - - [Team](https://appwrite.io/docs/references/cloud/models/team)



```web-code text
PUT /teams/{teamId}

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.updateName({
    teamId: '<TEAM_ID>',
    name: '<NAME>'
});

console.log(result);

```

Update the team's preferences by its unique ID. The object you pass is stored as is and replaces any previous value. The maximum allowed prefs size is 64kB and throws an error if exceeded.

- Request









- Team ID.

- Prefs key-value JSON object.


- Response









  - - [Preferences](https://appwrite.io/docs/references/cloud/models/preferences)



```web-code text
PUT /teams/{teamId}/prefs

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.updatePrefs({
    teamId: '<TEAM_ID>',
    prefs: {}
});

console.log(result);

```

Delete a team using its ID. Only team members with the owner role can delete the team.

- Request









- Team ID.


- Response


```web-code text
DELETE /teams/{teamId}

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.delete({
    teamId: '<TEAM_ID>'
});

console.log(result);

```

Invite a new member to join your team. Provide an ID for existing users, or invite unregistered users using an email or phone number. If initiated from a Client SDK, Appwrite will send an email or sms with a link to join the team to the invited user, and an account will be created for them if one doesn't exist. If initiated from a Server SDK, the new member will be added automatically to the team.

You only need to provide one of a user ID, email, or phone number. Appwrite will prioritize accepting the user ID > email > phone number if you provide more than one of these parameters.

Use the `url` parameter to redirect the user from the invitation email to your app. After the user is redirected, use the [Update Team Membership Status](https://appwrite.io/docs/references/cloud/client-web/teams#updateMembershipStatus) endpoint to allow the user to accept the invitation to the team.

Please note that to avoid a [Redirect Attack](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.md) Appwrite will accept the only redirect URLs under the domains you have added as a platform on the Appwrite Console.

- Request









- Team ID.

- Array of strings. Use this param to set the user roles in the team. A role can be any string. Learn more about [roles and permissions](https://appwrite.io/docs/permissions). Maximum of 100 roles are allowed, each 32 characters long.

- Email of the new team member.

- ID of the user to be added to a team.

- Phone number. Format this number with a leading '+' and a country code, e.g., +16175551212.

- URL to redirect the user back to your app from the invitation email. This parameter is not required when an API key is supplied. Only URLs from hostnames in your project platform list are allowed. This requirement helps to prevent an [open redirect](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html) attack against your project API.

- Name of the new team member. Max length: 128 chars.


- Response









  - - [Membership](https://appwrite.io/docs/references/cloud/models/membership)


- Rate limits












This endpoint is rate limited. You can only make a limited number of request to
his endpoint within a specific time frame.


The limit is applied for each unique limit key.










| Time frame | Attempts | Key |
| --- | --- | --- |
| 60 minutes | 10 requests | URL + IP |







[Learn more about rate limits](https://appwrite.io/docs/advanced/platform/rate-limits)


```web-code text
POST /teams/{teamId}/memberships

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.createMembership({
    teamId: '<TEAM_ID>',
    roles: [],
    email: 'email@example.com', // optional
    userId: '<USER_ID>', // optional
    phone: '+12065550100', // optional
    url: 'https://example.com', // optional
    name: '<NAME>' // optional
});

console.log(result);

```

Get a team member by the membership unique id. All team members have read access for this resource. Hide sensitive attributes from the response by toggling membership privacy in the Console.

- Request









- Team ID.

- Membership ID.


- Response









  - - [Membership](https://appwrite.io/docs/references/cloud/models/membership)



```web-code text
GET /teams/{teamId}/memberships/{membershipId}

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.getMembership({
    teamId: '<TEAM_ID>',
    membershipId: '<MEMBERSHIP_ID>'
});

console.log(result);

```

Use this endpoint to list a team's members using the team's ID. All team members have read access to this endpoint. Hide sensitive attributes from the response by toggling membership privacy in the Console.

- Request









- Team ID.

- Array of query strings generated using the Query class provided by the SDK. [Learn more about queries](https://appwrite.io/docs/queries). Maximum of 100 queries are allowed, each 4096 characters long. You may filter on the following attributes: userId, teamId, invited, joined, confirm, roles

- Search term to filter your list results. Max length: 256 chars.


- Response









  - - [Memberships List](https://appwrite.io/docs/references/cloud/models/membershipList)



```web-code text
GET /teams/{teamId}/memberships

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.listMemberships({
    teamId: '<TEAM_ID>',
    queries: [], // optional
    search: '<SEARCH>' // optional
});

console.log(result);

```

Modify the roles of a team member. Only team members with the owner role have access to this endpoint. Learn more about [roles and permissions](https://appwrite.io/docs/permissions).

- Request









- Team ID.

- Membership ID.

- An array of strings. Use this param to set the user's roles in the team. A role can be any string. Learn more about [roles and permissions](https://appwrite.io/docs/permissions). Maximum of 100 roles are allowed, each 32 characters long.


- Response









  - - [Membership](https://appwrite.io/docs/references/cloud/models/membership)



```web-code text
PATCH /teams/{teamId}/memberships/{membershipId}

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.updateMembership({
    teamId: '<TEAM_ID>',
    membershipId: '<MEMBERSHIP_ID>',
    roles: []
});

console.log(result);

```

Use this endpoint to allow a user to accept an invitation to join a team after being redirected back to your app from the invitation email received by the user.

If the request is successful, a session for the user is automatically created.

- Request









- Team ID.

- Membership ID.

- User ID.

- Secret key.


- Response









  - - [Membership](https://appwrite.io/docs/references/cloud/models/membership)



```web-code text
PATCH /teams/{teamId}/memberships/{membershipId}/status

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.updateMembershipStatus({
    teamId: '<TEAM_ID>',
    membershipId: '<MEMBERSHIP_ID>',
    userId: '<USER_ID>',
    secret: '<SECRET>'
});

console.log(result);

```

This endpoint allows a user to leave a team or for a team owner to delete the membership of any other team member. You can also use this endpoint to delete a user membership even if it is not accepted.

- Request









- Team ID.

- Membership ID.


- Response


```web-code text
DELETE /teams/{teamId}/memberships/{membershipId}

```

```web-code client-web
import { Client, Teams } from "appwrite";

const client = new Client()
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<YOUR_PROJECT_ID>'); // Your project ID

const teams = new Teams(client);

const result = await teams.deleteMembership({
    teamId: '<TEAM_ID>',
    membershipId: '<MEMBERSHIP_ID>'
});

console.log(result);

```

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)

Teams API Reference - Docs - Appwrite