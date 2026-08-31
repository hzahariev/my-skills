---
name: cs-requests-update
description: Draft a CS-leadership status update on the 🔝 CS Top Request backlog — pull current statuses across all teams, group by lifecycle, highlight what moved, and format it as a ready-to-send Slack message. Use when the user says "cs requests update", "cs top requests update", "backlog update for CS leadership", or invokes /cs-requests-update.
disable-model-invocation: true
---

# CS Top Requests — Leadership Slack Update

Produce a short, CS-leadership-friendly Slack message on where the top customer requests stand: what shipped, what's in QA/review, what's committed for dev, what's being scoped, and recent backlog cleanup. Plain-English status (no eng jargon), one ticket per bullet, each bullet leading with its `[TICKET-ID]`.

The `🔝 CS Top Request` label is **workspace-wide** — it spans many teams (Core FMS, Product, Onboarding, Reporting, Storefront, Communications, Revenue Management). Do **not** filter by team.

---

## Step 1 — Pull the current backlog

Fetch every issue carrying the `🔝 CS Top Request` label, with current statuses (the user may have changed some since the last update).

Call `list_issues` with:
- `label`: `0efe4774-742f-4c5c-b7cf-9ea812608863` — the `🔝 CS Top Request` label ID. Filter by **ID**; the name has an emoji prefix and won't match as plain text.
- `orderBy`: `updatedAt`
- `limit`: `50`

If `hasNextPage` is true, follow the `cursor` until all are collected. Do not pass a `team` filter.

For a sizable backlog (30+), **delegate this pull to a subagent** that returns a compact, status-grouped digest (identifier, title, status, statusType, completedAt, priority, team, assignee, estimate, updatedAt — **no descriptions**), so the full list stays out of context. `completedAt` is required for the Shipped delta in Step 3.

---

## Step 2 — Group by lifecycle

Bucket issues by status into CS-friendly groups:

| Group | Maps from statuses |
|---|---|
| 🚢 Shipped | Done / Shipped, completed |
| 🧪 Built — in QA / review | PR Merged / QA Ready, PR in Review, In Progress |
| 🛠️ Committed for dev | To Do Now |
| ✍️ Being scoped next | In Refinement |
| 📋 Backlog / triage | Backlog, Icebox, Triage |
| 🧹 Closed | Cancelled, Won't Fix, Duplicate |

---

## Step 3 — Identify what moved

The update is about **change**, not a full dump. Surface:
- Issues updated in roughly the **last 7 days** and their current status.
- Any grooming/consolidation done recently — re-specs, duplicates merged or closed, items promoted to dev. If the user has context on recent changes, weave it in.

### 🚢 Shipped is newly-shipped-only (do NOT re-list past shipments)

The `🚢 Shipped` **bullet list** must contain **only tickets that reached Done _since the previous update_** — never the full set of Done items carrying the label (that set only grows, so re-dumping it makes the section longer every week and re-announces things CS already saw).

Compute it from each issue's **`completedAt`** timestamp (request it in the `list_issues` `fields`), **not** from the text of the last Slack post:
1. Find the **cutoff** — the post time of the most recent prior `CS Top Requests — where things stand` message in `#cs-top-requests` (channel `C08BL0S0L6R`). Note its date for the header (`(DD Mon)`).
2. `🚢 Shipped` bullets = issues in a completed state whose **`completedAt` is after that cutoff**.
3. If none, don't drop the section — write `Nothing new shipped since <DD Mon>.` under the header.

Why `completedAt` and not diffing the last post's `[TICKET-ID]`s: once posts are delta-only, the previous post lists just *its* week's shipments, so subtracting its IDs would re-surface everything shipped before it. `completedAt` is immune to that.

This is the one section that is a **delta**, not a census. Everything else (QA/review, committed, scoping, backlog, cleanup) reflects current state.

---

## Step 4 — Draft the Slack message

Slack mrkdwn (single `*` for bold). Keep it short. Translate eng statuses to plain English ("PR Merged / QA Ready" → "built, in QA"; "To Do Now" → "committed for dev"; "In Refinement" → "being scoped"). Name customers only where confident.

```
*🔝 CS Top Requests — where things stand (DD Mon)*

Quick status on the top customer requests — *N tracked across teams.* What's moved:

🚢 *Shipped — new since last update (DD Mon)*
• [TICKET-ID] Plain-English outcome — Customer
_(only tickets that newly reached Done since the previous update — see Step 3; if none, write "Nothing new shipped since DD Mon.")_

🧪 *Built — in QA / review (shipping soon)*
• [TICKET-ID] ... — Customer

🛠️ *Committed for dev (next up)*
• [TICKET-ID] ...

✍️ *Being scoped next*
• [TICKET-ID] ...

🧹 *Backlog cleanup*
• [TICKET-ID] ...

📊 *Of N:* a shipped · b in QA/review · c committed · d scoping · e backlog/triage · f closed _(duplicates of other tickets or cancelled/won't do)_

Board: https://linear.app/cubbystorage/view/cs-top-request-d222c215e4eb
```

**Format rules**
- Every bullet **starts with `[TICKET-ID]`**, then a plain-English description, then `— Customer` if known.
- One ticket per bullet — no `·`-joined multi-item lines.
- The 📊 snapshot counts must sum to the total N. The `a shipped` count here is the **cumulative census** — every issue currently in Done — so it will normally be **larger** than the number of bullets in the `🚢 Shipped` section (which is delta-only, per Step 3). That difference is expected, not an error; keep the census count so the row still sums to N.
- Always gloss the "closed" count in plain English (closed = duplicates of other tickets or cancelled/won't do) — CS leadership shouldn't have to guess what it means.
- Lead with what *moved*; don't list every backlog/triage item — summarize those as a count.
- In the cleanup section, only claim reasons for closures you can actually verify (e.g. a duplicate's canonical ticket); otherwise just report counts.

---

## Step 5 — Send

The channel is `#cs-top-requests` (ID `C08BL0S0L6R`).

Posting pattern (two messages):
1. Parent message to the channel: just the short bold title — `CS Top Requests — status update (DD Mon)`.
2. The full update from Step 4 as the **first thread reply** on that parent (`thread_ts` = parent's ts).

**Interactive runs** (Hristo invoked the skill in a conversation): present the draft for review first and do not post without an explicit go-ahead.

**Scheduled/unattended runs** (weekly routine): publish automatically — no review step. Before posting, check the channel's recent messages; if a "CS Top Requests — status update" parent was already posted today, exit without posting (double-run guard). After posting, report the parent message link and the snapshot line.
