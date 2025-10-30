---
allowed-tools: Read, Write, Edit, MultiEdit, Bash(npm:*), Bash(pnpm:*), Bash(git:*), Bash(cat:*), Bash(ls:*), TodoWrite, Task, Glob, Grep
argument-hint: [feature-name] [what-to-add?]
description: Execute implementation plan with intelligent parallel agent coordination
---

# Frontend Feature Implementation

**Feature:** `$1`

## Phase 0: Initialize and Load Context

### Load Feature Description

If `$2` is provided, use it. Otherwise, read from stored FEATURE_CONTEXT.md:

```bash
# Find the most recent workspace for this feature (any type)
WORKSPACE=$(ls -td .temp/{analyze,initiate,quick-task}-$1-* 2>/dev/null | head -1)

if [ -z "$2" ] && [ -d "$WORKSPACE" ] && [ -f "$WORKSPACE/FEATURE_CONTEXT.md" ]; then
  # Read description from stored context
  DESCRIPTION=$(grep "^**Description:**" "$WORKSPACE/FEATURE_CONTEXT.md" | sed 's/^**Description:** //')
  echo "📖 Loaded feature description from $WORKSPACE/FEATURE_CONTEXT.md"
  echo "Feature: $1"
  echo "Description: $DESCRIPTION"
else
  DESCRIPTION="$2"
fi

# If still no description, error
if [ -z "$DESCRIPTION" ]; then
  echo "❌ Error: No description provided and no FEATURE_CONTEXT.md found."
  echo "Either:"
  echo "  1. Run /frontend-analyze \"$1\" \"description\" first, OR"
  echo "  2. Run /frontend-initiate \"$1\" \"description\" first, OR"
  echo "  3. Provide description: /frontend-implement \"$1\" \"description\""
  exit 1
fi
```

**Addition:** `$DESCRIPTION` (from $2 or stored context)

## Prerequisites

You must have:
1. Completed `/frontend-analyze "$1" "$DESCRIPTION"` → created PRE_ANALYSIS.md
2. Completed `/frontend-plan "$1"` → created MASTER_PLAN.md
3. User approved the MASTER_PLAN.md

Or completed `/frontend-initiate "$1" "$DESCRIPTION"` → created both files

## Phase 0: Initialize Implementation

### Create Todo List

```json
{
  "todos": [
    {
      "content": "Read MASTER_PLAN.md and analyze task requirements",
      "status": "in_progress",
      "activeForm": "Reading master plan"
    },
    {
      "content": "Determine intelligent agent selection based on tasks",
      "status": "pending",
      "activeForm": "Selecting agents"
    },
    {
      "content": "Execute Phase 1: Foundation (stores/composables)",
      "status": "pending",
      "activeForm": "Implementing foundation"
    },
    {
      "content": "Execute Phase 2: Components",
      "status": "pending",
      "activeForm": "Implementing components"
    },
    {
      "content": "Execute Phase 3: Integration",
      "status": "pending",
      "activeForm": "Integrating features"
    },
    {
      "content": "Execute Phase 4: Testing and validation",
      "status": "pending",
      "activeForm": "Testing implementation"
    },
    {
      "content": "Consolidate results and commit changes",
      "status": "pending",
      "activeForm": "Committing changes"
    }
  ]
}
```

## Phase 1: Read Plan and Analyze Requirements

Read: `.temp/analyze-$1-*/MASTER_PLAN.md` (or workspace location)

Analyze the plan to determine:
1. **What tech stack is involved?**
   - Vue/React/Angular/Astro?
   - TypeScript/JavaScript?
   - State management (Pinia/Redux/Zustand/nanostores)?
   - Testing framework?

2. **What specialists are needed?**
   - Store/state implementation?
   - Composable/hook implementation?
   - Component implementation?
   - API/backend integration?
   - Testing?

3. **Can tasks run in parallel?**
   - Foundation tasks (stores + composables) can run together
   - Component tasks depend on foundation
   - Integration depends on components
   - Testing can overlap with integration

## Phase 2: Intelligent Agent Selection

Based on the plan analysis, select appropriate specialist agents from your `.claude/agents/` directory:

### Available Specialist Agents

**Frontend Architecture & Components:**
- `vue-architect` - Vue 3 components, Composition API, Nanostores integration, SSR patterns
- `astro-architect` - Astro pages, layouts, API routes, SSR data fetching, authentication
- `nanostore-state-architect` - State management with nanostores, atoms, maps, computed stores
- `tailwind-styling-expert` - Responsive design, dark mode, accessibility, Tailwind patterns

