---
name: Enhance Existing Feature
type: feature-development
status: production-ready
updated: 2025-10-16
---

# Workflow: Enhance Existing Feature

**Goal**: Add functionality to an existing feature without code duplication

**Duration**: 1-3 hours (depends on complexity)
**Complexity**: Medium
**Principle**: Code reuse first, then implement

---

## Steps

### 1. Scout for Reusable Code
Invoke `code-reuser-scout`

**Agent**: `code-reuser-scout` analyzes existing patterns

**What to find:**
- Existing components that could be extended
- Composables solving similar problems
- Stores managing related state
- Utilities handling same data types
- Base components to compose

**Reports:**
- Exact matches (use as-is)
- Near matches (extend with new props/slots)
- Base components (compose from)
- VueUse alternatives (leverage existing)
- No match (safe to create new)

### 2. Research VueUse Composables
Use `documentation-researcher` for VueUse patterns

**Agent**: `documentation-researcher` searches local docs

**Example queries:**
- "VueUse composable for sorting arrays"
- "VueUse composable for debouncing search"
- "VueUse composable for drag and drop"

**Action:**
- Check if VueUse solves it (80% of cases)
- Use existing composable
- Extend with app-specific logic

### 3. Conditional Web Research
If needed, use `web-researcher`

**Agent**: `web-researcher` searches for latest 2025 patterns

**When:**
- Latest patterns not in local docs
- Framework just released new features
- Need to compare multiple solutions

**Example:**
- "Vue 3.5 new reactivity features"
- "Latest Astro SSR patterns 2025"

### 4. Extend Existing Code
Based on findings:

**If Exact Match:**
- Use component/composable as-is
- No new code needed

**If Near Match:**
- Add new props/slots to extend
- Add new actions to store
- Add new methods to composable
- Maintain backward compatibility

**If Base Component:**
- Compose new component from base
- Add specific functionality
- Reuse styling and structure

**If No Match:**
- Create new following established patterns
- Use same naming conventions
- Integrate with existing stores if applicable

### 5. Test & Validate
Add tests for new functionality

**Agent**: `vue-testing-specialist` adds tests

**Test:**
- New feature works
- Old feature still works (regression)
- Integration with existing code
- Edge cases

---

## Agent Orchestration

```
code-reuser-scout → documentation-researcher (VueUse) →
[conditional: web-researcher] → vue-architect (if extending components) →
nanostore-state-architect (if state needed) → vue-testing-specialist (if adding tests) →
typescript-validator (ensure types)
```

---

## Example: Add "Sort by Date" to Posts List

### Step 1: Scout
```
Claude: [Invokes code-reuser-scout]
Scout: "Found existing sort composable in src/composables/useSort.ts
        Currently sorts by title and author. Can extend with date sort.
        Also found FilterSortBar component with dropdown - can add date option."
```

### Step 2: Check VueUse
```
Claude: [Invokes documentation-researcher]
Query: "VueUse composable for sorting arrays"
Result: "Found useSorted from @vueuse/core - reactive array sorting.
         Documentation shows it handles reactive sort keys and orders."
```

### Step 3: No web research needed
Local patterns sufficient.

### Step 4: Extend existing code

**Extend composable:**
```typescript
// composables/useSort.ts
import { useSorted } from '@vueuse/core';

export type SortKey = 'title' | 'author' | 'date'; // Add 'date'
export type SortOrder = 'asc' | 'desc';

export function useSort(
  items: Ref<Item[]>,
  sortKey: Ref<SortKey> = ref('date'),
  order: Ref<SortOrder> = ref('desc')
) {
  const sorted = useSorted(items, (a, b) => {
    let aVal, bVal;

    switch (sortKey.value) {
      case 'date':
        aVal = a.createdAt;
        bVal = b.createdAt;
        break;
      // ... existing cases
    }

    return order.value === 'asc' ? compare(aVal, bVal) : compare(bVal, aVal);
  });

  return { sorted, sortKey, order };
}
```

**Extend component:**
```vue
<!-- components/FilterSortBar.vue -->
<script setup lang="ts">
const sortOptions = [
  { label: 'Title', value: 'title' },
  { label: 'Author', value: 'author' },
  { label: 'Date', value: 'date' }, // Add date option
];
</script>

<template>
  <div class="filters">
    <select v-model="sortKey" class="...">
      <option v-for="opt in sortOptions" :key="opt.value" :value="opt.value">
        {{ opt.label }}
      </option>
    </select>
  </div>
</template>
```

### Step 5: Test
```typescript
it('should sort by date', () => {
  const items = [
    { id: 1, title: 'Old', createdAt: new Date('2025-01-01') },
    { id: 2, title: 'New', createdAt: new Date('2025-01-10') },
  ];

  const { sorted } = useSort(ref(items), ref('date'), ref('desc'));

  expect(sorted.value[0].id).toBe(2); // New post first
});
```

---

## Decision Tree

```
Start: "Add new feature"
  ↓
code-reuser-scout: "Does this already exist?"
  ↓
  YES → Use as-is, done!
  ↓
  MAYBE → "Can we extend it?"
    ↓
    YES → Extend with new props/actions
    ↓
    NO → "Is there a base component?"
      ↓
      YES → Compose from base
      ↓
      NO → Create new (follow patterns)
  ↓
  NO → Check VueUse / local docs
    ↓
    FOUND → Use / integrate
    ↓
    NOT FOUND → Check web / create new
  ↓
Test & validate
```

---

## Code Reuse Strategy

### Before Adding Feature:
1. Search for exact match (component/composable/store)
2. Search for similar functionality
3. Look for base patterns to extend
4. Check VueUse for 80% solutions
5. Only then create new code

### When Extending:
- Add new prop with default (backward compatible)
- Add optional slot
- Add new store action
- Add new composable parameter
- Never remove existing functionality

### When Composing:
- Inherit base styling/structure
- Add specific customizations
- Reuse slots where applicable
- Maintain consistent naming

---

## Related Workflows

- [Debug Existing Feature](./07-debug-existing-feature.md)
- [Create Feature Page](./01-create-feature-page.md)
- [Test-Driven Development](./08-test-driven-development.md)

---

**Time Estimate**: 1-3 hours | **Complexity**: Medium | **Status**: ✅ Production Ready
