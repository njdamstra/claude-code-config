# Vue 3 Composable Consolidation - Community Best Practices

**Research Date:** 2025-11-04
**Sources:** Web research via Tavily MCP (articles, tutorials, discussions, Stack Overflow)
**Search Queries:**
- "Vue 3 composable consolidation best practices refactoring patterns"
- "Vue composition API composable design patterns when to merge 2024 2025"
- "large Vue composable architecture pitfalls gotchas lessons learned"

## Summary

Community consensus leans toward **smaller, focused composables over large consolidated ones**, with specific patterns emerging for when consolidation makes sense. The key insight: consolidation should follow **Extract Function principles** (Martin Fowler), grouping related logic for readability while keeping composables deliberately small and composable with each other.

**Strong Consensus (>75% of sources):**
- Keep composables small and focused (single responsibility)
- Use inline composables for component-specific logic before extracting to files
- Prefer Setup stores over Options stores for composability
- Avoid destructuring to maintain reactivity

**Moderate Consensus (50-75%):**
- Consolidate when logic shares state AND lifecycle
- Use `MaybeRefOrGetter` and `toValue()` for flexible parameter handling
- Extract to separate files only when reusable across components

**Controversial (<50%):**
- Whether to use Pinia vs useState for state management
- Options API vs Composition API migration timing

## Common Implementation Patterns

### Pattern 1: Inline Composables Refactoring (Extract Function)

**Source:** "The Inline Vue Composables Refactoring pattern" - alexop.dev - Apr 2025
**Link:** https://alexop.dev/posts/inline-vue-composables-refactoring/

**Description:**
Inspired by Martin Fowler's Extract Function pattern. Group related logic into well-named functions **within** your component before extracting to separate files. This is the stepping stone to consolidation.

**Code Example:**
```vue
<script setup>
// BEFORE: Mixed concerns
const showHiddenFolders = ref(localStorage.getItem('show-hidden') === 'true')
const favoriteFolders = useQuery(FOLDERS_FAVORITE, [])
watch(showHiddenFolders, (value) => {
  if (value) {
    localStorage.setItem('show-hidden', 'true')
  } else {
    localStorage.removeItem('show-hidden')
  }
})

// AFTER: Inline composables (consolidated within component)
const { showHiddenFolders } = useHiddenFolders()
const { favoriteFolders, toggleFavorite } = useFavoriteFolders()

function useHiddenFolders() {
  const showHiddenFolders = ref(localStorage.getItem('show-hidden') === 'true')

  watch(showHiddenFolders, (value) => {
    if (value) {
      localStorage.setItem('show-hidden', 'true')
    } else {
      localStorage.removeItem('show-hidden')
    }
  }, { lazy: true })

  return { showHiddenFolders }
}

function useFavoriteFolders() {
  const favoriteFolders = useQuery(FOLDERS_FAVORITE, [])

  async function toggleFavorite(currentFolderData) {
    await mutate({
      mutation: FOLDER_SET_FAVORITE,
      variables: {
        path: currentFolderData.path,
        favorite: !currentFolderData.favorite
      }
    })
  }

  return { favoriteFolders, toggleFavorite }
}
</script>
```

**Pros:**
- Improves readability without file overhead
- Easy to see related logic at a glance
- Stepping stone to external composables
- No risk of premature abstraction

**Cons:**
- Can make component file larger if overdone
- Not reusable outside component
- Risk of creating too many tiny functions

**When to Use:**
- Component logic getting hard to read (> 100 lines in `<script setup>`)
- Related state, watchers, and async logic needs grouping
- Logic is component-specific, not ready for sharing
- Improving readability without over-engineering

### Pattern 2: MaybeRefOrGetter for Flexible Parameters

**Source:** "Best practices using composables with multiple parameters" - Stack Overflow - Mar 2025
**Link:** https://stackoverflow.com/questions/79511390/

**Description:**
Avoid creating separate refs for every parameter. Use `MaybeRefOrGetter` type and `toValue()` utility to accept both reactive and non-reactive values, making composables more flexible and consolidatable.

