---
name: Vue Composable Builder
description: |
  Design and build Vue 3 composables with proper architecture, lifecycle management, store integration, and SSR safety. Use when extracting reusable logic from components, orchestrating multiple stores, splitting monolithic composables (500+ lines), implementing async patterns, or integrating with VueUse/Appwrite/Nanostores. CRITICAL: Composables provide behavior reuse with isolated state per component, NOT shared state (use stores for that). Covers API design with MaybeRefOrGetter, size-based split guidelines, store orchestration patterns, VueUse integration catalog, SSR safety, cleanup, anti-patterns, and troubleshooting. Use for "composable", "useX pattern", "reusable logic", "store orchestration", "split composable", "lifecycle management", "SSR-safe", "side effects".
version: 2.0.0
tags: [vue3, composables, composition-api, typescript, lifecycle, ssr, stores, nanostores, vueuse, appwrite, architecture, side-effects]
---

# Vue Composable Architect

This skill provides a comprehensive guide to designing and building robust, maintainable, and reusable Vue 3 composables.

## Core Philosophy & Decision Tree

1.  **Understand the Core Philosophy:**
    *   Composables are for **behavior reuse**, not data sharing. See [Core Philosophy](./resources/core-philosophy.md).

2.  **Decide if a Composable is Needed:**
    *   Is the logic reused in 3+ components?
    *   Does it manage complex side effects?
    *   Does it orchestrate multiple stores?
    *   Consult the [Decision Framework](./resources/decision-framework.md) for detailed guidance.

3.  **Design and Structure:**
    *   Follow the [API Design](./resources/api-design.md) and [Composable Structure](./resources/composable-structure.md) guidelines.

## Table of Contents

*   ### [Core Concepts](./resources/core-philosophy.md)
    *   [Composables vs. Stores](./resources/core-philosophy.md#composables-behavior-reuse-not-data-sharing)
    *   [Business Logic Layer](./resources/core-philosophy.md#business-logic-layer)
*   ### [Decision Making](./resources/decision-framework.md)
    *   [When to Create a Composable](./resources/decision-framework.md#when-to-create-a-composable)
    *   [Size-Based Guidelines](./resources/decision-framework.md#size-based-guidelines)
*   ### [Design & Structure](./resources/api-design.md)
    *   [API Design](./resources/api-design.md)
    *   [Composable Structure](./resources/composable-structure.md)
*   ### [Core Patterns & Examples](./resources/core-patterns.md)
    *   [Basic, Async, Event, Timer, Watcher Patterns](./resources/core-patterns.md)
    *   [Examples by Use Case](./resources/examples.md)
*   ### [Integrations](./resources/store-integration.md)
    *   [Store Integration](./resources/store-integration.md)
    *   [VueUse Integration](./resources/vueuse-integration.md)
    *   [Appwrite Integration](./resources/appwrite-integration.md)
*   ### [Advanced Topics](./resources/advanced-patterns.md)
    *   [Advanced Patterns](./resources/advanced-patterns.md)
    *   [Splitting Monolithic Composables](./resources/splitting-monolithic-composables.md)
    *   [SSR Safety](./resources/ssr-safety.md)
*   ### [Quality & Maintenance](./resources/best-practices.md)
    *   [Best Practices](./resources/best-practices.md)
    *   [Error Handling](./resources/error-handling.md)
    *   [Anti-Patterns](./resources/anti-patterns.md)
    *   [Troubleshooting](./resources/troubleshooting.md)
    *   [Composable Checklist](./resources/checklist.md)

---

## Cross-References

For related patterns, see these skills:

- **vue-component-builder** - Vue component patterns and UI
- **nanostore-builder** - Create stores for Appwrite collections with BaseStore
- **vue-state-architect** - Meta-framework for deciding where state should live
- **vue-composition-architect** - Component composition, provide/inject, compound components
- **astro-vue-architect** - Astro + Vue integration, data flow patterns, when to use composables vs components in Astro
- **soc-appwrite-integration** - useAppwriteClient singleton and BaseStore patterns