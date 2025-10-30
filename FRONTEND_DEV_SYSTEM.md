# Frontend Development System for Claude Code
## Astro + Vue + Tailwind + TypeScript + Appwrite Stack

**Generated:** 2025-10-16
**Purpose:** Specialized agent system and workflow patterns for frontend development with this tech stack

---

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Specialized Agents](#specialized-agents)
3. [Slash Commands](#slash-commands)
4. [Common Workflows](#common-workflows)
5. [Best Practices](#best-practices)

---

## Architecture Overview

### Tech Stack Patterns

**Astro (SSR/SSG Framework)**
- Islands Architecture with selective hydration
- File-based routing in `src/pages/`
- Middleware for authentication guards
- API routes in `src/pages/api/` with `APIRoute` type
- Session management via `Astro.session`
- Cookie-based authentication with httpOnly cookies

**Vue 3 (Interactive Components)**
- Composition API with `<script setup lang="ts">`
- Nanostores for cross-component state management
- VueUse composables for common patterns
- Client-side hydration with `client:load` directive
- SSR-safe patterns using `useMounted()` hook

**TypeScript (Type Safety)**
- Strong typing with `defineProps<T>()`, `defineEmits<T>()`
- Zod schemas for runtime validation
- Shared types between frontend and API routes
- Type-safe Appwrite client initialization

**Tailwind CSS (Styling)**
- Utility-first approach with dark mode support
- Consistent spacing, typography, and color patterns
- Flexbox/Grid for layouts
- Responsive design with mobile-first approach

**Appwrite (Backend)**
- Server-side client initialization with `getSSRClient()`
- Authentication via JWT and session cookies
- Database operations through service layer abstractions
- File storage and real-time subscriptions

---

## Specialized Agents

### 1. **astro-architect**
**Purpose:** Design and implement Astro pages, layouts, and API routes with proper SSR patterns.

**When to Use:**
- Creating new pages or API routes
- Implementing server-side data fetching
- Setting up authentication guards and middleware
- Structuring Astro project layouts
- Integrating backend services on the server side

**Tools:** Read, Edit, Write, Grep, Glob, WebSearch, mcp__gemini-cli__ask-gemini, mcp__github-docs__*

**System Prompt:**
```markdown
You are an Astro architect specializing in server-side rendering and page/API design. Your expertise includes:

1. Astro page structure (layouts, props, data fetching)
2. SSR patterns and hydration strategies
3. API route implementations with proper error handling
4. Authentication and authorization patterns (middleware, cookies, sessions)
5. Server-side data fetching with Appwrite integration
6. Edge cases and performance optimization for SSR

Always reference official Astro documentation from ~/.claude/documentation/astro/ and use Gemini for large file analysis. Provide production-ready implementations with error handling and type safety.
```

**Example Usage:**
```bash
# Creating new pages
User: "Create a dashboard page with authentication and data fetching"
Claude: [Invokes astro-architect to design page structure and implement]

# API routes
User: "Build an API endpoint for handling form submissions"
Claude: [Uses astro-architect agent]
```

---

### 2. **vue-architect**
**Purpose:** Design and implement Vue 3 components following the established architecture hierarchy.

**When to Use:**
- Creating new Vue components
- Refactoring existing components to improve reusability
- Implementing UI logic and event handling
- Composing complex UIs from base components
- Ensuring components are SSR-safe

**Tools:** Read, Edit, Write, Grep, WebSearch, mcp__gemini-cli__ask-gemini, mcp__github-docs__*

**System Prompt:**
```markdown
You are a Vue 3 architect specializing in Astro integration. Your expertise includes:

1. Composition API patterns (script setup, refs, computed, watch)
2. Nanostores integration with @nanostores/vue (useStore)
3. TypeScript patterns (defineProps, defineEmits, defineModel)
4. VueUse composables for common patterns
5. SSR-safe patterns (useMounted, client-only code)
6. Component composition, slots, and reusability
7. Props and emits typing for type safety

Always ensure components are SSR-compatible, TypeScript-safe, and reusable. Analyze existing patterns in the codebase before creating new components. Use slots and props to maximize flexibility and prevent duplication.
```

**Example Usage:**
```bash
# Creating new components
User: "Create a form input component with validation"
Claude: [Invokes vue-architect to design and implement]

# Refactoring
User: "Refactor prop drilling in this component hierarchy"
Claude: [Uses vue-architect agent]
```

---

### 3. **vue-testing-specialist**
**Purpose:** Write, run, and maintain tests for Vue components and composables using any testing framework.

**When to Use:**
- Writing tests for new components
- Adding tests for existing components
- Debugging test failures
- Implementing test-driven development (TDD)
- Testing composables and utilities
- Setting up test fixtures and mocks

**Tools:** Read, Edit, Write, Bash, Grep, mcp__gemini-cli__ask-gemini

**System Prompt:**
```markdown
You are a Vue testing specialist. Your expertise includes:

1. Writing tests with Vitest, Jest, or any Vue-compatible test framework
2. Component testing with @testing-library/vue and @vue/test-utils
3. Composable testing (testing reactive logic independently)
4. Mocking and stubbing Vue components, stores, and API calls
5. Test fixtures, factories, and reusable test utilities
6. SSR-safe test setup (handling browser APIs in tests)
7. Test-driven development (TDD) workflows
8. Debugging failing tests and improving test coverage

Always write tests that are independent, repeatable, and fast. Prioritize testing behavior over implementation details. Use descriptive test names and organize tests logically. Support TDD: write failing tests first, then implementation.
```

**Example Usage:**
```bash
# Test-driven component development
User: "Create tests for a form validation component"
Claude: [Invokes vue-testing-specialist to write failing tests first]

# Debugging test failures
User: "These component tests are failing in SSR mode"
Claude: [Uses vue-testing-specialist to fix SSR-specific test issues]
```

---

### 4. **tailwind-styling-expert**
**Purpose:** Research Tailwind patterns, responsive design, and dark mode implementations

**When to Use:**
- Implementing responsive layouts
- Adding dark mode support
- Researching Tailwind utility patterns
- Creating consistent design systems
- Debugging CSS issues

**Tools:** Read, Edit, WebSearch, mcp__tailwind__*, mcp__github-docs__*

**System Prompt:**
```markdown
You are a Tailwind CSS expert specializing in utility-first design. Your focus areas:

1. Responsive design with mobile-first approach
2. Dark mode implementation (dark: variants)
3. Flexbox and Grid layouts
4. Consistent spacing, typography, and color systems
5. Performance optimization (avoiding unused classes)
6. Accessibility considerations

Use mcp__tailwind__* tools for utility references. Reference ~/.claude/documentation/ui/tailwindcss.md for project-specific patterns. Always ensure responsive and accessible designs.
```

**Example Usage:**
```bash
# Styling new components
User: "Style this form with proper spacing and dark mode support"
Claude: [Invokes tailwind-styling-expert]

# Responsive fixes
User: "This layout breaks on mobile, fix it"
Claude: [Uses tailwind-styling-expert agent]
```

---

### 4. **appwrite-integration-specialist**
**Purpose:** Research and implement Appwrite client patterns, authentication, and database operations

**When to Use:**
- Setting up Appwrite client (SSR vs client-side)
- Implementing authentication flows
- Database CRUD operations
- File storage operations
- Real-time subscriptions

**Tools:** Read, Edit, Grep, WebSearch, WebFetch, mcp__gemini-cli__ask-gemini

**System Prompt:**
```markdown
You are an Appwrite integration specialist. Your expertise includes:

1. SSR-safe Appwrite client initialization (getSSRClient pattern)
2. Authentication flows (JWT, sessions, OAuth)
3. Database operations with proper error handling
4. File storage and bucket management
5. Real-time subscriptions and webhooks
6. Service layer abstraction patterns

Reference ~/.claude/documentation/appwrite/ and analyze existing patterns in src/stores/appwrite.ts. Use Gemini to analyze large API implementations in functions/.
```

**Example Usage:**
```bash
# Authentication issues
User: "User session is not persisting across page reloads"
Claude: [Invokes appwrite-integration-specialist to research session management]

# Database operations
User: "Implement pagination for this database query"
Claude: [Uses appwrite-integration-specialist agent]
```

---

### 5. **typescript-validator**
**Purpose:** Review and fix TypeScript errors, improve type safety, and implement Zod schemas

**When to Use:**
- Fixing TypeScript compilation errors
- Adding type safety to existing code
- Creating Zod validation schemas
- Type inference improvements
- Refactoring for better types

**Tools:** Read, Edit, Bash, Grep, WebSearch

**System Prompt:**
```markdown
You are a TypeScript expert focused on type safety and runtime validation. Your responsibilities:

1. Fix TypeScript compilation errors (use npm run typecheck)
2. Improve type inference and eliminate 'any' types
3. Create Zod schemas for runtime validation
4. Ensure type safety across component boundaries
5. Optimize TypeScript configuration for performance

Always run type checking after changes. Reference Zod documentation from ~/.claude/documentation/zod/. Prefer strong typing over type assertions.
```

**Example Usage:**
```bash
# Type errors
User: "Fix all TypeScript errors in this component"
Claude: [Invokes typescript-validator]

# Schema validation
User: "Add runtime validation for this API endpoint"
Claude: [Uses typescript-validator agent]
```

---

### 6. **ssr-debugger**
**Purpose:** Debug SSR-specific issues like hydration mismatches, client-server state sync, and performance

**When to Use:**
- Hydration mismatch errors
- Client-server state synchronization issues
- SSR performance problems
- Browser-only API usage in SSR context
- Cookie/session debugging

**Tools:** Read, Grep, Bash, WebSearch, mcp__gemini-cli__ask-gemini

**System Prompt:**
```markdown
You are an SSR debugging specialist. Your focus is identifying and fixing server-side rendering issues:

1. Hydration mismatch errors (DOM structure differences)
2. Client-server state synchronization
3. Browser API usage in SSR context (window, document, localStorage)
4. Cookie and session debugging
5. Performance bottlenecks in SSR
6. Memory leaks in server context

Use Gemini to analyze large page implementations. Always verify fixes work in both SSR and client-side contexts. Reference Astro SSR docs from ~/.claude/documentation/astro/.
```

**Example Usage:**
```bash
# Hydration errors
User: "Getting hydration mismatch warnings in console"
Claude: [Invokes ssr-debugger to analyze and fix]

# State sync issues
User: "Store state differs between server and client render"
Claude: [Uses ssr-debugger agent]
```

---

### 7. **nanostore-state-architect**
**Purpose:** Design and implement Nanostores for state management across Astro and Vue

**When to Use:**
- Creating new global stores
- Refactoring prop drilling to stores
- Implementing persistent state
- Cross-framework state sharing
- State synchronization patterns

**Tools:** Read, Edit, Write, Grep, WebSearch

**System Prompt:**
```markdown
You are a Nanostores expert specializing in Astro + Vue integration. Your expertise:

1. Atom stores for simple state
2. Map stores for complex objects
3. Computed stores for derived state
4. Persistent stores (localStorage integration)
5. Vue integration with @nanostores/vue (useStore)
6. SSR-safe store initialization patterns

Reference ~/.claude/documentation/nano/ for patterns. Always ensure stores are SSR-compatible and properly typed with TypeScript. Use .get() in event handlers, useStore() for reactive rendering.
```

**Example Usage:**
```bash
# State management
User: "Create a global store for user preferences"
Claude: [Invokes nanostore-state-architect]

# Refactoring
User: "This component has too many props, use stores instead"
Claude: [Uses nanostore-state-architect agent]
```

---

### 8. **code-scout** (formerly code-reuser-scout)
**Purpose:** Expert code discovery and mapping specialist - finds relevant files, reusable code, duplications, and patterns

**When to Use:**
- Phase 1 of all frontend commands (always runs first)
- Before creating any new component, composable, or utility
- When mapping existing features for debugging or enhancement
- To identify reusable code, duplications, and patterns
- For project context gathering (tech stack, structure, conventions)

**Tools:** Bash, Read, Grep, Glob, LS, mcp__gemini-cli__ask-gemini

**System Prompt:**
```markdown
You are a code discovery and mapping expert. Your mission is to analyze codebases to find, map, and document code patterns - NOT to identify bugs. Focus on:

1. **Components Search:** Look in src/components/vue/ for similar UI patterns
   - Search by functionality (modals, dropdowns, cards, forms, buttons)
   - Identify components that could be extended with props/slots
   - Find base components that abstract common patterns

2. **Composables Search:** Look in src/composables/ and check VueUse
   - Search for logic patterns (data fetching, form handling, auth)
   - Identify composables that could be extended
   - Always check VueUse first via documentation-researcher agent

3. **Stores Search:** Look in src/stores/ for state management
   - Find stores managing similar data
   - Identify stores that could have actions added
   - Check for related state that could be consolidated

4. **Utilities Search:** Look in src/utils/ for helper functions
   - Search for data transformation, validation, formatting logic
   - Find utilities that could be parameterized for reuse

5. **Types Search:** Look in src/types/ for TypeScript definitions
   - Find existing interfaces/types that match requirements
   - Identify types that could be extended or composed

**Search Strategy:**
- Use Gemini for large directory scans: `@src/components/vue/**/*.vue search for modal patterns`
- Use Grep for specific patterns: search for function names, component names
- Read base/common components first (BaseModal, BaseCard, etc.)
- Check composables directory AND VueUse documentation
- Report near-matches: "Component X does 80% of what you need, just add prop Y"

**Response Format:**
Report findings as:
1. **Exact Matches:** Files that do exactly what's needed
2. **Near Matches:** Files that need minor modifications (list what needs adding)
3. **Base Components:** Abstract components that could be composed
4. **VueUse Alternatives:** Existing composables that solve the problem
5. **No Match:** If nothing exists, confirm it's safe to create new code

Always prefer reusing/extending existing code over creating new implementations.
```

**Example Usage:**
```bash
# Before creating a component
User: "Create a dropdown select component"
Claude: [Invokes code-reuser-scout]
Scout: "Found SearchableDropdown.vue which already has dropdown logic with search.
       Could extend with props for your use case instead of creating new."

# Before creating a composable
User: "Create a composable for debouncing search input"
Claude: [Invokes code-reuser-scout]
Scout: "VueUse has useDebounce that does exactly this. Also found existing
       useDebounce import in 3 components already using it."

# Before adding utility
User: "Create a function to format dates"
Claude: [Invokes code-reuser-scout]
Scout: "Found src/utils/dateFormatter.ts with formatDate(), formatRelative(),
       formatTimeAgo(). Use these instead."
```

---

## Slash Commands

### `/frontend-research [topic]`
Research frontend patterns, best practices, or documentation

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/frontend-research.sh

TOPIC="$1"

echo "Researching frontend topic: $TOPIC"
echo "Analyzing codebase patterns and documentation..."

# Auto-delegate to appropriate specialist agent
```

**Usage Examples:**
```bash
/frontend-research "SSR authentication patterns"
/frontend-research "Vue composable for file uploads"
/frontend-research "Tailwind dark mode implementation"
```

---

### `/component [create|refactor|debug] [component-name]`
Create, refactor, or debug Vue components

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/component.sh

ACTION="$1"
COMPONENT_NAME="$2"

case "$ACTION" in
  create)
    echo "Creating Vue component: $COMPONENT_NAME"
    echo "Will invoke vue-architect agent"
    ;;
  refactor)
    echo "Refactoring component: $COMPONENT_NAME"
    echo "Will analyze existing patterns with Gemini, then refactor"
    ;;
  debug)
    echo "Debugging component: $COMPONENT_NAME"
    echo "Will analyze with ssr-debugger if SSR-related"
    ;;
esac
```

**Usage Examples:**
```bash
/component create UserProfileCard
/component refactor src/components/vue/modals/LoginModal.vue
/component debug src/components/vue/guards/BillingGuard.vue
```

---

### `/page [create|debug] [page-path]`
Create or debug Astro pages with SSR patterns

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/page.sh

ACTION="$1"
PAGE_PATH="$2"

case "$ACTION" in
  create)
    echo "Creating Astro page: $PAGE_PATH"
    echo "Will invoke astro-architect for patterns"
    ;;
  debug)
    echo "Debugging Astro page: $PAGE_PATH"
    echo "Will invoke ssr-debugger agent"
    ;;
esac
```

**Usage Examples:**
```bash
/page create src/pages/dashboard/settings/profile.astro
/page debug src/pages/dashboard/posts/create.astro
```

---

### `/api [create|debug] [route-path]`
Create or debug Astro API routes

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/api.sh

ACTION="$1"
ROUTE_PATH="$2"

case "$ACTION" in
  create)
    echo "Creating API route: $ROUTE_PATH"
    echo "Will research patterns and implement with proper error handling"
    ;;
  debug)
    echo "Debugging API route: $ROUTE_PATH"
    echo "Will analyze authentication, validation, and error handling"
    ;;
esac
```

**Usage Examples:**
```bash
/api create src/pages/api/posts/[id].ts
/api debug src/pages/api/auth/verify.json.ts
```

---

### `/store [create|refactor] [store-name]`
Create or refactor Nanostores

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/store.sh

ACTION="$1"
STORE_NAME="$2"

case "$ACTION" in
  create)
    echo "Creating Nanostore: $STORE_NAME"
    echo "Will invoke nanostore-state-architect agent"
    ;;
  refactor)
    echo "Refactoring store: $STORE_NAME"
    echo "Will analyze usage patterns and improve implementation"
    ;;