**Code Example:**
```typescript
// ❌ AVOID: Requires separate refs for each parameter
const useCircleStyle = ({
  cxRef,
  cyRef,
  rRef
}: {
  cxRef: Ref<number>,
  cyRef: Ref<number>,
  rRef: Ref<number>
}) => {
  const circleStyle = computed(() => {
    return `
      cx: ${cxRef.value}px;
      cy: ${cyRef.value}px;
      r: ${rRef.value}px;
    `;
  });

  return { circleStyle }
}

// ✅ BETTER: Flexible parameter handling
import { MaybeRefOrGetter, toValue, computed } from 'vue'

const useCircleStyle = (
  cx: MaybeRefOrGetter<number>,
  cy: MaybeRefOrGetter<number>,
  r: MaybeRefOrGetter<number>
) => {
  const circleStyle = computed(() => {
    return `
      cx: ${toValue(cx)}px;
      cy: ${toValue(cy)}px;
      r: ${toValue(r)}px;
    `;
  });

  return { circleStyle }
}

// Works with both:
const a = useCircleStyle(10, 20, 4) // Static values
const b = useCircleStyle(ref(10), ref(20), ref(4)) // Reactive refs
```

**Key Insight from Stack Overflow:**
> "Destructuring is mostly breaking reactivity. Use `toValue()` to normalize values and make composables accept both ref and non-ref."

**Pros:**
- Accepts both reactive and non-reactive values
- Less boilerplate (no need to create refs for every parameter)
- Easier to consolidate parameters
- More flexible API

**Cons:**
- Slightly less explicit about reactivity
- Need to remember `toValue()` inside computed/watchers

### Pattern 3: Options Object Pattern (Consolidating Parameters)

**Source:** "Options Object Pattern" - Michael Thiessen - Mar 2023
**Link:** https://michaelnthiessen.com/options-object-pattern

**Description:**
When composables have 3+ parameters, consolidate them into a single options object. Reduces prop drilling and makes future parameter additions non-breaking.

**Code Example:**
```typescript
// ❌ AVOID: Too many separate parameters
const useCircleStyle = (
  cx: number,
  cy: number,
  r: number,
  size: number,
  color: string,
  opacity: number
) => { /* ... */ }

// ✅ BETTER: Consolidated options object
const useCircleStyle = (options: {
  cx: number,
  cy: number,
  r: number,
  size?: number,
  color?: string,
  opacity?: number
}) => {
  const { cx, cy, r, size = 10, color = 'blue', opacity = 1 } = options

  const circleStyle = computed(() => ({
    cx: `${cx}px`,
    cy: `${cy}px`,
    r: `${r}px`,
    size: `${size}px`,
    color,
    opacity
  }))

  return { circleStyle }
}

// Usage
const { circleStyle } = useCircleStyle({
  cx: props.cx,
  cy: props.cy,
  r: props.r,
  color: 'red'
})
```

**Pros:**
- Easier to add parameters without breaking API
- Self-documenting (named parameters)
- Easy to provide defaults
- Consolidates related parameters

**Cons:**
- Slightly more verbose for simple cases (< 3 parameters)
- Need to destructure or access via object

**When to Use:**
- 3+ parameters
- Parameters are conceptually related (e.g., circle properties)
- Anticipate adding more parameters in future

### Pattern 4: Provider/Consumer Pattern (for Global State)

**Source:** "Design Patterns with Composition API in Vue 3" - Medium - Dec 2024
**Link:** https://medium.com/@davisaac8/design-patterns-and-best-practices-with-the-composition-api-in-vue-3-77ba95cb4d63

**Description:**
Consolidate global state using provide/inject instead of creating multiple separate composables. Good for app-level state that needs to be accessed across many components.

**Code Example:**
```typescript
// theme.js - Consolidated theme state
import { ref, provide, inject } from 'vue'

const ThemeSymbol = Symbol('theme')

export function provideTheme() {
  const theme = ref('light')

  function toggleTheme() {
    theme.value = theme.value === 'light' ? 'dark' : 'light'
  }

  provide(ThemeSymbol, { theme, toggleTheme })

  return { theme, toggleTheme }
}

export function useTheme() {
  const theme = inject(ThemeSymbol)

  if (!theme) {
    throw new Error('useTheme must be used within a component that provides theme')
  }

  return theme
}

// App.vue - Provide at root
<script setup>
import { provideTheme } from './composables/theme'

const { theme, toggleTheme } = provideTheme()
</script>

// AnyComponent.vue - Inject anywhere
<script setup>
import { useTheme } from './composables/theme'

const { theme } = useTheme()
</script>
```

