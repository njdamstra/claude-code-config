# Troubleshooting

### Issue: Classes not applying

**Symptoms:** Variant classes don't appear in DOM

**Solutions:**
1. Verify Tailwind sees complete class strings (no dynamic generation)
2. Check safelist in `tailwind.config.js` if needed
3. Run `npm run build` to regenerate Tailwind CSS

### Issue: Class overrides not working

**Symptoms:** `class` prop doesn't override CVA classes

**Solutions:**
1. Use `cn()` utility (combines clsx + tailwind-merge)
2. Ensure `tailwind-merge` is installed
3. Check class order: `cn(variants, props.class)`

### Issue: TypeScript errors with VariantProps

**Symptoms:** Type inference fails, `VariantProps<typeof X>` is `any`

**Solutions:**
1. Simplify variant definitions (< 10 variants per CVA)
2. Manually define props interface if inference breaks
3. Update TypeScript to v5+ for better inference

### Issue: Dark mode classes not working

**Symptoms:** `dark:` classes don't apply

**Solutions:**
1. Verify Tailwind dark mode config: `darkMode: 'class'`
2. Check `<html class="dark">` or `data-theme="dark"` attribute
3. Ensure dark: variants in CVA definitions
