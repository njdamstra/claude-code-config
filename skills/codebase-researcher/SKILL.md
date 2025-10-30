---
name: Codebase Researcher
description: Search codebase for existing patterns, composables (useFormValidation, useAuth), components (Button.vue, FormInput.vue, Modal.vue), stores (UserStore, BaseStore patterns), and utilities before creating new code. Analyzes match percentages (80%+ = reuse, 50-80% = extend, <50% = create). Use when building ANY new feature to prevent duplication. Automatically invoked by builder-mode and refactor-mode. Use for "does this exist", "find similar", "reusable patterns". Prevents redundant code with REUSE/EXTEND/CREATE recommendations.
version: 2.0.0
tags: [search, patterns, reuse, anti-duplication, composables, components, stores, prevention, discovery]
---

# Codebase Researcher

## Purpose
Find existing code before creating new code to prevent duplication.

## When Invoked
- Automatically by builder-mode (before any new code)
- Automatically by refactor-mode (before any changes)
- Manually when user asks "does this exist?" or "find similar"

## Search Strategy

### 1. Composables Search
```bash
# Find all composables
grep -r "export.*use[A-Z]" src/composables/
grep -r "export const use" src/composables/
grep -r "export function use" src/composables/

# Search by functionality keyword
grep -r "useForm\|useValidation\|useAuth" src/
grep -r "useModal\|useToast\|useNotification" src/
grep -r "useFetch\|useApi\|useQuery" src/
```

### 2. Components Search
```bash
# Find similar components by name pattern
find src/components/vue -name "*Button*.vue"
find src/components/vue -name "*Modal*.vue"
find src/components/vue -name "*Form*.vue"
find src/components/vue -name "*Input*.vue"
find src/components/vue -name "*Card*.vue"

# Search by props or functionality
grep -r "defineProps.*loading" src/components/
grep -r "defineProps.*disabled" src/components/
grep -r "Teleport" src/components/  # Find modals
```

### 3. Stores Search
```bash
# Find BaseStore extensions
grep -r "extends BaseStore" src/stores/
grep -r "class.*Store" src/stores/

# Search by collection/domain
grep -r "COLLECTION_ID" src/stores/
grep -r "USER\|Post\|Comment" src/stores/
```

### 4. Utilities Search
```bash
# Find utility functions
grep -r "export function" src/utils/
grep -r "export const.*=.*=>" src/utils/

# Search by functionality
grep -r "format\|parse\|validate" src/utils/
grep -r "debounce\|throttle" src/utils/
```

### 5. Patterns Search (Project-Specific)
```bash
# Appwrite patterns
grep -r "createDocument\|listDocuments\|getDocument" src/
grep -r "account.get\|account.create" src/

# Zod schemas
grep -r "z.object" src/schemas/
grep -r "z.enum\|z.array" src/

# Dark mode usage
grep -r "dark:" src/ | grep -v node_modules

# SSR patterns
grep -r "useMounted" src/
grep -r "client:load\|client:visible" src/
```

## Output Format

```markdown
## Codebase Search Results

**Searched for:** [keywords used]

### Composables Found
- ✓ **useFormValidation** (src/composables/useFormValidation.ts)
  - Purpose: Form validation with Zod schemas
  - Exports: validate(), errors, isValid, resetErrors
  - Used in: 8 components
  - Matches need: 90%

- ✓ **useAuth** (src/composables/useAuth.ts)
  - Purpose: Authentication state and operations
  - Exports: user, login(), logout(), isAuthenticated
  - Used in: 15 components
  - Matches need: 100%

### Components Found
- ✓ **FormInput.vue** (src/components/vue/forms/FormInput.vue)
  - Props: label, error, modelValue, type, disabled
  - Features: Dark mode, validation display, accessibility
  - Used in: 12 forms
  - Matches need: 95%

- ✓ **Button.vue** (src/components/vue/ui/Button.vue)
  - Props: variant, size, loading, disabled
  - Features: Multiple variants, loading state, full Tailwind
  - Used in: 30+ components
  - Matches need: 100%

### Stores Found
- ✓ **UserStore** (src/stores/user.ts)
  - Extends: BaseStore
  - Schema: UserSchema with Zod
  - Methods: getCurrentUser(), updateProfile()
  - Matches need: 85%

### Utilities Found
- ✓ **formatDate** (src/utils/date.ts)
  - Purpose: Date formatting utilities
  - Functions: formatDate(), parseDate(), relativeTime()
  - Matches need: 75%

### Not Found
- ❌ Password strength indicator component
- ❌ Email verification flow

## Recommendation

### ✅ REUSE (Strongly Recommended)
- useFormValidation - Covers 90% of validation needs
- FormInput.vue - Perfect for text inputs
- Button.vue - Exactly what's needed for actions
- UserStore - Has user data and update methods

### ✅ EXTEND (Recommended)
- userStore.updateProfile() - Add email verification flag

### ✅ CREATE NEW (Only These)
- PasswordStrength.vue - No existing component for this
- Email verification UI flow - New requirement

## Reasoning

Existing code covers 85% of requirements. The validation,
form inputs, buttons, and user state management are all
battle-tested patterns already in use. Only password strength
visualization and email verification flow are genuinely new
requirements that justify new code.

**Estimated savings:** ~200 lines of code by reusing existing
**Estimated time saved:** 2-3 hours
**Code consistency:** ✅ Using proven patterns
```

## Decision Framework

### When to REUSE Existing Code
✅ Functionality matches 80%+ of needs
✅ Well-tested and actively used (5+ usages)
✅ Can be extended or composed
✅ Follows project patterns
✅ Has good TypeScript types

### When to EXTEND Existing Code
✅ Covers 60-80% of needs
✅ Minor additions needed
✅ Extension doesn't break existing usage
✅ Maintains same pattern/API

### When to CREATE New Code
✅ No existing code found (searched thoroughly)
✅ Existing code fundamentally incompatible
✅ Requirements are genuinely novel
✅ Reusing would require major breaking changes
✅ New pattern is justified (discuss with user)

### When to REFACTOR Existing Code
✅ Pattern repeated 3+ times
✅ Multiple components have duplicate logic
✅ Can consolidate into shared utility
✅ Improves maintainability significantly

## Examples

### Example 1: Found Perfect Match
```
User wants: Form validation with error display

Search found:
- useFormValidation composable (used in 8 forms)
- FormInput component with error prop

Recommendation: ✅ REUSE both
Reasoning: Exact match, proven, widely used
```

### Example 2: Found Close Match
```
User wants: User profile with avatar + bio

Search found:
- UserCard component (shows name + avatar)
- No bio editing functionality

Recommendation: ✅ EXTEND UserCard
Reasoning: 70% match, add bio editing capability
```

### Example 3: Nothing Found
```
User wants: WebRTC video chat component

Search found:
- No WebRTC usage in codebase
- No video/audio components

Recommendation: ✅ CREATE NEW
Reasoning: Genuinely new requirement, no patterns exist
```

### Example 4: Should Consolidate
```
User wants: Loading spinner

Search found:
- LoadingSpinner.vue (used 5 times)
- Spinner.vue (used 3 times)
- Loading.vue (used 2 times)
- All do the same thing with slight variations

Recommendation: ⚠️ CONSOLIDATE FIRST
Reasoning: Duplication exists, consolidate to LoadingSpinner
then use that
```
