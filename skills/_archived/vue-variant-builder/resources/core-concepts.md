# Core Concepts

### What is CVA?

**CVA (Class Variance Authority)** creates type-safe variant generators for Tailwind components:

```typescript
import { cva, type VariantProps } from 'class-variance-authority'

const button = cva({
  base: "rounded font-medium transition-all",
  variants: {
    intent: {
      primary: "bg-primary-500 text-white hover:bg-primary-600",
      secondary: "bg-gray-500 text-white hover:bg-gray-600"
    },
    size: {
      sm: "px-3 py-1.5 text-sm",
      md: "px-4 py-2 text-base"
    }
  },
  defaultVariants: {
    intent: "primary",
    size: "md"
  }
})

// Usage
button() // => "rounded font-medium... [primary] [md]"
button({ intent: "secondary", size: "sm" })
```

**Key Benefits:**
- **Type inference:** `VariantProps<typeof button>` extracts prop types automatically
- **Compound variants:** Apply classes when multiple conditions met
- **Default variants:** Sensible defaults without manual logic
- **Zero runtime cost:** Just string concatenation, no CSS-in-JS

### CVA vs Manual Variant Maps

**Before (Manual Maps):**
```vue
<script setup lang="ts">
const variantMap = {
  primary: 'bg-primary-500 hover:bg-primary-600',
  secondary: 'bg-gray-500 hover:bg-gray-600'
}

const sizeMap = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base'
}

const classes = computed(() => cn(
  'rounded font-medium',
  variantMap[props.variant],
  sizeMap[props.size]
))
</script>
```

**After (CVA):**
```vue
<script setup lang="ts">
const buttonVariants = cva({
  base: "rounded font-medium",
  variants: {
    variant: { primary: "...", secondary: "..." },
    size: { sm: "...", md: "..." }
  }
})

// Automatic type inference
type ButtonProps = VariantProps<typeof buttonVariants>

const classes = computed(() => buttonVariants({
  variant: props.variant,
  size: props.size
}))
</script>
```

**CVA Advantages:**
- TypeScript types auto-generated
- Compound variants built-in
- Cleaner syntax for complex combinations
