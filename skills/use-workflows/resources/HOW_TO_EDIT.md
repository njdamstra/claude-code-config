# How to Edit the Planner Skill

This document provides a comprehensive guide to understanding, modifying, and extending the `planner` skill. It is designed for developers who need to customize planning workflows, add new capabilities, or debug the planning process.

## Part 1: How the Planner Skill Works

The `planner` skill is a sophisticated multi-agent orchestration system designed to generate detailed implementation plans. It operates on a hierarchical structure of Workflows, Phases, and Subagents, using templates to produce the final output.

### Core Components

Here is a breakdown of the key components and how they interact:

#### 1. `SKILL.md` (The Entry Point)
- **Purpose:** This is the main definition file for the skill. It tells the system what the skill is, what it does, and when to use it.
- **Interaction:** It's the first file read to determine if the `planner` skill should be activated based on user input. It provides a high-level overview of the available workflows.

#### 2. Workflows (`workflows/registry.json`)
- **Purpose:** Workflows are the highest level of process definition. They represent a complete planning process for a specific goal (e.g., creating a new feature, debugging an issue).
- **Structure:** Each workflow in `registry.json` defines:
    - `name` & `description`: For identification.
    - `phases`: An ordered list of phase names that constitute the workflow. This is the primary execution path.
    - `template`: The markdown template file used to generate the final plan.
- **Interaction:** The system selects a workflow based on user input (e.g., `/plans --workflow debugging`). It then executes the phases listed for that workflow in sequence.

#### 3. Phases (`phases/phase-registry.json`)
- **Purpose:** Phases are distinct stages within a workflow. Each phase has a specific goal, like `discovery` (gathering information) or `design` (creating a technical plan).
- **Structure:** Each phase in `phase-registry.json` defines:
    - `name` & `purpose`: For identification.
    - `required_for`: A list of workflows that use this phase.
    - `outputs`: The expected file outputs from this phase, typically stored in the `.temp` directory.
    - `gap_check_criteria`: A list of questions used for quality control before moving to the next phase.
- **Interaction:** The lead agent executes phases one by one as defined in the current workflow. After each phase, it performs a "gap check" using the criteria to ensure quality.

#### 4. Subagents (`subagents/selection-matrix.json`)
- **Purpose:** Subagents are specialized, independent agents that perform the actual work within a phase. They are responsible for tasks like scanning code, analyzing dependencies, or designing architecture.
- **Structure:** The `selection-matrix.json` is a critical file that maps workflows and phases to subagents.
    - `subagent_selection`: A nested object that defines which subagents to run for each `[workflow][phase]`. It distinguishes between `always` run agents and `conditional` agents (e.g., based on flags like `--frontend`).
    - `subagent_locations`: A dictionary mapping subagent names to their prompt files.
- **Interaction:** When a phase starts, the lead agent consults this matrix to determine which subagents to spawn. It often runs multiple subagents in parallel to speed up the process.

#### 5. Templates (`templates/*.md`)
- **Purpose:** Templates are markdown files that provide the structure for the final `plan.md` output. They contain placeholders that are filled in during the `synthesis` phase.
- **Interaction:** After all research and design phases are complete, the `synthesis` phase is triggered. The lead agent reads all the research from the `.temp` directory and uses the workflow-specific template (defined in `workflows/registry.json`) to assemble the final, human-readable plan.

#### 6. Resources (`resources/`)
- **`orchestration.md`:** Describes the patterns for how the lead agent coordinates subagents (e.g., parallel vs. sequential execution).
- **`gap-checklist.md`:** Provides detailed checklists for the quality gates that happen between phases. This ensures each phase's output is complete and actionable before the next phase begins.

### The End-to-End Flow
1.  User provides a prompt (e.g., "plan a new user dashboard feature").
2.  The system matches this to the `planner` skill via `SKILL.md`.
3.  The planner detects the desired workflow (e.g., `new-feature`).
4.  It loads the workflow definition from `workflows/registry.json`.
5.  It executes each phase in the workflow's `phases` array sequentially.
6.  In each phase, it uses `subagents/selection-matrix.json` to spawn the correct subagents.
7.  Subagents run in parallel, performing research and writing their findings to the `.temp` directory.
8.  Between phases, the lead agent uses `resources/gap-checklist.md` to verify the work.
9.  Once the research phases are done, the `synthesis` phase runs. The lead agent reads all `.temp` files and uses the appropriate file from the `templates/` directory to generate the final `plan.md`.
10. The `validation` and `finalize` phases run to check the plan's quality and create metadata.

---

## Part 2: Guide to Editing an Existing Workflow

Use this checklist when you need to modify an existing workflow.

### Checklist for Editing a Workflow

1.  **[ ] Identify Your Goal:**
    - Be clear about what you want to change. Are you adding a phase, removing a subagent, or changing the order?
    - **Example:** "I want to add a new `security-audit` phase to the `new-feature` workflow."

2.  **[ ] Modify Workflow Phases (`workflows/registry.json`):**
    - Open `workflows/registry.json`.
    - Find the workflow you are editing (e.g., `new-feature`).
    - Modify the `phases` array. Add, remove, or reorder the phase names as needed.
    - **Example:** Add `"security-audit"` to the `phases` array, probably before `"synthesis"`.

