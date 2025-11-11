# Vue Skills Consolidation Analysis & Recommendations

## Current State: 7 Vue Skills

### 1. **vue-component-builder**
**Focus:** Building Vue 3 components (SFCs)
- Composition API, script setup, TypeScript
- Tailwind CSS, dark mode, accessibility
- SSR safety patterns
- Third-party integrations (HeadlessUI, Iconify, ECharts)
- Forms, modals, component patterns
- **10 resource files**

### 2. **vue-composable-architect**
**Focus:** Designing and building composables
- Composable architecture and lifecycle
- Store integration (Nanostores)
- VueUse/Appwrite integrations
- Splitting monolithic composables
- SSR safety for composables
- **18 resource files** (most comprehensive)

### 3. **vue-composition-architect**
**Focus:** Component composition and architecture
- Splitting large components
- State colocation principles
- Provide/inject patterns
- Compound components
- Size-based guidelines
- **11 resource files**

### 4. **vue-headless-builder**
**Focus:** Headless UI components
- Reka UI patterns
- asChild composition
- Compound components (overlaps with composition-architect)
- Provide/inject context (overlaps with composition-architect)
- **14 resource files**

### 5. **vue-polymorphic-types**
**Focus:** Type-safe polymorphic components
- Generic components (`generic="T"`)
- Discriminated unions
- Ref forwarding
- CVA integration (overlaps with variant-builder)
- **10 resource files**

### 6. **vue-state-architect**
**Focus:** State management decisions
- Where state should live (component/composable/store/provide-inject)
- Nanostores patterns
- Form state patterns
- State placement hierarchy
- **8 resource files** (but very comprehensive, ~1000 lines)

### 7. **vue-variant-builder**
**Focus:** Component variant systems
- CVA (Class Variance Authority)
- Type-safe Tailwind variants
- Compound variants
- **7 resource files**

---

## Overlap Analysis

### Significant Overlaps:

1. **Compound Components & Provide/Inject:**
   - `vue-composition-architect` covers compound components
   - `vue-headless-builder` covers compound components (Reka UI pattern)
   - Both cover provide/inject
   - **Recommendation:** Merge headless patterns into composition-architect

2. **CVA Integration:**
   - `vue-polymorphic-types` has CVA integration pattern
   - `vue-variant-builder` is entirely about CVA
   - **Recommendation:** Merge polymorphic CVA pattern into variant-builder

3. **Component Building:**
   - `vue-component-builder` covers general component patterns
   - `vue-composition-architect` covers component architecture
   - `vue-polymorphic-types` covers component type patterns
   - **Recommendation:** These complement each other but could be unified

4. **State Management:**
   - `vue-state-architect` covers state placement decisions
   - `vue-composable-architect` covers composable state patterns
   - **Recommendation:** Keep separate - different concerns (decisions vs implementation)

---

## Consolidation Recommendations

### **RECOMMENDED: 2 Skills**

#### **Option A: Component-Centric (Recommended)**

**1. `vue-component-architect`** (Consolidates: component-builder, composition-architect, headless-builder, polymorphic-types, variant-builder)
- **Purpose:** Complete guide to building Vue components
- **Covers:**
  - Component fundamentals (script setup, TypeScript, Tailwind)
  - Component composition (splitting, provide/inject, compound components)
  - Headless UI patterns (Reka UI, asChild)
  - Type patterns (polymorphic, generics, discriminated unions)
  - Variant systems (CVA, Tailwind variants)
  - Third-party integrations
  - SSR safety, accessibility, dark mode
- **Why:** All these skills are about "how to build components" - they're complementary aspects of the same task

**2. `vue-state-architect`** (Keep as-is)
- **Purpose:** State management architecture decisions
- **Covers:**
  - Where state should live (component/composable/store/provide-inject)
  - Nanostores patterns
  - Form state patterns
- **Why:** This is a meta-framework for decisions, not implementation. It's conceptually different from component building.

**3. `vue-composable-architect`** (Keep as-is, but rename to clarify scope)
- **Purpose:** Building reusable composables
- **Covers:**
  - Composable architecture and lifecycle
  - Store integration
  - VueUse/Appwrite integrations
  - Splitting monolithic composables
- **Why:** Composables are a distinct abstraction layer - they're not components, they're reusable logic. This deserves its own skill.

---

### **ALTERNATIVE: 3 Skills (If you want more granularity)**

**1. `vue-component-architect`** (component-builder + composition-architect + headless-builder + polymorphic-types + variant-builder)
- Component building, composition, headless, types, variants

**2. `vue-composable-architect`** (keep as-is)
- Composable patterns and lifecycle

**3. `vue-state-architect`** (keep as-is)
- State management decisions

---

## Detailed Consolidation Plan

### **Skill 1: `vue-component-architect`**

**Merge from:**
- `vue-component-builder` (base component patterns)
- `vue-composition-architect` (component architecture)
- `vue-headless-builder` (headless patterns)
- `vue-polymorphic-types` (type patterns)
- `vue-variant-builder` (variant systems)

