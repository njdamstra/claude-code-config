---
description: Refactor platform-specific components to use provider pattern, reducing code duplication by 85%
argument-hint: [component-pattern]
allowed-tools: read, write, bash, grep, str_replace, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Provider Pattern Refactor

Refactor duplicated platform-specific components into a single configurable component using the provider pattern.

## Usage

```bash
/ui-provider-refactor *Card.vue
/ui-provider-refactor Facebook* Twitter* LinkedIn*
/ui-provider-refactor src/components/vue/social/*
```

**Syntax**: `/ui-provider-refactor [component-pattern]`

## The Provider Pattern Problem

### Before (Duplication)
```
src/components/vue/social/
├── FacebookCard.vue    (150 lines)
├── TwitterCard.vue     (145 lines)
├── LinkedInCard.vue    (148 lines)
├── InstagramCard.vue   (152 lines)
└── YouTubeCard.vue     (147 lines)

Total: ~740 lines of mostly duplicated code
```

### After (Provider Pattern)
```
src/components/vue/social/
├── BaseProviderCard.vue   (180 lines) - Generic component
src/config/
└── providers.ts           (60 lines)  - Platform configs

Total: ~240 lines (67% reduction!)
```

## Process

Refactor components matching: $ARGUMENTS

### Step 1: Identify Duplication (ui-analyzer)
1. Find all components matching pattern
2. Read and analyze each component
3. Extract common patterns:
   - Shared props
   - Common structure
   - Similar logic
   - Consistent styling
4. Identify unique aspects:
   - Platform-specific colors
   - Different icons
   - Unique labels
   - Platform IDs

### Step 2: Design Provider Config
1. Create providers configuration file
2. Define config shape:
   ```typescript
   interface ProviderConfig {
     name: string
     icon: string
     color: string
     gradient?: string
     apiEndpoint?: string
     // Platform-specific properties
   }
   ```
3. Extract all unique values per platform

### Step 3: Build Base Component (ui-builder)
1. Create generic `BaseProviderCard.vue`
2. Accept platform prop
3. Load config from providers file
4. Dynamic rendering based on config
5. Maintain all original functionality
6. Add type safety

### Step 4: Create Providers Config
1. Build `src/config/providers.ts`
2. Define all platform configurations
3. Export typed providers object
4. Document config structure

### Step 5: Migration Plan
1. Test base component with all platforms
2. Update imports across codebase
3. Delete deprecated components
4. Update documentation

### Step 6: Validation
1. Verify feature parity
2. Check type safety
3. Test all platforms
4. Measure code reduction

## Output Format

```markdown
# 🔄 Provider Pattern Refactor

**Target**: $ARGUMENTS
**Components Found**: [N]

---

## 📊 Analysis

### Duplicated Components
| Component | Lines | Duplication % |
|-----------|-------|---------------|
| FacebookCard.vue | 150 | 92% |
| TwitterCard.vue | 145 | 90% |
| LinkedInCard.vue | 148 | 91% |
| InstagramCard.vue | 152 | 93% |
| YouTubeCard.vue | 147 | 89% |
| **Total** | **742** | **91% avg** |

### Common Patterns (Shared Across All)
✅ Card wrapper with shadow
✅ Header with platform icon
✅ Account name display
✅ Follower count
✅ Connect/Disconnect button
✅ Loading states
✅ Error handling

### Unique Per Platform
- Platform colors (5 unique)
- Platform icons (5 unique)
- Platform names (5 unique)
- API endpoints (5 unique)
- Gradient styles (3 unique)

---

## 🏗️ Refactor Strategy

### New Structure

1. **BaseProviderCard.vue** (180 lines)
   - Generic implementation
   - Config-driven rendering
   - Full type safety
   - All shared logic

2. **src/config/providers.ts** (60 lines)
   - Platform configurations
   - Type definitions
   - Export all providers

**Code Reduction**: 742 → 240 lines (67% reduction!)

---

## 💻 Generated Files

### File 1: BaseProviderCard.vue

**Location**: `src/components/vue/social/BaseProviderCard.vue`

```vue
<script setup lang="ts">
import { computed } from 'vue'
import { providers, type ProviderPlatform } from '@/config/providers'

interface Props {
  platform: ProviderPlatform
  account: {
    name: string
    followers: number
    isConnected: boolean
  }
  loading?: boolean
}

const props = defineProps<Props>()

interface Emits {
  connect: []
  disconnect: []
}

const emit = defineEmits<Emits>()

// Get platform config
const config = computed(() => providers[props.platform])

// Dynamic classes based on config
const cardClasses = computed(() => ({
  'bg-gradient-to-br': !!config.value.gradient,
  [config.value.gradient || '']: !!config.value.gradient,
  'bg-white': !config.value.gradient,
  'shadow-lg': true,
  'rounded-lg': true,
  'p-6': true,
  'opacity-50': props.loading,
}))

