# Workflow Engine v2 - Complete Requirements

## Core Requirements

### 1. Basic Workflow Execution
- **REQ-1.1**: Load workflow definitions from YAML files
- **REQ-1.2**: Execute phases sequentially by default
- **REQ-1.3**: Support workflow-level variables and context
- **REQ-1.4**: Generate final deliverables based on templates
- **REQ-1.5**: Create metadata files tracking execution
- **REQ-1.6**: Preserve research artifacts in .temp/ folders

### 2. Phase Execution Modes
- **REQ-2.1**: **Strict Mode** - Follow phase definition exactly, no deviations
- **REQ-2.2**: **Loose Mode** - Main agent has freedom to choose approach
- **REQ-2.3**: **Adaptive Mode** - Main agent decides which subagents to spawn based on context
- **REQ-2.4**: Support mixed modes across phases in same workflow

### 3. Phase Behaviors
- **REQ-3.1**: **Parallel Behavior** - Spawn multiple subagents simultaneously
- **REQ-3.2**: **Sequential Behavior** - Execute subagents one at a time
- **REQ-3.3**: **Main-Only Behavior** - No subagents, main agent executes phase logic
- **REQ-3.4**: Support behavior configuration per phase

### 4. Subagent Orchestration
- **REQ-4.1**: Spawn subagents from registry with Task tool
- **REQ-4.2**: Support parallel subagent execution (2-5 simultaneous)
- **REQ-4.3**: Support sequential subagent execution
- **REQ-4.4**: Pass workflow-specific prompts to subagents
- **REQ-4.5**: Support conditional subagent spawning (--frontend, --backend, --both)
- **REQ-4.6**: Support adaptive subagent selection via inline scripts
- **REQ-4.7**: Track subagent outputs and deliverables
- **REQ-4.8**: Handle subagent failures gracefully

### 5. Subagent Prompt Customization
- **REQ-5.1**: Define workflow-specific prompts for each subagent
- **REQ-5.2**: Support prompt templates with variable substitution
- **REQ-5.3**: Pass phase context to subagent prompts (previous phase results, scope, etc.)
- **REQ-5.4**: Define deliverable locations in prompts
- **REQ-5.5**: Specify scope and constraints per workflow

### 6. Human-in-the-Loop
- **REQ-6.1**: Support approval checkpoints before phase execution
- **REQ-6.2**: Display deliverables to user for review
- **REQ-6.3**: Provide multiple options (proceed, retry, skip, abort)
- **REQ-6.4**: Support user feedback collection
- **REQ-6.5**: Allow conditional approval (only in certain conditions)
- **REQ-6.6**: Support phase repetition with feedback
- **REQ-6.7**: Allow skipping remaining phases

### 7. Deliverables Management
- **REQ-7.1**: Define required deliverables per phase
- **REQ-7.2**: Define optional deliverables per phase
- **REQ-7.3**: Validate deliverable existence before proceeding
- **REQ-7.4**: Support custom deliverable paths per workflow
- **REQ-7.5**: Track all deliverables in metadata

### 8. Gap Checks
- **REQ-8.1**: Execute gap checks after designated phases
- **REQ-8.2**: Support custom gap check criteria per phase
- **REQ-8.3**: Support inline scripts for gap check logic
- **REQ-8.4**: Handle gap check failures (retry, spawn additional agents, abort)
- **REQ-8.5**: Track gap check results in metadata

### 9. Skills Integration
- **REQ-9.1**: Invoke Claude Code skills from phases
- **REQ-9.2**: Pass arguments to skills
- **REQ-9.3**: Support conditional skill invocation
- **REQ-9.4**: Track skill invocations in metadata

### 10. Inline Scripting
- **REQ-10.1**: Execute JavaScript/pseudocode scripts in phase definitions
- **REQ-10.2**: Access context variables in scripts
- **REQ-10.3**: Return values from scripts to control flow
- **REQ-10.4**: Support main agent "thinkHard" in scripts
- **REQ-10.5**: Support file reading/writing in scripts
- **REQ-10.6**: Handle script errors gracefully

