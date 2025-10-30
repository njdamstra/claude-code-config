# Plan Master Template: Add to Existing Feature

**Purpose:** Create minimal-change implementation plan for extending existing feature

---

## Your Task

Create plan for adding **"{{ADDITION_DESCRIPTION}}"** to existing feature **{{FEATURE_NAME}}**

**Based on:** `{{WORKSPACE_PATH}}/PRE_ANALYSIS.md` (read this first!)

---

## Planning Philosophy: EXTENSION-FIRST, MINIMAL CHANGES

🎯 **Primary Goal:** Extend existing code rather than create new

**Priority Order:**
1. **Extend existing files** (add props, methods, slots)
2. **Compose existing components** (wrapper pattern)
3. **Create new files** (ONLY if extension impossible)

**Key Principle:** Change least amount of code necessary while achieving the goal

---

## Planning Requirements

### 1. Extension-First Approach

**Review PRE_ANALYSIS.md for:**
- Existing components that need new props/slots
- Existing stores that need new actions/getters
- Existing composables that need new methods
- Extension points identified

**Plan modifications to existing files:**
```markdown
### Extend: `src/components/ExistingComponent.vue`

**Add Props:**
- `newProp: string` - [purpose]

**Add Slots:**
- `#newSlot` - [purpose]

**Add Methods:**
- `handleNewAction()` - [purpose]

**Rationale:** Extending keeps code centralized, maintains patterns
```

### 2. Minimal Changes Philosophy

**For each change, ask:**
- Can I add optional props instead of required ones?
- Can I use defaults to preserve existing behavior?
- Can I make this additive (not changing existing code)?
- Will existing tests still pass?

**Backward Compatibility Checklist:**
- [ ] All new props are optional with defaults
- [ ] Existing component API unchanged
- [ ] Existing functionality preserved
- [ ] Existing tests still pass

### 3. Integration Strategy

**Map integration points:**
- Where does new functionality connect to existing?
- Which existing code calls new functionality?
- How does data flow through feature + addition?

**Example:**
```
Existing Flow:
User → ComponentA → Store → API

Enhanced Flow:
User → ComponentA (with new prop) → Store (with new action) → API (new endpoint)
```

### 4. Follow Architecture Hierarchy

Same hierarchy as "new" features:
1. VueUse composables (if available)
2. Extend existing composables OR create new
3. Extend existing stores OR create new
4. Extend existing components OR create new

**But prefer extending over creating!**

### 5. Assign Specialist Agents

Same agents as "new" features, but focus on **modification** tasks:
- `code-reuser-scout` - ALWAYS RUN FIRST (find more reuse opportunities)
- `nanostore-state-architect` - Extend existing stores
- `vue-architect` - Extend existing components
- `typescript-validator` - Update types, maintain safety
- `tailwind-styling-expert` - Style additions

---

## Output Requirements

Create `MASTER_PLAN.md` with:

### Header
```markdown
# Master Plan: Adding "{{ADDITION_DESCRIPTION}}" to {{FEATURE_NAME}}

