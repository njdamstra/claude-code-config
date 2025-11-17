# Official Documentation: Session Resilience Patterns

**Research Date:** 2025-11-15
**Sources:** Astro Docs, Vue 3 Docs, Headless UI, Nanostores, VueUse, MDN Web APIs
**Version Coverage:** Astro 5+, Vue 3+, Headless UI (React/Vue), Nanostores, VueUse v13+

## Summary

Comprehensive documentation on session resilience patterns covering Astro middleware authentication, Vue 3 lifecycle-based session monitoring, non-dismissible modals, API error handling, cross-tab communication, and state management integration. All patterns designed for SSR compatibility.

## 1. Astro Middleware Authentication Patterns

### Protect Routes with Authentication Middleware

**Purpose:** Intercept requests and verify authentication before rendering pages or API routes

**Pattern:**
```typescript
import { auth } from "../../../auth";
import { defineMiddleware } from "astro:middleware";

export const onRequest = defineMiddleware(async (context, next) => {
	const session = await auth.api.getSession({
		headers: context.request.headers,
	});

	// Redirect unauthenticated users
	if (context.url.pathname === "/dashboard" && !session) {
		return context.redirect("/");
	}

	return next();
});
```

**Key Points:**
- Use `defineMiddleware` to wrap route protection logic
- Check session via `auth.api.getSession()` with request headers
- Return `context.redirect()` before `next()` to prevent page rendering
- Middleware runs for every request before page/API route execution
- Not called during SSR build time

### Rewrite vs Redirect in Middleware

**Difference:**

Rewrite with `context.rewrite()`:
```javascript
export function onRequest (context, next) {
  if (!isLoggedIn(context)) {
    // Rewrite to /login without re-executing middleware
    // Preserves original request context for subsequent middleware
    return next(new Request("/login", {
      headers: {
        "x-redirect-to": context.url.pathname
      }
    }));
  }
  return next();
};
```

Redirect with `context.redirect()`:
```javascript
export function onRequest (context, next) {
  if (!isLoggedIn(context)) {
    // Full redirect re-executes middleware chain
    return context.rewrite(new Request("/login", {
      headers: {
        "x-redirect-to": context.url.pathname
      }
    }));
  }
  return next();
};
```

**Use Cases:**
- **Rewrite**: Internal route changes, server-side only (faster)
- **Redirect**: Visible URL changes, client-side browser redirect (slower)

### Middleware with Route Matchers

```typescript
import { clerkMiddleware, createRouteMatcher } from '@clerk/astro/server';

const isProtectedRoute = createRouteMatcher([
  '/dashboard(.*)',
  '/forum(.*)',
]);

export const onRequest = clerkMiddleware((auth, context) => {
  if (!auth().userId && isProtectedRoute(context.request)) {
    return auth().redirectToSignIn();
  }
});
```

## 2. Vue 3 Session Monitoring with Lifecycle Hooks

### Basic Session Polling Pattern

**Purpose:** Periodically check if session is still valid, cleanup on unmount

```vue
<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'

const isSessionValid = ref(true)
let sessionCheckInterval: NodeJS.Timeout

onMounted(() => {
  // Check immediately
  checkSession()

  // Poll every 5 minutes
  sessionCheckInterval = setInterval(() => {
    checkSession()
  }, 5 * 60 * 1000)
})

onUnmounted(() => {
  // Critical: Cleanup to prevent memory leaks
  if (sessionCheckInterval) {
    clearInterval(sessionCheckInterval)
  }
})

async function checkSession() {
  try {
    const response = await fetch('/api/session')
    if (response.status === 401) {
      isSessionValid.value = false
      // Redirect to login
      window.location.href = '/login'
    }
  } catch (error) {
    console.error('Session check failed:', error)
  }
}
</script>

<template>
  <div v-if="isSessionValid">
    <!-- Protected content -->
  </div>
</template>
```

**Critical Points:**
- Always cleanup intervals in `onUnmounted` to prevent memory leaks
- Lifecycle hooks cannot be called asynchronously (setTimeout is OK, but not async/await at top level)
- `onMounted` is NOT called during SSR (only on client)
- `onUnmounted` is NOT called during SSR

### Error Handling in Session Checks

