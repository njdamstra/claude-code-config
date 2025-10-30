# CLAUDE.md Template: Frontend Addition Workflow Orchestration

This is a CLAUDE.md template that provides context and instructions for coordinating the multi-phase frontend addition workflow.

Save this as `.claude/CLAUDE.md` in your project root (update as needed for your project).

```markdown
# Frontend Development System - Claude Code Configuration

## Project Overview

This is a [Vue 3 / React / Angular] frontend project using [describe stack]:
- Framework: [Vue/React/Angular] 3.x
- State Management: [Pinia/Redux/NgRx]
- Composables/Hooks: [VueUse/React Query/Angular Services]
- API: [REST/GraphQL] via [Axios/Fetch/Apollo]
- Build: [Vite/Webpack/ESBuild]
- Testing: [Vitest/Jest/Jasmine]

## Development Workflows

### Frontend Addition Workflow

The primary workflow for extending existing features follows a 4-phase approach:

#### Phase 1: Analysis (`/frontend-analyze [feature] [addition]`)

**What This Does:**
- Analyzes existing feature architecture
- Maps all related files and data flows
- Identifies reusable code patterns
- Researches existing solutions (VueUse, npm packages, etc.)

**When to Use:**
- Starting a new feature addition
- Understanding unfamiliar code
- Planning code reuse

**What It Produces:**
- `.temp/analyze-*/PRE_ANALYSIS.md` - Feature map and solutions research

**Duration:** ~15-30 minutes

#### Phase 2: Planning (`/frontend-plan [feature] [addition]`)

**What This Does:**
- Creates minimal-change implementation plan
- Identifies extension opportunities in existing code
- Plans store, composable, and component changes
- Estimates effort and impact

**When to Use:**
- After analysis is complete
- Before writing any implementation code

**What It Produces:**
- `.temp/MASTER_PLAN.md` - Detailed implementation plan
- Requests user approval before proceeding

**Duration:** ~10-20 minutes

**Approval Gate:** ⚠️ STOP - Present plan for human review and approval

#### Phase 3: Implementation (`/frontend-implement [feature] [addition]`)

**What This Does:**
- Executes implementation plan in parallel
- Spawns up to 5 agents for different concerns:
  1. Store/State agent
  2. Composable logic agent
  3. Component modification agent
  4. Integration wiring agent
  5. Testing agent

**When to Use:**
- After plan approval
- When ready to write code

**What It Produces:**
- Modified/created store files
- Modified/created composable files
- Modified/created component files
- New test files
- Git commits with clear messages

**Duration:** ~45-90 minutes depending on complexity

#### Phase 4: Validation (`/frontend-validate [feature] [addition]`)

**What This Does:**
- Runs automated checks (typecheck, lint, build, tests)
- Verifies regression testing (existing feature still works)
- Validates new functionality
- Creates completion report

**When to Use:**
- After implementation completes
- Before merging to main branch

**What It Produces:**
- `COMPLETION_REPORT.md` - Comprehensive validation results
- Clear pass/fail status for production readiness

**Duration:** ~10-20 minutes

### Quick Start

For a typical feature addition:

```bash
# Session 1: Analyze
/frontend-analyze "search" "filter capabilities"
# Output: PRE_ANALYSIS.md

# Session 2: Review and Plan
/frontend-plan "search" "filter capabilities"
# Output: MASTER_PLAN.md
# Wait for approval

# Session 3: Implement
/frontend-implement "search" "filter capabilities"
# Output: Implemented code + tests

