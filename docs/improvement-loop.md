# The Improvement Loop

The second loop in this harness: **the harness itself gets better every
session.** Memory makes work continuous; retrospectives make it compound.

## The practice

At the end of any substantial session, ask — every time, as a ritual:

> "How did we work together in this session?"

The `session-retrospective` skill structures the answer: highlights,
lowlights, what Claude could have done better, what *you* could have done
better, and which skills/hooks/tools would have helped.

## The loop runs in both directions

This is the part most people miss: the retrospective improves the
**operator**, not just the harness. Half the friction in any session traces
back to how it was run, not how it was executed — and only the retrospective
surfaces that half:

- Context delivered too late ("if I'd mentioned the deadline up front,
  the whole first hour would have been scoped differently")
- Ambiguous scope ("'clean this up' meant formatting to me and refactoring
  to Claude")
- Interrupting work that was about to converge, or not interrupting work
  that was drifting
- Asking for output before asking for the plan, or vice versa

Where operator-side findings go: some become how you phrase and sequence
requests tomorrow; the durable ones go in the **user profile memory**
(`user_profile.md`) so Claude can meet you halfway — anticipating the
context you tend to omit, or asking the one clarifying question you'd
have wanted.

A harness that only improves the tool plateaus at the quality of its
instructions. One that improves both sides compounds.

## Converting findings into harness changes

Every piece of friction goes into exactly one of three places:

| Finding type | Where it goes | Example |
|---|---|---|
| Behavioral rule Claude should follow | **Feedback memory** (`feedback_*.md`, type: feedback) | "When I say 'no', treat it as disagreement — don't proceed as if I accepted" |
| Something the harness should *enforce*, not just remember | **A hook** | "Claude keeps reading 2,000-line files into main context" → `large-read-warning` hook |
| A standing instruction for every session | **CLAUDE.md rule** | "Delegate verbose work to subagents, report under 200 words" |

The decision rule: *memories* shape judgment, *hooks* enforce mechanics,
*CLAUDE.md* sets standing policy. If a lesson keeps getting violated as a
memory, promote it to a hook.

## A worked example (fictional, but the shape is real)

Session friction: Claude fired 12 parallel research agents and the laptop
went into swap for ten minutes.

Retrospective output → three artifacts:

1. **Feedback memory** — `feedback_parallel_agents.md`: "Hard ceiling of 5
   parallel agents on this machine. **Why:** 8 GB unified memory; observed
   heavy swap at 6+. **How to apply:** batch in groups of 3–4,
   pilot-then-fan-out."
2. **Hook** — `parallel-agent-guard.sh`: detects prompts implying mass agent
   dispatch and injects the ceiling reminder *before* Claude plans the work.
3. **CLAUDE.md line** — "Default to parallel agents when tasks are
   independent, ceiling 5."

The mistake can now only happen once.

## Capture lessons as they happen, too

Don't wait for the retrospective for clear mistakes. The moment something
goes wrong — a bug, a wrong assumption, a failed approach — capture it as a
feedback memory with: what happened, why, and the rule that prevents
recurrence. Retrospectives catch the patterns; in-the-moment capture catches
the incidents.

## Automated complement

[everything-claude-code](https://github.com/affaan-m/everything-claude-code)'s
`continuous-learning` skill does an automated version of this — extracting
reusable patterns from sessions into learned skills. It pairs well with the
manual retrospective: automation catches patterns you didn't notice, the
retrospective catches things only you can judge.
