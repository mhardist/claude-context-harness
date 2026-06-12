#!/bin/bash
# Pre-Read Large File Warning
#
# Fires BEFORE a Read tool call. If the target file is large AND the caller
# didn't specify offset/limit (= reading the whole thing), injects a warning
# suggesting subagent delegation or section reads.
#
# Non-blocking: the Read proceeds. This is a nudge, not a block.

input=$(cat)

file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')
offset=$(echo "$input" | jq -r '.tool_input.offset // 0')
limit=$(echo "$input" | jq -r '.tool_input.limit // 0')

# If caller is already being disciplined (offset/limit specified), stay silent
if [ "$offset" != "0" ] || [ "$limit" != "0" ]; then
    exit 0
fi

# File must exist to measure it
[ ! -f "$file_path" ] && exit 0

# Line count — cheap, bounded
lines=$(wc -l < "$file_path" 2>/dev/null | tr -d ' ')
[ -z "$lines" ] && exit 0

# Threshold: 500 lines. A 500-line file is usually 3-8K tokens.
if [ "$lines" -gt 500 ]; then
    jq -n --arg lines "$lines" --arg fp "$file_path" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        additionalContext: ("[CONTEXT GUARD] About to Read \($fp) — \($lines) lines (likely 3-10K tokens). Prefer one of:\n" +
          "  1. Read with offset/limit on the specific section you need\n" +
          "  2. Grep first to find the exact line, then Read with offset around it\n" +
          "  3. Agent(subagent_type=Explore) with a focused question and \"report under 200 words\" — keeps the file out of main context entirely\n" +
          "This is a nudge, not a block. If you genuinely need the whole file in main context, proceed.")
      }
    }'
fi

exit 0
