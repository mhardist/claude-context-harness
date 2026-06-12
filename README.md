# claude-context-harness

**Work all day in Claude Code without context rot — and make the harness better every session.**

This is a working harness built around two loops:

1. **The memory loop** — knowledge is saved to persistent file-based memory *continuously* at logical checkpoints (with pressure-triggered hooks as the backstop), so you `/clear` with confidence — clear, not compact — because everything important is already saved.
2. **The improvement loop** — end-of-session retrospectives ("how did we collaborate?") turn friction into feedback memories, hooks, and CLAUDE.md rules, so the next session is measurably better.

```
   work → hooks nudge delegation & watch context %
        → memory-capture (40%) / context-monitor (50%) prompt consolidation
        → /dream consolidates memories, /clear wipes the window
        → next session recalls from memory and starts clean
        ↘ session-retrospective → feedback memories / new hooks / new rules
```

## Measured results

One month of real daily use (108 main sessions, ~3.6/day, mined from actual transcripts):

- **3.7% compaction rate** — auto-compact fired in 4 of 108 sessions. The threshold arithmetic works: clearing at 50% means the ~90% compaction trigger is almost never reached.
- **28% of all transcript bytes diverted to subagents** — 147.5 MB of reads, greps, and research ran in 801 disposable subagent windows instead of the main context. 56% of sessions delegated, ~7 dispatches per delegating session.
- **Median session: 1.47 MB** — short, sharp sessions instead of long degrading ones, because the memory system makes clearing free.
- **Search-first reading** — 1,598 grep/search commands vs 1,957 full-file reads, and 43.5% of reads bounded with limit/offset.
- **The guards retire themselves** — the 50% panic-save skill fired *zero* times (continuous checkpointing keeps sessions below it) and the delegation nudge fired in only 4 sessions (delegation became habit). The hooks that still fire (large-read warning, 32% of sessions) are the ones still teaching.

## Quickstart

```
/plugin marketplace add mhardist/claude-context-harness
/plugin install context-discipline@claude-context-harness
/plugin install working-style@claude-context-harness
```

Then copy what you want from [`templates/`](templates/):
- [`CLAUDE.md.example`](templates/CLAUDE.md.example) — the context-discipline rules, local-knowledge-first pattern, CLI-first tool preferences, and learn-from-mistakes instructions
- [`settings.json.example`](templates/settings.json.example) — context-% statusline, secrets-deny permissions, pre-commit secret scan, edit-backup hook
- [`mcp.json.example`](templates/mcp.json.example) — MCP config with env-var placeholders and the activate-on-demand philosophy

## What's inside

### Plugin: `context-discipline` (the hero)

| Component | Type | What it does |
|---|---|---|
| `dream` | skill | Memory consolidation — merges session signal into topic files, prunes the index |
| `context-manager` | skill | Checkpoint before /clear — saves session state, learnings, resume actions |
| `session-retrospective` | skill | "How did we collaborate?" — harvests friction into harness improvements |
| `context-monitor` | hook (PostToolUse) | Panic-save trigger at 50% context used |
| `memory-capture` | hook (PostToolUse) | One-shot nudge at 40% to promote durable knowledge to memory |
| `subagent-suggest` | hook (UserPromptSubmit) | Nudges delegation of exploration work to subagents |
| `large-read-warning` | hook (PreToolUse/Read) | Warns before large file reads pollute main context |
| `parallel-agent-guard` + `parallel-agent-pretool-guard` | hooks | Caps runaway parallel agent dispatch |
| `local-knowledge-first` | hook (UserPromptSubmit) | Reminds Claude to consult your authoritative local docs before guessing |

### Plugin: `working-style`

| Component | Type | What it does |
|---|---|---|
| `prompt-architect` | skill | Turns vague ideas into explicit, buildable prompts |
| `seven-advisors` | skill | Multi-perspective decision council — six de Bono-style advisors + a Stakeholder voice, run in parallel, synthesized |
| `mcp-guide` | skill | Which MCP server to use, when |
| `/mcp-activate-*` | commands | Activate MCP servers on demand instead of always-on — saves context every session |

The `/mcp-activate-*` commands read archived server configs from
`~/.claude/mcp-archive/` (one JSON file per server — see
[`templates/mcp-archive/context7.json`](templates/mcp-archive/context7.json)
for the format). Archive the servers you use occasionally, keep your default
config empty, and activate on demand.

## How the memory system works

See [`docs/memory-system.md`](docs/memory-system.md). The short version: memory is a directory of one-fact-per-file markdown notes with an index (`MEMORY.md`) that loads each session. Hooks prompt capture at context-pressure thresholds; `/dream` consolidates; `/clear` is safe because the files persist.

## The improvement loop

See [`docs/improvement-loop.md`](docs/improvement-loop.md). Ask "how did we collaborate this session?" at the end of substantial work; convert each finding into a feedback memory, a hook, or a CLAUDE.md rule. The harness compounds.

## Subagent delegation

See [`docs/subagent-delegation.md`](docs/subagent-delegation.md). Verbose work (big reads, codebase-wide greps, multi-step research) goes to subagents whose tool results never touch your main context.

## Local knowledge

See [`docs/local-knowledge.md`](docs/local-knowledge.md). Write down what Claude keeps re-deriving — authoritative markdown docs for your schemas, APIs, and gotchas. Wrong answers are the most expensive context of all; a 50-line file read beats a guessed-wrong query every time.

## More context practices

- **Context % in your statusline** — the statusline in `settings.json.example` shows `ctx:N%` every turn. Visibility is what makes you act at 50% instead of discovering pressure at the compaction warning.
- **Why this harness never compacts** — auto-compact fires above ~90% used; this harness clears at 50%. The threshold arithmetic makes compaction unreachable by design (see [`docs/memory-system.md`](docs/memory-system.md)).
- **Fat skills, thin CLAUDE.md** — your `CLAUDE.md` loads into every session; skills load only when triggered. Keep CLAUDE.md down to standing rules and a routing table, and push detailed procedures into skills. Same progressive-disclosure idea as MCP archiving, applied to instructions.
- **CLI-first tools** — terse CLI output (`psql`, `gcloud`, content extractors) over SDK exploration and raw page fetches. See the section in `CLAUDE.md.example`.

## Credits

This harness stands on the work of Jesse Vincent, Affaan Mustafa, Jarrod Watts, Steph Ango, Geoffrey Huntley, Daniel Avila, nextlevelbuilder, claudekit, and Anthropic's example skills. See [CREDITS.md](CREDITS.md) for the full map and recommended companion installs.

## License

MIT — see [LICENSE](LICENSE).
