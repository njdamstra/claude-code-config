# Official Documentation: Appwrite Messaging Email Targets and SMTP Formatting

**Research Date:** 2025-11-16
**Source:** /llmstxt/appwrite_io_llms_txt (Context7) + /appwrite/sdk-for-node
**Version:** Appwrite current (Node.js SDK)

## Summary

Appwrite Messaging provides a comprehensive email delivery system with three distinct recipient mechanisms: `users`, `targets`, and `topics`. Email targets are messaging endpoints created at the user level, containing an `identifier` (email address) and optional `providerId`. SMTP formatting is handled automatically by Appwrite using the configured SMTP provider's sender credentials.

## Email Recipients: Users vs Targets vs Topics

Appwrite's `createEmail()` method accepts three optional recipient parameters with different resolution paths:

### 1. `topics` (array of topic IDs)
- Routes email to all **subscribers** of a topic
- Subscribers are targets that have been added to the topic
- Indirect email delivery through topic subscriptions

### 2. `users` (array of user IDs)
- Routes email to **all targets of a user**
- Requires user to have one or more targets created
- Resolves each user's targets at send time
- Multiple targets per user means multiple emails

### 3. `targets` (array of target IDs)
- Direct specification of messaging targets
- Most direct recipient mechanism
- Single target = single email address

## User Target API Reference

### Create User Target (`users.createTarget()`)

**Purpose:** Create a messaging endpoint (email, phone, push device) for a user. Required before sending messages to that user.

**Node.js Signature:**
```typescript
users.createTarget({
  userId: string,              // Required - User ID
  targetId: string,            // Required - Unique target identifier
  providerType: string,        // Required - MessagingProviderType.Email
  identifier: string,          // Required - Email address (e.g., "user@example.com")
  providerId?: string,         // Optional - Specific provider to use for this target
  name?: string                // Optional - Display name for the target
})
```

**Parameters:**

- **`userId`** - The ID of the user who owns this target

- **`targetId`** - Unique identifier for this messaging endpoint
  - Must be unique within the user's targets
  - Used to reference the target in API calls

- **`providerType`** - The type of messaging provider
  - For email: `sdk.MessagingProviderType.Email`
  - Also supports: `Phone`, `Push`

- **`identifier`** - The actual email address
  - Full email format: `"user@example.com"`
  - This is what Appwrite uses as the SMTP recipient
  - Must be a valid email format for SMTP compliance

- **`providerId`** (optional) - Which email provider to use for this target
  - If omitted, uses the default project provider
  - Allows different targets to use different providers
  - Example: `"sendgrid_provider"` or `"smtp_abc123"`

- **`name`** (optional) - Human-readable name
  - For display/organizational purposes
  - Does NOT appear in SMTP headers (identifier is used instead)
  - Example: `"Work Email"` or `"Personal Email"`

**Code Example:**
```javascript
const sdk = require('node-appwrite');

const client = new sdk.Client()
  .setEndpoint('https://<REGION>.cloud.appwrite.io/v1')
  .setProject('<PROJECT_ID>')
  .setKey('<API_KEY>');

const users = new sdk.Users(client);

// Create email target for user
const target = await users.createTarget({
  userId: 'user_123',
  targetId: 'email_primary',
  providerType: sdk.MessagingProviderType.Email,
  identifier: 'john.doe@example.com',
  name: 'Primary Email'
});
```

**Response:**
```json
{
  "$id": "email_primary",
  "userId": "user_123",
  "name": "Primary Email",
  "identifier": "john.doe@example.com",
  "providerType": "email",
  "providerId": null,
  "createdAt": "2025-11-16T10:00:00Z"
}
```

### Update User Target (`users.updateTarget()`)

**Purpose:** Modify an existing target's email address, provider, or name.

**Node.js Signature:**
```typescript
users.updateTarget({
  userId: string,              // Required - User ID
  targetId: string,            // Required - Target to update
  identifier?: string,         // Optional - New email address
  providerId?: string,         // Optional - New provider
  name?: string                // Optional - New display name
})
```

**Parameters:**

- **`identifier`** (optional) - Change the email address
  - Updates the SMTP recipient for this target
  - Must remain in valid email format

- **`providerId`** (optional) - Change which provider sends to this target
  - Null/empty resets to default project provider
  - Useful for per-target provider selection

- **`name`** (optional) - Update the display name only
  - Does not affect SMTP delivery

**Code Example:**
```javascript
const updatedTarget = await users.updateTarget({
  userId: 'user_123',
  targetId: 'email_primary',
  identifier: 'john.newdomain@example.com',  // Update email
  name: 'Primary Email (Updated)'
});
```

## Target Field Specifications for SMTP

