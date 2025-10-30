---
description: Build new component by composing existing components together
argument-hint: [component1] + [component2] [+ component3...]
allowed-tools: read, write, grep, bash, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Composition

Create a new component by intelligently composing existing components together, maximizing code reuse.

## Usage

```bash
/ui-compose BaseModal + TextInput
/ui-compose Card + Avatar + Button
/ui-compose BaseProviderCard + ActionMenu + StatusBadge
```

**Syntax**: `/ui-compose [component1] + [component2] [+ ...]`

## Process

Compose components from: $ARGUMENTS

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

## Composition Strategies

### Strategy 1: Simple Wrapper
Wrap components in a container with minimal logic:

```vue
<script setup lang="ts">
import ComponentA from './ComponentA.vue'
import ComponentB from './ComponentB.vue'

interface Props {
  // Combined props from both components
}
const props = defineProps<Props>()
</script>

<template>
  <div class="composed-wrapper">
    <ComponentA :propA="props.valueA" />
    <ComponentB :propB="props.valueB" />
  </div>
</template>
```

### Strategy 2: Event Coordination
Components interact through parent-coordinated events:

```vue
<script setup lang="ts">
import { ref } from 'vue'
import ComponentA from './ComponentA.vue'
import ComponentB from './ComponentB.vue'

const sharedState = ref('')

const handleAEvent = (value) => {
  sharedState.value = value
  // Update ComponentB
}

const handleBEvent = (value) => {
  // Coordinate with ComponentA
}
</script>

<template>
  <div>
    <ComponentA 
      @update="handleAEvent" 
      :value="sharedState"
    />
    <ComponentB 
      @change="handleBEvent"
      :data="sharedState"
    />
  </div>
</template>
```

### Strategy 3: Slot-Based Composition
Use slots for flexible component insertion:

```vue
<script setup lang="ts">
import BaseContainer from './BaseContainer.vue'
import HeaderComponent from './HeaderComponent.vue'
import ContentComponent from './ContentComponent.vue'
</script>

<template>
  <BaseContainer>
    <template #header>
      <HeaderComponent />
    </template>
    <template #content>
      <ContentComponent />
    </template>
  </BaseContainer>
</template>
```

### Strategy 4: Provider Pattern
Use composition with config-driven components:

```vue
<script setup lang="ts">
import BaseProviderCard from './BaseProviderCard.vue'
import { providers } from '@/config/providers'

interface Props {
  platform: keyof typeof providers
}
const props = defineProps<Props>()
</script>

<template>
  <BaseProviderCard 
    :platform="props.platform"
    :config="providers[props.platform]"
  />
</template>
```

## Output Format

```markdown
# 🧩 Composed Component: [ComposedName]

**Composition**: $ARGUMENTS

---

## 📋 Analysis

### Components Found
| Component | Location | API Surface |
|-----------|----------|-------------|
| ComponentA | `path/to/A.vue` | Props: X, Events: Y, Slots: Z |
| ComponentB | `path/to/B.vue` | Props: X, Events: Y, Slots: Z |

### Composition Strategy
**Selected Approach**: [Simple Wrapper | Event Coordination | Slot-Based | Provider Pattern]

**Reasoning**: [Why this strategy fits best]

---

## 🏗️ Component Structure

### Props Interface
```typescript
interface Props {
  // Props from ComponentA
  propA: string
  
  // Props from ComponentB
  propB: number
  
  // Composition-specific props
  layout?: 'vertical' | 'horizontal'
}
\```

### Events
- `@submit` - When form is submitted (from ComponentB)
- `@cancel` - When action is cancelled (from ComponentA)
- `@update` - When data changes (composed event)

### Slots
- `header` - Optional header content
- `footer` - Optional footer content
- `default` - Main content area

---

## 💻 Generated Component

**File**: `src/components/vue/composed/[ComposedName].vue`

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'
import ComponentA from '@/components/vue/path/ComponentA.vue'
import ComponentB from '@/components/vue/path/ComponentB.vue'

// Type definitions
interface Props {
  // [All props defined]
}

interface Emits {
  // [All events defined]
}

// Props & Emits
const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Composition state (if needed)
const sharedState = ref()

// Event handlers
const handleComponentAEvent = (value) => {
  // Coordinate between components
  emit('update', value)
}

const handleComponentBEvent = (value) => {
  // Handle event from ComponentB
  emit('submit', value)
}

// Computed properties
const containerClasses = computed(() => ({
  'flex-col': props.layout === 'vertical',
  'flex-row': props.layout === 'horizontal'
}))
</script>

<template>
  <div :class="containerClasses">
    <ComponentA 
      v-bind="/* props */"
      @event="handleComponentAEvent"
    />
    
    <ComponentB
      v-bind="/* props */"
      @event="handleComponentBEvent"
    />
    
    <slot name="footer" />
  </div>
</template>
\```

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
- ✅ No critical issues

---

## 📚 Usage Example

```vue
<script setup lang="ts">
import ComposedComponent from '@/components/vue/composed/ComposedName.vue'

const handleSubmit = (data) => {
  console.log('Submitted:', data)
}
</script>

<template>
  <ComposedComponent
    :propA="valueA"
    :propB="valueB"
    layout="vertical"
    @submit="handleSubmit"
  />
</template>
\```

---

## 🎯 Benefits of Composition

**Code Reuse**: [X]% code reused from existing components
**Maintenance**: Single source of truth for child components
**Flexibility**: Easy to swap implementations
**Type Safety**: Full TypeScript coverage
**Consistency**: Inherits design system compliance

---

## 🚀 Next Steps

1. **Test composition**: Verify all interactions work
2. **Screenshot**: Run `/ui-screenshot` for visual docs
3. **Document**: Run `/ui-document` for API reference
4. **Deploy**: Ready for production use

**File Created**: `src/components/vue/composed/[ComposedName].vue`
\```

## Composition Best Practices

### DO:
✅ **Preserve child APIs** - Don't break existing component interfaces
✅ **Use v-bind="props"** - Forward props cleanly
✅ **Coordinate events** - Parent manages communication
✅ **Type everything** - Full TypeScript coverage
✅ **Keep it simple** - Minimal composition logic

### DON'T:
❌ **Modify children** - Don't alter child component code
❌ **Duplicate logic** - Use existing component features
❌ **Override styles** - Respect design system
❌ **Break encapsulation** - Keep concerns separated
❌ **Add unnecessary complexity** - Simple is better

## When to Compose

Use composition when:
- ✅ Multiple components solve parts of the problem
- ✅ Components are well-defined and stable
- ✅ You need to coordinate between components
- ✅ Pattern will be reused multiple times

Avoid composition when:
- ❌ Components are tightly coupled
- ❌ Simpler to create from scratch
- ❌ Composition adds more complexity than value
- ❌ One-off use case

## Time Estimate

- Component search: 2-3 minutes
- Composition design: 3-4 minutes
- Generation: 3-4 minutes
- Validation: 2-3 minutes
- **Total: 10-14 minutes**

## Integration

This command uses:
- **ui-analyzer** for component discovery and planning
- **ui-builder** for composed component generation
- **ui-validator** for quality checking

Promotes:
- Maximum code reuse
- Consistent patterns
- Maintainable architecture
- Type-safe integrations

Composition over creation - the smart way to build UI components.