**Pros:**
- Avoids prop drilling
- Centralized state management for simple use cases
- No need for Pinia/Vuex for small-scale state
- Easy to consolidate related app-level state

**Cons:**
- Tight coupling between provider and consumers
- Harder to debug (implicit dependency)
- Not suitable for complex state management

## Real-World Gotchas

### Gotcha 1: Destructuring Breaks Reactivity

**Problem:**
Developers consolidate composables but lose reactivity by destructuring props before passing to composables.

**Why it happens:**
Vue 3.4 and below: Destructured props are **not reactive** (they become static values).
Vue 3.5+: Compiler auto-prepends `props.` for destructured variables in same `<script setup>` block, but this can be confusing.

**Solution:**
```typescript
// ❌ AVOID: Destructuring breaks reactivity
const { cx, cy, r } = defineProps({
  cx: Number,
  cy: Number,
  r: Number
})

const { circleStyle } = useCircleStyle(cx, cy, r) // Static values!

// ✅ BETTER: Pass props directly
const props = defineProps({
  cx: Number,
  cy: Number,
  r: Number
})

const { circleStyle } = useCircleStyle(
  () => props.cx, // Getter function
  () => props.cy,
  () => props.r
)

// OR use toRef
const { circleStyle } = useCircleStyle(
  toRef(() => props.cx),
  toRef(() => props.cy),
  toRef(() => props.r)
)
```

**Source:** Stack Overflow answer with 2 upvotes - Mar 2025

**Key Insight:**
> "Vue's reactivity tracks usage when property is actually read via Proxy. Destructuring extracts the value immediately, breaking the Proxy chain."

### Gotcha 2: Large Composables = Difficult Reset Logic

**Problem:**
Consolidating too much state into one composable makes `$reset()` methods (for Setup stores) very long and error-prone.

**Why it happens:**
Setup stores (Pinia) don't have built-in `$reset()` like Options stores. If you consolidate many properties into one store, manually resetting them all is tedious.

**Solution:**
```typescript
// ❌ AVOID: Large consolidated store with manual reset
export const useUserStore = defineStore('user', () => {
  const username = ref(INITIAL_STATE.username)
  const email = ref(INITIAL_STATE.email)
  const preferences = ref(INITIAL_STATE.preferences)
  const subscriptions = ref(INITIAL_STATE.subscriptions)
  const notifications = ref(INITIAL_STATE.notifications)
  // ... 20 more properties

  function $reset() {
    // Manual reset for every property - error-prone!
    username.value = INITIAL_STATE.username
    email.value = INITIAL_STATE.email
    preferences.value = INITIAL_STATE.preferences
    subscriptions.value = INITIAL_STATE.subscriptions
    notifications.value = INITIAL_STATE.notifications
    // ... 20 more lines
  }

  return { username, email, /* ... */, $reset }
})

// ✅ BETTER: Split into smaller stores
export const useUserStore = defineStore('user', () => {
  const username = ref(INITIAL_STATE.username)
  const email = ref(INITIAL_STATE.email)

  function $reset() {
    username.value = INITIAL_STATE.username
    email.value = INITIAL_STATE.email
  }

  return { username, email, $reset }
})

export const useUserPreferencesStore = defineStore('userPreferences', () => {
  const preferences = ref(INITIAL_STATE.preferences)

  function $reset() {
    preferences.value = INITIAL_STATE.preferences
  }

  return { preferences, $reset }
})
```

**Source:** "What I learned from migrating from Vuex to Pinia" - Piccalil.li - Feb 2025
**Link:** https://piccalil.li/blog/what-i-learned-from-migrating-a-vue-project-from-vuex-to-pinia/

**Key Insight:**
> "Keep stores small and modular. If your `$reset` method is > 10 lines, you've consolidated too much."

### Gotcha 3: Over-Abstraction (The Paradox of Abstraction)

**Problem:**
Developers consolidate composables prematurely, creating abstractions that are harder to understand and maintain than the original code.

**Why it happens:**
"I felt like a freaking genius. My code had transcended bits and bytes." - Michael Thiessen

Consolidating for the sake of "clean code" without actual reuse or simplification.