```vue
<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'

const sessionState = ref<'valid' | 'expired' | 'checking'>('checking')
let checkInterval: NodeJS.Timeout
let retryCount = 0
const MAX_RETRIES = 3
const RETRY_DELAY = 1000

onMounted(() => {
  checkSessionWithRetry()
  checkInterval = setInterval(checkSessionWithRetry, 5 * 60 * 1000)
})

onUnmounted(() => {
  clearInterval(checkInterval)
})

async function checkSessionWithRetry() {
  sessionState.value = 'checking'

  for (let i = 0; i < MAX_RETRIES; i++) {
    try {
      const response = await fetch('/api/session', {
        credentials: 'include', // Send cookies
      })

      // HTTP error status doesn't throw, must check Response.ok
      if (!response.ok) {
        if (response.status === 401) {
          sessionState.value = 'expired'
          handleSessionExpired()
          return
        } else {
          throw new Error(`HTTP ${response.status}`)
        }
      }

      const data = await response.json()
      sessionState.value = 'valid'
      retryCount = 0
      return

    } catch (error) {
      retryCount = i + 1
      if (i < MAX_RETRIES - 1) {
        // Wait before retry
        await new Promise(resolve => setTimeout(resolve, RETRY_DELAY))
      }
    }
  }

  // All retries failed
  sessionState.value = 'expired'
  handleSessionExpired()
}

function handleSessionExpired() {
  // Show modal, redirect, etc.
  window.location.href = '/login'
}
</script>
```

**Key Patterns:**
- Use `response.ok` to check HTTP success (200-299 range)
- HTTP errors don't throw - manually check status codes
- 401 = Authentication failed, 403 = Forbidden/Not authorized
- Include `credentials: 'include'` to send authentication cookies
- Implement retry logic for network failures
- Never retry on 401/403 (authentication errors)

## 3. Headless UI Non-Dismissible Modals

### Prevent Modal Dismissal on Escape or Backdrop Click

**Purpose:** Create critical dialogs that require explicit action (confirmation required)

```vue
<script setup lang="ts">
import { Dialog, DialogPanel, DialogTitle } from '@headlessui/vue'
import { ref } from 'vue'

const isOpen = ref(false)
const canDismiss = ref(false) // Prevent dismissal until conditions met

function handleClose() {
  // Ignore close attempts if dismissal not allowed
  if (!canDismiss.value) return
  isOpen.value = false
}

function handleConfirm() {
  canDismiss.value = true
  isOpen.value = false
}
</script>

<template>
  <Dialog :open="isOpen" @close="handleClose" class="relative z-50">
    <!-- Backdrop with pointer-events to prevent clicks when dismissal disabled -->
    <DialogPanel class="fixed inset-0 overflow-y-auto">
      <div class="flex min-h-full items-center justify-center p-4">
        <div
          class="bg-white rounded-lg shadow-xl max-w-sm w-full"
          @click.stop="() => {}"
        >
          <DialogTitle class="text-lg font-bold">
            Session Expired
          </DialogTitle>

          <p class="mt-2 text-sm text-gray-600">
            Your session has expired. Please log in again.
          </p>

          <div class="mt-4 flex gap-3 justify-end">
            <!-- Cancel button hidden or disabled when dismissal not allowed -->
            <button
              v-if="canDismiss"
              @click="isOpen = false"
              class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded"
            >
              Cancel
            </button>

            <!-- Required action button -->
            <button
              @click="handleConfirm"
              class="px-4 py-2 bg-blue-500 text-white rounded"
            >
              Login Again
            </button>
          </div>
        </div>
      </div>
    </DialogPanel>
  </Dialog>
</template>
```

### Using static Prop for Uninterruptible Modals

Headless UI Dialog supports a `static` prop to completely prevent dismissal:

```vue
<Dialog :open="isOpen" @close="handleClose" static>
  <!-- Dialog content - Escape key and backdrop clicks ignored -->
</Dialog>
```

**Behavior:**
- `static` prop prevents default dismiss behavior entirely
- Still need to manually control `isOpen` via buttons
- Best for critical confirmations or required actions
- User cannot bypass with keyboard or mouse

## 4. API Error Interceptors & Status Code Handling

### Comprehensive Fetch Error Handler