**New Structure:**

```
vue-component-architect/
├── SKILL.md
└── resources/
    ├── core-patterns.md (from component-builder)
    ├── component-fundamentals.md (script setup, TypeScript, Tailwind)
    ├── component-composition.md (from composition-architect)
    │   ├── Splitting components
    │   ├── State colocation
    │   ├── Provide/inject
    │   └── Compound components
    ├── headless-patterns.md (from headless-builder)
    │   ├── Reka UI patterns
    │   ├── asChild composition
    │   └── Primitive components
    ├── type-patterns.md (from polymorphic-types)
    │   ├── Generic components
    │   ├── Discriminated unions
    │   └── Ref forwarding
    ├── variant-systems.md (from variant-builder + polymorphic CVA)
    │   ├── CVA setup
    │   ├── Type-safe variants
    │   └── Compound variants
    ├── third-party-integrations.md (from component-builder)
    ├── ssr-safety.md (from component-builder)
    ├── accessibility.md (from component-builder)
    ├── dark-mode.md (from component-builder)
    └── examples.md (consolidated examples)
```

**Description:**
```
Build Vue 3 components using Composition API, script setup, TypeScript, and Tailwind CSS. 
Covers component fundamentals, composition patterns (splitting, provide/inject, compound components), 
headless UI patterns (Reka UI, asChild), type-safe patterns (polymorphic, generics), 
variant systems (CVA), third-party integrations, SSR safety, and accessibility.
Use for ".vue", "component", "modal", "form", "headless", "compound component", "variant", "polymorphic".
```

---

### **Skill 2: `vue-composable-architect`** (Keep, minor updates)

**Keep as-is** - already well-structured and comprehensive.

**Minor updates:**
- Clarify relationship to `vue-component-architect` (composables vs components)
- Update cross-references

---

### **Skill 3: `vue-state-architect`** (Keep as-is)

**Keep as-is** - comprehensive decision framework.

**Minor updates:**
- Update cross-references to new `vue-component-architect`

---

## Migration Strategy

### Phase 1: Create New Skill Structure
1. Create `vue-component-architect` directory
2. Copy and reorganize resources from 5 skills
3. Merge overlapping content
4. Update cross-references
5. Write new SKILL.md

### Phase 2: Update Commands
1. Update `/commands/vue/component.md` to use `vue-component-architect`
2. Update `/commands/vue/composition.md` to use `vue-component-architect`
3. Update `/commands/vue/headless.md` to use `vue-component-architect`
4. Update `/commands/vue/polymorphic.md` to use `vue-component-architect`
5. Update `/commands/vue/variant.md` to use `vue-component-architect`
6. Keep `/commands/vue/composable.md` pointing to `vue-composable-architect`
7. Keep `/commands/vue/state.md` pointing to `vue-state-architect`

### Phase 3: Archive Old Skills
1. Move old skills to `_archived/`:
   - `vue-component-builder`
   - `vue-composition-architect`
   - `vue-headless-builder`
   - `vue-polymorphic-types`
   - `vue-variant-builder`

### Phase 4: Testing
1. Test each command to ensure correct skill invocation
2. Verify cross-references work
3. Check that all patterns are accessible

---

## Benefits of Consolidation

### **Reduced Cognitive Load**
- 2-3 skills instead of 7
- Clearer boundaries (components vs composables vs state decisions)
- Less confusion about which skill to use

### **Better Coverage**
- All component-related patterns in one place
- Easier to find related patterns
- More comprehensive examples

### **Maintainability**
- Single source of truth for component patterns
- Easier to keep cross-references updated
- Less duplication

### **User Experience**
- Clearer mental model: "Building components" vs "Building composables" vs "Managing state"
- More likely to find what they need
- Better discoverability

---

## Risks & Mitigations

### **Risk 1: Skill becomes too large**
- **Mitigation:** Well-organized with clear sections. Each resource file focuses on one topic.

### **Risk 2: Loss of specific patterns**
- **Mitigation:** Careful merge process, preserve all unique content, consolidate only overlapping content.

### **Risk 3: Breaking existing workflows**
- **Mitigation:** Update all commands simultaneously, keep archived skills for reference.

---

## Final Recommendation

**Consolidate to 2 skills:**

1. **`vue-component-architect`** - Everything about building Vue components
2. **`vue-composable-architect`** - Everything about building Vue composables  
3. **`vue-state-architect`** - Everything about state management decisions

This gives you:
- **Clear separation of concerns** (components vs composables vs state)
- **Comprehensive coverage** (all patterns in logical places)
- **Reduced complexity** (3 skills instead of 7)
- **Better maintainability** (less duplication, clearer structure)

The key insight: **Components and composables are different abstraction layers** - components are UI, composables are reusable logic. State architecture is a meta-framework for decisions. These three concerns naturally separate.

