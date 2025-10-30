# Code Scout Template: Add to Existing Feature

**Purpose:** Map existing feature and identify extension points for adding functionality

---

## Mission: Map Existing Feature + Find Extension Opportunities

You are analyzing **EXISTING FEATURE: {{FEATURE_NAME}}** to prepare for adding **{{ADDITION_DESCRIPTION}}**

---

## DUAL MISSION

### Mission 1: Map Existing Feature (Complete Feature Discovery)

#### 1.1 Find ALL Files Related to Existing Feature
- **Components** that implement it (search: `src/components/`, `*{{FEATURE_NAME}}*`, similar names)
- **Stores** that manage its state (search: `src/stores/`, `*{{FEATURE_NAME}}*Store*`)
- **Composables** that provide its logic (search: `src/composables/`, `use*{{FEATURE_NAME}}*`)
- **API routes** that support it (search: `src/pages/api/`, `src/api/`)
- **Types** that define it (search: `src/types/`, `*{{FEATURE_NAME}}*.ts`)
- **Tests** that cover it (search: `__tests__/`, `*.test.ts`, `*.spec.ts`)

#### 1.2 Trace Complete Data Flow
Map how data moves through the feature:
```
User Interaction (Component)
  ↓
Composable/Hook (Logic)
  ↓
Store/State (State Management)
  ↓
API Route/Service (Backend)
  ↓
Response flows back up
```

Document:
- How data enters this feature
- Which stores manage its state
- Which composables provide its logic
- Which components consume the data
- How it connects to backend APIs

#### 1.3 Document Existing Architecture Patterns
- Component naming conventions for this feature
- Store organization for this feature
- Composable composition patterns
- Type definitions structure
- API endpoint patterns

---

### Mission 2: Find Reusable Code for Addition

#### 2.1 Search for Existing Code That Provides "{{ADDITION_DESCRIPTION}}"
- **Exact matches** - Code that already does exactly this (100% match)
- **Near matches** - Code that does 70-90% of this (can be extended)
- **Base components** - Components that could be extended with new props/slots
- **Similar implementations** - Features elsewhere that do something similar

#### 2.2 Identify Extension Points
Where can "{{ADDITION_DESCRIPTION}}" be added to existing feature?
- **Components** that need new props/slots/methods
- **Stores** that need new actions/getters/state
- **Composables** that need new functionality
- **Types** that need new properties
- **API routes** that need new endpoints/parameters

#### 2.3 Check VueUse for Addition
Before creating custom code, check if VueUse provides:
- Composables that implement "{{ADDITION_DESCRIPTION}}" functionality
- Patterns that simplify implementation
- Utilities that reduce custom code

Search: https://vueuse.org or local docs

---

## Output Requirements

Create `PRE_ANALYSIS.md` in workspace with:

### Section 1: Existing Feature Map
```markdown
## Feature: {{FEATURE_NAME}}

### Files Involved
**Components:**
- `src/components/FeatureComponent.vue` - [what it does]
- [List all components]

**Stores:**
- `src/stores/FeatureStore.ts` - [state managed]
- [List all stores]

**Composables:**
- `src/composables/useFeature.ts` - [logic provided]
- [List all composables]

**API Routes:**
- `src/pages/api/feature/index.json.ts` - [endpoints]
- [List all routes]

**Types:**
- `src/types/feature.ts` - [types defined]
- [List all type files]

### Data Flow
[Describe how data flows through the feature]
```

### Section 2: Current Implementation Analysis
```markdown
## How {{FEATURE_NAME}} Currently Works

### User Flow
1. User [action]
2. Component calls [composable/method]
3. Store [updates state]
4. API [fetches/updates data]
5. UI [reflects changes]

### Architecture Patterns Used
- Component pattern: [describe]
- State pattern: [describe]
- API pattern: [describe]

### Key Integration Points
- [Where other features connect]
- [Where new functionality could integrate]
```

### Section 3: Reusable Code for Addition
```markdown
## Existing Code for "{{ADDITION_DESCRIPTION}}"

### Exact Matches (100% - Already Exists)
- `ComponentName` - Already implements this functionality
- [If found, recommend: REUSE, don't recreate]

### Near Matches (70-90% - Can Extend)
- `ComponentName` - Does [X] but needs [Y] added
- [Recommendation: EXTEND with new props/methods]

### Base Components to Compose
- `BaseComponent` - Can be composed with new functionality
- [Recommendation: COMPOSE new wrapper]

### Similar Implementations
- `SimilarFeature` - Uses pattern [X] which we can follow
- [Recommendation: FOLLOW PATTERN]
```

### Section 4: Extension Strategy
```markdown
## Recommended Extension Points

### Extend Existing Components
- **File:** `src/components/ExistingComponent.vue`
- **Changes:** Add props: `[newProp]`, Add slots: `[newSlot]`
- **Rationale:** [why extend vs create new]

### Extend Existing Stores
- **File:** `src/stores/ExistingStore.ts`
- **Changes:** Add actions: `[newAction]`, Add getters: `[newGetter]`
- **Rationale:** [why extend vs create new]

### Extend Existing Composables
- **File:** `src/composables/useExisting.ts`
- **Changes:** Add functionality: `[newFunction]`
- **Rationale:** [why extend vs create new]

### New Files Needed (Only if Extension Not Possible)
- `src/components/NewComponent.vue` - [why necessary]
- [List only truly new files needed]
```

### Section 5: VueUse Opportunities
```markdown
## VueUse Composables for Addition

- `useComposable()` - Provides [functionality for addition]
- [List VueUse alternatives that simplify implementation]

## Custom Code Needed
- [What custom code is still needed after VueUse]
```

### Section 6: Integration Recommendations
```markdown
## How to Integrate Addition

### Minimal Change Approach
1. Modify [existing file] to add [specific change]
2. Extend [existing component] with [new prop/slot]
3. Add [new action] to [existing store]

### Backward Compatibility
- All new props: Optional with defaults
- All new functionality: Additive (doesn't change existing behavior)
- Existing tests: Should still pass

### Integration Points
- [Where new code connects to existing feature]
- [What existing code calls new functionality]
```

---

## Critical Success Factors

✅ **Complete mapping** - Find ALL files related to existing feature
✅ **Trace data flow** - Understand how feature currently works
✅ **Extension-first mindset** - Prefer extending existing over creating new
✅ **Minimal changes** - Change only what's necessary
✅ **Backward compatibility** - Don't break existing functionality
✅ **VueUse first** - Check VueUse before custom implementation

---

**Output Location:** `{{WORKSPACE_PATH}}/PRE_ANALYSIS.md`
