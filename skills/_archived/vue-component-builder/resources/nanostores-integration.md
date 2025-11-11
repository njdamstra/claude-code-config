# Nanostores Integration
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $user, userStore } from '@/stores/user'
import { computed } from 'vue'

// Use store (reactive)
const user = useStore($user)

// Computed based on store
const displayName = computed(() => {
  return user.value?.name ?? 'Guest'
})

// Store methods
async function updateProfile(name: string) {
  if (user.value?.$id) {
    await userStore.updateProfile(user.value.$id, { name })
  }
}
</script>

<template>
  <div v-if="user" class="p-4 bg-white dark:bg-gray-800 rounded-lg">
    <p class="text-gray-900 dark:text-gray-100">
      Welcome, {{ displayName }}
    </p>
    <button
      @click="updateProfile('New Name')"
      class="mt-2 px-4 py-2 bg-blue-600 dark:bg-blue-500 text-white rounded-lg"
    >
      Update Profile
    </button>
  </div>
</template>
```
