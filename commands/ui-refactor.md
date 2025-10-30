---
description: Refactor multiple components with batch updates or composition patterns
argument-hint: [pattern] [description] [--batch] [--compose]
allowed-tools: read, write, bash, grep, str_replace, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 23, 2025
Consolidates batch-update and compose workflows
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Refactoring

Apply consistent changes across multiple components or compose existing components into new ones.

## Usage

```bash
/ui-refactor buttons/* Update to new focus-ring utility
/ui-refactor Card + Avatar + Badge --compose
/ui-refactor **/*.vue Convert borders to shadows --batch
```

**Syntax**: `/ui-refactor [pattern] [description] [--flags]`

## Flags

- `--batch` - Batch update multiple components with same changes
- `--compose` - Compose new component from existing components
- Default (no flags) - Analyze pattern and auto-detect best approach

## Workflow: Batch Updates (--batch flag)

Apply consistent changes across multiple components matching pattern.

### Step 1: Discovery
1. Find all components matching pattern
2. Count total components to update
3. Show list for user approval
4. **WAIT FOR CONFIRMATION** before proceeding

### Step 2: Analysis (ui-analyzer)
For each component:
1. Read current implementation
2. Identify required changes
3. Check for conflicts
4. Plan modification approach

### Step 3: Batch Update (ui-builder)
For each component:
1. Apply changes systematically
2. Maintain consistency across all files
3. Preserve existing functionality
4. Update TypeScript types as needed
5. Show progress: [X/N] Component updated

### Step 4: Validation (ui-validator)
For each updated component:
1. Quality score check
2. Design system compliance
3. Accessibility validation
4. Auto-fix common issues
5. Report issues if score < 85/100

### Step 5: Final Report
1. Show summary of all changes
2. Report quality metrics
3. List any issues found
4. Provide next steps

## Workflow: Component Composition (--compose flag)

Create new component by intelligently composing existing components.

### Step 1: Search & Locate (ui-analyzer)
1. Find all referenced components in codebase
2. Read their implementations
3. Understand their APIs (props, events, slots)
4. Analyze composition compatibility

### Step 2: Design Composition (ui-analyzer)
1. Determine component hierarchy
2. Plan props flow (parent → children)
3. Design event flow (children → parent)
4. Identify shared state needs
5. Plan styling integration

### Step 3: Generate Composed Component (ui-builder)
1. Create wrapper component
2. Import all child components
3. Wire up props and events
4. Add composition logic
5. Handle edge cases
6. Ensure type safety

### Step 4: Validate (ui-validator)
1. Check all components integrate properly
2. Verify prop/event flow works
3. Test accessibility
4. Validate design system compliance

## Output Format

