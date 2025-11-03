# Documentation Sitemap

Curated list of authoritative documentation sources for the tech stack.

## Framework Documentation

- **Astro**: https://docs.astro.build - Official SSR framework docs, routing, integrations, middleware, Cloudflare adapter
- **Astro Examples**: https://github.com/withastro/astro/tree/main/examples - Official example implementations
- **Vue 3 Guide**: https://vuejs.org/guide/ - Composition API, reactivity, lifecycle, components
- **Vue 3 API Reference**: https://vuejs.org/api/ - Complete API documentation
- **TypeScript Handbook**: https://www.typescriptlang.org/docs/handbook/ - Official TS documentation

## Astro Integrations

- **@astrojs/vue**: https://docs.astro.build/en/guides/integrations-guide/vue/ - Vue integration for Astro
- **@astrojs/cloudflare**: https://docs.astro.build/en/guides/integrations-guide/cloudflare/ - Cloudflare Pages adapter
- **@astrojs/sitemap**: https://docs.astro.build/en/guides/integrations-guide/sitemap/ - Sitemap generation
- **astrojs-service-worker**: https://github.com/tatethurston/astrojs-service-worker - PWA support for Astro

## State Management

- **Nanostores**: https://github.com/nanostores/nanostores - Core documentation and patterns
- **@nanostores/vue**: https://github.com/nanostores/vue - Vue 3 integration
- **@nanostores/persistent**: https://github.com/nanostores/persistent - Persistent storage
- **VueUse**: https://vueuse.org - Collection of Vue Composition utilities

## Styling

- **Tailwind CSS v4**: https://tailwindcss.com/docs - Official v4 documentation
- **@tailwindcss/vite**: https://tailwindcss.com/docs/installation/vite - Vite integration
- **Tailwind with Astro**: https://docs.astro.build/en/guides/styling/#tailwind - Astro-specific Tailwind setup
- **Tailwind CSS MCP**: Available via `mcp__tailwind-css__*` tools - Utilities, colors, config guides, component templates

## UI Components & Libraries

- **headlessui/vue**: https://headlessui.com - Unstyled, accessible UI components for Vue
- **floating-ui/vue**: https://floating-ui.com/docs/vue - Positioning library for tooltips, popovers, dropdowns
- **shadcn-ui/vue**: https://www.shadcn-vue.com - Re-usable components built with Radix Vue and Tailwind
- **Iconify Vue**: https://iconify.design/docs/icon-components/vue/ - Icon system for Vue
- **sweetalert2**: https://sweetalert2.github.io - Beautiful modals/alerts
- **emoji-picker-element**: https://github.com/nolanlawson/emoji-picker-element - Lightweight emoji picker

## Backend/BaaS

- **Appwrite Docs**: https://appwrite.io/docs - Complete backend platform documentation
- **Appwrite Web SDK**: https://appwrite.io/docs/sdks#client - Frontend SDK reference
- **Appwrite Functions**: https://appwrite.io/docs/products/functions - Serverless functions (Node.js, Bun, Python)
- **Appwrite Auth**: https://appwrite.io/docs/products/auth - Authentication patterns
- **Appwrite Database**: https://appwrite.io/docs/products/databases - Database queries and relationships
- **Appwrite Storage**: https://appwrite.io/docs/products/storage - File upload and management
- **node-appwrite**: https://github.com/appwrite/sdk-for-node - Node.js server SDK for functions
- **appwrite-utils**: https://github.com/Meldiron/appwrite-utils - Community utilities for Appwrite

## Validation & Data

- **Zod**: https://zod.dev - TypeScript-first schema validation
- **libphonenumber-js**: https://github.com/catamphetamine/libphonenumber-js - Phone number validation
- **metascraper**: https://metascraper.js.org - Metadata extraction from URLs

## Media Processing

- **@ffmpeg/ffmpeg**: https://github.com/ffmpeg/ffmpeg.wasm - WASM video processing
- **video.js**: https://videojs.com/guides/ - HTML5 video player
- **browser-image-compression**: https://github.com/Donaldcwl/browser-image-compression - Client-side image compression
- **Sharp**: https://sharp.pixelplumbing.com - High-performance image processing (Node.js functions)

## Charts & Visualization

- **ECharts**: https://echarts.apache.org/en/index.html - Powerful charting library
- **vue-echarts**: https://github.com/ecomfe/vue-echarts - Vue 3 wrapper for ECharts
- **D3.js**: https://d3js.org - Data visualization primitives

## Utilities

- **es-toolkit**: https://es-toolkit.slash.page - Modern Lodash alternative
- **Luxon**: https://moment.github.io/luxon/ - DateTime library
- **ulid-workers**: https://github.com/perry-mitchell/ulid-workers - ULID generation
- **idb**: https://github.com/jakearchibald/idb - IndexedDB wrapper

## Testing

- **Vitest**: https://vitest.dev - Fast Vite-native test framework
- **@testing-library/vue**: https://testing-library.com/docs/vue-testing-library/intro/ - Vue testing utilities
- **@vue/test-utils**: https://test-utils.vuejs.org - Official Vue testing utilities
- **happy-dom**: https://github.com/capricorn86/happy-dom - Fast DOM implementation for testing

## Build Tools

- **Vite**: https://vitejs.dev/guide/ - Build tool and dev server
- **Wrangler**: https://developers.cloudflare.com/workers/wrangler/ - Cloudflare tooling
- **pnpm**: https://pnpm.io/motivation - Fast, disk space efficient package manager

## Payment Integration

- **Stripe JS**: https://stripe.com/docs/js - Frontend Stripe integration
- **Stripe Node**: https://github.com/stripe/stripe-node - Server-side Stripe SDK

## Monitoring & Analytics

- **Sentry Astro**: https://docs.sentry.io/platforms/javascript/guides/astro/ - Error tracking for Astro
- **Microsoft Clarity**: https://clarity.microsoft.com/docs - Session replay and analytics

## Community Resources

- **Astro Discord**: https://astro.build/chat - Real-time community help
- **Vue Discord**: https://discord.com/invite/vue - Vue community discussions
- **Appwrite Discord**: https://appwrite.io/discord - Appwrite developer community
- **Stack Overflow - Astro**: https://stackoverflow.com/questions/tagged/astro - Q&A for Astro
- **Stack Overflow - Vue3**: https://stackoverflow.com/questions/tagged/vue.js+vue-composition-api - Vue 3 specific questions

## Usage Notes

**For MCP Researcher:**
- Use Context7 for library documentation queries
- Use Tailwind CSS MCP (`mcp__tailwind-css__*`) for Tailwind-specific queries:
  - `search_tailwind_docs` - Search official Tailwind docs
  - `get_tailwind_utilities` - Get utilities by category/property
  - `get_tailwind_colors` - Color palette information
  - `get_tailwind_config_guide` - Framework-specific setup guides
  - `convert_css_to_tailwind` - CSS to Tailwind utility conversion
  - `generate_color_palette` - Custom color generation
  - `generate_component_template` - Component templates with Tailwind
- Reference these URLs when searching for official docs
- Prioritize official documentation over third-party sources

**For Best Practice Researcher:**
- Use Tavily to find community articles and tutorials
- Search Stack Overflow and Discord for real-world patterns
- Look for recent content (last 6-12 months preferred)

**Version Considerations:**
- Vue 3: Focus on Composition API (not Options API)
- Tailwind: v4 syntax (different from v3)
- Astro: Latest stable release
- Appwrite: Check version compatibility for cloud vs self-hosted
