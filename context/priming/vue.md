# Vue/Astro Context Primer

## Core Concepts
- Vue 3 Composition API and SSR compatibility
- Astro islands architecture and hydration strategies
- Reactive state management with nanostores
- Component composition with VueUse

## SSR Considerations
- Use `onMounted` for browser-only code
- Implement proper hydration with client: directives
- Handle state persistence across SSR/client transitions
- Optimize hydration timing (client:visible, client:idle)

## Project Structure
```
src/
├── components/     # Vue components
├── pages/          # Astro pages
├── layouts/        # Layout components
├── stores/         # Nanostores state
└── composables/    # VueUse utilities
```

## State Management
- **Local state**: ref(), reactive()
- **Cross-component**: nanostores
- **Persistence**: nanostores with localStorage
- **Global state**: Pinia (if needed)

## Styling Approach
- Tailwind CSS with dark mode support
- Responsive, mobile-first design
- ADA compliance considerations
- Performance-optimized CSS delivery

## Common Patterns
- Composables for reusable logic
- Teleport for modals and overlays
- Suspense for async components
- Error boundaries for robustness

## Build Configuration
- Vite for development and bundling
- Astro configuration for SSR settings
- TypeScript integration
- CSS preprocessing and optimization