esac
```

**Usage Examples:**
```bash
/store create userSettingsStore
/store refactor src/stores/authStore.ts
```

---

### `/style [component-path]`
Add or improve Tailwind styling with dark mode and responsive design

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/style.sh

COMPONENT_PATH="$1"

echo "Styling component: $COMPONENT_PATH"
echo "Will invoke tailwind-styling-expert agent"
echo "Focus: Responsive design, dark mode, accessibility"
```

**Usage Examples:**
```bash
/style src/components/vue/cards/DashboardCard.vue
/style src/pages/dashboard/settings/index.astro
```

---

### `/fix-types [file-path]`
Fix TypeScript errors and improve type safety

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/fix-types.sh

FILE_PATH="$1"

echo "Fixing TypeScript errors in: $FILE_PATH"
echo "Will invoke typescript-validator agent"
echo "Running type check first..."

npm run typecheck 2>&1 | grep -A 5 "$FILE_PATH"
```

**Usage Examples:**
```bash
/fix-types src/pages/api/auth/connect.json.ts
/fix-types src/components/vue/modals/LoginWithModal.vue
```

---

### `/ssr-debug [issue-description]`
Debug SSR-specific issues like hydration mismatches

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/ssr-debug.sh

ISSUE="$*"

echo "Debugging SSR issue: $ISSUE"
echo "Will invoke ssr-debugger agent"
echo "Analyzing server-side and client-side rendering..."
```

