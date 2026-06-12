#!/bin/bash
# PreToolUse guard on the Task (subagent) tool — runtime hard-cap on concurrent dispatches.
#
# The existing parallel-agent-guard.sh fires on UserPromptSubmit (prompt-text heuristic) and
# therefore can't see the actual Task calls. This one fires BEFORE each Task spawn and counts
# launches in a short trailing window. A stateless per-call hook can't truly observe
# concurrency, but parallel Task calls in a single assistant message all land within ~1-2s,
# while a genuine sequential next wave is minutes apart — so a small window cleanly separates
# an in-message burst from a later wave.
#
# Ceiling per user_profile.md (8 GB M3, swap thrash observed under load): prefer <=4, hard 5.
#   count <=4  -> silent allow
#   count ==5  -> allow + inject "at hard ceiling" reminder
#   count  >5  -> DENY this call (re-dispatch overflow in a later wave)
#
# Non-fatal: any internal error exits 0 (fail-open) so it never wedges the session.

input=$(cat)
tool=$(echo "$input" | jq -r '.tool_name // ""' 2>/dev/null)
[ "$tool" = "Task" ] || exit 0

STAMP_FILE="/tmp/claude_task_launch_times"
WINDOW=8
now=$(date +%s)

# prune entries older than WINDOW
if [ -f "$STAMP_FILE" ]; then
  awk -v n="$now" -v w="$WINDOW" '($1 + 0) > (n - w)' "$STAMP_FILE" > "${STAMP_FILE}.tmp" 2>/dev/null && mv "${STAMP_FILE}.tmp" "$STAMP_FILE"
fi
echo "$now" >> "$STAMP_FILE" 2>/dev/null
count=$(wc -l < "$STAMP_FILE" 2>/dev/null | tr -d ' ')
[ -n "$count" ] || exit 0

if [ "$count" -gt 5 ]; then
  jq -n --arg c "$count" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("[PARALLEL-AGENT GUARD] " + $c + " Task dispatches within 8s exceeds the hard ceiling of 5 concurrent agents (8 GB M3 — see user_profile.md). This call is BLOCKED. Wait for the current batch to return, then re-dispatch the overflow in a later wave. Prefer waves of <=4.")
    }
  }'
elif [ "$count" -eq 5 ]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      additionalContext: "[PARALLEL-AGENT GUARD] You are at the hard ceiling of 5 concurrent Agent dispatches (8 GB M3). Launch no more in this wave (prefer <=4); wait for these to return before the next batch."
    }
  }'
fi
exit 0
