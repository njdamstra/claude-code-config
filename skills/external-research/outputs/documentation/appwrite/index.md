# Appwrite Documentation Index

This directory contains scraped Appwrite documentation organized by topic, optimized for this project's tech stack (Node.js, TypeScript, Vue 3, Astro).

## 📁 Documentation Structure

```
claude-docs/appwrite/
├── index.md                    # This file
├── SCRAPING_SUMMARY.md        # Complete scraping report
├── auth/                       # Authentication & Users (13 files)
│   ├── overview.md            # Auth methods overview
│   ├── quick-start.md         # Quick start + Vue Router guards
│   ├── email-password.md      # Signup/login/recovery flows
│   ├── oauth2.md              # OAuth2 providers & integration
│   ├── jwt.md                 # JWT authentication for servers
│   ├── magic-url.md           # Magic URL passwordless login
│   ├── email-otp.md           # Email OTP with security phrase
│   ├── anonymous.md           # Anonymous sessions
│   ├── accounts.md            # Account management
│   ├── auth-status.md         # Auth status checking
│   ├── mfa.md                 # Multi-factor authentication
│   ├── ssr.md                 # SSR authentication for Astro
│   └── preferences.md         # User preferences storage
├── databases/                  # Database & Collections (10 files)
│   ├── overview.md            # Database overview
│   ├── quick-start.md         # CRUD operations
│   ├── queries.md            # 40+ query operators
│   ├── permissions.md         # Access control patterns
│   ├── tables.md              # Table management
│   ├── rows.md                # Row operations/CRUD
│   ├── relationships.md       # Data relationships
│   ├── pagination.md          # Pagination patterns
│   ├── order.md               # Ordering results
│   └── atomic-operations.md   # Atomic numeric operations
├── functions/                  # Serverless Functions (5 files)
│   ├── overview.md            # Functions overview
│   ├── quick-start.md         # Git deployment workflow
│   ├── runtimes.md            # Node.js, Bun, Python runtimes
│   ├── execution.md           # Function execution guide
│   └── develop.md             # Development guide
├── storage/                    # File Storage (4 files)
│   ├── overview.md            # Storage basics
│   ├── quick-start.md         # File operations & buckets
│   ├── buckets.md             # Bucket management
│   └── upload-download.md     # File upload/download operations
├── web-sdk/                    # Web Client SDK (9 files)
│   ├── quick-start.md         # Getting started with Web SDK
│   ├── storage-reference.md   # Storage API reference
│   ├── databases-reference.md # Databases API reference
│   ├── account-reference.md   # Account API reference
│   ├── teams-reference.md     # Teams API reference
│   ├── functions-reference.md # Functions API reference
│   ├── messaging-reference.md # Messaging API reference
│   ├── locale-reference.md    # Locale API reference
│   └── avatars-reference.md   # Avatars API reference
├── nodejs-sdk/                 # Node.js Server SDK (9 files)
│   ├── account-reference.md   # Account API reference
│   ├── databases-reference.md # Databases API reference
│   ├── storage-reference.md   # Storage API reference
│   ├── functions-reference.md # Functions API reference
│   ├── users-reference.md     # Users API reference
│   ├── teams-reference.md     # Teams API reference
│   ├── messaging-reference.md # Messaging API reference
│   ├── locale-reference.md    # Locale API reference
│   └── avatars-reference.md   # Avatars API reference
├── messaging/                  # Push, Email, SMS (2 files)
│   ├── overview.md            # Messaging overview
│   └── messages.md            # Messages API
├── teams/                      # Team Management (1 file)
│   └── overview.md            # Team management
├── platform/                   # Platform & Advanced (5 files)
│   ├── events.md              # Event system
│   ├── webhooks.md            # Webhooks
│   ├── permissions.md         # Permissions architecture
│   ├── api-keys.md            # API key management
│   └── compute.md             # Function compute resources
├── tooling/                    # CLI & Tools (1 file)
│   └── cli-installation.md    # Appwrite CLI installation
├── quick-starts/               # Framework Quick Starts (1 file)
│   └── node.md                # Node.js quick start
└── network/                    # Network & Performance (2 files)
    ├── caching.md             # Multi-layer caching
    └── ddos.md                # DDoS mitigation
```

## ✅ Final Documentation Library

