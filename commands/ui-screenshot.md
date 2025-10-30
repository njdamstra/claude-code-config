---
description: Capture component screenshots with visual regression testing and baseline management
argument-hint: [component-path] [--baseline] [--compare] [--all-states]
allowed-tools: bash, write, read, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Screenshot

Capture high-quality screenshot of a component using Playwright for visual documentation and design reviews.

## Usage

```bash
/ui-screenshot src/components/vue/buttons/PrimaryButton.vue
/ui-screenshot PrimaryButton.vue --baseline
/ui-screenshot Card.vue --compare
/ui-screenshot Button.vue --all-states --compare
```

**Syntax**: `/ui-screenshot [component-path] [--flags]`

## Flags

- `--baseline` - Set current screenshot as baseline for future comparisons
- `--compare` - Compare against baseline and generate diff report
- `--all-states` - Capture multiple state variations (default, hover, active, disabled, loading)
- `--viewports` - Capture at multiple viewport sizes (mobile, tablet, desktop)
- `--themes` - Capture in light and dark modes

## Process

Capture screenshot for: $ARGUMENTS

### Step 1: Setup Preview
1. Create or locate component preview page
2. Import component
3. Set up example props
4. Apply design system styles

### Step 2: Start Dev Server
```bash
npm run dev
# Wait for server at http://localhost:5173
```

### Step 3: Capture Screenshot (ui-validator)
```javascript
// Run Playwright
await page.goto('/component-preview')
await page.waitForSelector('[data-testid="component"]')
await expect(page).toHaveScreenshot('ComponentName.png')
```

### Step 4: Save & Display
1. Save to `screenshots/` directory
2. If `--baseline` flag: Save to `tests/visual-baselines/`
3. If `--compare` flag: Compare against baseline, generate diff
4. Generate markdown with embedded image(s)
5. Display to user

### Step 5: Visual Regression (if --compare flag)
1. Load baseline screenshot from `tests/visual-baselines/`
2. Compare pixel-by-pixel using pixelmatch
3. Calculate difference percentage
4. Generate diff image with highlighted changes (red overlay)
5. Provide approval/rejection workflow

## Options

### --all-states
Capture multiple state variations:
```bash
/ui-screenshot Button.vue --all-states
```
Captures:
- Default state
- Hover state
- Active state
- Disabled state
- Loading state (if applicable)
- Error state (if applicable)

### --viewports
Capture at multiple viewport sizes:
```bash
/ui-screenshot Card.vue --viewports
```
Captures at:
- Mobile: 375x667
- Tablet: 768x1024
- Desktop: 1920x1080

### --themes
Capture in different themes:
```bash
/ui-screenshot Component.vue --themes
```
Captures:
- Light mode
- Dark mode (if supported)

### --browsers
Capture across browsers:
```bash
/ui-screenshot Component.vue --browsers
```
Captures in:
- Chromium
- Firefox
- WebKit (Safari)

## Playwright Setup

### Config for Mac Pro 2019
```typescript
// tests/screenshot.config.ts
import { defineConfig } from '@playwright/test'

export default defineConfig({
  testDir: './tests/screenshots',
  use: {
    baseURL: 'http://localhost:5173',
    viewport: { width: 1280, height: 720 },
    launchOptions: {
      args: [
        '--disable-gpu',              // Mac Pro optimization
        '--disable-dev-shm-usage',
      ],
      slowMo: 50,                    // Add slight delay
    },
    screenshot: 'only-on-failure',
    video: 'off',
    trace: 'off',
  },
  workers: 1,                        // Single worker for consistency
  timeout: 30000,
})
```

### Screenshot Script
```typescript
// tests/screenshots/capture.spec.ts
import { test, expect } from '@playwright/test'

test('ComponentName screenshot', async ({ page }) => {
  // Navigate to preview
  await page.goto('/component-preview?component=ComponentName')
  
  // Wait for component to render
  await page.waitForSelector('[data-testid="component-root"]', {
    state: 'visible',
    timeout: 10000
  })
  
  // Wait for animations to complete
  await page.waitForTimeout(500)
  
  // Capture screenshot
  const component = page.locator('[data-testid="component-root"]')
  await component.screenshot({
    path: 'screenshots/ComponentName.png',
    animations: 'disabled',
  })
})
```

