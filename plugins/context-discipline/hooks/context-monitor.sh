#!/bin/bash
# Context Monitor Hook
# Triggers context-manager protocol when remaining context drops below 50%
# Lowered from 65% to 50% because Opus 4.7 uses more tokens per turn than 4.6
# and context rot sets in before the 35% remaining mark.
# Uses two detection methods:
#   1. context_window.used_percentage from hook input (if available)
#   2. Transcript file size as fallback proxy
#
# Threshold: 50% used = 50% remaining
# Cooldown: 5 minutes between triggers (prevents spam during save process)
# Re-arms automatically after /clear + continued work

THRESHOLD_USED=50
STATE_FILE="/tmp/claude_context_manager_triggered"
COOLDOWN_SECONDS=300

# Cooldown check: if triggered within last 5 minutes, exit silently
if [ -f "$STATE_FILE" ]; then
    last_trigger=$(cat "$STATE_FILE" 2>/dev/null)
    now=$(date +%s)
    if [ -n "$last_trigger" ] && [ $((now - last_trigger)) -lt "$COOLDOWN_SECONDS" ]; then
        exit 0
    fi
fi

# Read hook input from stdin
input=$(cat)

# Method 1: Try context_window data from hook input
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)

if [ -n "$used" ] && [ "$used" != "null" ] && [ "$used" != "0" ]; then
    used_int=$(printf '%.0f' "$used")
    if [ "$used_int" -ge "$THRESHOLD_USED" ]; then
        date +%s > "$STATE_FILE"
        remaining=$((100 - used_int))
        cat <<SYSMSG
CONTEXT THRESHOLD ALERT: Context is ${used_int}% used (${remaining}% remaining — at/above the ${THRESHOLD_USED}% threshold).

REQUIRED ACTIONS — Execute immediately in this exact order:
1. Run the /context-manager skill NOW to save .context/learnings.md, .context/session_update.md, and .context/resume_actions.md
2. After files are saved, read .context/resume_actions.md and confirm the continuation instructions are correct
3. Inform the user: "Context at ${remaining}%. Session state saved. Clearing context now."
4. Execute /clear to free context
5. After clear, immediately read .context/resume_actions.md and continue work
SYSMSG
        exit 0
    fi
    # Context data available but below threshold — exit clean
    exit 0
fi

# Method 2: Fallback — estimate from transcript file size
transcript=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)

if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    # ~200K token context ~ ~800K chars
    # 50% of 800K ~ 400K chars
    # JSONL has metadata overhead, so use 350K as conservative trigger
    file_size=$(wc -c < "$transcript" 2>/dev/null | tr -d ' ')

    if [ -n "$file_size" ] && [ "$file_size" -gt 350000 ]; then
        date +%s > "$STATE_FILE"
        size_mb=$(echo "scale=1; $file_size / 1048576" | bc 2>/dev/null || echo "large")
        cat <<SYSMSG
CONTEXT THRESHOLD ALERT: Transcript size is ${size_mb}MB — estimated context usage exceeds the ${THRESHOLD_USED}% threshold.

REQUIRED ACTIONS — Execute immediately in this exact order:
1. Run the /context-manager skill NOW to save .context/learnings.md, .context/session_update.md, and .context/resume_actions.md
2. After files are saved, read .context/resume_actions.md and confirm the continuation instructions are correct
3. Inform the user: "Context running low. Session state saved. Clearing context now."
4. Execute /clear to free context
5. After clear, immediately read .context/resume_actions.md and continue work
SYSMSG
        exit 0
    fi
fi

# Below threshold — exit clean
exit 0
