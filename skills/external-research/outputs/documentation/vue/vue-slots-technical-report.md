# Vue Slots Technical Documentation

Content distribution mechanism allowing parent components to inject template content into child component placeholders. Based on Web Components `<slot>` spec with Vue-specific enhancements.

## Core API Surface

### Default Slot

```vue
<!-- Child.vue -->
<template>
  <button class="btn">
    <slot></slot>
  </button>
</template>

<!-- Parent.vue -->
<template>
  <Child>Click Me</Child>
  <!-- Renders: <button class="btn">Click Me</button> -->
</template>
```

### Named Slots

```vue
<!-- Layout.vue -->
<template>
  <div class="container">
    <header>
      <slot name="header"></slot>
    </header>
    <main>
      <slot></slot> <!-- default slot -->
    </main>
    <footer>
      <slot name="footer"></slot>
    </footer>
  </div>
</template>

<!-- Parent.vue -->
<template>
  <Layout>
    <template #header>
      <h1>Page Title</h1>
    </template>
    
    <p>Main content goes in default slot</p>
    
    <template #footer>
      <p>Footer content</p>
    </template>
  </Layout>
</template>
```

**Syntax variants:**
- `v-slot:header` (full)
- `#header` (shorthand, preferred)

### Scoped Slots

Pass data from child to parent through slot props.

```vue
<!-- DataList.vue -->
<script setup lang="ts">
interface Item {
  id: number
  name: string
  price: number
}

const items = ref<Item[]>([
  { id: 1, name: 'Product A', price: 29.99 },
  { id: 2, name: 'Product B', price: 49.99 }
])
</script>

<template>
  <ul>
    <li v-for="item in items" :key="item.id">
      <!-- Expose item data to parent via slot props -->
      <slot :item="item" :index="item.id"></slot>
    </li>
  </ul>
</template>

<!-- Parent.vue -->
<template>
  <DataList>
    <!-- Destructure slot props -->
    <template #default="{ item, index }">
      <div class="product">
        <h3>{{ item.name }}</h3>
        <span>${{ item.price }}</span>
      </div>
    </template>
  </DataList>
</template>
```

### Fallback Content

```vue
<!-- Button.vue -->
<template>
  <button>
    <slot>Submit</slot> <!-- Default text if no content provided -->
  </button>
</template>

<!-- Usage -->
<Button /> <!-- Renders: Submit -->
<Button>Cancel</Button> <!-- Renders: Cancel -->
```

## TypeScript Integration

### defineSlots Macro (Vue 3.3+)

Type-safe slot declarations with IDE autocomplete.

```vue
<script setup lang="ts">
// Basic slot typing
defineSlots<{
  default?: (props: { msg: string }) => any
  header?: (props: { title: string }) => any
}>()

// Multiple props with destructuring support
defineSlots<{
  item: (props: {
    product: {
      id: number
      name: string
      price: number
    }
    selected: boolean
  }) => any
}>()
</script>

<template>
  <slot :msg="'Hello'" />
  <slot name="header" :title="pageTitle" />
  <slot name="item" :product="currentProduct" :selected="isSelected" />
</template>
```

**Key behaviors:**
- Only accepts type parameter (no runtime args)
- Return type currently ignored by compiler
- Returns `slots` object (same as `useSlots()`)
- Parent gets full IntelliSense when consuming

### Generic Components with Typed Slots

```vue
<script setup lang="ts" generic="T extends object">
interface Props {
  items: T[]
}

defineProps<Props>()

defineSlots<{
  item(props: { item: T; index: number }): any
  empty?(): any
}>()
</script>

<template>
  <div v-if="items.length">
    <div v-for="(item, i) in items" :key="i">
      <slot name="item" :item="item" :index="i" />
    </div>
  </div>
  <slot v-else name="empty" />
</template>
```

### Consumer-Side Typing

When parent needs explicit typing:

```vue
<script setup lang="ts">
import DataTable from './DataTable.vue'

interface User {
  id: number
  name: string
  email: string
}

// Type assertion for slot props
type SlotProps = { row: User }
</script>

<template>
  <DataTable :data="users">
    <template #row="props">
      <!-- Cast to get type safety -->
      {{ (props as SlotProps).row.name }}
    </template>
  </DataTable>
</template>
```

### Non-`<script setup>` Components

