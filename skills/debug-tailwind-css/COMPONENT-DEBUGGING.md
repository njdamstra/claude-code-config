# Component-Level Debugging Guide

## Quick Reference: Scope Control

### ✅ **Yes! All tools support component-specific debugging**

You're not limited to repo-wide analysis. Here's how to target specific components:

---

## 🎯 Component-Specific Analysis

### 1. **Single Component Deep Dive**

```bash
# Analyze everything about ONE component
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/modals/BaseModal.vue
```

**Output:**
- Component structure (lines, blocks)
- Layout patterns (flex/grid usage)
- Spacing patterns (gap, padding, margin)
- Z-index & positioning
- Component dependencies (imports)
- Potential issues (fixed widths, !important, scoped styles)

### 2. **Parent-Child Relationships**

```bash
# See complete hierarchy: grandparent → parent → element → children
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js \
  ".modal" --port=6942
```

**Output:**
- DOM path from body to element
- Great-grandparent, grandparent, parent info
- Target element details
- All children
- All siblings
- Relationship analysis (positioning contexts, stacking contexts, nesting depth)

### 3. **Enhanced Box Model with Parent Context**

```bash
# See box model + parent container info + overflow detection
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js \
  ".card" --port=6942
```

**Output:**
- Element dimensions, padding, margin, border
- **Parent container** dimensions and layout
- **Available space** in parent
- **Space consumed** by padding/border
- **Overflow detection** (both element and parent overflow)

---

## 📂 Directory-Specific Analysis

### Static Analysis Tools (Shell Scripts)

All shell scripts accept **path arguments**:

```bash
# Analyze all modals
bash ~/.claude/skills/debug-tailwind-css/tools/flex-grid-analyzer.sh \
  src/components/vue/modals/

# Analyze single component
bash ~/.claude/skills/debug-tailwind-css/tools/flex-grid-analyzer.sh \
  src/components/vue/cards/ActivityCard.vue

# Analyze buttons directory
bash ~/.claude/skills/debug-tailwind-css/tools/spacing-analyzer.sh \
  src/components/vue/buttons/

# Validate layouts in dashboard
bash ~/.claude/skills/debug-tailwind-css/tools/layout-validator.sh \
  src/components/vue/dashboard/
```

**Available Shell Scripts:**
- `flex-grid-analyzer.sh [path]` - Flexbox/Grid patterns
- `layout-validator.sh [path]` - Common layout issues
- `spacing-analyzer.sh [path]` - Gap/padding/margin audit
- `z-index-hierarchy.sh [path]` - Z-index usage
- `tailwind-class-audit.sh [path]` - Most-used classes

---

## 🔬 Real-World Debugging Workflows

### Workflow 1: "Why is this modal positioned wrong?"

```bash
# 1. Check parent-child hierarchy
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js \
  ".modal" --port=6942

# 2. Check positioning context chain
node ~/.claude/skills/debug-tailwind-css/tools/position-tracer.js \
  ".modal" --port=6942

# 3. Analyze box model and parent overflow
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js \
  ".modal" --port=6942
```

### Workflow 2: "Why does this button look wrong on mobile?"

```bash
# 1. Deep component analysis (static)
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/buttons/PrimaryButton.vue

# 2. Check box model at runtime
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js \
  ".btn-primary" --port=6942

# 3. Check for fixed widths (causes mobile issues)
grep "w-\[.*px\]\|width:.*px" src/components/vue/buttons/PrimaryButton.vue
```

### Workflow 3: "Compare two similar components"

```bash
# Analyze first component
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/cards/PostCard.vue

# Analyze second component
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/cards/CompactPostCard.vue

# Compare the outputs side-by-side
```

### Workflow 4: "Debug parent container issues"

```bash
# 1. Check parent-child relationship
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js \
  ".child-element" --port=6942

# 2. Enhanced box model shows parent dimensions
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js \
  ".child-element" --port=6942
```

---

## 🧰 Tool Comparison Matrix

