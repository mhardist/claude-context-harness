#!/bin/bash
# Parallel Agent Guard
#
# On UserPromptSubmit, detect phrasing that implies many simultaneous Agent
# dispatches ("19 parallel agents", "spawn N agents in parallel", "fan out per
# X", etc.) and inject a reminder about the parallel-agent ceiling.
#
# Why: each parallel agent costs real memory and CPU. On modest hardware
# (e.g., 8 GB unified memory), 6+ concurrent agents can push the machine deep
# into swap. This hook is a belt-and-suspenders reminder to batch or ask
# before exceeding the ceiling.
#
# Configure with PARALLEL_AGENT_CEILING (default 5) in settings.json "env"
# or your shell profile.
#
# Non-blocking reminder. Claude decides whether to heed it.

ceiling="${PARALLEL_AGENT_CEILING:-5}"

prompt=$(jq -r '.prompt // ""')

if echo "$prompt" | grep -iE '(parallel (agents|research|briefings|cards|tasks)|spawn (n |[0-9]+ |multiple |many )agents?|fan.?out (per|across|over)|in parallel (to|on)|[0-9]{2,}.*agents?|multiple (simultaneous|concurrent) agents?|launch .{1,30} agents in a single message|dispatch .{1,30} (parallel|concurrent))' > /dev/null 2>&1; then
  jq -n --arg ceiling "$ceiling" '{
    hookSpecificOutput: {
      hookEventName: "UserPromptSubmit",
      additionalContext: "[PARALLEL-AGENT GUARD] This prompt implies multiple simultaneous Agent dispatches. Hard ceiling on this machine: prefer ≤ \($ceiling) parallel Agent tool calls. For larger sets, (1) batch in groups of 3–4 with pilot-then-fan-out, or (2) explicitly ask the user for permission before firing. Do NOT silently exceed the ceiling."
    }
  }'
fi