### Batch Update Output
```markdown
# 🔄 Batch Refactor: [Pattern]

**Target**: buttons/*
**Change**: Update to new focus-ring utility
**Components Found**: 5

---

## 📋 Discovery

### Components to Update:
```
src/components/vue/buttons/PrimaryButton.vue
src/components/vue/buttons/SecondaryButton.vue
src/components/vue/buttons/IconButton.vue
src/components/vue/buttons/LinkButton.vue
src/components/vue/buttons/DropdownButton.vue
```

**Proceed with batch update?** (yes/no)

---

## 🔄 Batch Update Progress

### Component 1/5: PrimaryButton.vue ⏳
**Status**: Analyzing...
**Changes**: Identified 2 modifications needed

**Status**: Updating...
**Changes Applied**:
- ✅ Replaced focus:ring-2 with focus-ring utility
- ✅ Updated TypeScript types

**Status**: Validating...
**Quality Score**: 96/100 ✅

---

### Component 2/5: SecondaryButton.vue ⏳
[Same progress format]

---

## ✅ Batch Update Complete

**Summary:**
- **Total Components**: 5
- **Successfully Updated**: 5
- **Failed**: 0
- **Average Quality Score**: 95/100
- **Time Taken**: 8 minutes

---

## 📊 Quality Report

| Component | Before | After | Change | Issues |
|-----------|--------|-------|--------|--------|
| PrimaryButton.vue | 92/100 | 96/100 | +4 | None |
| SecondaryButton.vue | 90/100 | 95/100 | +5 | None |
| IconButton.vue | 88/100 | 94/100 | +6 | Auto-fixed |
| LinkButton.vue | 91/100 | 96/100 | +5 | None |
| DropdownButton.vue | 89/100 | 93/100 | +4 | 1 warning |

**Overall Impact**: +4.8 average score improvement

---

## 🤖 Auto-Fixed Issues

1. **Missing TypeScript types** (2 components)
   - Added proper interface definitions

2. **Inconsistent class ordering** (3 components)
   - Standardized class order

---

## 🚀 Next Steps

```bash
# Capture updated screenshots
/ui-screenshot buttons/*.vue --compare

# Update documentation
/ui-document PrimaryButton.vue
```
```

### Composition Output
```markdown
# 🧩 Composed Component: UserProfileCard

**Composition**: Card + Avatar + Badge

---

## 📋 Analysis

### Components Found
| Component | Location | API Surface |
|-----------|----------|-------------|
| Card | `src/components/vue/cards/Card.vue` | Props: 3, Events: 2, Slots: 2 |
| Avatar | `src/components/vue/ui/Avatar.vue` | Props: 4, Events: 1, Slots: 0 |
| Badge | `src/components/vue/ui/Badge.vue` | Props: 3, Events: 0, Slots: 1 |

### Composition Strategy
**Selected Approach**: Slot-Based Composition

**Reasoning**: Components have well-defined slots that enable flexible composition

---

## 🏗️ Component Structure

### Props Interface
```typescript
interface Props {
  // From Card
  variant?: 'elevated' | 'outlined' | 'filled'

  // From Avatar
  src: string
  alt: string
  size?: 'sm' | 'md' | 'lg'

  // From Badge
  status?: 'online' | 'offline' | 'away' | 'busy'
  badgeText?: string

  // Composition-specific
  name: string
  role: string
}
```

### Events
- `@click` - When card is clicked
- `@avatar-click` - When avatar is clicked specifically

---

## 💻 Generated Component

**File**: `src/components/vue/composed/UserProfileCard.vue`

```vue
<script setup lang="ts">
import { computed } from 'vue'
import Card from '@/components/vue/cards/Card.vue'
import Avatar from '@/components/vue/ui/Avatar.vue'
import Badge from '@/components/vue/ui/Badge.vue'

interface Props {
  variant?: 'elevated' | 'outlined' | 'filled'
  src: string
  alt: string
  size?: 'sm' | 'md' | 'lg'
  status?: 'online' | 'offline' | 'away' | 'busy'
  badgeText?: string
  name: string
  role: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'elevated',
  size: 'md'
})

interface Emits {
  click: []
  avatarClick: []
}

const emit = defineEmits<Emits>()

const handleCardClick = () => {
  emit('click')
}

const handleAvatarClick = () => {
  emit('avatarClick')
}
</script>

<template>
  <Card
    :variant="variant"
    class="p-6"
    @click="handleCardClick"
  >
    <div class="flex items-center gap-4">
      <div class="relative">
        <Avatar
          :src="src"
          :alt="alt"
          :size="size"
          @click.stop="handleAvatarClick"
        />
        <Badge
          v-if="status"
          :variant="status"
          :text="badgeText"
          class="absolute -bottom-1 -right-1"
        />
      </div>

      <div class="flex-1">
        <h3 class="text-lg font-semibold text-[var(--color-text-primary)]">
          {{ name }}
        </h3>
        <p class="text-sm text-[var(--color-text-secondary)]">
          {{ role }}
        </p>
      </div>

      <slot name="actions" />
    </div>
  </Card>
</template>
```

---

## ✅ Validation Results

**Quality Score**: 94/100

**Strengths**:
- ✅ Clean composition pattern
- ✅ Type-safe prop forwarding
- ✅ Proper event coordination
- ✅ Design system compliant

**Issues**:
- ⚠️ Minor: Could add more JSDoc comments

---

## 📚 Usage Example

```vue
<script setup lang="ts">
import UserProfileCard from '@/components/vue/composed/UserProfileCard.vue'

const handleClick = () => {
  console.log('Card clicked')
}

const handleAvatarClick = () => {
  console.log('Avatar clicked')
}
</script>

<template>
  <UserProfileCard
    src="/avatars/john.jpg"
    alt="John Doe"
    name="John Doe"
    role="Senior Developer"
    status="online"
    size="lg"
    @click="handleClick"
    @avatar-click="handleAvatarClick"
  >
    <template #actions>
      <button class="btn-base btn-sm">Message</button>
    </template>
  </UserProfileCard>
</template>
```

---

## 🚀 Next Steps

1. **Test composition**: Verify all interactions work
2. **Screenshot**: Run `/ui-screenshot UserProfileCard.vue`
3. **Document**: Run `/ui-document UserProfileCard.vue`
4. **Deploy**: Ready for production use

**File Created**: `src/components/vue/composed/UserProfileCard.vue`
```

## Example Usage

```bash
# Batch update buttons
/ui-refactor buttons/* Add loading state prop --batch

# Compose new component
/ui-refactor Card + Avatar --compose

# Auto-detect (analyzes pattern)
/ui-refactor **/*Button.vue Standardize focus states

# Batch token migration
/ui-refactor **/*.vue Migrate hardcoded colors to tokens --batch
```

## Batch Update Strategies

### Strategy 1: Token Migration
Update design tokens across multiple components:
- Search: All color values
- Replace: With CSS custom properties
- Validate: 100% token compliance

### Strategy 2: API Changes
Add/remove props consistently:
- Identify: All affected components
- Update: Prop interfaces
- Validate: TypeScript compilation

### Strategy 3: Accessibility Improvements
Enhance a11y across component set:
- Add: ARIA labels
- Improve: Keyboard navigation
- Validate: WCAG compliance

### Strategy 4: Performance Optimization
Apply optimizations systematically:
- Add: v-memo directives
- Optimize: Computed properties
- Validate: Performance metrics

## Composition Strategies

### Strategy 1: Simple Wrapper
Wrap components in container with minimal logic

### Strategy 2: Event Coordination
Components interact through parent-coordinated events

### Strategy 3: Slot-Based Composition
Use slots for flexible component insertion

### Strategy 4: Provider Pattern
Use composition with config-driven components

## Time Estimates

### Batch Update
Per component:
- Analysis: 1 minute
- Update: 2-3 minutes
- Validation: 1-2 minutes
- **Total: 4-6 minutes per component**

For 10 components: 40-60 minutes

### Composition
- Component search: 2-3 minutes
- Composition design: 3-4 minutes
- Generation: 3-4 minutes
- Validation: 2-3 minutes
- **Total: 10-14 minutes**

## Best Practices

### DO:
✅ **Test on small batch first** - Verify approach works
✅ **Review changes** - Don't blindly apply
✅ **Update in git branch** - Easy rollback
✅ **Preserve child APIs** - Don't break existing interfaces
✅ **Keep it simple** - Minimal composition logic

### DON'T:
❌ **Update without backup** - Always commit first
❌ **Skip validation** - Quality matters
❌ **Modify children** - Don't alter child component code
❌ **Update too many at once** - Max 50 components per batch
❌ **Add unnecessary complexity** - Simple is better

This command provides powerful refactoring capabilities while maintaining code quality and consistency.