**Total Files**: 67 markdown files (~920 KB)
**Cache Duration**: 7 days on all content
**Firecrawl Credits Used**: ~75 credits
**Scraping Status**: COMPLETE ✅

### By Category

#### 🔐 Authentication (13 files, ~75 KB)
Complete authentication system coverage including all enabled auth methods, account management, and SSR support for Astro.

#### 🗄️ Databases (10 files, ~109 KB)
Comprehensive database documentation covering tables, rows, relationships, queries, permissions, pagination, ordering, and atomic operations.

#### ⚡ Functions (5 files, ~54 KB)
Complete serverless functions guide including all three runtimes (Node.js, Bun, Python), execution patterns, events, and development workflows.

#### 📦 Storage (4 files, ~36 KB)
File storage system with buckets, upload/download operations, and permissions management.

#### 🌐 Web Client SDK (9 files, ~129 KB)
Complete client-side JavaScript/TypeScript API references:
- Account API (69 KB) - Authentication, sessions, MFA, preferences
- Databases API (10 KB) - CRUD operations, queries
- Storage API (13 KB) - File upload/download
- Teams API (12 KB) - Team management
- Functions API (3 KB) - Function execution
- Messaging API (2 KB) - Push/email/SMS subscribers
- Locale API (5 KB) - Countries, currencies, languages
- Avatars API (9.6 KB) - Icons, flags, QR codes
- Quick Start (5.9 KB) - Getting started guide

#### 🖥️ Node.js Server SDK (9 files, ~367 KB)
Complete server-side Node.js API references:
- Account API (57 KB) - User authentication, sessions
- Databases API (50 KB) - Database operations
- Storage API (25 KB) - Bucket and file management
- Functions API (35 KB) - Serverless functions, deployments
- Users API (45 KB) - User management
- Teams API (20 KB) - Team and membership management
- Messaging API (100 KB) - Push, email, SMS providers
- Locale API (15 KB) - Location and locale data
- Avatars API (20 KB) - Avatar generation

#### 📧 Messaging (2 files, ~14.5 KB)
Push notifications, email, and SMS messaging system.

#### 👥 Teams (1 file, ~4.8 KB)
Team management, member invitations, and permissions.

#### 🔧 Platform (5 files, ~51.9 KB)
Advanced platform features including events, webhooks, permissions architecture, API keys, and compute resources.

#### 🛠️ Tooling (1 file, ~8.3 KB)
Appwrite CLI installation and configuration.

#### 🚀 Quick Starts (1 file, ~7.8 KB)
Node.js quick start guide with TablesDB examples and TypeScript usage.

#### 🌐 Network (2 files, ~7.1 KB)
Multi-layer caching strategies and DDoS mitigation.

## 📚 Appwrite Documentation Structure (Discovered via Firecrawl Map)

Based on the complete documentation mapping, here are the available sections:

### Core Products (Main Documentation)

#### Authentication (`/docs/products/auth/`)
- ✅ `/docs/products/auth` - Overview (already scraped)
- ✅ `/docs/products/auth/quick-start` - Quick start (already scraped)
- ✅ `/docs/products/auth/email-password` - Email/password (already scraped)
- ✅ `/docs/products/auth/oauth2` - OAuth2 (already scraped)
- ✅ `/docs/products/auth/jwt` - JWT (already scraped)
- ⏳ `/docs/products/auth/accounts` - Accounts management
- ⏳ `/docs/products/auth/identities` - Identities linking
- ⏳ `/docs/products/auth/mfa` - Multi-factor authentication
- ⏳ `/docs/products/auth/verify-user` - Email/phone verification
- ⏳ `/docs/products/auth/checking-auth-status` - Auth status checking
- ⏳ `/docs/products/auth/server-side-rendering` - SSR login
- ⏳ `/docs/products/auth/preferences-storage` - User preferences

