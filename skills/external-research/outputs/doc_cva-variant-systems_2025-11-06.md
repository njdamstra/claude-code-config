# Official Documentation: Class Variance Authority (CVA) and Variant Systems

**Research Date:** 2025-11-06
**Source:** /joe-bell/cva (Context7), cva.style/docs, Vercel Academy
**Version:** CVA 1.0 (beta)

## Summary

Class Variance Authority (CVA) is a TypeScript-first utility for creating type-safe component variants with traditional CSS/Tailwind. It provides the ergonomics of CSS-in-TS libraries like Stitches and Vanilla Extract without requiring runtime CSS generation. CVA excels at maintaining design system consistency while allowing full control over stylesheet output.

## Core API Reference

### `cva()` Function

**Purpose:** Creates a variant-aware class name generator with TypeScript inference

**Signature:**
```typescript
import { cva } from 'cva'

const component = cva(options)
```

**Parameters:**
- `base` (string | string[] | clsx value) - Base class names applied to all variants
- `options` (optional object):
  - `variants` - Schema defining variant dimensions (intent, size, etc.)
  - `compoundVariants` - Conditional classes based on multiple variant combinations
  - `defaultVariants` - Default values for variants

**Returns:** Function that generates class strings based on provided variant props

**Example:**
```typescript
import { cva } from 'cva'

const button = cva({
  base: "rounded border font-semibold",
  variants: {
    intent: {
      primary: "border-transparent bg-blue-500 text-white hover:bg-blue-600",
      secondary: "border-gray-400 bg-white text-gray-800 hover:bg-gray-100"
    },
    size: {
      small: "px-2 py-1 text-sm",
      medium: "px-4 py-2 text-base"
    }
  },
  compoundVariants: [
    {
      intent: "primary",
      size: "medium",
      class: "uppercase"
    }
  ],
  defaultVariants: {
    intent: "primary",
    size: "medium"
  }
})

// Usage
button()
// => "rounded border font-semibold border-transparent bg-blue-500 text-white hover:bg-blue-600 px-4 py-2 text-base uppercase"

button({ intent: "secondary", size: "small" })
// => "rounded border font-semibold border-gray-400 bg-white text-gray-800 hover:bg-gray-100 px-2 py-1 text-sm"
```

### `VariantProps<typeof variant>` Type Helper

**Purpose:** Extracts TypeScript prop types from CVA variant definitions

**Signature:**
```typescript
import type { VariantProps } from 'cva'

type ButtonProps = VariantProps<typeof button>
```

**Usage Pattern:**
```typescript
import { cva, type VariantProps } from 'cva'

export const buttonVariants = cva({
  base: "button",
  variants: {
    intent: { primary: "...", secondary: "..." },
    size: { sm: "...", md: "...", lg: "..." }
  }
})

export type ButtonProps = VariantProps<typeof buttonVariants>
// Inferred type:
// {
//   intent?: "primary" | "secondary"
//   size?: "sm" | "md" | "lg"
// }
```

## Variant Definition Patterns

### Basic Variants

Define mutually exclusive options for a single dimension:

```typescript
const component = cva({
  base: "base-class",
  variants: {
    // String values
    intent: {
      primary: "bg-blue-500 text-white",
      secondary: "bg-gray-500 text-white",
      outline: "border-2 border-blue-500 text-blue-600"
    },
    // Array syntax (same as space-separated string)
    size: {
      small: ["text-sm", "py-1", "px-2"],
      medium: ["text-base", "py-2", "px-4"],
      large: ["text-lg", "py-3", "px-6"]
    },
    // Boolean variants
    disabled: {
      false: null, // null = no classes applied
      true: "opacity-50 cursor-not-allowed"
    }
  }
})
```

### Compound Variants

Apply classes when multiple variant conditions are met simultaneously:

```typescript
const button = cva({
  base: "button",
  variants: {
    intent: { primary: "...", secondary: "..." },
    size: { small: "...", medium: "..." }
  },
  compoundVariants: [
    // Single condition match
    {
      intent: "primary",
      size: "medium",
      class: "uppercase"
    },
    // Multiple condition match (OR logic)
    {
      intent: ["primary", "secondary"], // Matches either
      size: "medium",
      class: "shadow-lg"
    },
    // Hover states for non-disabled buttons
    {
      intent: "primary",
      disabled: false,
      class: "hover:bg-blue-600"
    }
  ]
})
```

### Default Variants

Set default values to apply when no variant prop is provided:

