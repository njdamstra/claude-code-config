#!/usr/bin/env bash

# ============================================================================
# Constants for use-workflows-v2
# ============================================================================
# Purpose: Centralized constants used across workflow scripts
# ============================================================================

# ============================================================================
# Default Values
# ============================================================================

# Default base directory for workflow outputs
DEFAULT_BASE_DIR=".temp"

# Default subagent configuration values
DEFAULT_THOROUGHNESS="medium"
DEFAULT_TASK_AGENT_TYPE="general-purpose"
DEFAULT_DELIVERABLE="output.json"
DEFAULT_DESCRIPTION="No description"

# ============================================================================
# Validation Patterns
# ============================================================================

# Pattern for valid feature names (alphanumeric, hyphens, underscores)
FEATURE_NAME_PATTERN='^[a-zA-Z0-9_-]+$'

# Pattern for valid workflow names (lowercase, numbers, hyphens)
WORKFLOW_NAME_PATTERN='^[a-z0-9-]+$'

# Pattern for valid phase names (lowercase, numbers, hyphens)
PHASE_NAME_PATTERN='^[a-z0-9-]+$'

# Pattern for valid base directory paths
BASE_DIR_PATTERN='^[A-Za-z0-9._~/-]+$'

# ============================================================================
# File Extensions
# ============================================================================

# Template file extension
TEMPLATE_EXTENSION=".tmpl"

# YAML file extension
YAML_EXTENSION=".yaml"

# Markdown template extension (for subagent templates)
MD_TEMPLATE_EXTENSION=".md.tmpl"

# ============================================================================
# Directory Names
# ============================================================================

# Subagents directory name
SUBAGENTS_DIR="subagents"

# Workflows directory name
WORKFLOWS_DIR="workflows"

# Phases directory name
PHASES_DIR="phases"

# Output templates directory name
OUTPUT_TEMPLATES_DIR="output_templates"

# ============================================================================
# File Names
# ============================================================================

# Subagent registry filename
REGISTRY_FILENAME="registry.yaml"

# ============================================================================
# Path Patterns
# ============================================================================

# Phase directory name format: phase-{number:02d}-{name}
# Example: phase-01-discovery, phase-12-validation
PHASE_DIR_FORMAT="phase-%02d-%s"

# Subagent template path pattern: subagents/{type}/{workflow}.md.tmpl
# Example: subagents/code-researcher/new-feature-plan.md.tmpl
SUBAGENT_TEMPLATE_PATTERN="${SUBAGENTS_DIR}/%s/%s${MD_TEMPLATE_EXTENSION}"

# Output template path pattern: output_templates/{name}.{ext}.tmpl
# Example: output_templates/codebase-analysis.json.tmpl
OUTPUT_TEMPLATE_PATTERN="${OUTPUT_TEMPLATES_DIR}/%s${TEMPLATE_EXTENSION}"

# Workflow file path pattern: workflows/{name}.yaml
# Example: workflows/new-feature-plan.yaml
WORKFLOW_FILE_PATTERN="${WORKFLOWS_DIR}/%s${YAML_EXTENSION}"

# Phase template override pattern: phases/{workflow}/{phase}.md
# Example: phases/investigation-workflow/codebase-investigation.md
PHASE_OVERRIDE_PATTERN="${PHASES_DIR}/%s/%s.md"

# Phase template default pattern: phases/{phase}.md
# Example: phases/discovery.md
PHASE_DEFAULT_PATTERN="${PHASES_DIR}/%s.md"

# Registry file path pattern: subagents/registry.yaml
REGISTRY_FILE_PATTERN="${SUBAGENTS_DIR}/${REGISTRY_FILENAME}"

# ============================================================================
# Scope Values
# ============================================================================

# Default scope when no flags provided
SCOPE_DEFAULT="default"

# Frontend scope
SCOPE_FRONTEND="frontend"

# Backend scope
SCOPE_BACKEND="backend"

# Both frontend and backend scope
SCOPE_BOTH="both"

# ============================================================================
# Output Formatting
# ============================================================================

# Phase number padding (zero-padded to 2 digits)
PHASE_NUMBER_PADDING=2