**Usage Examples:**
```bash
/ssr-debug "hydration mismatch in dashboard layout"
/ssr-debug "store state not syncing between server and client"
```

---

### `/appwrite [setup|auth|database|storage]`
Research and implement Appwrite integration patterns

**Implementation:**
```bash
#!/bin/bash
# .claude/commands/appwrite.sh

TOPIC="$1"

echo "Appwrite integration: $TOPIC"
echo "Will invoke appwrite-integration-specialist agent"

case "$TOPIC" in
  setup)
    echo "Focus: Client initialization (SSR vs client-side)"
    ;;
  auth)
    echo "Focus: Authentication flows, session management"
    ;;
  database)
    echo "Focus: CRUD operations, queries, pagination"
    ;;
  storage)
    echo "Focus: File uploads, buckets, permissions"
    ;;
esac
```

**Usage Examples:**
```bash
/appwrite setup
/appwrite auth
/appwrite database
/appwrite storage
```

---

## Common Workflows

### Workflow 1: Create New Feature Page

**Goal:** Create a new dashboard page with authentication, data fetching, and interactive Vue components

**Steps:**
1. **Research** - Use `/frontend-research "Astro SSR auth patterns"` to understand authentication
2. **Create Page** - Use `/page create src/pages/dashboard/new-feature.astro`
   - Agent: `astro-architect` implements the page layout, auth check, and server-side data fetching.
3. **Create Components** - Use `/component create FeatureWidget`
   - Agent: `vue-architect` creates Vue components to display the data.
   - Implements: TypeScript props, consuming Nanostores, using VueUse composables.
4. **Style** - Use `/style src/components/vue/FeatureWidget.vue`
   - Agent: `tailwind-styling-expert` adds responsive styling with dark mode
5. **Validate** - Use `/fix-types src/pages/dashboard/new-feature.astro`
   - Agent: `typescript-validator` ensures type safety

**Agent Orchestration:**
```
astro-architect → vue-architect → tailwind-styling-expert → typescript-validator
```

---

### Workflow 2: Debug SSR Hydration Issues

**Goal:** Fix hydration mismatch warnings and client-server state sync

**Steps:**
1. **Identify Issue** - Use `/ssr-debug "hydration mismatch in component X"`
   - Agent: `ssr-debugger` analyzes server vs client rendering
2. **Fix Component** - Agent identifies browser API usage in SSR context
   - Implements: `useMounted()` pattern from VueUse
   - Ensures: Client-only code wrapped properly
3. **Fix State** - Use `/store refactor problematicStore`
   - Agent: `nanostore-state-architect` fixes state initialization
   - Implements: SSR-safe store initialization
4. **Validate** - Build and test in production mode
   - Verify: No hydration warnings, state syncs correctly

**Agent Orchestration:**
```
ssr-debugger → nanostore-state-architect (if state-related) → validation
```

---

### Workflow 3: Create API Endpoint with Validation

**Goal:** Create new API route with authentication, Zod validation, and Appwrite integration

**Steps:**
1. **Research Patterns** - Use `/api create src/pages/api/resources/[id].ts`
   - Agent: `astro-architect` designs and implements the API route structure.
2. **Implement Auth** - Use `/appwrite auth`
   - Agent: `appwrite-integration-specialist` implements authentication
   - Pattern: Cookie-based session or JWT header
3. **Add Validation** - Use `/fix-types src/pages/api/resources/[id].ts`
   - Agent: `typescript-validator` creates Zod schemas
   - Implements: Request body validation, error handling
4. **Test** - Use `vue-testing-specialist` to write integration tests
   - Tests: API endpoints, request validation, response handling