## Advanced Requirements

### 11. Dynamic Phase Control
- **REQ-11.1**: Skip phases based on conditions
- **REQ-11.2**: Repeat phases with feedback
- **REQ-11.3**: Jump to specific phases
- **REQ-11.4**: Execute phases in parallel groups
- **REQ-11.5**: Support phase dependencies (depends_on)

### 12. Workflow Composition
- **REQ-12.1**: Inherit phases from other workflows (extends)
- **REQ-12.2**: Override inherited phase configuration
- **REQ-12.3**: Compose workflows from reusable phase libraries

### 13. Conditional Execution
- **REQ-13.1**: Conditional phase execution (skip_if)
- **REQ-13.2**: Conditional subagent spawning
- **REQ-13.3**: Conditional skill invocation
- **REQ-13.4**: Conditional checkpoint activation

### 14. Iteration & Retry
- **REQ-14.1**: Support max_iterations per phase
- **REQ-14.2**: Automatic retry on gap check failure
- **REQ-14.3**: Escalation to human on max iterations
- **REQ-14.4**: Track iteration count in metadata

### 15. Template System
- **REQ-15.1**: Mustache templates for subagent prompts
- **REQ-15.2**: Variable substitution in templates
- **REQ-15.3**: Conditional sections in templates
- **REQ-15.4**: Template inheritance
- **REQ-15.5**: Template partials for reuse

### 16. Context Management
- **REQ-16.1**: Maintain workflow context across phases
- **REQ-16.2**: Pass data between phases
- **REQ-16.3**: Access user input in context
- **REQ-16.4**: Access previous phase outputs
- **REQ-16.5**: Store intermediate results

### 17. Backward Compatibility
- **REQ-17.1**: Existing JSON workflows must work unchanged
- **REQ-17.2**: Provide converter tool (JSON → YAML)
- **REQ-17.3**: Support legacy subagent selection matrix
- **REQ-17.4**: Support legacy phase registry
- **REQ-17.5**: Support legacy templates

### 18. Error Handling
- **REQ-18.1**: Graceful handling of subagent failures
- **REQ-18.2**: Graceful handling of script errors
- **REQ-18.3**: Graceful handling of missing deliverables
- **REQ-18.4**: Provide actionable error messages
- **REQ-18.5**: Support rollback on critical failures

### 19. Metadata & Tracking
- **REQ-19.1**: Track workflow execution time
- **REQ-19.2**: Track token usage estimates
- **REQ-19.3**: Track subagents spawned
- **REQ-19.4**: Track phases executed
- **REQ-19.5**: Track iterations and retries
- **REQ-19.6**: Track user decisions at checkpoints
- **REQ-19.7**: Generate execution summary

### 20. Claude Code Skills Environment
- **REQ-20.1**: Work within Claude Code skill execution context
- **REQ-20.2**: Use only available tools (Read, Write, Bash, Grep, Glob)
- **REQ-20.3**: No external dependencies (no npm packages)
- **REQ-20.4**: Pure shell scripts + markdown documentation
- **REQ-20.5**: Invoke subagents via Task tool properly
- **REQ-20.6**: Invoke skills via Skill tool properly
- **REQ-20.7**: Work within token limits (200K context)
- **REQ-20.8**: Progressive disclosure of documentation
- **REQ-20.9**: Compatible with main agent execution model

### 21. Workflow Definition Features
- **REQ-21.1**: Declarative YAML structure
- **REQ-21.2**: Inline JavaScript scripts for logic
- **REQ-21.3**: Comments and documentation in YAML
- **REQ-21.4**: Schema validation for YAML
- **REQ-21.5**: Default values for optional fields

### 22. Subagent Pool Management
- **REQ-22.1**: Limit simultaneous subagents (max 5)
- **REQ-22.2**: Queue subagents if pool full
- **REQ-22.3**: Track subagent status (pending, running, complete, failed)
- **REQ-22.4**: Cancel running subagents on workflow abort

