# Code Scout Template: New Feature Creation

**Purpose:** Analyze codebase for creating a brand new feature from scratch

---

## Mission: Discover Project Context and Reusable Patterns

You are analyzing the codebase to prepare for creating **NEW FEATURE: {{FEATURE_NAME}}**

**Feature Description:** {{FEATURE_DESCRIPTION}}

---

## Discovery Tasks

### 1. Find Similar Features
Search for existing features that are similar to "{{FEATURE_DESCRIPTION}}":
- Components that implement similar functionality
- Stores that manage similar state
- Composables that provide similar logic
- API routes with similar patterns
- Look in: `src/components/`, `src/stores/`, `src/composables/`, `src/pages/api/`

### 2. Map Project Architecture Patterns
Document the conventions used in this codebase:
- **Component naming:** How are components named? (PascalCase, kebab-case, prefixes?)
- **Store organization:** Pinia? Zustand? Nanostores? BaseStore pattern?
- **Composable patterns:** VueUse integration? Custom composables structure?
- **Type definitions:** Where are types stored? Naming conventions?
- **API route patterns:** File structure for API routes?

### 3. Identify Reusable Code
Find existing code that could be leveraged:
- **Base components** that can be composed (buttons, inputs, cards, modals)
- **Utility functions** that provide related functionality
- **Composables** from VueUse or custom that match needs
- **Store patterns** that could be extended
- **Similar implementations** elsewhere to learn from

### 4. Check for VueUse Alternatives
Before creating custom code, check if VueUse provides:
- State management composables
- DOM interaction utilities
- Sensor/device APIs
- Animation utilities
- Browser APIs

Search: https://vueuse.org or local docs in `/Users/natedamstra/.claude/documentation/vueuse/`

### 5. Identify Tech Stack Context
Determine from `package.json` and project structure:
- Frontend framework (Vue 3? React? Astro?)
- State management library
- Styling approach (Tailwind? Scoped styles?)
- Build tools
- Testing framework

---

## Output Requirements

Create `PRE_ANALYSIS.md` in workspace with:

### Section 1: Project Context
```markdown
## Project Tech Stack
- Framework: [Vue 3 / React / etc.]
- State: [Pinia / Zustand / Nanostores]
- Styling: [Tailwind CSS / etc.]
- Build: [Vite / etc.]

## Directory Structure
src/
├── components/
├── stores/
├── composables/
├── pages/
└── types/
```

### Section 2: Similar Features Found
```markdown
## Similar Features
- **[FeatureName]** (`path/to/feature`) - [similarity %] - [why similar]
- List all relevant existing features with match percentages
```

### Section 3: Reusable Code Opportunities
```markdown
## Base Components Available
- `BaseButton.vue` - Reusable button component
- [List all base components that could be used]

## Composables Available
- `useFormValidation()` - Form validation logic
- [List custom composables]

## VueUse Composables Relevant
- `useAsyncState()` - Async state management
- [List VueUse composables that match needs]

## Store Patterns
- BaseStore extending pattern in `src/stores/BaseStore.ts`
- [Document store patterns]

## Utilities
- [List utility functions that could be reused]
```

### Section 4: Architectural Patterns
```markdown
## Component Patterns
- Naming: [convention]
- Structure: [script setup / options API]
- Props: [TypeScript interfaces / etc.]

## State Management Patterns
- [How stores are organized]
- [How state is accessed in components]

## Type Safety Patterns
- [Where types live]
- [Zod validation patterns if used]

## API Route Patterns
- [File structure for routes]
- [Response formatting conventions]
```

### Section 5: Recommendations
```markdown
## Reusability Recommendations
1. **REUSE:** [Component/function name] - Already does exactly what we need
2. **EXTEND:** [Component/function name] - Does 70-90% of what we need, extend it
3. **CREATE NEW:** [What needs to be built from scratch]

## VueUse Opportunities
- Use `useComposable()` instead of custom implementation
- [List VueUse alternatives to custom code]

## Integration Strategy
- [How new feature should integrate with existing code]
- [Where new files should be created]
- [What existing files may need modifications]
```

---

## Critical Success Factors

✅ **Be thorough** - This analysis guides the entire implementation
✅ **Find matches** - Even 50% matches are valuable (extend vs create from scratch)
✅ **Prefer reuse** - VueUse > existing custom > new custom
✅ **Document patterns** - Help maintain consistency
✅ **Think composition** - How can existing pieces combine?

---

**Output Location:** `{{WORKSPACE_PATH}}/PRE_ANALYSIS.md`
