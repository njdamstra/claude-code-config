# Examples

### Example 1: Fixing Prop Drilling in Account Selection

**Before (Prop Drilling):**
```vue
<!-- Parent.vue -->
<MultiProviderCard
  :team-id="teamId"
  :oauth-accounts="accounts"
  :allow-selection="true"
  :disable-add-new="false"
  :disable-disconnect="false"
/>

<!-- MultiProviderCard.vue (passes through) -->
<ProviderCard
  :team-id="teamId"
  :oauth-accounts="accounts"
  :allow-selection="allowSelection"
  :disable-add-new="disableAddNew"
  :disable-disconnect="disableDisconnect"
/>

<!-- ProviderCard.vue (finally uses) -->
<div>{{ teamId }}</div>
```

**After (Provide/Inject):**
```vue
<!-- Parent.vue -->
<script setup lang="ts">
import { provide } from 'vue'

const accountConfig = {
  teamId: props.teamId,
  allowSelection: true,
  disableAddNew: false,
  disableDisconnect: false
}

provide('account-config', accountConfig)
</script>

<template>
  <MultiProviderCard :accounts="accounts" />
</template>

<!-- ProviderCard.vue (injects directly) -->
<script setup lang="ts">
const config = inject<AccountConfig>('account-config')
</script>

<template>
  <div>{{ config.teamId }}</div>
</template>
```

**Result:** Eliminated 7 props drilling through 2 levels.

### Example 2: Compound Component for Onboarding Steps

**Problem:** Onboarding flow has 10 steps, each needs access to flow state, but passing via props is verbose.

**Solution:**
```vue
<!-- OnboardingFlow.vue (Root) -->
<script setup lang="ts">
import { provide, ref, computed } from 'vue'

interface OnboardingContext {
  currentStep: Ref<number>
  totalSteps: number
  data: Ref<OnboardingData>
  goToStep: (step: number) => void
  nextStep: () => void
  previousStep: () => void
  update: (updates: Partial<OnboardingData>) => void
}

const OnboardingKey = Symbol() as InjectionKey<OnboardingContext>

const currentStep = ref(1)
const totalSteps = 10
const data = ref<OnboardingData>({})

provide(OnboardingKey, {
  currentStep,
  totalSteps,
  data,
  goToStep: (step) => currentStep.value = step,
  nextStep: () => currentStep.value++,
  previousStep: () => currentStep.value--,
  update: (updates) => Object.assign(data.value, updates)
})
</script>

<template>
  <div>
    <component :is="currentStepComponent" />
  </div>
</template>
```

```vue
<!-- StepOne.vue (Consumer) -->
<script setup lang="ts">
const onboarding = inject(OnboardingKey)

function handleSubmit() {
  onboarding.update({ describesYou: selectedOption.value })
  onboarding.nextStep()
}
</script>

<template>
  <div>
    <h1>Step {{ onboarding.currentStep }} of {{ onboarding.totalSteps }}</h1>
    <!-- Form content -->
    <button @click="handleSubmit">Next</button>
  </div>
</template>
```

### Example 3: Headless Dialog with asChild

**Design system requirement:** Dialog behavior (focus trap, ESC close, backdrop) with full styling control.

```vue
<!-- DialogRoot.vue (Headless) -->
<script setup lang="ts">
import { provide, ref } from 'vue'

const DialogKey = Symbol() as InjectionKey<{
  isOpen: Ref<boolean>
  open: () => void
  close: () => void
}>()

const isOpen = ref(false)

provide(DialogKey, {
  isOpen,
  open: () => isOpen.value = true,
  close: () => isOpen.value = false
})
</script>

<template>
  <div><slot /></div>
</template>
```

```vue
<!-- DialogTrigger.vue -->
<script setup lang="ts">
import { inject } from 'vue'
import Primitive from './Primitive.vue'

const dialog = inject(DialogKey)
</script>

<template>
  <Primitive as-child @click="dialog.open">
    <slot />
  </Primitive>
</template>
```

**Usage:**
```vue
<DialogRoot>
  <DialogTrigger as-child>
    <button class="btn-primary">Open Dialog</button>
  </DialogTrigger>
  <DialogContent class="modal-overlay">
    <div class="modal-card">
      <h2>Title</h2>
      <p>Content</p>
    </div>
  </DialogContent>
</DialogRoot>
```

**Result:** Single `<button>` with dialog behavior, no wrapper divs, full styling control.
