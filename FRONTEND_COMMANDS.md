I want to rename code-reuser-scout to be code-scout with pretty much the same functionality except just a little bit more generalized for being an expert code finder, including finding reusable code, duplications, etc.
I also want to create a new agent called plan-master that is similar to both the problem decomposer and the minimal change analyser, except it's function is to create the MASTER_PLAN.md file with what needs to be done (more generally), the relevant files and info needed from research needed, and a plan for which agents to spawn. it just respond to the main agent with instructions for which agent to do what but it can't be to restrictive since it should leave the specific implementation details to the expert agents. but it should say generally what sub agents to spawn, what they should focus on, what there deliverables are, context, and anything else useful for that agent. 

Here's the flow i want our 4 new commands to follow more generally:

PHASE 0:
initalaize workspace in .temp/[name]/ 

PHASE 1: PRE ANALSIS phase
spawn code-scout and documentation-researcher in parallel
main agent puts there findings in PRE_ANALYSIS.md file in workspace.

PHASE 2: PLANNING phase
spawn plan-master agent. this should output the MASTER_PLAN, a break down of what needs to be down and how to orchestrate the agents to do so (the order, if they should be in paralllel, etc)
main agent reads all of the MASTER_PLAN.md file created, and MUST update its todo list with the plan.


after phase 2 is finished, the agent should NOT proceed with implementation and instead ask me if i approve the master plan. if changes are requested, it should make the changes to the master plan until I approve it.

PHASE 3: IMPLEMENTATION phase

follow the master plan to proceed with implementation and spawning the sub agents accordingly. each agent must create a 300 lines or less document summary of what it changed and why
the main agent must review these documents.
this phase will be broken up probably in multiple sub phases depending on the complexity of the tasks

PHASE 4: COMPLETION phase

main agent creates the COMPLETION_REPORT.md file