## Preview Page Template

```vue
<!-- src/pages/component-preview.astro -->
---
const { component } = Astro.url.searchParams
---

<html>
  <head>
    <link rel="stylesheet" href="/src/styles/design-system.css" />
    <style>
      body {
        margin: 0;
        padding: 24px;
        background: var(--color-background);
        font-family: var(--font-sans);
      }
      
      .preview-container {
        max-width: 800px;
        margin: 0 auto;
      }
    </style>
  </head>
  <body>
    <div class="preview-container">
      <div id="component-root" data-testid="component-root">
        <!-- Component renders here -->
      </div>
    </div>
    
    <script>
      import { component } from './components/vue/{component}.vue'
      // Mount component...
    </script>
  </body>
</html>
```

## Output Format

### Standard Screenshot (no flags)
```markdown
# 📸 Screenshot: [ComponentName]

**Component**: `$ARGUMENTS`
**Captured**: [Timestamp]
**Resolution**: 1280x720

---

## 🖼️ Screenshot

![ComponentName](screenshots/ComponentName.png)

**File**: `screenshots/ComponentName.png`

---

## 📊 Capture Details

| Property | Value |
|----------|-------|
| **Viewport** | 1280x720 |
| **Browser** | Chromium |
| **Theme** | Light |
| **State** | Default |
| **File Size** | 45 KB |
```

### With --baseline Flag
```markdown
# 📸 Baseline Set: [ComponentName]

**Component**: `$ARGUMENTS`
**Baseline Captured**: [Timestamp]

---

## 🖼️ Baseline Screenshot

![ComponentName Baseline](tests/visual-baselines/ComponentName.png)

**Files:**
- Baseline: `tests/visual-baselines/ComponentName.png`
- Current: `screenshots/ComponentName.png`

**Status**: ✅ Baseline established

---

## 🚀 Next Steps

Run visual regression test:
```bash
/ui-screenshot ComponentName.vue --compare
```
\```

### With --compare Flag
```markdown
# 🔍 Visual Regression: [ComponentName]

**Component**: `$ARGUMENTS`
**Tested**: [Timestamp]

---

## 📊 Test Results

### Status: [✅ PASS | ⚠️ DIFF | ❌ FAIL]

**Metrics:**
- **Pixel Difference**: 245 pixels
- **Percentage**: 2.3% of image
- **Threshold**: 1.0% (exceeded ⚠️)
- **Baseline**: tests/visual-baselines/ComponentName.png
- **Current**: screenshots/ComponentName.png
- **Diff**: tests/visual-diffs/ComponentName-diff.png

---

## 🖼️ Visual Comparison

### Baseline (Expected)
![Baseline](tests/visual-baselines/ComponentName.png)

### Current (Actual)
![Current](screenshots/ComponentName.png)

### Difference (Highlighted)
![Diff](tests/visual-diffs/ComponentName-diff.png)

**Red areas** indicate pixel differences

---

## 📈 Diff Analysis

### Changed Areas Detected:
1. **Button border** (line 45-48)
   - Color changed: `#3B82F6` → `#2563EB`
   - Pixels affected: 156

2. **Text shadow** (line 67)
   - New shadow added
   - Pixels affected: 89

### Root Causes:
- Design token update: `--color-primary-500` changed
- CSS change: Added `text-shadow` property

---

## ⚠️ Decision Required

**Difference exceeds threshold** (2.3% > 1.0%)

**Options:**

1. **Approve Changes** - Update baseline
   ```bash
   /ui-screenshot ComponentName.vue --baseline
   ```

2. **Reject Changes** - Fix the component
   - Review the changes in the code
   - Revert unintended modifications
   - Re-test after fixes

3. **Adjust Threshold** - If diff is acceptable
   - Modify threshold in test config if visual changes are minor