```typescript
const button = cva({
  base: "button",
  variants: {
    intent: { primary: "...", secondary: "..." },
    size: { sm: "...", md: "...", lg: "..." }
  },
  defaultVariants: {
    intent: "primary",
    size: "md"
  }
})

button() // Uses defaults
// => "button [primary classes] [md classes]"

button({ intent: "secondary" }) // Overrides intent, keeps size default
// => "button [secondary classes] [md classes]"
```

## TypeScript Integration

### Type-Safe Props with VariantProps

```typescript
import { cva, type VariantProps } from 'cva'

// 1. Define variant function
export const buttonVariants = cva({
  base: "inline-flex items-center rounded font-medium transition-all",
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

// 2. Extract variant props type
export type ButtonVariantProps = VariantProps<typeof buttonVariants>

// 3. Extend with additional component props
export interface ButtonProps extends ButtonVariantProps {
  loading?: boolean
  disabled?: boolean
  children: React.ReactNode
}

// 4. Use in component
export const Button = ({ variant, size, loading, ...props }: ButtonProps) => {
  return (
    <button className={buttonVariants({ variant, size })} {...props} />
  )
}
```

### Required Variants Pattern

CVA variants are optional by default. Use TypeScript utility types to enforce required variants:

```typescript
import { cva, type VariantProps } from 'cva'

export type ButtonVariantProps = VariantProps<typeof buttonVariants>

export const buttonVariants = cva({
  base: "button",
  variants: {
    optional: { a: "...", b: "..." },
    required: { a: "...", b: "..." }
  }
})

// Make 'required' variant non-optional
export interface ButtonProps
  extends Omit<ButtonVariantProps, "required">,
    Required<Pick<ButtonVariantProps, "required">> {}

export const button = (props: ButtonProps) => buttonVariants(props)

// ❌ TypeScript Error: Property "required" is missing
button({})

// ✅ Valid
button({ required: "a" })
```

## Vue 3 Integration Patterns

### Basic Vue Component with CVA

```vue
<script setup lang="ts">
import { computed } from 'vue'
import { cva, type VariantProps } from 'cva'
import { cn } from '@/utils/cn' // Class merging utility

// Define variant function
const buttonVariants = cva({
  base: "inline-flex items-center rounded font-medium transition-all",
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

// Define component props interface
interface Props extends ButtonVariantProps {
  class?: string
}

// Define props with defaults
const props = withDefaults(defineProps<Props>(), {
  variant: "primary",
  size: "md"
})

// Compute classes
const classes = computed(() => cn(
  buttonVariants({
    variant: props.variant,
    size: props.size
  }),
  props.class // Allow external class overrides
))
</script>

<template>
  <button :class="classes">
    <slot />
  </button>
</template>
```

### Advanced Pattern: Variant Maps

For complex components, use computed variant maps instead of CVA when dynamic class generation is needed:

```vue
<script setup lang="ts">
import { computed } from 'vue'
import { cn } from '@/utils/cn'

interface Props {
  variant?: 'primary' | 'secondary' | 'outline'
  size?: 'sm' | 'md' | 'lg'
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md'
})

// Centralized variant maps (static strings - Tailwind-safe)
const variantMap = {
  primary: 'bg-primary-500 hover:bg-primary-600 text-white shadow-md',
  secondary: 'bg-gray-500 hover:bg-gray-600 text-white',
  outline: 'border-2 border-primary-500 text-primary-600 hover:bg-primary-500 hover:text-white'
}

const sizeMap = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg'
}

const classes = computed(() => cn(
  'inline-flex items-center rounded-lg font-medium transition-all',
  variantMap[props.variant],
  sizeMap[props.size],
  props.class
))
</script>

<template>
  <button :class="classes">
    <slot />
  </button>
</template>
```

### Props Pattern with withDefaults

```typescript
import { cva, type VariantProps } from 'cva'

const buttonVariants = cva({
  base: "button",
  variants: {
    variant: { primary: "...", secondary: "..." },
    size: { sm: "...", md: "...", lg: "..." }
  }
})

type ButtonVariantProps = VariantProps<typeof buttonVariants>

interface Props extends ButtonVariantProps {
  loading?: boolean
  disabled?: boolean
  class?: string
}

// Use withDefaults to set default variant values
const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
  loading: false,
  disabled: false
})
```

## Tailwind CSS Integration

### Static Class Strings (Critical for Tailwind)

