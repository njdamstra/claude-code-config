#!/usr/bin/env node

/**
 * Frontend Command Agent Auto-Spawn Hook
 *
 * Automatically detects @agent-name patterns in frontend commands
 * and orchestrates parallel agent spawning via the Task tool.
 */

const fs = require('fs');
const path = require('path');

// Map of @agent-name aliases to actual agent types
const AGENT_MAP = {
  '@code-scout': 'Explore',
  '@documentation-researcher': 'web-researcher',
  '@plan-master': 'problem-decomposer-orchestrator',
  '@vue-architect': 'astro-vue-architect',
  '@ssr-debugger': 'astro-vue-architect',
  '@typescript-validator': 'typescript-master',
  '@nanostore-state-architect': 'astro-vue-architect',
  '@appwrite-integration-specialist': 'appwrite-expert',
  '@tailwind-styling-expert': 'astro-vue-ux',
  '@vue-testing-specialist': 'astro-vue-architect',
  '@minimal-change-specialist': 'minimal-change-analyzer',
};

/**
 * Extract agent mentions and their missions from markdown
 */
function extractAgentTasks(content) {
  const agentPattern = /\*\*Spawn\s+(@[\w-]+)\s+with\s+mission:\*\*\s*```\s*([\s\S]*?)```/g;
  const agents = [];
  let match;

  while ((match = agentPattern.exec(content)) !== null) {
    const agentName = match[1];
    const mission = match[2].trim();
    agents.push({
      name: agentName,
      mission: mission,
      agentType: AGENT_MAP[agentName] || agentName.substring(1), // fallback to name without @
    });
  }

  return agents;
}

/**
 * Group agents that should run in parallel (same phase/section)
 */
function groupAgentsByPhase(content, agents) {
  const phases = [];
  let currentPhase = null;
  let currentPhaseAgents = [];

  const lines = content.split('\n');
  let agentIndex = 0;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    // Detect phase transitions
    if (line.match(/^##\s+Phase\s+\d+/)) {
      if (currentPhaseAgents.length > 0) {
        phases.push({
          phase: currentPhase,
          agents: currentPhaseAgents,
        });
        currentPhaseAgents = [];
      }
      currentPhase = line;
    }

    // Check if this line contains an agent spawn pattern
    if (line.includes('**Spawn')) {
      if (agentIndex < agents.length) {
        currentPhaseAgents.push(agents[agentIndex]);
        agentIndex++;
      }
    }
  }

  if (currentPhaseAgents.length > 0) {
    phases.push({
      phase: currentPhase,
      agents: currentPhaseAgents,
    });
  }

  return phases;
}

/**
 * Generate instruction for Claude to spawn agents
 */
function generateSpawnInstructions(agentPhases) {
  if (agentPhases.length === 0) {
    return '';
  }

  let instructions = '\n\n## AUTO-SPAWNED AGENTS\n\n';
  instructions += 'Claude should spawn the following agents to continue:\n\n';

  agentPhases.forEach((phaseGroup, idx) => {
    instructions += `### Phase Group ${idx + 1}\n`;
    instructions += `**Agents to spawn in parallel:**\n`;

    phaseGroup.agents.forEach((agent) => {
      instructions += `- **${agent.name}** (${agent.agentType})\n`;
      instructions += `  Mission: ${agent.mission.substring(0, 100)}...\n\n`;
    });
  });

  return instructions;
}

/**
 * Main hook processor
 */
function processCommand(commandContent) {
  const agents = extractAgentTasks(commandContent);

  if (agents.length === 0) {
    return commandContent;
  }

  const agentPhases = groupAgentsByPhase(commandContent, agents);
  const instructions = generateSpawnInstructions(agentPhases);

  return commandContent + instructions;
}

// Read from stdin and process
let input = '';
process.stdin.on('data', (chunk) => {
  input += chunk;
});

process.stdin.on('end', () => {
  const processed = processCommand(input);
  process.stdout.write(processed);
});
