# useToggle

Category: Utilities

Export Size: 208 B

A boolean switcher with utility functions.

## Usage

```ts
import { useToggle } from '@vueuse/core'

const [value, toggle] = useToggle()
```

When you pass a ref, `useToggle` will return a simple toggle function instead:

```ts
import { useToggle, ref } from '@vueuse/core'

const value = ref()
const toggle = useToggle(value)
```

Note: be aware that the toggle function accepts the first argument as the override value. You might want to avoid directly passing the function to events in the template, as the event object will pass in.

```html
<!-- caution: $event will be pass in -->
<button @click="toggleDark" />
<!-- recommended to do this -->
<button @click="toggleDark()" />
```