# Session 4: Validate
/frontend-validate "search" "filter capabilities"
# Output: COMPLETION_REPORT.md
```

---

## Architecture Patterns

### File Organization

```
src/
├── components/          # Vue/React components
│   ├── Feature/
│   └── FeatureNew.vue   # New components for additions
├── stores/              # State management (Pinia/Redux)
│   ├── feature.ts
│   └── featureNew.ts    # New store for additions
├── composables/         # VueUse composables / React hooks
│   ├── useFeature.ts
│   └── useFeatureNew.ts # New composables for additions
├── api/                 # API integration
├── types/               # TypeScript types
└── tests/               # Test files
```

### Naming Conventions

- **Components:** PascalCase, descriptive (`SearchFeature.vue`)
- **Stores:** camelCase with `use` prefix (`useSearchStore.ts`)
- **Composables:** camelCase with `use` prefix (`useSearchFilters.ts`)
- **Types:** PascalCase, descriptive (`SearchFilter`, `SearchResult`)
- **Files:** kebab-case for files, PascalCase for exported classes/components

### Patterns to Follow

1. **Extension Over Creation:** Always extend existing code before creating new
2. **Minimal Changes:** Modify only what's necessary for the addition
3. **Type Safety:** All new code must have full TypeScript types
4. **Backward Compatibility:** New props/actions must be optional, with defaults
5. **Testing:** New functionality must have comprehensive tests
6. **Documentation:** Add JSDoc comments to new functions

---

## Multi-Agent Coordination

### How to Work With Specialized Agents

When implementing features, you have access to specialized agents:

### 🚀 CRITICAL BEHAVIOR: BE PROACTIVE WITH SUB-AGENTS!

**YOU HAVE SPECIALIZED AGENTS AVAILABLE:**

1. **@code-scout** - Architecture analysis and code mapping
2. **@doc-researcher** - Documentation and solution research
3. **@feature-architect** - System design and planning
4. **@implementation-lead** - Code execution and integration
5. **@qa-specialist** - Testing and validation

**YOU MUST DELEGATE WORK TO THEM** - Don't try to do everything yourself!

### Delegation Pattern

When you have a task:
1. Break it into 3-5 clear sub-tasks
2. Identify which agent is best for each
3. Spawn agents in parallel for independent tasks
4. Collect results and consolidate

Example:
```
Main Task: Implement new feature

  ├── Task 1: Analyze existing code (→ @code-scout)
  ├── Task 2: Research solutions (→ @doc-researcher)
  ├── Task 3: Design architecture (→ @feature-architect)
  └── Tasks 4-5: Implement (→ @implementation-lead)
```

**Note:** Agents 1-3 can run in parallel (analysis phase)
**Then:** Wait for consolidation before starting agent 4+ (implementation)

---

## Code Style & Standards

### TypeScript

- Always use `strict` mode
- No implicit `any` types
- Export interfaces for public APIs
- Document complex logic with JSDoc

### Components

Vue 3 Script Setup style:
```typescript
<script setup lang="ts">
import { ref, computed } from 'vue'
import { useStore } from '@/stores/store'

// Props with explicit types
interface Props {
  modelValue?: string
  items?: Array<Item>
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: '',
  items: () => []
})

// Composables
const { doSomething } = useStore()

// Reactive state
const isLoading = ref(false)
</script>
```

### Stores

Using [Pinia/Redux] patterns:
```typescript
// Store follows established patterns
// New actions extend existing, don't replace
// State is typed
// Getters are for derived state
// Actions handle side effects
```

### Composables

Reusable logic in composables:
```typescript
export function useFeature() {
  // Logic here
  return { value, method }
}
```

---

## Testing Standards

### Test Files

- Place in `tests/` directory
- Use `.spec.ts` extension
- Test file name matches source: `MyComponent.vue` → `MyComponent.spec.ts`

### Coverage Expectations

- Unit tests: 80%+ coverage for new code
- Integration tests: Key workflows
- Regression tests: Run existing test suite

### Testing Tools

- Test runner: [Vitest/Jest]
- Component testing: [@vue/test-utils / React Testing Library]
- Assertion library: [Vitest/Jest]

---

## Build & Deployment

### Local Development

```bash
# Install dependencies
npm install

# Start dev server
npm run dev

# Run tests
npm run test

# Type check
npm run typecheck

# Lint
npm run lint

