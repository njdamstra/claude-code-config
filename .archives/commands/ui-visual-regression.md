---
description: Run visual regression tests comparing component screenshots against baselines with pixel diff analysis
argument-hint: [component-path] [--update-baselines]
allowed-tools: bash, read, write, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Visual Regression Testing

Automated visual regression testing with pixel-perfect comparison, diff highlighting, and baseline management.

## Usage

```bash
/ui-visual-regression src/components/vue/buttons/PrimaryButton.vue
/ui-visual-regression Button.vue
/ui-visual-regression **/*.vue --update-baselines
```

**Syntax**: `/ui-visual-regression [component-path] [--options]`

## Process

Test component: $ARGUMENTS

### Step 1: Check for Baseline
1. Look for existing baseline screenshot
2. Location: `tests/visual-baselines/ComponentName.png`
3. If not found, capture and set as baseline
4. If found, proceed to comparison

### Step 2: Capture Current Screenshot
1. Start dev server if needed
2. Navigate to component preview
3. Wait for full render
4. Capture screenshot at same viewport as baseline

### Step 3: Compare Images (ui-validator)
```typescript
// Playwright visual comparison
await expect(page).toHaveScreenshot('ComponentName.png', {
  maxDiffPixels: 100,        // Max pixels that can differ
  threshold: 0.2,            // Threshold for pixel difference
  maxDiffPixelRatio: 0.01,   // Max 1% pixels can differ
})
```

### Step 4: Generate Diff Report
If differences detected:
1. Create diff image with highlights
2. Calculate difference percentage
3. Generate side-by-side comparison
4. Determine if change is acceptable

### Step 5: User Decision
If diff exceeds threshold:
1. Show visual comparison
2. Ask user to approve/reject
3. Update baseline if approved
4. Fail test if rejected

## Baseline Management

### Initial Baseline Capture
```bash
# First run - no baseline exists
/ui-visual-regression Button.vue

Output:
✅ No baseline found - capturing initial baseline
📸 Baseline saved: tests/visual-baselines/Button.png
```

### Baseline Update
```bash
# After intentional visual changes
/ui-visual-regression Button.vue --update-baselines

Output:
🔄 Updating baseline screenshot...
✅ Baseline updated: tests/visual-baselines/Button.png
```

### Baseline Approval Workflow
```bash
# After changes, review diff first
/ui-visual-regression Button.vue

Output:
⚠️ Visual difference detected: 2.3%
📊 Review diff: tests/visual-diffs/Button-diff.png

Approve changes and update baseline? (yes/no)
```

## Diff Analysis

### Diff Image Generation
```typescript
// Generate diff with highlighted changes
import pixelmatch from 'pixelmatch'
import { PNG } from 'pngjs'

const diff = new PNG({ width, height })
const numDiffPixels = pixelmatch(
  baseline.data,
  current.data,
  diff.data,
  width,
  height,
  {
    threshold: 0.1,
    diffColor: [255, 0, 0],  // Red highlight
    alpha: 0.5,              // Semi-transparent
  }
)

// Save diff image
fs.writeFileSync('tests/visual-diffs/ComponentName-diff.png', PNG.sync.write(diff))
```

### Difference Metrics
Calculate multiple metrics:
- **Pixel Difference**: Number of different pixels
- **Percentage Difference**: % of pixels that differ
- **Color Distance**: Average color difference
- **Structural Similarity**: SSIM score