```typescript
type FetchResponse<T> =
  | { ok: true; data: T; status: number }
  | { ok: false; error: string; status: number; shouldRetry: boolean }

async function fetchWithErrorHandling<T>(
  url: string,
  options?: RequestInit
): Promise<FetchResponse<T>> {
  try {
    const response = await fetch(url, {
      credentials: 'include', // Important for auth cookies
      ...options,
    })

    // Fetch doesn't throw on HTTP errors - must check response.ok
    if (!response.ok) {
      return handleHttpError(response)
    }

    const data = await response.json() as T
    return { ok: true, data, status: response.status }

  } catch (error) {
    // Network errors, timeout, etc. - should retry
    return {
      ok: false,
      error: error instanceof Error ? error.message : 'Network error',
      status: 0,
      shouldRetry: true,
    }
  }
}

function handleHttpError(response: Response): FetchResponse<unknown> {
  switch (response.status) {
    case 401:
      // Unauthenticated - clear session, redirect to login
      clearAuthToken()
      window.location.href = '/login'
      return {
        ok: false,
        error: 'Authentication expired',
        status: 401,
        shouldRetry: false, // Don't retry auth errors
      }

    case 403:
      // Forbidden - insufficient permissions
      return {
        ok: false,
        error: 'Insufficient permissions',
        status: 403,
        shouldRetry: false,
      }

    case 404:
      // Not found
      return {
        ok: false,
        error: 'Resource not found',
        status: 404,
        shouldRetry: false,
      }

    case 429:
      // Rate limited - should retry with backoff
      return {
        ok: false,
        error: 'Rate limited',
        status: 429,
        shouldRetry: true,
      }

    case 500:
    case 502:
    case 503:
    case 504:
      // Server errors - should retry
      return {
        ok: false,
        error: `Server error (${response.status})`,
        status: response.status,
        shouldRetry: true,
      }

    default:
      return {
        ok: false,
        error: `HTTP Error ${response.status}`,
        status: response.status,
        shouldRetry: false,
      }
  }
}
```

### Using in Vue Components

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'

const data = ref<UserData | null>(null)
const error = ref<string | null>(null)
const isLoading = ref(false)

async function loadUserData() {
  isLoading.value = true
  error.value = null

  const result = await fetchWithErrorHandling<UserData>('/api/user')

  if (result.ok) {
    data.value = result.data
  } else {
    error.value = result.error

    // Handle retryable errors
    if (result.shouldRetry && result.status !== 401) {
      // Could implement retry logic here
    }
  }

  isLoading.value = false
}
</script>

<template>
  <div v-if="isLoading">Loading...</div>
  <div v-else-if="error" class="text-red-500">{{ error }}</div>
  <div v-else-if="data">
    <!-- Display data -->
  </div>
</template>
```

## 5. BroadcastChannel API for Cross-Tab Communication

### Basic Cross-Tab Session Synchronization

**Purpose:** Notify all tabs when session expires or user logs out

```typescript
class SessionManager {
  private channel: BroadcastChannel

  constructor() {
    // Create channel for session events
    this.channel = new BroadcastChannel('session-events')
    this.channel.onmessage = this.handleSessionMessage.bind(this)
  }

  notifySessionExpired() {
    // Broadcast to all other tabs
    this.channel.postMessage({
      type: 'SESSION_EXPIRED',
      timestamp: Date.now(),
    })
  }

  notifyLogout() {
    this.channel.postMessage({
      type: 'LOGOUT',
      timestamp: Date.now(),
    })
  }

  private handleSessionMessage(event: MessageEvent) {
    const { type, timestamp } = event.data

    switch (type) {
      case 'SESSION_EXPIRED':
        this.onSessionExpired()
        break
      case 'LOGOUT':
        this.onLogout()
        break
    }
  }

  private onSessionExpired() {
    console.log('Session expired in another tab')
    window.location.href = '/login'
  }

  private onLogout() {
    console.log('Logged out in another tab')
    window.location.href = '/login'
  }

  close() {
    this.channel.close()
  }
}

// Usage
const sessionManager = new SessionManager()

// When session expires in one tab
sessionManager.notifySessionExpired()
// All other tabs automatically redirect to login
```

### Vue 3 Composable for Cross-Tab Session Sync

```typescript
import { onMounted, onUnmounted, ref } from 'vue'

