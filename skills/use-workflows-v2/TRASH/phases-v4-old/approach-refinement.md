# Phase 5: Approach Refinement

## Overview

Deep dive into chosen approach with detailed implementation strategy and optional architecture specialist.

## Step 1: Load Chosen Approach

**Conditional subagent spawning** - May spawn architecture-specialist if complex.

Read user's selection from previous phase:
- Selected approach from `{{workspace}}/{{output_dir}}/approaches.json`
- Any modifications or hybrid elements discussed

## Step 2: Spawn Architecture Specialist (Conditional)

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `description`: "{{task_description}}"

**Spawned if:** Complexity flag set or user requested detailed architecture

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="Create detailed implementation strategy for {{feature_name}}",
  prompt="Design detailed implementation strategy for selected approach. Include: component architecture, data flow, API contracts, state management, file organization. Consider {{scope}} scope. Output to {{workspace}}/{{output_dir}}/{{deliverable_filename}}"
)
```

**Expected Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

{{^subagents}}
**No subagents spawned** - Main agent will refine approach directly.
{{/subagents}}

{{#subagents}}
## Step 3: Wait for Architecture Specialist

Wait for subagent to complete.

Monitor Task tool status. Verify output file exists once complete.
{{/subagents}}

## Step {{#subagents}}4{{/subagents}}{{^subagents}}3{{/subagents}}: Create Detailed Strategy

{{#subagents}}
Read architecture specialist output and enhance with additional details.
{{/subagents}}

{{^subagents}}
Main agent creates detailed implementation strategy.
{{/subagents}}

Write to: `{{workspace}}/{{output_dir}}/refined-approach.md`

Include:

### 1. Implementation Strategy

**Architecture Overview:**
- High-level component structure
- How components interact
- Where this fits in existing architecture

**Data Flow:**
- How data enters the system
- Transformations along the way
- Where data is stored/cached
- How data exits the system

**State Management:**
- What state needs to be managed
- Where state lives (nanostore, Vue reactive, Appwrite, etc.)
- How state updates propagate

### 2. Specific Files to Modify/Create

**Files to Create:**
```
src/components/[Component].vue - [Purpose]
src/composables/use[Name].ts - [Purpose]
src/stores/[Store].ts - [Purpose]
```

**Files to Modify:**
```
src/[existing-file].ts - [What changes]
```

### 3. Technical Challenges

**Challenge 1:** [Description]
- **Why it's challenging:** [Explanation]
- **Solution approach:** [How to handle]
- **Fallback plan:** [If primary approach fails]

**Challenge 2:** [Description]
- [Same structure]

### 4. Validation Strategy

**How to verify approach is working:**
1. [Verification step 1]
2. [Verification step 2]
3. [Verification step 3]

**Success indicators:**
- [ ] [Indicator 1]
- [ ] [Indicator 2]

### 5. Potential Blockers

**Blocker 1:** [Description]
- **Likelihood:** [High/Medium/Low]
- **Mitigation:** [How to prevent/resolve]

**Blocker 2:** [Description]
- [Same structure]

## Step {{#subagents}}5{{/subagents}}{{^subagents}}4{{/subagents}}: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Approach refinement has gaps:

[List specific missing elements]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step {{#subagents}}6{{/subagents}}{{^subagents}}5{{/subagents}}: Checkpoint Review

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
## Step {{#subagents}}6{{/subagents}}{{^subagents}}5{{/subagents}}: Investigation Complete

Approach refinement complete. Ready to move to planning workflow.

User can now invoke: `plan-writing-workflow`
{{/checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}
- `{{workspace}}/{{output_dir}}/refined-approach.md` - Detailed implementation strategy

## Success Criteria

- ✓ Detailed strategy created
- ✓ Specific files identified
- ✓ Technical challenges documented
- ✓ Validation strategy defined
- ✓ Blockers identified with mitigation
- ✓ Ready for detailed planning
