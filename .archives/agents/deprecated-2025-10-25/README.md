# Archived Agents - 2025-10-25

## codebase-researcher.md

**Reason for archival:** Functionality merged into enhanced code-scout agent

**What was merged:**
1. **Match percentage system** - REUSE (80-100%), EXTEND (50-79%), CREATE (0-49%)
2. **DEBUG category added** - For existing code with issues requiring fixes
3. **Systematic search protocol** - Composables, Components, Stores, Utilities, Schemas, VueUse checks
4. **Simplified recommendation format** - Clear categorization with justification

**Replacement:** Use `code-scout` agent for all codebase exploration

**Enhanced code-scout capabilities:**
- ✅ Objective match percentages for reusability scoring
- ✅ Systematic 6-step search protocol (composables → components → stores → utilities → schemas → VueUse)
- ✅ Four-category system: REUSE/EXTEND/CREATE/DEBUG
- ✅ Comprehensive PRE_ANALYSIS.md with 9 sections
- ✅ VueUse alternative detection
- ✅ Workflow-agnostic (usable anytime for codebase exploration)
- ✅ Haiku model (fast, cost-effective)

**Migration:**
- Any references to `codebase-researcher` → Use `code-scout` instead
- Task tool with subagent_type=Explore → Already uses code-scout
- Output styles (builder-mode, refactor-mode) → Update if needed

**Archive date:** 2025-10-25