**Agent Orchestration:**
```
astro-architect → appwrite-integration-specialist → typescript-validator → vue-testing-specialist
```

---

### Workflow 4: Refactor Component to Use Nanostores

**Goal:** Remove prop drilling by moving state to Nanostores

**Steps:**
1. **Analyze Current** - Use Gemini to analyze component tree
   - Command: `mcp__gemini-cli__ask-gemini "@src/components/vue/... analyze prop drilling"`
2. **Create Store** - Use `/store create featureStore`
   - Agent: `nanostore-state-architect` designs store structure
   - Implements: Atom/Map stores with TypeScript types
3. **Refactor Components** - Use `/component refactor ComponentA`
   - Agent: `vue-architect` removes props and adds store usage.
   - Pattern: `const state = useStore(featureStore)` for reactive rendering
4. **Test Changes** - Use `vue-testing-specialist` to update component tests
   - Tests: Store integration, reactive updates, component behavior
5. **Validate** - Ensure SSR compatibility
   - Agent: `ssr-debugger` checks for hydration issues
   - Test: Server and client render consistently

**Agent Orchestration:**
```
code-reuser-scout → nanostore-state-architect → vue-architect → vue-testing-specialist → ssr-debugger
```

---

### Workflow 5: Add Dark Mode to Components

**Goal:** Implement dark mode support with Tailwind CSS

**Steps:**
1. **Research Patterns** - Use `/frontend-research "Tailwind dark mode patterns"`
   - Agent: `tailwind-styling-expert` researches best practices
2. **Update Components** - Use `/style src/components/vue/cards/*.vue`
   - Agent applies `dark:` variants to all utilities
   - Pattern: `bg-white dark:bg-gray-800`, `text-gray-900 dark:text-white`
3. **Create Toggle** - Use `/component create DarkModeToggle`
   - Agent: `vue-architect` creates toggle component
   - Store: Uses Nanostore for persistent dark mode preference
4. **Test** - Use `vue-testing-specialist` to test dark mode functionality
   - Tests: Toggle functionality, persistence, CSS application
5. **Verify** - Test across all components
   - Check: All components have dark variants, no visual regressions

**Agent Orchestration:**
```
tailwind-styling-expert → vue-architect → nanostore-state-architect → vue-testing-specialist
```

---

### Workflow 6: Enhance Existing Feature

**Goal:** Add functionality to an existing feature without duplicating code

**Steps:**
1. **Scout for Reusable Code** - Invoke `code-reuser-scout` agent
   - Search for existing components, composables, stores that could be reused
   - Command: Describe what you want to add
   - Agent reports: Exact matches, near matches, base components to extend

2. **Research VueUse Composables** - Use `documentation-researcher` agent
   - Query: "How to implement [specific functionality] with VueUse?"
   - Example: "How to implement drag and drop with VueUse?"
   - Agent searches ~/.claude/documentation/vue/vueuse/ for relevant composables

3. **Conditional Web Research** - If needed, use `web-researcher` agent
   - Only invoke if: Latest 2025 patterns not in local docs
   - Focus: Specific technical questions or new framework features
   - Example: "Research Vue 3.5 new reactivity features for [use case]"

4. **Extend Existing Code** - Prioritize modification over creation
   - **If Exact Match Found:** Use existing component/composable as-is
   - **If Near Match Found:** Extend with additional props/slots/logic
   - **If Base Component Found:** Compose new component from base
   - **If No Match:** Create new but follow established patterns

5. **Follow Architecture Hierarchy**
   - **Level 1 - VueUse Composables:** Check if VueUse solves it (via `documentation-researcher`)
   - **Level 2 - Custom Composables:** Create in src/composables/ for reusable logic
   - **Level 3 - Stores:** Use Nanostores for cross-component state
   - **Level 4 - Components:** Build UI with proper slots for flexibility

6. **Validate Integration** - Ensure new code fits existing patterns
   - Type safety: Use TypeScript throughout
   - SSR compatibility: Use useMounted() for client-only code
   - Reactivity: Proper ref/computed usage
   - Testing: Verify feature works with existing code

**Example Scenario: Adding "Sort by Date" to Posts List**

```bash
# Step 1: Scout for existing code
Claude: [Invokes code-reuser-scout]
Scout: "Found existing sort composable in src/composables/useSort.ts
        Currently sorts by title and author. Can extend with date sort.
        Also found FilterSortBar component with dropdown - can add date option."

# Step 2: Check VueUse for helpers
Claude: [Invokes documentation-researcher with query: "VueUse composable for sorting arrays"]
documentation-researcher: "Found useSorted from @vueuse/core - reactive array sorting.
            Documentation shows it handles reactive sort keys and orders."

# Step 3: No web research needed - local patterns sufficient

# Step 4: Extend existing code
# - Extend useSort.ts to add 'date' as sortKey option
# - Add date option to FilterSortBar dropdown
# - Use existing useSorted from VueUse internally

# Step 5: Follow hierarchy (already using composable pattern ✓)

# Step 6: Validate
# - Types: sortKey type union extended with 'date'
# - SSR: No client-only code needed
# - Reactivity: useSorted handles reactive updates
# - Testing: Verify sort works with date field
```

**Agent Orchestration:**
```
code-reuser-scout → documentation-researcher (VueUse) → [conditional: web-researcher] →
vue-architect (if extending components) →
nanostore-state-architect (if state needed) →
vue-testing-specialist (if adding tests) →
typescript-validator (ensure types)
```

---

### Workflow 7: Debug Existing Feature

**Goal:** Fix bugs or issues in existing features without breaking related functionality

**Steps:**
1. **Understand the Feature** - Use `code-reuser-scout` to map related code
   - Find all components, stores, composables involved
   - Use Gemini to analyze large file sets
   - Command: "Analyze feature X - find all related files"
   - Scout reports: Component tree, state flow, dependencies

2. **Identify Issue Category**
   - **SSR Issue?** → Invoke `ssr-debugger` agent
   - **Type Error?** → Invoke `typescript-validator` agent
   - **State Sync Issue?** → Invoke `nanostore-state-architect` agent
   - **Appwrite Error?** → Invoke `appwrite-integration-specialist` agent
   - **Style Issue?** → Invoke `tailwind-styling-expert` agent
   - **Logic Bug?** → Invoke `vue-architect` agent
   - **Test Failure?** → Invoke `vue-testing-specialist` agent

3. **Research Similar Fixes** - Use `documentation-researcher` for specific questions
   - Query VueUse docs for alternative approaches
   - Example: "How does VueUse handle [specific edge case]?"
   - Check if similar bugs were solved in other components

4. **Conditional Deep Research** - Use `web-researcher` only if needed
   - Invoke for: Known framework bugs, recent breaking changes
   - Example: "Research Astro SSR hydration bug in version X"
   - Focus: Specific error messages or stack traces

5. **Implement Fix with Minimal Changes**
   - Follow principle: Change least amount of code possible
   - Prefer: Fixing logic over restructuring architecture
   - Validate: Test fix doesn't break related features

6. **Verify Reactivity & SSR**
   - Ensure reactive refs/computed still update correctly
   - Test SSR hydration still works
   - Check client-only code still has useMounted() guards

**Example Scenario: Posts Not Updating After Edit**

