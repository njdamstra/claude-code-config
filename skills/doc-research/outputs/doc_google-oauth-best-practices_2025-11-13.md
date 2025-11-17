# Official Documentation: Google OAuth 2.0 Best Practices

**Research Date:** 2025-11-13
**Source:** Google Identity Platform Official Docs (developers.google.com), Context7 Library ID `/googleapis/google-auth-library-nodejs`
**Version:** OAuth 2.0 Authorization Code Flow

## Summary

Google OAuth 2.0 is a delegated authorization protocol that allows users to grant third-party applications specific permissions without sharing passwords. Key findings cover the `prompt` parameter options, incremental authorization patterns, consent screen behavior, and scope management best practices.

---

## 1. Prompt Parameter Options

The `prompt` parameter controls when authentication and consent screens appear. It's a critical parameter for achieving "one-tap" sign-in experiences for returning users.

### Valid Values

| Value | Purpose | When to Use |
|-------|---------|------------|
| `consent` | Force user consent screen every time | Testing, forcing refresh token generation, when you need guaranteed consent |
| `select_account` | Force user to select which account to use | Multi-account scenarios, account switching flows |
| `none` | Don't show any authentication/authorization screens | For returning users with prior consent (errors if user not signed in) |
| (not specified - default) | Show screens only if needed | Normal flow - shows only once per user per scope set |

### Official Guidance

From Google's official OAuth 2.0 documentation:

- **Default behavior (no prompt):** User is prompted only once to authorize access to your project. Subsequent logins don't show consent if already granted.
- **`prompt=consent`:** Always re-prompts user for consent. Useful for:
  - Testing OAuth flow
  - Forcing refresh token generation (first auth only returns refresh token)
  - Demonstrating to users that you're requesting new permissions

- **`prompt=select_account`:** Invites user to select an account (useful when user has multiple Google accounts signed in)

- **`prompt=none`:** Don't display screens. Fails with error if user hasn't previously consented or isn't signed in. Only use after initial authorization.

### One-Tap Sign-In for Returning Users

Google's recommended approach:

```javascript
const authorizeUrl = oAuth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: ['https://www.googleapis.com/auth/userinfo.email'],
  // Don't specify prompt for returning users
  // Omitting prompt means "use cached consent if available"
  // Only shows screens if needed
});

// For testing/forcing consent flow:
const testUrl = oAuth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: ['https://www.googleapis.com/auth/userinfo.email'],
  prompt: 'consent' // Force consent screen every time
});
```

**Key insight from official docs:** When `prompt` is not specified, Google shows consent only once. Returning users bypass the consent screen entirely if they've already granted access to those scopes.

---

## 2. Incremental Authorization Pattern

Google OAuth 2.0 supports **incremental authorization**, allowing apps to request minimal permissions initially, then request additional scopes later when features are actually used.

### Official Best Practice

From Google's OAuth 2.0 Policies documentation:

> "It is generally a best practice to request scopes incrementally, at the time access is required, rather than upfront."

### How Incremental Authorization Works

1. **Initial sign-in:** Request minimal scopes (openid, email, profile)
2. **Feature activation:** When user enables a feature requiring new scopes, request only that scope
3. **User choice:** User can grant some scopes while denying others
4. **Handling denials:** If user denies a scope, disable related functionality

### Implementation Pattern

```javascript
// Step 1: Initial sign-in with minimal scopes
const signInUrl = oAuth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: [
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile'
  ]
});

// Step 2: Later, when user enables YouTube feature
const youtubePermissionUrl = oAuth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: [
    'https://www.googleapis.com/auth/youtube.readonly'
  ],
  prompt: 'consent' // Request fresh consent for new scope
});

// Step 3: Handle scope denial
const {tokens} = await oAuth2Client.getToken(authorizationCode);
if (!tokens.scope || !tokens.scope.includes('youtube.readonly')) {
  // Disable YouTube features in UI
  disableYoutubeFeatures();
}
```

### Minimum Scopes for Authentication Only

Official Google documentation confirms:

