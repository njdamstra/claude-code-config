# Headless UI Menu (Dropdown)

Headless UI is a set of completely unstyled, fully accessible UI components, designed to integrate seamlessly with Tailwind CSS. It provides the functionality and accessibility features for common UI patterns, leaving the styling entirely up to the developer.

The `Menu` component (often referred to as a Dropdown Menu) is used to display a list of choices, allowing users to make a selection from multiple options. It's ideal for UI elements resembling operating system menus, with specific accessibility semantics where focus is trapped within the open menu.

### Installation

To get started, install Headless UI via npm:

```bash
npm install @headlessui/vue
```

### Core Components

A Headless UI Menu is built using a combination of four primary components:

1.  **`Menu`**: The main container component that wraps the entire menu structure.
2.  **`MenuButton`**: The interactive element that toggles the visibility of the `MenuItems`. It renders a `button` by default.
3.  **`MenuItems`**: The container for the actual menu items. It renders a `div` by default.
4.  **`MenuItem`**: Individual selectable items within the `MenuItems` list.

### Basic Usage Example (Vue)

Here's a basic example demonstrating how to construct a dropdown menu:

```vue
<template>
  <Menu>
    <MenuButton>More options</MenuButton>
    <MenuItems>
      <MenuItem v-slot="{ active }">
        <a :class="{ 'bg-blue-500 text-white': active, 'bg-white text-black': !active }" href="/account-settings">
          Account settings
        </a>
      </MenuItem>
      <MenuItem v-slot="{ active }">
        <a :class="{ 'bg-blue-500 text-white': active, 'bg-white text-black': !active }" href="/documentation">
          Documentation
        </a>
      </MenuItem>
      <MenuItem disabled>
        <span class="opacity-75">Invite a friend (coming soon!)</span>
      </MenuItem>
    </MenuItems>
  </Menu>
</template>

<script setup>
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
</script>
```

### Styling

Headless UI components are unstyled by design. You provide the styles yourself, often using utility-first CSS frameworks like Tailwind CSS.

*   **Slot Props**: Each component exposes information about its current state (e.g., `active`, `disabled`) via slot props. You can use these to conditionally apply styles. For example, `MenuItem` exposes an `active` state to indicate if it's currently focused by mouse or keyboard.
*   **Data Attributes**: Components also expose `data-*` attributes (e.g., `data-active`, `data-focus`) that can be used for styling different states.

### Accessibility

Headless UI prioritizes accessibility, handling focus management, keyboard interaction, and relevant ARIA attributes out-of-the-box.

*   Clicking the `MenuButton` toggles the menu and focuses the `MenuItems`.
*   Focus is trapped within the open menu until `Escape` is pressed or the user clicks outside.
*   Arrow keys navigate through `MenuItem`s.

### Key Props and Features

*   **`as` prop**: By default, components render sensible HTML elements (e.g., `MenuButton` as `<button>`, `MenuItems` as `<div>`). You can change the rendered element using the `as` prop. Use `as="template"` to render children directly without a wrapper element.
*   **`disabled` prop**: You can disable individual `MenuItem`s, which will prevent interaction and can be styled accordingly.
*   **Transitions**: To animate the opening and closing of the menu, you can wrap `MenuItems` in Headless UI's `Transition` component.
*   **`unmount` prop**: On `MenuItems`, you can use the `unmount` prop to control whether the menu items are removed from the DOM or merely hidden when the menu is closed.