### Email Identifier Formatting

The `identifier` field must follow strict SMTP RFC standards:

**Valid Formats:**
```
user@example.com
john.doe@example.co.uk
first+tag@subdomain.example.com
user_name@example.org
```

**Invalid Formats (will cause "Invalid to field" errors):**
```
john.doe (no domain)
@example.com (no local part)
user@example (incomplete domain)
user example.com (space instead of @)
user@.com (missing domain name)
```

### Target Identifier vs Name Usage

| Field | SMTP Usage | Purpose |
|-------|-----------|---------|
| `identifier` | **Used as SMTP "To" field** | Email address SMTP recipient |
| `name` | **Not used in SMTP headers** | UI/organizational reference only |
| `providerId` | Determines which provider sends | Email provider selection |

**Important:** If your SMTP is showing "Invalid to field" errors, the `identifier` is being validated. Ensure it's a properly formatted email address.

## SMTP Provider Configuration

### Create SMTP Provider

**Node.js Signature:**
```typescript
messaging.createSMTPProvider({
  providerId: string,          // Required - Unique provider ID
  name: string,                // Required - Display name
  host: string,                // Required - SMTP server hostname
  port: number,                // Required - SMTP port (typically 587 or 465)
  username: string,            // Required - SMTP auth username
  password: string,            // Required - SMTP auth password
  encryption: string,          // Required - 'None', 'SSL', or 'TLS'
  autoTLS?: boolean,           // Optional - Auto-upgrade to TLS
  mailer?: string,             // Optional - Server identifier
  fromName?: string,           // Optional - Default "From" name
  fromEmail: string,           // Required - Sender email address
  replyToEmail?: string,       // Optional - Reply-to email
  replyToName?: string,        // Optional - Reply-to name
  enabled?: boolean            // Optional - Enable immediately
})
```

**Code Example:**
```javascript
const smtpProvider = await messaging.createSMTPProvider({
  providerId: 'smtp_custom',
  name: 'Custom SMTP Server',
  host: 'smtp.example.com',
  port: 587,
  username: 'appwrite@example.com',
  password: 'secure_password',
  encryption: 'TLS',
  autoTLS: true,
  fromName: 'Appwrite Support',
  fromEmail: 'noreply@example.com',
  replyToEmail: 'support@example.com',
  replyToName: 'Support Team'
});
```

## Email Message Sending

### Create Email (`messaging.createEmail()`)

**Node.js Signature:**
```typescript
messaging.createEmail({
  messageId: string,           // Required - Unique message identifier
  subject: string,             // Required - Email subject
  content: string,             // Required - Email body content
  topics?: string[],           // Optional - Topic IDs to send to
  users?: string[],            // Optional - User IDs to send to
  targets?: string[],          // Optional - Target IDs to send to
  cc?: string[],               // Optional - CC recipient IDs
  bcc?: string[],              // Optional - BCC recipient IDs
  html?: boolean,              // Optional - Treat content as HTML
  draft?: boolean,             // Optional - Save as draft
  scheduledAt?: string,        // Optional - ISO 8601 schedule time
  attachments?: any[]          // Optional - File attachments
})
```

**Parameters:**

- **`messageId`** - Unique identifier, typically matches message in your system

- **`subject`** - Email subject line

- **`content`** - Email body
  - Plain text by default
  - HTML when `html: true`

- **`topics`**, **`users`**, **`targets`** - Recipient selection (at least one required)
  - Can be mixed (e.g., some topics AND some targets)
  - Empty arrays are ignored

- **`cc`/`bcc`** - Secondary recipients (currently target IDs)

- **`html`** - Set `true` for HTML email bodies

- **`draft`** - Set `true` to save without sending

- **`scheduledAt`** - ISO 8601 format: `"2025-11-16T15:30:00Z"`

**Code Example - Send to User Targets:**
```javascript
const message = await messaging.createEmail({
  messageId: 'email_notification_001',
  subject: 'Welcome to Appwrite',
  content: '<h1>Welcome!</h1><p>Your account is ready.</p>',
  users: ['user_123'],  // Sends to all of user_123's email targets
  html: true
});
```

**Code Example - Send to Specific Targets:**
```javascript
const message = await messaging.createEmail({
  messageId: 'email_support_ticket',
  subject: 'Support Ticket #12345',
  content: 'Your ticket has been received.',
  targets: ['email_primary', 'email_backup'],  // Send to specific targets
  scheduledAt: '2025-11-16T15:30:00Z'
});
```

## How Appwrite Constructs SMTP Recipients

### Resolution Flow

