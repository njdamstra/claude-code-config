# Best Practices & Community Patterns: Appwrite SMTP Email Target Formatting

**Research Date:** 2025-11-16
**Sources:** Web research via Tavily (GitHub issues, Appwrite Threads, community discussions)
**Search Queries:**
- "Appwrite messaging Invalid to field SMTP error"
- "Appwrite createEmail SMTP recipient format target identifier"
- "site:github.com/appwrite/appwrite SMTP email target issues messaging"
- "Appwrite Resend email target format undisclosed-recipients validation error"
- "site:appwrite.io/threads email messaging SMTP format target"

## Summary

Appwrite's messaging system has undergone significant fixes for SMTP email formatting, particularly around the "Invalid to field" error when sending to multiple recipients. The core issue stems from how Appwrite formats recipient email addresses when using SMTP providers vs. API-based providers (SendGrid, Mailgun). A critical bug fix in **PR #9243** (merged Feb 2025 into v1.6.x) resolved privacy and formatting issues with SMTP batch emails.

**Key Community Consensus:**
- Use `users` array for simple sends (Appwrite handles target resolution)
- Use `bcc` to hide recipients from each other
- Use `cc` for transparent multi-recipient sends
- SMTP providers now send separate emails per recipient (post-PR #9243)
- Resend provider specifically requires strict RFC 5322 email format validation

## Common Implementation Patterns

### Pattern 1: Send Email to User (Recommended for Most Cases)

**Source:** Appwrite Threads, GitHub PR #9243
**Links:**
- https://appwrite.io/threads/1430090415884730388
- https://github.com/appwrite/appwrite/pull/9243

**Description:**
Use the `users` array parameter to send emails to Appwrite users. Appwrite automatically resolves the user's email target from their account settings.

**Code Example:**
```typescript
await messaging.createEmail({
  messageId: ID.unique(),
  subject: "Welcome Email",
  content: "<p>Welcome to our platform!</p>",
  users: [recipientUserId],  // Array of user IDs
  draft: false,
  html: true,
});
```

**Pros:**
- Appwrite automatically resolves email addresses from user accounts
- No need to manually manage email target IDs
- Works with default email targets set in user preferences
- Handles SMTP formatting automatically

**Cons:**
- Requires users to be registered in Appwrite Auth
- Cannot send to arbitrary email addresses without creating targets

### Pattern 2: Send to Specific Target ID

**Source:** Appwrite Threads - "Failed sending to target forbidden error"
**Link:** https://appwrite.io/threads/1397578713524211714

**Description:**
Send email to a specific email target by its ID. Requires explicit target creation.

**Code Example:**
```typescript
// First, create or fetch the target ID
// Then send using targets array
await messaging.createEmail(
  ID.unique(),           // messageId
  'Test Email',          // subject
  '<p>Test content</p>', // content
  [],                    // topics (empty)
  [],                    // users (empty when using targets)
  [targetId],            // targets (using the specific target ID)
  [],                    // cc (empty)
  [],                    // bcc (empty)
  [],                    // attachments (empty)
  false,                 // draft (false = send immediately)
  true                   // html (true for HTML content)
);
```

**Pros:**
- Direct control over which email address receives the message
- Can send to non-user email addresses
- Useful for guest/unauthenticated workflows

**Cons:**
- More verbose API
- Requires managing target IDs separately
- Potential "Forbidden" errors if target doesn't exist or lacks permissions

### Pattern 3: BCC for Privacy (Multiple Recipients)

**Source:** GitHub PR #9243 - "Fix email (smtp) to multiple recipients"
**Link:** https://github.com/appwrite/appwrite/pull/9243

**Description:**
Post-PR #9243 (v1.6.x+), SMTP providers send separate emails per recipient. Use `bcc` to hide recipients from each other.

**Code Example:**
```typescript
await messaging.createEmail({
  messageId: ID.unique(),
  subject: "Newsletter",
  content: "<p>Monthly update...</p>",
  bcc: ['user1@example.com', 'user2@example.com'],  // Recipients hidden from each other
  draft: false,
  html: true,
});
```

**Why it happens:**
Before PR #9243, SMTP emails to multiple recipients exposed all addresses to all recipients, creating privacy issues. The fix makes SMTP send separate emails (like SendGrid/Mailgun batch endpoints).

**Pros:**
- Protects recipient privacy
- Works with SMTP providers (Gmail, Mailgun SMTP, Resend)
- Each recipient gets their own email copy

**Cons:**
- Higher SMTP send volume (one email per recipient)
- Slightly slower delivery for large lists

## Real-World Gotchas

### Gotcha 1: Resend "Invalid `to` field" with `users` Array

**Problem:**
When using Resend as SMTP provider with `users: [userId]`, Appwrite sends malformed `to` field causing 422 validation error.

**Error Message:**
```json
{
  "name": "validation_error",
  "message": "Invalid `to` field. The email address needs to follow the `email@example.com` or `Name <email@example.com>` format.",
  "statusCode": 422
}
```

**Request Body Shows:**
```json
{
  "bcc": ["correct-email@example.com"],  // Correct email in BCC
  "to": "\"undisclosed-recipients\": ;"   // Malformed "to" field
}
```

**Why it happens:**
Appwrite's SMTP adapter uses `"undisclosed-recipients": ;` as a placeholder `to` field when sending to BCC recipients only. Resend's strict RFC 5322 validation rejects this non-standard format.

**Solution:**
**Temporary Workaround** (until Appwrite fixes this):
Use `targets` array with explicit email addresses instead of `users` array when using Resend:

```typescript
// Instead of users array
// await messaging.createEmail({ users: [userId], ... })

// Use targets with explicit emails
await messaging.createEmail({
  messageId: ID.unique(),
  subject: "Subject",
  content: "Content",
  targets: [targetId],  // Or create target with specific email
  draft: false,
  html: true,
});
```

**Source:** https://appwrite.io/threads/1430090415884730388

### Gotcha 2: "Failed sending to target forbidden" Error

**Problem:**
When sending to specific `targetId`, error "Failed sending to target [email] with error: Forbidden"

**Why it happens:**
- Target ID doesn't exist in the database
- Target was deleted
- Permissions issue (target belongs to different user/project)
- SMTP server not configured correctly (but magic links work)

**Solution:**
1. Verify target exists: Query targets to ensure ID is valid
2. Check permissions: Ensure function/API key has permission to send to that target
3. Test SMTP config: Run `docker exec appwrite doctor` (self-hosted) to verify SMTP connectivity
4. Use `users` array instead: Let Appwrite resolve targets automatically

```typescript
// Safer approach - let Appwrite handle target resolution
await messaging.createEmail({
  users: [userId],  // Appwrite finds default email target
  // ... other params
});
```

**Source:** https://appwrite.io/threads/1397578713524211714

### Gotcha 3: Target ID Confusion (User ID ≠ Target ID)

**Problem:**
Developers confuse `userId` with `targetId`, leading to laborious queries to get target IDs.

**Why it happens:**
Appwrite separates user authentication (User ID) from messaging targets (Target ID). A user can have multiple targets (email, SMS, push).

**Solution:**
- **For registered users:** Use `users: [userId]` - Appwrite auto-resolves default email target
- **For guest emails:** Create explicit targets first, then use `targets: [targetId]`
- **Don't query for target IDs** unless you need to send to non-default addresses

```typescript
// For authenticated users - NO target ID needed
await messaging.createEmail({
  users: ['user123'],  // Appwrite handles target resolution
  subject: 'Hello',
  content: 'Message',
});

// For guest/arbitrary emails - create target first
const target = await messaging.createEmailTarget({
  targetId: ID.unique(),
  email: 'guest@example.com',
});

await messaging.createEmail({
  targets: [target.$id],  // Now use target ID
  subject: 'Guest Email',
  content: 'Message',
});
```

**Source:** https://appwrite.io/threads/1360734879041720603

## Performance Considerations

**SMTP vs. API Providers (Post-PR #9243):**
- **SMTP (Gmail, custom servers):** Sends separate email per recipient
  - Pro: Better privacy, RFC compliant
  - Con: Higher send volume, slower for large lists
- **API Providers (SendGrid, Mailgun):** Use batch API endpoints
  - Pro: Single API call for multiple recipients
  - Con: Requires API-based provider setup

**Recommendation for Large Lists:**
Use SendGrid or Mailgun API (not SMTP) for newsletters/bulk sends. SMTP is better for transactional 1:1 emails.

## Compatibility Notes

### Resend Provider Compatibility
- **Issue:** Strict RFC 5322 validation rejects `"undisclosed-recipients": ;` format
- **Affected Versions:** All versions (Appwrite bug, not Resend)
- **Workaround:** Use `targets` instead of `users` array
- **Status:** Open issue, no official fix yet

### SMTP Provider Changes
- **Before v1.6.x:** Multiple recipients exposed all emails to all recipients
- **After v1.6.x (PR #9243):** SMTP sends separate email per recipient
- **Migration Impact:** None (automatic improvement)

### Version-Specific Notes
- **v1.6.x+:** PR #9243 merged (SMTP privacy fix)
- **v1.7.0+:** Includes all SMTP fixes from 1.6.x backports
- **v1.8.0+:** Latest stable with messaging improvements

## Community Recommendations

### Highly Recommended
- **Use `users` array for authenticated user emails** - Simplest, Appwrite handles target resolution automatically
- **Use `bcc` for multi-recipient privacy** - Ensures recipients don't see each other's addresses
- **Upgrade to v1.6.x+ for SMTP privacy fixes** - PR #9243 is critical for SMTP security
- **Test SMTP config with `appwrite doctor`** - Verifies connectivity before troubleshooting code

### Avoid
- **Manually querying target IDs for registered users** - Unnecessary, use `users` array instead
- **Using `to` field with multiple recipients** - Use `users`, `cc`, or `bcc` instead
- **Assuming user ID == target ID** - They're separate concepts
- **Using SMTP for bulk sends (1000+ emails)** - Switch to SendGrid/Mailgun API for performance

## Alternative Approaches

### Approach 1: Custom Email Sending Function
**When to use:** Need direct control over SMTP formatting, or Resend "undisclosed-recipients" workaround

```typescript
// Custom Appwrite Function using Resend API directly
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

await resend.emails.send({
  from: 'noreply@yourdomain.com',
  to: userEmail,  // Direct email, no target ID
  subject: 'Subject',
  html: '<p>Content</p>',
});
```

**Pros:** Full control, bypasses Appwrite SMTP formatting issues
**Cons:** Bypasses Appwrite messaging logs/tracking

**Source:** https://appwrite.io/threads/1279759107909484554

### Approach 2: Use Built-in SMTP (Not Resend)
**When to use:** Need messaging integration but Resend causes issues

Use Appwrite's built-in SMTP with providers that don't enforce strict RFC validation:
- Gmail SMTP
- Mailgun SMTP (not API)
- Custom SMTP servers
- SendGrid SMTP

**Note:** Still benefits from PR #9243 privacy fixes.

## Useful Tools & Libraries

- **Resend API SDK** - https://resend.com/docs/send-with-nodejs - Direct email sending bypassing Appwrite
- **Appwrite CLI** - `appwrite doctor` command to verify SMTP connectivity
- **node-appwrite SDK v18.0.0+** - Latest SDK with messaging support
- **Mailgun API** - Alternative to Resend with batch send endpoints

## References

### GitHub Issues & PRs
- [PR #9243: Fix email (smtp) to multiple recipients](https://github.com/appwrite/appwrite/pull/9243) - ChiragAgg5k - Feb 2025
  - **Key Fix:** SMTP sends separate email per recipient (privacy + RFC compliance)
- [Issue #8261: Email from other targets/users sent to all targets](https://github.com/appwrite/appwrite/issues/8261) - Privacy issue resolved by PR #9243
- [Issue #10101: Messages page broken after SMTP misconfiguration](https://github.com/appwrite/appwrite/issues/10101) - DeliveryErrors validation errors

### Appwrite Threads
- [Messaging via Resend: "undisclosed-recipients" error](https://appwrite.io/threads/1430090415884730388) - Oct 2025
  - **Issue:** Resend rejects `"to": "\"undisclosed-recipients\": ;"` format
  - **Workaround:** Use `targets` instead of `users` array
- [Failed sending to target forbidden error](https://appwrite.io/threads/1397578713524211714) - Jul 2025
  - **Cause:** Missing target ID, permissions issue, or SMTP misconfiguration
- [Unclear about using TargetID in Messaging](https://appwrite.io/threads/1360734879041720603) - Apr 2025
  - **Clarification:** Use `users` array to avoid manual target ID queries
- [SMTP problem](https://appwrite.io/threads/1222244187689189376) - Mar 2024
  - SMTP configuration and domain issues

### Release Notes
- [Appwrite v1.7.0 Changelog](https://github.com/appwrite/appwrite/releases) - Includes "Fix email (smtp) to multiple recipients"

## Implementation Checklist

When implementing Appwrite email sending:

- [ ] Upgrade to Appwrite v1.6.x+ (includes PR #9243 fix)
- [ ] Use `users` array for authenticated user emails (simplest)
- [ ] Use `bcc` for multi-recipient emails (privacy)
- [ ] Use `targets` array only for guest/non-user emails
- [ ] Test with your SMTP provider (Resend users: watch for "undisclosed-recipients" error)
- [ ] Run `appwrite doctor` to verify SMTP connectivity (self-hosted)
- [ ] Consider switching to SendGrid/Mailgun API for bulk sends
- [ ] Monitor message logs in Appwrite Console for delivery errors
- [ ] Set up proper error handling for 422 validation errors (Resend)
- [ ] Document which SMTP provider you're using (affects behavior)

## Version Migration Guide

**Upgrading from v1.5.x or earlier to v1.6.x+:**

1. **No breaking changes** - PR #9243 is backward compatible
2. **Behavior change:** SMTP now sends separate emails per recipient (improvement)
3. **Action required:** None, but review multi-recipient sends for performance
4. **Resend users:** Watch for "undisclosed-recipients" error (see Gotcha #1)

**Best practice after upgrade:**
```typescript
// Before PR #9243: This exposed all emails to all recipients
await messaging.createEmail({
  users: [user1, user2, user3],  // Privacy issue pre-v1.6.x
});

// After PR #9243: Each user gets separate email (privacy preserved)
await messaging.createEmail({
  users: [user1, user2, user3],  // Safe in v1.6.x+
});
```
