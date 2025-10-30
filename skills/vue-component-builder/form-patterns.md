# Form Patterns

## Zod Validation Pattern

```vue
<script setup lang="ts">
import { z } from 'zod'
import { ref } from 'vue'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

type FormData = z.infer<typeof schema>

const form = ref<FormData>({ email: '', password: '' })
const errors = ref<Record<string, string[]>>({})

function validate() {
  const result = schema.safeParse(form.value)
  if (!result.success) {
    errors.value = result.error.flatten().fieldErrors
    return false
  }
  errors.value = {}
  return true
}
</script>
```

## Form Input Component

Reusable input with error display, dark mode, and accessibility.
