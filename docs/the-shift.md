# The Shift: Why You Keep Compacting, and How to Stop

If you're here, the pattern probably looks like this: your best Claude Code
sessions run long. Somewhere past the first couple of hours, answers get
vaguer, earlier decisions get forgotten, and eventually the auto-compact
warning appears. You compact, lose some thread of what you were doing,
and limp on. Tomorrow you re-explain your project from scratch.

Every part of that is fixable, but not with a bigger context window and not
with better compaction. It requires a different mental model. This page is
the long version of that model; the rest of the repo is the machinery that
implements it.

## The wrong model: the window as a filing cabinet

The instinct is to treat the context window as *storage* — the place where
project knowledge accumulates. Under that model, a long session is an asset
("Claude finally understands my codebase!") and clearing is a catastrophe
(all that understanding, gone). So you hold on. The window fills with stale
file reads, dead-end explorations, and resolved discussions. Quality
degrades long before the window is full — context rot is gradual, not a
cliff. And when compaction finally fires, an algorithm you don't control
summarizes four hours of work into a paragraph, deciding for itself what
mattered.

Notice the trap: the more valuable your session, the more you fear losing
it, the longer you hold it, the worse it gets.

## The right model: the window as a workbench

A workbench is where *active* work happens. You bring out the tools and
materials for the current task; when the task is done, you put them away and
wipe the bench. Nobody stores their tools ON the bench — that's what the
shelves are for.

In this model:

- **Files are the shelves.** Decisions, project facts, learned gotchas, and
  resume-state live in structured markdown — named, indexed, linkable,
  reloadable on demand. (See [memory-system.md](memory-system.md).)
- **Sessions are disposable.** A session exists to complete a task, write
  down what it learned, and end. The knowledge survives; the conversation
  doesn't need to.
- **Clearing is routine, not loss.** `/clear` is wiping the bench after the
  work is shelved. Measured in practice: a median session of 1.47 MB,
  3–4 sessions a day, compaction in under 4% of sessions.

Compaction never gets *fixed* in this model — it gets *obsoleted*. The
auto-compact threshold sits above ~90% of the window; this harness clears
at 50%. You stop compacting for the same reason a kitchen with a dish
routine never runs out of plates.

## Why you don't clear today: trust, not tooling

Here's the real blocker, and it's psychological, not technical. You don't
avoid `/clear` because you can't press the button. You avoid it because you
don't *believe* everything important is saved. And under the filing-cabinet
model, you're right — it isn't. The knowledge lives only in the
conversation, so clearing genuinely destroys it. Your fear is accurate.

The harness's actual product is making that fear obsolete, mechanically:

1. **Continuous checkpointing** — Claude saves decisions, progress, and
   resume-state to memory files at logical checkpoints throughout the
   session, as a standing instruction (rule 4 in the CLAUDE.md template).
   Not at the end. Not when you remember to ask. Continuously.
2. **Hooks as the safety net** — if checkpointing slips, the
   `memory-capture` hook nudges at 40% used and `context-monitor` insists
   at 50%. In a month of measured use, the alert fired in 75% of sessions
   and the response was always the same: save inline, clear, continue.
3. **Proof through repetition** — the first time you clear and the next
   session picks up exactly where you left off (because it read
   `resume_actions.md` and the memory index), the fear loses its grip. By
   the tenth time, clearing feels like saving a document — an obvious,
   boring, safe operation.

Trust is the deliverable. The hooks and skills are just how it's built.

## What changes in practice

**Before:** one heroic 6-hour session. Hours 1–2 are sharp. Hour 3 starts
re-reading files it already read. Hour 4 contradicts a decision from hour 1.
Hour 5 compacts. Hour 6 is spent re-establishing what survived. Tomorrow
starts from zero.

**After:** the same day is five or six short sessions. Each starts clean,
reads a ~700-token memory index plus exactly the files it needs, does one
coherent chunk of work at full sharpness, writes its learnings to memory,
and ends. Verbose work — big file reads, codebase-wide searches, research —
runs in subagent windows that never touch the main bench (measured: 28% of
all transcript bytes diverted). Tomorrow's first session reads the index
and continues mid-thought.

The counterintuitive part: you lose *nothing* by ending sessions early, and
you lose *continuously* by extending them. Once memory is always current,
session length stops being how you measure progress. Files are.

## The habits, in priority order

If you adopt only part of this, adopt from the top:

1. **Save continuously, clear at completion boundaries.** The core habit.
   Memory always current → clearing always free → rot never accumulates.
2. **Delegate verbose work to subagents.** The biggest single lever on
   consumption (28% of bytes in measured use). The conclusion comes back;
   the file dumps stay in the subagent's disposable window.
3. **Search before reading, bound your reads.** Grep for the answer instead
   of reading the file; use offset/limit when you must read.
4. **Watch the gauge.** Put context % in your statusline
   (`templates/settings.json.example`). Pressure you can see is pressure
   you act on early.
5. **Close the loop.** End substantial sessions with "how did we work
   together?" — and let the answers improve both the harness and how you
   run it ([improvement-loop.md](improvement-loop.md)).

Expect the guards to fire constantly in week one — that's the system
teaching. In the measured data, the delegation nudge fired in just 6% of
sessions and the hard agent-ceiling in 3%, because the behaviors they
enforce had become habits. Good guards retire themselves.

## One sentence

Stop trying to make the context window remember things — that's what files
are for — and the compaction problem doesn't get solved, it disappears.