## Output Format

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
   /ui-visual-regression ComponentName.vue --update-baselines
   ```

2. **Reject Changes** - Fix the component
   - Review the changes in the code
   - Revert unintended modifications
   - Re-test after fixes

3. **Adjust Threshold** - If diff is acceptable
   ```typescript
   // In test config
   maxDiffPixelRatio: 0.03  // Allow up to 3%
   ```

---

## 🎯 Recommendations

**Change Assessment:** ⚠️ Review Needed

**Reasoning:**
- Changes appear intentional (design token update)
- Visual improvement detected
- No functional issues

**Suggested Action:**
✅ **Approve and update baseline**
- Changes are consistent with design system update
- No negative visual impact
- Safe to update baseline

---

## 📝 Test History

| Date | Result | Diff % | Action |
|------|--------|--------|--------|
| 2025-10-22 | PASS | 0.1% | None |
| 2025-10-20 | DIFF | 2.3% | Approved |
| 2025-10-18 | PASS | 0.0% | None |

---

## 🚀 Next Steps

**If Approved:**
1. Update baseline with --update-baselines flag
2. Document change in component changelog
3. Update component documentation if needed
4. Deploy to staging for testing

**If Rejected:**
1. Review recent code changes
2. Check design token updates
3. Fix unintended visual changes
4. Re-run visual regression test
\```

## Options

### --update-baselines
Update baseline screenshots without comparing:
```bash
/ui-visual-regression Button.vue --update-baselines
```
Use after approved visual changes.

### --threshold [value]
Set custom difference threshold:
```bash
/ui-visual-regression Button.vue --threshold 0.05
```
Allows up to 5% difference.

### --ignore-antialiasing
Ignore antialiasing differences:
```bash
/ui-visual-regression Button.vue --ignore-antialiasing
```
Useful for cross-browser testing.

### --all-components
Test all components in project:
```bash
/ui-visual-regression --all-components
```
Run full regression suite.

## Thresholds & Tolerances

### Default Tolerances
```typescript
{
  maxDiffPixels: 100,          // Max individual pixels
  maxDiffPixelRatio: 0.01,     // Max 1% of total pixels
  threshold: 0.2,              // Per-pixel color threshold
}
```

### Recommended Thresholds by Component Type

**Buttons & Small Components**: 0.5% (very strict)
**Cards & Medium Components**: 1.0% (standard)
**Pages & Large Components**: 2.0% (lenient)
**Animated Components**: 3.0% (allow frame variations)

## Handling Common Differences

### Antialiasing Differences
```typescript
// Increase threshold slightly
threshold: 0.3  // Instead of 0.2
```

### Font Rendering Variations
```typescript
// Use text diffing instead
diffStrategy: 'text-only'
```

### Dynamic Content (dates, random data)
```typescript
// Mask dynamic areas
mask: [
  { x: 10, y: 10, width: 100, height: 20 }  // Mask date display
]
```

### Animation Frame Differences
```typescript
// Disable animations
await page.evaluate(() => {
  document.body.style.setProperty('--animation-duration', '0s')
})
```

## CI/CD Integration

### GitHub Actions Workflow
```yaml
name: Visual Regression Tests

on:
  pull_request:
    paths:
      - 'src/components/**/*.vue'
      - 'src/styles/**/*.css'

jobs:
  visual-regression:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npx playwright install --with-deps
      
      # Run visual regression tests
      - run: npm run test:visual
      
      # Upload diff images on failure
      - uses: actions/upload-artifact@v3
        if: failure()
        with:
          name: visual-diffs
          path: tests/visual-diffs/
          
      # Comment on PR with results
      - name: Comment PR
        if: failure()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '⚠️ Visual regression tests failed. Check artifacts for diff images.'
            })
```

## Best Practices

### DO:
✅ **Establish baselines** - Capture good baseline first
✅ **Review diffs carefully** - Don't blindly approve
✅ **Update baselines deliberately** - Only for intentional changes
✅ **Run before PRs** - Catch issues early
✅ **Document changes** - Note why baseline updated

### DON'T:
❌ **Skip reviews** - Always review visual diffs
❌ **Set threshold too high** - Defeats the purpose
❌ **Ignore small changes** - They can compound
❌ **Update without approval** - Get design approval first
❌ **Test with animations** - Disable for consistency

## Troubleshooting

### Issue: Too Many False Positives
**Solution**: Adjust threshold or ignore antialiasing
```typescript
threshold: 0.3,
ignoreAntialiasing: true
```

### Issue: Baselines Out of Date
**Solution**: Batch update all baselines
```bash
/ui-visual-regression --all-components --update-baselines
```

### Issue: Cross-Browser Differences
**Solution**: Maintain separate baselines per browser
```
tests/visual-baselines/
  chromium/ComponentName.png
  firefox/ComponentName.png
  webkit/ComponentName.png
```

### Issue: Mac Pro Performance
**Solution**: Use optimized Playwright config
```typescript
workers: 1,
timeout: 60000,
launchOptions: { args: ['--disable-gpu'] }
```

## Time Estimate

Per component:
- Baseline capture: 30 seconds
- Current capture: 30 seconds
- Comparison: 10 seconds
- Diff generation: 10 seconds
- **Total: 80 seconds**

For full suite (50 components): ~60-70 minutes

## Integration

This command uses:
- **ui-validator** subagent for Playwright execution
- **pixelmatch** library for pixel comparison
- Baseline management system
- Diff visualization tools

Essential for:
- Preventing visual regressions
- Design system compliance
- Cross-browser consistency
- PR quality gates

Catch visual bugs before users do.