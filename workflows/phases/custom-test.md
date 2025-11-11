# Phase: Custom Test

**Phase Number:** {{phase_number}}
**Feature:** {{feature_name}}
**Workspace:** {{workspace}}

---

## Objective

Test custom phase template resolution. This phase template is bundled with the custom workflow, demonstrating the plugin system's ability to load custom phase templates.

## Steps

### Step 1: Verify Custom Phase Loading

✅ If you're reading this, the custom phase template loaded successfully from `~/.claude/workflows/phases/custom-test.md` instead of from the built-in phases directory.

### Step 2: Test Subagent Invocation

{{#subagents}}
**Subagent {{@index}}:** {{name}}

```bash
# Invoke subagent
Task tool with:
- subagent_type: "{{task_agent_type}}"
- prompt: "{{task_description}}"
```

{{/subagents}}

### Step 3: Verify Output Directory

All deliverables for this phase should be written to:
```
{{workspace}}/{{output_dir}}/
```

---

## Success Criteria

- [x] Custom phase template loaded from workflow directory
- [x] Subagents invoked successfully
- [ ] Deliverables written to correct location

---

**This is a custom phase template demonstrating the plugin system!**
