# Permission Patterns

## Overview

Socialaize implements a sophisticated permission system combining:
- ✅ **Team-based permissions** with 5 roles (owner, administrator, manager, member, shared)
- ✅ **OAuth account scoping** using `oa_` prefix pattern
- ✅ **User-level permissions** for individual access
- ✅ **Centralized helper function** for consistency

**Location**: `src/utils/appwriteUtils.ts`

## Team Roles

### Role Hierarchy

| Role | Permissions | Use Case |
|------|-------------|----------|
| **owner** | Full read/write access to team resources + OAuth scoped resources | Team creator, workspace owner |
| **administrator** (or **admin**) | Team-level write permissions for standard resources | Team manager, can modify most resources |
| **manager** | Defined in TEAM_ROLES constant but not yet used in permission logic | Reserved for future use |
| **member** | Standard team member access (no special team permissions) | Regular team member |
| **shared** | OAuth-specific role that grants read access to OAuth-scoped resources | Used exclusively for social media account scoping |

### Role Usage

```typescript
// From constants
export const TEAM_ROLES = {
  OWNER: "owner",
  ADMIN: "administrator",  // Also called "admin" in codebase
  MANAGER: "manager",
  MEMBER: "member",
  SHARED: "shared"  // OAuth-specific role
}
```

## Permission Helper

### getClientSidePermissions()

**Signature**:
```typescript
export const getClientSidePermissions = (
  ownerId: string,
  userTeamMembershipRoles: string[],
  oauthAccount?: OAuthAccount,
  existingPermissions: string[] = []
) => string[]
```

**Implementation**:
```typescript
export const getClientSidePermissions = (
  ownerId: string,
  userTeamMembershipRoles: string[],
  oauthAccount?: OAuthAccount,
  existingPermissions: string[] = []
) => {
  const permissions = [
    // Base user permissions
    Permission.read(Role.user(ownerId)),
    Permission.write(Role.user(ownerId)),
  ]

  // Team-based permissions
  if (userTeamMembershipRoles.includes("owner")) {
    permissions.push(Permission.write(Role.team(ownerId, "owner")))
  }

  if (userTeamMembershipRoles.includes("administrator")) {
    permissions.push(Permission.write(Role.team(ownerId, "administrator")))
  }

  // OAuth account scoping - uses `oa_` prefix
  if (oauthAccount) {
    const oauthAccountId = `oa_${oauthAccount.$id}`
    permissions.push(Permission.read(Role.team(oauthAccountId, "shared")))

    if (userTeamMembershipRoles.includes("owner")) {
      permissions.push(Permission.read(Role.team(oauthAccountId, "owner")))
      permissions.push(Permission.write(Role.team(oauthAccountId, "owner")))
    }
  }

  // Merge with existing permissions (deduplicate)
  return Array.from(new Set([...existingPermissions, ...permissions]))
}
```

## Usage Patterns

### Pattern 1: Team Resource Permissions

```typescript
import { getClientSidePermissions } from '@utils/appwriteUtils'
import { postContainerStore } from '@stores/postContainerStore'

const user = await account.get()
const teamMemberships = await teams.listMemberships(teamId)
const userRoles = teamMemberships.memberships
  .find(m => m.userId === user.$id)
  ?.roles || []

// Create post with team permissions
const permissions = getClientSidePermissions(
  teamId,  // Team ID as owner
  userRoles,
  undefined  // No OAuth scoping
)

const post = await postContainerStore.create({
  title: "Team Post",
  content: "Visible to team members",
  teamId: teamId
}, ID.unique(), permissions)

// Result: Team owners and admins can write, all team members can read
```

### Pattern 2: OAuth-Scoped Resource

```typescript
import { getClientSidePermissions } from '@utils/appwriteUtils'
import { postContainerStore } from '@stores/postContainerStore'

const oauthAccount = await oauthStore.get(oauthAccountId)

// Create post scoped to specific social media account
const permissions = getClientSidePermissions(
  user.$id,
  ['owner'],  // User is owner
  oauthAccount  // OAuth account scoping
)

const post = await postContainerStore.create({
  title: "Instagram Post",
  content: "Posted to @myaccount",
  oauthAccountId: oauthAccount.$id
}, ID.unique(), permissions)

// Result:
// - User has read/write
// - All team members with "shared" role on oa_${oauthAccountId} can read
// - Owners of oa_${oauthAccountId} can read/write
```

### Pattern 3: Combined Team + OAuth Permissions

```typescript
const permissions = getClientSidePermissions(
  teamId,          // Team owns the resource
  ['owner', 'administrator'],  // User roles in team
  oauthAccount     // Also scope to social account
)

// Result:
// - User has full access (user-level permissions)
// - Team owner/admin can write (team-level permissions)
// - Users with "shared" role on OAuth account can read
// - Owners of OAuth account can read/write
```

## OAuth Account Scoping Pattern

### The `oa_` Prefix

OAuth accounts are scoped using a special prefix pattern:

```typescript
const oauthAccountId = `oa_${oauthAccount.$id}`
```

This creates a **virtual team** for each social media account.

### Why `oa_` Prefix?

- **Namespace separation**: Distinguishes OAuth teams from regular teams
- **Permission isolation**: Social media account access is independent from workspace access
- **Cross-team sharing**: Multiple workspace teams can access the same OAuth account

### OAuth Permission Flow

1. **User connects social account** → OAuth account created
2. **Create `oa_` team** → Team ID = `oa_${oauthAccountId}`
3. **Grant "shared" role** → All workspace members get read access
4. **Owner permissions** → Workspace owners get read/write access
5. **Resources created** → Posts/content scoped to this OAuth team

