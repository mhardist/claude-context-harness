---
name: context-manager
description: >
  Use when context is running low, "save context", "preserve context",
  "context checkpoint", "prepare for context clear", or when conversation
  exceeds ~50 messages/tool calls. Auto-preserves session knowledge before /clear.
  Also saves intermediate data results (metrics, file paths, environment context)
  for multi-phase analytical workflows.
user-invocable: true
---

# Context Manager

Preserve session knowledge when context runs low, enabling seamless continuation after context clear.

## When to Activate

### Automatic Triggers (Self-Monitor)

Claude MUST proactively activate this skill when ANY of these conditions are detected:

| Condition | Threshold | Why |
|-----------|-----------|-----|
| Message count | ~40-50 back-and-forth messages | Proxy for context consumption |
| Tool call density | >30 tool calls in session | Heavy tool use = fast context drain |
| Large file reads | Multiple files >500 lines read | Large content fills context quickly |
| Response truncation | Output feels cut off | Direct signal of context pressure |
| Explicit warning | Claude mentions "context" or "running low" | Self-awareness trigger |

### Manual Triggers

User explicitly requests:
- `/context-manager` or `/context-save`
- "save context" or "preserve context"
- "context checkpoint"
- "prepare for context clear"

### Threshold-Based Monitoring

Claude SHOULD continuously gauge remaining context and act at these thresholds:

| Remaining | Action |
|-----------|--------|
| ~50% | **Checkpoint** -- save intermediate results (data, file paths, key findings) to `.context/session_state.json` so work can resume without re-running |
| ~25% | **Full preservation** -- execute the complete Protocol below (Steps 1-6) |
| ~5% | **Emergency save** -- write `resume_actions.md` immediately, inform user, and recommend `/clear` |

## Protocol

**CRITICAL:** Execute ALL steps in order. Do not skip steps.

### Step 1: Announce & Prepare

```
Initiating context preservation protocol...
```

Create directory if it doesn't exist:
```bash
mkdir -p .context
```

### Step 2: Update learnings.md

**REPLACE the file with current durable patterns.** Do NOT append session history.

learnings.md should contain ONLY reusable patterns that prevent recurring mistakes -- not session-specific details, firm-specific facts, or one-time debugging artifacts. Those belong in git history.

```markdown
# Durable Patterns & Gotchas

> Reusable patterns that prevent recurring mistakes. Session-specific details live in git history.
> Last updated: [TODAY'S DATE]

## [Category 1]
- [Pattern that prevents a recurring mistake]
- [Another durable pattern]

## [Category 2]
- [Pattern]
```

**Size limit: ~50 lines max.** If the file exceeds 50 lines, prune the least-reusable entries.

**Quality check:**
- Every entry should be something you've hit 2+ times or would definitely hit again
- Delete anything firm-specific, person-specific, or one-time
- Delete performance benchmarks from specific runs
- Delete edge cases about specific data records
- If a pattern is already documented in CLAUDE.md, don't duplicate it here

### Step 3: Update session_update.md

Add new session entry at top. **Keep max 3 entries total.** Delete older entries -- git preserves them.

```markdown
# Session Updates

> Keep max 3 recent entries. Older sessions are preserved in git history.

## Session: [TODAY'S DATE] ([Brief Title])

### Summary
[One sentence: what was accomplished]

### Key Changes
- `path/to/file` -- [what changed]

### Commits
- `abc1234` -- [commit message]

---
```

**Size limit: ~60 lines max** across all entries. Be concise.

### Step 4: Update resume_actions.md

**OVERWRITE this file.** It contains ONLY transient state for the next session.

```markdown
# Resume Actions

> Transient state only. Permanent reference lives in CLAUDE.md.
> Generated: [TODAY'S DATE]

## Current Goal
[What we're working on, or "No active work" if complete]

## Immediate Next Steps
[Numbered list, or "None pending" with potential future work]

## Transient Context
[ONLY information that would be lost and isn't in CLAUDE.md]
```

**Size limit: ~30 lines max.** Do NOT duplicate anything from CLAUDE.md (DB access, pipeline stages, CSV rules, deploy patterns, schema reference). If it's permanent knowledge, it belongs in CLAUDE.md, not here.

### Step 4.5: Data Checkpoint (session_state.json)

