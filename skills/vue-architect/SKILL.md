---
name: Vue Architect
description: |
  Design state management architecture for Vue 3 applications by deciding where state should live (component, composable, store, provide/inject) and preventing common anti-patterns. Use when unclear whether to use Nanostores vs composables vs local state, experiencing state duplication across components, dealing with prop drilling issues, implementing forms with draft state, or optimizing state reactivity. Works with .vue files, TypeScript interfaces, Nanostores (atom, map, computed, persistent), and composable patterns. Use for "state management", "where should state live", "store vs composable", "props vs state", "controlled component", "v-model pattern", "derived state", "computed store", "nanostore", "atom store", "state colocation", "state architecture", or when components have unclear state ownership.
version: 1.0.0
tags: [vue3, state-management, nanostores, composables, architecture, reactivity, atom, persistent]
---

# Vue State Architect

This skill provides a framework for designing robust and maintainable state management architectures in Vue 3 applications.

## Core Philosophy

**COLOCATE STATE AS CLOSE AS POSSIBLE TO WHERE IT'S USED.**

Start with local state and only lift it to a higher level (composable, store) when necessary.

## Decision Tree

1.  **Where should state live?**
    *   Consult the [State Placement Hierarchy](./resources/core-decision-framework.md#the-state-placement-hierarchy).

2.  **What type of state should it be?**
    *   Use the [State Type Decision Matrix](./resources/core-decision-framework.md#state-type-decision-matrix).

3.  **How should components interact with state?**
    *   Review the [Props vs. State Patterns](./resources/instructions.md#step-3-implement-props-vs-state-pattern).

## Table of Contents

*   ### [Core Decision Framework](./resources/core-decision-framework.md)
    *   [State Placement Hierarchy](./resources/core-decision-framework.md#the-state-placement-hierarchy)
    *   [State Type Decision Matrix](./resources/core-decision-framework.md#state-type-decision-matrix)
    *   [Component State vs. Props](./resources/core-decision-framework.md#component-state-vs-props-decision-tree)
*   ### [Step-by-Step Instructions](./resources/instructions.md)
    *   [Analyze State Characteristics](./resources/instructions.md#step-1-analyze-state-characteristics)
    *   [Choose State Pattern](./resources/instructions.md#step-2-choose-state-pattern)
    *   [Handle Form State](./resources/instructions.md#step-4-handle-form-state-local-draft-pattern)
    *   [Optimize Performance](./resources/instructions.md#step-5-optimize-state-performance)
*   ### [Decision Rules & Best Practices](./resources/decision-rules.md)
    *   [Decision Rules](./resources/decision-rules.md)
    *   [Best Practices](./resources/best-practices.md)
*   ### [Examples & Anti-Patterns](./resources/examples.md)
    *   [Examples](./resources/examples.md)
    *   [Anti-Patterns](./resources/anti-patterns.md)
*   ### [Troubleshooting](./resources/troubleshooting.md)

---

## Related Patterns

For complementary patterns, see:
- **vue-component-builder** - Component composition and provide/inject
- **vue-composable-builder** - Creating reusable composables
- **nanostore-builder** - Advanced Nanostores patterns (BaseStore, persistence, integrations)