**Solution:**
Follow the **Rule of Three**: Don't consolidate until you have **three actual use cases** for the abstraction.

**Source:** "The Paradox of Abstraction: When Good Code is Bad Code" - Michael Thiessen - May 2019
**Link:** https://michaelnthiessen.com/paradox-of-abstraction

**When to Consolidate:**
- ✅ Logic is used in 3+ places
- ✅ Related state AND lifecycle
- ✅ Consolidation makes code **simpler** to understand

**When NOT to Consolidate:**
- ❌ "Might be reusable someday"
- ❌ Making code "cleaner" for its own sake
- ❌ Creates more complexity than it removes

## Performance Considerations

### Insight 1: Composables Are Called on Every Component Instantiation

**Source:** Vue docs + community consensus

Each time a component using a composable is created, the composable function runs. Large consolidated composables with expensive operations (e.g., large initial state) can impact performance if the component is rendered many times.

**Recommendation:**
- Lazy-initialize expensive state
- Use `computed()` for derived state (cached)
- Split composables if only subset of logic is needed in different components

### Insight 2: Reactivity Overhead

**Source:** Community experience (Dev.to articles)

Consolidating too many reactive refs/reactives into one composable increases reactivity overhead. Vue tracks every reactive property, so 100 refs in one composable = 100 tracked dependencies.

**Recommendation:**
- Group related state that changes together
- Use `shallowRef()` or `shallowReactive()` for large objects that change wholesale
- Avoid consolidating unrelated reactive state

## Compatibility Notes

### Vue 3.4 vs Vue 3.5: Destructuring Behavior

**Vue 3.4 and below:**
Destructured props are **not reactive** unless explicitly wrapped with `toRef()` or getter functions.

**Vue 3.5+:**
Compiler auto-prepends `props.` when code in same `<script setup>` block accesses destructured variables from `defineProps()`.

**Migration Advice:**
If consolidating composables in a Vue 3.4 project that will upgrade to 3.5, be explicit about reactivity (use getter functions or `toRef()`) to avoid surprises.

**Source:** Vue docs + Stack Overflow discussion (Mar 2025)

### Pinia Options Stores vs Setup Stores

**Options Stores:**
- Built-in `$reset()` method
- Easier to migrate from Vuex
- Less composable with other stores

**Setup Stores:**
- More composable (can import other stores)
- More flexible
- No built-in `$reset()` (manual implementation)

**Community Consensus (Piccalil.li):**
"My preference is now to default to Setup stores, with the very big caveat that stores are kept deliberately small."

## Community Recommendations

### Highly Recommended:

1. **Start with Inline Composables** - Extract Function pattern within components before creating separate files (alexop.dev, Michael Thiessen)

2. **Use `MaybeRefOrGetter` + `toValue()`** - Flexible parameter handling reduces need for multiple wrapper composables (Stack Overflow, Vue docs)

3. **Keep Composables Small** - Single responsibility, < 100 lines, easy to test in isolation (Michael Thiessen, Piccalil.li)

4. **Options Object for 3+ Parameters** - Consolidate related parameters into single object (Michael Thiessen, VueUse patterns)

5. **Test Composables in Isolation** - Use `mount()` or `withSetup()` test utilities (alexop.dev article)

### Avoid:

1. **Premature Consolidation** - Don't consolidate until you have 3 real use cases (Michael Thiessen)

2. **Destructuring Props** - Pass `props` object or use getter functions to maintain reactivity (Stack Overflow consensus)

3. **Large Monolithic Composables** - If > 100 lines or > 10 state properties, split it (Piccalil.li, community)

4. **Over-Abstracting** - "The Composition API can lead to cluttered components full of mixed concerns if you're not careful" (Michael Thiessen)

## Alternative Approaches

### Approach 1: Inline Composables (Stay in Component)

**When to use:**
- Logic specific to one component
- Not ready for extraction
- Improving readability without file overhead

**Source:** alexop.dev, Michael Thiessen

**Trade-off:** Not reusable, but simpler and faster to implement.

### Approach 2: Composable Libraries (VueUse Pattern)

**When to use:**
- Need highly reusable, generic utilities
- Want battle-tested implementations
- Building a design system or component library

**Source:** VueUse codebase, Michael Thiessen patterns

**Trade-off:** More upfront work, but scales across many projects.

