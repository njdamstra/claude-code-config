# Headless UI Switch (Toggle)

Headless UI is a set of completely unstyled, fully accessible UI components, designed to integrate seamlessly with Tailwind CSS. It provides the functionality and accessibility features for common UI patterns, leaving the styling entirely up to the developer.

The `Switch` component is a fully accessible, unstyled toggle switch that can be used to show and hide content.

### Installation

To get started, install Headless UI via npm:

```bash
npm install @headlessui/vue
```

### Core Components

A Headless UI Switch is built using a combination of the following components:

1.  **`Switch`**: The main component that manages the state of the switch.
2.  **`SwitchGroup`**: (Optional) A wrapper component to group a `Switch`, `SwitchLabel`, and `SwitchDescription`.
3.  **`SwitchLabel`**: (Optional) A label for the switch.
4.  **`SwitchDescription`**: (Optional) A description for the switch.

### Basic Usage Example (Vue)

Here's a basic example demonstrating how to construct a toggle switch:

```vue
<template>
  <Switch
    v-model="enabled"
    :class="enabled ? 'bg-blue-600' : 'bg-gray-200'"
    class="relative inline-flex h-6 w-11 items-center rounded-full transition"
  >
    <span class="sr-only">Enable notifications</span>
    <span
      :class="enabled ? 'translate-x-6' : 'translate-x-1'"
      class="inline-block h-4 w-4 transform rounded-full bg-white transition"
    />
  </Switch>
</template>

<script setup>
import { ref } from 'vue'
import { Switch } from '@headlessui/vue'

const enabled = ref(false)
</script>
```

### Styling

Headless UI components are unstyled by design. You provide the styles yourself, often using utility-first CSS frameworks like Tailwind CSS.

*   **Slot Props**: The `Switch` component exposes its `checked` state via a slot prop, allowing for conditional styling directly within the component's children.
*   **Data Attributes**: Components also expose `data-*` attributes (e.g., `data-checked`, `data-disabled`) that can be used for styling different states.

### Accessibility

Headless UI prioritizes accessibility, handling focus management, keyboard interaction, and relevant ARIA attributes out-of-the-box.

*   **Keyboard Navigation**: Toggling by clicking or pressing the spacebar when focused.
*   **ARIA Attributes**: Correct `aria` attributes (e.g., `aria-checked`, `aria-labelledby`, `aria-describedby`) are managed automatically.

### Using with HTML Forms

If you add a `name` prop to your `Switch`, a hidden input element will be rendered and kept in sync with the switch's state. This allows the switch to be used within native HTML `<form>` elements for traditional form submissions. By default, the value will be `'on'` when checked.
