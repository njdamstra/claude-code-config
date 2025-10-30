# Plan Master Template: New Feature Creation

**Purpose:** Create comprehensive implementation plan for building a new feature from scratch

---

## Your Task

Create an implementation plan for **NEW FEATURE: {{FEATURE_NAME}}**

**Feature Description:** {{FEATURE_DESCRIPTION}}

**Based on:** `{{WORKSPACE_PATH}}/PRE_ANALYSIS.md` (read this first!)

---

## Planning Requirements

### 1. Follow Architecture Hierarchy (CRITICAL)

Build from bottom-up, leveraging existing code:

**Level 1: VueUse Composables** (Use if available)
- Check PRE_ANALYSIS.md for VueUse composables found
- Use VueUse instead of custom implementations

**Level 2: Custom Composables** (If VueUse doesn't provide)
- Create in `src/composables/use[FeatureName].ts`
- Encapsulate reusable logic
- SSR-safe patterns (useMounted for client-only)

**Level 3: Stores/State Management** (For cross-component state)
- Nanostores: `src/stores/[feature]Store.ts`
- BaseStore pattern: Extend BaseStore for Appwrite integration
- Zod validation: Match Appwrite attribute schemas

**Level 4: Components** (UI layer)
- Build with composition (reuse base components from PRE_ANALYSIS.md)
- Use slots for flexibility
- TypeScript props with `withDefaults()`
- Tailwind CSS (always include `dark:` classes)

### 2. Leverage Reusability (FROM PRE_ANALYSIS.md)

**Reuse Existing Code:**
- List base components identified in PRE_ANALYSIS.md
- List composables identified in PRE_ANALYSIS.md
- List VueUse alternatives identified in PRE_ANALYSIS.md

**Extend Existing Patterns:**
- Follow naming conventions from PRE_ANALYSIS.md
- Follow store patterns from PRE_ANALYSIS.md
- Follow component patterns from PRE_ANALYSIS.md

**Only Create New When:**
- VueUse doesn't provide it
- Existing code can't be extended
- Composition doesn't make sense

### 3. Plan Implementation Phases

Organize work into logical phases:

**Phase 1: Foundation (Stores & Composables)**
- Create/extend stores for state management
- Create/extend composables for logic
- Define TypeScript interfaces/types
- Create Zod schemas for validation

**Phase 2: Core Implementation (Components & Pages)**
- Create/extend Vue components
- Create Astro pages (if needed)
- Integrate with stores/composables
- Implement UI with Tailwind

**Phase 3: Enhancement (Styling & Types)**
- Complete dark mode support
- Ensure responsive design
- Complete TypeScript strict mode
- Add SSR safety checks (useMounted)

**Phase 4: Quality Assurance**
- Write component tests
- Write integration tests
- Run type checking
- Validate accessibility
- Test SSR compatibility

### 4. Assign Specialist Agents

Select appropriate agents for each task:

**Available Specialist Agents:**
- `code-reuser-scout` - Find existing patterns (ALWAYS RUN FIRST)
- `nanostore-state-architect` - Nanostores with BaseStore pattern
- `vue-architect` - Vue 3 components, Composition API, SSR
- `astro-architect` - Astro pages, layouts, API routes
- `tailwind-styling-expert` - Responsive design, dark mode
- `typescript-validator` - Type safety, Zod schemas
- `appwrite-integration-specialist` - Appwrite backend
- `vue-testing-specialist` - Component/unit tests

**Assignment Criteria:**
- One agent per clear responsibility
- Specify deliverables for each agent
- Define success criteria
- Note execution order (sequential vs parallel)

---

## Output Requirements

Create `MASTER_PLAN.md` with:

### Header
```markdown
# Master Plan: {{FEATURE_NAME}}

**Feature:** {{FEATURE_DESCRIPTION}}
**Date:** [today's date]
**Type:** New Feature (from scratch)
**Based on:** PRE_ANALYSIS.md

---

## Summary

**What's Being Built:** [concise description]

**Approach:** [architecture summary - which levels of hierarchy used]

**Impact:** [estimated complexity - Small/Medium/Large]

**Key Decisions:**
- Using VueUse: [list composables]
- Reusing existing: [list components/composables]
- Creating new: [list what needs to be built]

---
```

### Phase 1: Foundation
```markdown
## Phase 1: Foundation (Stores & Composables)

**Goal:** Establish data layer and reusable logic

### Task 1.1: Store/State Management

**Agent:** nanostore-state-architect

**Create:** `src/stores/{{FEATURE_NAME}}Store.ts`

**Requirements:**
- Extend BaseStore (if Appwrite integration needed)
- Define state structure
- Implement actions: [list actions needed]
- Implement getters: [list getters needed]
- Zod schema validation matching Appwrite attributes

**Success Criteria:**
- [ ] Store created with TypeScript types
- [ ] All CRUD operations implemented
- [ ] Zod validation complete
- [ ] SSR-safe initialization

---

### Task 1.2: Composables

**Agent:** vue-architect

**Action:** [Create new / Extend existing]

**File:** `src/composables/use{{FeatureName}}.ts`

**Use VueUse:**
- `useComposable1()` - [purpose from PRE_ANALYSIS.md]
- `useComposable2()` - [purpose from PRE_ANALYSIS.md]

**Custom Logic Needed:**
- [What VueUse doesn't provide]
- [Business logic specific to feature]

**Success Criteria:**
- [ ] VueUse composables integrated
- [ ] Custom logic encapsulated
- [ ] SSR-safe (useMounted for client-only)
- [ ] TypeScript types complete

---

### Task 1.3: Type Definitions

**Agent:** typescript-validator

**Create:** `src/types/{{feature}}.ts`

**Requirements:**
- Interface for store state
- Interface for component props
- Type for API responses
- Zod schemas for runtime validation

**Success Criteria:**
- [ ] All types defined
- [ ] Zod schemas match Appwrite attributes
- [ ] No 'any' types
- [ ] Strict mode passing
```

### Phase 2: Core Implementation
```markdown
## Phase 2: Core Implementation (Components & Pages)

**Goal:** Build UI layer using foundation from Phase 1

### Task 2.1: Main Component

**Agent:** vue-architect

**Action:** [Create new / Compose existing]

**File:** `src/components/vue/{{Category}}/{{ComponentName}}.vue`

**Base Components to Reuse:** (from PRE_ANALYSIS.md)
- `BaseButton.vue` - [how it's used]
- `BaseCard.vue` - [how it's used]

**Requirements:**
- Use Composition API with <script setup lang="ts">
- Props with `withDefaults()`
- Slots for flexibility: [list slots needed]
- Integrate with store: `use{{Feature}}Store()`
- Integrate with composables: `use{{Feature}}()`

**Success Criteria:**
- [ ] Component functional
- [ ] Props properly typed
- [ ] Slots implemented
- [ ] Tailwind + dark: classes
- [ ] SSR-safe (useMounted for client code)
- [ ] ARIA labels complete

---

### Task 2.2: Supporting Components (if needed)

[List additional components following same pattern]

---

### Task 2.3: Astro Page (if needed)

**Agent:** astro-architect

**Create:** `src/pages/{{feature}}.astro`

**Requirements:**
- SSR data fetching in frontmatter
- Pass props to Vue components
- Client directives: client:load / client:visible
- Error handling
- Loading states

**Success Criteria:**
- [ ] Page renders on server
- [ ] Data fetched server-side
- [ ] Vue components hydrate properly
- [ ] No hydration mismatches
```

### Phase 3: Enhancement
```markdown
## Phase 3: Enhancement (Styling & Safety)

**Goal:** Complete polish and safety checks

### Task 3.1: Styling Completion

**Agent:** tailwind-styling-expert

**Requirements:**
- Complete dark mode (all colors have dark: variants)
- Responsive design (mobile-first)
- Consistent spacing using design system tokens
- Accessibility: color contrast 4.5:1 minimum

**Success Criteria:**
- [ ] Dark mode complete
- [ ] Mobile responsive
- [ ] Design tokens used (no hardcoded colors)
- [ ] WCAG AA compliant

---

### Task 3.2: TypeScript Validation

**Agent:** typescript-validator

**Requirements:**
- Fix any type errors
- Ensure strict mode passing
- No 'any' types
- Zod schemas complete

**Success Criteria:**
- [ ] `pnpm run typecheck` passes
- [ ] No type errors
- [ ] Strict mode compliant

---

### Task 3.3: SSR Safety Check

**Agent:** ssr-debugger (if issues found)

**Check For:**
- Browser APIs used in SSR context
- useMounted wrapper for client-only code
- Hydration mismatches
- Memory leaks

**Success Criteria:**
- [ ] No SSR errors
- [ ] Hydration successful
- [ ] Client-only code properly wrapped
```

### Phase 4: Quality Assurance
```markdown
## Phase 4: Quality Assurance

**Goal:** Validate implementation with tests and checks

### Task 4.1: Component Tests

**Agent:** vue-testing-specialist

**Create:** `__tests__/{{feature}}.test.ts`

**Test Coverage:**
- Unit tests for composables
- Component tests for Vue components
- Integration tests for feature workflows
- Edge case handling
- Error states

**Success Criteria:**
- [ ] >80% coverage
- [ ] All tests passing
- [ ] Edge cases covered

---

### Task 4.2: Validation

**Run:**
- `pnpm run typecheck`
- `pnpm run lint`
- `pnpm run test`
- `pnpm run build`

**Manual Testing:**
- [ ] Feature works as described
- [ ] Responsive on mobile
- [ ] Dark mode works
- [ ] SSR renders correctly
- [ ] No console errors
```

### Success Criteria
```markdown
## Success Criteria

**Feature Complete When:**
- [ ] All phases completed
- [ ] All automated checks pass
- [ ] All agents report success
- [ ] Feature works as described in requirements
- [ ] No breaking changes to existing code
- [ ] Documentation updated (if needed)

**Acceptance:**
- User can [core functionality]
- Feature integrates with existing code
- No regressions in existing features
- Performance acceptable
```

### Implementation Effort Estimate
```markdown
## Implementation Effort Estimate

**Phase 1 - Foundation:**
- Files: [N] (stores, composables, types)
- Estimated LOC: ~[X]
- Agents: [list]

**Phase 2 - Core:**
- Files: [N] (components, pages)
- Estimated LOC: ~[X]
- Agents: [list]

**Phase 3 - Enhancement:**
- Files: [N] (styling, safety)
- Estimated LOC: ~[X]
- Agents: [list]

**Phase 4 - Quality:**
- Files: [N] (tests)
- Estimated LOC: ~[X]
- Agents: [list]

**Total Estimated Effort:** [Low/Medium/High]
**Estimated Time:** [X-Y hours]
```

---

## Critical Success Factors

Your plan must:

✅ **Focus on WHAT** needs to be done, not HOW to implement it
✅ **Leave technical details** to specialist agents
✅ **Leverage ALL reusability** from PRE_ANALYSIS.md
✅ **Follow architecture hierarchy** (VueUse → Composables → Stores → Components)
✅ **Assign clear agents** with specific deliverables
✅ **Enable parallel execution** where tasks are independent
✅ **Define success criteria** for each phase
✅ **Minimize new code** by reusing existing patterns

---

**Remember:** You are the orchestrator. Create a clear roadmap that empowers specialist agents to excel at their tasks while ensuring everything works together.

**Output Location:** `{{WORKSPACE_PATH}}/MASTER_PLAN.md`
