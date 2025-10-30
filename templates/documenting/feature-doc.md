# Feature: [Feature Name]

## Overview
Brief description of what this feature does and why it exists.

## API Reference

### Components
- **ComponentName** (`path/to/Component.vue`)
  - Props: `{ propName: Type }`
  - Events: `{ eventName: PayloadType }`
  - Slots: `{ slotName: Props }`

### Composables
- **useFeatureName** (`path/to/useFeature.ts`)
  - Returns: `{ state, methods, computed }`
  - Dependencies: List any required stores or services

### Stores
- **FeatureStore** (`path/to/featureStore.ts`)
  - State: Document reactive state
  - Methods: List available operations
  - Events: Real-time subscriptions

## Usage Examples

### Basic Usage
```vue
<script setup lang="ts">
import { ComponentName } from '@/components/feature'

// Example implementation
</script>

<template>
  <ComponentName />
</template>
```

### Advanced Usage
```typescript
// Complex scenarios, edge cases, integration patterns
```

## Implementation Details

### Architecture Decisions
- Why this approach was chosen
- Alternative approaches considered
- Trade-offs made

### Dependencies
- External libraries used
- Internal modules required
- Database collections involved

### Edge Cases
1. **Case 1**: Description and handling
2. **Case 2**: Description and handling

## Testing

### Test Coverage
- Unit tests: Location and scope
- Integration tests: Key scenarios
- E2E tests: Critical user flows

### Manual Testing Checklist
- [ ] Feature works in SSR context
- [ ] Dark mode support verified
- [ ] Accessibility tested (ARIA, keyboard)
- [ ] Mobile responsive
- [ ] Error states handled

## Known Limitations
- List any current limitations
- Planned improvements
- Performance considerations

## Related Documentation
- Links to related features
- Relevant ADRs or decision logs
- External documentation references
