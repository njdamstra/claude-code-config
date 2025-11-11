# Database Permissions

Permissions define who can access rows in a table. By default **no permissions** are granted to any users, so no user can access any rows. Permissions exist at two levels, table level and row level permissions.

In Appwrite, permissions are **granted**, meaning a user has no access by default and receive access when granted. A user with access granted at either table level or row level will be able to access a row. Users **don't need access at both levels** to access rows.

## Table Level

Table level permissions apply to every row in the table. If a user has read, create, update, or delete permissions at the table level, the user can access **all rows** inside the table.

Configure table level permissions by navigating to **Your table** > **Settings** > **Permissions**.

[Learn more about permissions and roles](https://appwrite.io/docs/advanced/platform/permissions)

## Row Level

Row level permissions grant access to individual rows. If a user has read, create, update, or delete permissions at the row level, the user can access the **individual row**.

Row level permissions are only applied if Row Security is enabled in the settings of your table. Enable row level permissions by navigating to **Your table** > **Settings** > **Row security**.

Row level permissions are configured in individual rows.

[Learn more about permissions and roles](https://appwrite.io/docs/advanced/platform/permissions)

## Common Use Cases

For examples of how to implement common permission patterns, including creating private rows that are only accessible to their creators, see the [permissions examples](https://appwrite.io/docs/advanced/platform/permissions#examples) in our platform documentation.
