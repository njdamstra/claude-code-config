---
name: VueUse Expert
description: Master VueUse composables library with decision frameworks, SSR patterns, and animation integration. Covers 160+ composables across 8 categories plus @vueuse/motion. Use when choosing composables for state management, DOM interaction, sensors, network, browser APIs, animations, or utilities. Provides decision trees, SSR safety guidance, and links to local documentation (262 files). Prevents recreating existing composables. Use for "vueuse", "composable", "animation", "motion", "useStorage", "useMounted", "watch*", "use*", "browser api", "ssr safety".
version: 1.0.0
tags: [vueuse, composables, ssr, motion, animations, state, dom, sensors, browser-api, utilities, decision-tree]
---

# VueUse Expert

This skill is your guide to mastering the VueUse library. It helps you discover, decide on, and correctly implement the 160+ available composables.

## Core Philosophy

**ALWAYS check VueUse before creating custom composables.**

## Quick Navigation & Decision Tree

1.  **Explore the Most Common Tools:**
    *   Start with the [Top 20 Most-Used Composables](./resources/top-20-composables.md) to familiarize yourself with the essentials.

2.  **Find the Right Composable for Your Task:**
    *   Use the [Decision Trees](./resources/decision-trees.md) to select the best composable for state management, DOM interaction, animations, and more.

3.  **Ensure SSR Safety:**
    *   Is your app running in an SSR environment (like Astro)?
    *   Consult the [SSR Safety Guide](./resources/ssr-safety-guide.md) to prevent common pitfalls.

4.  **Implement Animations:**
    *   For animations, refer to the [@vueuse/motion Guide](./resources/motion-library.md).

## Table of Contents

*   ### [Top 20 Composables](./resources/top-20-composables.md)
*   ### [Decision Trees](./resources/decision-trees.md)
    *   [State Management](./resources/decision-trees.md#decision-tree-1-state-management)
    *   [DOM Interaction](./resources/decision-trees.md#decision-tree-2-dom-interaction)
    *   [SSR Safety](./resources/decision-trees.md#decision-tree-3-ssr-safety)
    *   [Animations](./resources/decision-trees.md#decision-tree-4-animations)
    *   [Watchers](./resources/decision-trees.md#decision-tree-5-watchers)
*   ### [SSR Safety Guide](./resources/ssr-safety-guide.md)
*   ### [Animation with @vueuse/motion](./resources/motion-library.md)
*   ### [Composable Categories](./resources/category-reference.md)
    *   [State Management](./resources/category-reference.md#1-state-management-20-composables)
    *   [Elements & DOM](./resources/category-reference.md#2-elements--dom-35-composables)
    *   [Browser APIs](./resources/category-reference.md#3-browser-apis-30-composables)
    *   [Sensors & Input](./resources/category-reference.md#4-sensors--input-25-composables)
    *   [Network & Communication](./resources/category-reference.md#5-network--communication-10-composables)
    *   [Watchers & Timing](./resources/category-reference.md#6-watchers--timing-15-composables)
    *   [Utilities & Helpers](./resources/category-reference.md#7-utilities--helpers-20-composables)
    *   [Animations (@vueuse/motion)](./resources/category-reference.md#8-animations-vueusemotion-23-docs)
*   ### [Common Patterns](./resources/common-patterns.md)
*   ### [Documentation Navigation](./resources/documentation-navigation.md)

---

## Cross-References

### Related Skills

- **vue-composable-builder** - How to create custom composables (use VueUse when available!)
- **vue-component-builder** - Using VueUse composables in Vue components
- **astro-vue-architect** - SSR patterns with VueUse in Astro