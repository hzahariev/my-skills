---
name: cs-requests-triage
description: Batch-groom CS Request backlog — fetch, analyze, label, size, and organize CS Request tickets from Linear. Use when user says "triage cs requests", "groom the backlog", or "organize cs tickets". Supports optional args like "CORE" (team filter) or "--limit 10" (cap ticket count).
disable-model-invocation: true
---

# CS Request Backlog Grooming

Fetch CS Request tickets from Linear, analyze each one, enrich with metadata, detect duplicates, and output an organized summary.

All intermediate analysis is written to a **run workspace** so results survive context limits, support parallel runs, and enable accurate cross-ticket comparison.

## Arguments (optional)

Parse any arguments passed after the skill name:

- **Team filter**: If the argument is `CORE` or `ENG` (case-insensitive), only fetch tickets from that team.
- **Limit**: If the argument contains `--limit N`, process at most N tickets (after filtering). Process the oldest tickets first (FIFO).
- If no arguments are provided, fetch from both teams with no limit (default behavior).

---

## Step 1 — Initialize workspace and fetch tickets

### 1a. Create run workspace

Create a timestamped workspace directory for this run:

```bash
mkdir -p "/Users/hzahariev/Documents/cubby work docs/cubby/.triage-runs/$(date +%Y-%m-%dT%H%M%S)-$$"
```

Store the path in a variable — all subsequent file writes go here. The workspace contains:
- `manifest.md` — list of tickets to process and their status (pending/done/skipped)
- `analysis.md` — per-ticket analysis results, appended as each ticket is processed
- `cross-team-pool.md` — cached cross-team issue list for duplicate detection
- `summary.md` — final summary (copied to terminal at the end)

### 1b. Fetch CS Request tickets

Fetch tickets from **both** the Core FMS and ENG teams (or a single team if a team filter argument was provided) that have the `🙋‍♂️ CS Request` label.

**Team names in the Linear API**: Use `Core FMS` (display name) and `ENG` as the `team` parameter. Ticket identifiers use the prefix `CORE-` for Core FMS and `ENG-` for ENG.

**Run the Core FMS and ENG fetches in parallel** — they are independent API calls.

For each team, call `list_issues` with:
- `team`: `Core FMS` or `ENG`
- `label`: `🙋‍♂️ CS Request`
- `limit`: 250

Only keep tickets where `statusType` is one of: `triage`, `backlog`, `unstarted`.
Discard any ticket where `statusType` is `started`, `completed`, `canceled`, or `duplicate`.

If `hasNextPage` is true, follow the `cursor` to fetch additional pages until all matching tickets are collected.

If a `--limit N` argument was provided, sort tickets by creation date (oldest first — FIFO, so neglected tickets get triaged before recent ones) and keep only the first N.

Collect all tickets into a single list. Note whether each ticket is from CORE or ENG (based on its identifier prefix).

Print: `Fetched N tickets (X from CORE, Y from ENG)`

---

## Step 2 — Check idempotency and filter

**Run comment checks in parallel** — each ticket's `list_comments` call is independent.

For each ticket, call `list_comments` with `issueId` set to the ticket identifier.

