# appEntrypoint Configuration Guide

Complete guide to global Vue app configuration in Astro.

## What is appEntrypoint?

The `appEntrypoint` option extends the Vue app instance before rendering, enabling global configuration.

## Setup

```js
// astro.config.mjs
export default defineConfig({
  integrations: [vue({ appEntrypoint: '/src/pages/_app' })]
})
```

```ts
// src/pages/_app.ts
import type { App } from 'vue'

export default (app: App) => {
  // Global configuration here
}
```

## Common Use Cases

**See SKILL.md Section 3 for complete examples:**
- VueUse Motion plugin
- i18n configuration
- Global error handlers
- DevTools setup

## Best Practices

✅ Use for truly global plugins only
❌ Don't register many global components (hurts tree-shaking)
✅ Conditional logic for development vs production
❌ Don't initialize heavy dependencies here
