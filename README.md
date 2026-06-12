# claude-context-harness

**Work all day in Claude Code without context rot — and make the harness better every session.**

This is a working harness built around two loops:

1. **The memory loop** — hooks watch context pressure, skills consolidate session knowledge into persistent file-based memory, and you `/clear` with confidence because everything important is already saved.
2. **The improvement loop** — end-of-session retrospectives ("how did we collaborate?") turn friction into feedback memories, hooks, and CLAUDE.md rules, so the next session is measurably better.

```
   work → hooks nudge delegation & watch context %
        → memory-capture (40%) / context-monitor (50%) prompt consolidation
        → /dream consolidates memories, /clear wipes the window
        → next session recalls from memory and starts clean
        ↘ session-retrospective → feedback memories / new hooks / new rules
```

## Quickstart

```
/plugin marketplace add mhardist/claude-context-harness
/plugin install context-discipline@claude-context-harness
/plugin install working-style@claude-context-harness
```

Then copy what you want from [`templates/`](templates/):
- [`CLAUDE.md.example`](templates/CLAUDE.md.example) — the context-discipline rules, local-knowledge-first pattern, and learn-from-mistakes instructions
- [`settings.json.example`](templates/settings.json.example) — secrets-deny permissions, pre-commit secret scan, edit-backup hook
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
| `ralph-simplify` | skill | Aggressively strips overengineering ("what would a child do?") |
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

## Credits

This harness stands on the work of Jesse Vincent, Affaan Mustafa, Jarrod Watts, Steph Ango, Geoffrey Huntley, Daniel Avila, nextlevelbuilder, claudekit, and Anthropic's example skills. See [CREDITS.md](CREDITS.md) for the full map and recommended companion installs.

## License

MIT — see [LICENSE](LICENSE).