export function useSessionBroadcast() {
  const isSessionValid = ref(true)
  let channel: BroadcastChannel | null = null

  function initBroadcast() {
    channel = new BroadcastChannel('app-session')

    channel.onmessage = (event) => {
      const { type } = event.data

      if (type === 'SESSION_EXPIRED' || type === 'LOGOUT') {
        isSessionValid.value = false
        // Redirect or show modal
        window.location.href = '/login'
      }
    }

    channel.onmessageerror = (error) => {
      console.error('BroadcastChannel error:', error)
    }
  }

  function broadcastSessionExpired() {
    if (channel) {
      channel.postMessage({
        type: 'SESSION_EXPIRED',
        timestamp: Date.now(),
      })
    }
  }

  function broadcastLogout() {
    if (channel) {
      channel.postMessage({
        type: 'LOGOUT',
        timestamp: Date.now(),
      })
    }
  }

  onMounted(() => {
    initBroadcast()
  })

  onUnmounted(() => {
    if (channel) {
      channel.close()
    }
  })

  return {
    isSessionValid,
    broadcastSessionExpired,
    broadcastLogout,
  }
}

// Usage in component
const { isSessionValid, broadcastLogout } = useSessionBroadcast()
```

### BroadcastChannel API Details

**Constructor:**
```typescript
const channel = new BroadcastChannel('channel-name')
```
- Channel name determines which tabs can communicate
- Same origin only (protocol + domain + port must match)
- Multiple tabs with same channel name receive all messages

**Methods:**
```typescript
channel.postMessage(data) // Send to other tabs (not self)
channel.close()            // Close the channel
```

**Events:**
```typescript
channel.onmessage = (event) => {
  const data = event.data      // The sent data
  const origin = event.origin  // Sender's origin
}

channel.onmessageerror = (error) => {
  // Called when message can't be deserialized
}
```

**Important:**
- Message sender does NOT receive their own messages
- Only works between same-origin documents
- Available in all modern browsers (since March 2022)
- Works in Web Workers and Service Workers

## 6. Nanostores with Vue 3 Integration

### Auth State Store Pattern

```typescript
// stores/auth.ts
import { atom, onMount } from 'nanostores'

export interface User {
  id: string
  email: string
  name: string
}

export const $user = atom<User | null>(null)
export const $isLoading = atom(true)
export const $error = atom<string | null>(null)

// Initialize on mount (runs once when store is first accessed)
onMount($user, () => {
  checkSession()

  // Return cleanup function
  return () => {
    // Cleanup if needed
  }
})

async function checkSession() {
  try {
    $isLoading.set(true)
    const response = await fetch('/api/user', {
      credentials: 'include',
    })

    if (!response.ok) {
      if (response.status === 401) {
        $user.set(null)
        $error.set('Not authenticated')
      }
      return
    }

    const user = await response.json()
    $user.set(user)
    $error.set(null)

  } catch (error) {
    $error.set(error instanceof Error ? error.message : 'Unknown error')
  } finally {
    $isLoading.set(false)
  }
}

export async function logout() {
  try {
    await fetch('/api/logout', { method: 'POST', credentials: 'include' })
    $user.set(null)
  } catch (error) {
    $error.set(error instanceof Error ? error.message : 'Logout failed')
  }
}
```

### Vue 3 Component Integration

```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $user, $isLoading, logout } from '../stores/auth'

const user = useStore($user)
const isLoading = useStore($isLoading)

async function handleLogout() {
  await logout()
}
</script>

<template>
  <div v-if="isLoading">Loading...</div>
  <div v-else-if="!user">
    <p>Not authenticated</p>
    <a href="/login">Login</a>
  </div>
  <div v-else>
    <p>Welcome {{ user.name }}</p>
    <button @click="handleLogout">Logout</button>
  </div>
</template>
```

### Computed Stores for Derived State

```typescript
import { atom, computed } from 'nanostores'

const $user = atom<User | null>(null)

// Derived store - computed automatically updates when $user changes
export const $isAuthenticated = computed($user, user => user !== null)

export const $userDisplayName = computed($user, user =>
  user ? `${user.name} (${user.email})` : 'Guest'
)

export const $userPermissions = computed($user, user => {
  if (!user) return []
  return user.roles.flatMap(role => role.permissions)
})
```

### Multiple Stores Effect Pattern

```typescript
import { atom, effect } from 'nanostores'

const $user = atom<User | null>(null)
const $theme = atom<'light' | 'dark'>('light')