**Integration & Data:**
- `appwrite-integration-specialist` - Appwrite auth, database, storage, real-time subscriptions
- `typescript-validator` - Type safety, Zod schemas, error resolution, type inference
- `code-reuser-scout` - Find existing patterns, prevent duplication, identify reusable code

**Debugging & Quality:**
- `ssr-debugger` - SSR issues, hydration mismatches, client-server sync, performance
- `python-architect` - Python backend, FastAPI, data pipelines (if backend work needed)

**General Purpose:**
- `general-purpose` - Standard implementations when specialist expertise not required

### Agent Selection Logic

Analyze MASTER_PLAN.md to determine which specialists are needed:

**IF plan includes Vue components:**
- Use `vue-architect` for component implementation
- Check if SSR patterns needed → confirm `vue-architect` (includes SSR expertise)

**IF plan includes Astro pages/routes:**
- Use `astro-architect` for page structure and API routes
- Check if auth needed → `astro-architect` + `appwrite-integration-specialist`

**IF plan includes state management:**
- Use `nanostore-state-architect` for stores and atoms
- Check if persistent state needed → `nanostore-state-architect` handles this

**IF plan includes styling/design:**
- Use `tailwind-styling-expert` for responsive layouts and dark mode
- Check if accessibility required → `tailwind-styling-expert` handles this

**IF plan includes TypeScript types:**
- Use `typescript-validator` for type definitions and Zod schemas
- Check if type errors exist → `typescript-validator` can fix

**IF plan includes Appwrite backend:**
- Use `appwrite-integration-specialist` for auth, database, storage
- Check if real-time needed → `appwrite-integration-specialist` handles subscriptions

**IF plan includes reusability checking:**
- Use `code-reuser-scout` FIRST to find existing patterns
- Prevents duplication before implementation begins

**IF plan includes SSR debugging:**
- Use `ssr-debugger` for hydration issues or browser API problems

**IF plan includes Python backend:**
- Use `python-architect` for FastAPI/Django implementation

**FOR standard implementations:**
- Use `general-purpose` agents (can spawn multiple for parallel work)

### Agent Selection Priority

1. **ALWAYS start with `code-reuser-scout`** - Check for existing patterns first
2. **Select specialists based on task domain** - Use specific expertise when available
3. **Coordinate multiple specialists** - Spawn in parallel when tasks are independent
4. **Fall back to general-purpose** - Only when no specialist applies

## Phase 3: Execute Implementation

### Parallel Execution Strategy

Spawn appropriate specialist agents based on MASTER_PLAN.md requirements:

#### Foundation Phase (Parallel Agents)

**Agent 1: State Management (Nanostores)**

Use `nanostore-state-architect` agent:

```
Task(
  subagent_type: "nanostore-state-architect",
  description: "Implement nanostores for $DESCRIPTION state",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 1: Foundation section)

Task: Implement state management for "$DESCRIPTION" using nanostores

Implementation Requirements:
1. Store Type: [atom/map/computed from plan]
2. Store Name: [from plan naming conventions]
3. State Structure: [from plan type definitions]
4. Actions/Mutations: [from plan action list]
5. Persistence: [if needed - localStorage/sessionStorage]

Constraints:
- SSR-safe initialization (no browser APIs during module load)
- TypeScript strict typing
- Follow existing store patterns from codebase
- Use `$` prefix for store names
- Export actions alongside stores

Integration:
- Where to use: [components from plan]
- How to access: Use @nanostores/vue `useStore()` in Vue components

Success: Store implemented, type-safe, SSR-compatible, with clear actions.
Output: Store file path, exported stores and actions list.
"""
)
```

**Agent 2: Reusability Check (Before Implementation)**

Use `code-reuser-scout` agent FIRST:

```
Task(
  subagent_type: "code-reuser-scout",
  description: "Find existing patterns for $DESCRIPTION",
  prompt: """
Search Task: Find existing code patterns for "$DESCRIPTION" before implementation

Search For:
1. Existing components similar to [components we plan to create]
2. Existing composables that solve [functionality needed]
3. Existing stores that manage [similar state]
4. Existing utilities that provide [helper functions]
5. Similar implementations elsewhere in codebase

Report:
- EXACT MATCHES: Code that already does this
- NEAR MATCHES: Code that does 70-90% of this
- BASE COMPONENTS: Code we can extend/compose
- PATTERNS TO FOLLOW: Conventions observed in codebase

Recommendation:
Should we reuse existing code, extend it, refactor it, or create new?

Output: Detailed reusability report with file paths and line numbers.
"""
)
```

