# Best Practices

### Variant Organization

**File structure for large components:**
```
components/
├─ button/
│  ├─ Button.vue
│  ├─ variants.ts      # CVA definitions
│  └─ types.ts         # TypeScript interfaces
```

**variants.ts:**
```typescript
import { cva } from 'class-variance-authority'

export const buttonVariants = cva({
  base: "...",
  variants: { /* ... */ }
})

export type ButtonVariantProps = VariantProps<typeof buttonVariants>
```

### Performance

**CVA Performance Characteristics:**
- **Bundle size:** ~0.5KB gzipped
- **Runtime cost:** String concatenation only (negligible)
- **Type checking:** Complex variants can slow TypeScript
  - **Limit:** < 10 variants per CVA definition
  - **Solution:** Split and compose multiple CVAs

### Testing

**Test variant combinations:**
```typescript
import { describe, it, expect } from 'vitest'
import { buttonVariants } from './variants'

describe('buttonVariants', () => {
  it('applies default variants', () => {
    expect(buttonVariants()).toContain('bg-primary-500')
  })

  it('applies compound variants', () => {
    const result = buttonVariants({ intent: 'primary', size: 'md' })
    expect(result).toContain('shadow-md')
  })

  it('handles disabled state', () => {
    expect(buttonVariants({ disabled: true })).toContain('opacity-50')
  })
})
```
