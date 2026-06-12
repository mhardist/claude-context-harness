#!/bin/bash
# Memory Capture Hook — one-shot early reminder
#
# At 40% context used (60% remaining), injects a gentle reminder to review
# the session for durable findings and save them to the PERSISTENT memory
# system under ~/.claude/projects/<project-slug>/memory/ (computed from cwd).
#
# This runs BEFORE context-monitor's 50% panic save, so durables get captured
# while there's plenty of headroom. Runs once per session (sentinel file).
#
# Complements context-monitor.sh:
#   - memory-capture.sh (40% used) = early, persistent, one-shot
#   - context-monitor.sh (50% used) = late, working-dir scratch + /clear

THRESHOLD_USED=40
STATE_FILE="/tmp/claude_memory_capture_triggered"

# One-shot: if already fired this session, exit silently
if [ -f "$STATE_FILE" ]; then
    exit 0
fi

input=$(cat)
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)

# Claude Code stores per-project memory under a slug of the project path
# (slashes become dashes). Compute it from the hook's cwd.
cwd=$(echo "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && cwd="$PWD"
MEMORY_DIR="$HOME/.claude/projects/$(echo "$cwd" | tr '/' '-')/memory"

if [ -n "$used" ] && [ "$used" != "null" ] && [ "$used" != "0" ]; then
    used_int=$(printf '%.0f' "$used")
    if [ "$used_int" -ge "$THRESHOLD_USED" ]; then
        date +%s > "$STATE_FILE"
        remaining=$((100 - used_int))
        cat <<SYSMSG
MEMORY CAPTURE — one-shot early reminder (${used_int}% used / ${remaining}% remaining):

Context is still healthy but growing. BEFORE the panic save at 50%, review this session for durable findings and promote them to the PERSISTENT memory system:

    ${MEMORY_DIR}/

Not .context/ — that's working-dir scratch that dies when you switch projects. The persistent memory outlives /clear AND project changes.

CAPTURE if present (else stay silent, don't manufacture):
  - New feedback rules (user corrections or validated non-obvious approaches)
  - New project facts (who/what/why/when — convert relative dates to absolute)
  - New reference pointers (external systems, dashboards, people, tools)
  - New user profile info (role shifts, new preferences, domain knowledge)

RULES:
  - Read MEMORY.md first — UPDATE existing files rather than creating duplicates
  - Feedback/project entries: lead with rule/fact, then **Why:** and **How to apply:** lines
  - One memory per file, linked from MEMORY.md as a single line
  - If nothing durable exists in this session, say "no durables to capture" and move on

This is your cross-session knowledge bank. Use it before context pressure forces a rushed save.
SYSMSG
        exit 0
    fi
fi

exit 0