### 23. Finalization
- **REQ-23.1**: Generate final plan from template
- **REQ-23.2**: Aggregate all phase deliverables
- **REQ-23.3**: Create metadata.json
- **REQ-23.4**: Create archives directory
- **REQ-23.5**: Report completion to user

### 24. User Experience
- **REQ-24.1**: Clear progress indication per phase
- **REQ-24.2**: Estimated time and token usage shown upfront
- **REQ-24.3**: Announce workflow plan before execution
- **REQ-24.4**: Show subagents spawned per phase
- **REQ-24.5**: Display gap check results
- **REQ-24.6**: Clear checkpoint prompts with context

### 25. Extensibility
- **REQ-25.1**: Easy to add new workflows
- **REQ-25.2**: Easy to add new phases
- **REQ-25.3**: Easy to add new subagents
- **REQ-25.4**: Easy to customize existing workflows
- **REQ-25.5**: Plugin system for custom behaviors

## Non-Functional Requirements

### Performance
- **REQ-NFR-1**: Workflow loading < 1 second
- **REQ-NFR-2**: YAML parsing < 500ms
- **REQ-NFR-3**: Support workflows up to 20 phases
- **REQ-NFR-4**: Support up to 50 subagents per workflow

### Reliability
- **REQ-NFR-5**: Gracefully handle partial execution
- **REQ-NFR-6**: Preserve research on failure
- **REQ-NFR-7**: Resume capability from checkpoints

### Maintainability
- **REQ-NFR-8**: Clear code structure and documentation
- **REQ-NFR-9**: Separation of concerns (engine, phases, subagents)
- **REQ-NFR-10**: Testable components

### Usability
- **REQ-NFR-11**: Clear error messages with context
- **REQ-NFR-12**: Helpful examples and templates
- **REQ-NFR-13**: Progressive disclosure of complexity

## Implementation Constraints

### Claude Code Environment Constraints
- **CONST-1**: No Node.js execution (skill runs in Claude context)
- **CONST-2**: No npm packages or external libraries
- **CONST-3**: Must use Bash for scripting execution
- **CONST-4**: Must use Read/Write for file operations
- **CONST-5**: Must use Task tool for subagent spawning
- **CONST-6**: Must use Skill tool for skill invocation
- **CONST-7**: YAML parsing via yq or Python/Ruby
- **CONST-8**: JavaScript execution via Node.js installed on system
- **CONST-9**: Template rendering via mustache CLI or custom parser

### Design Constraints
- **CONST-10**: Backward compatible with existing workflows
- **CONST-11**: YAML as primary config format
- **CONST-12**: Scripts must be inline in YAML (no separate .js files initially)
- **CONST-13**: Main agent coordinates all execution
- **CONST-14**: No subagent-spawned subagents (flat hierarchy)

## Success Criteria

### Must Have
1. All 5 existing workflows work unchanged
2. Support strict/loose/adaptive execution modes
3. Human-in-the-loop checkpoints functional
4. Workflow-specific subagent prompts working
5. Skills integration working
6. Phase behaviors (parallel/sequential/main-only) working
7. Gap checks with custom logic working
8. Custom deliverables per workflow

### Should Have
1. Workflow composition (extends)
2. Conditional phase execution
3. Iteration limits and retry logic
4. Template system with variable substitution
5. Parallel phase execution
6. Converter tool (JSON → YAML)

### Nice to Have
1. Plugin system for custom behaviors
2. Resume from checkpoint capability
3. Visual workflow diagram generation
4. Workflow validation CLI tool
5. Unit tests for engine components

## Out of Scope (Future Work)
- GUI workflow editor
- Distributed execution (cloud)
- Real-time collaboration
- Workflow marketplace
- Version control integration
- CI/CD integration
- Metrics dashboard
- A/B testing workflows
