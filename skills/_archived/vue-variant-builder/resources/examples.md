# Examples

### Example 1: Button Component

**Complete implementation with all features:**

```vue
<!-- Button.vue -->
<script setup lang="ts">
import { computed } from 'vue'
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/utils/cn'

const buttonVariants = cva({
  base: "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none",
  variants: {
    variant: {
      default: "bg-primary-500 text-white hover:bg-primary-600 dark:bg-primary-600 dark:hover:bg-primary-700",
      destructive: "bg-red-600 text-white hover:bg-red-700 dark:bg-red-700 dark:hover:bg-red-800",
      outline: "border-2 border-primary-500 text-primary-600 hover:bg-primary-50 dark:border-primary-600 dark:text-primary-400 dark:hover:bg-primary-950",
      ghost: "hover:bg-gray-100 text-gray-900 dark:hover:bg-gray-800 dark:text-gray-100",
      link: "underline-offset-4 hover:underline text-primary-600 dark:text-primary-400"
    },
    size: {
      sm: "h-9 px-3 text-sm",
      md: "h-10 px-4 text-base",
      lg: "h-11 px-8 text-lg",
      icon: "h-10 w-10"
    }
  },
  compoundVariants: [
    {
      variant: "default",
      size: "md",
      class: "shadow-md"
    }
  ],
  defaultVariants: {
    variant: "default",
    size: "md"
  }
})

export type ButtonVariantProps = VariantProps<typeof buttonVariants>

interface Props extends ButtonVariantProps {
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: "default",
  size: "md"
})

const classes = computed(() => cn(
  buttonVariants({
    variant: props.variant,
    size: props.size
  }),
  props.class
))
</script>

<template>
  <button :class="classes">
    <slot />
  </button>
</template>
```

**Usage:**
```vue
<Button>Default</Button>
<Button variant="destructive" size="sm">Delete</Button>
<Button variant="outline" class="mt-4">Custom spacing</Button>
```

### Example 2: Badge Component

```vue
<!-- Badge.vue -->
<script setup lang="ts">
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/utils/cn'

const badgeVariants = cva({
  base: "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
  variants: {
    variant: {
      default: "border-transparent bg-primary-500 text-white dark:bg-primary-600",
      secondary: "border-transparent bg-gray-200 text-gray-900 dark:bg-gray-700 dark:text-gray-100",
      success: "border-transparent bg-success-500 text-white dark:bg-success-600",
      warning: "border-transparent bg-warning-500 text-white dark:bg-warning-600",
      error: "border-transparent bg-error-500 text-white dark:bg-error-600",
      outline: "text-gray-900 border-gray-300 dark:text-gray-100 dark:border-gray-600"
    }
  },
  defaultVariants: {
    variant: "default"
  }
})

type BadgeVariantProps = VariantProps<typeof badgeVariants>

interface Props extends BadgeVariantProps {
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: "default"
})

const classes = computed(() => cn(
  badgeVariants({ variant: props.variant }),
  props.class
))
</script>

<template>
  <span :class="classes">
    <slot />
  </span>
</template>
```

### Example 3: Card with Status Variants

```vue
<!-- Card.vue -->
<script setup lang="ts">
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/utils/cn'

const cardVariants = cva({
  base: "rounded-lg border bg-white text-gray-900 shadow-sm transition-all dark:bg-gray-900 dark:text-gray-100",
  variants: {
    status: {
      default: "border-gray-200 dark:border-gray-800",
      success: "border-green-200 bg-green-50/50 dark:border-green-800 dark:bg-green-950/50",
      warning: "border-yellow-200 bg-yellow-50/50 dark:border-yellow-800 dark:bg-yellow-950/50",
      error: "border-red-200 bg-red-50/50 dark:border-red-800 dark:bg-red-950/50"
    },
    padding: {
      none: "p-0",
      sm: "p-4",
      md: "p-6",
      lg: "p-8"
    }
  },
  defaultVariants: {
    status: "default",
    padding: "md"
  }
})

type CardVariantProps = VariantProps<typeof cardVariants>

interface Props extends CardVariantProps {
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  status: "default",
  padding: "md"
})

const classes = computed(() => cn(
  cardVariants({
    status: props.status,
    padding: props.padding
  }),
  props.class
))
</script>

<template>
  <div :class="classes">
    <slot />
  </div>
</template>
```

### Example 4: Eliminating Duplicate Components

**Before (Duplicate Components):**
```
components/
├─ PrimaryButton.vue (105 lines)
├─ SecondaryButton.vue (105 lines)
├─ OutlineButton.vue (105 lines)
└─ DangerButton.vue (105 lines)
```

**After (Single Component with Variants):**
```vue
<!-- Button.vue (80 lines total) -->
<script setup lang="ts">
const buttonVariants = cva({
  base: "...",
  variants: {
    variant: {
      primary: "...",
      secondary: "...",
      outline: "...",
      danger: "..."
    }
  }
})
</script>

<template>
  <button :class="buttonVariants({ variant: props.variant })">
    <slot />
  </button>
</template>
```

**Result:** Eliminated 315 lines of duplicate code, single source of truth for variants.