\```

---

## 🎯 Additional States (if --all-states)

### Default State
![Default](screenshots/ComponentName-default.png)

### Hover State
![Hover](screenshots/ComponentName-hover.png)

### Active State
![Active](screenshots/ComponentName-active.png)

### Disabled State
![Disabled](screenshots/ComponentName-disabled.png)

---

## 📱 Responsive Views (if --viewports)

### Mobile (375x667)
![Mobile](screenshots/ComponentName-mobile.png)

### Tablet (768x1024)
![Tablet](screenshots/ComponentName-tablet.png)

### Desktop (1920x1080)
![Desktop](screenshots/ComponentName-desktop.png)

---

## 🌓 Theme Variants (if --themes)

### Light Mode
![Light](screenshots/ComponentName-light.png)

### Dark Mode
![Dark](screenshots/ComponentName-dark.png)

---

## 🚀 Next Steps

1. **Use in documentation**: Add to component docs
2. **Share for review**: Use for design approval
3. **Set as baseline**: Use for visual regression testing
4. **Update regularly**: Capture after major changes

**Screenshot saved to**: `screenshots/ComponentName.png`
\```

## Screenshot Best Practices

### Preparation
✅ **Clean state**: No external data or API calls
✅ **Representative props**: Use realistic example data
✅ **Design system applied**: All tokens loaded
✅ **Animations complete**: Wait for transitions

### Capture Settings
✅ **Consistent viewport**: Always use same size
✅ **Disable animations**: For consistent screenshots
✅ **Wait for rendering**: Ensure component is fully loaded
✅ **Clip to component**: Don't capture entire page

### File Management
✅ **Organized directories**: Group by component type
✅ **Clear naming**: `ComponentName-state-viewport.png`
✅ **Version control**: Commit screenshots with code
✅ **Optimize size**: Compress images if large

## Troubleshooting

### Issue: Screenshot is blank
**Solution**: Increase wait timeout
```typescript
await page.waitForSelector('[data-testid="component"]', {
  timeout: 15000
})
```

### Issue: Component not styled
**Solution**: Ensure design-system.css is loaded
```html
<link rel="stylesheet" href="/src/styles/design-system.css" />
```

### Issue: Screenshot shows loading state
**Solution**: Wait for async data
```typescript
await page.waitForLoadState('networkidle')
```

### Issue: Playwright fails on Mac Pro
**Solution**: Add GPU optimization flags
```typescript
launchOptions: {
  args: ['--disable-gpu', '--no-sandbox']
}
```

## Automation

### Git Hook (Optional)
Capture screenshot on component changes:

```bash
# .claude/hooks/after-edit.sh
#!/bin/bash

if [[ $EDITED_FILE == *".vue" ]]; then
  echo "Capturing screenshot for $EDITED_FILE..."
  npx playwright test tests/screenshots/capture.spec.ts
fi
```

### CI/CD Integration
```yaml
# .github/workflows/screenshots.yml
name: Component Screenshots

on:
  pull_request:
    paths:
      - 'src/components/**/*.vue'

jobs:
  screenshots:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run screenshot
      - uses: actions/upload-artifact@v3
        with:
          name: screenshots
          path: screenshots/
```

## Screenshot Gallery

Auto-generate gallery of all component screenshots:

```markdown
# Component Gallery

## Buttons
![PrimaryButton](screenshots/PrimaryButton.png)
![SecondaryButton](screenshots/SecondaryButton.png)

## Cards
![UserCard](screenshots/UserCard.png)
![PostCard](screenshots/PostCard.png)

[Auto-generated from /screenshots directory]
```

## Time Estimate

- Setup preview: 1-2 minutes
- Start dev server: 30 seconds
- Capture screenshot: 30 seconds
- Save and display: 30 seconds
- **Total: 3-4 minutes**

With --all-states: 5-7 minutes
With --viewports: 6-8 minutes

## Integration

This command uses:
- **ui-validator** subagent for Playwright execution
- Astro preview page for component rendering
- Local dev server for live preview

Can be used for:
- Visual documentation
- Design reviews
- PR previews
- Visual regression baselines
- Component gallery

Quick, easy, and essential for visual component work.