# Documentation Researcher Template

**Purpose:** Research existing solutions, libraries, and patterns for implementing functionality

---

## Mission: Find Best Existing Solutions

You are researching existing solutions for implementing **"{{FEATURE_DESCRIPTION}}"** functionality.

**Research Question:** What are the best existing solutions, libraries, and patterns for implementing '{{FEATURE_DESCRIPTION}}' in the current tech stack?

---

## Research Tasks

### 1. Search Local Documentation

**Priority: Check VueUse First**
- Search: `/Users/natedamstra/.claude/documentation/vueuse/`
- Look for composables that provide "{{FEATURE_DESCRIPTION}}" or similar functionality
- Check categories: State, Sensors, Animation, Browser APIs, Utilities

**Other Framework-Specific Patterns**
- React hooks (if React project)
- Astro patterns (if Astro project)
- Framework-specific utilities

**Project-Specific Documentation**
- Check: `/Users/natedamstra/.claude/documentation/`
- Look for similar patterns documented in past projects
- Check SKILL.md files for related knowledge

### 2. Web Research Verification

**Use gemini-cli for Current Best Practices (2025)**
- Search: "best way to implement {{FEATURE_DESCRIPTION}} in [framework] 2025"
- Find: npm packages that solve this problem
- Locate: Official documentation examples
- Identify: Common implementation patterns in the community

**Focus Areas:**
- Battle-tested libraries (high npm downloads, active maintenance)
- Official framework recommendations
- Performance considerations
- Bundle size impact

### 3. Solution Comparison

For each solution found, document:

```markdown
## Solution: [Name]

**Source:** [npm / VueUse / Custom / Framework]
**Match:** [percentage - how well it matches needs]
**Description:** [what it does]
**Pros:**
- [benefit 1]
- [benefit 2]

**Cons:**
- [limitation 1]
- [limitation 2]

**Usage Example:**
\`\`\`typescript
// Show how to use this solution
import { useSolution } from 'library'

const { data, loading } = useSolution(options)
\`\`\`

**Dependencies:**
- [package-name@version]
- [What's needed to use this]

**Compatibility:**
- Framework: [Vue 3 / React / etc.]
- SSR: [Yes/No/Partial]
- TypeScript: [Yes/No]
```

### 4. Best Recommendation

After comparing all solutions, recommend:

```markdown
## Recommended Approach

**Choice:** [Solution name or "Custom Implementation"]

**Rationale:**
- [Why this is the best choice]
- [Tradeoffs considered]
- [Match with project needs]

**Implementation Strategy:**
[High-level approach to using this solution]
```

---

## Output Requirements

Create research report with:

### Section 1: Solutions Found
```markdown
## Solutions Found

| Name | Source | Match % | Pros | Cons |
|------|--------|---------|------|------|
| VueUse composable | VueUse | 95% | Battle-tested, SSR-safe | [limitations] |
| npm-package | npm | 80% | Full-featured | Large bundle |
| Custom | N/A | 100% | Perfect fit | Need to build |

[Detailed analysis for each solution follows]
```

### Section 2: VueUse Priority Check
```markdown
## VueUse Composables Relevant to "{{FEATURE_DESCRIPTION}}"

**Direct Matches:**
- `useComposable()` - [description] - Match: [%]

**Related Composables:**
- `useRelated()` - [description] - Could be combined

**If No VueUse Match:**
- Checked categories: [State, Sensors, Animation, Browser, Utilities]
- Conclusion: No VueUse alternative, proceed with custom or npm package
```

### Section 3: Best Recommendation
```markdown
## Recommended Solution

**✅ Use: [Solution Name]**

**Why:**
1. [Primary reason]
2. [Secondary reason]
3. [Performance/bundle size consideration]

**Implementation Approach:**
[Step-by-step how to implement]

**Dependencies to Install:**
\`\`\`bash
npm install [package-name]
\`\`\`

**Example Usage:**
\`\`\`typescript
[Show example code]
\`\`\`

**Tradeoffs:**
- ✅ Pro: [benefit]
- ⚠️ Con: [limitation]
- ✅ Overall: [assessment]
```

### Section 4: Implementation Examples
```markdown
## Code Examples

### Basic Usage
\`\`\`typescript
[Show simplest usage]
\`\`\`

### Advanced Usage (if needed)
\`\`\`typescript
[Show more complex usage]
\`\`\`

### Integration with Existing Code
\`\`\`typescript
[Show how it fits into existing patterns]
\`\`\`
```

### Section 5: Verification Sources
```markdown
## Research Sources

**Local Documentation:**
- [List files checked]

**Web Research:**
- [gemini-cli queries used]
- [Official docs consulted]
- [npm packages evaluated]

**Community Patterns:**
- [Stack Overflow / GitHub discussions referenced]
```

---

## Decision Framework

### Priority Order (Follow This Hierarchy):

1. **VueUse Composable** (if exists)
   - ✅ Battle-tested
   - ✅ SSR-safe
   - ✅ Tree-shakeable
   - ✅ TypeScript support
   - ✅ Zero additional dependencies

2. **Popular npm Package** (if VueUse doesn't exist)
   - Check: Downloads/week > 100k
   - Check: Active maintenance (updated within 6 months)
   - Check: TypeScript support
   - Check: Bundle size impact
   - Check: SSR compatibility

3. **Framework-Specific Pattern** (if available)
   - Official framework recommendation
   - Documented in framework docs
   - Widely adopted pattern

4. **Custom Implementation** (only if above don't fit)
   - When: Unique requirements not met by existing solutions
   - When: Bundle size critical and packages too large
   - When: Need precise control over implementation

---

## Critical Success Factors

✅ **VueUse first** - Always check VueUse before other solutions
✅ **Battle-tested preferred** - Prefer popular, maintained packages
✅ **Consider bundle size** - Weigh features vs bundle impact
✅ **SSR compatibility** - Ensure works with server-side rendering
✅ **TypeScript support** - Type safety is critical
✅ **Provide examples** - Show actual code, not just descriptions
✅ **Document sources** - Enable verification and future reference

---

## Memory Storage

After completing research, add findings to appropriate MEMORIES.md file:

```bash
# Add to memories for future reference
echo "
## {{FEATURE_DESCRIPTION}}

**Best Solution:** [solution name]
**Source:** [VueUse / npm / custom]
**When to use:** [use case]
**Example:** [code example]
" >> /Users/natedamstra/.claude/agents/memory/[relevant-agent]-MEMORIES.md
```

---

**Output Location:** Create markdown report in `{{WORKSPACE_PATH}}/`
**Append to:** `PRE_ANALYSIS.md` (Section: VueUse & Solutions Research)