#### Databases (`/docs/products/databases/`)
- ✅ `/docs/products/databases/quick-start` - Quick start (already scraped)
- ✅ `/docs/products/databases/queries` - Queries (already scraped)
- ✅ `/docs/products/databases/permissions` - Permissions (already scraped)
- ⏳ `/docs/products/databases/tables` - Tables management
- ⏳ `/docs/products/databases/rows` - Rows operations
- ⏳ `/docs/products/databases/relationships` - Relationships
- ⏳ `/docs/products/databases/pagination` - Pagination
- ⏳ `/docs/products/databases/order` - Ordering results
- ⏳ `/docs/products/databases/csv-imports` - CSV imports
- ⏳ `/docs/products/databases/bulk-operations` - Bulk operations
- ⏳ `/docs/products/databases/atomic-numeric-operations` - Atomic operations
- ⏳ `/docs/products/databases/legacy/*` - Legacy docs (pre-Tables terminology)

#### Functions (`/docs/products/functions/`)
- ✅ `/docs/products/functions` - Overview (already scraped)
- ✅ `/docs/products/functions/quick-start` - Quick start (already scraped)
- ⏳ `/docs/products/functions/runtimes` - Available runtimes

#### Storage (`/docs/products/storage/`)
- ✅ `/docs/products/storage` - Overview (already scraped)
- ✅ `/docs/products/storage/quick-start` - Quick start (already scraped)
- ⏳ `/docs/products/storage/buckets` - Buckets management
- ⏳ `/docs/products/storage/upload-download` - Upload/download operations

#### Messaging (`/docs/products/messaging/`)
- ✅ `/docs/products/messaging` - Overview (already scraped)
- ⏳ `/docs/products/messaging/messages` - Messages concepts

#### Sites (`/docs/products/sites/`)
- ⏳ `/docs/products/sites` - Overview
- ⏳ `/docs/products/sites/quick-start` - Quick start
- ⏳ `/docs/products/sites/develop` - Development guide
- ⏳ `/docs/products/sites/previews` - Preview deployments
- ⏳ `/docs/products/sites/templates` - Site templates
- ⏳ `/docs/products/sites/rendering/static` - Static rendering
- ⏳ `/docs/products/sites/migrations/vercel` - Migrate from Vercel

#### Network (`/docs/products/network/`)
- ⏳ `/docs/products/network/caching` - Caching strategies
- ⏳ `/docs/products/network/edges` - Edge computing
- ⏳ `/docs/products/network/ddos` - DDoS mitigation

### API References

#### Client Web SDK (`/docs/references/cloud/client-web/`)
- ⏳ `/docs/references/cloud/client-web/storage` - Storage API (partially scraped as storage-reference.md)
- ⏳ `/docs/references/cloud/client-web/databases` - Databases API
- ⏳ `/docs/references/cloud/client-web/tokens` - Tokens API
- ⏳ `/docs/references/cloud/client-web/locale` - Locale API

#### Server Node.js SDK (`/docs/references/cloud/server-nodejs/`)
- ⏳ Complete server SDK reference (URL structure to be confirmed)

#### Legacy SDK Versions
- Multiple versions available: 1.8.x, 1.7.x, 1.6.x, 1.5.x, 1.4.x, 1.3.x, etc.
- Each version has client-web, server-nodejs, and other platform SDKs

### Advanced Topics

#### Platform (`/docs/advanced/platform/`)
- ⏳ `/docs/advanced/platform/permissions` - Permissions architecture
- ⏳ `/docs/advanced/platform/webhooks` - Webhooks
- ⏳ `/docs/advanced/platform/events` - Event system
- ⏳ `/docs/advanced/platform/api-keys` - API keys
- ⏳ `/docs/advanced/platform/dev-keys` - Dev keys
- ⏳ `/docs/advanced/platform/compute` - Compute resources
- ⏳ `/docs/advanced/platform/free` - Free tier
- ⏳ `/docs/advanced/platform/enterprise` - Enterprise features
- ⏳ `/docs/advanced/platform/fair-use-policy` - Fair use policy
- ⏳ `/docs/advanced/platform/support-sla` - Support SLA
- ⏳ `/docs/advanced/platform/abuse` - Abuse policy

#### Security (`/docs/advanced/security/`)
- ⏳ `/docs/advanced/security` - Security overview
- ⏳ `/docs/advanced/security/ccpa` - CCPA compliance

#### Self-Hosting (`/docs/advanced/self-hosting/`)
- ⏳ `/docs/advanced/self-hosting` - Self-hosting guide
- ⏳ `/docs/advanced/self-hosting/configuration/environment-variables` - Environment variables
- ⏳ `/docs/advanced/self-hosting/configuration/email` - Email delivery
- ⏳ `/docs/advanced/self-hosting/configuration/sites` - Sites config
- ⏳ `/docs/advanced/self-hosting/production/updates` - Updates & migrations

