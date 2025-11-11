# Instructions

### Step 1: Setup CVA and cn() Utility

1. **Install dependencies:**
   ```bash
   npm install class-variance-authority clsx tailwind-merge
   ```

2. **Create cn() utility** (`src/utils/cn.ts`):
   ```typescript
   import { clsx, type ClassValue } from 'clsx'
   import { twMerge } from 'tailwind-merge'

   export function cn(...inputs: ClassValue[]) {
     return twMerge(clsx(inputs))
   }
   ```

   **Why tailwind-merge?** Resolves conflicting Tailwind classes:
   ```typescript
   // Without: both classes applied (wrong)
   clsx('px-4', 'px-2') // => "px-4 px-2"

   // With: last class wins (correct)
   cn('px-4', 'px-2') // => "px-2"
   ```

3. **Verify setup:**
   ```typescript
   import { cva } from 'class-variance-authority'
   import { cn } from '@/utils/cn'
   // Should compile without errors
   ```

### Step 2: Define Variant System

#### Basic Structure

```typescript
import { cva, type VariantProps } from 'class-variance-authority'

export const componentVariants = cva({
  // Base classes - always applied
  base: "class1 class2 class3",

  variants: {
    // Variant dimension 1
    variantName: {
      option1: "classes for option1",
      option2: "classes for option2"
    },

    // Variant dimension 2
    size: {
      sm: "size-specific classes",
      md: "size-specific classes"
    }
  },

  // Compound variants - when multiple conditions met
  compoundVariants: [
    {
      variantName: "option1",
      size: "md",
      class: "classes when both true"
    }
  ],

  // Default values
  defaultVariants: {
    variantName: "option1",
    size: "md"
  }
})

// Export type for component props
export type ComponentVariantProps = VariantProps<typeof componentVariants>
```

#### Variant Naming Conventions

**✅ Intent-based (semantic):**
```typescript
variants: {
  intent: { primary: "...", danger: "...", success: "..." }
}
```

**❌ Visual-based (non-semantic):**
```typescript
variants: {
  color: { blue: "...", red: "...", green: "..." }
}
```

**Reason:** Intent names are stable when colors change during rebrand.

### Step 3: Integrate with Vue Component

#### Pattern 1: Basic Integration

```vue
<script setup lang="ts">
import { computed } from 'vue'
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/utils/cn'

// Define variants
const buttonVariants = cva({
  base: "inline-flex items-center rounded-lg font-medium transition-all",
  variants: {
    variant: {
      primary: "bg-primary-500 text-white hover:bg-primary-600",
      secondary: "bg-gray-500 text-white hover:bg-gray-600",
      outline: "border-2 border-primary-500 text-primary-600"
    },
    size: {
      sm: "px-3 py-1.5 text-sm",
      md: "px-4 py-2 text-base",
      lg: "px-6 py-3 text-lg"
    }
  },
  defaultVariants: {
    variant: "primary",
    size: "md"
  }
})

// Extract variant props type
type ButtonVariantProps = VariantProps<typeof buttonVariants>

// Component props interface
interface Props extends ButtonVariantProps {
  class?: string
}

// Props with defaults
const props = withDefaults(defineProps<Props>(), {
  variant: "primary",
  size: "md"
})

// Computed classes
const classes = computed(() => cn(
  buttonVariants({
    variant: props.variant,
    size: props.size
  }),
  props.class // Allow external overrides
))
</script>

<template>
  <button :class="classes">
    <slot />
  </button>
</template>
```

#### Pattern 2: Compound Variants (Advanced)

**Use compound variants for state-dependent styling:**