const iconClasses = computed(() => ({
  'w-12': true,
  'h-12': true,
  'rounded-full': true,
  'flex': true,
  'items-center': true,
  'justify-center': true,
  [`bg-[var(${config.value.color})]`]: true,
}))

const buttonClasses = computed(() => ({
  'px-4': true,
  'py-2': true,
  'rounded-md': true,
  'font-medium': true,
  [`bg-[var(${config.value.color})]`]: props.account.isConnected,
  'bg-gray-200': !props.account.isConnected,
  'text-white': props.account.isConnected,
  'text-gray-700': !props.account.isConnected,
  'hover:opacity-80': true,
  'transition-opacity': true,
  'disabled:opacity-50': true,
}))

const handleAction = () => {
  if (props.account.isConnected) {
    emit('disconnect')
  } else {
    emit('connect')
  }
}

const formatFollowers = (count: number) => {
  if (count >= 1000000) {
    return `${(count / 1000000).toFixed(1)}M`
  }
  if (count >= 1000) {
    return `${(count / 1000).toFixed(1)}K`
  }
  return count.toString()
}
</script>

<template>
  <div :class="cardClasses">
    <!-- Header -->
    <div class="flex items-center justify-between mb-4">
      <div class="flex items-center gap-3">
        <!-- Platform Icon -->
        <div :class="iconClasses">
          <component :is="config.icon" class="w-6 h-6 text-white" />
        </div>
        
        <!-- Platform Name -->
        <div>
          <h3 class="font-semibold text-gray-900">
            {{ config.name }}
          </h3>
          <p class="text-sm text-gray-500">
            @{{ account.name }}
          </p>
        </div>
      </div>
      
      <!-- Connection Status -->
      <div
        v-if="account.isConnected"
        class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium"
      >
        Connected
      </div>
    </div>
    
    <!-- Stats -->
    <div class="mb-4">
      <div class="text-2xl font-bold text-gray-900">
        {{ formatFollowers(account.followers) }}
      </div>
      <div class="text-sm text-gray-500">
        Followers
      </div>
    </div>
    
    <!-- Action Button -->
    <button
      :class="buttonClasses"
      :disabled="loading"
      @click="handleAction"
    >
      <span v-if="loading" class="inline-block animate-spin mr-2">⚙️</span>
      {{ account.isConnected ? 'Disconnect' : `Connect ${config.name}` }}
    </button>
  </div>
</template>
\```

---

### File 2: providers.ts

**Location**: `src/config/providers.ts`

```typescript
// Platform provider configurations
export const providers = {
  facebook: {
    name: 'Facebook',
    icon: 'FacebookIcon',
    color: '--color-facebook',
    gradient: 'from-blue-600 to-blue-400',
    apiEndpoint: '/api/social/facebook',
  },
  twitter: {
    name: 'Twitter',
    icon: 'TwitterIcon',
    color: '--color-twitter',
    gradient: 'from-sky-500 to-sky-300',
    apiEndpoint: '/api/social/twitter',
  },
  linkedin: {
    name: 'LinkedIn',
    icon: 'LinkedInIcon',
    color: '--color-linkedin',
    gradient: 'from-blue-700 to-blue-500',
    apiEndpoint: '/api/social/linkedin',
  },
  instagram: {
    name: 'Instagram',
    icon: 'InstagramIcon',
    color: '--color-instagram',
    gradient: 'from-pink-600 via-red-600 to-yellow-500',
    apiEndpoint: '/api/social/instagram',
  },
  youtube: {
    name: 'YouTube',
    icon: 'YouTubeIcon',
    color: '--color-youtube',
    gradient: 'from-red-600 to-red-400',
    apiEndpoint: '/api/social/youtube',
  },
} as const

// Type definitions
export type ProviderPlatform = keyof typeof providers

export interface ProviderConfig {
  name: string
  icon: string
  color: string
  gradient?: string
  apiEndpoint: string
}

// Helper function to get config
export const getProviderConfig = (
  platform: ProviderPlatform
): ProviderConfig => {
  return providers[platform]
}
\```

---

## 📝 Migration Guide

### Step 1: Add Design Tokens
Add platform colors to `src/styles/design-system.css`:

```css
/* Platform Colors */
--color-facebook: #1877F2;
--color-twitter: #1DA1F2;
--color-linkedin: #0A66C2;
--color-instagram: #E4405F;
--color-youtube: #FF0000;
\```

### Step 2: Update Imports

**Before:**
```vue
<script setup lang="ts">
import FacebookCard from '@/components/vue/social/FacebookCard.vue'
import TwitterCard from '@/components/vue/social/TwitterCard.vue'
</script>