> "For the authentication, default scope (email, profile, openid) is sufficient, you don't need to add any sensitive scopes."

**Minimum scopes for sign-in:**

```javascript
scope: [
  'openid',
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile'
]
// Or as string: 'openid email profile'
```

These scopes give you:
- `openid` - OpenID Connect support, unique user identifier (sub claim)
- `email` - User's email address
- `profile` - Basic profile info (name, picture, etc.)

### Adding Scopes Later for Features

```javascript
// User clicks "Connect YouTube" button
async function requestYoutubeAccess() {
  const youtubeAuthUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: ['https://www.googleapis.com/auth/youtube.readonly'],
    prompt: 'consent' // Ensure user sees the request
  });

  // Redirect user to this URL
  // Google returns authorization code
  // Exchange for token with new scope
}
```

**Official policy requirement:** Include justification to user before requesting each new scope.

---

## 3. Consent Screen Behavior

### Why Consent Appears Every Time

Users see the consent screen repeatedly due to these factors:

1. **Different scope sets:** Requesting new/different scopes always triggers consent
2. **`prompt=consent`:** Explicitly forces consent screen
3. **Token revocation:** User revoked app access in Google Account Settings
4. **App not verified:** Unverified apps on Google Cloud Console show consent every time
5. **Switching authentication method:** Moving between development and production credentials

### Quick Select Account Experience

Official implementation:

```javascript
// Use select_account to let user quickly pick account
const quickSelectUrl = oAuth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: ['openid', 'email'],
  prompt: 'select_account'
  // Shows account selection UI, not full consent
});
```

**How to achieve "quick select and done":**

1. Use consistent scopes across requests (same scopes = cached consent)
2. Avoid `prompt=consent` for production
3. Request app verification in Google Cloud Console
4. Let returning users use `prompt=none` or omit prompt parameter

### App Verification Status

From official docs, verified apps vs. unverified:

- **Verified app** - User sees app logo, verification badge - consent may be cached longer
- **Unverified app** - Shows more cautionary messages, consent less likely to be cached
- Requires OAuth Consent Screen configuration in Google Cloud Console

### `access_type: "offline"` and Consent Frequency

The `access_type` parameter **does NOT affect consent frequency**. It only affects whether you receive a refresh token:

```javascript
// Does NOT affect consent screen frequency, only refresh token
access_type: 'offline' // Receive refresh_token on first auth
access_type: 'online' // Don't receive refresh_token (default)
```

**Important:** Refresh token is only returned on first authorization. To test refresh token flow:

```javascript
const testUrl = oAuth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: ['https://www.googleapis.com/auth/userinfo.email'],
  prompt: 'consent' // Force consent to get fresh refresh_token
});
```

---

## 4. Scope Best Practices

### Recommended Architecture for Multi-Feature Apps

**Separate authentication scopes from feature scopes:**

```javascript
// AUTHENTICATION SCOPES (requested at sign-in)
const authScopes = [
  'openid',
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile'
];

// FEATURE SCOPES (requested when user enables features)
const youtubeScopes = {
  readOnly: 'https://www.googleapis.com/auth/youtube.readonly',
  fullAccess: 'https://www.googleapis.com/auth/youtube'
};

const gmailScopes = {
  readOnly: 'https://www.googleapis.com/auth/gmail.readonly',
  sendEmail: 'https://www.googleapis.com/auth/gmail.send'
};

// Google Workspace scopes
const workspaceScopes = {
  calendar: 'https://www.googleapis.com/auth/calendar'
};

// Initial sign-in: authentication only
const signInUrl = oAuth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: authScopes
});

// Later: request specific features as needed
async function enableYoutubeSyncFeature() {
  const youtubeUrl = oAuth2Client.generateAuthUrl({
    scope: [youtubeScopes.readOnly],
    prompt: 'consent'
  });
}
```

### Scope Request Principles

From official Google OAuth 2.0 Policies:

1. **Request smallest set necessary** - Only request what you actually need
2. **Request least access** - E.g., use `gmail.readonly` instead of `gmail.send` if reading only
3. **Avoid over-requesting** - Don't request full access when you only need limited functionality
4. **Handle partial consent** - User may approve some requested scopes but not others

**Example from policy:**

> "An app that only uses Gmail APIs to occasionally send emails on a user's behalf shouldn't request the scope that provides full access to the user's email data."

### Handling YouTube API Scopes Separately

YouTube scopes work exactly like other feature scopes:

```javascript
// Separate YouTube authorization flow
async function authorizeYoutubeFeature() {
  // Create a fresh auth URL with only YouTube scope
  const youtubeAuthUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: ['https://www.googleapis.com/auth/youtube.readonly'],
    prompt: 'consent' // Force consent for visibility
  });

  // Redirect user, get authorization code
  // Exchange code for separate access/refresh tokens
  const {tokens} = await oAuth2Client.getToken(authCode);

  // Store YouTube tokens separately from auth tokens
  await db.saveYoutubeCredentials(userId, tokens);
}

// Later, use YouTube tokens independently
async function listUserChannels() {
  const youtubeTokens = await db.getYoutubeCredentials(userId);
  const youtubeClient = new OAuth2Client(clientId, clientSecret);
  youtubeClient.setCredentials(youtubeTokens);

  // Make YouTube API call with YouTube-scoped client
}
```

---

## 5. Configuration Examples

### Node.js Complete Example with Incremental Authorization

```javascript
const {OAuth2Client} = require('google-auth-library');

const oauth2Client = new OAuth2Client(
  'YOUR_CLIENT_ID',
  'YOUR_CLIENT_SECRET',
  'YOUR_REDIRECT_URI'
);

// Step 1: Initial sign-in (minimal scopes)
const initialAuthUrl = oauth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: [
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile'
  ]
  // Note: No prompt parameter = use cached consent if available
});

console.log('Visit this URL for initial authentication:', initialAuthUrl);

// After user returns with authorization code
async function handleInitialAuth(authCode) {
  const {tokens} = await oauth2Client.getToken(authCode);
  oauth2Client.setCredentials(tokens);

  // Store refresh token securely
  if (tokens.refresh_token) {
    await db.saveRefreshToken(userId, tokens.refresh_token);
  }

  return tokens;
}

// Step 2: Later, request additional scope for feature
async function enableYoutubeFeature(userId) {
  // Create new auth URL for YouTube scope only
  const youtubeAuthUrl = oauth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: ['https://www.googleapis.com/auth/youtube.readonly'],
    prompt: 'consent' // Request fresh consent for new scope
  });

  console.log('User needs to authorize YouTube:', youtubeAuthUrl);
  // Redirect user to this URL
}

// Step 3: Verify which scopes user actually granted
async function verifyGrantedScopes(accessToken) {
  const tokenInfo = await oauth2Client.getTokenInfo(accessToken);
  console.log('Granted scopes:', tokenInfo.scopes);

  const hasYoutube = tokenInfo.scopes.includes('youtube.readonly');
  if (!hasYoutube) {
    // Disable YouTube feature in UI
  }
}
```

### Handling Consent Screen Force (Testing)

```javascript
// Force consent every time (for testing or demonstration)
const testAuthUrl = oauth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: ['https://www.googleapis.com/auth/userinfo.email'],
  prompt: 'consent' // Always shows consent screen
});

// Force account selection screen
const selectAccountUrl = oauth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: ['https://www.googleapis.com/auth/userinfo.email'],
  prompt: 'select_account' // Shows account picker
});
```

---

## 6. Best Practices Summary

### For Authentication Only
1. Request minimal scopes: `openid`, `email`, `profile`
2. Set `access_type: 'offline'` to get refresh token
3. Don't use `prompt` parameter (defaults to smart behavior)
4. Store refresh token securely for token refresh

### For Incremental Authorization
1. Request minimal authentication scopes at sign-in
2. Request feature-specific scopes only when user enables features
3. Always provide user context before requesting new scopes
4. Handle partial consent (user may deny some scopes)
5. Disable features if user denies required scopes

