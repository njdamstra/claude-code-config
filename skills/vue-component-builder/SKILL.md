---
name: Vue Component Builder
description: |
  Comprehensive guide to building Vue 3 components using Composition API, script setup, TypeScript, and Tailwind CSS. 
  Covers component fundamentals, composition patterns (splitting, provide/inject, compound components), 
  headless UI patterns (Reka UI, asChild), type-safe patterns (polymorphic, generics, discriminated unions), 
  variant systems (CVA), performance optimization (lazy loading, v-memo, virtual scrolling), template refs (defineExpose),
  advanced slots (scoped, dynamic, renderless), transitions & animations, error handling, Suspense, 
  third-party integrations (HeadlessUI, Iconify, ECharts, Floating UI), Astro basics, SSR safety, 
  accessibility, dark mode, and best practices. Use for ".vue", "component", "modal", "form", "headless", 
  "compound component", "variant", "polymorphic", "generic component", "CVA", "split component", "provide inject",
  "defineAsyncComponent", "v-memo", "defineExpose", "Suspense", "Transition", "slots", "error handling".
version: 1.0.0
tags: [vue3, script-setup, composition-api, typescript, tailwind, dark-mode, ssr, accessibility, modals, forms, 
       defineModel, headlessui, iconify, echarts, floating-ui, headless-ui, compound-components, provide-inject, 
       polymorphic, generics, discriminated-unions, cva, variants, component-composition, state-colocation,
       performance, lazy-loading, v-memo, virtual-scrolling, code-splitting, defineAsyncComponent, defineExpose,
       template-refs, slots, scoped-slots, renderless-components, transitions, animations, error-handling,
       suspense, loading-states, astro, client-directives]
---

# Vue Component Architect

This skill provides a comprehensive guide to building robust, accessible, maintainable, and type-safe Vue 3 components using the Composition API, TypeScript, and Tailwind CSS.

## Core Philosophy

**Follow a set of critical rules to ensure consistency, performance, accessibility, and type safety across all components.**

## Table of Contents

