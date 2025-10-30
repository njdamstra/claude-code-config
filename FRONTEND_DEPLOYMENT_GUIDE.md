# Frontend Development System - Deployment & Usage Guide

**Status**: ✅ Production Ready
**Date**: October 16, 2025
**Projects**: Socialaize, Staryo
**Tech Stack**: Astro + Vue 3 + TypeScript + Tailwind + Appwrite + Nanostores

---

## Quick Start

### For Socialaize Frontend Development:
```
I need to [create a dashboard page | fix SSR hydration | add dark mode | test a component]
```

The system will automatically delegate to the appropriate agent(s).

### For Staryo Website Development:
```
I need to [build an admin feature | debug state issues | optimize performance]
```

Same delegation system applies.

---

## 11 Specialized Agents at Your Service

### 🏗️ **Astro Architect** `astro-architect`
- **When**: Building new Astro pages, API routes, implementing SSR
- **Expertise**: Page design, server-side data fetching, middleware, authentication guards
- **Model**: haiku-4.5 | **Color**: Orange
- **Example**: "Create a dashboard page with Appwrite integration"

### 🎨 **Vue Architect** `vue-architect`
- **When**: Creating Vue components, refactoring for reusability, implementing state
- **Expertise**: Composition API, Nanostores, SSR-safe patterns, slots, TypeScript
- **Model**: haiku-4.5 | **Color**: Green
- **Example**: "Create a form validation component with proper typing"

### ✅ **Testing Specialist** `vue-testing-specialist`
- **When**: Writing tests, debugging test failures, implementing TDD
- **Expertise**: Vitest, Jest, component testing, mocking, SSR-safe setup
- **Model**: haiku-4.5 | **Color**: Purple
- **Example**: "Write tests for this API route (TDD-first approach)"

### 🔍 **Code Reuser Scout** `code-reuser-scout`
- **When**: Before creating anything new (components, composables, stores)
- **Expertise**: Finding existing code, identifying near-matches, preventing duplication
- **Model**: haiku-4.5 | **Color**: Blue
- **Example**: "Is there already a form component I can extend?"

### 💾 **Nanostore Architect** `nanostore-state-architect`
- **When**: Managing cross-component state, refactoring prop drilling, persistent storage
- **Expertise**: Atom stores, map stores, computed stores, Vue integration, SSR safety
- **Model**: haiku-4.5 | **Color**: Red
- **Example**: "Refactor this component hierarchy to use stores instead of props"

### 🐛 **SSR Debugger** `ssr-debugger`
- **When**: Hydration mismatches, client-server state sync issues, performance problems
- **Expertise**: Hydration debugging, state sync, browser API detection, memory leaks
- **Model**: haiku-4.5 | **Color**: Yellow
- **Example**: "Getting hydration mismatch warnings in console"

### ⚙️ **Appwrite Specialist** `appwrite-integration-specialist`
- **When**: Setting up Appwrite, authentication, database operations, file storage
- **Expertise**: SSR client setup, auth flows, CRUD, real-time, service abstractions
- **Model**: haiku-4.5 | **Color**: Green
- **Example**: "Implement user authentication with Appwrite sessions"

### 🎭 **Tailwind Expert** `tailwind-styling-expert`
- **When**: Responsive layouts, dark mode, design systems, accessibility
- **Expertise**: Mobile-first design, dark mode variants, animations, performance
- **Model**: haiku-4.5 | **Color**: Teal
- **Example**: "Add dark mode support to all components"

### 📘 **TypeScript Validator** `typescript-validator`
- **When**: Type errors, improving type safety, implementing validation schemas
- **Expertise**: Type checking, Zod schemas, inference, type guards, strict typing
- **Model**: haiku-4.5 | **Color**: Blue
- **Example**: "Fix all TypeScript errors and add Zod validation"

### 📚 **Documentation Researcher** `documentation-researcher`
- **When**: Need specific technical documentation or API details
- **Expertise**: Local docs search, web verification, precision research, knowledge capture
- **Model**: haiku-4.5 | **Color**: Purple
- **Example**: "How do I implement reactive authentication in Astro with nanostores?"

### 🌐 **Web Researcher** `web-researcher`
- **When**: Latest patterns, 2025+ practices, framework updates, debugging specific errors
- **Expertise**: Targeted web search (max 5 per task), comprehensive reports, actionable findings
- **Model**: haiku-4.5 | **Color**: Cyan
- **Example**: "What are the latest Vue 3.5 reactivity features?"

---

## 8 Complete Workflows

### Workflow 1: Create New Feature Page
```
User: "Create a dashboard page with user profile, stats, and recent activity"
↓
astro-architect → vue-architect → tailwind-styling-expert → typescript-validator
↓
Result: Complete SSR page with typed components and responsive styling
```

### Workflow 2: Debug SSR Hydration Issues
```
User: "Getting hydration mismatch warnings"
↓
ssr-debugger → [Issue-specific agent] → validation
↓
Result: Fixed hydration, client-server state sync, no warnings
```

### Workflow 3: Create API Endpoint
```
User: "Build API endpoint for creating posts with validation"
↓
astro-architect → appwrite-integration-specialist → typescript-validator → vue-testing-specialist
↓
Result: Type-safe API route with validation and tests
```

