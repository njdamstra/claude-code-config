# Refactor Plan: [Refactor Name]

**Owner**: Name
**Date**: YYYY-MM-DD
**Status**: Planning | In Progress | Completed
**Risk Level**: Low | Medium | High

---

## Motivation
Why this refactor is necessary now:
- Technical debt accumulated
- Performance bottleneck identified
- Architecture doesn't support new requirements
- Code duplication / maintainability issues

## Current State Analysis

### Problem Areas
1. **Area 1** (`path/to/file.ts:123`)
   - Issue description
   - Impact on development velocity
   - Risk if left unaddressed

2. **Area 2** (`path/to/other.vue:45`)
   - Issue description
   - Impact on development velocity

### Metrics Before Refactor
- **Code Complexity**: Cyclomatic complexity score
- **Test Coverage**: X% for affected modules
- **Bundle Size**: XkB for feature
- **Build Time**: Xs for affected modules
- **Type Errors**: X errors in affected code

## Refactoring Goals

### Primary Objectives
1. **Objective 1**: Measurable outcome
2. **Objective 2**: Measurable outcome
3. **Objective 3**: Measurable outcome

### Success Criteria
- [ ] All tests pass after refactor
- [ ] No new TypeScript errors introduced
- [ ] Performance maintained or improved
- [ ] Code complexity reduced by X%
- [ ] Developer feedback positive

## Scope

### In Scope
- Files/modules to be refactored
- Features to be preserved
- Tests to be updated

### Out of Scope
- Related but separate improvements
- Feature additions
- Performance optimizations unrelated to structure

## Refactoring Strategy

### Approach
Describe high-level strategy:
- Extract shared logic into composables
- Consolidate duplicate components
- Simplify state management
- Improve type safety

### Before/After Architecture

**Before:**
```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Component A  │    │ Component B  │    │ Component C  │
│ (duplicated) │    │ (duplicated) │    │ (duplicated) │
└──────────────┘    └──────────────┘    └──────────────┘
```

**After:**
```
┌──────────────────────────────────────┐
│      Shared Composable Logic         │
└──────────────────────────────────────┘
         │              │              │
         ▼              ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ Component A  │ │ Component B  │ │ Component C  │
│  (extends)   │ │  (extends)   │ │  (extends)   │
└──────────────┘ └──────────────┘ └──────────────┘
```

## Implementation Plan

### Phase 1: Preparation
**Duration**: 1 day

**Tasks**:
- [ ] Map all dependencies with codebase-researcher
- [ ] Identify affected test files
- [ ] Create feature branch
- [ ] Document current behavior

**Risk**: Low

### Phase 2: Incremental Changes
**Duration**: 3 days

**Tasks**:
- [ ] Step 1: Extract shared logic (`src/composables/useShared.ts`)
- [ ] Step 2: Update Component A to use composable
- [ ] Step 3: Run tests, verify no regressions (tsc --noEmit)
- [ ] Step 4: Update Component B to use composable
- [ ] Step 5: Run tests, verify no regressions
- [ ] Step 6: Update Component C to use composable
- [ ] Step 7: Final test pass and type check

**Risk**: Medium - Each step must verify no breaking changes

### Phase 3: Cleanup
**Duration**: 1 day

**Tasks**:
- [ ] Remove deprecated code
- [ ] Update documentation
- [ ] Run full test suite
- [ ] Performance benchmarks
- [ ] Code review

**Risk**: Low

## Files Affected

### Modified Files
- `src/components/ComponentA.vue` - Use shared composable
- `src/components/ComponentB.vue` - Use shared composable
- `src/components/ComponentC.vue` - Use shared composable

### New Files
- `src/composables/useShared.ts` - Extracted shared logic

### Deleted Files
- `src/utils/duplicatedHelper.ts` - Consolidated into composable

### Test Files
- `tests/components/ComponentA.spec.ts` - Update mocks
- `tests/components/ComponentB.spec.ts` - Update mocks
- `tests/composables/useShared.spec.ts` - New test file

## Risk Assessment

### High-Risk Areas
1. **Area 1**: Why risky and mitigation
2. **Area 2**: Why risky and mitigation

### Rollback Strategy
If refactor introduces critical bugs:
1. Revert commit: `git revert <commit-hash>`
2. Restore from backup branch
3. Investigate issue offline
4. Re-plan approach

### Verification Checkpoints
After each phase:
- [ ] `tsc --noEmit` passes with 0 errors
- [ ] `npm test` passes with 100% prior coverage
- [ ] `npm run lint` passes with no new warnings
- [ ] Manual smoke test of affected features

## Testing Strategy

### Regression Testing
- [ ] All existing tests pass
- [ ] No new TypeScript errors
- [ ] Visual regression tests (if UI changes)

### New Tests
- [ ] Unit tests for extracted composable
- [ ] Integration tests for refactored components
- [ ] E2E tests for critical user flows

### Manual Testing Checklist
- [ ] Feature works in SSR context
- [ ] Dark mode still functional
- [ ] Accessibility unchanged (ARIA, keyboard)
- [ ] Performance metrics stable

## Metrics After Refactor

### Target Improvements
- **Code Duplication**: Reduce from X to Y lines
- **Cyclomatic Complexity**: Reduce from X to Y
- **Bundle Size**: Reduce by XkB
- **Type Safety**: 100% type coverage
- **Test Coverage**: Maintain or increase to X%

### Actual Results
(Fill after completion)
- **Code Duplication**: Actual reduction
- **Complexity**: Actual score
- **Bundle Size**: Actual size

## Communication Plan

### Stakeholders to Notify
- Engineering team (code review)
- QA team (testing focus areas)
- Product team (timeline and scope)

### Documentation Updates
- [ ] Update CLAUDE.md with new patterns
- [ ] Update component documentation
- [ ] Update architectural decision log

## Post-Refactor Review

### What Went Well
(Fill after completion)

### What Could Be Improved
(Fill after completion)

### Lessons Learned
(Fill after completion)

## References
- Issue #XXX - Original problem report
- PR #XXX - Implementation
- Related refactors: Link to similar past work
