# Tailwind Dark Mode Patterns

## Always Pair Light and Dark

```html
<!-- ✅ CORRECT -->
<div class="bg-white dark:bg-gray-800">
  <p class="text-gray-900 dark:text-gray-100">Text</p>
</div>

<!-- ❌ WRONG -->
<div class="bg-white">
  <p class="text-gray-900">Text</p>
</div>
```

## Common Patterns

### Backgrounds
- `bg-white dark:bg-gray-800`
- `bg-gray-50 dark:bg-gray-900`
- `bg-gray-100 dark:bg-gray-800`

### Text
- `text-gray-900 dark:text-gray-100`
- `text-gray-700 dark:text-gray-300`

### Borders
- `border-gray-200 dark:border-gray-700`
- `border-gray-300 dark:border-gray-600`

### Hover States
- `hover:bg-gray-100 dark:hover:bg-gray-700`
- `hover:text-gray-900 dark:hover:text-gray-100`
