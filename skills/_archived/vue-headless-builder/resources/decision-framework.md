# Decision Framework

### When to Use Headless Components

**Use headless when:**
- ✅ Need full design system control
- ✅ Building reusable component library
- ✅ Accessibility is critical requirement
- ✅ Multiple visual variants of same behavior
- ✅ Existing UI libraries too opinionated

**Don't use headless when:**
- ❌ Rapid prototyping with pre-styled components
- ❌ Design system already established
- ❌ Team unfamiliar with compound patterns
- ❌ Simple one-off components

### When to Use Compound Pattern

**Use compound when:**
- ✅ Multiple coordinated sibling components
- ✅ Shared state between related components
- ✅ Complex component with distinct sub-responsibilities
- ✅ Need to expose composed API to users

**Example compound candidates:**
- Accordion (Root, Item, Trigger, Content)
- Dialog (Root, Trigger, Content, Close)
- Select (Root, Trigger, Content, Item, Group)
- Tabs (Root, List, Trigger, Content)

**Don't use compound when:**
- ❌ Single component with no sub-parts
- ❌ No shared state between siblings
- ❌ Props drilling is sufficient
- ❌ Simple parent-child relationship

### When to Use Provide/Inject vs Props

**Use provide/inject when:**
- ✅ Deep nesting (3+ levels)
- ✅ Multiple components need same data
- ✅ Component composition (compound components)
- ✅ Avoiding props drilling through intermediaries

**Use props when:**
- ✅ Direct parent-child relationship
- ✅ Single level of communication
- ✅ Explicit data flow preferred
- ✅ Component is reusable across contexts
