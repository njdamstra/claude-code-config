# Appwrite Core Services

## Overview

All Appwrite services are accessible via `useAppwriteClient` composable. This documents the 7 core services and their common usage patterns in Socialaize.

## Services Available

1. **Account** - Authentication, user management
2. **Teams** - Team/workspace management, memberships
3. **Databases** - CRUD operations (primarily via BaseStore)
4. **Storage** - File upload/download, media management
5. **Functions** - Serverless backend execution (26 functions)
6. **Avatars** - Generated avatars, QR codes, flags
7. **Messaging** - Future feature (not yet used)

## 1. Account Service

### Authentication Operations

```typescript
const { account } = useAppwriteClient()

// Create account
await account.create(ID.unique(), email, password, name)

// Email/password login
const session = await account.createEmailSession(email, password)

// Get current user
const user = await account.get()

// Logout
await account.deleteSession('current')
```

### Email Verification

```typescript
// Send verification email
await account.createVerification(redirectUrl)

// Complete verification
await account.updateVerification(userId, secret)
```

### Password Recovery

```typescript
// Request password reset
await account.createRecovery(email, redirectUrl)

// Complete password reset
await account.updateRecovery(userId, secret, newPassword, confirmPassword)
```

### JWT Generation

```typescript
// Create JWT for API authentication
const jwt = await account.createJWT()

// Use with AppwriteServer
const appwrite = AppwriteServer.withSessionToken(undefined, jwt)
```

### User Preferences

```typescript
// Update user preferences
await account.updatePrefs({ theme: 'dark', language: 'en' })

// Get preferences
const prefs = await account.getPrefs()
```

## 2. Teams Service

### Team Management

```typescript
const { teams } = useAppwriteClient()

// Create team (workspace)
const team = await teams.create(ID.unique(), teamName)

// List user's teams
const userTeams = await teams.list()

// Get team details
const team = await teams.get(teamId)

// Update team
await teams.update(teamId, newName)

// Delete team
await teams.delete(teamId)
```

### Team Memberships

```typescript
// Invite member
await teams.createMembership(
  teamId,
  email,
  ['member'],  // roles: owner, administrator, manager, member
  redirectUrl
)

// List team members
const members = await teams.listMemberships(teamId)

// Get specific membership
const membership = await teams.getMembership(teamId, membershipId)

// Update member roles
await teams.updateMembershipRoles(
  teamId,
  membershipId,
  ['administrator']
)

// Remove member
await teams.deleteMembership(teamId, membershipId)
```

### Team Roles in Socialaize

- **owner** - Team creator, full access
- **administrator** (or **admin**) - Can manage team settings
- **manager** - Reserved for future use
- **member** - Standard team member
- **shared** - OAuth account scoping role

### Common Pattern: Get User's Team Role

```typescript
async function getUserTeamRole(teamId: string, userId: string): Promise<string[]> {
  const memberships = await teams.listMemberships(teamId)
  const userMembership = memberships.memberships.find(m => m.userId === userId)
  return userMembership?.roles || []
}
```

## 3. Databases Service

Primarily accessed via **BaseStore pattern**. See [basestore-pattern.md](./basestore-pattern.md).

Direct usage (uncommon):

```typescript
const { databases } = useAppwriteClient()

// Direct query (bypasses BaseStore)
const documents = await databases.listDocuments(
  'socialaize_data',
  APPWRITE_COLL_POST_CONTAINER,
  [Query.limit(10)]
)
```

## 4. Storage Service

### File Upload

```typescript
const { storage } = useAppwriteClient()

// Upload file with 5MB chunking (automatic)
const uploaded = await storage.createFile(
  'global_bucket',
  ID.unique(),
  file,
  [
    Permission.read(Role.user(userId)),
    Permission.write(Role.user(userId))
  ]
)
```

### File Retrieval

```typescript
// Get file metadata
const fileInfo = await storage.getFile('global_bucket', fileId)

// Get file view URL (for images/videos)
const viewUrl = storage.getFileView('global_bucket', fileId)

// Get file preview (resized image)
const previewUrl = storage.getFilePreview(
  'global_bucket',
  fileId,
  400,  // width
  300   // height
)

// Get file download URL
const downloadUrl = storage.getFileDownload('global_bucket', fileId)
```

### File Management

```typescript
// List files
const files = await storage.listFiles('global_bucket', [
  Query.equal('userId', userId)
])

// Delete file
await storage.deleteFile('global_bucket', fileId)
```

### Storage Buckets

- **global_bucket** - Primary storage
  - Max file size: 30MB
  - Compression: gzip enabled
  - Encryption: enabled
  - Antivirus: enabled

### Upload Best Practices

```typescript
// ✅ Automatic chunking for large files
async function uploadLargeFile(file: File, userId: string) {
  // Files uploaded in 5MB chunks automatically
  // Automatic 3-retry logic for failed chunks

  try {
    const uploaded = await storage.createFile(
      'global_bucket',
      ID.unique(),
      file,
      [
        Permission.read(Role.user(userId)),
        Permission.write(Role.user(userId))
      ]
    )
    return uploaded
  } catch (error) {
    console.error("Upload failed after 3 retries:", error)
    throw error
  }
}
```

## 5. Functions Service

### Execute Function

