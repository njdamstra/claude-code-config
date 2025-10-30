# Research-First Implementation Workflow

## Overview
This workflow implements Jason Zhou's research-focused approach: specialist agents research and plan, main agent implements with full context.

## Phase 1: Research & Planning (Token-Optimized)

### Step 1: Context Priming
```bash
/prime [domain] [project-area]
```
- Load domain-specific context
- Activate relevant agent awareness
- Minimize initial token consumption

### Step 2: Research Delegation
```bash
/research [topic] [agent-type] [focus-area]
```
- Spawn specialist research agent
- Agent investigates with minimal context
- Returns focused implementation plan
- **No token pollution** in main context

### Step 3: Research Compilation
- Collect research summaries from specialist agents
- Create focused implementation brief
- Identify file modification targets
- Plan testing and validation approach

## Phase 2: Implementation (Full Context)

### Step 4: Implementation Setup
- Main agent receives research summaries
- Load full project context for implementation
- Access to all files for debugging and integration

### Step 5: Focused Implementation
- Follow research-provided implementation plan
- Make changes to identified files
- Maintain architectural consistency
- Implement proper error handling

### Step 6: Integration Testing
- Run project-specific test commands
- Validate integration with existing code
- Check for breaking changes
- Performance impact assessment

## Phase 3: Validation & Documentation

### Step 7: Code Review (Optional)
```bash
@code-review [files-changed] [implementation-summary]
```
- Only if quality concerns identified
- Focus on security and performance
- Validate against project standards

### Step 8: Documentation Update
```bash
@service-documentation [changes-made] [api-impacts]
```
- Only if API or public interfaces changed
- Update relevant documentation
- Maintain documentation consistency

### Step 9: Context Bundling
```bash
/bundle save [session-name]
```
- Save session state for future reference
- Document implementation decisions
- Create restoration guide

## Token Optimization Benefits

### Research Phase Savings
- Specialist agents work with minimal context
- Research summaries vs full file access
- No context pollution from exploration

### Implementation Phase Efficiency
- Main agent gets focused guidance
- Full context available for debugging
- Reduced trial-and-error iterations

### Expected Token Savings: 40-60%

## Usage Examples

### TypeScript Feature Implementation
```bash
/prime typescript components
/research "React hook patterns" typescript-master "state management"
# Research agent provides implementation approach
# Main agent implements with full project context
/bundle save typescript-hooks-feature
```

### Vue Component Creation
```bash
/prime vue components
/research "SSR component patterns" astro-vue-architect "hydration strategies"
# Research agent analyzes SSR requirements
# Main agent creates component with proper SSR handling
@code-review src/components/NewComponent.vue "SSR compatibility"
```

### Python Pipeline Enhancement
```bash
/prime python data-processing
/research "async data processing" python-pipeline-architect "performance optimization"
# Research agent provides async patterns
# Main agent implements with proper error handling
/bundle save async-pipeline-upgrade
```

## Success Metrics
- **Research Quality**: Comprehensive investigation with minimal tokens
- **Implementation Speed**: Focused development with clear guidance
- **Code Quality**: Maintainable, tested, documented solutions
- **Token Efficiency**: 40-60% reduction vs traditional approach