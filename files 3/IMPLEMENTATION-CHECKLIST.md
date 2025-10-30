# Claude Code Command Refactoring: Implementation Checklist

Use this checklist to implement the refactored 4-command approach.

---

## Phase 0: Preparation (30 minutes)

### Understanding
- [ ] Read `FINDINGS-SUMMARY.md` for overview
- [ ] Read `RESEARCH-QUICK-START.md` for quick path
- [ ] Review research report sections 1-3 for context
- [ ] Understand the 4 limitations (nested spawn, todo state, task execution, phase orchestration)

### Workspace Setup
- [ ] Create `.claude/commands/` directory if it doesn't exist
  ```bash
  mkdir -p .claude/commands
  ```
- [ ] Verify you have write access to `.claude/` directory
- [ ] Back up existing `frontend-add.md` if you want to keep it
  ```bash
  cp .claude/commands/frontend-add.md .claude/commands/frontend-add.md.bak
  ```

---

## Phase 1: Create 4 Slash Commands (1-2 hours)

### Command 1: Analysis (`/frontend-analyze`)
- [ ] Copy template
  ```bash
  cp example-frontend-analyze.md .claude/commands/frontend-analyze.md
  ```
- [ ] Read through the template
- [ ] Customize for your project:
  - [ ] Update frontmatter `allowed-tools` if needed
  - [ ] Update `argument-hint` to match your convention
  - [ ] Update description if needed
  - [ ] Replace `[feature-name]` patterns with `$1`
  - [ ] Replace `[what-to-add]` patterns with `$2`
- [ ] Save and test reading it:
  ```bash
  cat .claude/commands/frontend-analyze.md | head -20
  ```

### Command 2: Planning (`/frontend-plan`)
- [ ] Copy template
  ```bash
  cp example-frontend-plan.md .claude/commands/frontend-plan.md
  ```
- [ ] Customize for your project (same as command 1)
- [ ] Ensure references to `.temp/analyze-*` paths are correct
- [ ] Verify output description (should be MASTER_PLAN.md)

### Command 3: Implementation (`/frontend-implement`)
- [ ] Copy template
  ```bash
  cp example-frontend-implement.md .claude/commands/frontend-implement.md
  ```
- [ ] Customize for your project
- [ ] Verify agent descriptions match your tech stack (Vue/React/Angular)
- [ ] Update npm commands to match your project:
  - [ ] `pnpm run typecheck` → your project's command
  - [ ] `pnpm run lint` → your project's command
  - [ ] `pnpm run build` → your project's command
  - [ ] `pnpm run test` → your project's command

### Command 4: Validation (`/frontend-validate`)
- [ ] Copy template
  ```bash
  cp example-frontend-validate.md .claude/commands/frontend-validate.md
  ```
- [ ] Customize for your project
- [ ] Ensure validation commands match your project
- [ ] Update report template sections as needed

### Verification
- [ ] List commands to verify all 4 exist:
  ```bash
  ls -la .claude/commands/frontend-*.md
  ```
  Should show:
  - [ ] frontend-analyze.md
  - [ ] frontend-plan.md
  - [ ] frontend-implement.md
  - [ ] frontend-validate.md

---

## Phase 2: Set Up Project Context (30 minutes)

### Create CLAUDE.md
- [ ] Copy template
  ```bash
  cp example-CLAUDE.md .claude/CLAUDE.md
  ```
- [ ] Edit for your actual project:
  - [ ] Replace `[Vue/React/Angular]` with actual framework
  - [ ] Replace `[Pinia/Redux/NgRx]` with actual state manager
  - [ ] Replace `[VueUse/React Query/Angular Services]` with actual
  - [ ] Update all npm commands to match your project
  - [ ] Update file paths to match your project structure
  - [ ] Add your project-specific patterns and conventions
  - [ ] Update testing framework references
  - [ ] Update build tool references

### Verify Content
- [ ] CLAUDE.md exists:
  ```bash
  ls -la .claude/CLAUDE.md
  ```
- [ ] Check that it reads correctly:
  ```bash
  head -50 .claude/CLAUDE.md
  ```

### Optional: Create Agents
If you want to formalize specialized agents (optional):
- [ ] Create `.claude/agents/` directory if needed
  ```bash
  mkdir -p .claude/agents
  ```
- [ ] Consider creating:
  - [ ] `code-scout.md` - Architecture analysis
  - [ ] `doc-researcher.md` - Solution research
  - [ ] But NOT required - can work without dedicated agent files

---

## Phase 3: Test First Command (30 minutes)

### Test `/frontend-analyze`

The command should now be available. Test it on a **small, well-understood feature**:

```bash
/frontend-analyze "search" "filter capabilities"
```

OR use your actual feature:

