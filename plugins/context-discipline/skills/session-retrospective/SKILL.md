---
name: session-retrospective
description: Use when the user asks how a session went or how we collaborated — "How did we collaborate in this session?", highlights/lowlights, what could Claude or the user do better/faster, or which skills/agents/hooks/tools/MCP would improve our work. Triggers on end-of-session reflection and retrospective requests.
---

# Session Retrospective

## Overview
Run a grounded retrospective on the *current* session: assess how we collaborated, surface highlights and friction, and turn the friction into concrete tooling recommendations (skills, subagents, hooks, MCP, tools/permissions) — then persist the durable lessons to memory. Every claim cites a specific moment from THIS session; no generic advice.

## When to use
- User asks any of: "How did we collaborate?", "highlights/lowlights?", "what could you/I do better/faster?", "any skills/hooks/agents/tools/MCP that would help?"
- End of a substantial session, before `/clear`, or after a milestone.

## Process

1. **Reconstruct the session (evidence first).** Scan the conversation for: the goal, what got delivered, key decisions, dead-ends/rework, repeated manual steps, tool/permission friction, wrong assumptions, and points where the user had to redirect. Note timestamps/turns so every finding is citable.

2. **Score the collaboration.**
   - **Highlights** — what worked and *why* (e.g. canary-before-bulk caught a problem early; delegating reads to subagents kept context lean).
   - **Lowlights** — friction and *root cause* (e.g. rework from a wrong assumption; repeated re-discovery; a permission denial loop; missing upfront domain context).

3. **Find the time sinks.** For each lowlight, name the cause class: missing context, unclear/late requirements, repeated manual command, slow tool path, wrong default, blocked-on-creds/IP, or context bloat.

4. **Recommend improvements — match the fix to the cause.** Don't default to "make a skill." Route each to the right mechanism:

   | Friction observed | Right fix |
   |---|---|
   | Rework from a wrong assumption / unclear requirement (often the **biggest** time sink) | **behavior + memory**: confirm the load-bearing definition / success criterion BEFORE building; save the lesson as `feedback` |
   | A *multi-step* judgment/technique you'll re-apply across projects | **new skill** (a *single* tip → a `reference` memory or extend an existing skill — don't spin up a whole skill for one trick) |
   | A heavy read / broad search / parallelizable work done inline | **subagent / parallel agents** |
   | "Always/whenever/before X do Y" automation, perm allowlist, env | **hook / settings** → use `update-config` (memory can't enforce behavior) |
   | An external service you hand-rolled API calls for | **MCP server** (see `mcp-guide`) |
   | Repeated permission prompts on safe commands | **allowlist** → `fewer-permission-prompts` / `update-config` |
   | A durable fact, preference, or "work this way" lesson | **memory** (this step 6) |

   A single finding can map to two fixes (e.g. a behavior change *and* a memory note). Route it to both.

   Also state **what the USER could do** (e.g. give constraints/domain semantics upfront, confirm the success criterion early) and **what Claude could do** (e.g. surface the tradeoff sooner, scope before fanning out).

5. **Present the report** (concise, scannable):
   - **Highlights** · **Lowlights** · **Faster next time** (1–3 changes for each side) · **Recommended additions** (table: item → type → the moment it addresses) · **Saved to memory** (list).

6. **Persist the durable items to memory.** For each lesson worth keeping, write/update a memory file per the user's memory convention (`type: feedback` for "how to work together" lessons — include **Why** and **How to apply**; `type: project`/`reference` for facts/pointers). Update `MEMORY.md` with a one-line hook. **Don't save** one-off trivia, automation/tooling fixes (those go to config/MCP, not memory), or a lesson that's just a *known CLAUDE.md rule being missed* — there the fix is adherence or a hook, not a duplicate memory. If a recommendation is an *automation* (hook/permission/setting), don't just note it in memory — offer to apply it via `update-config`.

## Principles
- **Evidence > vibes.** Cite the actual turn/decision; if you can't point to it, drop it.
- **Match fix to cause** (table above). Skills are for judgment you'll re-use; hooks/settings are for automation; memory is for durable facts/preferences.
- **Actionable & few.** 2–4 high-leverage recommendations beat a long generic list.
- **Two-sided.** Always include something the user could do differently, not just Claude.
- **Close the loop.** Actually write the memory files and offer to apply config changes — don't just recommend them.

## Common mistakes
- Generic advice not tied to this session → useless; re-anchor to a real moment.
- Recommending a "skill" for something that's really a hook/permission/MCP → wrong mechanism.
- Listing lessons but not saving them (or saving session trivia that won't matter next time).
- Only critiquing Claude; skipping what the user could do to get results faster.
