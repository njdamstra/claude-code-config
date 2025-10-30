---
description: Strategic planning with ASCII wireframes - searches patterns, analyzes design, generates layout options
argument-hint: [component description]
allowed-tools: read, grep, bash, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
Tailored for: Vue 3 + Astro + Appwrite + Nanostore stack
See: SOC_UI_INTEGRATION.md for foundation details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Planning

Use the ui-analyzer subagent to create a strategic plan before building any component.

## Socialaize Planning Context

Before planning any component, check:

### Existing Foundation
1. **Base components:** `ls src/components/vue/base/`
2. **Animation presets:** `ls src/components/vue/animations/composables/`
3. **Similar patterns:** `grep -r "similar-pattern" src/components/vue/`

### Include in Plan
- Which base components to extend (if any)
- Which animation presets to use (useAnimateElement, VueUse Motion, or Tailwind utilities)
- Whether state management needed (Nanostore + BaseStore pattern)
- Whether data validation needed (Zod schema matching Appwrite attributes)
- Icon strategy (@iconify/vue with mdi or simple-icons collections)

## Process

1. **Understand Requirements**
   - Parse the component description: $ARGUMENTS
   - Identify key functionality and features
   - Determine component category (button, card, modal, input, etc.)

2. **Search for Existing Patterns**
   - Search `src/components/vue/` for similar components
   - Look for reusable base components
   - Identify provider pattern opportunities
   - Check for composition possibilities

3. **Analyze Design Requirements**
   - Review `src/styles/design-system.css` for available tokens
   - Identify required colors, spacing, typography
   - Determine if new tokens are needed
   - Check for visual consistency with existing components

4. **Create Implementation Plan**
   - Decide: Reuse, Compose, or Create New
   - List required design tokens
   - Outline component structure
   - Identify accessibility requirements
   - Note performance considerations

## Output Format

Provide a concise plan in this format:

```markdown
# 📋 Component Plan: [Component Name]

## 🔍 Analysis

### Similar Components Found
- **[ComponentName]** (`path/to/component.vue`) - [similarity description]
- [List all relevant existing components]

### Composition Opportunities
- ✅ Can reuse [BaseComponent] for [functionality]
- ✅ Can compose [Component1] + [Component2]
- ❌ No direct reuse possible

## 🎨 Design Requirements

### Required Tokens
- **Colors**: `--color-primary-500`, `--color-text-primary`
- **Spacing**: `p-4`, `gap-2`, `space-y-3`
- **Typography**: `--font-sans`, `--text-base`
- **Other**: [any special tokens needed]

### Missing Tokens (to add)
- `--color-new-token` - [description and justification]

## 🏗️ Implementation Strategy

### Approach: [REUSE | COMPOSE | CREATE NEW]

**Recommendation**: [Brief explanation of the chosen approach]

### Component Structure
```typescript
// Outline the key parts
interface Props {
  // List main props
}

// Key features to implement:
1. [Feature 1]
2. [Feature 2]
\```

### Accessibility Requirements
- ✅ Keyboard navigation (Tab, Enter, Space, Arrows)
- ✅ ARIA labels: `aria-label`, `role`
- ✅ Focus management
- ✅ Color contrast: 4.5:1 minimum

### Performance Considerations
- Use `computed()` for reactive classes
- Consider `v-memo` for expensive rendering
- Lazy load if component is heavy

## 📝 Next Steps

1. **If REUSE**: Modify existing [ComponentName] to fit requirements
2. **If COMPOSE**: Build wrapper combining [Component1] + [Component2]
3. **If CREATE**: Generate 3 variants with /ui-create command

**Ready to proceed?** [Wait for user approval before generating code]
\```

## ASCII Wireframing (ALWAYS INCLUDED)

Generate 2-3 layout approaches automatically:

```
OPTION 1: Sidebar Layout
┌─────────────────────────────────────┐
│ Header                [Actions]     │
├────────┬────────────────────────────┤
│        │                            │
│ Side   │   Main Content Area        │
│ Nav    │   ┌──────────────────┐     │
│        │   │  Card            │     │
│ [opt]  │   │  - Title         │     │
│ [opt]  │   │  - Content       │     │
│ [opt]  │   └──────────────────┘     │
│        │                            │
└────────┴────────────────────────────┘

Mobile Transform:
┌──────────────┐
│ Header       │
├──────────────┤
│ [≡ Menu]     │
├──────────────┤
│ Content      │
│ ┌──────────┐ │
│ │ Card     │ │
│ └──────────┘ │
└──────────────┘

OPTION 2: Stack Layout
┌─────────────────────────────────────┐
│ Hero Section                        │
│ [Large Image / CTA]                 │
├─────────────────────────────────────┤
│ Features Grid                       │
│ ┌─────┐  ┌─────┐  ┌─────┐          │
│ │ F1  │  │ F2  │  │ F3  │          │
│ └─────┘  └─────┘  └─────┘          │
├─────────────────────────────────────┤
│ Content                             │
└─────────────────────────────────────┘

Mobile Transform:
┌──────────────┐
│ Hero (comp)  │
├──────────────┤
│ ┌──────────┐ │
│ │ Feature  │ │
│ └──────────┘ │
│ ┌──────────┐ │
│ │ Feature  │ │
│ └──────────┘ │
└──────────────┘
```

User selects option → Proceed with implementation

## Guidelines

- **Always search first** - Never assume we need a new component
- **Check Socialaize inventory first** - We have base components and animation utilities
- **Prioritize reuse** - Composition > Creation
- **Use existing animation system** - useAnimateElement + constants, VueUse Motion, or Tailwind
- **Follow BaseStore pattern** - For Appwrite collection integration
- **Validate with Zod** - Match Appwrite attribute schemas
- **Be specific** - Include exact file paths and token names
- **Plan for variants** - Think about different use cases
- **Consider the ecosystem** - How does this fit with existing components?
- **Wait for approval** - Don't generate code until plan is approved

## Example Usage

```bash
/ui-plan Badge component with status colors (success, error, warning)
/ui-plan Card for displaying user profile information
/ui-plan Modal dialog with form validation
```

The ui-analyzer subagent will automatically handle the analysis and planning. This planning phase reduces bugs by 30% and ensures we maximize code reuse.