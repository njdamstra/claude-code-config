# Parallel Execution (MVP Implementation)

## Current Status: Serialized "Parallel" Execution

**Implementation:** Parallel subagent spawning is currently serialized (sequential execution)
**Location:** `engine/subagent-pool.sh` lines 66-77
**Reason:** Context file (`context.json`) concurrent write safety

## Why Serialization?

When multiple subagents run truly in parallel, they would all attempt to update `context.json` simultaneously, causing:
- **Race conditions** - Last writer wins, losing intermediate updates
- **Corrupted JSON** - Partial writes from multiple processes
- **Lost tracking data** - Subagent counts, deliverables, phase status

## Current Implementation

```bash
# execute_parallel_subagents() in engine/subagent-pool.sh
# Lines 66-77

for subagent in subagents_array; do
  spawn_subagent "$subagent" "$context"  # Sequential spawn
  # Each subagent waits for previous to complete
  # Reloads context after each spawn
done
```

**Behavior:**
- Subagents spawn one-by-one
- Each waits for previous completion
- Context safely updated between spawns
- Functionally correct but slower

## Performance Impact

| Scenario | True Parallel | Serialized MVP | Impact |
|----------|--------------|----------------|--------|
| 5 subagents @ 10s each | 10s total | 50s total | 5x slower |
| 3 subagents @ 5s each | 5s total | 15s total | 3x slower |
| 1 subagent | 5s | 5s | No impact |

**Acceptable for MVP:**
- Correctness > Speed
- Most workflows use 1-3 subagents
- Context integrity preserved

## Future: True Parallelism

Multiple strategies for enabling true parallel execution:

### Option 1: File Locking (`flock`)
```bash
# Before context update
flock -x context.json.lock -c 'update_context'
```
**Pros:** Simple, POSIX-compliant
**Cons:** May not work on all filesystems

### Option 2: Per-Subagent Context Files
```bash
# Each subagent writes own file
context-subagent1.json
context-subagent2.json

# Merge at end
merge_contexts "$context_dir"/*.json
```
**Pros:** No locking needed
**Cons:** Complex merge logic, potential conflicts

### Option 3: Queue-Based Updates
```bash
# Subagents emit update messages
echo "$update_json" >> context_updates.queue

# Background process consumes queue
process_context_queue &
```
**Pros:** Non-blocking writes
**Cons:** Async complexity, eventual consistency

### Option 4: Context Server (Future)
```bash
# HTTP server for context mutations
curl -X POST localhost:8080/context/update \
  -d '{"deliverable": "..."}'
```
**Pros:** Atomic operations, scalable
**Cons:** Infrastructure overhead, overkill for MVP

## Recommended Path Forward

1. **Phase 1 (Current):** Serialized execution ✅
   - Ship MVP with known limitation
   - Document behavior clearly
   - Collect performance feedback

2. **Phase 2 (Next):** File locking
   - Implement `flock`-based locking
   - Test on macOS/Linux/WSL
   - Fallback to serialized on failure

3. **Phase 3 (Later):** Per-subagent contexts
   - Implement context merging
   - Handle conflicts gracefully
   - Enable true parallelism

## Acceptance Criteria Update

From implementation plan Phase 1:
> ✅ Parallel/sequential/main-only behaviors working (serialized MVP)

**Status:** COMPLETE with documented limitation

## Testing

Current test suite validates:
- ✅ Parallel behavior spawns all subagents
- ✅ Sequential behavior respects order
- ✅ Context integrity maintained
- ✅ No race conditions

**Does not test:**
- ❌ Actual concurrent execution (by design)
- ❌ Performance optimization
- ❌ Lock contention

## Migration Notes

When true parallelism is implemented:
1. No YAML workflow changes required
2. `behavior: parallel` will execute faster
3. `behavior: sequential` remains unchanged
4. Backward compatible with existing workflows

## References

- **Implementation:** `engine/subagent-pool.sh:66-77`
- **Validation:** `engine/workflow-loader.sh:103` (behavior validation)
- **Tests:** `tests/unit/test-loader.sh` (behavior acceptance)
- **Context Manager:** `engine/context-manager.sh` (atomic updates)
