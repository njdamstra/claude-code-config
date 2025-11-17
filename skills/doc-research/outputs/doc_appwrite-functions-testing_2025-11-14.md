# Official Documentation: Appwrite Serverless Functions Testing

**Research Date:** 2025-11-14
**Source:** /appwrite/appwrite (Context7), appwrite.io official documentation
**Version:** Appwrite 1.7+ (current)

## Summary

Appwrite Functions follow a standard request-response lifecycle that applies both to deployed functions and local development. Official testing approaches include local development with Docker, environment variable testing, dynamic API keys, and user impersonation via the CLI. The Appwrite SDK (node-appwrite for Node.js) provides type-safe methods for database interactions, which should be mocked or stubbed in unit tests.

## Testing Approaches

### 1. Local Development Testing (Official Method)

**Setup Requirements:**
- Docker Desktop installed and running
- Appwrite CLI installed: `npm install -g appwrite-cli`
- Project initialized with `appwrite.config.json`
- Function initialized via `appwrite init function`

**Local Execution Command:**
```bash
appwrite run functions --port 3000 --function-id "<FUNCTION_ID>"
```

**Key Features:**
- Hot reload enabled by default (changes auto-reload)
- Automatic Docker image pulling and setup (first run)
- Function accessible at `http://localhost:3000/`
- Emulates production environment precisely

**Configuration in `appwrite.config.json`:**
```json
{
  "functions": {
    "function-id": {
      "runtime": "node-16.0",
      "entrypoint": "src/main.js",
      "path": "functions/function-id",
      "scopes": ["databases.read", "databases.write"]
    }
  }
}
```

### 2. Local Development with Options

**Port Configuration:**
```bash
appwrite run functions --port 7000 --function-id "<FUNCTION_ID>"
```
Defaults to 3000, auto-increments if busy (3001, 3002, etc.)

**User Impersonation (for testing permissions):**
```bash
appwrite run functions --user-id "<USER_ID>"
```
- Sets `x-appwrite-user-id` header automatically
- Generates JWT token in `x-appwrite-user-jwt` header (1-hour expiry)
- Validates user exists before running
- Useful for testing access control logic

**Production Environment Variables:**
```bash
appwrite run functions --with-variables
```
Warning: Only use if function doesn't contain production secrets

**Disable Hot Reload:**
```bash
appwrite run functions --no-reload
```
Useful for debugging reload behavior

### 3. Function Lifecycle & Context

Every Appwrite Function follows this lifecycle:

1. Function invoked (HTTP, event, schedule, SDK call)
2. Active deployment's executor handles request
3. Executor passes request info via `context.req` object
4. Runtime executes code (you can log via `context.log()`)
5. Function returns response via `context.res.text()`, `context.res.json()`, etc.

**Context Object Properties:**

| Property | Description | Usage |
|----------|-------------|-------|
| `context.req` | Request object with method, body, headers | Read-only input |
| `context.res` | Response builder (text, json, binary, redirect, empty) | Output |
| `context.log(msg)` | Log to Appwrite Console (dev-only) | Debugging |
| `context.error(err)` | Log errors to Console (dev-only) | Error tracking |

**Node.js Function Example:**
```typescript
export default async function (context) {
  // Access request
  const body = context.req.bodyJson;
  const headers = context.req.headers;

  // Log (dev-only, not visible to caller)
  context.log('Processing request');

  // Business logic
  const result = await processData(body);

  // Return response
  return context.res.json({ success: true, data: result });
}
```

### 4. Testing with Dynamic API Keys

Dynamic API keys are automatically generated per function execution. They're available in two ways:

**At Build Time (via Environment Variable):**
```bash
// Automatically injected as APPWRITE_FUNCTION_API_KEY
// Only available during build phase
// Used to initialize Appwrite SDK
```

**At Runtime (via Header):**
```typescript
export default async function (context) {
  // x-appwrite-key header contains dynamic API key
  const apiKey = context.req.headers['x-appwrite-key'];

  // Use with SDK to act as admin
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(apiKey); // Dynamic key
}
```

**Scope Configuration:**
Configure function scopes in Appwrite Console to limit dynamic key permissions:
1. Navigate to Functions > Your Function > Settings > Scopes
2. Select minimal required scopes (best practice)
3. Available scopes: `databases.read`, `databases.write`, `collections.read`, `files.read`, `files.write`, etc.

### 5. Testing with JWT (User Context)

For testing functions that should act on behalf of a user:

**Automatically Provided Header:**
```typescript
export default async function (context) {
  // If invoked by authenticated user, this header is auto-present
  const jwtToken = context.req.headers['x-appwrite-user-jwt'];
  const userId = context.req.headers['x-appwrite-user-id'];

  // Use JWT to create client that respects user permissions
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setSession(jwtToken); // Acts as user

  // Can only access resources user has permission to
  const databases = new Databases(client);
}
```

**Local Testing with User Impersonation:**
```bash
appwrite run functions --user-id "user_abc123"
```
JWT valid for 1 hour during local testing.

### 6. Environment Variables in Functions

**Built-in Variables (Always Available):**