#### Implementation Phase (After Foundation Completes)

**Agent 3: Vue Component Implementation**

Use `vue-architect` agent for Vue components:

```
Task(
  subagent_type: "vue-architect",
  description: "Implement Vue components for $DESCRIPTION",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 2: Implementation section)

Task: Implement Vue 3 components for "$DESCRIPTION" with Composition API

Component Requirements:
1. Components to create/modify: [from plan]
2. Props interface: [from plan type definitions]
3. Emits interface: [from plan event list]
4. Slots needed: [from plan composition strategy]
5. Store integration: [which nanostores to use]

Implementation Guidelines:
- Use `<script setup lang="ts">` with Composition API
- Type props with `defineProps<T>()`
- Type emits with `defineEmits<T>()`
- Use `@nanostores/vue` for store access with `useStore()`
- Follow SSR-safe patterns (use `useMounted()` for client-only code)
- Implement proper slots for composition
- Add responsive design with Tailwind (defer to tailwind-styling-expert if needed)

Constraints:
- SSR-compatible (no window/document in setup)
- TypeScript strict mode
- Follow existing component patterns from codebase
- Backward compatible (new props optional with defaults)
- Accessible (proper ARIA attributes)

Success: Components implemented, SSR-safe, type-safe, accessible.
Output: Component file paths, props/emits interfaces, integration notes.
"""
)
```

**Agent 4: Styling Implementation (If Needed)**

Use `tailwind-styling-expert` for design work:

```
Task(
  subagent_type: "tailwind-styling-expert",
  description: "Style components for $DESCRIPTION",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 2: Implementation section)

Task: Style components for "$DESCRIPTION" with Tailwind CSS

Styling Requirements:
1. Components to style: [from plan]
2. Design requirements: [from plan design specs]
3. Responsive breakpoints: [mobile, tablet, desktop needs]
4. Dark mode support: [yes/no and color scheme]
5. Accessibility requirements: [focus states, contrast ratios]

Implementation Guidelines:
- Mobile-first responsive design
- Use dark: variant for dark mode
- Ensure WCAG AA contrast ratios
- Add proper focus indicators
- Follow existing design system tokens
- Use utility classes (avoid custom CSS)

Constraints:
- Consistency with existing components
- Performance (minimize custom CSS)
- Accessibility (keyboard navigation, screen readers)

Success: Styled components, responsive, accessible, dark mode support.
Output: List of styled components and design patterns used.
"""
)
```

**Agent 5: TypeScript Type Definitions**

Use `typescript-validator` for type safety:

```
Task(
  subagent_type: "typescript-validator",
  description: "Create type definitions for $DESCRIPTION",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 2: Implementation section)

Task: Create comprehensive type definitions for "$DESCRIPTION"

Type Requirements:
1. Interfaces/types to define: [from plan]
2. Zod schemas for validation: [API boundaries, user inputs]
3. Component prop types: [from component specifications]
4. Store types: [from nanostore specifications]
5. Utility function types: [from helper functions]

Implementation Guidelines:
- Use TypeScript 3.10+ syntax (built-in types, no imports from 'typing' unless necessary)
- Create Zod schemas for runtime validation at boundaries
- Ensure type inference works properly
- Add JSDoc comments for complex types
- Use utility types (Pick, Omit, Partial, Required)
- Avoid `any` type (use `unknown` for truly dynamic types)

Constraints:
- TypeScript strict mode enabled
- No type errors allowed
- Proper type inference for better DX
- Zod schemas match TypeScript types exactly

Success: Complete type coverage, no type errors, runtime validation at boundaries.
Output: Type file paths, interface definitions, Zod schemas created.
"""
)
```

#### Integration Phase

**Agent 6: Appwrite Integration (If Backend Needed)**

Use `appwrite-integration-specialist` if Appwrite is involved:

```
Task(
  subagent_type: "appwrite-integration-specialist",
  description: "Integrate Appwrite backend for $DESCRIPTION",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 3: Integration section)

Task: Integrate Appwrite backend services for "$DESCRIPTION"

Integration Requirements:
1. Services needed: [auth, database, storage, real-time, functions]
2. Collections/buckets: [from plan data model]
3. Permissions: [read/write permissions strategy]
4. Real-time channels: [if subscriptions needed]
5. Authentication flow: [if auth needed]

Implementation Guidelines:
- Separate client instances for server and browser contexts
- Use Zod schemas for request/response validation
- Implement proper error handling with user-friendly messages
- Set appropriate permissions for security
- Clean up subscriptions on component unmount
- Type all Appwrite responses with interfaces

Constraints:
- SSR-safe client initialization
- TypeScript strict typing
- Comprehensive error handling
- Security best practices (permissions, validation)

Success: Appwrite services integrated, type-safe, error-handled, secure.
Output: Service functions, client setup, type definitions, error handlers.
"""
)
```

**Agent 7: Astro Page Integration (If Pages/Routes Needed)**

Use `astro-architect` for Astro pages and API routes:

```
Task(
  subagent_type: "astro-architect",
  description: "Create Astro pages/routes for $DESCRIPTION",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 3: Integration section)

Task: Implement Astro pages and API routes for "$DESCRIPTION"

Page/Route Requirements:
1. Pages to create: [from plan page list]
2. API routes to create: [from plan API endpoints]
3. Data fetching needs: [SSR data requirements]
4. Authentication guards: [protected routes]
5. Layouts to use: [layout structure]

Implementation Guidelines:
- Server-side data fetching in frontmatter
- Proper authentication checks with redirects
- API routes with Zod validation
- Type-safe data flow from server to client
- Proper error handling and status codes
- SSR-compatible patterns (no browser APIs in server code)

Constraints:
- TypeScript strict mode
- Zod validation on all API routes
- Authentication where required
- Proper HTTP status codes
- Error handling for all edge cases

Success: Pages and routes implemented, SSR-safe, authenticated, validated.
Output: Page/route file paths, data flow documentation, API contracts.
"""
)
```

#### Quality Assurance Phase

**Agent 8: SSR Debugging (If Issues Found)**

Use `ssr-debugger` if SSR problems occur:

```
Task(
  subagent_type: "ssr-debugger",
  description: "Debug SSR issues in $DESCRIPTION",
  prompt: """
Debug Task: Identify and fix SSR-specific issues in "$DESCRIPTION" implementation

Issues to Check:
1. Hydration mismatches (server vs client rendering differences)
2. Browser API usage during SSR (window, document, localStorage)
3. Client-server state synchronization problems
4. Memory leaks in server context
5. Performance bottlenecks in SSR rendering

Debugging Steps:
- Reproduce issues locally
- Check server logs and build output
- Compare server HTML with client render
- Verify environment checks (import.meta.env.SSR)
- Trace data flow from server to client
- Profile SSR performance if needed

Fixes to Implement:
- Add `useMounted()` guards for client-only code
- Use client directives (client:load, client:only) where appropriate
- Ensure deterministic rendering (no random values, proper timestamps)
- Clean up event listeners and subscriptions
- Fix browser API access with environment checks

Success: All SSR issues resolved, hydration successful, no warnings.
Output: Issues found, fixes applied, verification results.
"""
)
```

## Phase 4: Consolidate and Verify

### Collect Implementation Reports

After all agents complete, consolidate findings:

```markdown
## Implementation Summary

### Foundation Phase
✅ Store/State: [changes summary]
✅ Composables/Hooks: [changes summary]
✅ Agents Used: [list agent types]

### Component Phase
✅ Components Modified: [N] files
✅ Changes: [summary]
✅ Agents Used: [list agent types]

### Integration Phase
✅ Wiring: [complete/partial]
✅ Data Flow: [verified/issues]
✅ Type Safety: [confirmed/issues]
✅ Agents Used: [list agent types]

### Testing Phase
✅ New Tests: [N] created
✅ Existing Tests: [all passing / X failing]
✅ Type Check: [passed/failed]
✅ Build: [successful/failed]

## Files Changed
[List files with line counts]

## Agent Selection Rationale
[Explain why each agent type was chosen]

## Backward Compatibility
✅ All changes additive
✅ No breaking changes
✅ Existing tests pass
✅ Default behavior unchanged
```

### Verification Checklist

Before completing:

- [ ] All store/state changes implemented
- [ ] All composable/hook changes implemented
- [ ] All component changes implemented
- [ ] Integration verified
- [ ] New tests passing
- [ ] Existing tests passing (regression)
- [ ] Type check passing
- [ ] Build successful
- [ ] No console errors
- [ ] Backward compatible
- [ ] Intelligent agents selected appropriately

