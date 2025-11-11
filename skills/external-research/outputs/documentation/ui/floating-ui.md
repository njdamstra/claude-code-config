# Floating UI Vue

Floating UI is a small library for positioning floating elements like tooltips, popovers, and dropdowns. This document provides an overview of how to use the `@floating-ui/vue` package.

### Installation

To get started, install `@floating-ui/vue` via npm:

```bash
npm install @floating-ui/vue
```

### `useFloating`

The `useFloating` composable is the main entry point for using Floating UI in Vue. It takes a reference to the floating element and a reference to the reference element, and it returns a set of reactive refs that you can use to position the floating element.

```vue
<script setup>
import { ref } from 'vue'
import { useFloating } from '@floating-ui/vue'

const reference = ref(null)
const floating = ref(null)

const { floatingStyles } = useFloating(reference, floating)
</script>

<template>
  <div>
    <button ref="reference">Reference</button>
    <div ref="floating" :style="floatingStyles">Floating</div>
  </div>
</template>
```

### Placement

You can control the placement of the floating element by passing a `placement` option to the `useFloating` composable. The available placements are:

*   `top`
*   `top-start`
*   `top-end`
*   `right`
*   `right-start`
*   `right-end`
*   `bottom`
*   `bottom-start`
*   `bottom-end`
*   `left`
*   `left-start`
*   `left-end`

```vue
<script setup>
import { ref } from 'vue'
import { useFloating } from '@floating-ui/vue'

const reference = ref(null)
const floating = ref(null)

const { floatingStyles } = useFloating(reference, floating, {
  placement: 'top',
})
</script>
```

### Middleware

Middleware allows you to extend the functionality of Floating UI. The most common middleware are:

*   **`offset`**: Adds a gap between the reference and floating elements.
*   **`flip`**: Flips the floating element to the opposite side if it's about to overflow.
*   **`shift`**: Shifts the floating element to prevent it from overflowing.
*   **`arrow`**: Adds an arrow to the floating element that points to the reference element.

```vue
<script setup>
import { ref } from 'vue'
import { useFloating, offset, flip, shift } from '@floating-ui/vue'

const reference = ref(null)
const floating = ref(null)

const { floatingStyles } = useFloating(reference, floating, {
  placement: 'top',
  middleware: [offset(10), flip(), shift()],
})
</script>
```

### `autoUpdate`

The `autoUpdate` function automatically updates the position of the floating element when the reference element or the floating element changes size or position.

```vue
<script setup>
import { ref } from 'vue'
import { useFloating, autoUpdate } from '@floating-ui/vue'

const reference = ref(null)
const floating = ref(null)

const { floatingStyles } = useFloating(reference, floating, {
  whileElementsMounted: autoUpdate,
})
</script>
```