### Workflow 4: Refactor to Nanostores
```
User: "This component hierarchy has too much prop drilling"
↓
code-reuser-scout → nanostore-state-architect → vue-architect → vue-testing-specialist → ssr-debugger
↓
Result: Clean state management, no prop drilling, all tests passing
```

### Workflow 5: Add Dark Mode
```
User: "Implement dark mode across the app"
↓
tailwind-styling-expert → vue-architect → nanostore-state-architect → vue-testing-specialist
↓
Result: Full dark mode support, toggle component, persistence
```

### Workflow 6: Enhance Existing Feature
```
User: "Add sorting by date to the posts list"
↓
code-reuser-scout → documentation-researcher → [conditional: web-researcher] → vue-architect → vue-testing-specialist
↓
Result: New feature integrated without code duplication
```

### Workflow 7: Debug Existing Feature
```
User: "Posts aren't updating after edit"
↓
code-reuser-scout → [Issue-specific agent] → documentation-researcher → [conditional: web-researcher] → vue-testing-specialist
↓
Result: Root cause found and fixed, tests added
```

### Workflow 8: Test-Driven Development
```
User: "Create a form validation component using TDD"
↓
code-reuser-scout → vue-testing-specialist (write tests) → vue-architect (implement) → vue-testing-specialist (verify) → typescript-validator
↓
Result: Fully tested component, 95%+ coverage, all tests passing
```

---

## Using the System

### Method 1: Natural Language (Recommended)
```
"I need to create a user settings page with dark mode toggle and Appwrite integration"
```
The system automatically delegates to the right agents in sequence.

### Method 2: Direct Agent Invocation
```
@astro-architect Create a dashboard page with authentication
@vue-architect Build form components with validation
@vue-testing-specialist Write tests for the form component
```

### Method 3: Workflow-Based
```
// For new features:
code-reuser-scout → appropriate-specialist

// For debugging:
code-reuser-scout (map feature) → [issue-specific-agent] → documentation-researcher → validation

// For testing:
vue-testing-specialist (write failing tests first)
```

---

## Key Principles

### 1. Code Reuse First
Always check existing code before creating new. Use `code-reuser-scout`.

### 2. Research Hierarchy
- **Local docs first**: documentation-researcher
- **VueUse/patterns**: documentation-researcher (search local)
- **Latest 2025 patterns**: web-researcher (conditional)
- **Web search**: Only when local resources insufficient

### 3. Architecture Hierarchy
- **Level 1**: VueUse composables (via documentation-researcher)
- **Level 2**: Custom composables (reusable logic)
- **Level 3**: Nanostores (cross-component state)
- **Level 4**: Vue components (UI with slots)

### 4. Test-First Mentality
- Write tests before implementation
- Use `vue-testing-specialist` to start
- Implement components to pass tests
- Validate with `typescript-validator`

### 5. Type Safety Always
- Strong TypeScript typing required
- Zod schemas for runtime validation
- No `any` types without justification
- Cross-boundary type safety

### 6. SSR Compatibility
- Wrap browser APIs with `useMounted()`
- Use `client:load` directives appropriately
- Test in both SSR and client contexts
- Check for hydration mismatches

---

## Common Requests & Responses

### "Create a new component"
**System Response**:
1. code-reuser-scout checks for existing patterns
2. vue-architect creates the component
3. tailwind-styling-expert adds styling
4. typescript-validator ensures types
5. (Optional) vue-testing-specialist adds tests

### "This feature is broken"
**System Response**:
1. code-reuser-scout maps the feature
2. Issue-specific agent debugs
3. documentation-researcher finds patterns
4. Implementation agent fixes
5. vue-testing-specialist adds test
6. ssr-debugger validates SSR

### "How do I...?"
**System Response**:
1. documentation-researcher searches local docs
2. Verifies with web search if needed
3. Provides exact API signatures, working examples
4. Documents findings for future reference

### "Add feature X"
**System Response**:
1. code-reuser-scout prevents duplication
2. Appropriate specialist implements
3. Follows established patterns
4. Fully tested and typed
5. SSR-compatible

---

## Performance Notes

All agents use **haiku-4.5** for optimal token efficiency:
- Faster response times
- Lower token costs
- Specialized expertise retained
- Production-ready quality

---

## What's Included

✅ **Documentation**: Complete FRONTEND_DEV_SYSTEM.md with examples
✅ **11 Agents**: Specialized for frontend, backend, testing, research
✅ **8 Workflows**: Complete patterns for common tasks
✅ **Type Safety**: TypeScript + Zod throughout
✅ **SSR Ready**: Astro + Vue SSR patterns
✅ **Testing**: Full TDD support
✅ **State Management**: Nanostores patterns
✅ **Backend**: Appwrite integration patterns
✅ **Styling**: Tailwind + dark mode
✅ **Research**: Local + web documentation

---

## Next Steps

1. **For your next task**, just describe what you need
2. **The system will automatically delegate** to the right agents
3. **Follow the patterns** established in the system
4. **Use the workflows** as templates for similar tasks
5. **Refer back to FRONTEND_DEV_SYSTEM.md** for patterns and best practices

---

## Support

**Questions about architecture?** → documentation-researcher or web-researcher
**Need to refactor?** → code-reuser-scout
**Debugging issues?** → Appropriate issue-specific agent
**Adding features?** → Follow the workflow patterns

---

**System Status**: ✅ PRODUCTION READY
**Ready to accelerate your frontend development with specialized agent support!**
