---
description: Generate concise, practical component documentation on-demand with API reference and usage examples
argument-hint: [component-path]
allowed-tools: write, read, view, bash
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Documentation

Generate comprehensive, scannable documentation for Vue components with API references, usage examples, and best practices.

## Usage

```bash
/ui-document src/components/vue/buttons/PrimaryButton.vue
/ui-document PrimaryButton.vue
/ui-document Button.vue --full
```

**Syntax**: `/ui-document [component-path] [options]`

## Process

Generate documentation for: $ARGUMENTS

### Step 1: Component Analysis (ui-documenter)
1. Read component file
2. Extract props from TypeScript interface
3. Extract events from defineEmits
4. Identify slots from template
5. Parse JSDoc comments if present
6. Analyze design token usage
7. Check accessibility features

### Step 2: Generate API Reference
1. Document all props with types
2. Document all events with payloads
3. Document all slots with descriptions
4. Add usage examples
5. Include design system notes

### Step 3: Create Examples
1. Basic usage example
2. Advanced usage examples
3. Common patterns
4. Edge cases
5. Integration examples

### Step 4: Add Context
1. Related components
2. Design system compliance
3. Accessibility notes
4. Browser support
5. Changelog

### Step 5: Save Documentation
1. Save to `docs/components/`
2. Update component index
3. Generate preview if requested

## Output Format

```markdown
# 📚 Documentation: [ComponentName]

**Component**: `$ARGUMENTS`
**Generated**: [Timestamp]
**Category**: [Buttons | Cards | Modals | Inputs | UI]

---

## Overview

[1-2 sentence description of what the component does and when to use it]

**Key Features:**
- [Feature 1]
- [Feature 2]
- [Feature 3]

---

## Installation

```vue
<script setup lang="ts">
import ComponentName from '@/components/vue/{category}/ComponentName.vue'
</script>
\```

---

## Basic Usage

```vue
<script setup lang="ts">
import ComponentName from '@/components/vue/{category}/ComponentName.vue'

const handleEvent = () => {
  console.log('Event triggered')
}
</script>

<template>
  <ComponentName 
    prop1="value"
    :prop2="data"
    @event="handleEvent"
  >
    Content
  </ComponentName>
</template>
\```

---

## API Reference

### Props

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `label` | `string` | Yes | - | Button label text displayed to users |
| `variant` | `'primary' \| 'secondary' \| 'tertiary'` | No | `'primary'` | Visual style variant of the button |
| `size` | `'sm' \| 'md' \| 'lg'` | No | `'md'` | Size of the button (affects padding and font) |
| `disabled` | `boolean` | No | `false` | Disables button interaction when true |
| `loading` | `boolean` | No | `false` | Shows loading spinner when true |
| `icon` | `Component` | No | `undefined` | Optional icon component to display |

### Events

| Event | Payload | Description |
|-------|---------|-------------|
| `click` | `MouseEvent` | Emitted when button is clicked |
| `focus` | `FocusEvent` | Emitted when button receives focus |
| `blur` | `FocusEvent` | Emitted when button loses focus |

### Slots

| Slot | Props | Description |
|------|-------|-------------|
| `default` | - | Main button content (overrides label prop) |
| `icon` | - | Custom icon slot (overrides icon prop) |
| `loading` | `{ loading: boolean }` | Custom loading indicator |

---

## Examples

### Basic Button

```vue
<ComponentName label="Click me" />
\```

### With Variant

```vue
<ComponentName 
  label="Submit" 
  variant="primary"
  size="lg"
  @click="handleSubmit"
/>
\```

### With Icon

```vue
<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline'
</script>

<template>
  <ComponentName 
    label="Add Item"
    :icon="PlusIcon"
  />
</template>
\```

### Loading State

```vue
<ComponentName 
  label="Processing..." 
  :loading="isLoading"
  :disabled="isLoading"
/>
\```

### Custom Content with Slot

```vue
<ComponentName>
  <span class="flex items-center gap-2">
    <CheckIcon class="w-4 h-4" />
    <span>Saved Successfully</span>
  </span>
</ComponentName>
\```

### Disabled State

```vue
<ComponentName 
  label="Unavailable"
  disabled
