# Code Reuse Decision Tree

## Start Here

```
Is there existing code that does something similar?
├─ NO → [Search more thoroughly]
│   └─ Still nothing? → CREATE NEW CODE
│
└─ YES → How close is the match?
    ├─ 90-100% match → REUSE AS-IS
    ├─ 70-89% match → EXTEND/COMPOSE
    ├─ 50-69% match → EVALUATE (see below)
    └─ <50% match → CREATE NEW (explain why)
```

## Evaluation Criteria

### For 90-100% Match (REUSE)
✅ Proceed if:
- Actively maintained (recent commits/usage)
- Well-tested (no open bugs)
- Used in 3+ places (proven pattern)
- Has good TypeScript types
- Follows project conventions

❌ Reconsider if:
- Marked as deprecated
- Has known issues
- Scheduled for refactor
- Poor documentation

### For 70-89% Match (EXTEND/COMPOSE)
Ask these questions:

**Can we extend it?**
- Is it designed for extension? (composable, generic)
- Would extension benefit existing users?
- Can we add without breaking changes?

**Can we compose it?**
- Can we wrap/combine with other code?
- Does composition make sense semantically?
- Will it be maintainable?

**Should we fork it?**
- Is our use case very different?
- Would extension create complexity?
- Would it be better to duplicate and diverge?

### For 50-69% Match (EVALUATE)
Calculate the trade-offs:

**Reuse Benefits:**
- Code reuse (estimate LOC saved)
- Consistency with existing patterns
- Battle-tested functionality
- Less maintenance burden

**Reuse Costs:**
- Adaptation complexity
- Potential constraints
- Learning curve
- Dependencies

**Create New Benefits:**
- Perfect fit for requirements
- No constraints
- Full control
- Cleaner for this specific case

**Create New Costs:**
- More code to maintain
- Potential duplication
- Reinventing the wheel
- Testing burden

## Decision Matrix

| Match % | Usage Count | Complexity | Decision |
|---------|-------------|------------|----------|
| 90%+ | 5+ uses | Any | ✅ REUSE |
| 90%+ | 1-4 uses | Low | ✅ REUSE |
| 90%+ | 1-4 uses | High | 🤔 EVALUATE |
| 70-89% | 5+ uses | Low | ✅ EXTEND |
| 70-89% | 5+ uses | High | 🤔 EVALUATE |
| 70-89% | 1-4 uses | Any | 🤔 EVALUATE |
| 50-69% | Any | Any | 🤔 EVALUATE |
| <50% | Any | Any | ❌ CREATE NEW |

## Red Flags

⚠️ DON'T REUSE IF:
- Code is marked `@deprecated`
- Has TODO comments saying "needs refactor"
- Has open bugs/issues
- Last touched >1 year ago (in active project)
- Comments say "temporary solution"
- Uses outdated patterns
- Lacks TypeScript types
- Has security warnings

⚠️ DON'T CREATE NEW IF:
- Pattern exists with 80%+ match
- Only hesitation is "not invented here"
- Difference is trivial (styling, naming)
- Would create duplication
- Team agreed on using existing pattern

## Examples

### Example 1: High Match, High Usage → REUSE
```
Requirement: Form input with validation
Found: FormInput.vue (95% match, used in 15 forms)

Decision: ✅ REUSE
Reasoning: Near-perfect match, heavily used, proven pattern
```

### Example 2: Medium Match, Low Usage → EVALUATE
```
Requirement: User profile card with avatar + bio
Found: UserCard.vue (65% match, used in 2 places)
  - Has avatar ✓
  - Has name ✓
  - Missing bio ✗
  - Missing edit capability ✗

Options:
A) Extend UserCard (add bio + edit mode)
   - Pros: Reuse existing, update 2 uses
   - Cons: Adds complexity to simple component

B) Create UserProfile (reuse UserCard inside)
   - Pros: Composition, keeps UserCard simple
   - Cons: New component to maintain

Decision: ✅ Option B (COMPOSE)
Reasoning: UserCard stays simple, new component composes it
```

### Example 3: Low Match → CREATE NEW
```
Requirement: WebRTC video chat component
Found: VideoPlayer.vue (20% match, video playback only)

Decision: ❌ CREATE NEW
Reasoning: VideoPlayer doesn't handle:
  - Peer connections
  - Real-time communication
  - Camera/mic access
  - Connection management
Fundamentally different requirements
```

### Example 4: Consolidation Opportunity
```
Requirement: Loading spinner
Found:
  - LoadingSpinner.vue (used 5×)
  - Spinner.vue (used 3×)
  - Loading.vue (used 2×)
All do essentially the same thing

Decision: ⚠️ CONSOLIDATE FIRST
Action: Consolidate to LoadingSpinner, then use that
Reasoning: Reduce duplication, improve maintainability
```

## Questions to Ask

Before deciding, ask yourself:

1. **Functionality:**
   - Does it do what I need?
   - What's missing?
   - What's extra?

2. **Quality:**
   - Is it well-tested?
   - Does it have TypeScript types?
   - Is it maintained?

3. **Integration:**
   - Does it fit project patterns?
   - Will it work with existing code?
   - Are there dependencies?

4. **Future:**
   - Will it scale with needs?
   - Can it be extended?
   - Is it flexible enough?

5. **Team:**
   - Do others use it?
   - Is it documented?
   - Would team approve?

## Final Check

Before creating new code, verify:
- [ ] Searched composables thoroughly
- [ ] Searched components by pattern
- [ ] Searched utilities by functionality
- [ ] Checked stores for similar state
- [ ] Asked team if similar code exists
- [ ] Documented why existing code won't work
- [ ] User approved creating new code

Only then: CREATE NEW CODE
