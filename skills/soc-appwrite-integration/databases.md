# Multi-Database Architecture

## Overview

Socialaize uses **19 active databases** for data separation and platform isolation:
- **9 core databases** - Application functionality
- **10 platform databases** - Social media platform-specific data

**Location**: Auto-generated in `src/.appwrite/constants/appwrite-constants.ts`

## Active Databases

### Core Application Databases

```typescript
export const DATABASE_IDS = {
  // Primary application data
  SOCIALAIZE_DATA: "socialaize_data",

  // Content management
  SYSTEM_CONTENT: "system_content",

  // AI services
  ARTIFICIAL_INTELLIGENCE: "artificial_int",

  // OAuth & authentication
  OAUTH: "oauth",

  // Automation
  WORKFLOWS: "workflows",
  WEBHOOKS: "webhooks",

  // File management
  FILE_METADATA: "fileMetadata",

  // Billing
  STRIPE: "stripe",

  // Analytics
  ANALYTICS: "analytics",
}
```

### Platform-Specific Databases

```typescript
export const DATABASE_IDS = {
  // ... core databases above

  // Social media platforms
  BLUESKY: "bluesky",
  INSTAGRAM: "instagram",
  FACEBOOK: "facebook",
  THREADS: "threads",
  TIKTOK: "tiktok",
  LINKEDIN: "linkedin",
  PINTEREST: "pinterest",
  GOOGLE: "google",  // YouTube
  MASTODON: "mastodon"
}
```

## Database Usage Guide

| Database | Purpose | Common Collections | Example Use Cases |
|----------|---------|-------------------|-------------------|
| `socialaize_data` | Primary app data | PostContainer, Media, Teams | User posts, team management |
| `system_content` | CMS content | Articles, ContentSection | Help docs, blog posts |
| `artificial_int` | AI services | AiCreditsUsed, Chat, ChatMessage | AI chat, credit tracking |
| `oauth` | Social auth | OAuthAccount | Connected social accounts |
| `workflows` | Automation | WorkflowDefinition, WorkflowExecution | Scheduled posting workflows |
| `webhooks` | Event logs | WebhookEvent, WebhookLog | Platform webhook handling |
| `fileMetadata` | File processing | FileMetadata, ProcessingQueue | Media uploads, video processing |
| `stripe` | Billing | Billing, BillingInvoices, DiscountCode | Subscriptions, invoices |
| `analytics` | Metrics | AnalyticDashboard, AnalyticWidget | Cross-platform analytics |
| `bluesky` | Bluesky platform | BlueskyPost, BlueskyMetric, BlueskyConversation | Bluesky posts and metrics |
| `instagram` | Instagram platform | InstagramPost, InstagramMetric | Instagram content |
| `facebook` | Facebook platform | FacebookPost, FacebookMetric | Facebook posts |
| `threads` | Threads platform | ThreadsPost, ThreadsMetric | Threads content |
| `tiktok` | TikTok platform | TikTokPost, TikTokMetric | TikTok videos |
| `linkedin` | LinkedIn platform | LinkedInPost, LinkedInMetric | LinkedIn posts |
| `pinterest` | Pinterest platform | PinterestPost, PinterestMetric | Pinterest pins |
| `google` | YouTube/Google | GooglePost, YouTubeMetric | YouTube videos |
| `mastodon` | Mastodon platform | MastodonPost, MastodonMetric | Mastodon toots |

## Usage Patterns

### Pattern 1: Store with Database Specification

```typescript
import { BaseStore } from "./baseStore"
import { PostContainerSchema } from "@appwrite/schemas/postContainer"

class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  constructor() {
    super(
      APPWRITE_COLL_POST_CONTAINER,
      PostContainerSchema,
      "currentPostContainer",
      "socialaize_data"  // ← Database ID specified
    )
  }
}
```

### Pattern 2: Platform-Specific Store