3.  **[ ] Define Subagent Selection (`subagents/selection-matrix.json`):**
    - Open `subagents/selection-matrix.json`.
    - If you added a new phase, create a new entry for it under the workflow (e.g., ` "security-audit": { "always": ["security-auditor"] }`).
    - If you are changing subagents for an existing phase, find the `[workflow][phase]` entry and modify the `always` or `conditional` lists.

4.  **[ ] Update Phase Definitions (`phases/phase-registry.json`):**
    - Open `phases/phase-registry.json`.
    - If you added a new phase, you **must** define it here. Give it a `name`, `purpose`, specify which workflows it's `required_for`, define its `outputs`, and add `gap_check_criteria`.
    - If you changed an existing phase's role, update its definition accordingly.

5.  **[ ] Adjust the Template (`templates/*.md`):**
    - If your changes produce new information that should be in the final plan, you **must** update the corresponding template.
    - Open the template file associated with your workflow (e.g., `templates/new-feature.md`).
    - Add a new section for the output of your new phase or subagent.
    - **Example:** Add a `## Security Audit` section to `new-feature.md`.

6.  **[ ] Update Quality Gates (`resources/gap-checklist.md`):**
    - To maintain quality, update the gap checklist.
    - Open `resources/gap-checklist.md`.
    - If you added a new phase, create a new section with a checklist for its outputs.
    - If you changed a phase, update its existing checklist.

7.  **[ ] Update Skill Description (`SKILL.md`):**
    - Finally, review `SKILL.md`. If your change is significant (e.g., adds a major new step), update the high-level description of the workflow so it remains accurate.

---

## Part 3: Guide to Creating New Components

Use these guides to extend the planner with new capabilities.

### How to Create a New Workflow

1.  **Define the Workflow (`workflows/registry.json`):**
    - Add a new object to the `workflows` section.
    - Give it a unique name (e.g., `technical-debt-review`).
    - Write a `description`.
    - Define the `phases` array with the sequence of phases it will run. You can reuse existing phases.
    - Specify a `template` file name (e.g., `technical-debt.md`).

2.  **Create the Template (`templates/`):**
    - Create the new markdown file (e.g., `templates/technical-debt.md`) in the `templates` directory.
    - Structure this file with the sections you want in the final plan.

3.  **Define Subagent Selection (`subagents/selection-matrix.json`):**
    - For your new workflow, add an entry in `subagent_selection`.
    - For each phase in your new workflow, define the `always` and `conditional` subagents to be run.

4.  **Update `SKILL.md`:**
    - Add your new workflow to the list in `SKILL.md` so users know it's available.

5.  **Update `gap-checklist.md`:**
    - Add a new section to the `Workflow-Specific Checkpoints` at the end of the file for your new workflow, defining its key quality gates.

### How to Create a New Phase

1.  **Define the Phase (`phases/phase-registry.json`):**
    - Add a new object to the `phases` section.
    - Give it a unique name (e.g., `compliance-check`).
    - Add a `purpose`, the `outputs` it will generate, and `gap_check_criteria`.
    - Specify which workflow(s) it is `required_for`.

2.  **Add Phase to Workflows (`workflows/registry.json`):**
    - Edit the `phases` array of any workflow that should use this new phase and add the new phase name.

3.  **Define Subagent Selection (`subagents/selection-matrix.json`):**
    - For each workflow that now uses this phase, add an entry under `subagent_selection` to define which subagents should run during this phase.

4.  **Update the Gap Checklist (`resources/gap-checklist.md`):**
    - Add a new H3 section for your phase with a checklist to ensure its outputs are validated correctly.

### How to Create a New Subagent

1.  **Create the Subagent Prompt File:**
    - Create a new markdown file in `~/.claude/agents/plans/` (e.g., `~/.claude/agents/plans/new-awesome-agent.md`).
    - Write a clear and concise prompt defining the agent's role, task, and expected output format.

2.  **Register the Subagent (`subagents/selection-matrix.json`):**
    - Add your new agent to the `subagent_locations` dictionary, mapping its name to its file path.
    - **Example:** `"new-awesome-agent": "~/.claude/agents/plans/new-awesome-agent.md"`

3.  **Assign the Subagent to a Phase (`subagents/selection-matrix.json`):**
    - Find the `[workflow][phase]` where you want this agent to run.
    - Add the agent's name to the `always` or `conditional` list.

### How to Create a New Template

1.  **Create the Template File (`templates/`):**
    - Create a new `.md` file in the `templates/` directory (e.g., `my-new-template.md`).
    - Structure it with the desired headers and placeholders (e.g., `{{FEATURE_NAME}}`, `{{RISK_ANALYSIS}}`). These placeholders are not automatically replaced but serve as a guide for the synthesis phase.

2.  **Associate with a Workflow (`workflows/registry.json`):**
    - Create a new workflow or edit an existing one.
    - Set the `template` property to the filename of your new template.
    - **Example:** `"template": "my-new-template.md"`
