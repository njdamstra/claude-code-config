# Pattern 2: asChild Composition

Eliminates extra DOM wrappers by merging props/behavior into child:

```vue
<script setup lang="ts">
import { DialogTrigger, TooltipRoot, TooltipTrigger } from 'reka-ui'
</script>

<template>
  <DialogRoot>
    <!-- asChild: DialogTrigger merges props into TooltipRoot -->
    <DialogTrigger as-child>
      <TooltipRoot>
        <!-- asChild: TooltipTrigger merges props into button -->
        <TooltipTrigger as-child>
          <button class="icon-btn">Open</button>
        </TooltipTrigger>
        <TooltipContent>Click to open dialog</TooltipContent>
      </TooltipRoot>
    </DialogTrigger>

    <DialogContent>Dialog content</DialogContent>
  </DialogRoot>
</template>
```

**Result:** Single `<button>` element with:
- DialogTrigger behavior (opens dialog)
- TooltipTrigger behavior (shows tooltip)
- Custom styles from `icon-btn`
- No wrapper divs