```typescript
import { BaseStore } from "./baseStore"
import { BlueskyPostSchema } from "@appwrite/schemas/blueskyPost"

class BlueskyPostStore extends BaseStore<typeof BlueskyPostSchema> {
  constructor() {
    super(
      APPWRITE_COLL_BLUESKY_POST,
      BlueskyPostSchema,
      "currentBlueskyPost",
      "bluesky"  // ← Platform-specific database
    )
  }
}
```

### Pattern 3: Cross-Database Queries

```typescript
// Fetch user's main post
const mainPost = await postContainerStore.get(postId)  // socialaize_data

// Fetch platform-specific posts
const instagramPost = await instagramPostStore.get(
  mainPost.instagramPostId
)  // instagram database

const blueskyPost = await blueskyPostStore.get(
  mainPost.blueskyPostId
)  // bluesky database

// Aggregate analytics from analytics database
const analytics = await analyticDashboardStore.list([
  Query.equal("postContainerId", postId)
])  // analytics database
```

## Why Multi-Database?

### ✅ Data Separation

Each database serves a distinct purpose:
- OAuth tokens isolated from app data
- Billing separate from user content
- Platform data doesn't pollute main database

### ✅ Platform Isolation

Each social platform gets its own database:
- **Prevents cross-contamination** of platform-specific data
- **Schema flexibility** - each platform has unique attributes
- **Independent scaling** - can move platforms to separate instances

### ✅ Performance Optimization

Smaller databases = faster queries:
- **Reduced index size** per database
- **Focused queries** don't scan irrelevant collections
- **Better query planner** with smaller datasets

### ✅ Backup/Restore Flexibility

Can backup/restore specific databases independently:
```bash
# Backup only billing data
appwrite databases backup stripe

# Restore only Instagram data
appwrite databases restore instagram
```

### ✅ Scalability

Platform databases can be moved to separate instances:
```
Instance 1: Core databases (socialaize_data, system_content, oauth, etc.)
Instance 2: High-volume platforms (instagram, facebook, tiktok)
Instance 3: Lower-volume platforms (mastodon, bluesky)
```

## Database Selection Guide

### When to Use `socialaize_data`

- ✅ Core app functionality (posts, teams, users)
- ✅ Cross-platform data (PostContainer)
- ✅ Application state (media, drafts)

### When to Use Platform Databases

- ✅ Platform-specific posts and metrics
- ✅ Platform API responses
- ✅ Platform-specific metadata

### When to Use `oauth`

- ✅ OAuth tokens and refresh tokens
- ✅ Connected account metadata
- ✅ OAuth flow state

### When to Use `analytics`

- ✅ Cross-platform analytics aggregation
- ✅ Dashboard configurations
- ✅ Widget definitions

### When to Use `workflows`

- ✅ Workflow definitions and templates
- ✅ Scheduled workflow executions
- ✅ Automation rules

### When to Use `artificial_int`

- ✅ AI chat conversations
- ✅ AI credit usage tracking
- ✅ AI-generated content

## Common Patterns

### Pattern 1: Hub-and-Spoke (PostContainer)

```typescript
// Hub: PostContainer in socialaize_data
const container = await postContainerStore.create({
  title: "My Multi-Platform Post",
  content: "Shared content",
  platforms: ["instagram", "bluesky", "tiktok"]
})

// Spokes: Platform-specific posts
const instagramPost = await instagramPostStore.create({
  postContainerId: container.$id,
  caption: "Instagram-specific caption",
  hashtags: ["#insta", "#social"]
}, undefined, undefined)  // Uses instagram database

const blueskyPost = await blueskyPostStore.create({
  postContainerId: container.$id,
  text: "Bluesky-specific text",
  mentions: ["@user.bsky.social"]
}, undefined, undefined)  // Uses bluesky database
```

### Pattern 2: Aggregated Analytics

```typescript
// Collect metrics from all platform databases
const instagramMetrics = await instagramMetricStore.list([
  Query.equal("postId", postId)
])  // instagram database

const blueskyMetrics = await blueskyMetricStore.list([
  Query.equal("postId", postId)
])  // bluesky database

// Store aggregated analytics in analytics database
await analyticWidgetStore.create({
  type: "engagement",
  postContainerId: postId,
  totalLikes: instagramMetrics.likes + blueskyMetrics.likes,
  totalComments: instagramMetrics.comments + blueskyMetrics.comments
}, undefined, undefined)  // analytics database
```

