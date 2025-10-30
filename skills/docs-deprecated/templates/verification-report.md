

# Verification Report Template

## Report Metadata

```json
{
  "report_type": "[accuracy/completeness/example-validation]",
  "topic": "[topic-name]",
  "timestamp": "2025-10-29T12:00:00Z",
  "subagent": "[subagent-name]",
  "phase": "phase4-verification"
}

---

## Accuracy Verification Report

### Overall Summary

- **Claims Verified:** [count]
- **Critical Issues:** [count]
- **Warning Issues:** [count]
- **Status:** [PASS/FAIL/WARNING]

### Verification Details

#### File Paths

**Verified:** [count] / [total]

✓ Correct file paths:
- `path/to/file1.ts`
- `path/to/file2.vue`

✗ Incorrect file paths:
- **Claim:** `old/path/to/file.ts`
- **Actual:** `new/path/to/file.ts`
- **Fix:** Update documentation line XX

#### Function Signatures

**Verified:** [count] / [total]

✓ Correct signatures:
- `functionName(param: Type): ReturnType`

⚠ Signature mismatches:
- **Claim:** `useComposable(config)`
- **Actual:** `useComposable(config, options?)`
- **Fix:** Add optional options parameter to docs

#### Code Examples

**Verified:** [count] / [total]

✓ Valid examples: [count]
✗ Invalid examples: [count]

**Example 1 (Line XX):**
- **Issue:** Missing import statement
- **Fix:** Add `import { useStore } from '@nanostores/vue'`

#### Dependencies

**Verified:** [count] / [total]

✓ Verified in package.json:
- `nanostore@^0.9.0`
- `vue@^3.4.0`

⚠ Version mismatch:
- **Claim:** `tailwindcss@^3.0.0`
- **Actual:** `tailwindcss@^4.0.0`
- **Fix:** Update version in documentation

### Issues by Severity

#### Critical Issues (MUST fix)

1. **File Not Found**
   - **Location:** Documentation line XX
   - **Claim:** `src/utils/helper.ts`
   - **Reality:** File does not exist
   - **Fix:** Remove reference or find correct file

#### Warning Issues (SHOULD fix)

1. **Parameter Incomplete**
   - **Location:** Documentation line YY
   - **Claim:** Function takes 1 parameter
   - **Reality:** Function has optional 2nd parameter
   - **Fix:** Document optional parameter

### Recommendations

1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

---

## Completeness Verification Report

### Overall Summary

- **File Coverage:** [percentage]% ([covered] / [total])
- **Pattern Coverage:** [percentage]% ([covered] / [total])
- **Integration Coverage:** [percentage]% ([covered] / [total])
- **Status:** [COMPLETE/GAPS_FOUND]

### File Coverage Analysis

#### High-Confidence Files (>0.8)

**Total:** [count]
**Documented:** [count]
**Missing:** [count]

Missing files:
1. `path/to/missing-file.ts`
   - **Relevance:** 0.85
   - **Reason:** Used by main component but not documented
   - **Action:** Add section for this utility

#### Medium-Confidence Files (0.6-0.8)

**Total:** [count]
**Documented:** [count]
**Missing:** [count]

[List any significant missing files with context]

### Pattern Coverage Analysis

**Total Patterns:** [count]
**Documented:** [count]
**Missing:** [count]

Missing patterns:
1. **Pattern:** Provider pattern variation
   - **Found in:** [file1, file2]
   - **Usage count:** [count]
   - **Action:** Add pattern documentation with example

### Architecture Coverage

#### Data Flows

**Total flows:** [count]
**Documented:** [count]
**Missing:** [count]

Missing data flows:
1. **Flow:** User input → validation → store update
   - **Components involved:** [list]
   - **Action:** Add data flow diagram and description

#### Integration Points

**Total integration points:** [count]
**Documented:** [count]
**Missing:** [count]

Missing integrations:
1. **Integration:** Authentication with API gateway
   - **Components:** AuthService, ApiClient
   - **Action:** Document integration pattern

### Recommendations

1. **Priority High:** Add missing high-confidence files
2. **Priority Medium:** Document missing patterns
3. **Priority Low:** Add missing integration details

---

## Example Validation Report

### Overall Summary

- **Examples Checked:** [count]
- **Valid Examples:** [count]
- **Invalid Examples:** [count]
- **Syntax Errors:** [count]
- **Import Errors:** [count]
- **Type Errors:** [count]
- **Status:** [PASS/FAIL]

### Example-by-Example Analysis

#### Example 1 (Documentation Line XX)

**Status:** ✓ Valid

```typescript
// Example code
import { useStore } from '@nanostores/vue'
const $store = useStore(myStore)

