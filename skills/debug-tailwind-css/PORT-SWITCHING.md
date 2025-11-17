# Port Switching Guide

## TL;DR - Super Easy Port Switching

Just add `--port=XXXX` to any browser tool command:

```bash
# Whatever port you're running on
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=6942
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js "h1" --port=3000
node ~/.claude/skills/debug-tailwind-css/tools/computed-styles.js "body" --port=4321
node ~/.claude/skills/debug-tailwind-css/tools/position-tracer.js ".modal" --port=8080
```

## Priority Order (Highest to Lowest)

1. **CLI `--port=` argument** ← Overrides everything
2. **CLI `--url=` argument** ← Overrides config file
3. **Config file** `.debug-tailwind-css.config.cjs` or `.js`
4. **Default** `http://localhost:4321`

## Examples

### Different Projects, Different Ports

```bash
# Project A on port 3000
cd ~/project-a
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=3000

# Project B on port 6942
cd ~/project-b
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=6942

# Project C on port 8080
cd ~/project-c
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=8080
```

### Persistent Config (One-Time Setup)

If you always use the same port for a project:

```bash
# In your project directory
cat > .debug-tailwind-css.config.cjs << 'EOF'
module.exports = {
  baseUrl: 'http://localhost:6942',
  outputDir: '.debug-output'
};
EOF

# Now all tools use port 6942 by default
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js "h1"
```

### Override Config File Temporarily

```bash
# Config file says port 6942, but override to 3000 for this run
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=3000
```

## Browser Tools (Support Port Switching)

✅ `detect-overflow.js` - Horizontal scroll detection
✅ `box-model-extractor.js` - Element box model analysis
✅ `computed-styles.js` - Runtime computed styles
✅ `position-tracer.js` - Positioning context chain

## Static Analysis Tools (No Port Needed)

These scan your code files, don't need a running server:
- `flex-grid-analyzer.sh`
- `layout-validator.sh`
- `spacing-analyzer.sh`
- `z-index-hierarchy.sh`
- `tailwind-class-audit.sh`
- `duplicate-detector.sh`

## Why .cjs Extension?

If your project has `"type": "module"` in package.json (ESM), Node.js won't load `.js` files as CommonJS. Use `.cjs` for the config file so it loads properly.

The tools check for `.cjs` first, then fall back to `.js` automatically.