| Variable | Description | Available |
|----------|-------------|-----------|
| `APPWRITE_FUNCTION_API_ENDPOINT` | API endpoint of running function | Build & Run |
| `APPWRITE_FUNCTION_API_KEY` | Function API key for SDK auth | Build time only |
| `APPWRITE_FUNCTION_ID` | Function ID | Build & Run |
| `APPWRITE_FUNCTION_NAME` | Function name | Build & Run |
| `APPWRITE_FUNCTION_DEPLOYMENT` | Deployment ID | Build & Run |
| `APPWRITE_FUNCTION_PROJECT_ID` | Project ID | Build & Run |
| `APPWRITE_FUNCTION_RUNTIME_NAME` | Runtime name (e.g., "Node.js") | Build & Run |
| `APPWRITE_FUNCTION_RUNTIME_VERSION` | Runtime version (e.g., "21.0") | Build & Run |
| `APPWRITE_VERSION` | Appwrite version | Build & Run |
| `APPWRITE_REGION` | Function region | Build & Run |

**Custom Variables:**
Define in Function Settings > Configuration > Variables (encrypted at rest)

**Testing with Variables:**
```bash
appwrite run functions --with-variables
```
Loads production variables for local testing (use cautiously).

### 7. Request Headers (Always Provided)

Functions automatically receive metadata headers:

| Header | Description | Example |
|--------|-------------|---------|
| `x-appwrite-trigger` | Invocation source | `http`, `schedule`, `event` |
| `x-appwrite-event` | Event name (if triggered by event) | `databases.documents.create` |
| `x-appwrite-key` | Dynamic API key (runtime) | `api_key_xyz...` |
| `x-appwrite-user-id` | User ID (if user-invoked) | `user_abc123` |
| `x-appwrite-user-jwt` | JWT token (if user-invoked) | `eyJ0eXAi...` |
| `x-appwrite-execution-id` | Current execution ID | `exec_123...` |
| `x-appwrite-country-code` | Country code | `US` |
| `x-appwrite-continent-code` | Continent code | `NA` |
| `x-appwrite-continent-eu` | Is in EU? | `false` |
| `x-appwrite-client-ip` | Caller IP address | `192.168.1.1` |

## Node-Appwrite SDK Testing Patterns

### 8. SDK Integration in Functions

**Initialization Pattern:**
```typescript
import { Client, Databases } from 'node-appwrite';

export default async function (context) {
  // Option 1: Dynamic API Key (Admin)
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(context.req.headers['x-appwrite-key']);

  // Option 2: JWT (User Context)
  const userClient = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setSession(context.req.headers['x-appwrite-user-jwt']);

  const databases = new Databases(client);
  return context.res.json({ success: true });
}
```

### 9. Testing Database Queries

**Example with Error Handling:**
```typescript
import { Client, Databases, Query } from 'node-appwrite';

export default async function (context) {
  try {
    const client = new Client()
      .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
      .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
      .setKey(context.req.headers['x-appwrite-key']);

    const databases = new Databases(client);

    // Query with filters
    const documents = await databases.listDocuments(
      process.env.DATABASE_ID,
      process.env.COLLECTION_ID,
      {
        queries: [
          Query.equal('status', 'active'),
          Query.greaterThan('score', 100),
          Query.limit(10)
        ]
      }
    );

    context.log(`Found ${documents.total} documents`);
    return context.res.json(documents);

  } catch (error) {
    context.error(`Database error: ${error.message}`);
    return context.res.json({ error: error.message }, 500);
  }
}
```

**Supported Query Types:**
```typescript
Query.equal('field', 'value')
Query.notEqual('field', 'value')
Query.lessThan('age', 18)
Query.greaterThan('price', 100)
Query.between('score', 50, 100)
Query.startsWith('email', 'admin@')
Query.endsWith('domain', '.com')
Query.contains('tags', 'featured')
Query.isNull('deletedAt')
Query.isNotNull('profileImage')
Query.search('content', 'keyword')
Query.orderAsc('name')
Query.orderDesc('createdAt')
Query.limit(20)
Query.offset(0)
Query.select(['name', 'email'])
```

## Code Structure for Complex Functions

For larger functions, split code into modules:

**Node.js Example:**
```typescript
// src/utils.ts
export function add(a: number, b: number): number {
  return a + b;
}

// src/main.ts
import { add } from './utils';

export default function (context) {
  return context.res.json({ result: add(5, 3) });
}
```

## Testing Strategies Summary

### Unit Testing Approach

While Appwrite provides no official unit test framework, use standard patterns:

**1. Mock the Appwrite Client:**
```typescript
// test/oauth-manager.test.ts
import { jest } from '@jest/globals';

describe('OAuthManager', () => {
  let mockDatabases;

  beforeEach(() => {
    mockDatabases = {
      getDocument: jest.fn(),
      updateDocument: jest.fn(),
      createDocument: jest.fn()
    };
  });

  test('should handle OAuth scope selection', async () => {
    // Arrange
    mockDatabases.getDocument.mockResolvedValue({
      $id: 'oauth_123',
      scopes: ['read', 'write']
    });

    // Act
    const result = await selectScopes(mockDatabases, 'oauth_123');

    // Assert
    expect(result).toEqual({ read: true, write: true });
  });
});
```