**❌ NEVER: Dynamic class generation**
```typescript
// This will NOT work with Tailwind's JIT compiler
const cls = `text-${size}` // ❌ Won't generate CSS
```

**✅ ALWAYS: Complete static strings**
```typescript
// CVA with complete class strings
const button = cva({
  base: "button",
  variants: {
    size: {
      sm: "text-sm px-3 py-1.5",
      md: "text-base px-4 py-2",
      lg: "text-lg px-6 py-3"
    }
  }
})
```

### Class Merging with cn() Utility

CVA works best with a class merging utility to handle conflicts and conditionals:

```typescript
// src/utils/cn.ts
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

**Usage Pattern:**
```typescript
import { cn } from '@/utils/cn'

const button = cva({
  base: "button",
  variants: { /* ... */ }
})

// Merge CVA classes with external classes
const Component = ({ variant, className }) => {
  return (
    <button className={cn(button({ variant }), className)}>
      Click me
    </button>
  )
}
```

**Why tailwind-merge?**
- Resolves conflicting Tailwind classes (e.g., `px-4` + `px-2` = `px-2`)
- Understands Tailwind's class structure
- Prevents specificity issues

## Component Composition Patterns

### Extending CVA Components

Allow external classes via `class` or `className` prop:

```typescript
const button = cva({
  base: "button",
  variants: { /* ... */ }
})

button({ class: "m-4" })
// => "button [variant classes] m-4"

button({ className: "m-4" }) // React convention
// => "button [variant classes] m-4"
```

### Composing Multiple CVA Components

```typescript
import { cva, cx } from 'cva'
import type { VariantProps } from 'cva'

// Base box component
export type BoxProps = VariantProps<typeof box>
export const box = cva({
  base: "box box-border",
  variants: {
    margin: { 0: "m-0", 2: "m-2", 4: "m-4", 8: "m-8" },
    padding: { 0: "p-0", 2: "p-2", 4: "p-4", 8: "p-8" }
  },
  defaultVariants: {
    margin: 0,
    padding: 0
  }
})

// Card component extending box
type CardBaseProps = VariantProps<typeof cardBase>
const cardBase = cva({
  base: "card border-solid border-slate-300 rounded",
  variants: {
    shadow: {
      md: "drop-shadow-md",
      lg: "drop-shadow-lg",
      xl: "drop-shadow-xl"
    }
  }
})

// Combine props interfaces
export interface CardProps extends BoxProps, CardBaseProps {}

// Merge classes with cx utility
export const card = ({ margin, padding, shadow }: CardProps = {}) =>
  cx(box({ margin, padding }), cardBase({ shadow }))
```

## Best Practices

### 1. Centralized Variant Definitions

**Pattern:** Define variant functions in separate files, export for reuse

```typescript
// components/button/variants.ts
import { cva } from 'cva'

export const buttonVariants = cva({
  base: "...",
  variants: { /* ... */ }
})

export type ButtonVariantProps = VariantProps<typeof buttonVariants>

// components/button/Button.vue
import { buttonVariants, type ButtonVariantProps } from './variants'
```

### 2. Semantic Variant Names

Use intent-revealing names over visual descriptions:

```typescript
// ✅ Good: Intent-based
variants: {
  intent: { primary: "...", danger: "...", success: "..." }
}

// ❌ Bad: Visual-based
variants: {
  color: { blue: "...", red: "...", green: "..." }
}
```

### 3. Design Token Consistency

Use design system tokens in variant classes:

```typescript
const button = cva({
  base: "button",
  variants: {
    variant: {
      primary: "bg-primary-500 text-white hover:bg-primary-600",
      secondary: "bg-secondary-500 text-white hover:bg-secondary-600"
    }
  }
})
```

### 4. Compound Variants for Interactions

Use compound variants for state-dependent styles:

```typescript
compoundVariants: [
  // Hover states only for non-disabled buttons
  {
    intent: "primary",
    disabled: false,
    class: "hover:bg-blue-600 active:bg-blue-700"
  },
  {
    intent: "secondary",
    disabled: false,
    class: "hover:bg-gray-100 active:bg-gray-200"
  }
]
```

### 5. Null Variants for Unset States

Use `null` to explicitly define "no classes" variant:

```typescript
variants: {
  intent: {
    unset: null, // No classes applied
    primary: "button--primary",
    secondary: "button--secondary"
  }
}

button({ intent: "unset" })
// => "button" (only base classes)
```

## Common Patterns

### Pattern 1: Button Component

```typescript
import { cva, type VariantProps } from 'cva'

