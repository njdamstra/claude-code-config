# How to Edit the Codebase Documentation System

This document provides a comprehensive guide to understanding, modifying, and extending the `codebase-documentation` skill. It is designed for developers who need to customize documentation workflows, add new research capabilities, or debug the documentation generation process.

## Part 1: How the Documentation System Works

The `codebase-documentation` skill is a sophisticated multi-agent orchestration system designed to automate the creation of technical documentation. It operates on a hierarchical structure of Workflows, Phases, and Subagents, using templates to produce the final output. The entire process is initiated from the `/docs` command.

### Core Components

Here is a breakdown of the key components and how they interact:

#### 1. Command (`/commands/docs.md`)
- **Purpose:** This is the user-facing entry point. It's responsible for parsing the user's command-line arguments (`/docs new <topic> Description: ...`).
- **Interaction:** It validates the user's input, extracts the topic, description, workflow type, and flags, and then formats a natural language prompt that triggers the `codebase-documentation` skill.

#### 2. Skill (`/skills/codebase-documenation/SKILL.md`)
- **Purpose:** This is the main orchestrator. It manages the entire documentation generation process from start to finish.
- **Interaction:** Once activated, the skill detects the desired workflow, loads all necessary configurations, and executes the defined sequence of phases.

#### 3. Workflows (`workflows/registry.json`)
- **Purpose:** Workflows are the highest level of process definition. They represent a complete documentation process for a specific goal (e.g., a `comprehensive` deep-dive vs. a `quickref` cheat sheet).
- **Structure:** The system has 4 workflows: `comprehensive`, `how-to`, `quickref`, and `architecture`. Each defines:
    - `phases`: An ordered list of phase names that constitute the workflow.
    - `subagents`: A list of subagents to be used in each phase.
    - `template`: The markdown template file for the final output.
- **Interaction:** The skill selects a workflow and executes its defined phases in sequence.

#### 4. Phases (`phases/phase-registry.json`)
- **Purpose:** Phases are distinct stages within a workflow, each with a specific goal (e.g., `discovery`, `analysis`, `verification`).
- **Structure:** The system has 6 phases. The registry defines each phase's purpose, its inputs/outputs, and the criteria for a `gap_check` to ensure quality before proceeding.
- **Interaction:** The lead agent (the skill) executes phases one by one. After key phases, it performs a "gap check" to ensure the research is sound.

#### 5. Subagents (`subagents/selection-matrix.json`)
- **Purpose:** Subagents are specialized, independent agents that perform the actual research. There are 11 subagents for tasks like scanning files, mapping dependencies, and verifying accuracy.
- **Structure:** The `selection-matrix.json` maps workflows and phases to subagents. It uses `always` for subagents that always run and `conditional` for subagents that run based on flags (`--frontend`, `--backend`) or context (`has_examples`).
- **Interaction:** When a phase starts, the skill consults this matrix to determine which subagents to spawn in parallel.

#### 6. Templates (`templates/*.md`)
- **Purpose:** These markdown files provide the structure for the final documentation. There are 4 templates, one for each workflow.
- **Interaction:** In the `synthesis` phase, the skill reads all the research from the `.temp` directory and uses the workflow-specific template to assemble the final, human-readable `main.md` file.

#### 7. Research Artifacts (`brains/codebase-docs/<topic>/.temp/`)
- **Purpose:** This directory is the scratchpad where all subagents write their findings.
- **Interaction:** Subagents write their output to this directory. Later-phase subagents and the final `synthesis` phase read from this directory to build upon previous work. The directory is preserved for debugging and transparency.

### The End-to-End Flow
1.  User runs `/docs new ...`.
2.  The `docs.md` command parses the input and triggers the `codebase-documentation` skill.
3.  The skill detects the workflow (e.g., `architecture`).
4.  It loads the workflow's definition from `workflows/registry.json`.
5.  It executes each phase in the defined sequence (e.g., `plan` -> `discovery` -> `analysis` -> `synthesis` -> `finalize`).
6.  In each phase, it uses `subagents/selection-matrix.json` to spawn the correct subagents in parallel.
7.  Subagents perform research and write their findings to `.temp/`.
8.  The skill performs quality `gap_checks` between phases.
9.  The `synthesis` phase uses the appropriate template (e.g., `architecture.md`) to build the final `main.md` from the research artifacts.
10. The `finalize` phase creates metadata and reports completion.

