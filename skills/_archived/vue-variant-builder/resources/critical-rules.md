# Critical Rules

### ✅ DO:

1. **Use complete static strings:**
   ```typescript
   variants: {
     size: {
       sm: "text-sm px-3 py-1.5" // ✅ Complete string
     }
   }
   ```

2. **Use cn() for class overrides:**
   ```typescript
   const classes = computed(() => cn(
     buttonVariants({ variant }),
     props.class
   ))
   ```

3. **Plan dark mode from start:**
   ```typescript
   primary: "bg-blue-500 dark:bg-blue-600"
   ```

4. **Use semantic variant names:**
   ```typescript
   intent: { primary: "...", danger: "..." }
   ```

5. **Extract variant props type:**
   ```typescript
   type Props = VariantProps<typeof buttonVariants>
   ```

### ❌ DON'T:

1. **Never use dynamic class generation:**
   ```typescript
   // ❌ WRONG - Tailwind won't generate CSS
   const cls = `text-${size}`
   ```

2. **Don't skip tailwind-merge:**
   ```typescript
   // ❌ WRONG - Class conflicts
   const cls = clsx(variants, props.class)

   // ✅ CORRECT - Resolves conflicts
   const cls = cn(variants, props.class)
   ```

3. **Don't create massive variant definitions:**
   ```typescript
   // ❌ Too many combinations (180+)
   variants: {
     color: { /* 3 options */ },
     size: { /* 5 options */ },
     shape: { /* 3 options */ },
     shadow: { /* 4 options */ }
   }

   // ✅ Split into multiple CVA definitions
   ```

4. **Don't use visual names:**
   ```typescript
   // ❌ Non-semantic
   color: { blue: "...", red: "..." }

   // ✅ Semantic
   intent: { primary: "...", danger: "..." }
   ```

5. **Don't retrofit dark mode:**
   ```typescript
   // ❌ Add dark: variants later (painful refactor)

   // ✅ Add dark: variants from start
   ```
