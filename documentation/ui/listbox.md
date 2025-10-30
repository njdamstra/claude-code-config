# Headless UI Listbox (Select)

Headless UI is a set of completely unstyled, fully accessible UI components, designed to integrate seamlessly with Tailwind CSS. It provides the functionality and accessibility features for common UI patterns, leaving the styling entirely up to the developer.

The `Listbox` component is used to create a fully accessible, custom select menu.

### Installation

To get started, install Headless UI via npm:

```bash
npm install @headlessui/vue
```

### Core Components

A Headless UI Listbox is built using a combination of four primary components:

1.  **`Listbox`**: The main container component that wraps the entire listbox and manages its state.
2.  **`ListboxButton`**: The button that toggles the visibility of the listbox options.
3.  **`ListboxOptions`**: The container for the actual listbox options.
4.  **`ListboxOption`**: Individual selectable items within the `ListboxOptions` list.
5.  **`ListboxLabel`**: (Optional) A label for the listbox.

### Basic Usage Example (Vue)

Here's a basic example demonstrating how to construct a custom select menu:

```vue
<template>
  <Listbox v-model="selectedPerson">
    <ListboxButton>{{ selectedPerson.name }}</ListboxButton>
    <ListboxOptions>
      <ListboxOption
        v-for="person in people"
        :key="person.id"
        :value="person"
        as="template"
        v-slot="{ active, selected }"
      >
        <li
          :class="{
            'bg-blue-500 text-white': active,
            'bg-white text-black': !active,
          }"
        >
          <CheckIcon v-show="selected" />
          {{ person.name }}
        </li>
      </ListboxOption>
    </ListboxOptions>
  </Listbox>
</template>

<script setup>
import { ref } from 'vue'
import { Listbox, ListboxButton, ListboxOptions, ListboxOption } from '@headlessui/vue'
import { CheckIcon } from '@heroicons/vue/20/solid'

const people = [
  { id: 1, name: 'Durward Reynolds' },
  { id: 2, name: 'Kenton Towne' },
  { id: 3, name: 'Therese Wunsch' },
  { id: 4, name: 'Benedict Kessler' },
  { id: 5, name: 'Katelyn Rohan' },
]
const selectedPerson = ref(people[0])
</script>
```

### Styling

Headless UI components are unstyled by design. You provide the styles yourself, often using utility-first CSS frameworks like Tailwind CSS.

*   **Slot Props**: Each component exposes information about its current state (e.g., `active`, `selected`) via slot props. You can use these to conditionally apply styles. For example, `ListboxOption` exposes an `active` state to indicate if it's currently focused by mouse or keyboard, and a `selected` state to indicate if it's the currently selected option.
*   **Data Attributes**: Components also expose `data-*` attributes (e.g., `data-active`, `data-selected`) that can be used for styling different states.

### Accessibility

Headless UI prioritizes accessibility, handling focus management, keyboard interaction, and relevant ARIA attributes out-of-the-box.

### Key Props and Features

*   **`as` prop**: By default, components render sensible HTML elements (e.g., `ListboxButton` as `<button>`, `ListboxOptions` as `<ul>`). You can change the rendered element using the `as` prop. Use `as="template"` to render children directly without a wrapper element.
*   **`v-model`**: The `Listbox` component uses `v-model` to manage the selected value.
*   **Transitions**: To animate the opening and closing of the listbox, you can wrap `ListboxOptions` in Headless UI's `Transition` component.