```bash
# Step 1: Map the feature
Claude: [Invokes code-reuser-scout]
Scout: "Post editing involves:
        - EditPostModal.vue (component)
        - postContainerStore.ts (state)
        - usePostEdit composable (logic)
        - API: /api/posts/[id].ts (backend)
        Related: PostCard.vue, PostsList.vue display the posts"

# Step 2: Identify category
User describes: "Posts update in database but UI doesn't refresh"
Claude: State sync issue → Invoke nanostore-state-architect

# Step 3: Research via documentation-researcher
Claude: [Invokes documentation-researcher]
Query: "How to trigger reactive updates in Nanostores after async operations?"
documentation-researcher: "Use store.set() or store.setKey() after API success.
            Ensure components use useStore() not .get() for reactivity."

# Step 4: Check for known issues
Claude: [Invokes web-researcher conditionally]
Query: "Nanostores not updating Vue components Astro SSR"
Finds: Common issue - need to await store update

# Step 5: Implement minimal fix
# Found issue: usePostEdit was updating store before API confirmed success
# Fix: Move store.setKey() to after await postApi.update() succeeds

# Step 6: Verify
# - Reactive updates work: ✓ (useStore in components)
# - SSR compatible: ✓ (no browser APIs used)
# - Related features work: ✓ (PostCard, PostsList update correctly)
```

**Agent Orchestration:**
```
code-reuser-scout (map feature) →
[Issue-specific agent: ssr-debugger | typescript-validator | nanostore-state-architect] →
documentation-researcher (research solutions) →
[conditional: web-researcher for deep issues] →
[Implementing agent based on fix type] →
vue-testing-specialist (add/fix tests) →
ssr-debugger (verify SSR still works)
```

**Debug Decision Tree:**
```
Hydration mismatch? → ssr-debugger
Type errors? → typescript-validator
State not updating? → nanostore-state-architect
API/Auth errors? → appwrite-integration-specialist
Styling broken? → tailwind-styling-expert
Component logic bug? → vue-architect
Test failure? → vue-testing-specialist
Unknown category? → code-reuser-scout (analyze first)
```

---

### Workflow 8: Test-Driven Component Development

**Goal:** Create a new, fully tested Vue component using test-driven development (TDD)

**Steps:**

1. **Scout for Reusable Code** - Invoke `code-reuser-scout`
   - Ensure the component doesn't already exist
   - Check if similar components could be extended
   - Look for base components to compose from

2. **Write Failing Tests** - Use `vue-testing-specialist`
   - Agent creates test file (e.g., `MyComponent.test.ts`)
   - Tests cover: Primary functionality, props, emits, slots, edge cases
   - Tests should fail because component doesn't exist yet
   - Example: Testing form validation, conditional rendering, event emissions

3. **Implement Component** - Use `vue-architect`
   - Agent creates `MyComponent.vue`
   - Implements minimal code to make tests pass
   - Ensures TypeScript typing, SSR compatibility
   - Follows established component patterns

4. **Run Tests** - Use `vue-testing-specialist`
   - Run test suite: `npm run test`
   - Verify all tests now pass
   - Check test coverage

5. **Refactor & Add More Tests** - Iterate
   - Add tests for additional edge cases
   - Add tests for integration with other components/stores
   - Refactor component code while maintaining passing tests
   - Ensure no regressions

6. **Type Validation** - Use `typescript-validator`
   - Run type check: `npm run typecheck`
   - Fix any type errors
   - Ensure props and emits are properly typed

**Agent Orchestration:**
```
code-reuser-scout → vue-testing-specialist (write tests) → vue-architect (implement) →
vue-testing-specialist (verify tests pass) → typescript-validator (type check)
```

**Example: Building a UserCard Component with TDD**

```bash
# Step 1: Scout for existing components
Claude: [Invokes code-reuser-scout]
Scout: "No existing UserCard component found.
        Found BaseCard.vue that could be composed.
        UserAvatar.vue exists and can be reused."

# Step 2: Write failing tests
Claude: [Invokes vue-testing-specialist]
vue-testing-specialist: "Created UserCard.test.ts with tests for:
        - Renders user name and avatar
        - Emits 'click' event
        - Accepts 'user' prop
        - Shows role badge when provided
        - Tests fail: UserCard component not found"

# Step 3: Implement component
Claude: [Invokes vue-architect]
vue-architect: "Created UserCard.vue:
        - Accepts 'user' prop (typed)
        - Emits 'click' event
        - Composes BaseCard + UserAvatar
        - Shows role badge conditionally"

# Step 4: Run tests
vue-testing-specialist: "All tests passing ✓
        Coverage: 95% statements"

# Step 5: Add integration tests
# - Test with stores
# - Test with parent components
# - Test async operations

# Step 6: Type validation
typescript-validator: "No type errors found ✓"
```

---

## Best Practices

### Agent Usage Guidelines

**1. Let Claude Auto-Delegate**
- Claude will automatically invoke specialist agents when appropriate
- Trust the automatic delegation for most tasks
- Manual invocation via comments is optional: `// Use vue-architect`

**2. Use Gemini for Large File Analysis**
- Always use Gemini for analyzing multiple components: `@src/components/vue/**/*.vue`
- Let Gemini analyze patterns before implementing changes
- Use Gemini for directory-wide research

**3. Sequential vs Parallel Agents**
- **Sequential:** Research → Implement → Validate (most common)
- **Parallel:** Style + Type-checking (independent tasks)
- Agents have separate context windows - use this advantage

**4. Documentation-First Research**
- All agents should reference `~/.claude/documentation/` first
- Web search only for latest 2025 patterns not in docs
- Use `mcp__github-docs__*` for framework-specific examples

---

### TypeScript & Type Safety

**1. Strong Typing Required**
```typescript
// ✅ Good - Strong typing
defineProps<{ userId: string; onSuccess: (data: User) => void }>();

// ❌ Bad - Weak typing
defineProps<{ userId: any; onSuccess: Function }>();
```

**2. Zod for Runtime Validation**
```typescript
// API route validation
const RequestSchema = z.object({
  title: z.string().min(1),
  content: z.string(),
  tags: z.array(z.string()).optional(),
});

export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();
  const validated = RequestSchema.parse(body); // Throws if invalid
  // ...
};
```

**3. Type Inference from Schemas**
```typescript
// Infer TypeScript types from Zod schemas
type Request = z.infer<typeof RequestSchema>;
```

---

### SSR Patterns

**1. SSR-Safe Component Pattern**
```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core';
import { ref } from 'vue';

const isMounted = useMounted();
const data = ref<Data | null>(null);

// Only run on client side
watch(isMounted, async (mounted) => {
  if (mounted) {
    data.value = await fetchData();
  }
});
</script>

<template>
  <div v-if="isMounted">
    <!-- Client-only content -->
  </div>
</template>
```

**2. Appwrite Client Initialization**
```typescript
// Server-side (Astro page/API route)
const client = getSSRClient(cookies, undefined, true, false);

// Client-side (Vue component)
const client = getClientSideSessionClient();
```

**3. Session Management**
```typescript
// Astro middleware (auto-guards routes)
export async function onRequest({ cookies, redirect, url }, next) {
  const session = cookies.get(SESSION_COOKIE_NAME);
  if (!session && url.pathname.startsWith('/dashboard')) {
    return redirect('/login');
  }
  return next();
}
```

---

### Nanostores Patterns

**1. Basic Atom Store**
```typescript
// stores/themeStore.ts
import { atom } from 'nanostores';

export const darkMode = atom<boolean>(false);

// Usage in Vue
import { useStore } from '@nanostores/vue';
import { darkMode } from '@/stores/themeStore';

const isDark = useStore(darkMode);
```

**2. Map Store with Actions**
```typescript
// stores/userStore.ts
import { map } from 'nanostores';
import type { User } from '@/types';

export const userStore = map<{ user: User | null; loading: boolean }>({
  user: null,
  loading: false,
});

export function setUser(user: User) {
  userStore.setKey('user', user);
}

export function clearUser() {
  userStore.set({ user: null, loading: false });
}
```

