# useMotionVariants

useMotionVariants is used to handle the [Variants](https://motion.vueuse.org/features/variants) state and selection.

## Parameters

### `variants`

A [Variants](https://motion.vueuse.org/features/variants#custom-variants) definition.

## Exposed

### `state`

The current variant data value as a computed.

### `variant`

A string reference that updates the state when changed.

#### Example

```ts
const variants: MotionVariants = {
  initial: {
    opacity: 0,
    y: 100,
  },
  enter: {
    opacity: 1,
    y: 0,
  },
}

const { variant, state } = useMotionVariants(variants)

variant.value = 'initial'

nextTick(() => (variant.value = 'enter'))
```