### Approach 3: Hybrid (Small Composables + Composition)

**When to use:**
- Medium-to-large apps
- Some logic is component-specific, some shared
- Want flexibility without over-engineering

**Source:** Piccalil.li migration case study

**Trade-off:** Requires discipline to keep composables small and well-organized.

**Example:**
```
composables/
  ├─ inline/ (component-specific, not extracted)
  ├─ shared/ (reusable across components)
  │   ├─ useAuth.ts
  │   ├─ useFetch.ts
  └─ app/ (app-level state, provide/inject)
      └─ useTheme.ts
```

## Useful Tools & Libraries

- **VueUse** - Collection of essential Vue composition utilities (https://vueuse.org/)
  Demonstrates best practices for composable design, including parameter consolidation.

- **Pinia** - Official Vue state management (https://pinia.vuejs.org/)
  Setup stores show how to compose multiple stores together.

- **Vitest** - Testing framework for composables (https://vitest.dev/)
  Use `mount()` from `@vue/test-utils` or custom `withSetup()` helper to test composables in isolation.

## References

### Articles & Tutorials

- [The Inline Vue Composables Refactoring pattern](https://alexop.dev/posts/inline-vue-composables-refactoring/) - alexop.dev - Apr 2025
- [Composable Design Patterns in Vue](https://michaelnthiessen.com/composable-patterns-in-vue) - Michael Thiessen - Dec 2024
- [Design Patterns with Composition API in Vue 3](https://medium.com/@davisaac8/design-patterns-and-best-practices-with-the-composition-api-in-vue-3-77ba95cb4d63) - Medium - Dec 2024
- [Options Object Pattern](https://michaelnthiessen.com/options-object-pattern) - Michael Thiessen - Mar 2023
- [The Paradox of Abstraction: When Good Code is Bad Code](https://michaelnthiessen.com/paradox-of-abstraction) - Michael Thiessen - May 2019
- [Understanding the Vue 3 Composition API](https://dev.to/jacobandrewsky/understanding-the-vue-3-composition-api-fa2) - Dev.to - 2024
- [Advanced Prototyping Techniques with Vue 3 Composition API](https://www.uxpin.com/studio/blog/advanced-prototyping-techniques-with-vue-3-composition-api/) - UXPin - 2024

### Stack Overflow

- [Best practices using composables with multiple parameters including reactivity](https://stackoverflow.com/questions/79511390/best-practices-using-composables-with-multiple-parameters-including-reactivity) - 242 views, accepted answer with 2 upvotes - Mar 2025
  - Key takeaway: Use `MaybeRefOrGetter` and `toValue()`, avoid destructuring

### Case Studies

- [What I learned from migrating from Vuex to Pinia](https://piccalil.li/blog/what-i-learned-from-migrating-a-vue-project-from-vuex-to-pinia/) - Piccalil.li - Feb 2025
  - Real-world migration experience
  - Key insight: "Keep stores small and modular" to avoid large reset methods

### Official Documentation

- [Vue 3 Composition API](https://vuejs.org/guide/extras/composition-api-faq.html) - Official Vue docs
- [Pinia Setup Stores](https://pinia.vuejs.org/core-concepts/#Setup-Stores) - Official Pinia docs
- [Martin Fowler's Extract Function](https://refactoring.com/catalog/extractFunction.html) - Foundational refactoring pattern

## Decision Framework

**Should I consolidate these composables?**

```
┌─ Are they used in 3+ places?
│  ├─ NO → Keep inline or separate
│  └─ YES ↓
│
├─ Do they share state AND lifecycle?
│  ├─ NO → Keep separate
│  └─ YES ↓
│
├─ Will consolidation make code simpler?
│  ├─ NO → Keep separate
│  └─ YES ↓
│
├─ Can you keep it < 100 lines?
│  ├─ NO → Split into smaller composables
│  └─ YES → ✅ CONSOLIDATE
```

**Final Recommendation:**

Start with **inline composables** (Extract Function pattern) within your component. Only extract to separate files when you have **3 actual reuse cases**. When you do consolidate, **keep composables small** (< 100 lines, single responsibility) and use **flexible parameter patterns** (`MaybeRefOrGetter`, options objects).

The community overwhelmingly favors **small, composable composables** over large, consolidated ones.