**For analytical/multi-phase workflows only.** Skip this step for pure coding sessions.

Create/update `.context/session_state.json` to preserve intermediate computation results so the next session can resume without re-running expensive operations.

**OVERWRITE this file** (always reflects current state):

```json
{
  "generated": "[TODAY'S DATE AND TIME]",
  "workflow": "[Name of the multi-phase workflow]",
  "current_phase": "[Which phase we're in]",
  "completed_phases": [
    {
      "phase": "[Phase name]",
      "result_files": ["path/to/output1.csv"],
      "summary": "[What this phase produced]"
    }
  ],
  "key_metrics": {
    "[metric_name]": "[value]"
  },
  "data_locations": {
    "input": "[Path to input data]",
    "final_output": "[Path to completed output if any]"
  },
  "next_phase": {
    "action": "[What to do next]",
    "inputs_ready": true
  }
}
```

Only include fields that have actual values. Remove unused fields.

### Step 5: Verify Files

Confirm all files exist and are within size limits:
```bash
wc -l .context/learnings.md .context/session_update.md .context/resume_actions.md
```

If any file exceeds its limit, prune it before proceeding.

### Step 6: Promote durables to PERSISTENT memory (NEW — critical bridge)

The `.context/` directory is working-dir scratch — it dies when you switch projects. Anything reusable across projects / sessions / months must be promoted to the persistent memory system:

```
~/.claude/projects/<project-slug>/memory/
```

(The project slug is your project path with slashes replaced by dashes, e.g.
`/Users/you/myproject` → `-Users-you-myproject`.)

Before /clear, review `.context/learnings.md` and the session for items that belong in persistent memory rather than project-local scratch:

| Type | Goes to persistent memory? |
|------|---------------------------|
| New feedback rule the user taught | **YES** — `feedback_*.md`, linked from MEMORY.md |
| New project fact (who/what/why/when, convert relative dates to absolute) | **YES** — `project_*.md` |
| New reference pointer (external system, dashboard, tool, person) | **YES** — `reference_*.md` |
| User profile update (role, preferences, knowledge) | **YES** — update `user_profile.md` |
| Project-local coding pattern, file path, or CLAUDE.md-covered rule | **NO** — stays in `.context/learnings.md` only |
| Git history / commit-covered info | **NO** — let git be the source of truth |

Rules:
- **Check MEMORY.md FIRST** — update existing files when possible, don't duplicate
- Feedback/project entries: lead with rule/fact, then **Why:** and **How to apply:** lines
- One memory per file, one-line entry in MEMORY.md
- If nothing durable exists, say "no cross-session durables to promote" and skip

### Step 7: Clear & Resume

1. **Inform user:**
   ```
   Context preservation complete. Saved to .context/ (working-dir) and
   ~/.claude/projects/<project-slug>/memory/ (persistent, if durables found).
   - learnings.md: [N] durable patterns
   - session_update.md: [N] recent sessions
   - resume_actions.md: Ready for continuation
   - persistent memory: [N new/updated files, or "no durables"]

   Executing /clear now...
   ```

2. **Clear context:** Run `/clear`

3. **Resume immediately:** After clear completes, read `.context/resume_actions.md` and continue work

## File Location

```
.context/
├── learnings.md        # Durable patterns only (~50 lines max)
├── session_update.md   # Last 3 sessions (~60 lines max)
├── resume_actions.md   # Transient state (~30 lines max)
└── session_state.json  # Data workflow state (when applicable)
```

## Key Principles

- **learnings.md REPLACES** each time with current durable patterns -- not a historical log
- **session_update.md keeps max 3 entries** -- delete older ones, git has the history
- **resume_actions.md OVERWRITES** -- always fresh, always minimal
- **Single source of truth** -- don't duplicate CLAUDE.md content in any .context file
- **Size discipline** -- if a file is growing, you're doing it wrong

## Anti-Patterns (DO NOT)

- Append endlessly to learnings.md (it becomes unreadable and wastes context)
- Include firm-specific or person-specific details in learnings.md
- Duplicate DB access patterns, pipeline stages, or deploy patterns from CLAUDE.md
- Keep more than 3 session entries in session_update.md
- Write resume_actions.md longer than 30 lines
- Include "What Was Completed" history in resume_actions.md (that's session_update.md's job)