| Tool | Scope | Input | Output Type |
|------|-------|-------|-------------|
| `component-debugger.sh` | Single file | File path | Static analysis report |
| `parent-child-analyzer.js` | DOM hierarchy | CSS selector | Runtime hierarchy tree |
| `box-model-extractor.js` | Single element + parent | CSS selector | Runtime box model + parent |
| `flex-grid-analyzer.sh` | Files/dirs | Directory path | Static flex/grid audit |
| `layout-validator.sh` | Files/dirs | Directory path | Static layout issues |
| `spacing-analyzer.sh` | Files/dirs | Directory path | Static spacing patterns |

---

## 💡 Pro Tips

### 1. **Combine Static + Runtime Analysis**

```bash
# Static: What classes are used?
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/modals/BaseModal.vue

# Runtime: What are the computed values?
node ~/.claude/skills/debug-tailwind-css/tools/computed-styles.js \
  ".modal" --port=6942
```

### 2. **Target Specific CSS Selectors**

All browser tools accept **any CSS selector**:

```bash
# ID selector
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js \
  "#user-profile" --port=6942

# Class selector
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js \
  ".dashboard-card" --port=6942

# Complex selector
node ~/.claude/skills/debug-tailwind-css/tools/position-tracer.js \
  ".modal .modal-header button" --port=6942

# Attribute selector
node ~/.claude/skills/debug-tailwind-css/tools/computed-styles.js \
  "[data-testid='submit-button']" --port=6942
```

### 3. **Output Files for Deeper Analysis**

All tools save detailed JSON/text reports to `.debug-output/`:

```bash
# Run analysis
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/cards/WorkflowCard.vue

# View full report
cat .debug-output/component-debug-WorkflowCard.txt

# Or view JSON for programmatic use
cat .debug-output/hierarchy-analysis.json | jq '.children[] | .tagName'
```

---

## 🚀 Quick Commands Cheat Sheet

```bash
# Component deep dive (static)
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh <file>

# Parent-child hierarchy (runtime)
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js <selector> --port=XXXX

# Box model + parent info (runtime)
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js <selector> --port=XXXX

# Directory analysis (static)
bash ~/.claude/skills/debug-tailwind-css/tools/flex-grid-analyzer.sh <directory>
bash ~/.claude/skills/debug-tailwind-css/tools/layout-validator.sh <directory>
bash ~/.claude/skills/debug-tailwind-css/tools/spacing-analyzer.sh <directory>

# Overflow detection (runtime)
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=XXXX
```

---

## 📊 Example Outputs

### Component Debugger Output

```
=== COMPONENT DEBUG REPORT: BaseModal ===
File: src/components/vue/modals/BaseModal.vue

COMPONENT STRUCTURE:
  Total lines: 163
  Uses Flexbox: ✓
  Uses Grid: ✗

SPACING PATTERNS:
  Gap: 2 px-6, 1 py-4
  Padding: 2 p-, 1 pt-4

POTENTIAL ISSUES:
  ⚠️ Fixed pixel widths found (may break responsive)
  ⚠️ No flex-wrap found
  ✓ Uses scoped styles
```

### Parent-Child Analyzer Output

```
📍 DOM Path (body → target):
└─ nav [block]
  └─ div.container [block]
    └─ div.flex [flex]
      └─ button.btn [flex]

👪 Parent: div.flex.items-center
  Display: flex
  Dimensions: 800px × 64px
  Children: 3

🎯 Target: button.btn-primary
  Display: flex
  Position: relative
  Padding: 8px 16px
  Children: 2 (icon + text)

🔍 Relationship Analysis:
  ✓ Parent is flexbox container
  ⚠️ Deep nesting (7 levels)
```

---

## Summary

✅ **Static analysis tools** - Accept file/directory paths
✅ **Browser tools** - Accept CSS selectors
✅ **New tools** - Purpose-built for component debugging
✅ **Flexible** - Mix static + runtime analysis
✅ **Detailed** - Parent-child relationships fully mapped

**You can debug at ANY level: repo-wide, directory, single file, or single DOM element!**