```typescript
const { functions } = useAppwriteClient()

// Async execution (fire and forget)
await functions.createExecution(
  'WorkflowManager',
  JSON.stringify({ workflowId: '123' }),
  true,  // async
  '/execute',
  ExecutionMethod.POST
)

// Sync execution (wait for response)
const execution = await functions.createExecution(
  'WorkflowManager',
  JSON.stringify({ workflowId: '123' }),
  false,  // sync
  '/execute',
  ExecutionMethod.POST
)

const result = JSON.parse(execution.responseBody)
```

### Available Functions (26 Total)

#### Infrastructure
- **counter** - Document counting (used by BaseStore)
- **CleanupManager** - Background cleanup tasks

#### OAuth & Auth
- **OAuthManager** - OAuth flow handling
- **PermHandler** - Permission management

#### Platform APIs (9 functions)
- **FacebookApi** - Facebook Graph API operations
- **InstagramApi** - Instagram API operations
- **MastodonApi** - Mastodon API operations
- **ThreadsApi** - Threads API operations
- **TikTokApi** - TikTok API operations
- **LinkedInApi** - LinkedIn API operations
- **PinterestApi** - Pinterest API operations
- **YouTubeApi** - YouTube API operations
- **BlueskyApi** - Bluesky API operations

#### Business Logic
- **WorkflowManager** - Workflow execution engine
- **PostManager** - Post publishing logic
- **WebhookManager** - Webhook event handling
- **SyncManager** - Data synchronization
- **SocialHubManager** - Social media hub operations

#### File Processing
- **VideoDownloader** - Download videos from URLs
- **VideoHandler** - Video processing and transcoding
- **FileMetadataHandler** - File metadata extraction

#### Analytics
- **AnalyticsHandler** - Analytics aggregation
- **SentimentAnalyzer** - AI sentiment analysis

#### Integrations
- **StripeHandler** - Stripe billing operations
- **TeamHandler** - Team management operations
- **EmailHandler** - Email sending

#### AI Services
- **AI_API** - AI chat and generation

### Common Function Patterns

#### Pattern 1: Background Job

```typescript
// Fire and forget
await functions.createExecution(
  'CleanupManager',
  JSON.stringify({ action: 'cleanup_old_files' }),
  true  // async - don't wait for response
)
```

#### Pattern 2: Synchronous Operation

```typescript
// Wait for response
const execution = await functions.createExecution(
  'AI_API',
  JSON.stringify({ prompt: 'Generate caption', context: '...' }),
  false  // sync - wait for response
)

const aiResponse = JSON.parse(execution.responseBody)
console.log("AI generated:", aiResponse.caption)
```

#### Pattern 3: Platform API Call

```typescript
// Publish to Instagram via function
const execution = await functions.createExecution(
  'InstagramApi',
  JSON.stringify({
    action: 'publish',
    postId: '123',
    oauthAccountId: 'oauth_abc'
  }),
  false,  // sync - need response to know if published
  '/publish',
  ExecutionMethod.POST
)

const publishResult = JSON.parse(execution.responseBody)
if (publishResult.success) {
  console.log("Published to Instagram:", publishResult.instagramPostId)
}
```

## 6. Avatars Service

### Generate Avatars

```typescript
const { avatars } = useAppwriteClient()

// Get initials avatar
const initialsUrl = avatars.getInitials(
  'John Doe',
  200,  // width
  200   // height
)

// Get QR code
const qrUrl = avatars.getQR('https://example.com', 300)

// Get country flag
const flagUrl = avatars.getFlag('us')

// Get credit card icon
const cardUrl = avatars.getCreditCard('visa')
```

### Common Usage

```vue
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { avatars } = useAppwriteClient()
const user = { name: 'Jane Smith' }

const avatarUrl = avatars.getInitials(user.name, 100, 100)
</script>

<template>
  <img :src="avatarUrl" alt="User avatar" />
</template>
```

## 7. Messaging Service

**Status**: Not currently used in codebase (future feature)

Accessible via:
```typescript
const { messaging } = useAppwriteClient()
```

## Common Service Combinations

### Pattern 1: Account + Teams (Onboarding)

```typescript
// Create account
const user = await account.create(ID.unique(), email, password, name)

// Create personal team
const team = await teams.create(ID.unique(), `${name}'s Workspace`)

// User is automatically added as owner
```

### Pattern 2: Storage + Functions (Media Processing)

```typescript
// Upload video
const uploaded = await storage.createFile('global_bucket', ID.unique(), videoFile, permissions)

// Trigger video processing function
await functions.createExecution(
  'VideoHandler',
  JSON.stringify({ fileId: uploaded.$id, action: 'transcode' }),
  true  // async
)
```

### Pattern 3: Teams + Databases (Team Content)

```typescript
// Get user's team
const userTeams = await teams.list()
const primaryTeam = userTeams.teams[0]

// Create team post
const post = await postContainerStore.create({
  title: "Team Announcement",
  teamId: primaryTeam.$id
}, ID.unique(), [
  Permission.read(Role.team(primaryTeam.$id)),
  Permission.write(Role.team(primaryTeam.$id, 'administrator'))
])
```

## Summary

Appwrite services provide:
- **Account** - Authentication, user management, JWT, verification
- **Teams** - Workspaces, memberships, 5 role types
- **Databases** - CRUD (via BaseStore pattern)
- **Storage** - File upload (5MB chunks, 3-retry), download, preview URLs
- **Functions** - 26 serverless functions for backend operations
- **Avatars** - Generated initials, QR codes, flags
- **Messaging** - Future feature

Next: See [patterns-utilities.md](./patterns-utilities.md) for common integration patterns.