**3. Computed Store**
```typescript
// Derived state
import { computed } from 'nanostores';
import { userStore } from './userStore';

export const isAuthenticated = computed(userStore, (state) => state.user !== null);
```

**4. Persistent Store**
```typescript
import { persistentAtom } from '@nanostores/persistent';

export const userPreferences = persistentAtom<Preferences>(
  'user_preferences',
  defaultPreferences,
  {
    encode: JSON.stringify,
    decode: JSON.parse,
  }
);
```

---

### Tailwind Patterns

**1. Responsive + Dark Mode**
```vue
<template>
  <div class="
    p-4 md:p-6 lg:p-8
    bg-white dark:bg-gray-800
    text-gray-900 dark:text-white
    border border-gray-200 dark:border-gray-700
  ">
    <!-- Content -->
  </div>
</template>
```

**2. Common Layout Patterns**
```vue
<!-- Flexbox center -->
<div class="flex items-center justify-center min-h-screen">

<!-- Grid layout -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

<!-- Sticky header -->
<header class="sticky top-0 z-50 bg-white dark:bg-gray-900">
```

**3. Consistent Design System**
```vue
<!-- Spacing scale: 0, 1, 2, 4, 6, 8, 12, 16, 24, 32 -->
<div class="space-y-6">
  <section class="p-6">
    <!-- Content -->
  </section>
</div>

<!-- Typography scale -->
<h1 class="text-4xl font-bold">Heading</h1>
<h2 class="text-2xl font-semibold">Subheading</h2>
<p class="text-base">Body text</p>
<span class="text-sm text-gray-600 dark:text-gray-400">Caption</span>
```

---

### Vue Component Architecture

**Architecture Hierarchy: Composables → Stores → Components**

This hierarchy defines where logic should live for maximum reusability and maintainability.

#### Level 1: VueUse Composables (Check First)
**Always check VueUse BEFORE creating custom composables**

Use `documentation-researcher` agent to search VueUse documentation:
```bash
# Example queries
"VueUse composable for debouncing input"
"VueUse composable for local storage persistence"
"VueUse composable for window resize handling"
"VueUse composable for drag and drop"
```

**Common VueUse Composables:**
- State: `useStorage`, `useSessionStorage`, `useLocalStorage`
- Browser: `useMounted`, `useWindowSize`, `useMediaQuery`, `useDark`
- Elements: `useElementSize`, `useIntersectionObserver`, `useResizeObserver`
- Sensors: `useMouse`, `useScroll`, `usePointer`, `useSwipe`
- Utilities: `useDebounce`, `useThrottle`, `useInterval`, `useTimeout`
- Network: `useFetch`, `useWebSocket`
- Animation: `useTransition`, `useSpring`

**Example: Check VueUse First**
```vue
<script setup lang="ts">
// ✅ Good - Use VueUse
import { useLocalStorage, useDark, useWindowSize } from '@vueuse/core';

const theme = useLocalStorage('theme', 'light');
const isDark = useDark();
const { width, height } = useWindowSize();

// ❌ Bad - Reimplementing VueUse functionality
const theme = ref(localStorage.getItem('theme') || 'light');
watch(theme, (val) => localStorage.setItem('theme', val));
</script>
```

#### Level 2: Custom Composables (Reusable Logic)
**Create in `src/composables/` for app-specific reusable logic**

**When to create custom composables:**
- Logic used by multiple components
- Complex stateful behavior
- Appwrite API calls
- Form handling
- Data transformation

**Composable Pattern:**
```typescript
// composables/usePostEdit.ts
import { ref, computed } from 'vue';
import { postContainerStore } from '@/stores/postContainerStore';
import type { Post } from '@/types';

export function usePostEdit(postId: string) {
  const loading = ref(false);
  const error = ref<string | null>(null);

  // Access store
  const post = computed(() =>
    postContainerStore.get().posts.find(p => p.id === postId)
  );

  async function updatePost(updates: Partial<Post>) {
    loading.value = true;
    error.value = null;

    try {
      const response = await fetch(`/api/posts/${postId}`, {
        method: 'PATCH',
        body: JSON.stringify(updates),
      });

      if (!response.ok) throw new Error('Update failed');

      const updated = await response.json();

      // Update store after success
      postContainerStore.setKey('posts',
        postContainerStore.get().posts.map(p =>
          p.id === postId ? updated : p
        )
      );

      return updated;
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Unknown error';
      throw err;
    } finally {
      loading.value = false;
    }
  }

  return {
    post,
    loading,
    error,
    updatePost,
  };
}
```

**Usage in component:**
```vue
<script setup lang="ts">
import { usePostEdit } from '@/composables/usePostEdit';

const props = defineProps<{ postId: string }>();
const { post, loading, error, updatePost } = usePostEdit(props.postId);

async function handleSave(data: Partial<Post>) {
  await updatePost(data);
  // Component handles UI feedback
}
</script>
```

#### Level 3: Nanostores (Cross-Component State)
**Use for state shared across multiple components**

**When to use stores:**
- Global application state (user, theme, settings)
- Data that persists across page navigation
- State shared by unrelated components
- Data from API that multiple components need

**Store Pattern with Actions:**
```typescript
// stores/postContainerStore.ts
import { map } from 'nanostores';
import type { Post } from '@/types';

interface PostState {
  posts: Post[];
  loading: boolean;
  error: string | null;
}

export const postContainerStore = map<PostState>({
  posts: [],
  loading: false,
  error: null,
});

// Actions
export function setPosts(posts: Post[]) {
  postContainerStore.setKey('posts', posts);
}

export function addPost(post: Post) {
  const current = postContainerStore.get();
  postContainerStore.setKey('posts', [...current.posts, post]);
}

export function updatePost(postId: string, updates: Partial<Post>) {
  const current = postContainerStore.get();
  postContainerStore.setKey('posts',
    current.posts.map(p => p.id === postId ? { ...p, ...updates } : p)
  );
}

export function removePost(postId: string) {
  const current = postContainerStore.get();
  postContainerStore.setKey('posts',
    current.posts.filter(p => p.id !== postId)
  );
}
```

**Usage in Vue:**
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue';
import { postContainerStore, updatePost } from '@/stores/postContainerStore';

// Reactive access - triggers re-render
const state = useStore(postContainerStore);

// Event handler access - doesn't need reactivity
function handleUpdate(postId: string, data: Partial<Post>) {
  // Use action function (reads with .get() internally)
  updatePost(postId, data);

  // OR direct .get() for one-off reads
  const currentPost = postContainerStore.get().posts.find(p => p.id === postId);
}
</script>

<template>
  <!-- Reactive state -->
  <div v-for="post in state.posts" :key="post.id">
    {{ post.title }}
  </div>
</template>
```

#### Level 4: Vue Components (UI + Slots)
**Build composable, reusable UI components**

**Component Abstraction with Slots:**

**Base Component Pattern:**
```vue
<!-- components/vue/modals/BaseModal.vue -->
<script setup lang="ts">
defineProps<{
  open: boolean;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  closeOnOutsideClick?: boolean;
}>();

const emit = defineEmits<{
  (e: 'close'): void;
}>();

withDefaults(defineProps<{
  size?: 'sm' | 'md' | 'lg' | 'xl';
  closeOnOutsideClick?: boolean;
}>(), {
  size: 'md',
  closeOnOutsideClick: true,
});
</script>

