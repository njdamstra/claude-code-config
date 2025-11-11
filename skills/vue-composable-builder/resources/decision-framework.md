# Decision Framework

### When to Create a Composable

```
Is logic reused in 3+ components?
├─ YES → Create composable
└─ NO → Is there complex side-effect management?
   ├─ YES → Create composable
   └─ NO → Does it orchestrate multiple stores?
      ├─ YES → Create composable
      └─ NO → Keep inline in component
```

**✅ CREATE a Composable When:**
1. Logic is reused across **3+ components**
2. Combining **multiple reactive sources** (stores, refs, computed)
3. Managing **side effects** (event listeners, API calls, timers, WebSockets)
4. Accessing **browser APIs** (localStorage, geolocation, camera, etc.)
5. **Orchestrating multiple stores** (auth + billing + teams)
6. Adding **loading/error states** on top of store operations

**❌ DON'T Create a Composable When:**
1. Logic is used in only **1-2 components** (keep inline)
2. Simple **one-liner computed properties**
3. No **side effects** to manage
4. Better suited as a **utility function** (pure transformation)

### Size-Based Guidelines

| Size | Action | Pattern |
|------|--------|---------|
| **< 100 lines** | Keep as single file | Simple focused composable |
| **100-300 lines** | Organize by sections | State, computed, methods, lifecycle |
| **300-500 lines** | Consider splitting | Extract sub-concerns |
| **500+ lines** | **MUST split** | Create multiple composables with composition |

### Which Composable Pattern to Use

```
Does this use Appwrite collections?
├─ YES → Is there a BaseStore for this collection?
│  ├─ YES → Pattern: Store Orchestration (wrap store)
│  └─ NO → Create store first (nanostore-builder)
│
└─ NO → Is this client-side state only?
   ├─ YES → Pattern: Store-Like Composable (persistentAtom)
   └─ NO → Pattern: Direct useStore() in component
```
