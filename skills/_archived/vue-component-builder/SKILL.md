---
name: Vue 3 Component Builder
description: Build Vue 3 components using Composition API, script setup syntax, TypeScript strict mode, and Tailwind CSS. Use when creating/modifying .vue SFCs, building form components, modals with Teleport, or integrating third-party libraries (HeadlessUI, Iconify, ECharts). CRITICAL RULES enforced: Tailwind preferred, always dark: mode classes, useMounted for SSR safety, TypeScript prop validation with withDefaults, ARIA labels for accessibility. Prevents common mistakes (missing dark mode, SSR hydration errors, inaccessible components). Use for ".vue", "component", "modal", "form", "icon", "chart".
version: 3.0.0
tags: [vue3, script-setup, composition-api, typescript, tailwind, dark-mode, ssr, accessibility, modals, forms, defineModel, headlessui, iconify]
---

# Vue 3 Component Builder

This skill provides a comprehensive guide to building robust, accessible, and maintainable Vue 3 components using the Composition API, TypeScript, and Tailwind CSS.

## Core Philosophy

**Follow a set of critical rules to ensure consistency, performance, and accessibility across all components.**

## Table of Contents

*   ### [Core Patterns & Rules](./resources/core-patterns.md)
    *   [Critical Rules](./resources/core-patterns.md#critical-rules-never-break)
    *   [Tech Stack](./resources/core-patterns.md#tech-stack)
    *   [Base Component Template](./resources/core-patterns.md#base-component-template)
    *   [Modern v-model Pattern](./resources/core-patterns.md#modern-v-model-pattern-vue-34)
*   ### [Common Component Patterns](./resources/ssr-safe-patterns.md)
    *   [SSR-Safe Patterns](./resources/ssr-safe-patterns.md)
    *   [Form Validation](./resources/form-validation-pattern.md)
    *   [Modals](./resources/modal-pattern.md)
    *   [Nanostores Integration](./resources/nanostores-integration.md)
*   ### [Third-Party Libraries](./resources/third-party-libraries.md)
    *   [Iconify](./resources/third-party-libraries.md#iconify-iconifyvue---256-components-use-this)
    *   [HeadlessUI](./resources/third-party-libraries.md#headlessui-headlessuivue---11-components)
    *   [Floating UI](./resources/third-party-libraries.md#floating-ui-floating-uivue---14-components)
    *   [ECharts](./resources/third-party-libraries.md#echarts-vue-echarts---15-chart-components)
*   ### [Best Practices & Checklists](./resources/component-checklist.md)
    *   [File Organization](./resources/file-organization.md)
    *   [Dark Mode](./resources/dark-mode.md)
    *   [Accessibility](./resources/accessibility.md)
    *   [Component Checklist](./resources/component-checklist.md)

---

## Cross-References

For related patterns, see these skills:
- **astro-vue-architect** - Astro + Vue integration architecture
- **vue-composable-builder** - Vue composable patterns and VueUse integration
- **nanostore-builder** - State management with Nanostores
- **soc-appwrite-integration** - Appwrite SDK usage for data operations