<template>
  <FacebookCard :account="fbAccount" />
  <TwitterCard :account="twAccount" />
</template>
\```

**After:**
```vue
<script setup lang="ts">
import BaseProviderCard from '@/components/vue/social/BaseProviderCard.vue'
</script>

<template>
  <BaseProviderCard platform="facebook" :account="fbAccount" />
  <BaseProviderCard platform="twitter" :account="twAccount" />
</template>
\```

### Step 3: Delete Old Components

```bash
# Remove deprecated files
rm src/components/vue/social/FacebookCard.vue
rm src/components/vue/social/TwitterCard.vue
rm src/components/vue/social/LinkedInCard.vue
rm src/components/vue/social/InstagramCard.vue
rm src/components/vue/social/YouTubeCard.vue
\```

### Step 4: Update Documentation

Update component docs to reference BaseProviderCard instead of platform-specific components.

---

## ✅ Validation Results

### Feature Parity Check

| Feature | Before | After | Status |
|---------|--------|-------|--------|
| Platform Display | ✅ | ✅ | ✅ |
| Follower Count | ✅ | ✅ | ✅ |
| Connect/Disconnect | ✅ | ✅ | ✅ |
| Loading States | ✅ | ✅ | ✅ |
| Error Handling | ✅ | ✅ | ✅ |
| Type Safety | ✅ | ✅ | ✅ |
| Accessibility | ✅ | ✅ | ✅ |

**Result**: 100% feature parity maintained ✅

### Code Quality
- **TypeScript**: Full type safety with `ProviderPlatform` type
- **Design System**: 100% token compliance
- **Accessibility**: All WCAG AA requirements met
- **Performance**: Improved (single component to maintain)

---

## 📊 Impact Analysis

### Code Reduction
- **Before**: 742 lines across 5 files
- **After**: 240 lines in 2 files
- **Reduction**: 502 lines (67.7% reduction)

### Maintenance Benefits
- **Single Source of Truth**: Update once, affects all platforms
- **Easy to Add Platforms**: Add 10 lines to config vs. 150-line component
- **Consistent Behavior**: No divergent implementations
- **Type-Safe**: Platform prop ensures valid platforms only

### Time Savings
- **Adding New Platform**: 
  - Before: 2-3 hours (new component)
  - After: 5 minutes (config entry)
- **Fixing Bugs**:
  - Before: Fix in 5 places
  - After: Fix once
- **Design Updates**:
  - Before: Update 5 files
  - After: Update 1 file

---

## 🎯 Next Steps

1. ✅ **Test All Platforms**: Verify each platform works
2. ✅ **Update Codebase**: Replace all old imports
3. ✅ **Delete Old Files**: Remove deprecated components
4. ✅ **Update Docs**: Document provider pattern
5. ✅ **Add More Platforms**: Now trivial to add new ones!

---

## 🚀 Adding New Platforms

**It's now incredibly easy!**

```typescript
// Just add to providers.ts (10 lines)
tiktok: {
  name: 'TikTok',
  icon: 'TikTokIcon',
  color: '--color-tiktok',
  gradient: 'from-black to-cyan-400',
  apiEndpoint: '/api/social/tiktok',
}
\```

```vue
<!-- Use immediately -->
<BaseProviderCard platform="tiktok" :account="data" />
\```

**That's it!** No new component file needed.

---

## 📈 Comparison

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Total Lines | 742 | 240 | -67.7% |
| Files | 5 | 2 | -60% |
| Add Platform | 150 lines | 10 lines | -93% |
| Fix Bug | 5 places | 1 place | -80% time |
| Consistency | Divergent | Unified | ✅ |
| Type Safety | Partial | Full | ✅ |

**Success!** 🎉
\```

## When to Use Provider Pattern

### Use When:
✅ **3+ similar components** with minor variations
✅ **Configurable differences** (colors, labels, etc.)
✅ **Shared structure and behavior**
✅ **Predictable variations** (platform-specific)
✅ **Frequent additions expected**

### Don't Use When:
❌ **Components are fundamentally different**
❌ **Complex, unique logic per variant**
❌ **Only 1-2 variants exist**
❌ **Variations are unpredictable**
❌ **Performance-critical (rare)**

## Time Estimate

- Analysis: 10-15 minutes
- Base component creation: 30-40 minutes
- Config file creation: 10-15 minutes
- Migration: 15-20 minutes
- Testing: 15-20 minutes
- **Total: 80-110 minutes**

**ROI**: Hours saved on every future update or addition!

## Integration

This command uses:
- **ui-analyzer** for duplication detection
- **ui-builder** for base component generation
- **ui-validator** for feature parity validation

The provider pattern is one of the most powerful refactoring techniques for eliminating duplication while maintaining flexibility.