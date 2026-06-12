# The Always-Loaded Budget

Some context is spent before you type your first word, every single session.
Most people never measure it. There are three fixed costs, and one rule
governs all of them.

## The three fixed costs

| Source | When it loads | What's lazy |
|---|---|---|
| `CLAUDE.md` (global + project) | Every session, in full | Nothing — every line is a per-session tax |
| Skill **descriptions** | Every session (the index) | Skill **bodies** — they only load when a skill fires |
| MCP tool schemas | Depends — always-on servers load all their tools | Archived servers cost zero until activated |

Measure yours:

```bash
# CLAUDE.md tax (chars / 4 ≈ tokens)
for f in ~/.claude/CLAUDE.md ./CLAUDE.md; do
  c=$(wc -c < "$f" 2>/dev/null); echo "$f: ~$((c / 4)) tokens/session"; done

# Skill-description tax (your enabled set)
find ~/.claude/skills -name SKILL.md | while read f; do
  awk '/^---$/{n++; next} n==1 && /^description:/,/^[a-z_-]+:/' "$f"; done | wc -c
```

## The rule: zero duplication with on-demand sources

The goal is not minimization — a few thousand tokens of standing rules is
cheap insurance compared to one wrong-answer correction cycle. The goal is
that **nothing always-loaded restates something that loads on demand.**

`CLAUDE.md` should hold exactly two kinds of content:

1. **Behavioral rules** — how Claude should work ("delegate verbose work",
   "never overwrite deliverables without a backup")
2. **Facts Claude can't discover** — your environment map, account layout,
   vault locations

Everything else — procedures, syntax references, tool walkthroughs, routing
tables — belongs in a skill, where it costs nothing until the moment it's
needed. If your CLAUDE.md contains a markdown-syntax cheat sheet that also
lives inside a skill, you're paying for it twice in every session and using
it in almost none.

## Skill descriptions are index entries, not brochures

The description is the only part of a skill that's always in context. Write
it like a card-catalog entry: what it does, when it triggers, in one or two
sentences. A 1,000-character description costs ~250 tokens per session
forever; a 150-character one triggers just as reliably.

## Disable what you don't use

A disabled plugin's skills vanish from the index entirely — the plugin-level
mirror of MCP archiving. Let usage data decide: grep your transcripts for
`"skill":"<name>"` to see what actually fires (that's how `ralph-simplify`
got cut from this very repo — zero invocations in a month of sessions).

## How this compounds with the rest of the harness

The always-loaded budget is the *fixed* cost; delegation, grep-first
reading, and the clear/memory loop manage the *variable* cost. Trimming
fixed overhead raises the ceiling on every session equally — it's the only
optimization here that pays off even in your shortest sessions.