**Validation:**
- ✓ Syntax valid
- ✓ Imports correct
- ✓ Types match
- ✓ Matches actual usage

#### Example 2 (Documentation Line YY)

**Status:** ✗ Invalid

```vue
<script setup>
// Missing import
const data = useData()
</script>

**Issues:**
1. **Missing Import:** `import { useData } from '@/composables'`
2. **Fix:** Add import statement

**Corrected Version:**
```vue
<script setup lang="ts">
import { useData } from '@/composables'
const data = useData()
</script>

#### Example 3 (Documentation Line ZZ)

**Status:** ⚠ Warning

```typescript
// Type annotation could be more specific
const value = computed(() => store.value)

**Issues:**
1. **Warning:** Missing type annotation for clarity
2. **Recommendation:** Add `ComputedRef<Type>` annotation

### Syntax Validation

**TypeScript Examples:** [count]
- ✓ Valid: [count]
- ✗ Invalid: [count]

**Vue Examples:** [count]
- ✓ Valid: [count]
- ✗ Invalid: [count]

**JavaScript Examples:** [count]
- ✓ Valid: [count]
- ✗ Invalid: [count]

### Import Validation

**Total Import Statements:** [count]
- ✓ Valid imports: [count]
- ✗ Missing imports: [count]
- ✗ Incorrect paths: [count]

### Type Validation

**Total Type Annotations:** [count]
- ✓ Correct types: [count]
- ⚠ Missing types: [count]
- ✗ Incorrect types: [count]

### Cross-Reference with Actual Code

**Examples matching real usage:** [count] / [total]

Examples that don't match actual patterns:
1. **Example at line XX:**
   - **Documented pattern:** [pattern shown]
   - **Actual pattern:** [pattern in codebase]
   - **Fix:** Update example to match actual usage

### Recommendations

1. **Fix immediately:** [Critical issues]
2. **Fix before finalization:** [Important improvements]
3. **Consider for future:** [Nice-to-have enhancements]

---

## Report Format Guidelines

### JSON Output Format

Use this structure for machine-readable reports:

```json
{
  "metadata": {
    "report_type": "accuracy|completeness|example-validation",
    "topic": "topic-name",
    "timestamp": "ISO-8601",
    "subagent": "subagent-name"
  },
  "summary": {
    "total_checks": 0,
    "passed": 0,
    "warnings": 0,
    "critical": 0,
    "status": "PASS|WARNING|FAIL"
  },
  "issues": [
    {
      "severity": "critical|warning|info",
      "type": "missing_file|signature_mismatch|import_error",
      "location": "file:line or section",
      "claim": "What documentation states",
      "actual": "What reality is",
      "fix": "Specific fix to apply"
    }
  ],
  "coverage": {
    "percentage": 85.5,
    "covered": 42,
    "total": 49,
    "missing": ["item1", "item2"]
  },
  "recommendations": [
    "Recommendation 1",
    "Recommendation 2"
  ]
}

### Markdown Output Format

Use this structure for human-readable reports:


# [Report Type] Report

## Summary
[High-level overview with key metrics]

## Details
[Section-by-section detailed findings]

### [Category]
[Specific findings with examples]

## Issues
### Critical
[Must-fix issues]

### Warnings
[Should-fix issues]

## Recommendations
[Actionable next steps]

### Severity Definitions

**Critical:**
- Prevents documentation from being accurate
- Causes confusion or errors for users
- Must be fixed before finalization
- Examples: wrong file paths, missing imports in examples, non-existent functions

**Warning:**
- Reduces documentation quality
- Could cause confusion
- Should be fixed if possible
- Examples: incomplete parameter lists, minor type mismatches, missing edge cases

**Info:**
- Enhancement opportunities
- Nice-to-have improvements
- Can be deferred
- Examples: additional examples, more detailed explanations, cross-references

### Action Item Format

Each issue should have a clear action:

**Issue:** [Clear description]
- **Location:** [Where in docs]
- **Problem:** [What's wrong]
- **Fix:** [Specific action to take]
- **Priority:** [Critical/High/Medium/Low]

---