Scan the comments for any comment body containing the marker `<!-- cs-requests-triage` **or** the legacy marker `<!-- triage-cs-requests` (this skill's former name). The marker may include a version suffix like `<!-- cs-requests-triage v3 | 2026-06-23 -->` — match on **either** prefix to catch any version, so tickets triaged under the old name are still recognized as done.

If the marker is found, this ticket has already been processed — **skip it**.

Collect the remaining unprocessed tickets.

### Write manifest

Write `manifest.md` to the workspace:

```markdown
# Triage Run Manifest
Run started: [timestamp]
Team filter: [CORE / ENG / both]
Limit: [N or none]

## Tickets
| # | Identifier | Title | Team | Created | Status |
|---|-----------|-------|------|---------|--------|
| 1 | CORE-123 | Fix payment display | CORE | 2026-05-15 | pending |
| 2 | ENG-456 | Add export button | ENG | 2026-05-20 | pending |
...

Skipped (already triaged): [list of identifiers]
```

Print: `N tickets to process (M already triaged, skipped)`

If zero tickets remain, print `All tickets already triaged — nothing to do.` and stop.

---

## Step 3 — Build context (cross-team pool + projects)

**Run 3a and 3b in parallel** — they are independent.

### 3a. Fetch cross-team comparison pool

Fetch ALL issues from both the Core FMS and ENG teams, **regardless of status**, to build a comparison list for duplicate detection.

For each team (`Core FMS` and `ENG`), call `list_issues` with:
- `team`: the team name
- `limit`: 250

Do **not** filter by `statusType` — include issues in every status (triage, backlog, unstarted, started, completed, canceled, duplicate). This ensures we catch matches against work that's already done or in progress.

If `hasNextPage` is true, follow the `cursor` to fetch additional pages until all matching issues are collected.

Exclude issues that are already in the current CS Request batch (to avoid self-matching).

Write `cross-team-pool.md` to the workspace:

```markdown
# Cross-Team Comparison Pool
Fetched: [timestamp]
Total: N issues (X from Core FMS, Y from ENG)

## Issues
| Identifier | Title | Status Type | Team |
|-----------|-------|-------------|------|
| CORE-100 | Improve unit search | started | Core FMS |
| ENG-200 | Fix gate access timeout | completed | ENG |
...
```

Print: `Cross-team pool: N issues cached (X from Core FMS, Y from ENG)`

### 3b. Fetch existing projects

Call `list_projects` with `team: Core FMS` to get existing projects. This list is used during per-ticket analysis for project bundling.

---

## Step 4 — Analyze each ticket

For each unprocessed ticket, call `get_issue` with the ticket identifier to get the full description and metadata.

Analyze the ticket across all dimensions below, then **append the result to `analysis.md`** in the workspace before moving to the next ticket. This is critical — writing each analysis immediately means you can reference prior tickets accurately during cross-ticket comparison.

### Per-ticket analysis template

Append this block to `analysis.md` for each ticket:

```markdown
---
## [TICKET-ID]: [Title]
Created: [date] | Team: [CORE/ENG] | Age: [N days]
Existing labels: [list] | Existing priority: [priority or "none"]

### Standardized Title
Original: [original title]
New: [Page/Location]: [Brief summary]
Rationale: [why this title was chosen]

### Theme Label
[Theme label name] — [reason this theme fits best]

### Claude Suggested Effort Estimate
**[XS/S/M/L/XL]** (estimate=[1/2/3/5/8]) — [one-line rationale]

### Type
[Frontend / Backend / Frontend; Backend]

### Design Needed
[Yes / No] — [reason]

### Vibe Code Candidate
[Yes / No] — [reason]

### Suggested Priority
[Urgent / High / Medium / Low] — [reason]
[IF ticket already has a human-set priority: "Note: ticket already has priority [X] set by a human — my suggestion differs/agrees because [reason]"]

### Staleness
[IF ticket.createdAt is older than 30 days: "⚠️ STALE — created [N] days ago, still in [status]. PM should verify this is still relevant."]
[IF not stale: "Fresh — created [N] days ago"]

### ENG → CORE Reassignment
[Not applicable / Reassign to Core FMS / Ambiguous — needs manual review] — [reason]

### Needs Info
[No / Yes — list missing items]

### Affected Surfaces
[List the user-facing pages, dialogs, tabs, and controls affected — e.g., "Rentals page → Lease details drawer → Payment history tab"]

### Proposed Approach
[business-level description]

### Open Questions
[list or "None — ticket is well-defined."]

### Suggested Project
[project name or "No match"]
```

### Analysis criteria reference

#### Claude Suggested Effort Estimate

- **XS** (estimate=1): Under a day — typo, copy change, single config tweak, hyperlink fix
- **S** (estimate=2): 2–3 days — single-field addition, minor UI adjustment, simple validation
- **M** (estimate=3): 4–5 days — new feature touching multiple areas, moderate backend + frontend, new API endpoint
- **L** (estimate=5): 6–10 days — multi-component feature, new workflow, schema migration + backend + frontend
- **XL** (estimate=8): More than 10 days — large cross-cutting feature, architectural change, new subsystem

#### Type Classification

- **Frontend** — UI-only changes (React components, styling, client-side logic)
- **Backend** — Server-only changes (API endpoints, DB queries, business logic, migrations)
- **Frontend; Backend** — Requires changes on both frontend and backend

#### Vibe Code Candidate

A ticket is a **Vibe Code Candidate** if it involves truly trivial, no-engineer-needed changes that a PM could ship with Claude Code. Examples:
- Broken hyperlinks
- Text, label, or copy changes
- Tooltip or placeholder updates
- Feature flag toggles that are already wired up
- Pure cosmetic CSS tweaks

The litmus test: "Could a PM ship this with Claude Code without an engineer reviewing?" Size alone doesn't qualify — a small but complex backend change is NOT a Vibe Code Candidate.

If it doesn't clearly pass the litmus test, it is NOT a Vibe Code Candidate.

#### Suggested Priority

- **Urgent**: Actively blocking customers, causing revenue loss, or escalated by CS leadership
- **High**: Affecting multiple customers, frequently reported, significant friction
- **Medium**: Affects some customers, moderate friction, has workarounds
- **Low**: Nice-to-have, single customer request, cosmetic, has easy workarounds

Consider: how many customers are affected, is there a workaround, is revenue at risk, how often is it reported, and how old the ticket is (older neglected tickets may warrant a bump).

If the ticket already has a priority set by a human (the `priority` field is not null/none), note it explicitly. If your suggestion differs, explain why — but do **not** change the Linear priority field.

#### ENG → CORE FMS Team Reassignment (ENG tickets only)

For tickets with identifiers starting with `ENG-`, determine if the ticket falls under the **CORE FMS product scope**:

**In scope — reassign to Core FMS:**
- Facility surfaces: Home, Sitemap, Units, Pricing groups, Leads, Rentals, Collections, Shop, Payments, Reports, Walkthrough, Combo locks, Preferences
- Tasks module: Today, My tasks, All tasks, Completed, Archived
- Settings pages: Users, Roles, Teams, Workflows, Facility groups, Communication, Document templates, Coverage, Fee library, Lease configurations, Reservations, Payment fees, Product catalog, Inventory management
- Tenant Portal: Gate code display, lease details, payment status, and other tenant-facing surfaces
- Other: Payments processing, Physical mail, Gate access

**NOT in CORE FMS scope:**
- Settings pages: Pricing, Billing, General ledger mapping
- Anything not listed above (Comms AI, Storefront, Call center, etc.)

**Decision rules:**
- If the ticket **clearly** relates to a CORE FMS area → mark for reassignment
- If **ambiguous** (touches CORE FMS but also other areas, or unclear from description) → do NOT reassign, flag as "ambiguous — needs manual review" in the triage comment

#### Design Classification

A ticket needs the `Design` label if it involves ANY of:
- A new UI flow or page that doesn't exist yet
- Significant layout changes to an existing page
- New visual components or patterns not already in the design system
- UX redesign or changes to user-facing workflows that affect navigation or interaction patterns
- Changes to how information is visually organized or presented

Design is **NOT needed** if the ticket involves only:
- Data or copy changes (labels, text, messages)
- Backend-only work (API endpoints, business logic, migrations)
- Adding/removing columns in an existing data grid
- Simple form field additions using existing component patterns
- Bug fixes that restore existing behavior

#### Needs Info Quality Gate

Flag a ticket as `Needs Info` if ANY of these are true:
- **(a) Unclear problem**: The ticket doesn't clearly describe what is broken, missing, or needs to change
- **(b) No reproduction steps**: For bug reports, there are no steps to reproduce the issue and no expected vs. actual behavior described
- **(c) No customer context**: No information about who reported it, how many customers are affected, or how frequently the issue occurs
- **(d) Ambiguous scope**: The description is vague enough that the effort estimate would be unreliable (e.g., "improve the payments page" with no specifics)

When flagging `Needs Info`, list the specific items that are missing so they can be collected.

#### Standardized Title

Every ticket gets a standardized title following this naming convention:

```
[Page/Location]: [Brief action summary]
```

**Format rules:**
- The prefix is the **primary page or surface** where the change takes place (e.g., `Rentals`, `Sitemap`, `Payments`, `Tenant Portal`, `Permissions`)
- After the colon, a brief (3-8 word) summary of the change in imperative form (e.g., "Add source column", "Fix payment split display", "Allow deferred insurance upload")
- If the change spans multiple pages equally, use the most user-facing or primary surface
- Use common surface names: Rentals, Payments, Collections, Sitemap, Units, Leads, Tasks, Shop, Walkthrough, Tenant Portal, Permissions, Settings, etc.

**Examples:**
- `Rentals: Add a source column`
- `Shop: Add manager special feature`
- `Sitemap: Update reserved unit color`
- `Payments: Support split payment methods`
- `Permissions: Add granular discount toggle`
- `Tenant Portal: Allow deferred insurance upload`
- `Collections: Auto-generate lien notices`
- `Reports: Add facility group filtering`

The standardized title **replaces the original ticket title** via `save_issue`. The original title is preserved in the triage comment for reference.

#### Theme Label Assignment

Based on the primary surface/page identified during analysis, assign the **single best-fitting Core FMS theme label** from this list:

| Theme Label | Use when the ticket primarily touches... |
|---|---|
| `Theme: Rentals` | Leases, move-ins, move-outs, lease details, rental flow |
| `Theme: Payments` | Payment processing, payment methods, ledger entries, refunds, credits |
| `Theme: Collections` | Collections workflow, past-due accounts, debt recovery |
| `Theme: Lien & Auction` | Lien process, auction management, lien statuses |
| `Theme: Units` | Unit management, unit details, unit availability |
| `Theme: Sitemap` | Visual sitemap, sitemap editor, unit map colors/layout |
| `Theme: Leads` | Lead management, lead tracking, prospect pipeline |
| `Theme: Tasks` | Task management (today, my tasks, all tasks) |
| `Theme: Shop` | Merchandise, retail items, point-of-sale shop |
| `Theme: Permissions` | User permissions, role management, access control toggles |
| `Theme: Settings` | Facility settings, system configuration pages |
| `Theme: User Management` | User accounts, manager profiles, team management |
| `Theme: Tenants` | Customer/tenant profiles, tenant details page |
| `Theme: Insurance` | Coverage configurations, insurance/protection plans |
| `Theme: Notifications` | Alerts, notification settings, system notifications |
| `Theme: Templates` | Document templates, email/SMS templates |
| `Theme: Lease configuration` | Lease settings, lease terms, lease type configs |
| `Theme: Lease creation` | New lease flow, move-in wizard |
| `Theme: Move-outs` | Move-out process, move-out scheduling |
| `Theme: Unit transfers` | Unit-to-unit transfers |
| `Theme: Omnibar` | Global search, omnibar functionality |
| `Theme: Search` | Search features across surfaces |
| `Theme: Activity Log` | Activity/audit log |
| `Theme: Facility Ops` | General facility operations, facility-level features |
| `Theme: Bulk Actions` | Bulk operations across any surface |
| `Theme: Datagrid enhancements` | Data grid/table improvements (columns, filters, sorting) across any surface |
| `Theme: Waive & Credit` | Fee waivers, credits, adjustments |
| `Theme: Portfolio-wide UX` | Cross-facility or portfolio-level UX changes |
| `Theme: Integrations` | Third-party integrations |
| `Theme: Message sequences` | Automated message sequences, drip campaigns |
| `Theme: Walkthrough` | Walkthrough/inspection feature |

**Rules:**
- Assign exactly **one** theme label per ticket — pick the single best fit
- Only assign theme labels from the list above (these are the Core FMS team labels)
- If no theme label fits well (e.g., the ticket is about a non-Core-FMS surface like Storefront, RevMan, or Comms), do NOT assign a theme label
- The theme label is added to the `labels` array in `save_issue` alongside all other labels
- For ENG tickets that stay in ENG (not moved to Core FMS), do NOT assign a Core FMS theme label

#### Project Bundling

Using the project list fetched in Step 3b, for each ticket:
- If it clearly belongs to an existing project (based on theme labels and description), note the project name
- If multiple unprocessed tickets share a theme but have no project, suggest they be bundled into a new project

After analyzing each ticket, update its row in `manifest.md` status from `pending` to `analyzed`.

Print progress: `Analyzed [N/total]: [TICKET-ID] — [Size] [Type] [Priority]`

---

## Step 5 — Cross-ticket comparison

**Read `analysis.md` and `cross-team-pool.md` from the workspace** to perform accurate comparison. Do not rely on memory of earlier analysis — read the files.

### 5a. Within-batch comparison

Compare all analyzed tickets pairwise:
- **Duplicates**: Two tickets describe the exact same problem/request. Mark the newer one as `duplicateOf` the older one.
- **Related**: Two tickets are about the same area or feature but describe different aspects. Link them using `relatedTo`.

Look for: similar titles, overlapping descriptions, same feature area, same customer complaint.

### 5b. Cross-team scan

For each CS Request ticket, compare it against the cross-team pool (from `cross-team-pool.md`):
- Check for **title similarity** — similar wording, same feature area mentioned
- Check for **description keyword overlap** — same customer names, same error messages, same surface area

Categorize each match:

1. **Duplicate** — the matched issue describes the exact same problem/request. Mark the CS Request ticket as `duplicateOf` the matched issue.
2. **Related** — the matched issue is about the same area or feature but describes a different aspect. Link using `relatedTo`.
3. **Potential Fix in Progress** — the matched issue has a `statusType` of `started` AND has at least one linked pull request. To check for PRs: call `get_issue` on the matched issue and look for GitHub PR URLs in the issue's attachments, relations, or description. Do NOT mark as duplicate — just surface it in the triage comment so the PM can check if the incoming fix covers this request.

### 5c. Write comparison results

Append a `## Cross-Ticket Comparison` section to `analysis.md`:

```markdown
## Cross-Ticket Comparison

### Within-batch
- CORE-123 ↔ CORE-456: **duplicate** (CORE-456 is newer → mark as duplicateOf CORE-123)
- CORE-789 ↔ ENG-101: **related** (both touch Payments)

### Cross-team matches
- CORE-123 → CORE-050: **related** (same surface, different ask)
- ENG-456 → CORE-300: **potential fix in progress** (CORE-300 is In Review, PR #1234)

### No matches
- CORE-789: no duplicates or related tickets found
```

Print: `Cross-ticket scan: D duplicates, R related, F potential fixes in progress`

---

## Step 6 — Apply changes and post comments

**Read `analysis.md` from the workspace** for the definitive analysis of each ticket. Do not rely on memory.

### 6a. Apply changes to each ticket

For each analyzed ticket, call `save_issue` with the ticket identifier and:

- `title`: the standardized title (e.g., `Payments: Support split payment methods`). This replaces the original ticket title.
- `estimate`: the numeric estimate (XS=1, S=2, M=3, L=5, XL=8)
- `labels`: an array containing ALL existing labels on the ticket PLUS the new ones. Include:
  - All labels the ticket already has (to preserve them, especially `🙋‍♂️ CS Request`)
  - `Claude Triaged` — always applied to every ticket that receives a triage comment
  - `Frontend` and/or `Backend` based on the type classification
  - `Design` if the ticket requires designer involvement
  - `Vibe Code Candidate` if applicable
  - `Needs Info` if the ticket is missing critical information
  - The assigned **Theme label** (e.g., `Theme: Payments`) if one was identified — only for Core FMS tickets or ENG tickets being moved to Core FMS
- For ENG tickets that clearly fall under CORE FMS scope: `team`: `Core FMS` — this moves the ticket to the Core FMS team so it appears in the [CS Requests view](https://linear.app/cubbystorage/team/CORE/view/cs-requests-00bc39fed084). The ticket identifier will change from `ENG-XXXX` to `CORE-XXXX` after the move.
- If a matching project was identified: `project`: the project name

If the ticket was identified as a duplicate, also call `save_issue` with `duplicateOf` set to the older ticket's identifier.

If the ticket has related tickets, call `save_issue` with `relatedTo` set to an array of related ticket identifiers.

### 6b. Post triage comment

For each processed ticket, call `save_comment` with `issueId` set to the ticket identifier.

Use this comment template (fill in the values from `analysis.md`):

```
<!-- cs-requests-triage v3 | [YYYY-MM-DD] -->

> **TL;DR**: [One sentence: what this ticket is, how big it is, and whether it's actionable as-is. E.g., "Small frontend fix to add a missing column to the Payments grid — ready to pick up."]

## Triage Assessment

| Field | Value |
|---|---|
| **Effort Estimate** | [XS/S/M/L/XL] — [one-line rationale] |
| **Type** | [Frontend / Backend / Frontend; Backend] |
| **Theme** | [Theme label name, e.g., "Payments"] |
| **Design** | [Yes / No] |
| **Suggested Priority** | [Urgent / High / Medium / Low] |
| **Vibe Code Candidate** | [Yes / No] |

### Title Standardization

| Original Title | New Title |
|---|---|
| [original ticket title] | [new standardized title] |

[CONDITIONAL — only if ticket already has a human-set priority that differs from the suggestion:]
> **Priority note**: This ticket already has priority **[existing]** set by a human. My analysis suggests **[suggested]** because [reason]. Keeping the existing priority — adjust if needed.

[CONDITIONAL — only if ticket is older than 30 days:]
> **⚠️ Stale**: This ticket was created [N] days ago and is still in [status]. Please verify it's still relevant before prioritizing.

### Problem Statement

[2-3 sentences describing what is broken, missing, or needs to change — written from the customer's perspective. What are they experiencing? What can't they do?]

### Business Rationale

[Why this matters: which customers are affected, how many, how frequently the issue occurs, whether revenue is at risk, whether there's a workaround, and how this aligns with product priorities.]

### Affected Surfaces

[List the user-facing pages, dialogs, tabs, and controls that this change touches — described from the user's perspective. E.g., "Rentals page → Lease details drawer → Payment history tab", "Tenant Portal → Pay Now button → Payment method selector", "Settings → Lease configurations → Delinquency section"]

### Proposed Approach

[Business-level description of what the solution should accomplish. Describe the desired outcome and behavior, NOT implementation details or code changes. E.g., "Allow facility managers to split a payment across multiple methods at the point of sale" rather than "Add a splitPayment endpoint to PaymentsApiController."]

### Open Questions

- [List unresolved ambiguities, decisions that need to be made, dependencies on other teams, or edge cases that need clarification]
- [If no open questions, write "None — ticket is well-defined."]

[CONDITIONAL — only include this section if the ticket was flagged as Needs Info:]
### ⚠️ Information Gaps

This ticket is missing critical information needed to properly scope the work:
- [ ] [Specific missing item, e.g., "No reproduction steps — need exact steps to trigger the bug"]
- [ ] [Another missing item, e.g., "No customer context — which facility/customer reported this?"]

---

<details>
<summary>Team & Project</summary>

**Team reassignment**: [Not applicable / Moved from ENG to Core FMS / Ambiguous — needs manual review]

**Suggested project**: [Project name if matched, or "Consider bundling with [TICKET-IDs] into a new project for [theme]", or "No project match"]

</details>

<details>
<summary>Related Tickets</summary>

**Duplicates**: [TICKET-ID if duplicate found, or "None detected"]
**Related**: [TICKET-IDs if related found, or "None detected"]
**Potential Fix in Progress**: [TICKET-ID (status, PR link) if a matched issue is actively being worked on with a linked PR, or "None detected"]

[Include matches from both within-batch comparison and cross-team scan.]

</details>

---
*Auto-generated by Hristo Zahariev's /cs-requests-triage skill (v3)*
```

After posting the comment, update the ticket's row in `manifest.md` status from `analyzed` to `done`.

---

## Step 7 — Summary

### 7a. Write summary to workspace

Write `summary.md` to the workspace with the full summary table and totals.

### 7b. Print terminal summary

Print the summary table to the terminal:

```
## CS Request Triage Summary
Run: [timestamp] | Workspace: [path]

| Ticket | New Title | Original Title | Theme | Size | Priority | Type | Design | Vibe | Needs Info | Stale | Team Move | Related |
|--------|-----------|----------------|-------|------|----------|------|--------|------|------------|-------|-----------|---------|
| [CORE-XXX](https://linear.app/cubbystorage/issue/CORE-XXX) | [new title] | [original title] | Payments | M | High | FE; BE | No | No | No | No | — | CORE-YYY |
| [ENG-XXX](https://linear.app/cubbystorage/issue/ENG-XXX) | [new title] | [original title] | — | S | Medium | FE | Yes | Yes | No | ⚠️ 45d | → Core FMS | — |
...

### Totals
- Tickets processed: N
- Already triaged (skipped): M
- Labels applied: Frontend=X, Backend=Y, Design=D, Vibe Code Candidate=V, Needs Info=I
- Tickets moved ENG → Core FMS: A
- Stale tickets (30+ days): S
- Duplicates found: B
- Related links created: C (within-batch) + E (cross-team)
- Potential fixes in progress: F
- Workspace: [full path to run directory]
```

Truncate titles to 50 characters maximum in the table. Format ticket identifiers as markdown hyperlinks using the pattern `[CORE-XXX](https://linear.app/cubbystorage/issue/CORE-XXX)`. In the Type column, use abbreviations: `FE` for Frontend, `BE` for Backend, `FE; BE` for both. In the Stale column, show the age in days if 30+ days old.

---

## Important Rules

- **Standardize ticket titles** — replace the original title with the `[Page/Location]: [Brief summary]` format. Never modify ticket descriptions.
- **Never change the Linear priority field** — only suggest priority in the comment. If a human already set priority, acknowledge it.
- **Preserve all existing labels** — when updating labels via `save_issue`, always include all existing labels plus any new ones
- **Be conservative on team reassignment** — only move ENG tickets when the match to CORE FMS scope is clear. When in doubt, flag for manual review.
- **Be conservative on duplicates** — only mark as duplicate when the tickets are clearly describing the same issue. Prefer `relatedTo` over `duplicateOf` when unsure.
- **Be conservative on Needs Info** — only flag when information is genuinely missing, not when the ticket is simply brief but clear. A short, well-defined request does not need the `Needs Info` label.
- **Always write analysis to the workspace file before moving to the next ticket** — do not rely on context memory for cross-ticket comparison.
- **Always read workspace files when referencing prior analysis** — especially in Steps 5 and 6.
- **Workspace files are the source of truth** — if your memory of an analysis conflicts with what's written in `analysis.md`, trust the file.
