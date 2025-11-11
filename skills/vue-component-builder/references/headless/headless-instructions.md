# Instructions

### Step 1: Identify Component Type

**Primitive?**
- Single element that can render as different tags
- Use Pattern 1 (Primitive Component)

**Compound?**
- Multiple coordinated sibling components
- Shared state between related components
- Use Pattern 3 (Compound Components)

**Composition?**
- Needs to merge behavior without wrapper
- Use Pattern 2 (asChild)

### Step 2: Design Context (for Compound Components)

1. **Root Context:** Global state/config for entire component
2. **Item Context:** Per-item state (optional, for nested compounds)
3. **Naming:** `[Component][Part]Context` (e.g., `AccordionRootContext`)

### Step 3: Implement Provide/Inject

1. **Use Symbols for keys** - Prevents collisions
2. **Provide readonly state** - Mutations via methods only
3. **Validate required context** - Throw errors if missing
4. **Optional context pattern** - Pass `null` for optional inject

### Step 4: Add Accessibility

- **ARIA attributes:** `aria-expanded`, `aria-controls`, `aria-labelledby`
- **Keyboard navigation:** Arrow keys, Enter, Escape
- **Focus management:** `tabindex`, focus trapping
- **Semantic HTML:** Use proper elements (`<button>`, `<dialog>`)

### Step 5: Test Composition

```vue
<!-- Test asChild composition -->
<PrimitiveComponent as-child>
  <CustomComponent />
</PrimitiveComponent>

<!-- Test compound coordination -->
<Root>
  <Item value="1">
    <Trigger>Open 1</Trigger>
    <Content>Content 1</Content>
  </Item>
</Root>
```

