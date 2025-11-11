# Headless UI Dialog (Modal)

Headless UI is a set of completely unstyled, fully accessible UI components, designed to integrate seamlessly with Tailwind CSS. It provides the functionality and accessibility features for common UI patterns, leaving the styling entirely up to the developer.

The `Dialog` component is a fully accessible, unstyled modal that can be used to show and hide content.

### Installation

To get started, install Headless UI via npm:

```bash
npm install @headlessui/vue
```

### Core Components

A Headless UI Dialog is built using a combination of the following components:

1.  **`Dialog`**: The main component that manages the state of the dialog.
2.  **`DialogPanel`**: The container for the actual dialog content.
3.  **`DialogTitle`**: (Optional) A title for the dialog.
4.  **`DialogDescription`**: (Optional) A description for the dialog.
5.  **`DialogOverlay`**: (Optional) A backdrop for the dialog.

### Basic Usage Example (Vue)

Here's a basic example demonstrating how to construct a modal:

```vue
<template>
  <button @click="isOpen = true">Open Dialog</button>

  <Dialog :open="isOpen" @close="isOpen = false">
    <DialogOverlay class="fixed inset-0 bg-black opacity-30" />

    <DialogPanel class="fixed inset-0 flex items-center justify-center p-4">
      <div class="bg-white p-4 rounded-lg">
        <DialogTitle>Deactivate account</DialogTitle>
        <DialogDescription>
          This will permanently deactivate your account.
        </DialogDescription>

        <p>
          Are you sure you want to deactivate your account? All of your data will be permanently
          removed. This action cannot be undone.
        </p>

        <button @click="isOpen = false">Deactivate</button>
        <button @click="isOpen = false">Cancel</button>
      </div>
    </DialogPanel>
  </Dialog>
</template>

<script setup>
import { ref } from 'vue'
import { Dialog, DialogPanel, DialogTitle, DialogDescription, DialogOverlay } from '@headlessui/vue'

const isOpen = ref(false)
</script>
```

### Styling

Headless UI components are unstyled by design. You provide the styles yourself, often using utility-first CSS frameworks like Tailwind CSS.

### Accessibility

Headless UI prioritizes accessibility, handling focus management, keyboard interaction, and relevant ARIA attributes out-of-the-box.

*   **Focus Management**: When the dialog opens, focus is automatically moved inside and trapped within the dialog.
*   **Screen Reader Support**: Using `DialogTitle` and `DialogDescription` ensures that screen readers announce the dialog's purpose when it opens.
*   **Scroll Locking**: When a dialog is open, scrolling is locked on the underlying page.