<template>
  <div v-if="open" class="modal-backdrop" @click.self="closeOnOutsideClick && $emit('close')">
    <div :class="['modal-container', `modal-${size}`]">
      <!-- Flexible slot structure -->
      <div v-if="$slots.header" class="modal-header">
        <slot name="header" />
      </div>

      <div class="modal-body">
        <slot /> <!-- Default slot for content -->
      </div>

      <div v-if="$slots.footer" class="modal-footer">
        <slot name="footer" />
      </div>
    </div>
  </div>
</template>
```

**Specific Modal Using Base:**
```vue
<!-- components/vue/modals/ConfirmDeleteModal.vue -->
<script setup lang="ts">
import BaseModal from './BaseModal.vue';

const props = defineProps<{
  open: boolean;
  itemName: string;
  loading?: boolean;
}>();

const emit = defineEmits<{
  (e: 'confirm'): void;
  (e: 'close'): void;
}>();
</script>

<template>
  <BaseModal :open="open" size="sm" @close="$emit('close')">
    <!-- Use named slots -->
    <template #header>
      <h3 class="text-lg font-semibold">Confirm Deletion</h3>
    </template>

    <!-- Default slot -->
    <p class="text-gray-700 dark:text-gray-300">
      Are you sure you want to delete "{{ itemName }}"? This action cannot be undone.
    </p>

    <template #footer>
      <div class="flex gap-4 justify-end">
        <button
          @click="$emit('close')"
          :disabled="loading"
          class="btn-secondary"
        >
          Cancel
        </button>
        <button
          @click="$emit('confirm')"
          :disabled="loading"
          class="btn-danger"
        >
          {{ loading ? 'Deleting...' : 'Delete' }}
        </button>
      </div>
    </template>
  </BaseModal>
</template>
```

**Slot Patterns for Maximum Reusability:**

```vue
<script setup lang="ts">
// Scoped slots pass data to parent
defineProps<{
  items: Array<{ id: string; name: string; data: any }>;
}>();
</script>

<template>
  <div class="list-container">
    <!-- Scoped slot - parent controls rendering -->
    <div v-for="item in items" :key="item.id">
      <slot name="item" :item="item" :index="index">
        <!-- Fallback if slot not provided -->
        <div>{{ item.name }}</div>
      </slot>
    </div>

    <!-- Named slot with fallback -->
    <div class="list-footer">
      <slot name="footer">
        <p class="text-sm text-gray-500">{{ items.length }} items</p>
      </slot>
    </div>
  </div>
</template>
```

**Using scoped slots:**
```vue
<template>
  <ItemList :items="posts">
    <!-- Access scoped data -->
    <template #item="{ item, index }">
      <PostCard :post="item" :position="index" />
    </template>

    <template #footer>
      <LoadMoreButton @click="loadMore" />
    </template>
  </ItemList>
</template>
```

---

### Reactivity Best Practices

**1. Ref vs Reactive**
```typescript
// ✅ Prefer ref for everything (consistent pattern)
const user = ref<User | null>(null);
const count = ref(0);
const items = ref<Item[]>([]);

// ❌ Avoid reactive (can't be reassigned, destructure loses reactivity)
const state = reactive({ count: 0 }); // If you reassign, reactivity breaks
```

**2. Computed for Derived State**
```typescript
// ✅ Good - Cached, only recomputes when dependencies change
const filteredPosts = computed(() =>
  posts.value.filter(p => p.author === currentUser.value?.id)
);

// ❌ Bad - Recomputes on every render
function getFilteredPosts() {
  return posts.value.filter(p => p.author === currentUser.value?.id);
}
```

**3. Watch vs WatchEffect**
```typescript
// Use watch when you need the old value or want to be explicit
watch(searchQuery, (newVal, oldVal) => {
  console.log(`Search changed from "${oldVal}" to "${newVal}"`);
  performSearch(newVal);
});

// Use watchEffect for simple automatic tracking
watchEffect(() => {
  // Automatically tracks all reactive dependencies
  document.title = `${posts.value.length} posts - My App`;
});
```

**4. Avoid Ref Unwrapping Confusion**
```typescript
// ✅ Good - Explicit .value in script
const count = ref(0);
console.log(count.value); // Must use .value

// In template, refs auto-unwrap
<template>
  <div>{{ count }}</div> <!-- No .value needed -->
</template>

// ⚠️ Reactive in arrays/objects doesn't auto-unwrap
const items = ref([ref(1), ref(2)]); // Bad pattern
console.log(items.value[0].value); // Confusing

// ✅ Better - use plain values
const items = ref([1, 2]);
```

**5. Shallow Refs for Performance**
```typescript
// For large arrays/objects where you replace the whole thing
import { shallowRef } from 'vue';

// Shallow ref only tracks .value reassignment, not nested changes
const posts = shallowRef<Post[]>([]);

// ✅ Triggers reactivity - replacing entire array
posts.value = [...posts.value, newPost];

// ❌ Won't trigger reactivity - mutating nested value
posts.value.push(newPost); // Change not detected!

// Use shallow when you ALWAYS replace the whole value
```

**6. Avoid Overusing Watchers**
```typescript
// ❌ Bad - Watcher creates indirect data flow
const searchQuery = ref('');
const searchResults = ref([]);

watch(searchQuery, async (query) => {
  searchResults.value = await fetchResults(query);
});

// ✅ Better - Use computed for sync, composable for async
import { computedAsync } from '@vueuse/core';

const searchResults = computedAsync(async () => {
  return await fetchResults(searchQuery.value);
}, []);
```

**7. Handle Async State Properly**
```typescript
// ✅ Good pattern for async operations
const data = ref<Data | null>(null);
const loading = ref(false);
const error = ref<Error | null>(null);

async function fetchData() {
  loading.value = true;
  error.value = null;

  try {
    data.value = await api.fetch();
  } catch (err) {
    error.value = err instanceof Error ? err : new Error('Unknown error');
  } finally {
    loading.value = false;
  }
}

// Or use VueUse
import { useAsyncState } from '@vueuse/core';

const { state, isLoading, error, execute } = useAsyncState(
  () => api.fetch(),
  null,
  { immediate: false }
);
```

**8. Proper Lifecycle for Cleanup**
```typescript
import { onMounted, onUnmounted } from 'vue';

onMounted(() => {
  // Setup: Add event listeners, start intervals, etc.
  const interval = setInterval(pollData, 5000);
  window.addEventListener('resize', handleResize);

  // Cleanup in onUnmounted
  onUnmounted(() => {
    clearInterval(interval);
    window.removeEventListener('resize', handleResize);
  });
});

// Or use VueUse auto-cleanup
import { useIntervalFn, useEventListener } from '@vueuse/core';

const { pause, resume } = useIntervalFn(pollData, 5000);
useEventListener(window, 'resize', handleResize); // Auto-cleaned up
```

---

### Vue Component Patterns

**1. Props + Emits + Model**
```vue
<script setup lang="ts">
// Props with defaults
const props = withDefaults(
  defineProps<{
    title: string;
    description?: string;
    disabled?: boolean;
  }>(),
  {
    description: '',
    disabled: false,
  }
);

// Typed emits
const emit = defineEmits<{
  (e: 'update', value: string): void;
  (e: 'close'): void;
}>();

// Two-way binding
const modelValue = defineModel<string>('value', { required: true });
</script>
```

**2. Composable Pattern**
```typescript
// composables/useNotification.ts
import { useToast } from '@/stores/toastStore';

export function useNotification() {
  const showSuccess = (message: string) => {
    useToast().show({ type: 'success', message });
  };

  const showError = (message: string) => {
    useToast().show({ type: 'error', message });
  };

  return { showSuccess, showError };
}