```bash
/frontend-analyze "YOUR_FEATURE" "what you want to add"
```

### Verify Output
- [ ] Command completes without errors
- [ ] `.temp/analyze-*/PRE_ANALYSIS.md` file is created
- [ ] File contains useful analysis:
  - [ ] List of files related to the feature
  - [ ] Data flow description
  - [ ] Architectural patterns documented
  - [ ] VueUse/npm solutions found

### Review
- [ ] Read the PRE_ANALYSIS.md output
- [ ] Is it accurate for your feature?
- [ ] Does it make sense?
- [ ] Are all relevant files found?

### Adjust if Needed
If analysis seems incomplete:
- [ ] Make sure you're using your actual feature name
- [ ] Check that `.claude/CLAUDE.md` has enough project context
- [ ] Consider re-running with more specific feature details
- [ ] OR troubleshoot by running `/frontend-analyze` again

### Success
- [ ] PRE_ANALYSIS.md exists ✅
- [ ] Contains useful information ✅
- [ ] Ready to move to next phase ✅

---

## Phase 4: Test Full Workflow (2-4 hours)

### Test `/frontend-plan`

Using the output from Phase 3:

```bash
/frontend-plan "YOUR_FEATURE" "what you want to add"
```

### Verify Output
- [ ] Command reads PRE_ANALYSIS.md successfully
- [ ] MASTER_PLAN.md is created
- [ ] Plan contains:
  - [ ] Extension-first strategy described
  - [ ] Phases broken down (Foundation, Implementation, Integration, QA)
  - [ ] Files to modify identified
  - [ ] New files justified (if any)
  - [ ] Success criteria listed
  - [ ] Impact assessment (Small/Medium/Large)

### Review & Approval
- [ ] Read MASTER_PLAN.md carefully
- [ ] Do you agree with approach?
- [ ] Are all necessary components covered?
- [ ] Is it realistic for your codebase?

### Approve or Adjust
- [ ] If approved: Continue to implementation ✅
- [ ] If needs changes: Edit MASTER_PLAN.md directly and re-run plan phase
- [ ] If fundamental issues: May need to adjust CLAUDE.md project context

### Test `/frontend-implement`

Once plan is approved:

```bash
/frontend-implement "YOUR_FEATURE" "what you want to add"
```

### Verify Implementation
- [ ] Command executes without errors
- [ ] Multiple agents spawn and run in parallel
- [ ] Implementation reports are created
- [ ] Source files are modified
- [ ] Tests are added
- [ ] Changes are committed to git

### Check Results
- [ ] Run your project's validation:
  ```bash
  npm run typecheck
  npm run lint
  npm run build
  npm run test
  ```
- [ ] All pass? ✅
- [ ] Any failures? ❌ See troubleshooting below

### Test `/frontend-validate`

After implementation:

```bash
/frontend-validate "YOUR_FEATURE" "what you want to add"
```

### Verify Validation
- [ ] All automated checks pass
- [ ] Regression testing confirms existing features still work
- [ ] New functionality verified working
- [ ] COMPLETION_REPORT.md created
- [ ] Status shows "READY FOR PRODUCTION" ✅

---

## Phase 5: Troubleshooting (As Needed)

### Issue: Command Not Found

**Problem:** `/frontend-analyze` doesn't appear in `/help`

**Solutions:**
- [ ] Check file exists: `ls .claude/commands/frontend-analyze.md`
- [ ] Check it has `description` in frontmatter
- [ ] Restart Claude Code
- [ ] Verify `.claude/` directory is in project root

### Issue: Analysis Incomplete

**Problem:** PRE_ANALYSIS.md missing features or data flow

**Solutions:**
- [ ] Ensure `.claude/CLAUDE.md` has complete project context
- [ ] Re-run `/frontend-analyze` with more detailed parameters
- [ ] Check that feature actually exists in codebase
- [ ] Manually verify feature files match what Claude found

### Issue: Plan Seems Wrong

**Problem:** MASTER_PLAN.md suggests wrong approach

**Solutions:**
- [ ] Edit MASTER_PLAN.md directly with corrections
- [ ] Or re-run `/frontend-plan` with modified CLAUDE.md
- [ ] Consider if analysis needs refinement

### Issue: Implementation Errors

**Problem:** Implementation completes but code has errors

**Solutions:**
- [ ] Check error messages from typecheck/lint/test
- [ ] Edit problematic files manually
- [ ] Re-run `/frontend-validate` to confirm fixes

### Issue: Tests Fail

**Problem:** New tests fail or existing tests broken

**Solutions:**
- [ ] Check test output for specific failures
- [ ] May need to adjust CLAUDE.md testing guidance
- [ ] Consider if implementation needs adjustment
- [ ] Can manually fix test files if needed

