# Third-Party Library Integration

This codebase heavily relies on several third-party libraries. **ALWAYS use these patterns** when integrating them.

### Iconify (@iconify/vue) - 256+ Components Use This

**Standard Icon Pattern:**
```vue
<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { useMounted } from '@vueuse/core'

const mounted = useMounted()
</script>

<template>
  <!-- ALWAYS wrap icons in useMounted for SSR safety -->
  <template v-if="mounted">
    <Icon icon="mdi:home" class="w-6 h-6 text-blue-600 dark:text-blue-400" />
    <Icon icon="mdi:close" class="w-4 h-4" />
    <Icon icon="heroicons:user-circle-20-solid" />
  </template>
</template>
```

**Icon Collections Used:**
- `mdi:*` - Material Design Icons (most common)
- `heroicons:*` - Heroicons
- `lucide:*` - Lucide icons
- `ri:*` - Remix Icon

**Why useMounted Required:** Icon component uses browser APIs that crash during SSR.

---

### HeadlessUI (@headlessui/vue) - 11+ Components

**Accessible Modal Pattern:**
```vue
<script setup lang="ts">
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'

const open = defineModel<boolean>('open', { required: true })
</script>

<template>
  <TransitionRoot :show="open" as="template">
    <Dialog @close="open = false" class="relative z-50">
      <!-- Backdrop -->
      <TransitionChild
        as="template"
        enter="duration-300 ease-out"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="duration-200 ease-in"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-black/50 dark:bg-black/70" />
      </TransitionChild>

      <!-- Modal Panel -->
      <div class="fixed inset-0 flex items-center justify-center p-4">
        <TransitionChild
          as="template"
          enter="duration-300 ease-out"
          enter-from="opacity-0 scale-95"
          enter-to="opacity-100 scale-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100 scale-100"
          leave-to="opacity-0 scale-95"
        >
          <DialogPanel class="max-w-md w-full bg-white dark:bg-gray-800 rounded-lg p-6 shadow-xl">
            <DialogTitle class="text-xl font-bold text-gray-900 dark:text-gray-100 mb-4">
              Modal Title
            </DialogTitle>

            <div class="text-gray-700 dark:text-gray-300">
              <!-- Modal content -->
            </div>

            <div class="mt-6 flex justify-end space-x-3">
              <button
                @click="open = false"
                class="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-lg"
              >
                Cancel
              </button>
              <button
                class="px-4 py-2 bg-blue-600 dark:bg-blue-500 text-white rounded-lg"
              >
                Confirm
              </button>
            </div>
          </DialogPanel>
        </TransitionChild>
      </div>
    </Dialog>
  </TransitionRoot>
</template>
```

**Why HeadlessUI:**
- Accessible by default (ARIA attributes built-in)
- Keyboard navigation handled automatically
- Focus management included
- Screen reader compatible
- Unstyled (use Tailwind for styling)

---

### Floating UI (@floating-ui/vue) - 14+ Components

**Dropdown/Popover Positioning:**
```vue
<script setup lang="ts">
import { useFloating, offset, flip, shift } from '@floating-ui/vue'
import { ref } from 'vue'

const referenceRef = ref<HTMLElement>()
const floatingRef = ref<HTMLElement>()

const { floatingStyles } = useFloating(referenceRef, floatingRef, {
  placement: 'bottom-start',
  middleware: [
    offset(8), // 8px offset from trigger
    flip(), // Flip if not enough space
    shift({ padding: 8 }) // Shift to stay in viewport
  ]
})

const isOpen = ref(false)
</script>

<template>
  <div>
    <!-- Trigger -->
    <button
      ref="referenceRef"
      @click="isOpen = !isOpen"
      class="px-4 py-2 bg-blue-600 text-white rounded-lg"
    >
      Toggle Dropdown
    </button>

    <!-- Floating Content -->
    <div
      v-if="isOpen"
      ref="floatingRef"
      :style="floatingStyles"
      class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg shadow-lg p-2 z-50"
    >
      <!-- Dropdown items -->
      <button class="w-full text-left px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
        Option 1
      </button>
      <button class="w-full text-left px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
        Option 2
      </button>
    </div>
  </div>
</template>
```

**Common Middleware:**
- `offset(px)` - Space between trigger and floating element
- `flip()` - Flip to opposite side if no space
- `shift()` - Move horizontally to stay in viewport
- `arrow()` - Position arrow element
- `autoUpdate()` - Update position on scroll/resize

---

### ECharts (vue-echarts) - 15+ Chart Components

**Base Chart Pattern:**
```vue
<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useMounted, useWindowSize } from '@vueuse/core'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'

// Register ECharts components (tree-shakeable)
use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

const props = defineProps<{
  data: { x: string; y: number }[]
  title?: string
}>()

const mounted = useMounted()
const { width } = useWindowSize()
const chartRef = ref<InstanceType<typeof VChart>>()

// ECharts option object
const option = computed(() => ({
  title: {
    text: props.title,
    textStyle: {
      color: '#374151', // Update based on theme
    }
  },
  tooltip: {
    trigger: 'axis'
  },
  xAxis: {
    type: 'category',
    data: props.data.map(d => d.x)
  },
  yAxis: {
    type: 'value'
  },
  series: [{
    type: 'line',
    data: props.data.map(d => d.y),
    smooth: true
  }]
}))

// Resize chart on window resize
watch(width, () => {
  chartRef.value?.resize()
})

onMounted(() => {
  // Initial resize after mount
  setTimeout(() => chartRef.value?.resize(), 100)
})
</script>

<template>
  <div v-if="mounted" class="w-full h-full">
    <VChart
      ref="chartRef"
      :option="option"
      :autoresize="true"
      class="w-full h-full"
    />
  </div>
</template>
```

**Why ECharts:**
- Tree-shakeable (import only what you use)
- Responsive with `useWindowSize()` hook
- Dark mode support via theme configuration
- 15+ chart types (Line, Bar, Pie, etc.)

---

### When to Use Each Library

| Library | Use Case | SSR Safety |
|---------|----------|------------|
| **Iconify** | All icons in UI | ⚠️ Requires `useMounted()` |
| **HeadlessUI** | Modals, popovers, dropdowns, tabs | ✅ SSR-safe |
| **Floating UI** | Advanced positioning (tooltips, dropdowns) | ⚠️ Requires `useMounted()` |
| **ECharts** | Data visualization and charts | ⚠️ Requires `useMounted()` |
| **VueUse** | Composable utilities | ✅ Most are SSR-safe |

**Critical Rule:** Always check if a library needs `useMounted()` for SSR safety. If it accesses `window`, `document`, or `navigator`, wrap it.