### APIs

- ⏳ `/docs/apis/graphql` - GraphQL API
- `/docs/references` - API reference overview

### Tooling

- ⏳ `/docs/tooling/command-line/installation` - CLI installation
- ⏳ `/docs/tooling/command-line/non-interactive` - Non-interactive CLI
- ⏳ `/docs/tooling/mcp` - Model Context Protocol
- ⏳ `/docs/tooling/mcp/docs` - MCP for docs
- ⏳ `/docs/tooling/mcp/windsurf` - MCP with Windsurf Editor

### Quick Starts (Framework-Specific)
- ✅ `/docs/quick-starts/web` - Web (already scraped)
- ⏳ `/docs/quick-starts/nextjs` - Next.js
- ⏳ `/docs/quick-starts/react-native` - React Native
- ⏳ `/docs/quick-starts/flutter` - Flutter
- ⏳ `/docs/quick-starts/angular` - Angular
- ⏳ `/docs/quick-starts/node` - Node.js
- ⏳ `/docs/quick-starts/python` - Python
- ⏳ `/docs/quick-starts/go` - Go
- ⏳ `/docs/quick-starts/dart` - Dart
- ⏳ `/docs/quick-starts/kotlin` - Kotlin
- ⏳ `/docs/quick-starts/apple` - Apple (iOS/macOS)
- ⏳ `/docs/quick-starts/android-java` - Android (Java)
- ⏳ `/docs/quick-starts/qwik` - Qwik

### Tutorials
- Multiple step-by-step tutorials available for React, Next.js, SvelteKit, Nuxt, etc.

### Notes
- **No `/docs/products/realtime`** - Realtime functionality is documented elsewhere (possibly in events/webhooks)
- **No `/docs/products/platform`** - Platform features are under `/docs/advanced/platform/`
- **GraphQL available** at `/docs/apis/graphql`
- **Sites product** exists at `/docs/products/sites/` (static site hosting)

## 🎯 Scraping Progress - Relevant Documentation

Based on the project's actual Appwrite usage (appwrite.json analysis):

### ✅ HIGH PRIORITY - Completed (22 of 24 pages)

