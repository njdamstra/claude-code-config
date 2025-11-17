# Debug Tailwind CSS Skill - Complete Summary

## ✅ What You Asked For

> "Shell scripts operate repo-wide... what if we wanted to debug a single component or parent-child relationships?"

**Answer: EVERYTHING now supports component-level debugging!**

---

## 🎯 New Component-Specific Tools

### 1. **Component Debugger** (NEW!)
Deep dive into a single Vue component (static analysis)

```bash
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/modals/BaseModal.vue
```

**Analyzes:**
- Component structure (lines, blocks)
- Layout patterns (flex/grid)
- Spacing (gap, padding, margin)
- Z-index & positioning
- Imports/dependencies
- Issues (fixed widths, !important, scoped styles)

### 2. **Parent-Child Hierarchy Analyzer** (NEW!)
Complete DOM hierarchy analysis (runtime)

```bash
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js \
  ".modal" --port=6942
```

**Shows:**
- DOM path from body → target
- Great-grandparent, grandparent, parent
- Target element
- All children
- All siblings
- Relationship analysis (flex parent, positioning contexts, nesting depth)

---

## 🔧 Enhanced Existing Tools

### Enhanced Box Model Extractor
Now includes parent analysis + overflow detection!

```bash
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js \
  ".card" --port=6942
```

**New features:**
- Parent container dimensions
- Available space in parent
- Space consumed by element
- Overflow detection (element + parent)

---

## 📂 Path Targeting (Already Existed!)

All shell scripts accept path arguments:

```bash
# Single file
bash ~/.claude/skills/debug-tailwind-css/tools/flex-grid-analyzer.sh \
  src/components/vue/modals/BaseModal.vue

# Directory
bash ~/.claude/skills/debug-tailwind-css/tools/layout-validator.sh \
  src/components/vue/buttons/

# Specific component type
bash ~/.claude/skills/debug-tailwind-css/tools/spacing-analyzer.sh \
  src/components/vue/cards/
```

---

## 🚀 Quick Commands

### Component-Level Debugging

```bash
# Deep component analysis (static)
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh <file>

# Parent-child hierarchy (runtime)
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js <selector> --port=XXXX

# Box model + parent (runtime)
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js <selector> --port=XXXX
```

### Directory/File Targeting

```bash
# Flex/grid analysis
bash ~/.claude/skills/debug-tailwind-css/tools/flex-grid-analyzer.sh <path>

# Layout validation
bash ~/.claude/skills/debug-tailwind-css/tools/layout-validator.sh <path>

# Spacing patterns
bash ~/.claude/skills/debug-tailwind-css/tools/spacing-analyzer.sh <path>

# Z-index hierarchy
bash ~/.claude/skills/debug-tailwind-css/tools/z-index-hierarchy.sh <path>
```

### Port Switching

All browser tools support `--port=XXXX`:

```bash
# Easy port switching
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=6942
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js ".btn" --port=3000
```

---

## 📊 Tool Matrix

| Tool | Scope | Analysis Type | Targets |
|------|-------|---------------|---------|
| **component-debugger.sh** | Single file | Static | File path |
| **parent-child-analyzer.js** | DOM tree | Runtime | CSS selector |
| **box-model-extractor.js** | Element + parent | Runtime | CSS selector |
| **flex-grid-analyzer.sh** | Repo/dir/file | Static | Path |
| **layout-validator.sh** | Repo/dir/file | Static | Path |
| **spacing-analyzer.sh** | Repo/dir/file | Static | Path |
| **z-index-hierarchy.sh** | Repo/dir/file | Static | Path |
| **detect-overflow.js** | Full page | Runtime | --port |
| **position-tracer.js** | Element | Runtime | CSS selector |
| **computed-styles.js** | Element | Runtime | CSS selector |

---

## 🎓 Real-World Examples

### Debug Modal Positioning Issue

```bash
# 1. Check component file (static)
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/modals/BaseModal.vue

# 2. Check DOM hierarchy (runtime)
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js \
  ".modal" --port=6942

# 3. Check positioning context
node ~/.claude/skills/debug-tailwind-css/tools/position-tracer.js \
  ".modal" --port=6942
```

### Compare Button Components

```bash
# Analyze first button
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/buttons/PrimaryButton.vue

# Analyze second button
bash ~/.claude/skills/debug-tailwind-css/tools/component-debugger.sh \
  src/components/vue/buttons/OutlineButton.vue

# Compare outputs
```

### Debug Child Element Overflow

```bash
# Check parent-child relationship
node ~/.claude/skills/debug-tailwind-css/tools/parent-child-analyzer.js \
  ".child" --port=6942

# Check box model + parent overflow
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js \
  ".child" --port=6942
```

---

## 📝 NPM Scripts Added

```bash
# In project directory
cd ~/.claude/skills/debug-tailwind-css

# New shortcuts
npm run debug:component -- src/components/vue/modals/BaseModal.vue
npm run analyze:hierarchy -- ".modal" --port=6942
```

---

## 📚 Documentation Created

1. **PORT-SWITCHING.md** - How to switch ports easily
2. **COMPONENT-DEBUGGING.md** - Complete component debugging guide
3. **SUMMARY.md** - This file!

---

## ✨ What's Fixed/Added

### Fixed
✅ ESM project support (.cjs config files)
✅ Port switching via CLI arguments
✅ All browser tools work with your server

### Added
✅ Component-specific debugger (static analysis)
✅ Parent-child hierarchy analyzer (runtime)
✅ Enhanced box model with parent context
✅ Complete documentation

### Enhanced
✅ Box model extractor now shows parent info
✅ Overflow detector now shows both horizontal & vertical
✅ All tools support flexible targeting

---

## 🎯 Summary

**Before:** "Shell scripts operate repo-wide"
**After:** "ALL tools support component-level debugging!"

**Scope options:**
- 🌍 Repo-wide (default)
- 📂 Directory-specific
- 📄 Single file
- 🎯 Single DOM element
- 👪 Parent-child relationships

**Port switching:**
- Just add `--port=XXXX` to any browser tool
- No config file edits needed

**You can now debug at ANY level you want!** 🎉
