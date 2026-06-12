# Subagent Delegation

The cheapest context is the context you never spend. Subagents run with
their own context window; only their final report (a few hundred words)
lands in yours. Their file reads, greps, and web fetches stay in *their*
window and die with them.

## The rule of thumb

Delegate when the work is **verbose but the answer is small**:

| Situation | Delegate? | Why |
|---|---|---|
| File read > 500 lines | Yes — `Explore` agent | You need the conclusion, not the file |
| Codebase-wide grep / "where is X handled?" | Yes — `Explore` agent | Many files touched, one answer needed |
| Multi-step research (web, docs, comparisons) | Yes — `general-purpose` agent | Dozens of fetches, one report |
| Single-fact lookup in a known file | No — just `Read` with offset/limit | Delegation overhead exceeds the read |
| Work requiring full conversation context | No | The subagent doesn't have your conversation |

Always tell the agent to **report under 200 words** (or whatever fits).
An unconstrained agent returns essays.

## Parallelism — with a ceiling

Independent tasks → parallel agents, launched in a single message. But each
concurrent agent costs real memory and CPU on your machine. On modest
hardware (8 GB unified memory), 6+ concurrent agents means swap.

The `parallel-agent-guard` hook injects a reminder when a prompt implies
mass dispatch. Set your own limit via `PARALLEL_AGENT_CEILING` (default 5).
For big fan-outs: pilot one agent first, confirm the prompt produces the
right shape of answer, then batch the rest in groups of 3–4.

## The supporting hooks

- `subagent-suggest` (UserPromptSubmit) — notices exploration-shaped prompts
  ("find all the places where…", "how does X work across the codebase") and
  nudges delegation before the main context starts reading files.
- `large-read-warning` (PreToolUse/Read) — warns before a big file read
  pollutes main context.
- `parallel-agent-guard` + `parallel-agent-pretool-guard` — the dispatch
  ceiling, at prompt time and at tool-call time.

## Why this matters for the memory loop

Delegation isn't just speed — it's what keeps you *under* the 40%/50%
capture thresholds for hours instead of minutes. Lean main context →
fewer panic saves → more work per session → better retrospectives.