/>
\```

---

## Design System

### Tokens Used

This component uses the following design tokens:

**Colors:**
- `--color-primary-500` - Primary button background
- `--color-primary-600` - Primary button hover state
- `--color-text-primary` - Button text color
- `--color-text-inverse` - Text on colored backgrounds

**Spacing:**
- `p-3` (12px) - Small button padding
- `p-4` (16px) - Medium button padding (default)
- `p-5` (20px) - Large button padding
- `gap-2` (8px) - Icon to text spacing

**Typography:**
- `--font-sans` - Button font family
- `--text-sm` (14px) - Small button text
- `--text-base` (16px) - Medium button text
- `--text-lg` (18px) - Large button text

**Other:**
- `--radius-md` - Button border radius
- `--shadow-sm` - Button shadow

### Color Variants

```vue
<!-- Primary (default) -->
<ComponentName variant="primary" />  
<!-- Uses --color-primary-* tokens -->

<!-- Secondary -->
<ComponentName variant="secondary" />  
<!-- Uses --color-secondary-* tokens -->

<!-- Tertiary -->
<ComponentName variant="tertiary" />  
<!-- Uses --color-gray-* tokens -->
\```

---

## Accessibility

### Features

- ✅ **Semantic HTML**: Uses native `<button>` element
- ✅ **Keyboard Navigation**: Full Tab, Enter, Space support
- ✅ **Focus Indicators**: Visible focus ring with proper contrast
- ✅ **ARIA Labels**: Automatically includes accessible labels
- ✅ **Disabled States**: Proper `aria-disabled` when disabled
- ✅ **Loading States**: `aria-busy` when loading
- ✅ **Color Contrast**: Meets WCAG AAA (7:1 ratio)
- ✅ **Touch Targets**: Minimum 44x44px tap area

### WCAG Compliance

**Level**: AAA

**Tested With:**
- Keyboard navigation (Tab, Enter, Space)
- Screen readers (VoiceOver, NVDA, JAWS)
- Color contrast tools
- Touch target measurements

### Best Practices

```vue
<!-- ✅ GOOD: Descriptive label -->
<ComponentName label="Save changes" />

<!-- ❌ BAD: Non-descriptive label -->
<ComponentName label="Click" />

<!-- ✅ GOOD: Disabled with reason -->
<ComponentName 
  label="Submit" 
  disabled
  aria-label="Submit button (disabled: form incomplete)"
/>

<!-- ❌ BAD: Disabled without context -->
<ComponentName label="Submit" disabled />
\```

---

## Browser Support

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | 90+ | ✅ Full Support |
| Firefox | 88+ | ✅ Full Support |
| Safari | 14+ | ✅ Full Support |
| Edge | 90+ | ✅ Full Support |

**Mobile:**
- iOS Safari 14+
- Chrome Mobile 90+
- Samsung Internet 14+

---

## Related Components

- **[SecondaryButton](./SecondaryButton.md)** - Alternative button style
- **[IconButton](./IconButton.md)** - Icon-only button variant
- **[ButtonGroup](./ButtonGroup.md)** - Group multiple buttons
- **[LinkButton](./LinkButton.md)** - Button styled as link

---

## Common Patterns

### Form Submit Button

```vue
<form @submit.prevent="handleSubmit">
  <ComponentName 
    type="submit"
    label="Save"
    :loading="isSubmitting"
    :disabled="!isValid"
  />
</form>
\```

### Confirmation Dialog Action

```vue
<ComponentName 
  variant="primary"
  label="Confirm"
  @click="confirmAction"
/>
<ComponentName 
  variant="secondary"
  label="Cancel"
  @click="cancelAction"
/>
\```

### Async Action with Loading

```vue
<script setup lang="ts">
import { ref } from 'vue'

const loading = ref(false)

