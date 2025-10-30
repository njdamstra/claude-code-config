# Hybrid Layout Patterns

Combining Astro zero-JS layouts with Vue interactive islands.

## Pattern 1: Astro Shell + Vue Islands

```astro
<html>
  <Header client:load />    <!-- Vue island -->
  <main><slot /></main>     <!-- Astro content -->
  <Footer client:visible /> <!-- Vue island -->
</html>
```

## Pattern 2: Nested Layouts

**See SKILL.md Section 6 for complete examples.**

## Pattern 3: Conditional Islands

Load Vue components only when needed (e.g., admin panels).

## Props vs Nanostores

❌ Props drilling through layers
✅ Nanostores for shared state