**Authentication (5 of 7 pages scraped)**
- ✅ `auth/magic-url.md` - Magic URL login (2.5 KB)
- ✅ `auth/email-otp.md` - Email OTP with security phrase (3.2 KB)
- ✅ `auth/anonymous.md` - Anonymous sessions (1.4 KB)
- ✅ `auth/accounts.md` - Account management (2.7 KB)
- ✅ `auth/auth-status.md` - Auth status checking (3.0 KB)
- ❌ `/docs/products/auth/phone` - **404 Not Found** (URL doesn't exist)
- ❌ `/docs/products/auth/invites` - **404 Not Found** (URL doesn't exist)

**Databases (6 of 6 pages scraped) ✅**
- ✅ `databases/tables.md` - Table management (6.4 KB)
- ✅ `databases/rows.md` - Row operations/CRUD (9.2 KB)
- ✅ `databases/relationships.md` - Data relationships (13 KB)
- ✅ `databases/pagination.md` - Pagination patterns (4.2 KB)
- ✅ `databases/order.md` - Ordering results (3.2 KB)
- ✅ `databases/atomic-operations.md` - Atomic numeric operations (6.2 KB)

**Functions (3 of 3 pages scraped) ✅**
- ✅ `functions/runtimes.md` - Node.js, Bun, Python runtimes (4.2 KB)
- ✅ `functions/execution.md` - Function execution guide (22 KB)
- ✅ `functions/develop.md` - Development guide (24 KB)

**Storage (2 of 2 pages scraped) ✅**
- ✅ `storage/buckets.md` - Bucket management (4.9 KB)
- ✅ `storage/upload-download.md` - File operations (14 KB)

**Teams (1 of 1 page scraped) ✅**
- ✅ `teams/overview.md` - Team management (4.8 KB)

**Platform/Advanced (5 of 5 pages scraped) ✅**
- ✅ `platform/events.md` - Event system (16 KB)
- ✅ `platform/webhooks.md` - Webhooks (17.2 KB)
- ✅ `platform/permissions.md` - Permissions architecture (10.7 KB)
- ✅ `platform/api-keys.md` - API key management (4.3 KB)
- ✅ `platform/compute.md` - Function compute resources (3.7 KB)

**SDK References (1 of 2 pages scraped)**
- ✅ `web-sdk/databases-reference.md` - Web client databases API (9.9 KB)
- ⏳ `/docs/references/cloud/server-nodejs` - Node.js server SDK (not yet scraped)

### ✅ MEDIUM PRIORITY - Completed (5 of 6 pages)

**Messaging (1 page) ✅**
- ✅ `messaging/messages.md` - Messages API (13 KB)

**Authentication (3 pages) ✅**
- ✅ `auth/mfa.md` - Multi-factor authentication (9.8 KB)
- ✅ `auth/ssr.md` - SSR authentication for Astro (14 KB)
- ✅ `auth/preferences.md` - User preferences storage (5.7 KB)

**Tooling (1 of 2 pages) ✅**
- ✅ `tooling/cli-installation.md` - Appwrite CLI (8.3 KB)
- ⏳ `/docs/tooling/command-line/deployments` - CLI deployments (not yet scraped)

### ✅ LOW PRIORITY - Completed (3 of 5 pages)

**Quick Starts**
- ✅ `quick-starts/node.md` - Node.js quick start (7.8 KB)

**Performance**
- ✅ `network/caching.md` - Multi-layer caching (4.3 KB)
- ✅ `network/ddos.md` - DDoS mitigation (2.8 KB)

**Failed (404 Not Found)**
- ❌ `/docs/references/cloud/server-nodejs` - Node.js server SDK reference
- ❌ `/docs/tooling/command-line/deployments` - CLI deployments

### 📊 Final Summary

- **Total Successfully Scraped**: 63 pages (~920 KB)
- **Total Documentation Library**: 67 markdown files
- **Failed (404 Errors)**: 4 pages (phone auth, invites, generic server-nodejs SDK URL, CLI deployments)
- **Coverage**: 100% of accessible relevant documentation + Complete API references
- **Cache Duration**: 7 days on all scraped content

**API References Included:**
- ✅ **9 Web Client SDK APIs** - Complete client-side references for Vue 3
- ✅ **9 Node.js Server SDK APIs** - Complete server-side references for Functions
- ✅ All services: Account, Databases, Storage, Functions, Users, Teams, Messaging, Locale, Avatars

### ❌ URLs That Don't Exist in Appwrite Docs

These URLs returned 404 errors and likely don't exist or have been moved:
1. `/docs/products/auth/phone` - Phone/SMS authentication
2. `/docs/products/auth/invites` - User invitations
3. `/docs/references/cloud/server-nodejs` - Server Node.js SDK reference
4. `/docs/tooling/command-line/deployments` - CLI deployments guide

## 🛠️ Scraping Guide

### How to Scrape Additional Documentation

Use Firecrawl with the following pattern:

```typescript
mcp__firecrawl__firecrawl_scrape({
  url: "https://appwrite.io/docs/products/[topic]",
  formats: ["markdown"],
  onlyMainContent: true,
  maxAge: 604800000  // 7 days cache
})
```

### File Organization Pattern
- Save to: `claude-docs/appwrite/[topic]/[page-name].md`
- Update this index.md with new files after each scrape
- Keep folder structure organized by service/topic

### Benefits of This Approach
- ✅ Topic-based organization (easier to find related docs)
- ✅ 7-day caching (re-scraping is free within cache period)
- ✅ Only scrape what's relevant to this project
- ✅ Markdown format is easy to search with Grep
- ✅ Can be versioned in git for tracking doc changes

## 📖 Usage

These documentation files can be:
1. **Referenced directly** - Read the markdown files in your editor
2. **Searched** - Use Grep to find specific APIs or concepts
3. **Used as context** - Copy relevant sections when implementing features
4. **Updated periodically** - Re-run scrapes to get latest documentation

## Related Documentation

For Appwrite usage in this project, see:
- `/functions/*/` - Individual Appwrite function implementations
- `appwrite.json` - Function configurations and triggers
- `src/appwrite/` - TypeScript type definitions for Appwrite collections
