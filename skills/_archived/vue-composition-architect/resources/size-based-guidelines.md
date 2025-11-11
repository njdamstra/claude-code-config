# Size-Based Guidelines

### Component/Composable Size Thresholds

| Size | Classification | Action | Example |
|------|---------------|--------|---------|
| **< 100 lines** | Small | Keep as single file | `useMouse`, `Button.vue` |
| **100-300 lines** | Medium | Organize by sections | `useFetch`, `FormInput.vue` |
| **300-500 lines** | Large | **Consider splitting** | `useVirtualList`, `DataTable.vue` |
| **500+ lines** | Very Large | **MUST split** | `useOnboardingFlow`, `UserProfile.vue` |

**Rationale:**
- 100 lines = Single concern, highly focused
- 300 lines = Complexity threshold (consider splitting)
- 500 lines = Multiple features that must be independent
