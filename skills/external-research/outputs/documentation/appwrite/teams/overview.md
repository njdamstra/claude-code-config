[Skip to content](https://appwrite.io/docs/products/auth/teams#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Teams are a good way to allow users to share access to resources. For example, in a todo app, a user can [create a team](https://appwrite.io/docs/references/cloud/client-web/teams#create) for one of their todo lists and [invite another user](https://appwrite.io/docs/references/cloud/client-web/teams#createMembership) to the team to grant the other user access. You can further give special rights to parts of a team using team roles.

The invited user can [accept the invitation](https://appwrite.io/docs/references/cloud/client-web/teams#updateMembershipStatus) to gain access. If the user's ever removed from the team, they'll lose access again.

[Learn about using Teams for multi-tenancy](https://appwrite.io/docs/products/auth/multi-tenancy)

## [Create team](https://appwrite.io/docs/products/auth/teams\#create)

For example, we can create a team called `teachers` with roles `maths`, `sciences`, `arts`, and `literature`.

The creator of the team is also granted the `owner` role. **Only those with the `owner` role can invite and remove members**.

```web-code client-web line-numbers
import { Client, Teams } from "appwrite";

const client = new Client();

const teams = new Teams(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;

const promise = teams.create(
    'teachers',
    'Teachers',
    ['maths', 'sciences', 'arts', 'literature']
);

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

## [Invite a member](https://appwrite.io/docs/products/auth/teams\#create-membership)

You can invite members to a team by creating team memberships. For example, inviting "David" a math teacher, to the teachers team.

```web-code client-web line-numbers
import { Client, Teams } from "appwrite";

const client = new Client();

const teams = new Teams(client);

client
    .setEndpoint('https://<REGION>.cloud.appwrite.io/v1') // Your API Endpoint
    .setProject('<PROJECT_ID>') // Your project ID
;

const promise = teams.createMembership(
    'teachers',
    ["maths"],
    "david@example.com"
    );

promise.then(function (response) {
    console.log(response); // Success
}, function (error) {
    console.log(error); // Failure
});

```

## [Using the CLI](https://appwrite.io/docs/products/auth/teams\#using-the-CLI)

##### Before proceeding

Ensure you [**install**](https://appwrite.io/docs/tooling/command-line/installation#getting-started) the CLI, [**log in**](https://appwrite.io/docs/tooling/command-line/installation#login) to your Appwrite account, and [**initialize**](https://appwrite.io/docs/tooling/command-line/installation#initialization) your Appwrite project.

Use the CLI command `appwrite teams create-membership [options]` to invite a new member into your team.

```web-code sh line-numbers
appwrite teams create-membership --team-id "<TEAM_ID>" --roles --phone "+12065550100" --name "<NAME>" --user-id "<USER_ID>"

```

You can also get, update, and delete a user's membership. However, you cannot use the CLI to configure permissions for team members.

[Learn more about the CLI teams commands](https://appwrite.io/docs/tooling/command-line/teams#commands)

## [Permissions](https://appwrite.io/docs/products/auth/teams\#permissions)

You can grant permissions to all members of a team using the `Role.team(<TEAM_ID>)` role or individual roles in the team using the `Role.team(<TEAM_ID>, [<ROLE_1>, <ROLE_2>, ...])` role.

| Description | Role |
| --- | --- |
| All members | `Role.team(<TEAM_ID>)` |
| Select roles | `Role.team(<TEAM_ID>, [<ROLE_1>, <ROLE_2>, ...])` |

[Learn more about permissions](https://appwrite.io/docs/advanced/platform/permissions)

## [Memberships privacy](https://appwrite.io/docs/products/auth/teams\#memberships-privacy)

In certain use cases, your app may not need to share members' personal information with others. You can safeguard privacy by marking specific membership details as private. To configure this setting, navigate to **Auth** \> **Security** \> **Memberships privacy**

These details can be made private:

- `userName` \- The member's name
- `userEmail` \- The member's email address
- `mfa` \- Whether the member has enabled multi-factor authentication

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
