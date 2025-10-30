# Component Decision Tree

Complete analysis for choosing .astro vs Vue components.

## Decision Flowchart

**See SKILL.md Quick Decision Tree for visual flowchart.**

## Analysis Factors

1. **Interactivity Level**
2. **Reusability**
3. **State Management**
4. **Performance Requirements**
5. **SEO Impact**

## Performance Comparison

| Approach | Bundle Size | TTI | SEO |
|----------|-------------|-----|-----|
| .astro | 0 KB | Instant | Excellent |
| Vue | 50-100 KB | ~200ms | Good |

## Real-World Examples

**Static Content:** Blog posts, landing pages → .astro
**Interactive:** Forms, dashboards, real-time → Vue
**Hybrid:** Astro page + Vue islands for interaction

**See SKILL.md Section 1 for complete guidelines.**
