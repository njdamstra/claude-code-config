---
name: Vue Headless Builder
description: |
  Build headless UI components using Reka UI patterns with asChild composition,
  compound components, and provide/inject context sharing. Use when creating
  unstyled primitives (Dialog, Accordion, Combobox), implementing asChild pattern
  for composition without wrappers, or building coordinated component families.
  Works with .vue files. Use for "headless component", "asChild", "compound component",
  "Reka UI", "Radix Vue", "renderless", "provide inject context".
version: 1.0.0
tags: [vue, headless-ui, composition, compound-components, reka-ui]
---

# Vue Headless Builder

This skill provides patterns for building headless UI components in Vue 3, following the architecture of libraries like Reka UI and Radix Vue.

## Core Philosophy

**Headless = Behavior without presentation.**

Build components that provide functionality (state management, accessibility, keyboard navigation) without any styling, allowing for maximum customization.

## Table of Contents

*   ### [Core Philosophy](./resources/core-philosophy.md)
*   ### [Core Patterns](./resources/pattern-1-primitive-component.md)
    *   [Pattern 1: Primitive Component](./resources/pattern-1-primitive-component.md)
    *   [Pattern 2: asChild Composition](./resources/pattern-2-as-child-composition.md)
    *   [Pattern 3: Compound Components](./resources/pattern-3-compound-components.md)
    *   [Pattern 4: Type-Safe Context](./resources/pattern-4-type-safe-context.md)
    *   [Pattern 5: Forwarding Props](./resources/pattern-5-forward-props.md)
    *   [Pattern 6: Forwarding Refs](./resources/pattern-6-forward-refs.md)
*   ### [Instructions & Decision Framework](./resources/instructions.md)
    *   [Step-by-step Instructions](./resources/instructions.md)
    *   [Decision Framework](./resources/decision-framework.md)
*   ### [Examples](./resources/examples.md)
*   ### [Best Practices](./resources/naming-conventions.md)
    *   [Naming Conventions](./resources/naming-conventions.md)
    *   [Common Gotchas](./resources/common-gotchas.md)
*   ### [SSR & Performance](./resources/ssr-and-performance.md)

---

## Related Skills

- **vue-composition-architect** - For solving prop drilling with provide/inject
- **vue-component-builder** - For building styled Vue components
- **vue-state-architect** - For deciding where state should live