# Decision Framework

### Generic vs Union Type

| Scenario | Use Generic | Use Union |
|----------|-------------|-----------|
| Data list with type-safe selection | ✅ | ❌ |
| Success/error states | ❌ | ✅ |
| Type-safe emit handlers | ✅ | ❌ |
| Mutually exclusive props | ❌ | ✅ |
| Reusable across data types | ✅ | ❌ |
| Variant-based styling | ❌ | ✅ |

### When to Add Runtime Validation

Use Zod for runtime validation when:
- Props come from external APIs
- Type safety must extend to production
- Need descriptive error messages

```vue
<script setup lang="ts" generic="T extends z.ZodType">
import { z } from 'zod'

const props = defineProps<{
  schema: T
  data: z.infer<T>
}>()

// Runtime validation
const validated = computed(() => {
  const result = props.schema.safeParse(props.data)
  if (!result.success) {
    console.error('Validation failed:', result.error)
  }
  return result.success ? result.data : null
})
</script>
```
