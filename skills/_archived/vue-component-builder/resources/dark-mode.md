# Dark Mode Best Practices

### Color Patterns
```
Background colors:
- Light: bg-white, bg-gray-50, bg-gray-100
- Dark:  dark:bg-gray-800, dark:bg-gray-900, dark:bg-black

Text colors:
- Light: text-gray-900, text-gray-800, text-gray-700
- Dark:  dark:text-gray-100, dark:text-gray-200, dark:text-gray-300

Border colors:
- Light: border-gray-200, border-gray-300
- Dark:  dark:border-gray-700, dark:border-gray-600

Hover states:
- Light: hover:bg-gray-100
- Dark:  dark:hover:bg-gray-700
```

### Always Pair Light + Dark
```vue
<!-- CORRECT: Both light and dark -->
<div class="bg-white dark:bg-gray-800">
  <p class="text-gray-900 dark:text-gray-100">Text</p>
</div>

<!-- INCORRECT: Only light ❌ -->
<div class="bg-white">
  <p class="text-gray-900">Text</p>
</div>
```