### For Consent Screen Management
1. Omit `prompt` parameter for best user experience (uses cached consent)
2. Use `prompt: 'consent'` only for testing or when forcing user acknowledgment
3. Use `prompt: 'select_account'` for multi-account scenarios
4. Get app verified in Google Cloud Console to reduce consent friction
5. Request app verification for production apps

### For Scope Management
1. Request smallest set of scopes necessary
2. Prefer read-only scopes (e.g., `gmail.readonly` vs `gmail.send`)
3. Separate authentication from feature scopes
4. Justify new scope requests to users
5. Update Google Cloud Console consent screen config when scopes change

### For YouTube Integration
1. Request YouTube scopes separately from auth scopes
2. Use same incremental pattern: request when user enables YouTube feature
3. Minimum YouTube scope: `youtube.readonly`
4. Store YouTube tokens separately from auth tokens

---

## 7. Gotchas & Important Notes

- **Refresh token only on first auth:** Even with `access_type: 'offline'`, refresh_token is only returned on first authorization. To test refresh token flow, use `prompt: 'consent'` to force re-authorization.

- **Consent screen config matters:** Your OAuth Consent Screen configuration in Google Cloud Console must match requested scopes. Mismatches can cause errors.

- **Scope changes trigger reassessment:** If you add restricted scopes, your app may need re-verification.

- **Access token expiration:** Access tokens expire (typically ~1 hour). Always use refresh token to get new access tokens without re-prompting user.

- **Revocation clears consent:** If user revokes app access in Google Account Settings, your cached consent is cleared. Next auth will show full consent screen.

- **Multi-scope denials:** When requesting multiple scopes, user can approve some and deny others. Check returned scopes and disable features accordingly.

- **App verification status:** Unverified apps may show more warnings and are less likely to cache consent for extended periods.

- **Cross-origin and One Tap:** Google One Tap now uses Federated Credential Management (FedCM) in newer browsers, which has different behavior than traditional OAuth flow.

---

## 8. Official Sources & References

- **Google OAuth 2.0 Web Server Flow:** https://developers.google.com/identity/protocols/oauth2/web-server
- **Google OAuth 2.0 Policies:** https://developers.google.com/identity/protocols/oauth2/policies
- **Google Identity Setup Guide:** https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid
- **Google Auth Library for Node.js:** https://github.com/googleapis/google-auth-library-nodejs
- **OAuth 2.0 for iOS & Desktop Apps:** https://developers.google.com/identity/protocols/oauth2/native-app
- **Sign in with Google JavaScript API Reference:** https://developers.google.com/identity/gsi/web/reference/js-reference

---

## 9. Key Implementation Decisions for Socialaize

Based on official documentation, for Appwrite + Astro application:

### Recommended Scope Strategy
```typescript
// Authentication scopes (request at sign-in)
const AUTH_SCOPES = [
  'openid',
  'email',
  'profile'
] as const;

// Feature scopes (request on-demand)
const FEATURE_SCOPES = {
  youtube: 'https://www.googleapis.com/auth/youtube.readonly',
  gmail: 'https://www.googleapis.com/auth/gmail.readonly',
} as const;
```

### URL Generation Best Practices
```typescript
// For first-time users: minimal scopes, no prompt
function generateSignInUrl() {
  return oauth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: AUTH_SCOPES,
    // No prompt = use cached consent if available
  });
}

// For returning users with existing consent: no prompt needed
// For feature additions: request new scope with prompt=consent
function generateFeatureAuthUrl(feature: keyof typeof FEATURE_SCOPES) {
  return oauth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: [FEATURE_SCOPES[feature]],
    prompt: 'consent' // Explicit request for new access
  });
}
```

### Consent Screen Behavior
- First sign-in: Shows consent screen once
- Returning users: Skips consent if scopes unchanged (critical for UX)
- New features: Shows consent only for new scopes
- Never use `prompt='consent'` in production unless you want to force visible consent every time
