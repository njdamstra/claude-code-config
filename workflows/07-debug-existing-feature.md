---
name: Debug Existing Feature
type: debugging
status: production-ready
updated: 2025-10-16
---

# Workflow: Debug Existing Feature

**Goal**: Fix bugs in existing features without breaking related functionality

**Duration**: 30 min - 3 hours (depends on complexity)
**Complexity**: Medium
**Goal**: Minimal changes, maximum clarity

---

## Steps

### 1. Map the Feature
Invoke `code-reuser-scout`

**Agent**: `code-reuser-scout` maps all related code

**Find:**
- Components involved
- Stores managing state
- Composables with logic
- API endpoints
- Tests covering feature
- Related features that depend on it

**Output:**
- Component tree diagram
- State flow
- Dependencies
- Potential impact areas

### 2. Identify Issue Category
Based on problem description:

| Issue Type | Agent |
|-----------|-------|
| Hydration mismatch | ssr-debugger |
| Type errors | typescript-validator |
| State not updating | nanostore-state-architect |
| API/Auth errors | appwrite-integration-specialist |
| Styling broken | tailwind-styling-expert |
| Component logic bug | vue-architect |
| Test failure | vue-testing-specialist |
| Unknown | code-reuser-scout (re-analyze) |

### 3. Research Similar Fixes
Use `documentation-researcher`

**Agent**: `documentation-researcher` searches patterns

**Query:**
- "How does VueUse handle [specific edge case]?"
- "Pattern for [specific problem]"
- "Best practice for [scenario]"

### 4. Conditional Web Research
If needed, use `web-researcher`

**When:**
- Known framework bugs
- Recent breaking changes
- Specific error message research

### 5. Implement Fix (Minimal Changes)
Invoke appropriate specialist agent

**Principle:** Change least amount of code possible

**Fix location priorities:**
1. Logic layer (composable/store)
2. Component layer (template/computed)
3. Type layer (TypeScript)
4. Styling layer (CSS)

### 6. Add/Fix Tests
Use `vue-testing-specialist`

**Tests to add:**
- Test reproducing the bug
- Test verifying fix
- Related regression tests

### 7. Verify No Regressions
Validate related features still work

**Agent**: `ssr-debugger` verifies SSR compatibility

**Check:**
- Component renders correctly
- Related features work
- No new console errors
- Performance acceptable

---

## Agent Orchestration

```
code-reuser-scout (map) → [Issue-specific agent] →
documentation-researcher (research) →
[conditional: web-researcher] →
[Implementing agent] → vue-testing-specialist (test) →
ssr-debugger (validate)
```

---

## Example: Posts Not Updating After Edit

### Step 1: Map Feature
```
Claude: [Invokes code-reuser-scout]
Scout: "Posts editing involves:
        - EditPostModal.vue (component)
        - postContainerStore.ts (state)
        - usePostEdit composable (logic)
        - /api/posts/[id].ts (backend)
        Related: PostCard.vue, PostsList.vue display posts"
```

### Step 2: Identify Category
```
User: "Posts update in database but UI doesn't refresh"
Category: State sync issue
Agent: nanostore-state-architect
```

### Step 3: Research
```
Claude: [Invokes documentation-researcher]
Query: "How to trigger reactive updates in Nanostores after async operations?"
Result: "Use store.set() or store.setKey() after API success.
         Ensure components use useStore() not .get() for reactivity."
```

### Step 4: No web research needed
Local patterns sufficient.

### Step 5: Implement Fix

**Find issue:**
```typescript
// composables/usePostEdit.ts - BEFORE (bug)
async function updatePost(updates: Partial<Post>) {
  loading.value = true;

  // Update store BEFORE API call
  postContainerStore.setKey('posts', newPosts);

  try {
    await api.updatePost(postId, updates);
  } catch (err) {
    // Oops - store already updated before we knew if it would succeed
  }
}
```

**Fix:**
```typescript
// composables/usePostEdit.ts - AFTER (fixed)
async function updatePost(updates: Partial<Post>) {
  loading.value = true;
  error.value = null;

  try {
    // Call API first
    const response = await fetch(`/api/posts/${postId}`, {
      method: 'PATCH',
      body: JSON.stringify(updates),
    });

    if (!response.ok) throw new Error('Update failed');

    const updated = await response.json();

    // Update store AFTER API success
    const current = postContainerStore.get();
    postContainerStore.setKey('posts',
      current.posts.map(p =>
        p.id === postId ? updated : p
      )
    );

    return updated;
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Unknown error';
    throw err;
  } finally {
    loading.value = false;
  }
}
```

### Step 6: Add Tests
```typescript
it('updates store after successful API call', async () => {
  const { updatePost } = usePostEdit(postId);

  const updated = await updatePost({ title: 'New Title' });

  const current = postContainerStore.get();
  expect(current.posts.find(p => p.id === postId)).toEqual(updated);
});

it('does not update store on API error', async () => {
  mockApi.rejectUpdate();

  try {
    await updatePost({ title: 'Bad Title' });
  } catch {}

  const current = postContainerStore.get();
  expect(current.posts.find(p => p.id === postId).title).toBe('Original');
});
```

### Step 7: Verify
```
- PostCard updates immediately ✓
- PostsList refreshes ✓
- Related features work ✓
- No SSR issues ✓
- No new console errors ✓
```

---

## Debug Decision Tree

```
Bug report received
  ↓
code-reuser-scout: Map the feature
  ↓
Identify issue category:
  ├─ Hydration issue? → ssr-debugger
  ├─ Type error? → typescript-validator
  ├─ State problem? → nanostore-state-architect
  ├─ API error? → appwrite-integration-specialist
  ├─ Styling issue? → tailwind-styling-expert
  ├─ Component logic? → vue-architect
  ├─ Test fails? → vue-testing-specialist
  └─ Unknown? → research / re-analyze
  ↓
Implement minimal fix
  ↓
Add/fix tests
  ↓
Verify no regressions
  ↓
Done!
```

---

## Minimal Change Principle

**Instead of:**
- Refactoring whole component (too risky)
- Rewriting entire feature (too many changes)
- Changing architecture (side effects)

**Do:**
- Fix specific logic (one function)
- Update one store action
- Add missing check
- Fix event binding
- Correct computed property

**Example - Fix Minimal Logic:**
```typescript
// ❌ Refactor everywhere (bad)
// Rewrite component + composable + store

// ✅ Fix specific logic (good)
// Just fix the state update order
postContainerStore.setKey('posts', newPosts); // Move after API call
```

---

## Testing Strategy for Bugs

1. **Reproduce test first** (test that fails with bug)
2. **Implement fix** (minimal change)
3. **Test passes** (verify fix works)
4. **Add regression tests** (prevent re-occurrence)

```typescript
// 1. Reproduce bug
it('posts should update after edit', () => {
  const { updatePost } = usePostEdit(postId);
  // This test fails initially (reproduces bug)
});

// 2-3. Fix implemented and test passes

// 4. Regression test
it('store not updated if API fails', () => {
  // Prevent bug from happening in different scenario
});
```

---

## Related Workflows

- [Enhance Existing Feature](./06-enhance-existing-feature.md)
- [Debug SSR Hydration](./02-debug-ssr-hydration.md)
- [Test-Driven Development](./08-test-driven-development.md)

---

**Time Estimate**: 30 min - 3 hours | **Complexity**: Medium | **Status**: ✅ Production Ready