*   ### [Core Patterns & Rules](./references/core-patterns.md)
    *   [Critical Rules](./references/fundamentals/critical-rules.md)
    *   [Tech Stack](./references/core-patterns.md#tech-stack)
    *   [Base Component Template](./references/core-patterns.md#base-component-template)
    *   [Modern v-model Pattern](./references/core-patterns.md#modern-v-model-pattern-vue-34)

*   ### [Component Fundamentals](./references/fundamentals/component-fundamentals.md)
    *   [SSR-Safe Patterns](./references/fundamentals/ssr-safe-patterns.md)
    *   [Form Validation](./references/fundamentals/form-validation-pattern.md)
    *   [Modals](./references/fundamentals/modal-pattern.md)
    *   [File Organization](./references/fundamentals/file-organization.md)
    *   [Dark Mode](./references/fundamentals/dark-mode.md)
    *   [Accessibility](./references/fundamentals/accessibility.md)
    *   [Component Checklist](./references/fundamentals/component-checklist.md)

*   ### [Component Composition](./references/composition/component-composition.md)
    *   [Core Decision Framework](./references/composition/core-decision-framework.md)
    *   [Size-Based Guidelines](./references/composition/size-based-guidelines.md)
    *   [Split Decision Framework](./references/composition/split-decision-framework.md)
    *   [State Colocation](./references/composition/state-colocation.md)
    *   [Orchestrator Pattern](./references/composition/orchestrator-pattern.md)
    *   [Instructions](./references/composition/composition-instructions.md)
    *   [Examples](./references/composition/composition-examples.md)
    *   [Best Practices](./references/composition/composition-best-practices.md)
    *   [Troubleshooting](./references/composition/composition-troubleshooting.md)
    *   [Decision Rules](./references/composition/decision-rules.md)

*   ### [Headless UI Patterns](./references/headless/headless-patterns.md)
    *   [Core Philosophy](./references/headless/headless-philosophy.md)
    *   [Pattern 1: Primitive Component](./references/headless/pattern-1-primitive-component-headless.md)
    *   [Pattern 2: asChild Composition](./references/headless/pattern-2-as-child-composition-headless.md)
    *   [Pattern 3: Compound Components](./references/headless/pattern-3-compound-components-headless.md)
    *   [Pattern 4: Type-Safe Context](./references/headless/pattern-4-type-safe-context-headless.md)
    *   [Pattern 5: Forward Props](./references/headless/pattern-5-forward-props-headless.md)
    *   [Pattern 6: Forward Refs](./references/headless/pattern-6-forward-refs-headless.md)
    *   [Instructions](./references/headless/headless-instructions.md)
    *   [Decision Framework](./references/headless/headless-decision-framework.md)
    *   [Examples](./references/headless/headless-examples.md)
    *   [Naming Conventions](./references/headless/headless-naming-conventions.md)
    *   [Common Gotchas](./references/headless/headless-gotchas.md)
    *   [SSR & Performance](./references/headless/headless-ssr-performance.md)

*   ### [Type-Safe Patterns](./references/types/type-patterns.md)
    *   [Pattern 1: Generic Components](./references/types/pattern-1-generic-components-polymorphic.md)
    *   [Pattern 2: Discriminated Unions](./references/types/pattern-2-discriminated-unions-polymorphic.md)
    *   [Pattern 3: Generic Ref Forwarding](./references/types/pattern-3-ref-forwarding-polymorphic.md)
    *   [Pattern 4: CVA Integration](./references/types/pattern-4-cva-integration-polymorphic.md)
    *   [Instructions](./references/types/polymorphic-instructions.md)
    *   [Decision Framework](./references/types/polymorphic-decision-framework.md)
    *   [Examples](./references/types/polymorphic-examples.md)
    *   [Common Gotchas](./references/types/polymorphic-gotchas.md)
    *   [Performance & Compatibility](./references/types/polymorphic-performance.md)

*   ### [Variant Systems](./references/variants/variant-systems.md)
    *   [Core Concepts](./references/variants/cva-core-concepts.md)
    *   [Instructions](./references/variants/cva-instructions.md)
    *   [Examples](./references/variants/cva-examples.md)
    *   [Critical Rules](./references/variants/cva-critical-rules.md)
    *   [Best Practices](./references/variants/cva-best-practices.md)
    *   [Troubleshooting](./references/variants/cva-troubleshooting.md)

*   ### [Third-Party Integrations](./references/integrations/third-party-libraries.md)
    *   [Iconify](./references/integrations/third-party-libraries.md#iconify-iconifyvue---256-components-use-this)
    *   [HeadlessUI](./references/integrations/third-party-libraries.md#headlessui-headlessuivue---11-components)
    *   [Floating UI](./references/integrations/third-party-libraries.md#floating-ui-floating-uivue---14-components)
    *   [ECharts](./references/integrations/third-party-libraries.md#echarts-vue-echarts---15-chart-components)

*   ### [Performance Optimization](./references/performance/performance-optimization.md)
    *   [Lazy Loading & Code Splitting](./references/performance/lazy-loading.md)
    *   [v-memo Directive](./references/performance/v-memo.md)
    *   [Virtual Scrolling](./references/performance/virtual-scrolling.md)
    *   [Code Splitting Strategies](./references/performance/code-splitting.md)
    *   [Performance Monitoring](./references/performance/performance-monitoring.md)

*   ### [Template Refs](./references/refs/template-refs.md)
    *   [defineExpose](./references/refs/define-expose.md)
    *   [Typed Refs](./references/refs/typed-refs.md)
    *   [Ref Forwarding](./references/refs/ref-forwarding.md)

*   ### [Advanced Slots](./references/slots/advanced-slots.md)
    *   [Scoped Slots](./references/slots/scoped-slots.md)
    *   [Dynamic Slots](./references/slots/dynamic-slots.md)
    *   [Renderless Components](./references/slots/renderless-components.md)

*   ### [Transitions & Animations](./references/transitions/transitions-animations.md)
    *   [Transition Component](./references/transitions/transition-component.md)
    *   [TransitionGroup](./references/transitions/transition-group.md)

*   ### [Error Handling](./references/errors/error-handling.md)
    *   [Error Boundaries](./references/errors/error-boundaries.md)

*   ### [Suspense & Loading States](./references/suspense/loading-states.md)
    *   [Suspense Patterns](./references/suspense/suspense-patterns.md)

*   ### [Astro Basics](./references/astro-basics/client-directives.md)
    *   [Client Directives](./references/astro-basics/client-directives.md)

*   ### [State Integration](./references/integrations/nanostores-integration.md)
    *   [Nanostores Integration Patterns](./references/integrations/nanostores-integration.md)

---

## Cross-References

For related patterns, see these skills:
- **vue-composable-builder** - Vue composable patterns and VueUse integration
- **vue-architect** - Meta-framework for deciding where state should live
- **nanostore-builder** - State management with Nanostores
- **soc-appwrite-integration** - Appwrite SDK usage for data operations
- **astro-vue-architect** - Astro + Vue integration architecture (for architectural decisions, not component-level patterns)

