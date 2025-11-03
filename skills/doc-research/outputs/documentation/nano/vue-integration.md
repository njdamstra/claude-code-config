# Nanostores Vue Integration

This document explains how to integrate Nanostores with Vue.

## useStore

The `useStore` hook is the primary way to connect Nanostores to your Vue components. It subscribes to the store and returns a reactive `ref` that will be updated when the store changes.

### Usage

```vue
<script setup>
import { useStore } from '@nanostores/vue';
import { isAuthenticated } from './stores/auth';

const $isAuthenticated = useStore(isAuthenticated);
</script>

<template>
  <div>
    <p v-if="$isAuthenticated">You are logged in.</p>
    <p v-else>You are logged out.</p>
  </div>
</template>
```

## mapStores

The `mapStores` helper combines multiple stores into a single reactive state.

### Usage

```vue
<script setup>
import { mapStores } from '@nanostores/vue';
import { user } from './stores/user';
import { cart } from './stores/cart';

const { user: $user, cart: $cart } = mapStores({ user, cart });
</script>
```
