# The Memory System

The point of this harness: **context windows are disposable, knowledge is not.**
Once everything important lives in files, `/clear` stops being scary and long
work stops rotting.

## Where memory lives

Claude Code gives every project a persistent directory that survives `/clear`:

```
~/.claude/projects/<project-slug>/memory/
```

(`<project-slug>` is your project path with slashes replaced by dashes.)

Inside, the convention is **one fact per file**, with an index:

```
memory/
├── MEMORY.md                      ← the index — one line per memory, loaded each session
├── user_profile.md                ← who you are, how you like to work
├── feedback_<topic>.md            ← corrections & validated approaches ("type: feedback")
├── project_<name>.md              ← ongoing work, goals, constraints
└── reference_<thing>.md           ← pointers to external systems, dashboards, docs
```

Each memory file has frontmatter:

```markdown
---
name: short-kebab-slug
description: one-line summary used to decide relevance during recall
metadata:
  type: user | feedback | project | reference
---

The fact. For feedback/project memories, follow with **Why:** and
**How to apply:** lines. Link related memories with [[their-name]].
```

Rules that keep it healthy:

- **Update, don't duplicate.** Check `MEMORY.md` before writing a new file.
- **Don't save what the repo already records** (code structure, git history,
  CLAUDE.md content).
- **Convert relative dates to absolute** ("last Tuesday" is useless in July).
- **Delete memories that turn out to be wrong.**

## The capture pipeline (hooks + skills)

Three moments where knowledge gets captured, ordered by urgency:

| Trigger | Component | What happens |
|---|---|---|
| 40% context used | `memory-capture` hook (one-shot) | Gentle nudge: review the session for durable findings, promote them to persistent memory while there's headroom |
| 50% context used | `context-monitor` hook | Panic save: triggers the `context-manager` skill — session state, learnings, and resume actions written to `.context/` scratch + durables promoted |
| End of day / on demand | `/dream` skill | Consolidation: merges accumulated signal into topic files, prunes the index, removes duplicates — like sleep for the harness |

`.context/` (in the working directory) is **scratch** — session state and
resume actions for picking up where you left off. The `memory/` directory is
**durable** — it outlives `/clear`, project switches, and months of time.

## Save continuously — the thresholds are the backstop, not the engine

The hooks above fire at pressure points, but the system works best when
saving is *continuous*: Claude writes progress and resume-state notes to
memory at logical checkpoints — after a decision, a completed phase, a
durable finding — not only when a threshold trips. (The
`CLAUDE.md.example` template includes this as a standing instruction.)

This inverts the usual relationship with the context window. When memory is
always current, low context availability stops being scary: you can clear —
or crash, or close the laptop — at any moment and resume with confidence.
The hooks exist for the sessions where the checkpointing discipline slipped.

## Clear, don't compact

When context runs low you have two options, and they are not equivalent:

- **Compaction** summarizes your conversation automatically. It's lossy, you
  don't control what survives, and the summary degrades with each round —
  the harness deciding what mattered.
- **Clearing** wipes the window after *you* (and your skills) have written
  what mattered to structured memory files. Nothing is lost because the
  durable knowledge was extracted deliberately, with names, links, and an
  index — and the next session reloads exactly the files it needs instead
  of dragging a blurry summary of everything.

This harness is built for clearing. Compaction is the fallback you should
rarely hit — and the thresholds make it *unreachable* by design: auto-compact
fires above ~90% used, but this harness intervenes at 40% (promote durables)
and 50% (checkpoint + clear). The clear cycle completes twice over before
compaction's threshold is even approachable. If you ever see a compaction
warning while running this harness, that's a signal the checkpoint loop
broke — investigate, don't just compact.

Two supporting habits:

- **Put context % in your statusline** (see `templates/settings.json.example`)
  so you watch the window drain in real time instead of discovering pressure
  when the warning appears.
- **Save continuously at checkpoints** (rule 4 in `CLAUDE.md.example`) so the
  50% intervention is a non-event — everything durable is already on disk.

## The payoff: /clear with confidence

The loop in practice:

1. Work normally. Hooks watch context pressure silently; memory gets
   updated at every logical checkpoint.
2. At 40%, promote remaining durables. At 50%, checkpoint everything.
3. `/clear`. The window is empty; the knowledge isn't.
4. Next session starts clean, recalls from `MEMORY.md`, and continues.

A 4-hour workday becomes six or eight short, sharp sessions instead of one
long degrading one.
