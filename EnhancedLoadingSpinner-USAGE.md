# EnhancedLoadingSpinner Usage Examples

## Component Features

- ✅ **5 size variants**: xs, sm, md, lg, xl
- ✅ **4 color variants**: primary, secondary, white, current
- ✅ **Optional text label**
- ✅ **Inline or block layout**
- ✅ **Dark mode support**
- ✅ **SSR-safe** (no client-only code)
- ✅ **Accessible** (ARIA labels, screen reader text)
- ✅ **TypeScript** with full type safety

---

## Basic Usage

### Default Spinner (medium, primary)
```vue
<EnhancedLoadingSpinner />
```

### With Size Variants
```vue
<!-- Extra small -->
<EnhancedLoadingSpinner size="xs" />

<!-- Small -->
<EnhancedLoadingSpinner size="sm" />

<!-- Medium (default) -->
<EnhancedLoadingSpinner size="md" />

<!-- Large -->
<EnhancedLoadingSpinner size="lg" />

<!-- Extra large -->
<EnhancedLoadingSpinner size="xl" />
```

### With Color Variants
```vue
<!-- Primary (blue) - default -->
<EnhancedLoadingSpinner variant="primary" />

<!-- Secondary (gray) -->
<EnhancedLoadingSpinner variant="secondary" />

<!-- White (for dark backgrounds) -->
<EnhancedLoadingSpinner variant="white" />

<!-- Current color (inherits text color) -->
<EnhancedLoadingSpinner variant="current" />
```

### With Text Label
```vue
<!-- Centered with text below -->
<EnhancedLoadingSpinner
  size="lg"
  text="Loading your data..."
/>

<!-- Different messages -->
<EnhancedLoadingSpinner
  size="md"
  variant="primary"
  text="Processing..."
/>

<EnhancedLoadingSpinner
  size="sm"
  variant="secondary"
  text="Please wait"
/>
```

### Inline Layout
```vue
<!-- Inline with text beside spinner -->
<EnhancedLoadingSpinner
  size="sm"
  variant="current"
  text="Loading..."
  inline
/>
```

---

## Real-World Examples

### 1. Button Loading State
```vue
<script setup lang="ts">
import { ref } from 'vue'
import EnhancedLoadingSpinner from '@/components/EnhancedLoadingSpinner.vue'

const isLoading = ref(false)

async function handleSubmit() {
  isLoading.value = true
  try {
    await submitForm()
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <button
    @click="handleSubmit"
    :disabled="isLoading"
    class="px-4 py-2 bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 text-white rounded-lg disabled:opacity-50 flex items-center space-x-2"
  >
    <EnhancedLoadingSpinner
      v-if="isLoading"
      size="xs"
      variant="white"
      inline
    />
    <span>Submit</span>
  </button>
</template>
```

### 2. Page Loading Overlay
```vue
<script setup lang="ts">
import { ref } from 'vue'
import EnhancedLoadingSpinner from '@/components/EnhancedLoadingSpinner.vue'

const isPageLoading = ref(true)

// Simulate data loading
setTimeout(() => {
  isPageLoading.value = false
}, 2000)
</script>

<template>
  <div v-if="isPageLoading" class="fixed inset-0 bg-white/90 dark:bg-gray-900/90 flex items-center justify-center z-50">
    <EnhancedLoadingSpinner
      size="xl"
      variant="primary"
      text="Loading page..."
    />
  </div>

  <div v-else>
    <!-- Page content -->
  </div>
</template>
```

### 3. Card Loading State
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'
import EnhancedLoadingSpinner from '@/components/EnhancedLoadingSpinner.vue'

const data = ref(null)
const isLoading = ref(true)

onMounted(async () => {
  try {
    data.value = await fetchData()
  } finally {
    isLoading.value = false
  }
})
</script>

<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
    <div v-if="isLoading" class="flex justify-center py-8">
      <EnhancedLoadingSpinner
        size="lg"
        variant="primary"
        text="Loading data..."
      />
    </div>

    <div v-else>
      <!-- Display data -->
      <h2 class="text-xl font-bold text-gray-900 dark:text-gray-100">{{ data.title }}</h2>
      <p class="text-gray-700 dark:text-gray-300">{{ data.content }}</p>
    </div>
  </div>
</template>
```

### 4. Infinite Scroll Loading Indicator
```vue
<script setup lang="ts">
import { ref } from 'vue'
import EnhancedLoadingSpinner from '@/components/EnhancedLoadingSpinner.vue'

const isLoadingMore = ref(false)
const items = ref([1, 2, 3, 4, 5])

async function loadMore() {
  isLoadingMore.value = true
  try {
    const newItems = await fetchMoreItems()
    items.value.push(...newItems)
  } finally {
    isLoadingMore.value = false
  }
}
</script>

