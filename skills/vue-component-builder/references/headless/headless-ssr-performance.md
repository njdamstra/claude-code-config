# SSR Considerations

- Provide/inject works in SSR
- Context available during server render
- Hydration maintains context correctly
- No special handling needed for basic cases

## Performance Notes

**Provide/inject is efficient:**
- Direct reference, not prop chain traversal
- No re-renders of intermediate components
- Reactive updates only affect consumers

**Avoid over-providing:**
- Only provide what descendants need
- Split contexts if different consumers need different data
- Example: Root context vs Item context separation
