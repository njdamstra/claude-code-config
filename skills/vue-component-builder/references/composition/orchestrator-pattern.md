# Pattern 0: Orchestrator Pattern (Split Large Components)

### When to Use

- Component/composable exceeds 300 lines
- Handles 3+ unrelated concerns
- Parts have different reusability needs

### Component Splitting by Responsibility

#### Before: Monolithic Component (400+ lines)

```vue
<!-- UserProfile.vue - TOO LARGE -->
<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'

// User data state (100 lines)
const user = ref<User | null>(null)
const isLoading = ref(false)
const error = ref<string | null>(null)
async function fetchUser() { /* ... */ }

// Form state (80 lines)
const editMode = ref(false)
const form = ref({ name: '', email: '', bio: '' })
const formErrors = ref<Record<string, string>>({})
function validateForm() { /* ... */ }

// Avatar upload state (60 lines)
const uploadingAvatar = ref(false)
const avatarPreview = ref<string | null>(null)
async function uploadAvatar() { /* ... */ }

// Settings state (60 lines)
const settings = ref({ notifications: true, theme: 'light' })
function saveSettings() { /* ... */ }

// ... 100+ more lines
</script>

<template>
  <!-- 100+ lines of mixed UI -->
</template>
```

#### After: Split into Focused Components

```vue
<!-- UserProfile.vue - ORCHESTRATOR (50 lines) -->
<script setup lang="ts">
import UserProfileHeader from './UserProfileHeader.vue'
import UserProfileForm from './UserProfileForm.vue'
import UserAvatar from './UserAvatar.vue'
import UserSettings from './UserSettings.vue'

const props = defineProps<{ userId: string }>()

// Only coordination logic here
const { user, isLoading, error, refetch } = useUserData(props.userId)
</script>

<template>
  <div class="user-profile">
    <UserProfileHeader :user="user" :loading="isLoading" />
    <UserAvatar :user="user" @update="refetch" />
    <UserProfileForm :user="user" @save="handleSave" />
    <UserSettings :user="user" />
  </div>
</template>
```

```vue
<!-- UserProfileForm.vue - FOCUSED (80 lines) -->
<script setup lang="ts">
import { useFormValidation } from '@/composables/useFormValidation'

const props = defineProps<{ user: User }>()
const emit = defineEmits<{ save: [User] }>()

// Form-specific logic only
const { form, errors, validate } = useFormValidation(props.user)

async function handleSubmit() {
  if (await validate()) {
    emit('save', form.value)
  }
}
</script>

<template>
  <!-- Form UI only (40 lines) -->
</template>
```

**Split Criteria Met:**
- ✅ SRP: Each component has single responsibility
- ✅ Size: All components < 100 lines
- ✅ Reusability: UserAvatar reusable elsewhere
- ✅ Testing: Each component independently testable

### Composable Splitting by Concern

#### Before: Monolithic Composable (1675 lines)

```typescript
// useOnboardingFlow.ts - TOO LARGE
export function useOnboardingFlow() {
  // Data CRUD (200 lines)
  const onboarding = ref<Onboarding | null>(null)
  async function fetchOnboarding() { /* ... */ }
  async function updateOnboarding() { /* ... */ }

  // Navigation (150 lines)
  const currentStep = ref(1)
  function nextStep() { /* ... */ }
  function prevStep() { /* ... */ }

  // OAuth connections (300 lines)
  const connectedProviders = ref<Provider[]>([])
  async function connectProvider() { /* ... */ }

  // Billing/limits (250 lines)
  const limits = ref<Limits | null>(null)
  function checkLimit() { /* ... */ }

  // Validation (200 lines)
  const errors = ref<Record<string, string>>({})
  function validateStep() { /* ... */ }

  // ... 575+ more lines

  return {
    // 50+ exported properties/methods
  }
}
```

#### After: Split into Focused Composables

```typescript
// useOnboardingData.ts - DATA CRUD (150 lines)
export function useOnboardingData(userId: string) {
  const onboarding = ref<Onboarding | null>(null)
  const isLoading = ref(false)

  async function fetch() { /* ... */ }
  async function update(data: Partial<Onboarding>) { /* ... */ }

  return { onboarding, isLoading, fetch, update }
}
```

```typescript
// useOnboardingNavigation.ts - NAVIGATION (100 lines)
export function useOnboardingNavigation(totalSteps: number) {
  const currentStep = ref(1)

  const canGoNext = computed(() => currentStep.value < totalSteps)
  const canGoPrev = computed(() => currentStep.value > 1)

  function next() { if (canGoNext.value) currentStep.value++ }
  function prev() { if (canGoPrev.value) currentStep.value-- }
  function goTo(step: number) {
    if (step >= 1 && step <= totalSteps) {
      currentStep.value = step
    }
  }

  return { currentStep, canGoNext, canGoPrev, next, prev, goTo }
}
```

```typescript
// useOnboardingOAuth.ts - OAUTH (200 lines)
export function useOnboardingOAuth(userId: string) {
  const connectedProviders = ref<Provider[]>([])
  const isConnecting = ref(false)

  async function connect(provider: string) { /* ... */ }
  async function disconnect(providerId: string) { /* ... */ }

  return { connectedProviders, isConnecting, connect, disconnect }
}
```

#### Orchestrator Composable (Composition)

```typescript
// useOnboardingFlow.ts - ORCHESTRATOR (150 lines)
export function useOnboardingFlow(userId: string) {
  const totalSteps = 5

  // Compose focused composables
  const data = useOnboardingData(userId)
  const navigation = useOnboardingNavigation(totalSteps)
  const oauth = useOnboardingOAuth(userId)
  const validation = useOnboardingValidation()
  const billing = useOnboardingBilling(userId)

  // Orchestration logic only
  watchEffect(() => {
    if (navigation.currentStep === 3 && !oauth.connectedProviders.value.length) {
      // Show OAuth prompts
    }
  })

  async function handleNext() {
    const isValid = await validation.validateStep(
      navigation.currentStep,
      data.onboarding.value
    )

    if (isValid) {
      await data.update({ currentStep: navigation.currentStep + 1 })
      navigation.next()
    }
  }

  return {
    // Expose selected APIs from each composable
    ...data,
    ...navigation,
    ...oauth,
    validation: {
      errors: validation.errors,
      validateField: validation.validateField
    },
    billing,
    handleNext
  }
}
```

**Split Criteria Met:**
- ✅ SRP: Each composable has single responsibility
- ✅ Size: All composables < 200 lines
- ✅ Reusability: useOnboardingNavigation reusable for any stepper
- ✅ Testing: Each composable independently testable
- ✅ Lifecycle: OAuth cleanup in useOnboardingOAuth only
