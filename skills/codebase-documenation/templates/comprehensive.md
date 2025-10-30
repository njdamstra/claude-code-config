

# Documentation Template

Use this structure when synthesizing findings into final documentation.

## Standard Documentation Structure


# [Topic Name]

## Overview

[2-3 sentence high-level description of what this topic covers]

**Purpose:** [Why this exists in the codebase]
**Location:** [Primary file/directory locations]
**Stack:** [Technologies used: Vue3, TypeScript, nanostore, etc.]

## Architecture

### Component Structure

[Diagram or description of how components are organized]

[topic]/
├── components/
│   ├── MainComponent.vue
│   └── SubComponent.vue
├── composables/
│   └── useTopicLogic.ts
└── types/
    └── topic.types.ts

### Data Flow

1. [Entry point]
2. [Processing steps]
3. [Output/side effects]

[Optionally include ASCII diagram of data flow]

### Integration Points

- **[System A]**: [How it integrates]
- **[System B]**: [How it integrates]
- **[External Service]**: [API calls, webhooks, etc.]

## Core Components

### [Component Name]

**File:** `path/to/component.vue`
**Purpose:** [What it does]

**Props:**
- `propName` (Type): Description
- `propName2` (Type): Description

**Emits:**
- `eventName` (PayloadType): When triggered

**Key Features:**
- Feature 1
- Feature 2

**Implementation Notes:**
[Important details about how it works]

### [Another Component]

[Same structure as above]

## Composables & Utilities

### useTopicLogic()

**File:** `path/to/composable.ts`
**Purpose:** [What it provides]

**Returns:**
```typescript
{
  state: Ref<StateType>,
  action: (param: Type) => void,
  computed: ComputedRef<Type>
}
```

**Usage Example:**
```typescript
import { useTopicLogic } from '@/composables/useTopicLogic'

const { state, action, computed } = useTopicLogic()

// Use the composable
action(someValue)
```

**Implementation Details:**
[How it works internally]

## Patterns & Conventions

### Naming Conventions

- **Components:** PascalCase (e.g., `UserProfile.vue`)
- **Composables:** camelCase with `use` prefix (e.g., `useAuth.ts`)
- **Types:** PascalCase with `.types.ts` suffix
- **Utilities:** camelCase (e.g., `formatDate.ts`)

### Composition Patterns

**Pattern: [Pattern Name]**

[Description of the pattern]

**Example:**
```typescript
// Example code showing pattern
```

**When to Use:**
[Guidance on when this pattern applies]

## Usage Examples

### Basic Usage

```vue
<script setup lang="ts">
import { Component } from '@/components/topic'

// Setup code
</script>

<template>
  <Component />
</template>
```

### Advanced Usage

```typescript
// More complex example showing edge cases
```

### Common Scenarios

#### Scenario 1: [Common Use Case]

```typescript
// Code example
```

#### Scenario 2: [Another Use Case]

```typescript
// Code example
```

## Dependencies

### Internal Dependencies

- **[Module]** (`path/to/module`): [How it's used]
- **[Module]** (`path/to/module`): [How it's used]

### External Dependencies

- **[Package]** (`version`): [Purpose and usage]
- **[Package]** (`version`): [Purpose and usage]

### Type Dependencies

```typescript
import type { TypeName } from '@/types/topic.types'
```

## State Management

### nanostore Integration

**Store:** `path/to/store.ts`

```typescript
import { atom, map } from 'nanostores'

export const topicStore = map({
  // Store structure
})
```

**Usage in Components:**
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { topicStore } from '@/stores/topic'

const $topic = useStore(topicStore)
</script>
```

## API Integration

### Appwrite Functions

**Function:** `functionName`
**Endpoint:** `/v1/functions/[id]/executions`
**Purpose:** [What this serverless function does]

**Request:**
```typescript
{
  // Request payload structure
}
```

**Response:**
```typescript
{
  // Response structure
}
```

**Error Handling:**
```typescript
try {
  // Function call
} catch (error) {
  // Error handling
}
```

### Database Schema

**Collection:** `collectionName`
**Structure:**
```json
{
  "field1": "type",
  "field2": "type"
}
```

## Styling Patterns

### Tailwind CSS Conventions

**Common Classes:**
- Layout: `flex`, `grid`, `container`
- Spacing: `p-4`, `m-2`, `gap-4`
- Colors: `bg-primary`, `text-secondary`

**Component-Specific Patterns:**
```html
<div class="container mx-auto p-4">
  <!-- Pattern usage -->
</div>
```

### Responsive Design

```html
<!-- Mobile-first responsive patterns -->
<div class="
  flex flex-col gap-2
  md:flex-row md:gap-4
  lg:gap-8
">
</div>
```

## Testing Considerations

### Unit Testing Approach

[How this topic should be tested]

### Integration Testing

[Key integration points to test]

### E2E Scenarios

1. [Critical user flow]
2. [Edge case scenario]

## Edge Cases & Gotchas

### Edge Case 1: [Description]

**Problem:** [What can go wrong]
**Solution:** [How to handle it]
**Example:**
```typescript
// Code showing proper handling
```

### Edge Case 2: [Description]

[Same structure]

## Performance Considerations

- **Optimization 1:** [Description and implementation]
- **Optimization 2:** [Description and implementation]

**Metrics:**
- [Performance metric and target]

## Security Considerations

- **Concern 1:** [Security consideration]
- **Mitigation:** [How it's addressed]

## Future Enhancements

- [ ] Potential improvement 1
- [ ] Potential improvement 2
- [ ] Planned refactoring

## Related Topics

- [Related Topic 1] - `[link to documentation]`
- [Related Topic 2] - `[link to documentation]`

## Changelog

- **2025-10-29:** Initial documentation created
- **[Date]:** [Update description]

---

**Last Updated:** 2025-10-29
**Verified:** ✓
**Files Analyzed:** [count]
**Coverage:** [percentage]

## Section Guidelines

### Overview Section
- Keep to 2-3 sentences maximum
- Focus on *what* and *why*, not *how*
- Include location and stack info

### Architecture Section
- Visual representations preferred (ASCII or diagrams)
- Show file structure clearly
- Map data flows explicitly
- Document all integration points

### Components Section
- One subsection per major component
- Always include file path
- Document props, emits, and key features
- Add implementation notes for complex logic

### Patterns Section
- Name patterns clearly
- Provide runnable examples
- Specify when to use each pattern

### Usage Examples Section
- Progress from basic to advanced
- All examples must be syntactically valid
- Include imports and setup
- Cover common scenarios

### Dependencies Section
- Separate internal vs. external
- Version numbers for external deps
- Explain usage, not just list

### Edge Cases Section
- Document known gotchas
- Provide solutions, not just problems
- Include code examples for handling

### Related Topics Section
- Link to other documentation in brains/
- Explain relationship briefly

---

