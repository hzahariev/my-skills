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

For a sizable backlog (30+), **delegate this pull to a subagent** that returns a compact, status-grouped digest (identifier, title, status, statusType, priority, team, assignee, estimate, updatedAt — **no descriptions**), so the full list stays out of context.

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

---

## Step 4 — Draft the Slack message

Slack mrkdwn (single `*` for bold). Keep it short. Translate eng statuses to plain English ("PR Merged / QA Ready" → "built, in QA"; "To Do Now" → "committed for dev"; "In Refinement" → "being scoped"). Name customers only where confident.

```
*🔝 CS Top Requests — where things stand (DD Mon)*

Quick status on the top customer requests — *N tracked across teams.* What's moved:

🚢 *Shipped*
• [TICKET-ID] Plain-English outcome — Customer

🧪 *Built — in QA / review (shipping soon)*
• [TICKET-ID] ... — Customer

🛠️ *Committed for dev (next up)*
• [TICKET-ID] ...

✍️ *Being scoped next*
• [TICKET-ID] ...

🧹 *Backlog cleanup*
• [TICKET-ID] ...

📊 *Of N:* a shipped · b in QA/review · c committed · d scoping · e backlog/triage · f closed

Board: https://linear.app/cubbystorage/view/cs-top-request-d222c215e4eb
```

**Format rules**
- Every bullet **starts with `[TICKET-ID]`**, then a plain-English description, then `— Customer` if known.
- One ticket per bullet — no `·`-joined multi-item lines.
- The 📊 snapshot counts must sum to the total N.
- Lead with what *moved*; don't list every backlog/triage item — summarize those as a count.

---

## Step 5 — Review, then send

Present the draft for review first. **Do not post to Slack without an explicit go-ahead and a confirmed channel.** These have been posted in `#product` before — offer that as the default, but confirm the channel. On approval, send via the Slack tool, or hand the text over for the user to post.
