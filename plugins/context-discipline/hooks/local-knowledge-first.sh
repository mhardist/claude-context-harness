#!/bin/bash
# UserPromptSubmit hook: injects a reminder to consult your local, authoritative
# docs before answering database or schema questions. Silent when the prompt
# doesn't mention schema/DB keywords.
#
# Configure by setting LOCAL_KNOWLEDGE_PATHS (in settings.json "env" or your
# shell profile) to a short description of where your authoritative docs live,
# e.g.:
#   LOCAL_KNOWLEDGE_PATHS="1. ~/my-data-model/Tables/*.md — table schemas. 2. ~/my-vault/ — platform knowledge."
#
# Optionally set LOCAL_KNOWLEDGE_KEYWORDS to extend the trigger regex with
# your own table names (misses are expensive; stray reminders are harmless).

paths="${LOCAL_KNOWLEDGE_PATHS:-your local schema docs and knowledge base (configure LOCAL_KNOWLEDGE_PATHS to name them)}"
extra_keywords="${LOCAL_KNOWLEDGE_KEYWORDS:-}"

prompt=$(jq -r '.prompt // ""')

# Match schema/database intent. Tuned to prefer false positives over misses —
# a stray reminder is harmless, a missed one causes column-name guessing.
regex='(schema|column|postgres|psql|select |insert |update |delete from|database table|data model|which table|what columns|column names|join .* on)'
if [ -n "$extra_keywords" ]; then
  regex="${regex%)}|${extra_keywords})"
fi

if echo "$prompt" | grep -iE "$regex" > /dev/null 2>&1; then
  jq -n --arg paths "$paths" '{
    hookSpecificOutput: {
      hookEventName: "UserPromptSubmit",
      additionalContext: "[LOCAL KNOWLEDGE FIRST — read before answering] This prompt mentions database/schema concepts. You MUST consult these local sources before writing SQL or naming columns:\n\n\($paths)\n\nRules:\n- Do NOT guess column names, types, or relationships. Look them up.\n- If unsure which DB a table lives in, check the local docs before querying.\n- This reminder is automated, not manual. Treat it as a hard precondition."
    }
  }'
fi