export const buttonVariants = cva({
  base: "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none",
  variants: {
    variant: {
      default: "bg-primary text-primary-foreground hover:bg-primary/90",
      destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
      outline: "border border-input hover:bg-accent hover:text-accent-foreground",
      secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
      ghost: "hover:bg-accent hover:text-accent-foreground",
      link: "underline-offset-4 hover:underline text-primary"
    },
    size: {
      default: "h-10 py-2 px-4",
      sm: "h-9 px-3 rounded-md",
      lg: "h-11 px-8 rounded-md",
      icon: "h-10 w-10"
    }
  },
  defaultVariants: {
    variant: "default",
    size: "default"
  }
})
```

### Pattern 2: Badge Component

```typescript
export const badgeVariants = cva({
  base: "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
  variants: {
    variant: {
      default: "border-transparent bg-primary text-primary-foreground hover:bg-primary/80",
      secondary: "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
      destructive: "border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80",
      outline: "text-foreground"
    }
  },
  defaultVariants: {
    variant: "default"
  }
})
```

### Pattern 3: Card with Status Variants

```typescript
export const cardVariants = cva({
  base: "rounded-lg border bg-card text-card-foreground shadow-sm transition-all",
  variants: {
    status: {
      default: "",
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
```

## Gotchas & Important Notes

### 1. Tailwind JIT Compiler Limitations

**Issue:** Dynamic class generation won't work with Tailwind's JIT compiler

```typescript
// ❌ This will NOT generate CSS
const dynamicClass = `text-${props.size}` // Don't do this!

// ✅ Use complete static strings in CVA
const button = cva({
  variants: {
    size: {
      sm: "text-sm",
      md: "text-base",
      lg: "text-lg"
    }
  }
})
```

### 2. Class Order and Specificity

**Issue:** Class order matters for Tailwind conflicts

**Solution:** Use `tailwind-merge` via `cn()` utility to resolve conflicts:

```typescript
import { cn } from '@/utils/cn'

// Without tailwind-merge: both px-4 and px-2 applied
const classes = clsx("px-4", "px-2") // => "px-4 px-2"

// With tailwind-merge: last px value wins
const classes = cn("px-4", "px-2") // => "px-2"
```

### 3. Responsive Variants Not Supported

**Issue:** CVA doesn't natively support responsive variants

**Workaround:** Use Tailwind's responsive prefixes in variant classes:

```typescript
// ❌ Not supported
const button = cva({
  variants: {
    size: {
      sm: "text-sm",
      md: "text-base"
    }
  },
  responsiveVariants: { /* doesn't exist */ }
})

// ✅ Embed responsive classes in variants
const button = cva({
  variants: {
    size: {
      responsive: "text-sm md:text-base lg:text-lg"
    }
  }
})

// ✅ Or conditionally render different variants
<button :class="buttonVariants({ size: isMobile ? 'sm' : 'md' })">
```

### 4. Default Variants Can Be Overridden with null

```typescript
const button = cva({
  variants: {
    intent: { primary: "...", secondary: "..." }
  },
  defaultVariants: {
    intent: "primary"
  }
})

button() // Uses default: primary
button({ intent: null }) // Removes default, no intent classes applied
```

### 5. TypeScript Inference with Complex Types

**Issue:** Complex prop types may not infer correctly

**Solution:** Use explicit type annotations:

```typescript
import type { VariantProps } from 'cva'

const button = cva({ /* ... */ })

// Explicit type annotation ensures inference
type ButtonProps = VariantProps<typeof button>

interface ComponentProps extends ButtonProps {
  // Additional props with proper typing
}
```

## Related Topics

- **tailwind-variants** - Alternative library with similar API but responsive variants support
- **clsx** - Utility for conditionally joining class names
- **tailwind-merge** - Merge Tailwind CSS classes without style conflicts
- **Radix UI Slot** - Polymorphic component pattern for `asChild` prop

## References

- [CVA Official Documentation](https://cva.style/docs)
- [CVA GitHub Repository](https://github.com/joe-bell/cva)
- [CVA Beta Documentation](https://beta.cva.style)
- [Vercel Academy: shadcn/ui Component Anatomy](https://vercel.com/academy/shadcn-ui/extending-shadcn-ui-with-custom-components)
- [Tailwind CSS Documentation](https://tailwindcss.com)
- [Vue 3 TypeScript Guide](https://vuejs.org/guide/typescript/composition-api.html)