// Effect runs whenever any dependency changes
// Useful for side effects coordinating multiple stores
const cleanup = effect(
  [$user, $theme],
  ([user, theme]) => {
    // Apply theme based on user preference
    if (user?.preferredTheme) {
      $theme.set(user.preferredTheme)
    }

    // Log user activity
    if (user) {
      console.log(`User logged in: ${user.email}`)
    }

    // Return cleanup function
    return () => {
      // Called when dependencies change or effect is destroyed
    }
  }
)
```

### SSR Safety with Nanostores

```typescript
// stores/ssrAuth.ts
import { atom, onMount } from 'nanostores'

export const $sessionId = atom<string | null>(null)

onMount($sessionId, () => {
  // This only runs on client (after hydration)
  // Won't run during SSR build
  if (typeof window !== 'undefined') {
    initializeSession()
  }

  return () => {
    // Cleanup on unmount
  }
})

async function initializeSession() {
  const sessionId = localStorage.getItem('sessionId')
  $sessionId.set(sessionId)
}
```

## 7. VueUse Composables for Session Management

### useAsyncState for Session Checking

```vue
<script setup lang="ts">
import { useAsyncState } from '@vueuse/core'

interface SessionData {
  userId: string
  email: string
  expiresAt: number
}

const { state, isLoading, isReady, error, execute } = useAsyncState(
  checkSessionAPI,
  { userId: '', email: '', expiresAt: 0 },
  {
    immediate: true,  // Run on mount
    resetOnExecute: true, // Reset to initialState before executing
  }
)

async function checkSessionAPI(): Promise<SessionData> {
  const response = await fetch('/api/session', {
    credentials: 'include',
  })

  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`)
  }

  return response.json()
}

function manualRefresh() {
  execute() // Manually trigger the async function
}
</script>

<template>
  <div>
    <div v-if="isLoading">Checking session...</div>
    <div v-else-if="error" class="text-red-500">
      {{ error }}
      <button @click="manualRefresh">Retry</button>
    </div>
    <div v-else-if="isReady">
      Session valid until {{ new Date(state.expiresAt).toLocaleString() }}
    </div>
  </div>
</template>
```

### useInterval for Periodic Session Checks

```vue
<script setup lang="ts">
import { useInterval, useMounted } from '@vueuse/core'
import { ref } from 'vue'

const isMounted = useMounted() // Returns true only after client mount

// Interval setup - safely only runs on client
const { counter, pause, resume } = useInterval(5 * 60 * 1000, {
  controls: true, // Expose pause/resume
  immediate: isMounted.value, // Only start if mounted
})

async function checkSession() {
  if (!isMounted.value) return // Safety check for SSR

  try {
    const response = await fetch('/api/session', {
      credentials: 'include',
    })

    if (response.status === 401) {
      pause()
      window.location.href = '/login'
    }
  } catch (error) {
    console.error('Session check failed:', error)
  }
}

// Run on each interval tick
watch(counter, () => {
  checkSession()
})
</script>
```

### useMounted for SSR-Safe Client Code

```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core'

const isMounted = useMounted()

// Safe browser API access only after mount
const handleBrowserAPI = () => {
  if (!isMounted.value) return

  // Now safe to use:
  const sessionId = localStorage.getItem('sessionId')
  // ... use sessionId
}
</script>

<template>
  <!-- Only render browser-dependent content after mount -->
  <div v-if="isMounted">
    <button @click="handleBrowserAPI">Check Session</button>
  </div>
</template>
```

## Common Patterns Summary

### SSR Safety Rules
1. Lifecycle hooks (`onMounted`, `onUnmounted`) never run during SSR
2. Use `useMounted()` to check if component is hydrated
3. Interval checks should only initialize after mount
4. BroadcastChannel should initialize in `onMounted`
5. LocalStorage access only after mount

### Session Resilience Checklist
- [ ] Middleware protects sensitive routes
- [ ] Session checks implement retry logic
- [ ] Errors distinguish 401 (auth) vs 403 (permission)
- [ ] Intervals cleaned up on unmount
- [ ] Cross-tab logout broadcast implemented
- [ ] Non-dismissible modal for critical actions
- [ ] Nanostores provide reactive auth state
- [ ] VueUse composables handle async operations safely

## References

- **Astro Middleware:** https://docs.astro.build/en/guides/middleware/
- **Vue 3 Lifecycle:** https://vuejs.org/guide/essentials/lifecycle.html
- **Headless UI Dialog:** https://headlessui.com/
- **Nanostores:** https://github.com/nanostores/nanostores
- **VueUse:** https://vueuse.org/
- **BroadcastChannel API:** https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel
- **Fetch API:** https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
