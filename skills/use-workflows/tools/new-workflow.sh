#!/usr/bin/env bash

set -euo pipefail

# Workflow scaffolding tool
# Usage: ./tools/new-workflow.sh <workflow-name> <execution-mode>

if [ $# -lt 2 ]; then
  echo "Usage: $0 <workflow-name> <execution-mode>"
  echo ""
  echo "Arguments:"
  echo "  workflow-name    Lowercase with hyphens (e.g., 'custom-research')"
  echo "  execution-mode   strict | loose | adaptive"
  echo ""
  echo "Example:"
  echo "  $0 custom-research adaptive"
  exit 1
fi

WORKFLOW_NAME=$1
EXECUTION_MODE=$2
OUTPUT_FILE="workflows/${WORKFLOW_NAME}.workflow.yaml"

# Validate execution mode
if [[ ! "$EXECUTION_MODE" =~ ^(strict|loose|adaptive)$ ]]; then
  echo "Error: execution-mode must be strict, loose, or adaptive"
  exit 1
fi

# Validate workflow name
if [[ ! "$WORKFLOW_NAME" =~ ^[a-z-]+$ ]]; then
  echo "Error: workflow-name must be lowercase with hyphens only"
  exit 1
fi

# Check if file exists
if [ -f "$OUTPUT_FILE" ]; then
  echo "Error: $OUTPUT_FILE already exists"
  exit 1
fi

echo "Creating workflow: $WORKFLOW_NAME ($EXECUTION_MODE mode)"

# Generate template based on mode
case "$EXECUTION_MODE" in
  strict)
    cat > "$OUTPUT_FILE" <<EOF
name: ${WORKFLOW_NAME}
description: "Brief description of workflow purpose"
execution_mode: strict

phases:
  - id: phase_1
    name: "Phase 1 Name"
    description: "What this phase accomplishes"
    behavior: parallel  # parallel | sequential | main-only
    subagents:
      - type: codebase-scanner
        config:
          output_path: "{{output_dir}}/scan.md"
      - type: code-scout
        config:
          output_path: "{{output_dir}}/scout.md"
    checkpoint:
      approval_required: true
    gap_check:
      enabled: false

  - id: phase_2
    name: "Phase 2 Name"
    description: "What this phase accomplishes"
    behavior: sequential
    subagents:
      - type: pattern-analyzer
        config:
          output_path: "{{output_dir}}/patterns.md"
    checkpoint:
      prompt: "Review outputs before continuing?"
      options:
        - label: "Continue"
          on_select:
            action: continue
        - label: "Abort"
          on_select:
            action: abort

finalization:
  template: "templates/final-plan.md.tmpl"
  output: "{{output_dir}}/final-plan.md"
EOF
    ;;

  loose)
    cat > "$OUTPUT_FILE" <<EOF
name: ${WORKFLOW_NAME}
description: "Brief description of workflow purpose"
execution_mode: loose

phases:
  - id: phase_1
    name: "Phase 1 Name"
    description: "What this phase accomplishes"
    behavior: main-only
    main_agent:
      script: |
        // Main agent has full control
        const result = await thinkHard("Analyze and determine approach");
        writeFile('analysis.md', result);
    suggested_subagents:
      - type: code-scout
      - type: pattern-analyzer
    checkpoint:
      approval_required: true

  - id: phase_2
    name: "Phase 2 Name"
    description: "What this phase accomplishes"
    behavior: main-only
    main_agent:
      script: |
        const findings = readFile('analysis.md');
        const plan = await thinkHard(`Create plan from: ${findings}`);
        writeFile('plan.md', plan);

finalization:
  template: "templates/final-plan.md.tmpl"
  output: "{{output_dir}}/final-plan.md"
EOF
    ;;

  adaptive)
    cat > "$OUTPUT_FILE" <<EOF
name: ${WORKFLOW_NAME}
description: "Brief description of workflow purpose"
execution_mode: adaptive

phases:
  - id: phase_1
    name: "Phase 1 Name"
    description: "What this phase accomplishes"
    behavior: parallel
    subagents:
      always:
        - type: codebase-scanner
          config:
            output_path: "{{output_dir}}/scan.md"
      adaptive:
        script: |
          const scan = readFile('scan.md');
          const agents = [];

          if (scan.includes('Vue')) {
            agents.push({
              type: 'component-analyzer',
              config: { output_path: 'components.md' }
            });
          }

          if (scan.includes('Appwrite')) {
            agents.push({
              type: 'backend-analyzer',
              config: { output_path: 'backend.md' }
            });
          }

          return agents;
    checkpoint:
      approval_required: true
    gap_check:
      enabled: true
      max_iterations: 3
      script: |
        const deliverables = context.deliverables.filter(d => d.phase === phase.id);
        const gaps = identifyGaps(deliverables);

        if (gaps.length === 0) {
          return { status: 'complete' };
        }

        return {
          status: 'incomplete',
          gaps: gaps,
          action: 'retry',
          message: 'Gaps detected'
        };

  - id: phase_2
    name: "Phase 2 Name"
    description: "What this phase accomplishes"
    behavior: parallel
    subagents:
      always:
        - type: pattern-analyzer
          config:
            output_path: "{{output_dir}}/patterns.md"
      adaptive:
        script: |
          // Determine additional subagents based on phase 1 results
          return [];

finalization:
  template: "templates/final-plan.md.tmpl"
  output: "{{output_dir}}/final-plan.md"
EOF
    ;;
esac

echo "✓ Created $OUTPUT_FILE"
echo ""
echo "Next steps:"
echo "  1. Edit $OUTPUT_FILE to customize phases"
echo "  2. Validate: ./tools/validator.sh $OUTPUT_FILE"
echo "  3. Test: bash engine/workflow-runner.sh $OUTPUT_FILE test-feature"
