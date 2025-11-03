# useSSRWidth

Category: Browser

Export Size: 309 B

Last Changed: 2 months ago

Used to set a global viewport width which will be used when rendering SSR components that rely on the viewport width like `useMediaQuery` or `useBreakpoints`

## Usage

```ts
import { provideSSRWidth } from '@vueuse/core'

const app = createApp(App)

provideSSRWidth(500, app)
```

Or in the root component:

```vue
<script setup lang="ts">
import { provideSSRWidth } from '@vueuse/core'

provideSSRWidth(500)
</script>
```

To retrieve the provided value if you need it in a subcomponent:

```vue
<script setup lang="ts">
import { injectSSRWidth } from '@vueuse/core'

const width = injectSSRWidth()
</script>
```

## Type Declarations

```ts
export declare function injectSSRWidth(): number | undefined
export declare function provideSSRWidth(
  width: number | null,
  app?: App<unknown>,
): void
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useSSRWidth/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useSSRWidth/index.md)

## Changelog

### v13.6.0 on 7/28/2025
- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

### v12.1.0 on 12/22/2024
- feat: add optional support for SSR in useMediaQuery and useBreakpoints (#4317)
