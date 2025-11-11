# useStepper

**Category**: Utilities
**Export Size**: 392 B
**Last Changed**: 2 months ago

Provides helpers for building a multi-step wizard interface.

## Demo

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useStepper/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNVMtu2zAQ/ZUhF1pA0n2bFEXbBujQYcO2YBl0ZRMjWRIl+aAbhv/7KMlO0m5sFwsm+fgeyR55qHq79XgUjVLRFqZrhxad1yCYrFd55GweLXeST1oZBxdwS/yFl1xyh78LRwkB16gaaHBELLSbFVJgNMgwWAGzUCLqF6wmgeEVG82YYDrf0ymbsnJZKOkcoIDVP8jlz9fnzQ+BDUq3jkcoxuMbumSOEb6XWErf7NFsd+t4uyPMDRVKIW+k2FJ/thHnEkp1Ej7xGFZruIQrQJcrUNbuEDRIKh0z4TTtY19g1iEH19rbQ5ym6ZMx7JwGg/Gl51jAHa4TiP9MgLc6dxo+p2KBrsPamy+4dUzUuYDZtI1TQExuFJdO1ebF51IHMgrIVc8LaBuYDi7HGNChcAvQUkMpwY+jDgJTIKgGrAJ1JgTrlLbgDa9rNFzWQ+IKYqkD6ntHMaZ+Om8kVEzYvCH7mDMew1alDb1Ko8F7o5VF2+E7k2FsH6jyMnHcye6ENiSbjLSunptLzN7uQ6jExZVXnfUy64aWRpQPrp4XOhEsSn8Nw0ZijSKOoBDMWhpVA94hLUigBNVNJ19BJu9wSh6mU/0Oh/7bJMxTk9QRTSXUKTknJBUGfl8nNT1rMp9OszkY5WWJZfuXBGet7DEh36RF49XQi7QuqITFG5776KCgQzKb/5+U6nq4E9NMXKAlvJLwViojrc7rx27vnaNGPhYCF2/EPujoneolxLq8Dk7xZTbIXnT9C5NXV1k=)

**User information**
First name:
Last name:

**Form Data Example:**
```json
{
  "firstName": "Jon",
  "lastName": "",
  "billingAddress": "",
  "contractAccepted": false,
  "carbonOffsetting": false,
  "payment": "credit-card"
}
```

**Wizard State Example:**
```json
{
  "steps": {
    "user-information": { "title": "User information" },
    "billing-address": { "title": "Billing address" },
    "terms": { "title": "Terms" },
    "payment": { "title": "Payment" }
  },
  "stepNames": [ "user-information", "billing-address", "terms", "payment" ],
  "index": 0,
  "current": { "title": "User information" },
  "next": "billing-address",
  "isFirst": true,
  "isLast": false
}
```

## Usage

### Steps as array

```ts
import { useStepper } from '@vueuse/core'

const {
  steps,
  stepNames,
  index,
  current,
  next,
  previous,
  isFirst,
  isLast,
  goTo,
  goToNext,
  goToPrevious,
  goBackTo,
  isNext,
  isPrevious,
  isCurrent,
  isBefore,
  isAfter,
} = useStepper([
  'billing-address',
  'terms',
  'payment',
])

// Access the step through `current`
console.log(current.value) // 'billing-address'
```

### Steps as object

```ts
import { useStepper } from '@vueuse/core'

const {
  steps,
  stepNames,
  index,
  current,
  next,
  previous,
  isFirst,
  isLast,
  goTo,
  goToNext,
  goToPrevious,
  goBackTo,
  isNext,
  isPrevious,
  isCurrent,
  isBefore,
  isAfter,
} = useStepper({
  'user-information': { title: 'User information' },
  'billing-address': { title: 'Billing address' },
  'terms': { title: 'Terms' },
  'payment': { title: 'Payment' },
})

// Access the step object through `current`
console.log(current.value.title) // 'User information'
```

## Type Declarations

```ts
export interface UseStepperReturn<StepName, Steps, Step> {
  /** List of steps. */
  steps: Readonly<Ref<Steps>>
  /** List of step names. */
  stepNames: Readonly<Ref<StepName[]>>
  /** Index of the current step. */
  index: Ref<number>
  /** Current step. */
  current: ComputedRef<Step>
  /** Next step, or undefined if the current step is the last one. */
  next: ComputedRef<StepName | undefined>
  /** Previous step, or undefined if the current step is the first one. */
  previous: ComputedRef<StepName | undefined>
  /** Whether the current step is the first one. */
  isFirst: ComputedRef<boolean>
  /** Whether the current step is the last one. */
  isLast: ComputedRef<boolean>
  /** Get the step at the specified index. */
  at: (index: number) => Step | undefined
  /** Get a step by the specified name. */
  get: (step: StepName) => Step | undefined
  /** Go to the specified step. */
  goTo: (step: StepName) => void
  /** Go to the next step. Does nothing if the current step is the last one. */
  goToNext: () => void
  /** Go to the previous step. Does nothing if the current step is the previous one. */
  goToPrevious: () => void
  /** Go back to the given step, only if the current step is after. */
  goBackTo: (step: StepName) => void
  /** Checks whether the given step is the next step. */
  isNext: (step: StepName) => boolean
  /** Checks whether the given step is the previous step. */
  isPrevious: (step: StepName) => boolean
  /** Checks whether the given step is the current step. */
  isCurrent: (step: StepName) => boolean
  /** Checks if the current step is before the given step. */
  isBefore: (step: StepName) => boolean
  /** Checks if the current step is after the given step. */
  isAfter: (step: StepName) => boolean
}

export declare function useStepper<T extends string | number>(
  steps: MaybeRef<T[]>,
  initialStep?: T,
): UseStepperReturn<T, T[], T>

export declare function useStepper<T extends Record<string, any>>(
  steps: MaybeRef<T>,
  initialStep?: keyof T,
): UseStepperReturn<Exclude<keyof T, symbol>, T, T[keyof T]>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useStepper/index.ts) • [Demo](https://vueuse.org/core/useStepper/#demo) • [Docs](https://vueuse.org/core/useStepper/)

## Contributors

* Anthony Fu
* SerKo
* IlyaL
* Jelle Roorda
* Ostap Brehin
* sun0day
* Enzo Innocenzi

## Changelog

*   **v13.6.0** on 7/28/2025
    *   `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
*   **v12.8.0** on 3/5/2025
    *   `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
*   **v12.0.0-beta.1** on 11/21/2024
    *   `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
