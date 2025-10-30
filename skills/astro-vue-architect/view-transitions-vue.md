# View Transitions with Vue

Integration patterns for Astro View Transitions + Vue islands.

## Basic Setup

```astro
import { ClientRouter } from 'astro:transitions'
<ClientRouter />
```

## Persisting Vue Islands

```astro
<VueComponent client:load transition:persist />
```

**See SKILL.md Section 5 for:**
- State persistence patterns
- Nanostore integration
- Animation coordination
- Lifecycle events

## Common Patterns

1. Persist interactive components (video players, forms)
2. Use Nanostores for cross-navigation state
3. Name transitions for explicit matching
4. Handle lifecycle events in Vue components