### Pattern 3: OAuth Account Lookup

```typescript
// Get OAuth account from oauth database
const oauthAccount = await oauthStore.get(accountId)  // oauth database

// Use to query platform-specific data
if (oauthAccount.platform === "instagram") {
  const posts = await instagramPostStore.list([
    Query.equal("oauthAccountId", accountId)
  ])  // instagram database
}
```

## Environment Variables

Database IDs can be overridden per environment:

```env
# .env.development
APPWRITE_DB_SOCIALAIZE_DATA=dev_socialaize_data
APPWRITE_DB_INSTAGRAM=dev_instagram

# .env.production
APPWRITE_DB_SOCIALAIZE_DATA=prod_socialaize_data
APPWRITE_DB_INSTAGRAM=prod_instagram
```

## Troubleshooting

### Database Not Found Error

**Symptom**: `Database 'xyz' not found`

**Causes**:
- Database ID incorrect in BaseStore constructor
- Environment variable not set
- Database not created in Appwrite

**Solution**:
1. Check BaseStore constructor uses correct database ID
2. Verify database exists in Appwrite console
3. Check environment variables match actual database IDs

### Cross-Database Query Issues

**Symptom**: Can't query across databases

**Cause**: Appwrite doesn't support cross-database queries

**Solution**: Query each database separately and combine results in code:

```typescript
// ✅ Good - separate queries
const mainData = await postContainerStore.list([...])  // socialaize_data
const platformData = await instagramPostStore.list([...])  // instagram

// Combine in code
const combined = mainData.map(post => ({
  ...post,
  instagramData: platformData.find(p => p.postContainerId === post.$id)
}))

// ❌ Bad - cross-database query (not supported)
// Can't query socialaize_data and instagram in single query
```

## Best Practices

### ✅ Use Appropriate Database for Data Type

```typescript
// ✅ Good - OAuth in oauth database
class OAuthStore extends BaseStore<typeof OAuthAccountSchema> {
  constructor() {
    super(
      APPWRITE_COLL_OAUTH_ACCOUNT,
      OAuthAccountSchema,
      "currentOAuthAccount",
      "oauth"  // ← Correct database
    )
  }
}

// ❌ Bad - OAuth in wrong database
class OAuthStore extends BaseStore<typeof OAuthAccountSchema> {
  constructor() {
    super(
      APPWRITE_COLL_OAUTH_ACCOUNT,
      OAuthAccountSchema,
      "currentOAuthAccount",
      "socialaize_data"  // ← Wrong - should be "oauth"
    )
  }
}
```

### ✅ Consistent Database Naming

```typescript
// Platform stores always use platform database
class InstagramPostStore extends BaseStore<...> {
  constructor() {
    super(..., "instagram")  // ← Platform database
  }
}

class BlueskyPostStore extends BaseStore<...> {
  constructor() {
    super(..., "bluesky")  // ← Platform database
  }
}
```

### ✅ Document Database Choice

```typescript
/**
 * Stores user billing information in stripe database
 * Separate from main app data for compliance and isolation
 */
class BillingStore extends BaseStore<typeof BillingSchema> {
  constructor() {
    super(
      APPWRITE_COLL_BILLING,
      BillingSchema,
      "currentBilling",
      "stripe"  // ← Documented choice
    )
  }
}
```

## Summary

Multi-database architecture provides:
- **19 active databases** - 9 core + 10 platform-specific
- **Data separation** - OAuth, billing, platforms isolated
- **Platform isolation** - Each social platform has own database
- **Performance** - Smaller databases, faster queries
- **Scalability** - Can move databases to separate instances
- **Flexibility** - Independent backup/restore

Next: See [services.md](./services.md) for Appwrite core services (Account, Teams, Storage, Functions).
