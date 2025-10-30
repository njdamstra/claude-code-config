---
name: ui-polish
description: Automatically polish existing component with professional touches
autoApprove: false
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
Tailored for: Vue 3 + Astro + Appwrite + Nanostore stack
See: SOC_UI_INTEGRATION.md for foundation details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Polish Command

Automatically enhance an existing component with professional polish.

## Usage

```bash
/ui-polish src/components/vue/UserCard.vue
```

## Process

1. **Analyze Current State**
   - Run ui-analyzer scoring
   - Identify polish gaps

2. **Apply Enhancements**

   **Interactive States:**
   - Add missing hover/focus/active states
   - Use `focus-ring` utility class (from Part 1 plugin)
   - Use `transition-fast`, `transition-medium` (from Part 1 Tailwind config)
   - Use `shadow-focus-primary`, `shadow-focus-error` (from Part 1 plugin)
   - Ensure focus rings on all interactive elements
   - Add proper disabled states
   - Implement loading states where applicable

   **Motion:**
   - Use `ANIMATION_DURATION` constants from '@/constants/animations'
   - Use `EASING` constants from '@/constants/animations'
   - Apply Tailwind animation utilities: `animate-fade-in`, `animate-slide-in-up`
   - Add transitions with `transition-fast ease-smooth`
   - Add prefers-reduced-motion support
   - Use existing animation system (useAnimateElement or VueUse Motion)

   **Depth:**
   - Use `shadow-{sm,md,lg,xl}` (from Part 1 Tailwind config)
   - Use `glass-{subtle,medium,strong}` (from Part 1 plugin for glassmorphism)
   - Layer with `bg-neutral-{50,100}` (from Part 1 color scale)
   - Convert borders to shadows (except inputs/focus states)
   - Add color layering for elevation
   - Implement dual-shadow system

   **Typography:**
   - Use `text-{base,lg,xl,2xl}` with proper line heights (from Part 1)
   - Use `font-{medium,semibold,bold}` (from Part 1)
   - Use `leading-{tight,normal,relaxed}` (from Part 1)
   - Fix any scale violations
   - Correct font weights
   - Adjust line heights
   - Verify color contrast (WCAG AA minimum)

   **Spacing:**
   - Standardize to spacing scale (4, 6, 8, 12, 16, 24, 32)
   - Fix any arbitrary values (pl-10 → pl-12)
   - Ensure consistent rhythm
   - Use gap utilities for flex/grid layouts

3. **Before/After Comparison**
   - Take screenshot of original
   - Apply changes
   - Take screenshot of polished version
   - Show side-by-side comparison

4. **Report**
   ```
   🎨 UI Polish Complete

   Improvements Made:
   - ✅ Added focus rings to 3 buttons
   - ✅ Converted 4 borders to shadows
   - ✅ Added hover transitions (200ms ease-out)
   - ✅ Fixed 2 spacing inconsistencies
   - ✅ Added prefers-reduced-motion support

   Scores:
   Before: 72/100
   After: 94/100
   Improvement: +22 points

   Visual Changes:
   [Screenshot comparison]
   ```

## Approval Gates

- Pause after analysis, show proposed changes
- Wait for user approval
- Apply changes
- Show before/after

## Safety Checks

- Never remove functionality
- Preserve existing behavior
- Only enhance visuals/interaction
- Maintain accessibility
- Keep responsiveness intact
