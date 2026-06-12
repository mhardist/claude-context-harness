#!/bin/bash
# Subagent Delegation Nudge
#
# On UserPromptSubmit, detect phrasing that implies broad exploration
# (analyze all, audit, review the whole codebase, research how X works, etc.)
# and inject a reminder to delegate to an Agent — so the verbose tool results
# stay in the subagent's context rather than polluting main.
#
# Non-blocking reminder. Claude decides whether to heed it.

prompt=$(jq -r '.prompt // ""')

# Patterns that almost always benefit from subagent delegation
if echo "$prompt" | grep -iE '(analyze all|audit (the|this|my) (repo|codebase|code)|review (the )?(whole|entire) (repo|codebase|project)|look through (every|all)|scan .{1,40}(codebase|repo|repository)|research how .+ works|find all (usages|references|instances) of|enumerate all|list all (files|functions|tables|classes|components|endpoints)|map (all|the whole)|go through (all|every)|check every|what .{1,20} exist in this (repo|codebase|project))' > /dev/null 2>&1; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "UserPromptSubmit",
      additionalContext: "[DELEGATION NUDGE] This prompt sounds like broad exploration (many file reads / greps likely). Prefer Agent(subagent_type=Explore) with a focused research question and \"report under 200 words\" — keeps verbose tool output in the subagent context, not main. Multiple independent questions? Launch parallel agents in a single message. Only skip delegation if the work is genuinely small (1-2 reads) or requires back-and-forth with the user."
    }
  }'
fi