**Feature:** {{FEATURE_NAME}}
**Addition:** {{ADDITION_DESCRIPTION}}
**Date:** [today's date]
**Type:** Feature Extension
**Based on:** PRE_ANALYSIS.md

---

## Summary

**What's Being Added:** [concise description]

**Approach:** [Extension vs Creation summary]
- Extending: [N] existing files
- Creating: [N] new files (only if necessary)

**Impact:** [Small/Medium/Large change]

**Backward Compatible:** [Yes/No/Partial]
- [Explanation of compatibility]

**Key Decisions:**
- **Extension Strategy:** [Which files extended and why]
- **Integration Points:** [Where new connects to existing]
- **Reusability:** [What existing code leveraged]

---
```

### Phase 1: Foundation
```markdown
## Phase 1: Foundation (Extend/Create Stores & Composables)

**Goal:** Extend data layer OR create new only if necessary

### Task 1.1: Store/State Management

**Agent:** nanostore-state-architect

**Action:** [EXTEND existing / CREATE new]

**File:** `src/stores/{{feature}}Store.ts` (existing)

**If EXTENDING:**

**Add to Existing Store:**
- **New State:**
  ```typescript
  // Add to existing state interface
  newProperty: string
  ```
- **New Actions:**
  - `addNewAction()` - [purpose]
  - [List actions]
- **New Getters:**
  - `getNewValue()` - [purpose]

**Rationale:** [Why extending existing store vs creating new]

**Backward Compatibility:**
- New state properties initialized with safe defaults
- Existing actions unchanged
- Existing getters unchanged

**If CREATING NEW:**
[Only if extension impossible - document why]

**Success Criteria:**
- [ ] Existing store extended (or new created if necessary)
- [ ] New actions/getters implemented
- [ ] Backward compatible
- [ ] Existing tests pass

---

### Task 1.2: Composables

**Agent:** vue-architect

**Action:** [EXTEND existing / CREATE new]

**File:** `src/composables/use{{Feature}}.ts` (existing)

**If EXTENDING:**

**Add to Existing Composable:**
```typescript
// Extend existing composable
export function useFeature() {
  // ... existing code ...

  // NEW: Add functionality for {{ADDITION_DESCRIPTION}}
  const newMethod = () => {
    // implementation
  }

  return {
    // ... existing exports ...
    newMethod // NEW
  }
}
```

**Rationale:** [Why extending vs creating new]

**If CREATING NEW:**
[Document why extension not possible]

**Success Criteria:**
- [ ] Composable extended/created
- [ ] New functionality works
- [ ] Existing functionality preserved
- [ ] SSR-safe
```

### Phase 2: Core Implementation
```markdown
## Phase 2: Core Implementation (Extend/Create Components)

**Goal:** Extend UI layer with minimal changes

### Task 2.1: Main Component Extension

**Agent:** vue-architect

**Action:** EXTEND existing

**File:** `src/components/vue/{{Category}}/{{Component}}.vue` (existing)

**Add to Component:**

**New Props (Optional with Defaults):**
```typescript
interface Props {
  // ... existing props ...
  newProp?: string // NEW - optional!
}

const props = withDefaults(defineProps<Props>(), {
  // ... existing defaults ...
  newProp: 'default-value' // NEW - safe default
})
```

**New Slots:**
- `#newSlot` - [purpose, optional]

**New Methods:**
- `handleNewAction()` - [purpose]

**Integration:**
- [How new functionality connects to existing component logic]

**Backward Compatibility Proof:**
- Component works without new props (defaults used)
- Existing slots/methods unchanged
- Existing behavior preserved

**Success Criteria:**
- [ ] Component extended (not replaced)
- [ ] New props optional with defaults
- [ ] Existing usage still works
- [ ] Dark mode maintained
- [ ] ARIA labels updated if needed

---

### Task 2.2: New Components (Only if Needed)

[Only if extension/composition impossible]

**Why New Component Necessary:**
- [Can't extend existing because...]
- [Composition doesn't work because...]
- [Truly new functionality that doesn't fit]

[Follow same structure as "new" template if needed]
```

### Phase 3: Integration
```markdown
## Phase 3: Integration

**Goal:** Wire new functionality into existing feature seamlessly

### Task 3.1: Integration Points

**Where New Code Connects:**

**Point 1:** [Component A uses new Store action]
```typescript
// In ComponentA.vue
const store = useFeatureStore()

// NEW: Call new action
const handleClick = () => {
  store.newAction()
}
```

**Point 2:** [Component B receives new prop]
```typescript
// In parent component
<ComponentB :new-prop="value" />
```

**Data Flow:**
```
User Action
  ↓
Component (with new prop/method)
  ↓
Composable (extended with new logic)
  ↓
Store (extended with new action)
  ↓
API (new endpoint OR extended existing)
  ↓
Response flows back
```

**Success Criteria:**
- [ ] All integration points identified
- [ ] Data flows correctly
- [ ] No broken connections
- [ ] Error handling maintained

---

### Task 3.2: Backward Compatibility Verification

**Verify:**
- [ ] Existing tests pass WITHOUT changes
- [ ] Component works without new props
- [ ] Default behavior unchanged
- [ ] No breaking changes to public API

**Migration Required?**
- [ ] None (fully backward compatible)
- [ ] Optional (enhancement available, not required)
- [ ] Required (document migration steps)
```

### Phase 4: Quality Assurance
```markdown
## Phase 4: Quality Assurance

**Goal:** Validate addition AND ensure no regressions

### Task 4.1: New Functionality Tests

**Agent:** vue-testing-specialist

**Create:** `__tests__/{{feature}}-addition.test.ts`

**Test Coverage:**
- [ ] New functionality works
- [ ] New props behave correctly
- [ ] New store actions work
- [ ] Integration works
- [ ] Edge cases covered

---

### Task 4.2: Regression Testing

**Critical:** Test existing functionality

**Run Existing Tests:**
- [ ] All existing tests pass
- [ ] No test modifications needed (proof of backward compatibility)

**Manual Regression Testing:**
- [ ] Existing workflows still work
- [ ] Existing UI unchanged (unless intentionally enhanced)
- [ ] No console errors
- [ ] No performance degradation

**Success Criteria:**
- [ ] New tests pass
- [ ] ALL existing tests pass
- [ ] No regressions detected
```

### Success Criteria
```markdown
## Success Criteria

**Addition Complete When:**
- [ ] "{{ADDITION_DESCRIPTION}}" functionality working
- [ ] Minimal code changes achieved
- [ ] Backward compatibility maintained
- [ ] All tests passing (existing + new)
- [ ] No regressions in existing features
- [ ] Pattern consistency preserved

**Metrics:**
- Files modified: [N]
- Files created: [N] (minimize this!)
- Lines changed: ~[X] (minimize this!)
- Breaking changes: [0 - target]
```

### Implementation Effort Estimate
```markdown
## Implementation Effort Estimate

**Extension Complexity:** [Low/Medium/High]

**Files Modified:** [list existing files to modify]
**Files Created:** [list new files only if necessary]

**Phase 1 - Foundation:**
- Extend [N] stores/composables
- Estimated LOC: ~[X]

**Phase 2 - Implementation:**
- Extend [N] components
- Estimated LOC: ~[X]

**Phase 3 - Integration:**
- Integration points: [N]
- Estimated LOC: ~[X]

**Phase 4 - Quality:**
- New tests: ~[X] LOC
- Regression tests: Existing

**Total Estimated Effort:** [Low/Medium/High]
**Estimated Time:** [X-Y hours]
```

---

## Critical Success Factors

Your plan must:

✅ **Extension-first mindset** - Modify existing before creating new
✅ **Minimal changes** - Touch only what's necessary
✅ **Backward compatible** - Existing code works unchanged
✅ **Preserve patterns** - Follow existing conventions
✅ **Clear integration** - Document how new connects to existing
✅ **Regression-proof** - Existing tests pass without modification

**Remember:** The best addition is one that feels native to the existing codebase, not bolted on.

---

**Output Location:** `{{WORKSPACE_PATH}}/MASTER_PLAN.md`