const handleAsync = async () => {
  loading.value = true
  try {
    await someAsyncOperation()
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <ComponentName 
    label="Process"
    :loading="loading"
    @click="handleAsync"
  />
</template>
\```

---

## TypeScript

### Type Definitions

```typescript
interface Props {
  label: string
  variant?: 'primary' | 'secondary' | 'tertiary'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
  loading?: boolean
  icon?: Component
}

interface Emits {
  (e: 'click', event: MouseEvent): void
  (e: 'focus', event: FocusEvent): void
  (e: 'blur', event: FocusEvent): void
}
\```

### Usage with TypeScript

```vue
<script setup lang="ts">
import ComponentName from '@/components/vue/{category}/ComponentName.vue'
import type { ComponentProps } from '@/components/vue/{category}/ComponentName.vue'

// Type-safe props
const buttonProps: ComponentProps = {
  label: 'Submit',
  variant: 'primary',
  size: 'lg'
}

// Type-safe event handler
const handleClick = (event: MouseEvent) => {
  console.log('Clicked', event)
}
</script>

<template>
  <ComponentName v-bind="buttonProps" @click="handleClick" />
</template>
\```

---

## Performance

### Optimizations

- ✅ **Computed Classes**: Reactive class composition
- ✅ **Event Delegation**: Efficient event handling
- ✅ **No Re-renders**: Stable component structure
- ✅ **Small Bundle**: ~2KB gzipped

### Benchmarks

- **Initial Render**: < 1ms
- **Re-render**: < 0.5ms
- **Bundle Size**: 2.1 KB (minified + gzipped)

---

## Troubleshooting

### Button not clickable
**Issue**: Click events not firing
**Solution**: Check if `disabled` or `loading` props are true

### Wrong colors showing
**Issue**: Button shows incorrect colors
**Solution**: Ensure design-system.css is imported and tokens are defined

### Focus ring not visible
**Issue**: Focus indicator not showing
**Solution**: Check browser settings and CSS for `outline` overrides

### Icon not displaying
**Issue**: Icon slot or prop not working
**Solution**: Verify icon component is properly imported and passed

---

## Changelog

### v1.2.0 - 2025-10-22
- Added `loading` prop with spinner
- Improved accessibility with better ARIA labels
- Enhanced TypeScript types
- Added `icon` slot for custom icons

### v1.1.0 - 2025-10-15
- Added `size` prop for different button sizes
- Improved color contrast to meet WCAG AAA
- Fixed focus indicator on dark backgrounds
- Performance optimization with computed classes

### v1.0.0 - 2025-10-01
- Initial release
- Basic props (label, variant, disabled)
- Primary, secondary, tertiary variants
- Full accessibility support

---

## Contributing

Found a bug or have a suggestion?
1. Create an issue in the project repository
2. Describe the problem or enhancement
3. Include code examples if applicable

---

**Documentation File**: `docs/components/{category}/ComponentName.md`
**Last Updated**: [Timestamp]
**Maintained by**: ui-documenter subagent
\```

## Options

### --full
Generate extended documentation:
```bash
/ui-document Button.vue --full
```
Includes:
- Detailed architecture notes
- Implementation details
- Testing guide
- Migration guide (if applicable)

### --api-only
Generate only API reference:
```bash
/ui-document Button.vue --api-only
```
Props, events, slots table only.

### --examples-only
Generate only usage examples:
```bash
/ui-document Button.vue --examples-only
```
Multiple usage examples without API details.

## Documentation Best Practices

### DO:
✅ **Be concise** - Get to the point quickly
✅ **Show code** - Examples over explanations
✅ **Use tables** - For props, events, slots
✅ **Include types** - Full TypeScript support
✅ **Add context** - Related components, patterns
✅ **Keep updated** - Update with code changes

### DON'T:
❌ **Be verbose** - Avoid long paragraphs
❌ **Just explain** - Always show examples
❌ **Forget accessibility** - Document a11y features
❌ **Skip edge cases** - Show error states, loading, etc.
❌ **Ignore tokens** - Document design system usage

## Auto-Generation Features

The ui-documenter automatically extracts:

### From TypeScript
- Prop types and descriptions
- Event signatures
- Interface definitions
- Type exports

### From Template
- Slot locations and usage
- Component structure
- Class applications

### From JSDoc
```typescript
/**
 * Primary action button with loading state
 * @example
 * <PrimaryButton label="Submit" @click="save" />
 */
```

### From Code Comments
```vue
<!-- Main action button for forms -->
<button>{{ label }}</button>
```

## Time Estimate

- Component analysis: 1-2 minutes
- API reference extraction: 1-2 minutes
- Example generation: 2-3 minutes
- Context and notes: 1-2 minutes
- **Total: 5-9 minutes**

## Integration

This command uses:
- **ui-documenter** subagent for documentation generation
- **ui-analyzer** for design token extraction
- **ui-validator** for accessibility information

Creates documentation that developers actually want to read - practical, scannable, and immediately useful.