```
createEmail() called with:
├─ users: ['user_123']
│  └─ Query user's targets → Find all email targets
│     └─ Extract identifier field → 'john@example.com'
│        └─ Add to SMTP "To" field
│
├─ targets: ['email_primary']
│  └─ Query target by ID
│     └─ Extract identifier field → 'john@example.com'
│        └─ Add to SMTP "To" field
│
└─ topics: ['newsletter']
   └─ Query topic's subscribers
      └─ Collect all subscribed targets
         └─ Extract identifier fields
            └─ Add to SMTP "To" field (multiple recipients)
```

### SMTP Header Construction

For each recipient, Appwrite constructs the SMTP "To" field:

```
To: john@example.com
```

Or with display name (when available from target.name or provider fromName):

```
To: "John Doe" <john@example.com>
```

**SMTP Headers Set by Provider:**
```
From: "Appwrite Support" <noreply@example.com>
Reply-To: "Support Team" <support@example.com>
Subject: Welcome to Appwrite
Content-Type: text/html; charset=UTF-8
```

## Error Handling

### "Invalid to field" Error

**Cause:** The `identifier` in a target is malformed or missing

**Solutions:**
1. Validate email format before creating/updating targets
2. Use regex: `/^[^\s@]+@[^\s@]+\.[^\s@]+$/`
3. Ensure no spaces or special characters except dots, hyphens, underscores
4. Verify @ symbol is present and domain has a dot

**Example Fix:**
```javascript
function validateEmailIdentifier(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!regex.test(email)) {
    throw new Error(`Invalid email identifier: ${email}`);
  }
  return email;
}

const target = await users.createTarget({
  userId: 'user_123',
  targetId: 'email_primary',
  providerType: sdk.MessagingProviderType.Email,
  identifier: validateEmailIdentifier('john@example.com'),
  name: 'Primary Email'
});
```

### No Targets Found

**Cause:** User has no email targets created

**Solution:** Create at least one target before sending to that user

```javascript
// First, ensure user has targets
const targets = await users.listTargets('user_123');
if (targets.total === 0) {
  await users.createTarget({
    userId: 'user_123',
    targetId: 'email_primary',
    providerType: sdk.MessagingProviderType.Email,
    identifier: 'user@example.com'
  });
}

// Now send email
await messaging.createEmail({
  messageId: 'email_001',
  subject: 'Test',
  content: 'Test message',
  users: ['user_123']  // Will find the target we just created
});
```

## Best Practices

### Target Naming vs Identifier

**Correct Approach:**
```javascript
// Name is for your organization
// Identifier is the actual SMTP email
await users.createTarget({
  userId: 'user_123',
  targetId: 'email_work',
  identifier: 'john@company.com',    // ← This becomes SMTP "To"
  name: 'Work Email'                  // ← This is metadata only
});
```

**Anti-Pattern:**
```javascript
// Don't put the display name in identifier
await users.createTarget({
  userId: 'user_123',
  targetId: 'email_work',
  identifier: 'John Doe <john@company.com>',  // ❌ Invalid SMTP format
  name: 'Work Email'
});
```

### Provider Selection

**Use Case - Per-User Providers:**
```javascript
// Power user gets premium provider
await users.createTarget({
  userId: 'power_user',
  targetId: 'email',
  identifier: 'power@company.com',
  providerId: 'sendgrid_premium'  // High-volume provider
});

// Regular user uses default
await users.createTarget({
  userId: 'regular_user',
  targetId: 'email',
  identifier: 'regular@company.com'
  // providerId omitted → uses default project provider
});
```

### Email Validation

Always validate email identifiers on the client side before API calls:

```typescript
import { z } from 'zod';

const EmailSchema = z.string().email('Invalid email address');

const createEmailTarget = async (userId: string, email: string) => {
  const validEmail = EmailSchema.parse(email);  // Throws if invalid

  return users.createTarget({
    userId,
    targetId: 'email_primary',
    providerType: sdk.MessagingProviderType.Email,
    identifier: validEmail
  });
};
```

## Related Topics

- [Appwrite Messaging API](https://appwrite.io/docs/products/messaging)
- [SMTP Provider Configuration](https://appwrite.io/docs/products/messaging/smtp)
- [Email Message Scheduling](https://appwrite.io/docs/products/messaging/send-email-messages)
- [Topics and Subscribers](https://appwrite.io/docs/products/messaging/topics)

## References

- Official Appwrite Docs: https://appwrite.io/docs/products/messaging
- SMTP Configuration: https://appwrite.io/docs/products/messaging/smtp
- Node.js SDK: https://github.com/appwrite/sdk-for-node
- Email Sending: https://appwrite.io/docs/products/messaging/send-email-messages
- User Management: https://appwrite.io/docs/products/auth/users
