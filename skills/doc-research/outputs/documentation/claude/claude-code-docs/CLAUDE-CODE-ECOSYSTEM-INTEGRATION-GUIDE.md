# Claude Code Ecosystem Integration Guide
## The Complete Playbook for Skills, Output Styles, Subagents, Slash Commands, Hooks & MCP

**Author:** Synthesized from Official Documentation + Community Best Practices  
**Last Updated:** October 2025  
**Tech Stack Focus:** Vue 3, Astro, TypeScript, Appwrite, Tailwind CSS, Zod  
**Status:** Complete Integration Reference

---

## TABLE OF CONTENTS

1. [Ecosystem Overview](#ecosystem-overview)
2. [Architecture & Component Relationships](#architecture--component-relationships)
3. [Feature Integration Matrix](#feature-integration-matrix)
4. [Decision Framework: When to Use What](#decision-framework-when-to-use-what)
5. [Real-World Integration Patterns](#real-world-integration-patterns)
6. [Tech Stack-Specific Workflows](#tech-stack-specific-workflows)
7. [Advanced Integration Examples](#advanced-integration-examples)
8. [Best Practices & Anti-Patterns](#best-practices--anti-patterns)
9. [Edge Cases & Troubleshooting](#edge-cases--troubleshooting)
10. [Complete Project Setup Guide](#complete-project-setup-guide)

---

## ECOSYSTEM OVERVIEW

### The Claude Code Component Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE CORE                          │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  MAIN AGENT (System Prompt + Context Window)          │   │
│  │  • Base personality & capabilities                    │   │
│  │  • Tool access (Bash, Edit, Write, Read, etc.)        │   │
│  │  • Project context (CLAUDE.md)                        │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
│  ┌───────────────────────── LAYER 1: PERSONALITY ──────────┐│
│  │ OUTPUT STYLES (.claude/output-styles/*.md)             ││
│  │ • Replaces system prompt entirely                      ││
│  │ • Changes Claude's personality & reasoning             ││
│  │ • User-invoked with /output-style                      ││
│  └────────────────────────────────────────────────────────┘│
│                                                               │
│  ┌───────────────────────── LAYER 2: CAPABILITIES ─────────┐│
│  │ SKILLS (.claude/skills/*/SKILL.md)                     ││
│  │ • Model-invoked (Claude decides when)                  ││
│  │ • Progressive disclosure (load on demand)              ││
│  │ • Specialized knowledge packages                       ││
│  └────────────────────────────────────────────────────────┘│
│                                                               │
│  ┌───────────────────────── LAYER 3: DELEGATION ───────────┐│
│  │ SUBAGENTS (.claude/agents/*.md)                        ││
│  │ • Model-invoked specialized assistants                 ││
│  │ • Separate context windows                             ││
│  │ • Task-specific system prompts                         ││
│  └────────────────────────────────────────────────────────┘│
│                                                               │
│  ┌───────────────────────── LAYER 4: WORKFLOWS ────────────┐│
│  │ SLASH COMMANDS (.claude/commands/*.md)                 ││
│  │ • User-invoked workflow templates                      ││
│  │ • Can call subagents & skills                          ││
│  │ • Reusable prompt patterns                             ││
│  └────────────────────────────────────────────────────────┘│
│                                                               │
│  ┌───────────────────────── LAYER 5: AUTOMATION ───────────┐│
│  │ HOOKS (.claude/settings.json)                          ││
│  │ • Lifecycle event automation                           ││
│  │ • Deterministic execution (always runs)                ││
│  │ • Pre/Post tool execution                              ││
│  └────────────────────────────────────────────────────────┘│
│                                                               │
│  ┌───────────────────────── LAYER 6: EXTERNAL DATA ────────┐│
│  │ MCP SERVERS (.claude/settings.json)                    ││
│  │ • External tool/data integration                       ││
│  │ • GitHub, Slack, Databases, APIs                       ││
│  │ • Real-time data access                                ││
│  └────────────────────────────────────────────────────────┘│
└───────────────────────────────────────────────────────────────┘
```

### Core Principles

**Three Types of Invocation:**

1. **User-Invoked** (Explicit)
   - Output Styles: `/output-style name`
   - Slash Commands: `/command args`
   - Tools: Direct prompt "edit file X"

2. **Model-Invoked** (Autonomous)
   - Skills: Claude reads description, decides to use
   - Subagents: Claude delegates based on task match
   - MCP Tools: Claude calls when needs external data

3. **Event-Invoked** (Automatic)
   - Hooks: Triggered by lifecycle events
   - Always execute when event fires

---

## ARCHITECTURE & COMPONENT RELATIONSHIPS

### How Components Interact

```
USER PROMPT: "Build a Vue 3 login component with proper validation"
     ↓
┌────────────────────────────────────────────────────────────┐
│ 1. OUTPUT STYLE (Active personality layer)                 │
│    • Determines response format                            │
│    • Sets reasoning approach                               │
│    • Doesn't change available tools                        │
└────────────────────────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────────────────────────┐
│ 2. MAIN AGENT (Analyzes task)                              │
│    • Reads CLAUDE.md project context                       │
│    • Discovers available skills & subagents                │
│    • Plans approach                                        │
└────────────────────────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────────────────────────┐
│ 3. SKILL DISCOVERY (Model-invoked)                         │
│    Task needs: Vue 3 component → Matches description       │
│    • Loads vue-component-builder skill                     │
│    • Reads SKILL.md instructions                           │
│    • Follows skill's best practices                        │
└────────────────────────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────────────────────────┐
│ 4. TOOL EXECUTION (With hooks)                             │
│    Pre-Hook: Validate file doesn't exist                   │
│    Write Tool: Create LoginForm.vue                        │
│    Post-Hook: Run Prettier, ESLint                         │
└────────────────────────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────────────────────────┐
│ 5. SUBAGENT DELEGATION (If needed)                         │
│    Complex validation logic detected                       │
│    • Delegates to test-engineer subagent                   │
│    • Subagent creates test file                            │
│    • Returns to main agent with results                    │
└────────────────────────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────────────────────────┐
│ 6. MCP INTEGRATION (If configured)                         │
│    Need to update Appwrite schema?                         │
│    • MCP server connects to Appwrite API                   │
│    • Creates collection/attributes                         │
│    • Returns confirmation                                  │
└────────────────────────────────────────────────────────────┘
     ↓
RESULT: Complete Vue 3 component with tests, formatted,
        validated, and integrated with backend
```

### Communication Flow Between Components

```
Output Style ←→ Main Agent
    ↕
Skills ←─────→ Main Agent ←─────→ Subagents
    ↕              ↕                 ↕
Hooks ←─────→ Tool Execution ←──→ MCP Servers
    ↕              ↕                 ↕
Settings.json (Configuration Layer)
    ↕
Commands (User-Invoked Workflows)
```

---

## FEATURE INTEGRATION MATRIX

### What Works Together

| Feature 1 | Feature 2 | Integration Type | Use Case |
|-----------|-----------|------------------|----------|
| **Output Style** | Skills | Seamless | Style changes personality, skills provide domain knowledge |
| **Output Style** | Subagents | Seamless | Style affects main agent only, subagents keep their prompts |
| **Output Style** | Commands | Seamless | Commands can specify output style inline |
| **Output Style** | Hooks | Independent | Hooks run regardless of output style |
| **Output Style** | MCP | Independent | MCP tools work the same in any style |
| **Skills** | Subagents | Complementary | Skills = knowledge, Subagents = delegation |
| **Skills** | Commands | Reference | Commands can reference skills in instructions |
| **Skills** | Hooks | Coordinated | Hooks can trigger after skill-driven actions |
| **Skills** | MCP | Orchestration | Skills can instruct use of MCP tools |
| **Subagents** | Commands | Explicit Invocation | Commands can request specific subagents |
| **Subagents** | Hooks | Lifecycle | SubagentStop hook fires after completion |
| **Subagents** | MCP | Independent | Subagents can use MCP tools if allowed |
| **Commands** | Hooks | Triggered | Hooks run during command execution |
| **Commands** | MCP | Tool Usage | Commands can use MCP tools |
| **Hooks** | MCP | Automated | Hooks can trigger MCP operations |

### Conflict & Precedence Rules

1. **Output Styles vs Output Styles**: Only one active at a time
2. **Project vs User Settings**: Project overrides user
3. **Skills with Same Name**: Project skills override user skills
4. **Subagents with Same Name**: Project agents override user agents
5. **Commands with Same Name**: Project commands override user commands
6. **Hook Matchers**: First matching hook executes (if continue=false)

---

## DECISION FRAMEWORK: WHEN TO USE WHAT

### The Component Selection Flowchart

```
START: What problem are you solving?
  ↓
┌──────────────────────────────────────────────────────┐
│ Does Claude need a DIFFERENT PERSONALITY?            │
│ (Research mode vs coding mode vs audit mode)         │
└──────────────────────────────────────────────────────┘
  YES → Use OUTPUT STYLE
  NO ↓
┌──────────────────────────────────────────────────────┐
│ Do you want to TRIGGER this manually when needed?    │
│ (Like a macro or template)                           │
└──────────────────────────────────────────────────────┘
  YES → Use SLASH COMMAND
  NO ↓
┌──────────────────────────────────────────────────────┐
│ Does Claude need SPECIALIZED KNOWLEDGE?              │
│ (Excel analysis, API patterns, testing frameworks)   │
└──────────────────────────────────────────────────────┘
  YES → Use SKILL
  NO ↓
┌──────────────────────────────────────────────────────┐
│ Should a SEPARATE AGENT handle specific tasks?       │
│ (Security reviews, test generation, documentation)   │
└──────────────────────────────────────────────────────┘
  YES → Use SUBAGENT
  NO ↓
┌──────────────────────────────────────────────────────┐
│ Must something ALWAYS happen automatically?          │
│ (Format on save, run tests, validate inputs)         │
└──────────────────────────────────────────────────────┘
  YES → Use HOOKS
  NO ↓
┌──────────────────────────────────────────────────────┐
│ Need access to EXTERNAL DATA/TOOLS?                  │
│ (GitHub, databases, Slack, custom APIs)              │
└──────────────────────────────────────────────────────┘
  YES → Use MCP SERVER
  NO → Use CLAUDE.md instructions
```

### Quick Decision Table

| Need | Solution | Example |
|------|----------|---------|
| Change Claude's personality | Output Style | Research mode vs coding mode |
| Store reusable workflow | Slash Command | `/fix-github-issue 123` |
| Give Claude domain expertise | Skill | Excel analysis, API patterns |
| Delegate to specialist | Subagent | Security reviewer, test engineer |
| Guarantee automation | Hook | Auto-format, auto-test |
| Access external data | MCP Server | GitHub, Appwrite, Slack |
| Project guidelines | CLAUDE.md | Tech stack, conventions |

---

## REAL-WORLD INTEGRATION PATTERNS

### Pattern 1: Complete Feature Development Workflow

**Scenario:** Building a new feature from GitHub issue to deployment

**Integration Stack:**

```
┌─────────────────────────────────────────────────────┐
│ SLASH COMMAND: /feature-from-issue                  │
│ • User-invoked workflow orchestrator                │
│ • Coordinates all other components                  │
└─────────────────────────────────────────────────────┘
         ↓ (fetches issue)
┌─────────────────────────────────────────────────────┐
│ MCP: GitHub Server                                  │
│ • Fetch issue details                               │
│ • Get PR context                                    │
│ • Update status                                     │
└─────────────────────────────────────────────────────┘
         ↓ (analyzes requirements)
┌─────────────────────────────────────────────────────┐
│ OUTPUT STYLE: Explanatory                           │
│ • Detailed reasoning during implementation          │
│ • Documents design decisions                        │
└─────────────────────────────────────────────────────┘
         ↓ (implements code)
┌─────────────────────────────────────────────────────┐
│ SKILLS: vue-component-builder + api-integration     │
│ • Vue 3 best practices                              │
│ • Appwrite SDK patterns                             │
└─────────────────────────────────────────────────────┘
         ↓ (creates files - triggers hooks)
┌─────────────────────────────────────────────────────┐
│ HOOKS: PostToolUse                                  │
│ • ESLint auto-fix                                   │
│ • Prettier formatting                               │
│ • Type checking                                     │
└─────────────────────────────────────────────────────┘
         ↓ (generates tests)
┌─────────────────────────────────────────────────────┐
│ SUBAGENT: test-engineer                             │
│ • Creates comprehensive test suite                  │
│ • Separate context window                           │
└─────────────────────────────────────────────────────┘
         ↓ (final verification)
┌─────────────────────────────────────────────────────┐
│ SUBAGENT: security-reviewer                         │
│ • Scans for vulnerabilities                         │
│ • Validates input handling                          │
└─────────────────────────────────────────────────────┘
         ↓ (creates PR)
┌─────────────────────────────────────────────────────┐
│ MCP: GitHub Server                                  │
│ • Create PR with full description                   │
│ • Link to original issue                            │
└─────────────────────────────────────────────────────┘
```

**Implementation:**

**File:** `.claude/commands/feature-from-issue.md`
```markdown
---
description: Complete feature development workflow from GitHub issue to PR
argument-hint: [issue-number]
model: claude-sonnet-4-20250514
---

# Feature Development From Issue

Implement a complete feature from GitHub issue $1.

## Process

1. **Fetch Issue Context** (use GitHub MCP)
   - Get issue details, labels, comments
   - Understand requirements and acceptance criteria
   - Note any existing discussions

2. **Design Implementation** (use explanatory output style)
   - Create technical design
   - Document approach and trade-offs
   - Get user approval before coding

3. **Implement Feature**
   - Use vue-component-builder skill for UI
   - Use api-integration skill for backend
   - Follow Astro routing patterns
   - Implement with Tailwind CSS
   - Use Zod for validation

4. **Generate Tests** (delegate to test-engineer subagent)
   - Unit tests with Vitest
   - Component tests with Testing Library
   - Integration tests for API calls

5. **Security Review** (delegate to security-reviewer subagent)
   - Check for XSS, injection vulnerabilities
   - Validate authentication/authorization
   - Review data handling

6. **Create PR** (use GitHub MCP)
   - Comprehensive description
   - Link to issue
   - Include testing instructions

## Output Format
Progress updates at each phase.
Final PR link at completion.
```

### Pattern 2: Content Generation System

**Scenario:** Research and create blog posts with citations

**Integration Stack:**

```
OUTPUT STYLE: content-researcher
    ↓
SKILL: web-research + markdown-authoring
    ↓
MCP: Brave Search (web search)
    ↓
HOOKS: PreToolUse (validate sources)
    ↓
HOOKS: PostToolUse (SEO optimization)
```

**Implementation:**

**File:** `.claude/output-styles/content-researcher.md`
```markdown
---
name: Content Researcher
description: Deep research and content creation with citations
---

# Content Researcher

## Purpose
You are a thorough content researcher who creates
well-researched, cited articles.

## Approach

### Phase 1: Research
1. Use web search to find 5-10 authoritative sources
2. Prioritize: academic, government, established media
3. Take detailed notes with source URLs
4. Identify controversies or gaps

### Phase 2: Outline
1. Create structured outline with main points
2. Map sources to each point
3. Identify where more research is needed

### Phase 3: Writing
1. Write in clear, engaging prose
2. Use markdown formatting
3. Add inline citations [^1]
4. Create references section at bottom

### Phase 4: Optimization
1. Add meta description
2. Suggest image placements
3. Internal linking opportunities
4. Keywords naturally integrated

## Output Format
Always create markdown files with:
- Title and metadata
- Body with citations
- References section
- SEO recommendations section
```

**File:** `.claude/skills/web-research/SKILL.md`
```markdown
---
name: Web Research
description: Systematic web research with source validation and citation management. Use when creating content requiring authoritative sources.
---

# Web Research Skill

## Instructions

### Source Validation
ALWAYS verify sources meet these criteria:
- Published date (prefer last 2 years)
- Author credentials
- Domain authority (.edu, .gov, established media)
- No obviously biased content

### Research Process
1. Start with broad query
2. Identify 3-5 key subtopics
3. Deep dive each subtopic
4. Cross-reference contradictory info
5. Note consensus vs outlier views

### Citation Format
Use markdown footnote syntax:
```
According to recent studies[^1], the technique has shown...

[^1]: Smith, J. (2024). "Research Title". Journal Name.
      https://example.com/article
```

### Output Structure
Always provide:
- Main findings (bullet points)
- Source summary table
- Research gaps identified
- Recommended next steps
```

### Pattern 3: Automated Quality Pipeline

**Scenario:** Ensure all code changes meet standards

**Integration Stack:**

```
All Tool Execution
    ↓
HOOKS: PreToolUse (validation)
    ↓
HOOKS: PostToolUse (formatting & testing)
    ↓
HOOKS: Stop (commit & notify)
```

**Implementation:**

**File:** `.claude/settings.json`
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/validate-file.py"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/format-and-test.sh",
            "continue": true
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/commit-and-notify.sh"
          }
        ]
      }
    ]
  }
}
```

**File:** `.claude/hooks/validate-file.py`
```python
#!/usr/bin/env python3
import json
import sys

# Read hook payload
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
file_path = tool_input.get('file_path', '')

# Validation rules
FORBIDDEN_PATTERNS = ['.env', '.key', 'credentials']
REQUIRED_EXTENSIONS = ['.ts', '.vue', '.astro', '.md']

# Block forbidden files
if any(pattern in file_path for pattern in FORBIDDEN_PATTERNS):
    sys.stderr.write(f"❌ Cannot edit {file_path}: sensitive file\n")
    sys.exit(2)

# Warn about non-standard extensions
if not any(file_path.endswith(ext) for ext in REQUIRED_EXTENSIONS):
    sys.stderr.write(f"⚠️  Warning: {file_path} unusual extension\n")

# Allow
sys.exit(0)
```

**File:** `.claude/hooks/format-and-test.sh`
```bash
#!/bin/bash
# Read JSON from stdin
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Only process TS/Vue files
if [[ "$file_path" =~ \.(ts|vue)$ ]]; then
    echo "🎨 Formatting $file_path..."
    npx prettier --write "$file_path"
    
    echo "🔍 Linting $file_path..."
    npx eslint --fix "$file_path"
    
    echo "🧪 Type checking..."
    npx tsc --noEmit
fi

exit 0
```

---

## TECH STACK-SPECIFIC WORKFLOWS

### Vue 3 + Astro Project Setup

**Directory Structure:**
```
my-astro-project/
├── .claude/
│   ├── settings.json
│   ├── commands/
│   │   ├── new-component.md
│   │   ├── new-page.md
│   │   └── api-endpoint.md
│   ├── agents/
│   │   ├── vue-specialist.md
│   │   └── api-architect.md
│   ├── skills/
│   │   ├── vue-component-builder/
│   │   ├── astro-routing/
│   │   └── appwrite-integration/
│   ├── output-styles/
│   │   └── vue-educator.md
│   └── hooks/
│       ├── format.sh
│       └── type-check.sh
├── src/
│   ├── components/
│   ├── pages/
│   ├── layouts/
│   └── lib/
└── CLAUDE.md
```

### Component 1: Vue Component Builder Skill

**File:** `.claude/skills/vue-component-builder/SKILL.md`
```markdown
---
name: Vue 3 Component Builder
description: Build Vue 3 components with TypeScript, Composition API, and best practices. Use when creating .vue files.
version: 1.0.0
tags: [vue3, typescript, composition-api]
---

# Vue 3 Component Builder

## Quick Start
When creating Vue components for this Astro project:
1. Use Composition API with <script setup>
2. TypeScript with defineProps, defineEmits
3. Tailwind CSS for styling
4. Nanostore for global state
5. Zod for prop validation

## Component Template

```vue
<script setup lang="ts">
import { computed, ref } from 'vue'
import { z } from 'zod'

// Props schema
const propsSchema = z.object({
  title: z.string(),
  count: z.number().optional()
})

// Props
const props = defineProps<z.infer<typeof propsSchema>>()

// Emits
const emit = defineEmits<{
  update: [value: number]
  close: []
}>()

// State
const localCount = ref(props.count ?? 0)

// Computed
const displayText = computed(() => 
  `${props.title}: ${localCount.value}`
)

// Methods
function increment() {
  localCount.value++
  emit('update', localCount.value)
}
</script>

<template>
  <div class="rounded-lg border p-4">
    <h2 class="text-xl font-bold">{{ displayText }}</h2>
    <button
      @click="increment"
      class="mt-2 rounded bg-blue-500 px-4 py-2 text-white hover:bg-blue-600"
    >
      Increment
    </button>
  </div>
</template>
```

## Patterns

### Form Components
Use floating-ui/vue for popovers:
```vue
<script setup lang="ts">
import { useFloating } from '@floating-ui/vue'
// ...
</script>
```

### Headless UI Integration
```vue
<script setup lang="ts">
import { Combobox, ComboboxInput, ComboboxOptions } from '@headlessui/vue'
</script>
```

### Nanostore Integration
```vue
<script setup lang="ts">
import { useStore } from '@nanostores/vue'
import { $userStore } from '@/stores/user'

const user = useStore($userStore)
</script>
```

## File Naming
- PascalCase for components: `UserProfile.vue`
- Place in `src/components/`
- Group by feature: `src/components/auth/LoginForm.vue`

## Testing
Create test file: `ComponentName.spec.ts`
Use Vitest + Testing Library

## References
For more patterns, see [component-patterns.md](component-patterns.md)
```

### Component 2: Appwrite Integration Skill

**File:** `.claude/skills/appwrite-integration/SKILL.md`
```markdown
---
name: Appwrite Integration
description: Integrate with Appwrite for databases, authentication, and serverless functions. Use when working with backend.
version: 1.0.0
tags: [appwrite, backend, api]
---

# Appwrite Integration

## Client Setup

```typescript
// src/lib/appwrite.ts
import { Client, Account, Databases } from 'appwrite'

const client = new Client()
  .setEndpoint(import.meta.env.PUBLIC_APPWRITE_ENDPOINT)
  .setProject(import.meta.env.PUBLIC_APPWRITE_PROJECT_ID)

export const account = new Account(client)
export const databases = new Databases(client)
```

## Database Operations

### Create Document
```typescript
import { databases } from '@/lib/appwrite'
import { z } from 'zod'

const userSchema = z.object({
  name: z.string(),
  email: z.string().email(),
  role: z.enum(['user', 'admin'])
})

async function createUser(data: z.infer<typeof userSchema>) {
  const validated = userSchema.parse(data)
  
  return await databases.createDocument(
    'DATABASE_ID',
    'COLLECTION_ID',
    'unique()',
    validated
  )
}
```

### Query Documents
```typescript
import { Query } from 'appwrite'

const users = await databases.listDocuments(
  'DATABASE_ID',
  'COLLECTION_ID',
  [
    Query.equal('role', 'admin'),
    Query.limit(10)
  ]
)
```

## Authentication

### Email/Password
```typescript
import { account } from '@/lib/appwrite'

async function login(email: string, password: string) {
  return await account.createEmailSession(email, password)
}

async function register(email: string, password: string, name: string) {
  return await account.create('unique()', email, password, name)
}
```

## Serverless Functions

### Function Structure
```javascript
// functions/send-email/src/index.js
export default async ({ req, res, log, error }) => {
  try {
    const data = JSON.parse(req.body)
    // Process request
    return res.json({ success: true })
  } catch (err) {
    error(err.message)
    return res.json({ success: false }, 500)
  }
}
```

## Error Handling
Always wrap in try-catch:
```typescript
try {
  const result = await databases.createDocument(...)
  return result
} catch (err) {
  if (err instanceof AppwriteException) {
    console.error('Appwrite error:', err.message)
  }
  throw err
}
```

## Environment Variables
Required in `.env`:
```
PUBLIC_APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
PUBLIC_APPWRITE_PROJECT_ID=your-project-id
APPWRITE_API_KEY=your-api-key
```

## References
See [appwrite-examples.md](appwrite-examples.md)
```

### Component 3: New Component Slash Command

**File:** `.claude/commands/new-component.md`
```markdown
---
description: Create a new Vue 3 component with TypeScript, tests, and story
argument-hint: [component-name] [component-type]
model: claude-sonnet-4-20250514
---

# New Vue 3 Component

Create a complete Vue 3 component: $1 (type: $2)

## Component Types
- form: Form component with validation
- display: Display-only component
- interactive: Interactive UI element
- layout: Layout component

## Process

1. **Create Component File**
   Use vue-component-builder skill to create:
   `src/components/$1.vue`
   
   Follow these patterns:
   - Composition API with <script setup>
   - TypeScript
   - Zod schema for props
   - Tailwind CSS classes
   - Proper accessibility (ARIA labels)

2. **Create Test File**
   Delegate to test-engineer subagent:
   `src/components/$1.spec.ts`
   
   Include tests for:
   - Component renders
   - Props work correctly
   - Events emit properly
   - Edge cases

3. **Add to Index**
   Export from `src/components/index.ts`

4. **Documentation**
   Add JSDoc comments explaining:
   - Purpose
   - Props
   - Events
   - Usage example

## Example Usage
```bash
/new-component LoginForm form
/new-component UserCard display
/new-component DropdownMenu interactive
```

## Output
Links to created files and next steps.
```

### Component 4: Vue Specialist Subagent

**File:** `.claude/agents/vue-specialist.md`
```markdown
---
name: Vue 3 Specialist
description: MUST BE USED for Vue 3 component development, Composition API questions, and Vue-specific optimizations. Expert in Vue 3 + TypeScript + Tailwind.
tools: Read, Write, Edit, Bash(npm *)
model: sonnet
---

# Vue 3 Specialist

You are a Vue 3 expert specializing in modern Vue development with TypeScript.

## Expertise
- Vue 3 Composition API
- TypeScript integration
- Tailwind CSS + Headless UI
- State management (Nanostore)
- Performance optimization
- Accessibility best practices

## When Invoked
Handle tasks involving:
- Creating Vue components
- Refactoring to Composition API
- Type safety improvements
- Component performance optimization
- Complex reactive state
- Composable functions

## Approach

### Component Creation
1. Use <script setup lang="ts">
2. Define props with TypeScript + Zod
3. Use defineEmits for events
4. Implement with Composition API
5. Apply Tailwind classes
6. Add proper TypeScript types

### Best Practices
- Keep components under 200 lines
- Extract logic to composables
- Use computed for derived state
- Proper cleanup in onUnmounted
- Meaningful prop names
- Comprehensive TypeScript types

### Patterns

**Composable Pattern:**
```typescript
// composables/useAuth.ts
import { ref, computed } from 'vue'

export function useAuth() {
  const user = ref(null)
  const isAuthenticated = computed(() => !!user.value)
  
  async function login(email: string, password: string) {
    // ...
  }
  
  return { user, isAuthenticated, login }
}
```

**Form Pattern with Zod:**
```vue
<script setup lang="ts">
import { z } from 'zod'
import { ref } from 'vue'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

const form = ref({ email: '', password: '' })
const errors = ref<Record<string, string>>({})

function validate() {
  try {
    schema.parse(form.value)
    errors.value = {}
    return true
  } catch (err) {
    if (err instanceof z.ZodError) {
      errors.value = err.flatten().fieldErrors
    }
    return false
  }
}
</script>
```

## Context Discovery
Before creating components, check:
- `src/components/` - Existing patterns
- `tailwind.config.ts` - Theme configuration
- `src/composables/` - Available composables
- `package.json` - Installed packages

## Output Format
- Clean, typed Vue components
- Comprehensive inline comments
- Usage examples in JSDoc
- Test suggestions
```

### Component 5: Quality Pipeline Hooks

**File:** `.claude/settings.json`
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/format-vue.sh",
            "continue": true
          }
        ]
      }
    ]
  },
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write", "Read", "Notebook"],
    "deny": [".env*", "*.key", "*.pem", ".appwrite.json"]
  },
  "environment": {
    "NODE_ENV": "development"
  }
}
```

**File:** `.claude/hooks/format-vue.sh`
```bash
#!/bin/bash
# Format and validate Vue/TS files

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Only process Vue/TS files
if [[ "$file_path" =~ \.(vue|ts|astro)$ ]]; then
    echo "🎨 Formatting $file_path..."
    
    # Prettier
    npx prettier --write "$file_path" 2>&1 | grep -v "unchanged"
    
    # ESLint (only for .ts and .vue)
    if [[ "$file_path" =~ \.(vue|ts)$ ]]; then
        echo "🔍 Linting $file_path..."
        npx eslint --fix "$file_path" 2>&1 | grep -v "0 errors"
    fi
    
    echo "✅ Formatting complete"
fi

exit 0
```

**File:** `.claude/hooks/type-check.sh`
```bash
#!/bin/bash
# Run TypeScript type checking

echo "🔍 Type checking..."
npx tsc --noEmit

if [ $? -eq 0 ]; then
    echo "✅ Type checking passed"
else
    echo "❌ Type checking failed"
    exit 1
fi
```

---

## ADVANCED INTEGRATION EXAMPLES

### Example 1: Multi-Agent Code Review System

**Scenario:** Comprehensive code review using multiple specialized agents

```
USER: /review-pr 456

┌─────────────────────────────────────────────┐
│ SLASH COMMAND: review-pr                    │
│ Orchestrates entire review process          │
└─────────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────────┐
│ MCP: GitHub Server                          │
│ • Fetch PR diff                             │
│ • Get changed files                         │
│ • Read PR description                       │
└─────────────────────────────────────────────┘
         ↓ (parallel delegation)
    ┌────┴────┬────────┬────────┐
    ↓         ↓        ↓        ↓
┌─────┐  ┌──────┐ ┌──────┐ ┌───────┐
│Sec  │  │Test  │ │Perf  │ │Style  │
│Agent│  │Agent │ │Agent │ │Agent  │
└─────┘  └──────┘ └──────┘ └───────┘
    │         │        │        │
    └────┬────┴────────┴────────┘
         ↓ (aggregate results)
┌─────────────────────────────────────────────┐
│ MAIN AGENT                                  │
│ • Combine findings                          │
│ • Prioritize by severity                    │
│ • Generate review summary                   │
└─────────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────────┐
│ MCP: GitHub Server                          │
│ • Post review comment                       │
│ • Add labels                                │
│ • Request changes or approve                │
└─────────────────────────────────────────────┘
```

**Implementation:**

**File:** `.claude/commands/review-pr.md`
```markdown
---
description: Comprehensive PR review using specialized agents
argument-hint: [pr-number]
model: claude-sonnet-4-20250514
---

# PR Review Command

Review PR #$1 using multiple specialized agents.

## Process

1. **Fetch PR Data** (GitHub MCP)
   - Get PR diff
   - List changed files
   - Read description and comments

2. **Parallel Agent Reviews**
   
   **Security Review** (security-reviewer agent):
   - Check for XSS, SQL injection
   - Validate input sanitization
   - Review authentication/authorization
   - Scan for hardcoded secrets
   
   **Test Coverage** (test-engineer agent):
   - Verify tests exist for changes
   - Check test quality
   - Identify missing test cases
   - Validate mocks/fixtures
   
   **Performance Analysis** (performance-analyst agent):
   - Identify N+1 queries
   - Check algorithm complexity
   - Review database queries
   - Analyze bundle size impact
   
   **Code Style** (vue-specialist agent):
   - Vue best practices
   - TypeScript quality
   - Component structure
   - Accessibility issues

3. **Aggregate Results**
   - Combine all findings
   - Remove duplicates
   - Priority: Critical → High → Medium → Low
   - Generate summary report

4. **Post Review** (GitHub MCP)
   - Comment on PR with findings
   - Add labels (needs-work, security, performance)
   - Request changes if critical issues found
   - Approve if only minor issues

## Output Format
Markdown report with:
- Executive summary
- Findings by category and severity
- Code snippets showing issues
- Remediation suggestions
- Overall recommendation
```

**File:** `.claude/agents/security-reviewer.md`
```markdown
---
name: Security Reviewer
description: MUST BE USED for security reviews, vulnerability scanning, and OWASP Top 10 checks
tools: Read, Grep, Bash(npm audit)
model: opus
---

# Security Reviewer

You are a security expert focused on application security.

## Primary Mission
Find security vulnerabilities and provide remediation guidance.

## OWASP Top 10 Checklist

### 1. Injection Attacks
Search patterns:
```bash
# SQL injection
grep -rn "executeQuery.*\$\|query.*+" .

# Command injection
grep -rn "exec\|eval\|child_process" .
```

### 2. Broken Authentication
Check for:
- Weak password requirements
- Missing rate limiting
- Session management issues
- Missing MFA

### 3. Sensitive Data Exposure
```bash
grep -rn "password.*=\|api_key.*=\|secret.*=" .
```

### 4. XSS
```bash
grep -rn "innerHTML\|dangerouslySetInnerHTML\|v-html" .
```

### 5. Broken Access Control
Look for:
- Missing authorization checks
- Insecure direct object references
- Privilege escalation risks

### 6. Security Misconfiguration
Check:
- Default configurations
- Verbose error messages
- Unnecessary features enabled
- Missing security headers

### 7. Dependencies
```bash
npm audit --json
```

### 8-10. [Continue pattern...]

## Output Format
```markdown
# Security Review Report

## Critical Issues ⚠️
### [Issue Title]
- **File**: `path/to/file:line`
- **Severity**: Critical
- **Issue**: [Description]
- **Remediation**: [Fix]
- **Code**:
  ```typescript
  // Vulnerable
  const result = executeQuery(userInput);
  
  // Fixed
  const result = executeQuery(sanitize(userInput));
  ```

## High Priority
[Same format]

## Medium Priority
[Same format]

## Recommendations
1. [General improvement]
2. [Additional security measure]
```
```

### Example 2: Intelligent Documentation Generation

**Scenario:** Generate comprehensive documentation from code

```
OUTPUT STYLE: technical-writer
    ↓
SKILL: code-to-docs
    ↓
SUBAGENT: doc-generator
    ↓
HOOK: PostToolUse (validate markdown)
```

**File:** `.claude/output-styles/technical-writer.md`
```markdown
---
name: Technical Writer
description: Create clear, comprehensive technical documentation with examples
---

# Technical Writer

## Purpose
You create developer-focused documentation that is:
- Clear and concise
- Example-driven
- Properly structured
- Accessible to different skill levels

## Documentation Principles

### Structure
1. **Overview**: What it does (1 paragraph)
2. **Quick Start**: Get running in 5 minutes
3. **API Reference**: Complete details
4. **Examples**: Common use cases
5. **Troubleshooting**: Common issues

### Writing Style
- Use present tense
- Active voice
- Short sentences
- Code examples for every concept
- No jargon without explanation

### Code Examples
Always include:
- Complete, runnable examples
- Comments explaining non-obvious parts
- Common variations
- Error handling

### Diagrams
Use mermaid for:
- Architecture diagrams
- Sequence diagrams
- State machines
- Data flow

## Markdown Format

### Headers
- H1: Document title
- H2: Major sections
- H3: Subsections
- H4: Details

### Code Blocks
Always specify language:
```typescript
// Good
function example() {}
```

### Links
- Descriptive text, not "click here"
- Internal links relative
- External links absolute

### Tables
For API references, options, configurations

## Context Discovery
Before documenting, check:
- `README.md` - Project overview
- `package.json` - Dependencies
- `tsconfig.json` - TypeScript config
- Existing docs in `docs/`
- Code comments in source
```

**File:** `.claude/skills/code-to-docs/SKILL.md`
```markdown
---
name: Code to Documentation
description: Generate comprehensive documentation from source code. Use when creating API docs, component docs, or guides.
---

# Code to Documentation

## Process

### 1. Code Analysis
Read source files and extract:
- Exported functions/classes
- Function signatures
- JSDoc comments
- TypeScript types
- Usage examples in tests
- Import/export patterns

### 2. Structure Generation
Create documentation with:
- API reference (alphabetical)
- Type definitions
- Examples from tests
- Related types/interfaces

### 3. Format
Use markdown with:
```markdown
# Component/Module Name

Brief description from JSDoc or code.

## Installation
[If applicable]

## Usage

### Basic Example
```typescript
import { Thing } from './thing'

const example = new Thing()
```

### Advanced Examples
[From tests or complex use cases]

## API Reference

### `functionName(param: Type): ReturnType`

Description from JSDoc.

**Parameters:**
- `param` (Type): Description

**Returns:** ReturnType - Description

**Example:**
```typescript
const result = functionName('value')
```

## Types

### `TypeName`
```typescript
interface TypeName {
  prop: string
}
```

## Troubleshooting

### Common Issue 1
**Problem:** Error message
**Solution:** How to fix
```

### 4. Cross-Referencing
Link to:
- Related components
- Used by / uses
- Type definitions
- Examples

### 5. Validation
Check generated docs for:
- All exports documented
- Examples are complete
- Links work
- Code blocks have language
- TypeScript examples type-check
```

---

## BEST PRACTICES & ANTI-PATTERNS

### Best Practices

#### 1. Progressive Complexity
```
✅ GOOD: Build features incrementally

CLAUDE.md → Basic instructions
    ↓
Skills → Domain knowledge (when needed)
    ↓
Subagents → Specialized tasks (when needed)
    ↓
Hooks → Automation (when stable)
    ↓
MCP → External data (when required)

❌ BAD: Everything at once
- 10 skills from day 1
- 5 subagents immediately
- Complex hooks before workflow is stable
```

#### 2. Description Specificity
```
✅ GOOD: Specific triggers
"MUST BE USED for Vue 3 component creation with TypeScript
 and Composition API. Use when creating .vue files."

❌ BAD: Vague
"Helps with components"
```

#### 3. Skill Granularity
```
✅ GOOD: Focused skills
- vue-component-builder: Vue components
- api-integration: API calls
- form-validation: Form handling

❌ BAD: Mega-skills
- frontend-skill: Everything frontend
```

#### 4. Hook Performance
```
✅ GOOD: Selective hooks
PostToolUse + matcher: "Edit|Write"
  → Only runs for file operations

❌ BAD: All tools
PreToolUse + matcher: ""
  → Runs for EVERY tool call
```

#### 5. Subagent Specialization
```
✅ GOOD: Clear specialization
- test-engineer: Write tests
- security-reviewer: Security only
- performance-analyst: Performance only

❌ BAD: General agents
- code-helper: "Does everything"
```

### Anti-Patterns

#### Anti-Pattern 1: Circular Dependencies
```
❌ PROBLEM:
Skill A references Skill B
Skill B references Skill A
→ Infinite loop

✅ SOLUTION:
Create shared skill with common functionality
Skills A and B both reference shared skill
```

#### Anti-Pattern 2: Over-Automation
```
❌ PROBLEM:
Hooks that:
- Make git commits without user review
- Deploy to production automatically
- Delete files without confirmation

✅ SOLUTION:
- Hooks for formatting, linting, testing
- User confirms destructive operations
- Staging deployments only
```

#### Anti-Pattern 3: Skill Overload
```
❌ PROBLEM:
20+ skills loaded
→ Token waste, slow discovery

✅ SOLUTION:
5-10 essential skills maximum
Archive unused skills
Use project-specific vs user-level intelligently
```

#### Anti-Pattern 4: Unclear Invocation
```
❌ PROBLEM:
Command description: "Does stuff"
Skill description: "Helpful skill"
Agent description: "Assists with tasks"
→ Claude can't decide when to use

✅ SOLUTION:
Clear, specific trigger conditions:
"MUST BE USED when [specific condition]"
```

#### Anti-Pattern 5: MCP Overuse
```
❌ PROBLEM:
MCP server for static data
→ Slow, network dependent

✅ SOLUTION:
Skills for static knowledge
MCP for dynamic/external data only
```

---

## EDGE CASES & TROUBLESHOOTING

### Edge Case 1: Skill Not Being Used

**Symptom:** Claude doesn't use your skill even when appropriate

**Diagnosis:**
1. Check description specificity
2. Verify SKILL.md has frontmatter
3. Ensure skill is in correct directory
4. Check for name conflicts (project vs user)

**Solutions:**
```yaml
# ❌ Too vague
description: Helpful for components

# ✅ Specific triggers
description: |
  Create Vue 3 components with TypeScript and Composition API.
  MUST BE USED when creating .vue files or when user requests
  "create component" or "new component".
```

### Edge Case 2: Subagent Not Being Invoked

**Symptom:** Task seems perfect for subagent, but not delegated

**Diagnosis:**
1. Check agent description has "MUST BE USED"
2. Verify agent is in `.claude/agents/`
3. Check tool permissions (agent may lack needed tools)

**Solutions:**
```yaml
# ❌ Passive description
description: Can help with security reviews

# ✅ Imperative description
description: MUST BE USED for security reviews, vulnerability scans, and OWASP Top 10 checks. Expert in application security.
```

### Edge Case 3: Hooks Not Firing

**Symptom:** Hook command not executing

**Diagnosis:**
```bash
# Enable debug mode
export CLAUDE_DEBUG=1
claude

# Look for:
[HOOKS] Executing hook: PreToolUse
[HOOKS] Hook exit code: 0
```

**Common Issues:**
1. **Matcher doesn't match:**
   ```json
   // Wrong
   {"matcher": "edit"}  // lowercase
   
   // Right
   {"matcher": "Edit"}  // exact tool name
   ```

2. **Script not executable:**
   ```bash
   chmod +x .claude/hooks/format.sh
   ```

3. **Script path wrong:**
   ```json
   // Wrong (relative)
   {"command": "./format.sh"}
   
   // Right (absolute)
   {"command": ".claude/hooks/format.sh"}
   ```

### Edge Case 4: MCP Server Won't Connect

**Symptom:** "MCP server failed to connect"

**Diagnosis:**
```bash
# Check logs
claude --debug

# Look for:
[MCP] Spawning server: github
[MCP] Server output: [error message]
```

**Common Issues:**
1. **Environment variable not set:**
   ```bash
   echo $GITHUB_TOKEN
   # Should output token, not empty
   ```

2. **Command not found:**
   ```bash
   # Test manually
   npx -y @anthropic-ai/mcp-github-server
   ```

3. **Wrong syntax:**
   ```json
   // Wrong
   {"env": {"TOKEN": "$GITHUB_TOKEN"}}
   
   // Right
   {"env": {"TOKEN": "${GITHUB_TOKEN}"}}
   ```

### Edge Case 5: Output Style Not Changing Behavior

**Symptom:** Output style loaded but Claude acts the same

**Diagnosis:**
1. Verify style is actually loaded: `/output-style`
2. Check style file has frontmatter
3. Verify file is in correct directory

**Understanding:**
Output styles replace system prompt but:
- ✅ Change personality, reasoning style
- ✅ Change response format
- ❌ Don't change available tools
- ❌ Don't change project context
- ❌ Don't add new capabilities

**Solution:**
Combine output style with skills for capabilities:
```
Output Style: Research mode (personality)
    +
Skill: Web research (capability)
    =
Research-focused Claude with web research skills
```

### Edge Case 6: Command Arguments Not Working

**Symptom:** `$1`, `$2` not replaced in command

**Common Issues:**
1. **Quotes matter:**
   ```bash
   # Wrong - shell interprets $1
   /command arg1 arg2
   
   # Right - pass as string
   /command "arg1 arg2"
   ```

2. **Positional args only work if arguments provided:**
   ```markdown
   # In command file:
   Process $1 and $2
   
   # Must invoke with args:
   /command arg1 arg2
   ```

### Edge Case 7: Skill Loading Performance

**Symptom:** Claude takes long time to start

**Diagnosis:**
Too many skills with large SKILL.md files

**Solutions:**
1. **Use progressive disclosure:**
   ```
   SKILL.md (small, 200-500 tokens)
   ├── Quick start
   ├── Basic instructions
   └── Links to detailed docs
   
   detailed-guide.md (large, loaded on demand)
   examples.md (loaded on demand)
   api-reference.md (loaded on demand)
   ```

2. **Archive unused skills:**
   ```bash
   mkdir .claude/skills-archive
   mv .claude/skills/unused-skill .claude/skills-archive/
   ```

3. **Use project-level strategically:**
   ```
   User level (~/.claude/skills/):
   - Personal, cross-project skills
   
   Project level (.claude/skills/):
   - Project-specific only
   ```

### Edge Case 8: Conflicts Between Features

**Symptom:** Features interfering with each other

**Scenarios:**

1. **Skill vs Subagent overlap:**
   ```
   Problem: Both handle same task
   Solution: 
   - Skill = Knowledge
   - Subagent = Delegation
   
   Example:
   - vue-component-builder (Skill)
     → Knowledge about Vue patterns
   - vue-specialist (Subagent)
     → Separate agent for complex Vue work
   ```

2. **Hook timing issues:**
   ```
   Problem: Hook runs before tool completes
   Solution: Use PostToolUse, not PreToolUse
   ```

3. **Command + Subagent confusion:**
   ```
   Problem: Command explicitly calls subagent, but wrong one used
   Solution: Use exact agent name:
   "Use the test-engineer subagent" (specific)
   not "Use a testing agent" (ambiguous)
   ```

---

## COMPLETE PROJECT SETUP GUIDE

### Initial Setup (One Time)

#### Step 1: Create Directory Structure
```bash
cd my-astro-project

# Create .claude directory
mkdir -p .claude/{commands,agents,skills,output-styles,hooks}

# Create files
touch .claude/settings.json
touch .claude/CLAUDE.md

# Create hooks
touch .claude/hooks/{format.sh,type-check.sh,validate.py}
chmod +x .claude/hooks/*.sh .claude/hooks/*.py
```

#### Step 2: Configure Git
```bash
# .gitignore
cat >> .gitignore << 'EOF'
# Claude local settings
.claude/settings.local.json
.claude/.mcp.json

# Hook dependencies
.claude/hooks/node_modules/
EOF

# Commit project settings
git add .claude/settings.json
git add .claude/commands/
git add .claude/agents/
git add .claude/skills/
git commit -m "Add Claude Code configuration"
```

#### Step 3: Base Settings
```bash
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write", "Read", "Notebook"],
    "deny": [".env*", "*.key", "*.pem", ".appwrite.json"]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/format.sh",
            "continue": true
          }
        ]
      }
    ]
  },
  "model": "claude-sonnet-4-20250514"
}
EOF
```

#### Step 4: Create CLAUDE.md
```bash
cat > CLAUDE.md << 'EOF'
# Project Context

## Tech Stack
- **Frontend**: Astro + Vue 3
- **Styling**: Tailwind CSS
- **State**: Nanostore
- **Backend**: Appwrite (databases, auth, functions)
- **Language**: TypeScript
- **Validation**: Zod
- **UI Components**: Headless UI, Floating UI

## Project Structure
```
src/
├── components/    # Vue 3 components
├── pages/         # Astro pages
├── layouts/       # Astro layouts
├── lib/           # Utilities, Appwrite client
├── stores/        # Nanostore stores
└── types/         # TypeScript types
```

## Conventions

### Components
- PascalCase names: `UserProfile.vue`
- Composition API with <script setup>
- Props with Zod schemas
- Tailwind for styling

### Files
- TypeScript everywhere
- Named exports preferred
- One component per file

### Git
- Conventional commits: `feat:`, `fix:`, `docs:`
- Branch naming: `feature/description`, `fix/issue-number`

## Commands
- `npm run dev` - Start dev server
- `npm run build` - Build for production
- `npm run preview` - Preview build
- `npm test` - Run tests
- `npm run lint` - ESLint
- `npm run format` - Prettier
EOF
```

### Adding Features

#### Add First Skill: Vue Component Builder
```bash
mkdir -p .claude/skills/vue-component-builder
cat > .claude/skills/vue-component-builder/SKILL.md << 'EOF'
---
name: Vue 3 Component Builder
description: Create Vue 3 components with TypeScript and Composition API. Use when creating .vue files or when user requests "create component".
version: 1.0.0
tags: [vue3, typescript]
---

# Vue 3 Component Builder

## Template
```vue
<script setup lang="ts">
import { ref } from 'vue'
import { z } from 'zod'

const props = defineProps<{
  title: string
}>()

const emit = defineEmits<{
  update: [value: string]
}>()
</script>

<template>
  <div class="rounded-lg border p-4">
    <!-- Component content -->
  </div>
</template>
```

## Rules
- Always use Composition API
- TypeScript for all props/emits
- Tailwind CSS classes
- Zod for validation
EOF
```

#### Add First Subagent: Vue Specialist
```bash
cat > .claude/agents/vue-specialist.md << 'EOF'
---
name: Vue 3 Specialist
description: MUST BE USED for Vue 3 component development, Composition API questions, and Vue-specific optimizations
tools: Read, Write, Edit
model: sonnet
---

# Vue 3 Specialist

You are a Vue 3 expert specializing in TypeScript and Composition API.

## Approach
1. Use <script setup lang="ts">
2. Composition API patterns
3. Proper TypeScript types
4. Tailwind CSS styling
5. Accessibility (ARIA)

## When Invoked
- Creating Vue components
- Refactoring to Composition API
- Vue-specific problems
- Component optimization
EOF
```

#### Add First Command: New Component
```bash
cat > .claude/commands/new-component.md << 'EOF'
---
description: Create new Vue 3 component with tests
argument-hint: [component-name]
---

# New Component: $1

1. Create component file: `src/components/$1.vue`
2. Use vue-component-builder skill for structure
3. Delegate to test-engineer for tests
4. Export from `src/components/index.ts`
EOF
```

#### Add First Hook: Auto-Format
```bash
cat > .claude/hooks/format.sh << 'EOF'
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

if [[ "$file_path" =~ \.(vue|ts|astro)$ ]]; then
    npx prettier --write "$file_path" 2>&1 | head -n 1
    npx eslint --fix "$file_path" 2>&1 | head -n 1
fi
exit 0
EOF

chmod +x .claude/hooks/format.sh
```

### Testing Setup

#### Test First Skill
```bash
# Start Claude
claude

# In Claude:
"Create a Vue component called TestCard"

# Should:
# 1. Use vue-component-builder skill
# 2. Create properly structured component
# 3. Auto-format with hook
```

#### Test First Command
```bash
# In Claude:
"/new-component UserProfile"

# Should:
# 1. Create UserProfile.vue
# 2. Create UserProfile.spec.ts
# 3. Update index.ts
```

#### Test First Subagent
```bash
# In Claude:
"I need a complex Vue component with advanced reactivity"

# Should delegate to vue-specialist subagent
# Look for: Task(vue-specialist) in logs
```

### Gradual Enhancement

#### Week 1: Core Setup
- ✅ CLAUDE.md
- ✅ 1-2 essential skills
- ✅ 1 key subagent
- ✅ Format hook
- ⬜ Commands
- ⬜ MCP
- ⬜ Output styles

#### Week 2: Workflows
- ✅ 2-3 slash commands
- ✅ Test coverage hook
- ⬜ Additional skills
- ⬜ MCP integration

#### Week 3: Specialization
- ✅ Domain-specific skills
- ✅ 2-3 more subagents
- ✅ Custom output style
- ⬜ MCP servers

#### Week 4: Optimization
- ✅ MCP for external data
- ✅ Advanced hooks
- ✅ Team patterns documented
- ✅ CI/CD integration

### Maintenance

#### Monthly Review
```bash
# Check what's actually used
claude --stats  # If available, or manually review

# Archive unused features
mv .claude/skills/unused .claude/skills-archive/

# Update descriptions based on usage
# Refine hooks based on performance
```

#### Team Sync
```bash
# Commit changes
git add .claude/
git commit -m "chore: update Claude Code configuration"

# Team documentation
echo "## Claude Code Setup" >> docs/development.md
echo "See .claude/ for configuration" >> docs/development.md
```

---

## QUICK REFERENCE

### Component Priority (Highest to Lowest)

1. **CLAUDE.md** - Always loaded, base context
2. **Output Style** - Active style's system prompt
3. **Settings** - Permissions, env vars, MCP, hooks
4. **Skills** - Model discovers, loads on demand
5. **Subagents** - Model delegates when needed
6. **Commands** - User explicitly invokes
7. **Hooks** - Execute on lifecycle events

### File Locations Cheat Sheet

```
.claude/
├── CLAUDE.md              # Project context (always read)
├── settings.json          # Configuration (committed)
├── settings.local.json    # Local overrides (not committed)
│
├── commands/              # Slash commands
│   └── command-name.md    # /command-name
│
├── agents/                # Subagents
│   └── agent-name.md      # Delegated to by Claude
│
├── skills/                # Skills
│   └── skill-name/
│       └── SKILL.md       # Discovered by Claude
│
├── output-styles/         # Output styles
│   └── style-name.md      # /output-style style-name
│
└── hooks/                 # Hook scripts
    └── script.sh          # Called by lifecycle events
```

### Decision Tree

```
Need different personality? → Output Style
Need to trigger manually? → Slash Command
Need specialized knowledge? → Skill
Need separate specialist? → Subagent
Must always run? → Hook
Need external data? → MCP Server
Need project guidelines? → CLAUDE.md
```

### Common Workflows

**Creating a feature:**
```
CLAUDE.md (context)
    ↓
Skill (domain knowledge)
    ↓
Tool execution
    ↓
Hook (format/test)
    ↓
Subagent (tests/security)
```

**Code review:**
```
Command (/review-pr)
    ↓
MCP (fetch PR)
    ↓
Multiple Subagents (parallel)
    ↓
Aggregate results
    ↓
MCP (post review)
```

**Research & document:**
```
Output Style (researcher)
    ↓
Skill (web-research)
    ↓
MCP (web search)
    ↓
Hook (validate markdown)
```

---

## CONCLUSION

This integration guide demonstrates that Claude Code's power comes from **intelligent combination** of features:

1. **Start Simple**: CLAUDE.md + 1-2 skills
2. **Add Gradually**: Commands → Subagents → Hooks → MCP
3. **Specialize**: Domain-specific skills, output styles
4. **Automate**: Hooks for repetitive tasks
5. **Integrate**: MCP for external systems

**Key Principles:**
- Features complement, don't duplicate
- Clear descriptions enable discovery
- Progressive disclosure prevents overload
- Hooks guarantee execution
- MCP bridges external systems

**For Your Stack (Vue 3 + Astro + Appwrite):**
- Skills for framework patterns
- Subagents for specialized tasks
- Commands for common workflows
- Hooks for quality assurance
- MCP for Appwrite integration

Start with the essential features, measure their impact, and expand based on actual usage patterns. The ecosystem is designed to scale from simple projects to complex, team-based development.

---

**Next Steps:**
1. Implement the basic setup from the guide
2. Test with a real feature
3. Refine based on experience
4. Add features as needs emerge
5. Share successful patterns with team

Good luck building with Claude Code! 🚀
