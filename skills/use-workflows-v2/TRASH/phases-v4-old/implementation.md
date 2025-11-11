# Phase 4: Implementation Breakdown

## Overview

Synthesize requirements and design into detailed file-by-file implementation breakdown.

## Step 1: Review Previous Phases

**No subagents spawned** - Main agent synthesizes.

Read outputs from previous phases:
- `{{workspace}}/{{output_dir}}/requirements.json` - Requirements and user stories
- `{{workspace}}/{{output_dir}}/architecture.json` - Technical design and architecture

Understand what needs to be built and how it's architected.

## Step 2: Create File-by-File Breakdown

For each file that needs to be created or modified, document:

### For New Files:

**File:** `src/[path]/[filename]`
**Purpose:** [What this file does]
**Type:** Component | Composable | Store | Utility | Type | API Route | Page

**Structure:**
```typescript
// Key imports needed
import { ... } from '...'

// Main exports
export const/interface/type [name] = ...
```

**Implementation notes:**
- [Key logic or patterns to use]
- [Important considerations]

---

### For Modified Files:

**File:** `src/[path]/[filename]`
**Changes needed:**

**1. Add import:**
```typescript
import { newThing } from '@/lib/new'
```

**2. Modify function [functionName]:**
- Add parameter: `newParam: string`
- Update logic: [description of change]

**3. Add new function:**
```typescript
export const newFunction = (param: Type) => {
  // [Key logic]
}
```

---

## Step 3: Document Import/Dependency Updates

List all import changes across the codebase:

**New dependencies (npm packages):**
```json
{
  "@library/package": "^1.2.3"
}
```

**New internal imports:**
- `ComponentA` needs to import `useNewComposable`
- `StoreB` needs to import type `NewType`

**Dependency order:**
1. Create utilities first
2. Then create composables
3. Then create stores
4. Finally create components

## Step 4: Add Code Snippets for Complex Logic

For any complex logic, provide code snippets:

**Example: Form validation logic**
```typescript
const validateForm = (data: FormData) => {
  const schema = z.object({
    field: z.string().min(3)
  })

  return schema.safeParse(data)
}
```

**Example: State update pattern**
```typescript
const updateState = (newValue: string) => {
  store.set(state => ({
    ...state,
    value: newValue
  }))
}
```

## Step 5: Write Implementation Document

Write to: `{{workspace}}/{{output_dir}}/implementation.md`

Format:
```markdown
# Implementation Breakdown

## Overview
[Brief summary of what's being built]

## Implementation Order
1. [Step 1 - what to build first]
2. [Step 2 - what to build second]
3. [Step 3 - etc.]

## Files to Create

### [File 1 path]
[Structure and implementation notes]

### [File 2 path]
[Structure and implementation notes]

## Files to Modify

### [File 1 path]
[Changes needed]

### [File 2 path]
[Changes needed]

## Import/Dependency Updates
[List of all import changes]

## Complex Logic Snippets
[Code snippets for tricky parts]

## Implementation Notes
- [Important consideration 1]
- [Important consideration 2]
```

## Step 6: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Implementation breakdown has gaps:

[List specific missing elements]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 7: Checkpoint Review

**Present to user:**

{{checkpoint_prompt}}

**Files for review:**
{{#checkpoint_show_files}}
- `{{.}}`
{{/checkpoint_show_files}}

**Ask user:**

What would you like to do next?
{{#checkpoint_options}}
{{index}}. {{value}}
{{/checkpoint_options}}

**Wait for user selection** before proceeding.
{{/checkpoint}}

{{^checkpoint}}
## Step 7: Proceed to Testing Phase

Implementation breakdown complete. No checkpoint defined.

Continue directly to Phase 5: Testing Strategy.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/implementation.md` - Detailed file-by-file breakdown

## Success Criteria

- ✓ All files identified (create + modify)
- ✓ Implementation order specified
- ✓ Import updates documented
- ✓ Complex logic has code snippets
- ✓ Ready for implementation
