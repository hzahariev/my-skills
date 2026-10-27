---
name: prime-backlog-update
description: Draft a weekly status update on the Prime go-live backlog (the Linear "Prime Backlog" view: PRIME-labelled issues in projects labelled "Prime Go Live Feedback", across all squads) — pull current statuses, group by lifecycle, highlight what moved, and format it as a ready-to-send Slack message for #c_prime-storage. Use when the user says "prime backlog update", "prime status update", "where does prime's backlog stand", or invokes /prime-backlog-update.
disable-model-invocation: true
---

# Prime Backlog — Weekly Slack Update

Produce a short, leadership-friendly Slack message on where Prime's go-live feedback stands: what shipped, what's in QA/review, what's committed for dev, what's being scoped, and recent backlog cleanup. Plain-English status (no eng jargon), one ticket per bullet, each bullet leading with its `[TICKET-ID]` and ending with the owning squad.

Scope = the Linear view **Prime Backlog** (https://linear.app/cubbystorage/view/prime-backlog-7e9e48ebdec5): every issue carrying the `PRIME` label whose **project** carries the project label `Prime Go Live Feedback`. The view spans squads (Core FMS, Communications, Storefront, and any squad that labels a project this way). Do **not** filter by team.

---

## Step 1 — Pull the view

The Linear MCP cannot evaluate the view's project-label filter (`list_issues` with `customView` returns nothing), so rebuild the view in two calls:

1. `list_projects` with `label`: `Prime Go Live Feedback`, no `team` filter, `fields`: `id, name, teams, status`. Follow `cursor` until complete. Today this is six projects (four Core FMS, one Storefront, one Communications); never hardcode the list — a squad can add a project at any time.
2. For **each** project: `list_issues` with `project`: the project id, `label`: `9cedd0aa-1a69-49f9-9ecf-b92b993a9b58` (the `PRIME` issue label, filter by ID), `limit`: `100`, `fields`: `id, title, status, statusType, priority, team, assignee, project, parentId, completedAt, canceledAt, updatedAt` — **no descriptions**. Follow `cursor` until complete. Keep sub-issues (the view shows them).

Merge the lists (dedupe by id). Without descriptions the pull is small enough to do inline; only for a very large backlog (80+) **delegate the pull to a subagent** that returns a compact, status-grouped digest. `completedAt` and `canceledAt` are required for Step 3.

Sanity: the view holds roughly 40–60 issues. Fewer than 15 means the pull failed; stop and say so rather than report on a partial set.

---

## Step 2 — Group by lifecycle

Squads name their states differently, so bucket by `statusType` first and by name only where one type splits:

| Group | Maps from |
|---|---|
| 🚢 Shipped | `statusType` completed (Released, Done / Shipped) |
| 🧪 Built — in QA / review | `statusType` started (In Progress, PR in Review, Merged, In QA / Design Review) |
| 🛠️ Committed for dev | `statusType` unstarted **and** state named Ready for Dev / To Do Now |
| ✍️ Being scoped next | `statusType` unstarted **and** state named In Refinement / In Design |
| 📋 Backlog / triage | `statusType` backlog or triage |
| 🧹 Closed | `statusType` canceled or duplicate (Cancelled, Won't Fix / Can't repro, Duplicate) |

Any other `unstarted` state a squad uses (e.g. a plain Todo) counts as 🛠️ Committed for dev, so the 📊 counts always reconcile to N.

---

## Step 3 — Identify what moved

The update is about **change**, not a full dump. Surface:
- Issues whose **status changed** since the cutoff (entered QA/review, became committed, got closed) and their current status.
- Grooming you can see in the data: duplicates merged or closed, cancellations, items promoted to dev. If the user has context on recent changes, weave it in.

Evidence rule: only `status`, `completedAt` and `canceledAt` count as movement. `updatedAt` alone is **not** evidence — bulk label or project edits touch it — so never infer a re-spec or a promotion from `updatedAt`.

### 🚢 Shipped is newly-shipped-only (do NOT re-list past shipments)

The `🚢 Shipped` **bullet list** contains **only tickets that reached a completed state _since the previous update_** — never the full set of shipped items (that set only grows and re-announces things the channel already saw).

Compute it from each issue's **`completedAt`**, not from the text of the last Slack post:
1. Find the **cutoff** — the `ts` of the most recent prior `Prime backlog — status update` parent message in `#c_prime-storage` (channel `C08RLE6HBQS`): `slack_read_channel` with `oldest` = unix timestamp of today − 14 days, `limit` 100, `response_format` concise, matching the parent on that exact title text. Note its date for the header (`(DD Mon)`). If there is no prior post (first run), the cutoff is **00:00 UTC of today − 7 days**; write the header as `new since DD Mon` with that date.
2. `🚢 Shipped` bullets = issues in a completed state whose **`completedAt` ≥ cutoff** (timestamps are UTC).
3. If none, keep the section and write `Nothing new shipped since <DD Mon>.` under the header.

This is the one section that is a **delta**, not a census. Everything else (QA/review, committed, scoping, backlog, cleanup) reflects current state.

For each duplicate or cancelled issue closed since the cutoff, call `get_issue` with `includeRelations: true` so the cleanup bullet can name the canonical ticket (`duplicateOf`); if that fails, report the closure without a reason.

---

## Step 4 — Draft the Slack message

Slack mrkdwn (single `*` for bold). Keep it short. Translate eng statuses to plain English ("Merged" / "PR in Review" → "built, in QA"; "Ready for Dev" → "committed for dev"; "In Refinement" → "being scoped"). Write outcomes the way Prime's operations team would describe them, not as ticket titles.

```
*🏷️ Prime go-live backlog — where things stand (DD Mon)*

Quick status on Prime's go-live feedback — *N tracked across squads.* What's moved:

🚢 *Shipped — new since last update (DD Mon)*
• [TICKET-ID] Plain-English outcome — Squad
_(only tickets that newly reached a completed state since the previous update — see Step 3; if none, write "Nothing new shipped since DD Mon.")_

🧪 *Built — in QA / review (shipping soon)*
• [TICKET-ID] ... — Squad

🛠️ *Committed for dev (next up)*
• [TICKET-ID] ... — Squad

✍️ *Being scoped next*
• [TICKET-ID] ... — Squad

🧹 *Backlog cleanup*
• [TICKET-ID] ... — Squad

📊 *Of N:* a shipped · b in QA/review · c committed · d scoping · e backlog/triage · f closed _(duplicates of other tickets or cancelled/won't do)_

Board: https://linear.app/cubbystorage/view/prime-backlog-7e9e48ebdec5
```

**Format rules**
- Every bullet **starts with `[TICKET-ID]`**, then a plain-English description, then `— Squad` (Core FMS, Comms, Storefront, …).
- 🧪 bullets carry the real sub-status in parentheses before the squad: `(built, in QA)` for Merged / PR in Review / In QA, `(in development)` for In Progress — never call an In Progress item built.
- Keep it short: 🛠️ and ✍️ list **at most 6 bullets each** — items that entered the group since the cutoff first, then by priority — and close a truncated section with `_+N more in Linear_`. 🚢 lists the full delta and 🧪 lists everything (it is short).
- One ticket per bullet — no `·`-joined multi-item lines.
- The 📊 snapshot counts must sum to the total N. The `a shipped` count is the **cumulative census** — every issue currently in a completed state — so it is normally **larger** than the number of bullets in `🚢 Shipped` (delta-only per Step 3). That difference is expected; keep the census count so the row still sums to N.
- Always gloss the "closed" count in plain English.
- Lead with what *moved*; don't list every backlog/triage item — summarize those as a count.
- In the cleanup section, only claim reasons for closures you can verify (e.g. a duplicate's canonical ticket); otherwise report counts.
- Never @-mention people or groups.

---

## Step 5 — Send

The channel is `#c_prime-storage` (ID `C08RLE6HBQS`).

Posting pattern (two messages):
1. Parent message to the channel: just the short bold title — `Prime backlog — status update (DD Mon)`.
2. The full update from Step 4 as the **first thread reply** on that parent (`thread_ts` = parent's ts).

**Interactive runs** (Hristo invoked the skill in a conversation): present the draft for review first and do not post without an explicit go-ahead.

**Scheduled/unattended runs** (weekly routine): publish automatically — no review step. Before posting, check the channel's recent messages; if a `Prime backlog — status update` parent was already posted within the last 6 days, exit without posting (double-run guard). After posting, report the parent message link and the snapshot line.
