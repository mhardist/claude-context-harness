# Local Knowledge: Write Down What Claude Keeps Re-Deriving

The `local-knowledge-first` hook reminds Claude to consult your local docs
before answering schema questions. But the hook only works if those docs
exist — and *authoring them* is the actual practice. This is the highest-ROI
habit in the harness that no plugin can install for you.

## The economics

Wrong answers are the most expensive context of all. When Claude guesses a
column name and gets it wrong, you pay three times: the wrong attempt, the
correction exchange, and the redo. A guessed-wrong SQL query against an
unfamiliar schema can burn thousands of tokens and several minutes; reading a
50-line authoritative markdown file costs almost nothing and is right the
first time.

Live exploration isn't much better than guessing: letting Claude introspect
a database (`\d+` on every table) or crawl an API floods the window with
output it needs once and drags around forever.

## The practice

Maintain a directory of authoritative markdown files for anything Claude
repeatedly needs and can't cheaply derive:

```
~/my-data-model/
├── Tables/
│   ├── orders.md          ← columns, types, gotchas ("amounts are varchar — cast!")
│   ├── customers.md
│   └── ...
├── apis.md                ← endpoints, auth patterns, rate limits
└── conventions.md         ← naming rules, environment map, deploy targets
```

Each file: what the thing is, exact names and types, and — most valuable —
the **gotchas** ("this table has placeholder rows; roll up before summing",
"this column is only populated when X"). Gotchas are precisely the knowledge
that's invisible in the data and expensive to rediscover.

Then wire the hook: set `LOCAL_KNOWLEDGE_PATHS` to point at the directory
and add your table names to `LOCAL_KNOWLEDGE_KEYWORDS` so the reminder
triggers on your domain vocabulary.

## How the docs stay current

Feed the improvement loop into them: every time a session discovers
something the docs didn't cover (a schema quirk, a casting trap, a
misleading column name), the retrospective or an in-the-moment capture adds
it to the relevant file. The docs compound the same way memory does — each
mistake is paid for exactly once.

## Rule of thumb

If Claude has derived the same fact in two different sessions, it belongs in
a file. The second derivation was already waste; don't pay a third time.
