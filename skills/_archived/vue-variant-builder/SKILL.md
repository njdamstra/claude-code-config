---
name: Vue Variant Builder
description: |
  Create type-safe component variant systems using CVA (Class Variance Authority) for Vue 3 components with Tailwind CSS. Use when building multi-variant components (Button, Badge, Card), eliminating duplicate components (PrimaryButton, DangerButton), implementing compound variants (hover states, size combinations), or replacing manual variant maps. Works with .vue files, TypeScript, and Tailwind CSS v4. Use for "component variants", "CVA", "button variants", "tailwind variants", "compound variants", "type-safe variants", "variant builder", or when components have multiple style variations (3+ color/size combinations).
version: 1.0.0
tags: [vue3, cva, variants, tailwind, typescript, design-system]
---

# Vue Variant Builder

This skill provides a structured approach to building type-safe, maintainable, and scalable component variant systems in Vue 3 using CVA (Class Variance Authority) and Tailwind CSS.

## Core Philosophy

**Eliminate duplicate components and manual variant maps by using CVA to create a single source of truth for your component styles.**

## Decision Tree

1.  **Is your component starting to have multiple style variations (e.g., different colors, sizes)?**
    *   Yes: Proceed to the next step.
    *   No: CVA might be overkill. Stick with simple props.

2.  **Are you creating separate components for each variation (e.g., `PrimaryButton`, `SecondaryButton`)?**
    *   Yes: This is a clear sign you need CVA. See the [Core Concepts](./resources/core-concepts.md) to understand how CVA can help.

3.  **Ready to build your variant system?**
    *   Follow the [Step-by-Step Instructions](./resources/instructions.md) to set up CVA, define your variants, and integrate them into your Vue components.

## Table of Contents

*   ### [Core Concepts](./resources/core-concepts.md)
    *   [What is CVA?](./resources/core-concepts.md#what-is-cva)
    *   [CVA vs. Manual Variant Maps](./resources/core-concepts.md#cva-vs-manual-variant-maps)
*   ### [Step-by-Step Instructions](./resources/instructions.md)
    *   [Setup](./resources/instructions.md#step-1-setup-cva-and-cn-utility)
    *   [Define Variant System](./resources/instructions.md#step-2-define-variant-system)
    *   [Integrate with Vue Component](./resources/instructions.md#step-3-integrate-with-vue-component)
    *   [Handle Dark Mode](./resources/instructions.md#step-4-handle-dark-mode)
    *   [Advanced Patterns](./resources/instructions.md#step-5-advanced-patterns)
*   ### [Examples](./resources/examples.md)
    *   [Button Component](./resources/examples.md#example-1-button-component)
    *   [Badge Component](./resources/examples.md#example-2-badge-component)
    *   [Card Component](./resources/examples.md#example-3-card-with-status-variants)
*   ### [Rules & Best Practices](./resources/critical-rules.md)
    *   [Critical Rules](./resources/critical-rules.md)
    *   [Best Practices](./resources/best-practices.md)
*   ### [Troubleshooting](./resources/troubleshooting.md)

---

## Related Patterns

For complementary patterns, see:
- **vue-composition-architect** - Component composition and slot patterns
- **vue-state-architect** - State management decisions
- **ui-builder** - Complete UI component generation