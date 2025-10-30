# Client Directive Optimization

Performance guide for optimizing Vue component hydration in Astro.

## Directive Reference

| Directive | Hydration | Bundle Impact | Use When |
|-----------|-----------|---------------|----------|
| `client:load` | Immediate | High priority | Critical interaction |
| `client:visible` | On scroll | Lazy loaded | Below fold |
| `client:idle` | After idle | Deferred | Non-critical |
| `client:only` | Client-only | No SSR | Breaks SSR |
| `client:media` | Media query | Conditional | Responsive |

## Performance Strategy

**See SKILL.md Section 4 for complete optimization patterns.**

## Decision Matrix

```
Critical interaction? → client:load
Below fold? → client:visible
Can wait? → client:idle
Breaks SSR? → client:only
Responsive? → client:media
```

## Bundle Size Impact

Without optimization: 250 KB initial
With optimization: 80 KB initial + lazy loading

**See SKILL.md for detailed bundle analysis.**