```vue
<script setup lang="ts">
const buttonVariants = cva({
  base: "inline-flex items-center rounded-lg font-medium transition-all",
  variants: {
    intent: {
      primary: "bg-primary-500 text-white",
      secondary: "bg-gray-500 text-white"
    },
    size: {
      sm: "px-3 py-1.5 text-sm",
      md: "px-4 py-2 text-base"
    },
    disabled: {
      false: null, // null = no classes
      true: "opacity-50 cursor-not-allowed"
    }
  },
  compoundVariants: [
    // Hover states only for non-disabled buttons
    {
      intent: "primary",
      disabled: false,
      class: "hover:bg-primary-600 active:bg-primary-700"
    },
    {
      intent: "secondary",
      disabled: false,
      class: "hover:bg-gray-600 active:bg-gray-700"
    },
    // Size + intent combo
    {
      intent: "primary",
      size: "md",
      class: "shadow-md"
    }
  ],
  defaultVariants: {
    intent: "primary",
    size: "md",
    disabled: false
  }
})
</script>
```

#### Pattern 3: Multiple Variants with Composition

**When variants get too large, split and compose:**

```vue
<script setup lang="ts">
import { cva } from 'class-variance-authority'
import { cn } from '@/utils/cn'

// Split into focused variant functions
const colorVariants = cva({
  base: "",
  variants: {
    intent: {
      primary: "bg-primary-500 text-white",
      secondary: "bg-gray-500 text-white"
    }
  }
})

const sizeVariants = cva({
  base: "",
  variants: {
    size: {
      sm: "px-3 py-1.5 text-sm",
      md: "px-4 py-2 text-base",
      lg: "px-6 py-3 text-lg"
    }
  }
})

// Compose in computed
const classes = computed(() => cn(
  "inline-flex items-center rounded-lg font-medium",
  colorVariants({ intent: props.intent }),
  sizeVariants({ size: props.size }),
  props.class
))
</script>
```

### Step 4: Handle Dark Mode

**Plan for dark mode from day one:**

```typescript
const buttonVariants = cva({
  base: "button",
  variants: {
    variant: {
      // Include dark: variants even if unused initially
      primary: "bg-primary-500 text-white hover:bg-primary-600 dark:bg-primary-600 dark:hover:bg-primary-700",
      secondary: "bg-gray-200 text-gray-900 hover:bg-gray-300 dark:bg-gray-800 dark:text-gray-100 dark:hover:bg-gray-700"
    }
  }
})
```

**Why add dark: variants early?**
- Retrofitting later requires touching every variant
- Easy to forget some variants
- Inconsistent dark mode experience

### Step 5: Advanced Patterns

#### Data Attributes for State

**Use data attributes instead of JavaScript conditionals:**

```vue
<script setup lang="ts">
const cardVariants = cva({
  base: "rounded-lg border p-4 transition-colors",
  variants: {
    variant: {
      default: "border-gray-300",
      danger: "border-red-300"
    }
  }
})
</script>

<template>
  <div
    :data-selected="isSelected ? '' : undefined"
    :data-disabled="isDisabled ? '' : undefined"
    :class="cardVariants({ variant })"
    class="
      bg-white text-gray-900
      data-[selected]:bg-blue-500 data-[selected]:text-white
      data-[disabled]:opacity-50 data-[disabled]:cursor-not-allowed
    "
  >
    <slot />
  </div>
</template>
```

**Benefits:**
- No JS conditionals in template
- Multiple states compose naturally
- Same pattern as Radix UI

#### CSS Variables for Dynamic Values

**When you need runtime-dynamic values (animations, scroll):**

```vue
<script setup lang="ts">
import { ref, computed, type CSSProperties } from 'vue'

const scroll = ref(0)

const labelVariants = cva({
  base: "sticky top-0 font-mono",
  variants: {
    color: {
      primary: "text-blue-600",
      secondary: "text-gray-600"
    }
  }
})

// CSS variable for dynamic opacity
const dynamicStyles = computed(() => ({
  '--scroll-opacity': scroll.value / 1000
}) as CSSProperties)
</script>

<template>
  <div @scroll="scroll = $event.target.scrollTop">
    <span
      :class="labelVariants({ color: 'primary' })"
      :style="dynamicStyles"
      class="opacity-[calc(var(--scroll-opacity))]"
    >
      {{ scroll }}
    </span>
  </div>
</template>
```

**Pattern:** CVA for static variants, CSS variables for dynamic runtime values.
