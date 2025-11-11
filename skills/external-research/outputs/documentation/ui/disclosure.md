# Headless UI Disclosure (Accordion)

Headless UI is a set of completely unstyled, fully accessible UI components, designed to integrate seamlessly with Tailwind CSS. It provides the functionality and accessibility features for common UI patterns, leaving the styling entirely up to the developer.

The `Disclosure` component is a fully accessible, unstyled accordion that can be used to show and hide content.

### Installation

To get started, install Headless UI via npm:

```bash
npm install @headlessui/vue
```

### Core Components

A Headless UI Disclosure is built using a combination of the following components:

1.  **`Disclosure`**: The main container component that wraps the entire disclosure and manages its state.
2.  **`DisclosureButton`**: The button that toggles the visibility of the disclosure panel.
3.  **`DisclosurePanel`**: The container for the actual disclosure content.

### Basic Usage Example (Vue)

Here's a basic example demonstrating how to construct an accordion:

```vue
<template>
  <Disclosure>
    <DisclosureButton>
      <h2>Toggle Section Title</h2>
    </DisclosureButton>
    <DisclosurePanel>
      <p>This is the content that will be revealed or hidden.</p>
    </DisclosurePanel>
  </Disclosure>
</template>

<script setup>
import { Disclosure, DisclosureButton, DisclosurePanel } from '@headlessui/vue'
</script>
```

### Styling

Headless UI components are unstyled by design. You provide the styles yourself, often using utility-first CSS frameworks like Tailwind CSS.

*   **Slot Props**: The `Disclosure` component exposes its `open` state via a slot prop, allowing for conditional styling directly within the component's children.
*   **Data Attributes**: Components also expose `data-*` attributes (e.g., `data-open`, `data-closed`) that can be used for styling different states.

### Accessibility

Headless UI prioritizes accessibility, handling focus management, keyboard interaction, and relevant ARIA attributes out-of-the-box.

*   **Keyboard Navigation**: Toggling by clicking or pressing the spacebar when focused.
*   **ARIA Attributes**: Correct `aria` attributes (e.g., `aria-expanded`, `aria-controls`) are managed automatically.

### Transitions

To animate the opening and closing of the disclosure, you can wrap `DisclosurePanel` in Headless UI's `Transition` component.