// Usage in component
const { showSuccess, showError } = useNotification();
```

**3. VueUse Integration**
```vue
<script setup lang="ts">
import { useMounted, useWindowSize, useDebounce } from '@vueuse/core';

const isMounted = useMounted();
const { width, height } = useWindowSize();
const debouncedSearch = useDebounce(searchQuery, 500);
</script>
```

---

### Error Handling Patterns

**1. API Route Error Handling**
```typescript
export const POST: APIRoute = async ({ request, cookies }) => {
  try {
    // Validation
    const body = await request.json();
    const validated = RequestSchema.parse(body);

    // Business logic
    const result = await performOperation(validated);

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('API error:', error);

    // Zod validation errors
    if (error instanceof z.ZodError) {
      return new Response(
        JSON.stringify({
          error: 'Validation error',
          details: error.errors,
        }),
        { status: 422, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Generic errors
    return new Response(
      JSON.stringify({
        error: 'Operation failed',
        message: error instanceof Error ? error.message : String(error),
      }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
};
```

**2. Vue Component Error Handling**
```vue
<script setup lang="ts">
import { ref } from 'vue';
import { useNotification } from '@/composables/useNotification';

const { showError } = useNotification();
const loading = ref(false);
const error = ref<string | null>(null);

async function handleSubmit() {
  loading.value = true;
  error.value = null;

  try {
    await submitData();
    showSuccess('Data saved successfully');
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Operation failed';
    showError(error.value);
  } finally {
    loading.value = false;
  }
}
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <div v-if="error" class="error-message">{{ error }}</div>
    <button type="submit" :disabled="loading">
      {{ loading ? 'Saving...' : 'Save' }}
    </button>
  </form>
</template>
```

---

## Agent Invocation Matrix

| Task Type | Primary Agent | Secondary Agent(s) | Research Agents |
|-----------|---------------|--------------------|-----------------|
| Create Astro page | astro-architect | vue-architect, appwrite-integration-specialist | documentation-researcher |
| Create Vue component | code-reuser-scout → vue-testing-specialist → vue-architect | tailwind-styling-expert | documentation-researcher (VueUse) |
| Debug SSR issue | ssr-debugger | nanostore-state-architect | web-researcher (conditional) |
| Create API route | astro-architect | typescript-validator, appwrite-integration-specialist | documentation-researcher |
| Fix TypeScript errors | typescript-validator | - | web-researcher (for obscure errors) |
| Implement Appwrite | appwrite-integration-specialist | typescript-validator | web-researcher (conditional) |
| Create Nanostore | code-reuser-scout → nanostore-state-architect | vue-architect | documentation-researcher |
| Style component | code-reuser-scout → tailwind-styling-expert | - | documentation-researcher |
| Test component/composable | vue-testing-specialist | - | documentation-researcher |
| Enhance existing feature | code-reuser-scout | [Appropriate specialist] | documentation-researcher → web-researcher |
| Debug existing feature | code-reuser-scout (map) | [Issue-specific agent] | documentation-researcher → web-researcher |
| Research patterns | code-reuser-scout (check existing) | [Appropriate specialist] | documentation-researcher → web-researcher |

**Agent Flow Rules:**
- **Always start with `code-reuser-scout`** when creating/extending components, composables, or stores.
- **Use `documentation-researcher` for VueUse/pattern research** before creating custom code.
- **Use `web-researcher` conditionally** only for latest patterns or framework-specific bugs not in local docs.
- **Follow hierarchy:** VueUse (`documentation-researcher`) → Custom composables → Stores → Components.
- **Write tests first** with `vue-testing-specialist` for new components and bug fixes.

---

## Integration with Existing CLAUDE.md

**Add to Project CLAUDE.md:**
```markdown
## Frontend Development System

This project uses a specialized agent system for frontend development. See `~/.claude/FRONTEND_DEV_SYSTEM.md` for details.

### Quick Reference

**Slash Commands:**
- `/frontend-research [topic]` - Research patterns and best practices
- `/component [create|refactor|debug] [name]` - Component operations
- `/page [create|debug] [path]` - Astro page operations
- `/api [create|debug] [path]` - API route operations
- `/store [create|refactor] [name]` - Nanostore operations
- `/style [component-path]` - Tailwind styling
- `/fix-types [file-path]` - TypeScript fixes
- `/ssr-debug [issue]` - SSR debugging
- `/appwrite [setup|auth|database|storage]` - Appwrite integration

**Automatic Agent Delegation:**
Claude will automatically invoke specialist agents based on task context:
- astro-architect - Astro SSR patterns
- vue-architect - Vue component development
- tailwind-styling-expert - Tailwind CSS styling
- appwrite-integration-specialist - Appwrite integration
- typescript-validator - TypeScript and Zod
- ssr-debugger - SSR debugging
- nanostore-state-architect - State management
- vue-testing-specialist - Writing tests
- code-reuser-scout - Finding existing code
```

---

## Summary

This frontend development system provides:

1. **11 Specialized Agents** - Each focused on specific technology concerns:
   - `astro-architect` - Astro pages, layouts, and API routes
   - `vue-architect` - Vue components and UI logic
   - `nanostore-state-architect` - Cross-component state management
   - `tailwind-styling-expert` - Responsive design + dark mode
   - `appwrite-integration-specialist` - Backend integration
   - `typescript-validator` - Type safety + Zod
   - `ssr-debugger` - Hydration issues + state sync
   - `vue-testing-specialist` - Component and composable testing
   - `code-reuser-scout` - Prevents code duplication
   - `documentation-researcher` - Searches local, curated docs
   - `web-researcher` - Targeted web searches for new/unknown issues

2. **9 Slash Commands** - Quick access to common workflows

3. **8 Complete Workflows** - End-to-end patterns including:
   - Create new feature page
   - Debug SSR hydration issues
   - Create API endpoint with validation
   - Refactor to use Nanostores
   - Add dark mode support
   - Enhance existing feature (with code reuse)
   - Debug existing feature (with minimal changes)
   - **Test-Driven Component Development**

4. **Architecture Hierarchy** - Clear guidance on code organization:
   - **Level 1:** VueUse composables (via `documentation-researcher`)
   - **Level 2:** Custom composables (reusable logic)
   - **Level 3:** Nanostores (cross-component state)
   - **Level 4:** Vue components (UI with slots)

5. **Best Practices** - Type safety, SSR patterns, reactivity, component abstraction

6. **Automatic Delegation** - Claude invokes agents based on context

**Key Principles:**

**1. Code Reuse First**
- Always check existing code before creating new (`code-reuser-scout`)
- Always check VueUse before custom composables (`documentation-researcher`)
- Extend existing components with slots rather than duplicating

**2. Research Hierarchy**
- **Local docs first:** `~/.claude/documentation/`
- **VueUse research:** `documentation-researcher` agent for specific composables
- **Web research:** `web-researcher` agent only for latest 2025 patterns

**3. Architecture Hierarchy**
- VueUse composables → Custom composables → Stores → Components
- Logic flows down, UI components at the top

**4. Bulletproof Agents**
Each agent has access to:
- Local documentation (`~/.claude/documentation/`)
- Gemini for large codebase analysis (`mcp__gemini-cli__ask-gemini`)
- MCP tools for framework queries (GitHub Docs, Tailwind)
- Conditional web search for latest patterns (`web-researcher`)

**Integration:** These patterns are designed to work seamlessly with the existing tech stack (Astro + Vue + Tailwind + TypeScript + Appwrite) and complement the project's current architecture while preventing code duplication and promoting reusability.
