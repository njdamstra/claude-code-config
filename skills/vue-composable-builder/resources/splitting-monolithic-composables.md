# Splitting Monolithic Composables

**When to split:** Composable exceeds 300 lines or handles multiple unrelated concerns.

### Split Strategy

**Before (Monolithic useOnboardingFlow - 1675 lines):**
```typescript
export function useOnboardingFlow() {
  // 50+ state properties
  // 30+ actions
  // 20+ getters
  // Navigation logic
  // OAuth logic
  // Billing logic
  // Validation logic
  // AI recommendations
}
```

**After (Split into focused composables):**

```typescript
// composables/onboarding/useOnboardingData.ts
export function useOnboardingData() {
  // ONLY data CRUD operations (~100 lines)
  const data = ref<OnboardingData>({})

  function update(updates: Partial<OnboardingData>) {
    Object.assign(data.value, updates)
  }

  return { data, update }
}

// composables/onboarding/useOnboardingNavigation.ts
export function useOnboardingNavigation() {
  // ONLY next/prev/goTo logic (~80 lines)
  const currentStep = ref(1)

  function nextStep() {
    currentStep.value++
  }

  function previousStep() {
    currentStep.value--
  }

  return { currentStep, nextStep, previousStep }
}

// composables/onboarding/useOnboardingOAuth.ts
export function useOnboardingOAuth() {
  // ONLY OAuth connection management (~150 lines)
  const connections = ref<OAuthConnection[]>([])

  async function connect(provider: string) {
    // OAuth logic
  }

  return { connections, connect }
}

// composables/onboarding/useOnboardingFlow.ts (Orchestrator)
export function useOnboardingFlow() {
  // Compose sub-composables (~50 lines)
  const { data, update } = useOnboardingData()
  const { currentStep, nextStep, previousStep } = useOnboardingNavigation()
  const { connections, connect } = useOnboardingOAuth()

  // Orchestration logic only
  return {
    data,
    update,
    currentStep,
    nextStep,
    previousStep,
    connections,
    connect
  }
}
```

**Benefits:**
- Each composable < 200 lines
- Single responsibility
- Easy to test in isolation
- Clear dependencies