<template>
  <div class="space-y-4">
    <div
      v-for="item in items"
      :key="item"
      class="p-4 bg-white dark:bg-gray-800 rounded-lg"
    >
      Item {{ item }}
    </div>

    <!-- Loading more indicator at bottom -->
    <div v-if="isLoadingMore" class="flex justify-center py-4">
      <EnhancedLoadingSpinner
        size="md"
        variant="primary"
        text="Loading more..."
        inline
      />
    </div>
  </div>
</template>
```

### 5. Dark Background Variant
```vue
<template>
  <!-- Dark card with white spinner -->
  <div class="bg-gray-900 dark:bg-black p-8 rounded-lg">
    <EnhancedLoadingSpinner
      size="lg"
      variant="white"
      text="Processing your request..."
    />
  </div>
</template>
```

### 6. Inline Text Loading
```vue
<template>
  <p class="text-gray-700 dark:text-gray-300 flex items-center space-x-2">
    <EnhancedLoadingSpinner
      size="xs"
      variant="current"
      inline
    />
    <span>Saving changes...</span>
  </p>
</template>
```

---

## Props API

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `size` | `'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'` | `'md'` | Size of the spinner |
| `variant` | `'primary' \| 'secondary' \| 'white' \| 'current'` | `'primary'` | Color variant |
| `text` | `string \| undefined` | `undefined` | Optional loading text |
| `inline` | `boolean` | `false` | Inline layout (horizontal) |

---

## Size Reference

| Size | Dimensions | Use Case |
|------|------------|----------|
| `xs` | 16px (1rem) | Small buttons, inline text |
| `sm` | 24px (1.5rem) | Medium buttons, compact cards |
| `md` | 32px (2rem) | Default, most common use case |
| `lg` | 48px (3rem) | Large cards, prominent loading |
| `xl` | 64px (4rem) | Full page overlays, splash screens |

---

## Variant Reference

| Variant | Light Mode | Dark Mode | Use Case |
|---------|------------|-----------|----------|
| `primary` | Blue (#2563eb) | Light Blue (#60a5fa) | Default, most actions |
| `secondary` | Gray (#4b5563) | Light Gray (#9ca3af) | Secondary actions |
| `white` | White (#ffffff) | Off-white (#f3f4f6) | Dark backgrounds |
| `current` | Inherits text color | Inherits text color | Match surrounding text |

---

## Accessibility Features

- ✅ `role="status"` - Identifies as status indicator
- ✅ `aria-live="polite"` - Announces to screen readers (non-intrusive)
- ✅ `aria-label="Loading"` - Describes spinner purpose
- ✅ `aria-hidden="true"` - Hides decorative spinner from screen readers
- ✅ `.sr-only` text - Provides context for screen reader users
- ✅ Semantic HTML - Uses proper container structure

---

## Dark Mode

All variants automatically adapt to dark mode:

```vue
<!-- Automatically switches based on theme -->
<EnhancedLoadingSpinner variant="primary" />
<!-- Light: border-blue-600 -->
<!-- Dark: dark:border-blue-400 -->

<EnhancedLoadingSpinner variant="secondary" />
<!-- Light: border-gray-600 -->
<!-- Dark: dark:border-gray-400 -->
```

Text color also adapts:
```vue
<EnhancedLoadingSpinner text="Loading..." />
<!-- Light: text-gray-700 -->
<!-- Dark: dark:text-gray-300 -->
```

---

## Comparison with Existing LoadingSpinner.vue

| Feature | Old LoadingSpinner.vue | EnhancedLoadingSpinner.vue |
|---------|------------------------|----------------------------|
| Size variants | ❌ Fixed (32x32) | ✅ 5 sizes (xs-xl) |
| Color variants | ❌ Fixed (gray-900) | ✅ 4 variants |
| Text label | ❌ No | ✅ Optional |
| Inline layout | ❌ No | ✅ Yes |
| Props | ❌ None | ✅ Full API |
| Dark mode | ✅ Basic | ✅ All variants |
| Accessibility | ⚠️ Partial | ✅ Complete |
| TypeScript | ✅ Yes | ✅ Full types |

---

## Migration from Old Component

Replace:
```vue
<LoadingSpinner class="w-20 h-20" />
```

With:
```vue
<EnhancedLoadingSpinner size="lg" />
```

---

## Notes

- **SSR-Safe**: No client-only code, works perfectly with Astro SSR
- **Performance**: CSS-only animation (no JavaScript)
- **Composable**: Works well with other components
- **Responsive**: Adapts to light/dark mode automatically
- **Accessible**: Proper ARIA attributes and screen reader support
