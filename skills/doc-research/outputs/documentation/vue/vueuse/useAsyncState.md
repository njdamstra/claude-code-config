# useAsyncState

Category: State

Export Size: 931 B

Reactive async state. Will not block your setup function and will trigger changes once the promise is ready. The state is a `shallowRef` by default.

## Usage

```ts
import { useAsyncState } from '@vueuse/core'
import axios from 'axios'

const { state, isReady, isLoading } = useAsyncState(
  axios
    .get('https://jsonplaceholder.typicode.com/todos/1')
    .then(t => t.data),
  { id: null },
)
```

### Manually trigger the async function

You can also trigger it manually. This is useful when you want to control when the async function is executed.

```vue
<script setup lang="ts">
import { useAsyncState } from '@vueuse/core'

const { state, isReady, execute } = useAsyncState(onClick, '', { immediate: false })

async function onClick(event) {
  await new Promise(r => setTimeout(r, 500))
  return `${event.target.textContent} clicked!`
}
</script>

<template>
  <div>State: {{ state }}</div>

  <button type="button" @click="execute">
    Execute now
  </button>

  <button type="button" @click="e => execute(500, e)">
    Execute with delay
  </button>
</template>
```
