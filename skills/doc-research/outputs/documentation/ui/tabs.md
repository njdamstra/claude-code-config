# Headless UI Tabs

Headless UI is a set of completely unstyled, fully accessible UI components, designed to integrate seamlessly with Tailwind CSS. It provides the functionality and accessibility features for common UI patterns, leaving the styling entirely up to the developer.

The `Tabs` component is a fully accessible, unstyled tab component that can be used to show and hide content.

### Installation

To get started, install Headless UI via npm:

```bash
npm install @headlessui/vue
```

### Core Components

A Headless UI Tabs component is built using a combination of the following components:

1.  **`TabGroup`**: The main container for the tabs.
2.  **`TabList`**: Contains the individual `Tab` buttons.
3.  **`Tab`**: Represents a single tab button.
4.  **`TabPanels`**: Contains the `TabPanel` components.
5.  **`TabPanel`**: The content associated with a specific `Tab`.

### Basic Usage Example (Vue)

Here's a basic example demonstrating how to construct a set of tabs:

```vue
<template>
  <TabGroup>
    <TabList>
      <Tab>Tab 1</Tab>
      <Tab>Tab 2</Tab>
      <Tab>Tab 3</Tab>
    </TabList>
    <TabPanels>
      <TabPanel>Content for Tab 1</TabPanel>
      <TabPanel>Content for Tab 2</TabPanel>
      <TabPanel>Content for Tab 3</TabPanel>
    </TabPanels>
  </TabGroup>
</template>

<script setup>
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from '@headlessui/vue'
</script>
```

### Styling

Headless UI components are unstyled by design. You provide the styles yourself, often using utility-first CSS frameworks like Tailwind CSS.

*   **Slot Props**: The `Tab` component exposes its `selected` state via a slot prop, allowing for conditional styling directly within the component's children.
*   **Data Attributes**: Components also expose `data-*` attributes (e.g., `data-selected`) that can be used for styling different states.

### Accessibility

Headless UI prioritizes accessibility, handling focus management, keyboard interaction, and relevant ARIA attributes out-of-the-box.

*   **Keyboard Navigation**: Arrow keys can be used to navigate between tabs.
*   **ARIA Attributes**: Correct `aria` attributes (e.g., `aria-selected`, `aria-controls`) are managed automatically.

### Key Props and Features

*   **`defaultIndex`**: You can set the initially selected tab by passing a `defaultIndex` prop to the `TabGroup` component.
*   **`v-model`**: You can control the selected tab by using `v-model` on the `TabGroup` component.
*   **`manual`**: By default, tabs are automatically selected as the user navigates through them using arrow keys. If you prefer to only change the tab when the user presses `Enter` or `Space`, use the `manual` prop on `TabGroup`.
*   **`vertical`**: You can change the orientation of the `TabList` to vertical using the `vertical` prop on `TabGroup`.