### Commit Changes

If all verification passes:

```bash
git add -A
git commit -m "feat: add $DESCRIPTION to $1 feature

- Extended store with new actions/getters
- Enhanced composable with new logic
- Modified components to support new functionality
- Added comprehensive tests
- Maintained backward compatibility

Agents used: [list agent types]"
```

## Success Criteria

- [x] MASTER_PLAN.md read and understood
- [x] Appropriate agents selected based on task requirements
- [x] Foundation implemented (stores/composables)
- [x] Components implemented
- [x] Integration complete
- [x] Tests passing (new + regression)
- [x] Type check passing
- [x] Build successful
- [x] Backward compatibility maintained
- [x] Changes committed with clear message

## Next Step

After implementation completes:

```bash
/frontend-validate "$1"
```

Note: Description is automatically loaded from FEATURE_CONTEXT.md

## Intelligent Agent Selection Notes

**Key Principles:**
1. **ALWAYS use code-reuser-scout FIRST** - Check for existing patterns before implementing
2. **Match agent specialization to task domain** - Use specialist expertise when available
3. **Spawn agents in parallel when possible** - Independent tasks can run simultaneously
4. **Coordinate specialists across phases** - Foundation → Implementation → Integration → QA
5. **Document agent selection rationale** - Explain why each agent was chosen

**Agent Selection Examples:**

| Requirement | Agent(s) to Use | Rationale |
|-------------|----------------|-----------|
| Vue 3 components | `vue-architect` | Composition API, SSR, Nanostores expertise |
| Astro pages/routes | `astro-architect` | SSR data fetching, authentication, API routes |
| State management | `nanostore-state-architect` | Nanostores atoms, maps, computed, persistence |
| Styling/design | `tailwind-styling-expert` | Responsive, dark mode, accessibility |
| TypeScript types | `typescript-validator` | Type safety, Zod schemas, error resolution |
| Appwrite backend | `appwrite-integration-specialist` | Auth, database, storage, real-time |
| SSR issues | `ssr-debugger` | Hydration, browser API guards, performance |
| Code reuse check | `code-reuser-scout` | Find existing patterns, prevent duplication |
| Python backend | `python-architect` | FastAPI, data pipelines, async patterns |
| Standard work | `general-purpose` | When specialist expertise not required |

**Agent Coordination Strategy:**

1. **Pre-Implementation:** `code-reuser-scout` finds existing patterns
2. **Foundation Phase:** `nanostore-state-architect` + `typescript-validator` (parallel)
3. **Implementation Phase:** `vue-architect` + `tailwind-styling-expert` + `typescript-validator` (parallel)
4. **Integration Phase:** `astro-architect` + `appwrite-integration-specialist` (as needed)
5. **Quality Phase:** `ssr-debugger` (if issues found) + automated validation

**Agent File Locations:**

All specialist agents are defined in `/Users/natedamstra/.claude/agents/`:
- `code-scout.md` - Used in analyze phase
- `documentation-researcher.md` - Used in analyze phase
- `plan-master.md` - Used in plan phase
- `vue-architect.md` - Vue components (implement phase)
- `astro-architect.md` - Astro pages/routes (implement phase)
- `nanostore-state-architect.md` - State management (implement phase)
- `tailwind-styling-expert.md` - Styling/design (implement phase)
- `typescript-validator.md` - Type safety (implement phase)
- `appwrite-integration-specialist.md` - Backend integration (implement phase)
- `ssr-debugger.md` - SSR debugging (implement phase)
- `code-reuser-scout.md` - Reusability check (implement phase)
- `python-architect.md` - Python backend (if needed)

**Dynamic Selection Based on MASTER_PLAN.md:**

The agent selection should adapt to what's actually in the plan:
- If plan mentions Vue components → spawn `vue-architect`
- If plan mentions stores → spawn `nanostore-state-architect`
- If plan mentions styling → spawn `tailwind-styling-expert`
- If plan mentions Appwrite → spawn `appwrite-integration-specialist`
- If plan mentions pages/routes → spawn `astro-architect`
- If plan mentions types/validation → spawn `typescript-validator`
- ALWAYS spawn `code-reuser-scout` first to check for existing code

**Parallel vs Sequential:**
- Foundation tasks (stores, types) can run in parallel
- Component tasks depend on foundation being complete
- Integration tasks depend on components being complete
- Testing can overlap with integration