**2. Extract Business Logic:**
```typescript
// src/oauthLogic.ts
export async function selectScopes(
  databases: Databases,
  oauthId: string,
  selectedScopes: string[]
): Promise<void> {
  // Business logic testable without context
  return databases.updateDocument(
    process.env.DATABASE_ID,
    process.env.OAUTH_COLLECTION,
    oauthId,
    { selectedScopes }
  );
}

// src/main.ts
import { selectScopes } from './oauthLogic';

export default async function (context) {
  const client = new Client()...
  const databases = new Databases(client);

  const body = context.req.bodyJson;
  await selectScopes(databases, body.oauthId, body.scopes);

  return context.res.json({ success: true });
}
```

**3. Test with Real Local Instance:**
```bash
# Start function locally
appwrite run functions --port 3000 --function-id "OAuthManager"

# In another terminal, test with curl
curl -X POST http://localhost:3000 \
  -H "Content-Type: application/json" \
  -d '{"oauthId": "oauth_123", "scopes": ["read", "write"]}'
```

### Integration Testing

For full integration testing with OAuth Manager:

**1. Use User Impersonation:**
```bash
appwrite run functions --user-id "test_user_123" --port 3000
```

**2. Test Permission Scenarios:**
```bash
# Test without proper scopes
curl -X POST http://localhost:3000/select-scopes \
  -H "x-appwrite-key: invalid_key" \
  -d '...'

# Test with valid JWT
curl -X POST http://localhost:3000/select-scopes \
  -H "x-appwrite-user-jwt: eyJ0eXAi..." \
  -d '...'
```

**3. Debug with Logs:**
```typescript
export default async function (context) {
  context.log('Request body:', JSON.stringify(context.req.bodyJson));
  context.log('Headers:', JSON.stringify(context.req.headers));
  context.log('User ID:', context.req.headers['x-appwrite-user-id']);

  // ... function logic ...

  context.log('Response:', JSON.stringify(result));
  return context.res.json(result);
}
```

View logs in Appwrite Console:
1. Functions > Your Function > Executions > Click execution
2. View "Logs" tab for `context.log()` output
3. View "Errors" tab for `context.error()` output

## Dependencies & Build Configuration

**Dependency Management:**

| Runtime | Package Manager | Command | Dependency File |
|---------|-----------------|---------|-----------------|
| Node.js | NPM | `npm install` | `package.json`, `package-lock.json` |
| Python | pip | `pip install -r requirements.txt` | `requirements.txt` |
| PHP | Composer | `composer install` | `composer.json`, `composer.lock` |
| Ruby | Bundler | `bundle install` | `Gemfile`, `Gemfile.lock` |

**Configure Build Commands:**
1. Console: Functions > Your Function > Settings > Configuration > Build Settings
2. Add install command: `npm install`
3. Add build command if compiling: `npm run build` (for TypeScript)

**Hot Reload Behavior:**
- **Interpreted languages:** Only restart on code change (fast)
- **Compiled languages:** Rebuild and restart on change
- **All languages:** Rebuild if dependency file changes (package.json, requirements.txt, etc.)

## Environment Setup Checklist

For OAuth Manager-type functions using node-appwrite SDK:

```typescript
// .env / appwrite.config.json
APPWRITE_FUNCTION_API_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_FUNCTION_PROJECT_ID=<your_project_id>
DATABASE_ID=<oauth_database_id>
OAUTH_COLLECTION=<oauth_collection_id>
PROVIDER_API_KEY=<provider_api_key>  // OAuth provider key
PROVIDER_SECRET=<provider_secret>    // OAuth provider secret

// Scopes for dynamic API key
{
  "functions": {
    "OAuthManager": {
      "scopes": [
        "documents.read",
        "documents.write",
        "collections.read"
      ]
    }
  }
}
```

## Limitations & Important Notes

**Local Development Limitations (Official Documentation):**
- Permissions system not enforced locally (all requests succeed)
- Events not triggered by database changes
- CRON schedules not executed
- Function timeouts not enforced
- Real-time updates not available

**SDK-Specific Notes:**
- `node-appwrite` is server-side SDK (not for browser)
- Dynamic API keys only available in function context
- JWT tokens expire after 1 hour in local testing
- User impersonation validates user exists before running

**Testing OAuth Functions:**
- Mock external OAuth provider API calls
- Test token refresh logic separately
- Test scope selection with real database queries
- Validate permission inheritance with user JWT

## References

- [Official Appwrite Functions Docs](https://appwrite.io/docs/products/functions)
- [Local Development Guide](https://appwrite.io/docs/products/functions/develop-locally)
- [Function Development Guide](https://appwrite.io/docs/products/functions/develop)
- [Node-Appwrite SDK Docs](https://github.com/appwrite/sdk-for-node)
- [Appwrite CLI Reference](https://appwrite.io/docs/tooling/command-line)
