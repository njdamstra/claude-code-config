---
name: Vue Polymorphic Types
description: |
  Create type-safe polymorphic Vue components using generic="T" attribute and
  discriminated unions with never pattern. Use when building components with
  type-safe variants (success/error states), generic data-driven components
  (lists, tables, selects), or type-safe emits. Works with .vue files.
  Use for "generic component", "discriminated union", "variant props",
  "type-safe variants", "polymorphic", "generic T", "never type".
version: 1.0.0
tags: [vue, typescript, generics, discriminated-unions, type-safety]
---

# Vue Polymorphic Types

This skill provides patterns for creating type-safe polymorphic and generic components in Vue 3, leveraging modern TypeScript features.

## Core Concepts

*   **Generic Components:** Use the `generic="T"` attribute to create components that can work with any data type while preserving type safety.
*   **Discriminated Unions:** Create components with mutually exclusive props, ensuring that invalid prop combinations are caught at compile time.

## Table of Contents

*   ### [Pattern 1: Generic Components](./resources/pattern-1-generic-components.md)
    *   Learn how to use the `generic="T"` attribute to create type-safe, data-driven components.
*   ### [Pattern 2: Discriminated Unions](./resources/pattern-2-discriminated-unions.md)
    *   Create components with mutually exclusive variant props using the `never` type.
*   ### [Pattern 3: Generic Ref Forwarding](./resources/pattern-3-ref-forwarding.md)
    *   Build generic components that can expose a typed DOM element reference.
*   ### [Pattern 4: CVA Integration](./resources/pattern-4-cva-integration.md)
    *   Combine generic components with Class Variance Authority for type-safe variants.
*   ### [Instructions & Decision Framework](./resources/instructions.md)
    *   [Step-by-step instructions](./resources/instructions.md) for implementing these patterns.
    *   A [decision framework](./resources/decision-framework.md) to help you choose the right pattern.
*   ### [Examples](./resources/examples.md)
    *   See practical examples of generic and polymorphic components.
*   ### [Common Gotchas & Best Practices](./resources/common-gotchas.md)
    *   Avoid common pitfalls and follow best practices for robust components.
*   ### [Performance & Compatibility](./resources/performance-and-compatibility.md)
    *   Understand the performance and compatibility implications of these patterns.

---

## Related Skills

- **vue-variant-builder** - CVA patterns for type-safe Tailwind variants
- **vue-component-builder** - Build Vue 3 components with TypeScript
- **typescript-fixer** - Fix TypeScript errors with root cause analysis