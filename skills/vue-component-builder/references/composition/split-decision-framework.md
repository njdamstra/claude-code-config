# When to Split Components/Composables

### Split Decision Framework

```
Does the component/composable have 2+ of these triggers?
├─ Size: 300+ lines
├─ SRP Violation: Handles 3+ unrelated concerns
├─ Reusability Mismatch: Parts used independently elsewhere
├─ Lifecycle Mismatch: Different parts need different hooks
├─ Testing Difficulty: Hard to test in isolation
└─ State Over-Lifting: State higher than needed

IF 2+ TRIGGERS → SPLIT
IF 1 TRIGGER → Consider organizing by sections
IF 0 TRIGGERS → Keep consolidated
```

### Split Triggers in Detail

**1. Size Violation (300+ lines)**
- Component `<script setup>` + `<template>` exceeds 300 lines
- Composable function body exceeds 300 lines
- Indicates multiple responsibilities

**2. SRP Violation (3+ unrelated concerns)**
- Handles data CRUD + navigation + validation + OAuth + billing
- Each concern = potential extraction candidate

**3. Reusability Mismatch**
- Part A used in 5 places, Part B only used here
- Extract Part A to reusable component/composable

**4. Lifecycle Mismatch**
- OAuth needs cleanup on unmount, navigation doesn't
- Split into separate composables with isolated lifecycles

**5. Testing Difficulty**
- Can't test data CRUD without OAuth logic interfering
- Split for independent testing

**6. State Over-Lifting**
- State lives in App.vue but only ProductList uses it
- Colocate state with ProductList component