### Issue: Parallel Agents Didn't Coordinate

**Problem:** Multiple agents created conflicting changes

**Solutions:**
- [ ] This is rare but can happen
- [ ] Manual merge of conflicting changes
- [ ] Consider adjusting agent prompts in slash command
- [ ] May need more specific MASTER_PLAN.md details

---

## Phase 6: Production Deployment (As Needed)

### If Validation Passed ✅

- [ ] COMPLETION_REPORT.md shows "READY FOR PRODUCTION"
- [ ] All automated checks pass
- [ ] Code review complete (if required)
- [ ] Ready to merge!

```bash
git add .
git commit -m "feat: add [feature] to [parent_feature]"
git push origin feature-branch
```

### If There Are Issues ❌

- [ ] Keep refining using phases
- [ ] Don't force-merge broken code
- [ ] Iterate until COMPLETION_REPORT.md shows ready

---

## Phase 7: Optimization (After First Use)

### Collect Feedback
- [ ] Did workflow work as expected?
- [ ] Which parts were smooth?
- [ ] Which parts were rough?
- [ ] Any improvements needed?

### Refine Commands
- [ ] Update slash command templates based on experience
- [ ] Improve CLAUDE.md project context
- [ ] Consider creating agent files if helpful
- [ ] Document any project-specific patterns

### Share with Team
- [ ] Add refactored commands to version control:
  ```bash
  git add .claude/
  git commit -m "feat: add frontend addition workflow slash commands"
  ```
- [ ] Document usage in project README
- [ ] Share with team if collaborative

---

## Success Checklist: Final Verification

After implementing the refactored approach:

- [ ] 4 slash commands exist: analyze, plan, implement, validate
- [ ] CLAUDE.md has complete project context
- [ ] First test command completed successfully
- [ ] Analysis phase produced PRE_ANALYSIS.md
- [ ] Planning phase produced MASTER_PLAN.md
- [ ] Implementation phase ran without errors
- [ ] Validation phase confirms production-ready
- [ ] All automated checks pass
- [ ] Feature works as intended
- [ ] Backward compatibility maintained
- [ ] Test coverage adequate
- [ ] Type safety verified
- [ ] Ready to deploy ✅

---

## Quick Reference: File Locations

### Your New Slash Commands
```
.claude/commands/
├── frontend-analyze.md
├── frontend-plan.md
├── frontend-implement.md
└── frontend-validate.md
```

### Your Project Context
```
.claude/
├── CLAUDE.md  (project context and patterns)
└── commands/  (slash commands above)
```

### Generated Artifacts (during workflow)
```
.temp/
├── analyze-[feature]-[date]/
│   └── PRE_ANALYSIS.md
└── MASTER_PLAN.md  (in repo root or .temp/)

Modified:
├── src/  (modified source files)
└── tests/  (new test files)

Reports:
└── COMPLETION_REPORT.md
```

---

## Timeline

**Realistic Timeline for One Feature:**

| Phase | Time | Effort |
|-------|------|--------|
| Setup commands & CLAUDE.md | 2-3 hours | One-time |
| Analyze feature | 15-30 min | Per feature |
| Plan implementation | 10-20 min | Per feature |
| Implement feature | 45-90 min | Per feature |
| Validate & deploy | 10-20 min | Per feature |
| **Total per feature** | **1.5-3 hours** | Automated |

---

## Common Customizations

### For React Projects
- Change agent instructions: Replace "Vue components" with "React components"
- Update commands: Replace `pnpm` with `npm`
- Update store refs: Replace Pinia with Redux/Zustand
- Update composable refs: Replace VueUse with React hooks

### For Angular Projects
- Similar customizations as React
- Replace component terminology
- Update service references
- Update module/dependency injection patterns

### For Django/FastAPI Backend
- Similar approach but for backend features
- Commands: `/backend-analyze`, `/backend-plan`, etc.
- Replace frontend patterns with backend patterns
- Update API route handling

---

## Next Actions

1. **Immediate (Today)**
   - [ ] Read FINDINGS-SUMMARY.md
   - [ ] Review example command templates

2. **This Session**
   - [ ] Copy 4 command templates to `.claude/commands/`
   - [ ] Customize CLAUDE.md for your project
   - [ ] Test `/frontend-analyze` on a simple feature

3. **Next Session**
   - [ ] Run `/frontend-plan` and review output
   - [ ] Run full 4-phase workflow
   - [ ] Verify implementation quality

4. **Production**
   - [ ] Deploy refactored commands to team
   - [ ] Document for team usage
   - [ ] Collect feedback and iterate

---

**You're Ready!** Follow this checklist and you'll have a working, production-ready multi-phase slash command system. 🚀
