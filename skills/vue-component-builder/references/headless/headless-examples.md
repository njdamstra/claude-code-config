# Examples

### Example 1: Simple Primitive

```vue
<!-- Button.vue - Renders as different elements -->
<script setup lang="ts">
interface Props {
  as?: 'button' | 'a' | 'div'
  variant?: 'primary' | 'secondary'
}

const props = withDefaults(defineProps<Props>(), {
  as: 'button',
  variant: 'primary'
})
</script>

<template>
  <component
    :is="as"
    :class="['btn', `btn-${variant}`]"
    v-bind="$attrs"
  >
    <slot />
  </component>
</template>

<!-- Usage -->
<Button as="a" href="/home">Go Home</Button>
<Button as="button" @click="handleClick">Submit</Button>
```

### Example 2: Complete Accordion

```vue
<!-- Usage -->
<template>
  <AccordionRoot type="single" collapsible>
    <AccordionItem value="item-1">
      <AccordionTrigger>What is headless UI?</AccordionTrigger>
      <AccordionContent>
        Headless UI separates behavior from presentation...
      </AccordionContent>
    </AccordionItem>

    <AccordionItem value="item-2">
      <AccordionTrigger>Why use compound components?</AccordionTrigger>
      <AccordionContent>
        Compound components coordinate through shared context...
      </AccordionContent>
    </AccordionItem>
  </AccordionRoot>
</template>
```

### Example 3: Dialog with asChild

```vue
<template>
  <DialogRoot>
    <!-- asChild: Button component receives dialog trigger behavior -->
    <DialogTrigger as-child>
      <Button variant="primary">Open Settings</Button>
    </DialogTrigger>

    <DialogPortal>
      <DialogOverlay class="dialog-overlay" />
      <DialogContent class="dialog-content">
        <DialogTitle>Settings</DialogTitle>
        <DialogDescription>
          Configure your preferences
        </DialogDescription>

        <!-- Your settings form -->

        <DialogClose as-child>
          <Button variant="secondary">Close</Button>
        </DialogClose>
      </DialogContent>
    </DialogPortal>
  </DialogRoot>
</template>
```