```ts
import { defineComponent, type SlotsType } from 'vue'

export default defineComponent({
  slots: Object as SlotsType<{
    default: (props: { msg: string }) => any
    header: () => any
  }>,
  setup(props, { slots }) {
    // slots.default is now typed
    return () => (
      <div>
        {slots.default?.({ msg: 'typed' })}
      </div>
    )
  }
})
```

## Advanced Patterns

### Dynamic Slot Names

```vue
<script setup lang="ts">
const slotName = ref<'primary' | 'secondary'>('primary')
</script>

<template>
  <Card>
    <template #[slotName]>
      Dynamic slot content
    </template>
  </Card>
</template>
```

### Conditional Slot Rendering

Check slot existence before rendering wrapper markup:

```vue
<script setup lang="ts">
import { useSlots } from 'vue'

const slots = useSlots()
</script>

<template>
  <!-- Only render header div if slot provided -->
  <div v-if="slots.header" class="header-wrapper">
    <slot name="header" />
  </div>
  
  <slot />
  
  <!-- Check with $slots in template -->
  <div v-if="$slots.footer" class="footer-wrapper">
    <slot name="footer" />
  </div>
</template>
```

### Renderless Components

Provide logic without markup:

```vue
<!-- FetchData.vue -->
<script setup lang="ts">
interface Props {
  url: string
}

const props = defineProps<Props>()

defineSlots<{
  default(props: {
    data: any
    loading: boolean
    error: Error | null
  }): any
}>()

const { data, loading, error } = useFetch(props.url)
</script>

<template>
  <slot :data="data" :loading="loading" :error="error" />
</template>

<!-- Usage -->
<template>
  <FetchData url="/api/users">
    <template #default="{ data, loading, error }">
      <div v-if="loading">Loading...</div>
      <div v-else-if="error">{{ error.message }}</div>
      <ul v-else>
        <li v-for="user in data" :key="user.id">
          {{ user.name }}
        </li>
      </ul>
    </template>
  </FetchData>
</template>
```

### Multiple Scoped Slots Pattern

```vue
<!-- ProductGrid.vue -->
<script setup lang="ts">
interface Product {
  id: number
  name: string
  price: number
  featured: boolean
}

const products = ref<Product[]>([...])

defineSlots<{
  featured?(props: { product: Product }): any
  regular(props: { product: Product; index: number }): any
  empty?(): any
}>()
</script>

<template>
  <div v-if="products.length">
    <div class="featured">
      <div v-for="p in products.filter(x => x.featured)" :key="p.id">
        <slot name="featured" :product="p" />
      </div>
    </div>
    <div class="grid">
      <div v-for="(p, i) in products.filter(x => !x.featured)" :key="p.id">
        <slot name="regular" :product="p" :index="i" />
      </div>
    </div>
  </div>
  <slot v-else name="empty" />
</template>
```

## Scope Rules

**Critical:** Slot content has access to **parent scope only**, not child scope.

```vue
<!-- Child.vue -->
<script setup lang="ts">
const childData = ref('Not accessible')
</script>

<template>
  <slot></slot>
</template>

<!-- Parent.vue -->
<script setup lang="ts">
const parentData = ref('Accessible')
</script>

<template>
  <Child>
    {{ parentData }} <!-- ✅ Works -->
    {{ childData }}  <!-- ❌ Undefined -->
  </Child>
</template>
```

**To access child data:** Use scoped slots

```vue
<!-- Child.vue -->
<template>
  <slot :child-data="childData"></slot>
</template>

<!-- Parent.vue -->
<template>
  <Child v-slot="{ childData }">
    {{ childData }} <!-- ✅ Now accessible -->
  </Child>
</template>
```

## Edge Cases & Gotchas

### 1. Default Slot Shorthand Scope Conflict

**Problem:** Cannot mix default slot shorthand with named slots

```vue
<!-- ❌ INVALID - Causes scope ambiguity -->
<MyList v-slot="props">
  {{ props.item }}
  <template #footer="footerProps">
    <!-- props NOT available here -->
  </template>
</MyList>

<!-- ✅ CORRECT - Explicit default slot -->
<MyList>
  <template #default="props">
    {{ props.item }}
  </template>
  <template #footer="footerProps">
    {{ footerProps.data }}
  </template>
</MyList>
```

### 2. Slot Name Casing in Components

Named slots must match exactly. Kebab-case in template requires kebab-case in definition:

```vue
<!-- Child.vue -->
<template>
  <slot name="user-profile"></slot> <!-- kebab-case -->
</template>

<!-- Parent - Both work -->
<template>
  <Child>
    <template #user-profile>...</template>
    <template v-slot:user-profile>...</template>
  </Child>
</template>
```

### 3. Slots in v-for

Slot props available per iteration:

```vue
<template>
  <div v-for="item in items" :key="item.id">
    <slot :item="item"></slot>
  </div>
</template>
```

**Anti-pattern:** Iterating over slot in parent loses reactivity

```vue
<!-- ❌ AVOID -->
<Child>
  <template #default="{ items }">
    <div v-for="item in items" :key="item.id">...</div>
  </template>
</Child>

<!-- ✅ PREFER - Let child handle iteration -->
<Child v-slot="{ item }">
  <div>{{ item.name }}</div>
</Child>
```

### 4. Fragment Slot Content

Vue 3 supports fragment roots. Multiple root elements in slots work without wrapper:

```vue
<template>
  <Modal>
    <h1>Title</h1>
    <p>Content</p>
    <button>Action</button>
    <!-- All three elements rendered without wrapper -->
  </Modal>
</template>
```

### 5. Slot with Components

Components can be slot content:

```vue
<template>
  <Card>
    <UserProfile :user="currentUser" />
    <ActionButtons />
  </Card>
</template>
```

### 6. $slots Reactivity

`$slots` object itself is not reactive. Check slot existence in computed or template expressions, not in reactive watch:

```vue
<script setup lang="ts">
import { useSlots, computed } from 'vue'

const slots = useSlots()

// ✅ CORRECT
const hasHeader = computed(() => !!slots.header)

// ❌ AVOID - Not reactive
const hasHeader = ref(!!slots.header)
</script>
```

### 7. Slot Content Hydration

When using `client:*` directives in Astro, slot content hydration can behave unexpectedly with Vue components.

### 8. TypeScript Generic Constraints

`defineSlots` with no generic doesn't work - requires `generic="T extends object"` workaround:

```vue
<!-- ❌ TypeScript error -->
<script setup lang="ts">
defineSlots<{
  foo(props: { a: boolean }): any
}>()
</script>

<!-- ✅ Works with generic -->
<script setup lang="ts" generic="T extends object">
defineSlots<{
  foo(props: { a: boolean }): any
}>()
</script>
```

## Astro + Vue Integration

### Named Slots in Astro Pages

**Critical Issue:** Astro slot syntax conflicts with Vue named slots when using Vue components directly in `.astro` files.

```astro
---
// ❌ PROBLEMATIC - Astro captures slots
import VueCard from './VueCard.vue'
---

<VueCard>
  <template #header>
    <h1>Title</h1>
  </template>
</VueCard>
<!-- Astro treats this as Astro slots, not Vue slots -->
```

**Workarounds:**

1. **Wrap in another Vue component:**
```vue
<!-- VueWrapper.vue -->
<template>
  <VueCard>
    <template #header>
      <slot name="header" />
    </template>
  </VueCard>
</template>
```

2. **Use Vue-to-Vue composition only:**
```astro
---
import VueParent from './VueParent.vue'
---

<VueParent client:load />
<!-- All slot handling happens within Vue ecosystem -->
```

### Scoped Slots in Astro

**Cannot access scoped slot props from Astro templates:**

```astro
---
import DataList from './DataList.vue'
---

<!-- ❌ DOES NOT WORK -->
<DataList>
  <template #default="{ item }">
    <div>{item.name}</div>
  </template>
</DataList>
```

**Solution:** Use props instead of scoped slots when crossing Astro/Vue boundary:

```vue
<!-- DataList.vue -->
<script setup lang="ts">
defineProps<{
  renderItem?: (item: any) => string
}>()
</script>

<template>
  <div v-if="renderItem">
    <div v-for="item in items" :key="item.id" v-html="renderItem(item)" />
  </div>
  <div v-else>
    <slot :item="item" />
  </div>
</template>
```

### SSR Slot Rendering

In Astro SSR context, Vue slots are converted to `h()` render functions:

```ts
// Internal: Astro's Vue renderer
const slots = {}
for (const [key, value] of Object.entries(slotted)) {
  slots[key] = () => h(StaticHtml, { 
    value, 
    name: key === 'default' ? undefined : key 
  })
}
```

Slot content is static HTML at SSR time. Dynamic Vue reactivity requires `client:*` directive.

