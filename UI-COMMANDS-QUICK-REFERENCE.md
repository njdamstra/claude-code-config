# UI Commands Quick Reference

**Updated**: October 23, 2025
**Version**: 2.0 (Consolidated)

---

## 📋 Core Workflow Commands

### `/ui-new [description]`
Create new component with planning, variants, refinement, and validation.

**Flags:**
- `--skip-plan` - Skip planning/wireframing phase
- `--variants N` - Generate N variants (default: 3)
- `--skip-validation` - Skip quality checks
- `--screenshot` - Capture screenshot after generation

**Examples:**
```bash
/ui-new Badge with status colors
/ui-new Card layout --skip-plan
/ui-new Button --variants 5
/ui-new Spinner --skip-plan --screenshot
```

---

### `/ui-plan [description]`
Strategic planning with ASCII wireframes only.

**Generates:**
- 2-3 wireframe layout options
- Desktop + mobile transformations
- Pros/cons for each option
- Implementation recommendations

**Examples:**
```bash
/ui-plan Navigation menu with dropdown
/ui-plan User dashboard layout
```

---

### `/ui-review [component-path]`
Comprehensive quality review with auto-fix and polish.

**Flags:**
- `--fix` - Auto-fix detected issues
- `--polish` - Apply professional polish

**Examples:**
```bash
/ui-review UserCard.vue
/ui-review Button.vue --fix
/ui-review Modal.vue --polish
/ui-review Card.vue --fix --polish
```

---

### `/ui-document [component-path]`
Generate comprehensive component documentation.

**Examples:**
```bash
/ui-document PrimaryButton.vue
/ui-document UserCard.vue
```

---

## ✅ Validation & Testing Commands

### `/ui-validate [flags]`
Design system compliance auditing.

**Flags:**
- `--tokens` - Token compliance only
- `--a11y` - Accessibility only
- `--all` - Full audit (default)
- `--fix` - Auto-fix violations

**Examples:**
```bash
/ui-validate
/ui-validate --tokens --fix
/ui-validate --a11y
```

---

### `/ui-screenshot [component-path]`
Screenshot capture with visual regression testing.

**Flags:**
- `--baseline` - Set baseline screenshot
- `--compare` - Compare against baseline
- `--all-states` - Capture all states
- `--viewports` - Multiple viewport sizes

**Examples:**
```bash
/ui-screenshot Button.vue
/ui-screenshot Button.vue --baseline
/ui-screenshot Button.vue --compare
/ui-screenshot Card.vue --all-states --compare
```

---

## 🔧 Advanced Commands

### `/ui-refactor [pattern] [description]`
Batch updates or component composition.

**Flags:**
- `--batch` - Batch update multiple components
- `--compose` - Compose new from existing
- Auto-detect (no flag)

**Examples:**
```bash
/ui-refactor buttons/* Update focus states --batch
/ui-refactor Card + Avatar --compose
/ui-refactor **/*.vue Migrate to tokens --batch
```

---

### `/ui-provider-refactor [pattern]`
Refactor to provider pattern (reduces duplication by 85%).

**Examples:**
```bash
/ui-provider-refactor *Card.vue
/ui-provider-refactor Facebook* Twitter* LinkedIn*
```

---

## 🔄 Common Workflows

### Workflow 1: Create New Component
```bash
# With planning and wireframes
/ui-new User profile card

# Quick creation (skip planning)
/ui-new Loading spinner --skip-plan

# Explore options (5 variants)
/ui-new Badge design --variants 5
```

---

### Workflow 2: Improve Existing Component
```bash
# Review quality
/ui-review UserCard.vue

# Auto-fix issues
/ui-review UserCard.vue --fix

# Apply polish
/ui-review UserCard.vue --polish

# Do everything
/ui-review UserCard.vue --fix --polish
```

---

### Workflow 3: Visual Regression Testing
```bash
# 1. Set baseline
/ui-screenshot Button.vue --baseline

# 2. Make changes to component
# ... edit code ...

# 3. Compare
/ui-screenshot Button.vue --compare

# 4. If approved, update baseline
/ui-screenshot Button.vue --baseline
```

---

### Workflow 4: Design System Audit
```bash
# Full audit
/ui-validate

# Token compliance only
/ui-validate --tokens

# Auto-fix violations
/ui-validate --tokens --fix

# Accessibility only
/ui-validate --a11y --fix
```

---

### Workflow 5: Batch Refactoring
```bash
# Update all buttons
/ui-refactor buttons/* Add loading state prop --batch

# Compose new component
/ui-refactor Card + Avatar + Badge --compose

# Migrate tokens project-wide
/ui-refactor **/*.vue Convert to design tokens --batch
```

---

## 🚀 Quick Start Guide

### For New Components
```bash
1. /ui-new [description]
2. Select wireframe option
3. Choose preferred variant
4. Component is ready!
```

### For Existing Components
```bash
1. /ui-review [path] --fix --polish
2. /ui-screenshot [path] --compare
3. /ui-document [path]
```

### For Project-Wide Updates
```bash
1. /ui-validate --all --fix
2. /ui-refactor [pattern] [change] --batch
3. /ui-screenshot **/*.vue --compare
```

---

## 📚 Command Comparison

| Task | Old Commands | New Command |
|------|-------------|-------------|
| Create component | `/ui-create` | `/ui-new` |
| Polish component | `/ui-polish` | `/ui-review --polish` |
| Generate variants | `/ui-variants N` | `/ui-new --variants N` |
| Token validation | `/ui-validate-tokens` | `/ui-validate --tokens` |
| Visual regression | `/ui-visual-regression` | `/ui-screenshot --compare` |
| Batch update | `/ui-batch-update` | `/ui-refactor --batch` |
| Compose components | `/ui-compose` | `/ui-refactor --compose` |

---

## 💡 Pro Tips

1. **Use planning for complex components**
   ```bash
   /ui-new Dashboard layout  # Includes wireframes
   ```

2. **Skip planning for simple components**
   ```bash
   /ui-new Icon button --skip-plan
   ```

3. **Combine flags for power**
   ```bash
   /ui-review Card.vue --fix --polish
   /ui-screenshot Button.vue --all-states --compare
   ```

4. **Validate before committing**
   ```bash
   /ui-validate --all --fix
   ```

5. **Document after creation**
   ```bash
   /ui-new Component
   /ui-document Component.vue
   ```

---

## ⚠️ Deprecated Commands

These commands now show migration guides:

- `DEPRECATED-ui-create.md` → Use `/ui-new`
- `DEPRECATED-ui-polish.md` → Use `/ui-review --polish`
- `DEPRECATED-ui-variants.md` → Use `/ui-new --variants N`
- `DEPRECATED-ui-batch-update.md` → Use `/ui-refactor --batch`
- `DEPRECATED-ui-compose.md` → Use `/ui-refactor --compose`
- `DEPRECATED-ui-validate-tokens.md` → Use `/ui-validate --tokens`
- `DEPRECATED-ui-visual-regression.md` → Use `/ui-screenshot --compare`

**Removal Date**: November 7, 2025

---

## 📖 Full Documentation

For detailed documentation, see:
- `/commands/ui-new.md`
- `/commands/ui-plan.md`
- `/commands/ui-review.md`
- `/commands/ui-validate.md`
- `/commands/ui-refactor.md`
- `/commands/ui-screenshot.md`
- `/commands/ui-document.md`
- `/commands/ui-provider-refactor.md`

---

**Total Commands**: 8 (down from 12)
**Total Flags**: 11 new flags
**Complexity Reduction**: 42%