# Build
npm run build
```

### Quality Checks

Before committing:
```bash
npm run typecheck && npm run lint && npm run test && npm run build
```

### Deployment

- Main branch: Auto-deploys to production
- All tests must pass before merge
- No console warnings/errors
- Bundle size checked

---

## Troubleshooting

### Common Issues

**Issue: Agent doesn't find a file**
- Files are case-sensitive
- Check exact path in `src/`
- Use `Read` tool to verify file exists

**Issue: Type errors after implementation**
- Run `npm run typecheck` to see full errors
- Check that new props/functions are properly typed
- Ensure no implicit `any` types

**Issue: Tests fail unexpectedly**
- Run `npm run test` to see failure details
- May need to update snapshots
- Check that existing functionality still works

### When to Ask for Help

- Unclear requirements
- Architectural decisions needed
- Build/test failures that can't be resolved
- Performance concerns

---

## Useful Commands

| Command | Purpose |
|---------|---------|
| `/frontend-analyze` | Analyze feature architecture |
| `/frontend-plan` | Create implementation plan |
| `/frontend-implement` | Execute implementation |
| `/frontend-validate` | Run validation tests |
| `npm run dev` | Start dev server |
| `npm run test` | Run test suite |
| `npm run typecheck` | Check TypeScript |
| `npm run lint` | Lint code |
| `npm run build` | Build for production |

---

## Git Workflow

### Commit Messages

Use conventional commits:
```
feat: add filter capability to search feature
fix: resolve search results pagination bug
refactor: simplify filter logic
test: add tests for new search filters
docs: update search feature documentation
```

### Branch Naming

- Feature: `feature/search-filters`
- Bug fix: `bugfix/search-results`
- Refactor: `refactor/search-architecture`

### PR Template

Include in PR:
- What was added/changed
- Why this approach was chosen
- How to test the changes
- Any breaking changes (none expected)
- Screenshots if UI changes

---

## VueUse & Common Patterns

### Recommended VueUse Composables

For common tasks, check VueUse first:
- `useWindowSize()` - Window dimensions
- `useStorage()` - LocalStorage/SessionStorage
- `useFetch()` - HTTP requests
- `useDebounce()` - Debounced values
- `useThrottle()` - Throttled values
- `useAsync()` - Async operations
- `useElementSize()` - Element dimensions

### Avoid Reimplementing VueUse

Before writing custom logic, check if VueUse already provides it.
This reduces code, improves quality, and follows industry standards.

---

## Success Metrics

When implementing features:
- ✅ All tests passing (new + regression)
- ✅ TypeScript strict mode clean
- ✅ No console errors/warnings
- ✅ Backward compatible
- ✅ Code follows project patterns
- ✅ Documentation updated
- ✅ Performance acceptable

---

## Resources

- [Vue 3 Documentation](https://vuejs.org)
- [Pinia Store](https://pinia.vuejs.org)
- [VueUse Composables](https://vueuse.org)
- [TypeScript Best Practices](https://www.typescriptlang.org/docs)
- [Testing Best Practices](https://vitest.dev)
```

---

## How to Use This CLAUDE.md

1. **Save** this file as `.claude/CLAUDE.md` in your project
2. **Customize** sections to match your actual project:
   - Replace `[Vue/React/Angular]` with actual framework
   - Replace `[Pinia/Redux/NgRx]` with actual state manager
   - Update commands to match your actual npm scripts
   - Add project-specific patterns and conventions
3. **Reference** in prompts: "I'm starting a new feature, review CLAUDE.md for workflow"
4. **Update** as your project evolves

## Key Benefits

- 📚 Claude has complete project context immediately
- 🎯 Reduces back-and-forth clarification questions
- 🏗️ Enforces consistent patterns across features
- 🤖 Enables agents to work more independently
- ✅ Makes approval and validation faster

Claude will reference this file automatically when making decisions about:
- Where to put new code
- What patterns to follow
- How to structure components
- What testing is needed
- How to coordinate agents

This is your blueprint for successful AI-assisted development!