### Example: Instagram Account Scoping

```typescript
// User connects Instagram account
const instagramAccount = {
  $id: "instagram_abc123",
  platform: "instagram",
  accountName: "@mycompany"
}

// OAuth team ID
const oauthTeamId = `oa_instagram_abc123`

// Create post for this Instagram account
const permissions = getClientSidePermissions(
  user.$id,
  ['owner'],
  instagramAccount
)

// Permissions include:
// - Permission.read(Role.user(user.$id))
// - Permission.write(Role.user(user.$id))
// - Permission.read(Role.team('oa_instagram_abc123', 'shared'))
// - Permission.read(Role.team('oa_instagram_abc123', 'owner'))
// - Permission.write(Role.team('oa_instagram_abc123', 'owner'))

const instagramPost = await postContainerStore.create({
  title: "Product Launch",
  platform: "instagram",
  oauthAccountId: "instagram_abc123"
}, ID.unique(), permissions)
```

## Common Scenarios

### Scenario 1: Workspace Post (No Social Account)

```typescript
// Team post not tied to any social account
const permissions = getClientSidePermissions(
  teamId,
  ['owner'],
  undefined  // No OAuth account
)

// Permissions:
// - User read/write
// - Team owner write
```

### Scenario 2: Personal Social Media Post

```typescript
// User's personal social account
const permissions = getClientSidePermissions(
  user.$id,
  ['owner'],
  personalOAuthAccount
)

// Permissions:
// - User read/write
// - Team shared role can read
// - Team owner can read/write
```

### Scenario 3: Shared Workspace Social Account

```typescript
// Company social account accessible to all team members
const permissions = getClientSidePermissions(
  teamId,
  ['administrator'],
  companyOAuthAccount
)

// Permissions:
// - User read/write (created it)
// - Team admin can write
// - All team members with "shared" role can read
```

## Permission Debugging

### Check Effective Permissions

```typescript
const permissions = getClientSidePermissions(
  ownerId,
  roles,
  oauthAccount
)

console.log("Effective permissions:", permissions)
// Output:
// [
//   "read(\"user:abc123\")",
//   "write(\"user:abc123\")",
//   "write(\"team:abc123/owner\")",
//   "read(\"team:oa_xyz789/shared\")",
//   ...
// ]
```

### Verify User Has Permission

```typescript
function canUserAccess(userId: string, document: Models.Document): boolean {
  const userReadPermission = `read("user:${userId}")`
  const userWritePermission = `write("user:${userId}")`

  return document.$permissions.includes(userReadPermission) ||
         document.$permissions.includes(userWritePermission)
}
```

### Test Permission Scenarios

```typescript
// Test 1: Owner can access
const ownerPermissions = getClientSidePermissions('team123', ['owner'])
console.assert(ownerPermissions.includes('write("team:team123/owner")'))

// Test 2: Admin can write
const adminPermissions = getClientSidePermissions('team123', ['administrator'])
console.assert(adminPermissions.includes('write("team:team123/administrator")'))

// Test 3: OAuth shared role can read
const oauthPermissions = getClientSidePermissions(
  'user123',
  ['owner'],
  { $id: 'oauth_abc' }
)
console.assert(oauthPermissions.includes('read("team:oa_oauth_abc/shared")'))
```

## Best Practices

### ✅ Always Use getClientSidePermissions()

```typescript
// ✅ Good - consistent permission logic
const permissions = getClientSidePermissions(ownerId, roles, oauthAccount)

// ❌ Bad - manual permission construction (inconsistent)
const permissions = [
  Permission.read(Role.user(userId)),
  Permission.write(Role.user(userId))
]
```

### ✅ Pass Existing Permissions for Updates

```typescript
const existingPost = await postContainerStore.get(postId)

// Preserve existing permissions when updating
const permissions = getClientSidePermissions(
  ownerId,
  roles,
  oauthAccount,
  existingPost.$permissions  // ← Merge with existing
)

await postContainerStore.update(postId, { title: "Updated" }, permissions)
```

### ✅ Scope OAuth Content to OAuth Accounts

```typescript
// ✅ Good - OAuth content scoped properly
if (post.oauthAccountId) {
  const oauthAccount = await oauthStore.get(post.oauthAccountId)
  permissions = getClientSidePermissions(teamId, roles, oauthAccount)
}

// ❌ Bad - OAuth content without scoping
permissions = getClientSidePermissions(teamId, roles)  // Missing OAuth account
```

### ✅ Verify User Roles Before Permission Assignment

```typescript
const memberships = await teams.listMemberships(teamId)
const currentUserMembership = memberships.memberships.find(
  m => m.userId === user.$id
)

if (!currentUserMembership) {
  throw new Error("User is not a team member")
}

const permissions = getClientSidePermissions(
  teamId,
  currentUserMembership.roles,
  oauthAccount
)
```

## Troubleshooting

See [troubleshooting.md](./troubleshooting.md#permission-errors) for common permission issues.

## Summary

Permission system provides:
- **5 team roles** - owner, administrator, manager, member, shared
- **OAuth account scoping** - `oa_` prefix for social media account permissions
- **Centralized helper** - `getClientSidePermissions()` for consistency
- **Flexible sharing** - Resources scoped to teams, users, or OAuth accounts
- **Permission merging** - Combines user, team, and OAuth permissions

Next: See [databases.md](./databases.md) for multi-database architecture guide.
