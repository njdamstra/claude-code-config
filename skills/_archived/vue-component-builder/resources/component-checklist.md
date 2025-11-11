# Before Creating Component

1. **Search for existing components** (use codebase-researcher skill)
2. **Check for similar patterns** in other components
3. **Identify reusable parts** (can you compose existing components?)
4. **Plan component API** (props, emits, slots)
5. **Consider SSR** (will this render on server?)

## Component Checklist

- [ ] TypeScript `<script setup lang="ts">`
- [ ] Props with `withDefaults(defineProps<{}>(), {})` pattern
- [ ] v-model with `defineModel()` (if applicable)
- [ ] `useMounted()` for client-only code (icons, browser APIs)
- [ ] Tailwind classes preferred (scoped styles only for transitions)
- [ ] Dark mode classes (`dark:`) on ALL colors
- [ ] Proper TypeScript types with no `any`
- [ ] ARIA labels on interactive elements
- [ ] `defineEmits<{}>()` properly typed
- [ ] Error handling present
- [ ] Responsive design (mobile-first with Tailwind breakpoints)
- [ ] Third-party libraries integrated correctly (HeadlessUI, Iconify, etc.)
- [ ] Existing components checked for reuse potential