---

## Part 2: Guide to Editing the System

Use this checklist when you need to modify an existing workflow or component.

### Checklist for Editing a Workflow

1.  **[ ] Identify Your Goal:**
    - Be clear about what you want to change. Are you adding a subagent to a phase? Changing the phase order?
    - **Example:** "I want to add the `example-validator` to the `architecture` workflow's verification phase."

2.  **[ ] Modify Workflow Definitions (`workflows/registry.json`):**
    - If changing the phase sequence, edit the `phases` array for the target workflow.
    - If changing the subagents used, update the `subagents` list for the relevant phase.

3.  **[ ] Define Subagent Selection (`subagents/selection-matrix.json`):**
    - This is the primary file for changing which subagents run.
    - To add/remove a subagent, find the `[workflow][phase]` entry and modify the `always` or `conditional` lists.
    - **Example:** Add `"example-validator"` to the `verification.conditional` list for the `architecture` workflow.

4.  **[ ] Update Phase Definitions (`phases/phase-registry.json`):**
    - Only edit this if you are changing a phase's fundamental behavior (e.g., making a gap check mandatory).

5.  **[ ] Adjust the Template (`templates/*.md`):**
    - If your changes produce new information that should be in the final document, you **must** update the corresponding template.
    - **Example:** If you add a new analysis subagent, add a new section to the `comprehensive.md` template to display its findings.

6.  **[ ] Update Quality Gates (`resources/gap-checklist.md`):**
    - To maintain quality, update the checklist for any phase you modify.

7.  **[ ] Update Skill/Command Descriptions (`SKILL.md`, `commands/docs.md`):**
    - If your change is significant (e.g., adds a new workflow), update the descriptions in these files to keep them accurate.

---

## Part 3: Guide to Creating New Components

Use these guides to extend the documentation system.

### How to Create a New Workflow

1.  **Define the Workflow (`workflows/registry.json`):**
    - Add a new object to the `workflows` section (e.g., `api-reference`).
    - Define its `phases` array, `subagents` list, and `template` file name.

2.  **Create the Template (`templates/`):**
    - Create the new markdown file (e.g., `templates/api-reference.md`).
    - Structure it with the sections you want in the final document.

3.  **Define Subagent Selection (`subagents/selection-matrix.json`):**
    - Add a new top-level key for your workflow (e.g., `"api-reference": { ... }`).
    - For each phase in your new workflow, define the `always` and `conditional` subagents to run.

4.  **Update Command and Skill (`commands/docs.md`, `SKILL.md`):**
    - Add the new workflow name to the list of valid options in both files so users can select it.

### How to Create a New Phase

1.  **Define the Phase (`phases/phase-registry.json`):**
    - Add a new object to the `phases` section (e.g., `security-review`).
    - Define its `name`, `description`, `required_for`/`optional_for`/`skipped_for` workflows, `outputs`, and `gap_check_criteria`.

2.  **Add Phase to Workflows (`workflows/registry.json`):**
    - Edit the `phases` array of any workflow that should use this new phase.

3.  **Define Subagent Selection (`subagents/selection-matrix.json`):**
    - For each workflow that now uses this phase, add an entry to define which subagents should run during it.

4.  **Update the Gap Checklist (`resources/gap-checklist.md`):**
    - Add a new section for your phase with a checklist to ensure its outputs are validated.

### How to Create a New Subagent

1.  **Create the Subagent Prompt File:**
    - Create a new markdown file in `~/.claude/agents/docs/` (e.g., `~/.claude/agents/docs/security-scanner.md`).
    - Use the `templates/subagent-template.md` as a guide to define its role, tools, and output format.

2.  **Register the Subagent (`subagents/selection-matrix.json`):**
    - Add your new agent to the `subagent_locations` dictionary.
    - **Example:** `"security-scanner": "~/.claude/agents/docs/security-scanner.md"`

3.  **Assign the Subagent to a Phase (`subagents/selection-matrix.json`):**
    - Find the `[workflow][phase]` where you want this agent to run and add its name to the `always` or `conditional` list.