## Performance Considerations

### 1. Slot Compilation

Slots compile to functions. Parent re-renders trigger slot re-execution:

```vue
<Child>
  <ExpensiveComponent /> <!-- Re-renders with parent -->
</Child>
```

**Optimization:** Memoize expensive slot content with `v-memo`:

```vue
<Child>
  <div v-memo="[data.id]">
    <ExpensiveComponent :data="data" />
  </div>
</Child>
```

### 2. Conditional Slots

Check slot existence before rendering wrapper elements:

```vue
<!-- ❌ SUBOPTIMAL - Empty div always rendered -->
<div class="header">
  <slot name="header" />
</div>

<!-- ✅ OPTIMAL -->
<div v-if="$slots.header" class="header">
  <slot name="header" />
</div>
```

### 3. Scoped Slot Function Calls

Scoped slots are functions called on each render. Avoid complex computations in slot props:

```vue
<!-- ❌ AVOID - Computation runs every render -->
<template>
  <slot :computed-value="expensiveComputation(item)" />
</template>

<!-- ✅ PREFER - Memoize with computed -->
<script setup lang="ts">
const computedValue = computed(() => expensiveComputation(item.value))
</script>

<template>
  <slot :computed-value="computedValue" />
</template>
```

## Testing Patterns

```ts
// Component.test.ts
import { mount } from '@vue/test-utils'
import CardComponent from './Card.vue'

describe('Card slots', () => {
  it('renders default slot content', () => {
    const wrapper = mount(CardComponent, {
      slots: {
        default: '<p>Slot content</p>'
      }
    })
    expect(wrapper.html()).toContain('Slot content')
  })

  it('renders named slots', () => {
    const wrapper = mount(CardComponent, {
      slots: {
        header: '<h1>Header</h1>',
        footer: '<div>Footer</div>'
      }
    })
    expect(wrapper.html()).toContain('Header')
    expect(wrapper.html()).toContain('Footer')
  })

  it('passes scoped slot props', () => {
    const wrapper = mount(DataList, {
      slots: {
        default: `
          <template #default="{ item }">
            <div>{{ item.name }}</div>
          </template>
        `
      }
    })
    // Use wrapper.findComponent() to test slot prop data
  })

  it('renders fallback when no slot provided', () => {
    const wrapper = mount(CardComponent)
    expect(wrapper.html()).toContain('Default Content')
  })
})
```

## Common Anti-Patterns

### ❌ Passing Render Props (React-style)

```vue
<!-- DOES NOT WORK -->
<DataTable :render-row="(row) => <div>{row.name}</div>" />
```

Astro components render to static HTML. Cannot pass runtime functions.

**Use scoped slots instead:**

```vue
<DataTable>
  <template #row="{ row }">
    <div>{{ row.name }}</div>
  </template>
</DataTable>
```

### ❌ Accessing Child State Without Scoped Slots

```vue
<!-- Parent tries to access child's internal state -->
<Child>
  {{ childInternalData }} <!-- Undefined -->
</Child>
```

**Must expose via scoped slot:**

```vue
<Child v-slot="{ childData }">
  {{ childData }}
</Child>
```

### ❌ Over-Nesting Scoped Slots

```vue
<!-- VERBOSE -->
<Outer>
  <template #default="{ outerData }">
    <Middle>
      <template #default="{ middleData }">
        <Inner>
          <template #default="{ innerData }">
            {{ outerData }} {{ middleData }} {{ innerData }}
          </template>
        </Inner>
      </template>
    </Middle>
  </template>
</Outer>
```

**Consider prop drilling or provide/inject for deeply nested data:**

```vue
<!-- Outer.vue -->
<script setup lang="ts">
provide('outerData', outerData)
</script>

<!-- Deep child -->
<script setup lang="ts">
const outerData = inject('outerData')
</script>
```

### ❌ Dynamic Slot Names Without Key

```vue
<!-- Missing :key causes render issues -->
<div v-for="name in slotNames">
  <slot :name="name" />
</div>

<!-- ✅ CORRECT -->
<div v-for="name in slotNames" :key="name">
  <slot :name="name" />
</div>
```

## Integration with Tech Stack

### With @headlessui/vue

