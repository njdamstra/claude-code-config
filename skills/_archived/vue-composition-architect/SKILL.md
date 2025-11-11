---
name: Vue Composition Architect
description: |
  Design and implement Vue 3 component composition architectures using size-based split guidelines, state colocation principles, and composition patterns to solve prop drilling, tight coupling, and unclear component boundaries. Use when refactoring large components (300+ lines), splitting monolithic composables, implementing provide/inject for component subtrees, designing compound components (Dialog.Root/Trigger pattern), or creating headless UI primitives. CRITICAL: Colocate state as close as possible to usage, split when 2+ triggers present (size, SRP violation, reusability mismatch). Works with .vue SFC files, TypeScript interfaces, and component composition patterns. Use for "prop drilling", "component architecture", "split component", "compound component", "headless UI", "provide inject", "state colocation", "component splitting", or when components pass 5+ props through intermediaries.
version: 2.0.0
tags: [vue3, composition, architecture, slots, provide-inject, compound-components, headless-ui, splitting, refactoring, state-colocation]
---

# Vue Composition Architect

This skill helps you design and implement robust Vue 3 component composition architectures. It provides guidelines and patterns to create scalable, maintainable, and reusable components.

## Core Concepts & Decision Tree

When faced with a complex component, use this decision tree to determine the best course of action:

1.  **Analyze the Component:**
    *   Is the component becoming too large or complex?
        *   Consult the [Size-Based Guidelines](./resources/size-based-guidelines.md).
    *   Does the component have too many responsibilities?
        *   Review the [Split Decision Framework](./resources/split-decision-framework.md).

2.  **Manage State Effectively:**
    *   Is state being passed through multiple layers of components (prop drilling)?
    *   Is state located too high in the component tree?
        *   Apply the principles of [State Colocation](./resources/state-colocation.md).

3.  **Choose the Right Composition Pattern:**
    *   Based on your analysis, select the appropriate composition pattern.
        *   Use the [Core Decision Framework](./resources/core-decision-framework.md) to guide your choice.

## Table of Contents

*   ### [Core Concepts](./resources/core-decision-framework.md)
    *   [Problem → Solution Matrix](./resources/core-decision-framework.md#problem-→-solution-matrix)
    *   [Composition Patterns Hierarchy](./resources/core-decision-framework.md#composition-patterns-hierarchy)
    *   [State Placement Hierarchy](./resources/core-decision-framework.md#state-placement-hierarchy)
*   ### [Guidelines & Rules](./resources/decision-rules.md)
    *   [Size-Based Guidelines](./resources/size-based-guidelines.md)
    *   [Split Decision Framework](./resources/split-decision-framework.md)
    *   ["3 Unrelated Components" Rule](./resources/decision-rules.md#3-unrelated-components-rule)
    *   ["200 Lines" Rule](./resources/decision-rules.md#200-lines-rule)
    *   ["Props vs Provide/Inject" Rule](./resources/decision-rules.md#props-vs-provideinject-rule)
*   ### [Step-by-Step Instructions](./resources/instructions.md)
    *   [Step 1: Analyze Component Hierarchy](./resources/instructions.md#step-1-analyze-component-hierarchy)
    *   [Step 2: Choose Composition Pattern](./resources/instructions.md#step-2-choose-composition-pattern)
    *   [Step 3: Refactor Implementation](./resources/instructions.md#step-3-refactor-implementation)
    *   [Step 4: Validate Architecture](./resources/instructions.md#step-4-validate-architecture)
*   ### [Patterns & Examples](./resources/examples.md)
    *   [Orchestrator Pattern](./resources/orchestrator-pattern.md)
    *   [Provide/Inject](./resources/examples.md#example-1-fixing-prop-drilling-in-account-selection)
    *   [Compound Components](./resources/examples.md#example-2-compound-component-for-onboarding-steps)
    *   [Headless UI](./resources/examples.md#example-3-headless-dialog-with-aschild)
*   ### [Best Practices](./resources/best-practices.md)
*   ### [Troubleshooting](./resources/troubleshooting.md)

---

## Related Patterns

For complementary patterns, see:
- **vue-state-architect** - When to use stores vs composables vs provide/inject
- **vue-composable-architect** - Creating reusable composable logic with lifecycle
- **vue-variant-builder** - Styling compound components with CVA
- **vue-headless-builder** - Reka UI patterns, asChild composition, primitive components