```vue
<script setup lang="ts">
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
</script>

<template>
  <Menu>
    <!-- Headless UI uses scoped slots heavily -->
    <MenuButton>
      Options
    </MenuButton>
    <MenuItems>
      <MenuItem v-slot="{ active }">
        <button :class="{ 'bg-blue-500': active }">
          Edit
        </button>
      </MenuItem>
    </MenuItems>
  </Menu>
</template>
```

### With Nanostores

Slots receive reactive data from atoms:

```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $user } from '@/stores/user'

const user = useStore($user)
</script>

<template>
  <Card>
    <template #header>
      <h1>{{ user.name }}</h1>
    </template>
    
    <slot :user="user" />
  </Card>
</template>
```

### With @floating-ui/vue

```vue
<script setup lang="ts">
import { useFloating } from '@floating-ui/vue'

const { floatingStyles } = useFloating(reference, floating)

defineSlots<{
  default(props: { styles: typeof floatingStyles.value }): any
}>()
</script>

<template>
  <div ref="reference">
    <button>Trigger</button>
  </div>
  
  <div ref="floating" :style="floatingStyles">
    <slot :styles="floatingStyles" />
  </div>
</template>
```

## Debugging

### Inspecting Slots in DevTools

```vue
<script setup lang="ts">
import { useSlots, onMounted } from 'vue'

const slots = useSlots()

onMounted(() => {
  console.log('Available slots:', Object.keys(slots))
  console.log('Default slot:', slots.default?.())
})
</script>
```

### Type Checking Slot Props

Use `vue-tsc` for full slot type checking:

```bash
pnpm vue-tsc --noEmit
```

Enable in VSCode with Volar extension. Slot prop mismatches show as type errors.

### Render Function Debugging

Access compiled slot functions:

```vue
<script setup lang="ts">
import { getCurrentInstance } from 'vue'

const instance = getCurrentInstance()
console.log(instance?.slots)
// Shows: { default: Function, header: Function }
</script>
```

## Migration from Vue 2

### API Changes

| Vue 2 | Vue 3 |
|-------|-------|
| `this.$scopedSlots` | `this.$slots` (unified) |
| `this.$slots.header` | `this.$slots.header()` (function) |
| `slot` attribute | `v-slot` directive |
| `slot-scope` | Removed (use `v-slot`) |

### Slot Unification

Vue 3 unified normal and scoped slots:

```vue
<!-- Vue 2 -->
<script>
export default {
  mounted() {
    this.$slots.default // VNode[]
    this.$scopedSlots.default() // Function
  }
}
</script>

<!-- Vue 3 -->
<script setup lang="ts">
import { useSlots } from 'vue'

const slots = useSlots()
// All slots are functions now
slots.default?.()
</script>
```

### Render Function Migration

```ts
// Vue 2
h(Component, [
  h('div', { slot: 'header' }, 'Header'),
  h('div', { slot: 'footer' }, 'Footer')
])

// Vue 3
h(Component, {}, {
  header: () => h('div', 'Header'),
  footer: () => h('div', 'Footer')
})
```

## Version-Specific Behavior

### Vue 3.3+ (defineSlots)

- `defineSlots` macro available
- Type-only parameter
- Returns `slots` object

### Vue 3.5.17 (Current)

- Improved TypeScript inference
- Better generic component support with slots
- Enhanced IDE autocomplete for slot props

### Astro 5.13.7

- Slot conflict between Astro and Vue namespaces
- Scoped slots don't work across Astro/Vue boundary
- Prefer Vue-to-Vue composition for complex slot patterns

## Quick Reference

```vue
<!-- Slots Quick Reference -->
<template>
  <!-- Default slot -->
  <slot></slot>
  
  <!-- Named slot -->
  <slot name="header"></slot>
  
  <!-- Scoped slot -->
  <slot :item="data" :index="i"></slot>
  
  <!-- Fallback content -->
  <slot>Default</slot>
  
  <!-- Conditional slot -->
  <div v-if="$slots.header">
    <slot name="header" />
  </div>
  
  <!-- Dynamic slot name -->
  <slot :name="dynamicName"></slot>
</template>

<script setup lang="ts">
import { useSlots, computed } from 'vue'

// Type slots
defineSlots<{
  default?: (props: { msg: string }) => any
  header?: () => any
}>()

// Check slot existence
const slots = useSlots()
const hasHeader = computed(() => !!slots.header)
</script>

<!-- Usage -->
<Component>
  <template #default="{ msg }">{{ msg }}</template>
  <template #header>Header</template>
</Component>
```
