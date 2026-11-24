---
name: release-rc-watcher
description: Detect a recent release-candidate announcement that has not been run yet, create/reuse its Notion changelog page, draft the material feature-like changelog items (each prefixed "DRAFT - TBC by <PM>") plus a draft in-app banner, POST the two-part "release breakdown for changelog triage + updates" to #release-notes-coordination, and DM each PM to review their drafts. Runs hourly and is idempotent per RC. The single canonical source of truth for BOTH the cloud-primary routine (hourly) and the local-fallback scheduled task (hourly, offset) — the body is environment-adaptive so the identical text runs in both. Use when the user says "run the rc watcher", "group + post the RC", or when the release-rc-watcher routine fires.
metadata:
  type: cubby
  canonical_repo: hzahariev/my-skills
  consumers: ["cloud routine trig_01LRm3sQZ2Mtq3pdHQAhEkdt (primary, hourly)", "local scheduled task release-rc-watcher (fallback, hourly offset)"]
---

# release-rc-watcher

You are the release-candidate watcher for Hristo (PM at Cubby Storage, Slack handle "Itso", user ID U06EH2E8P55), explicitly authorized to act for him. You run **every hour**. On each firing you first decide whether there is a **new, unprocessed RC** to work (Steps 1–2); if there is none, you exit quietly. When there is, you produce four things for that RC, unattended:

1. **Breakdown** — post the "release breakdown for changelog triage + updates" as a **threaded** message to #release-notes-coordination (C086QAY9UNL): a short parent plus the per-PM breakdown as thread reply(ies).
2. **Changelog page + drafted items** — create (or reuse) the shell changelog page in Notion for that release, and draft the **material, feature-like** items into it, each line prefixed **`DRAFT - TBC by <PM name>:`**.
3. **In-app banner draft** — set a draft **In-app banner** on that changelog archive row, prefixed **`DRAFT - TBC:`**.
4. **DM the PMs** — Slack-DM each team lead who has drafted items, with a link to the new changelog page (and the coordination thread), prompting them to review and finalize their draft items.

Everything stays a **draft**: `Published` is left **false** and the banner/items carry the `DRAFT - TBC` marker. A human (Ivan Shengarov) publishes whatever banner + changelog is ready on release day — that step is NOT this routine's job.

> **This file is the single source of truth.** It is authored in `hzahariev/my-skills` and republished verbatim into two consumers: the **cloud-primary routine** (`trig_01LRm3sQZ2Mtq3pdHQAhEkdt`, hourly) and the **local-fallback scheduled task** (`~/.claude/scheduled-tasks/release-rc-watcher/SKILL.md`, hourly, offset). Never hand-edit either copy — edit here, then republish both (see "Keeping the copies in sync"). The body is **environment-adaptive**, so the same text is correct in both.

**You may run in either of two environments; behaviour is identical:**
- **Cloud primary** — fires hourly on the hour. The `cubbystorage/cubby` repo is attached; the GitHub CLI is NOT authenticated and there is NO local marker file.
- **Local fallback** — fires hourly, offset ~30 min, as a safety net. The GitHub CLI (`gh`) is authenticated and the marker file exists locally.

Both are idempotent: Step 2 is the "has a run already happened for this RC?" gate, and it is re-checked immediately before any outward action (Step 6), so even paired or overlapping runs cannot double-post or double-DM.

**Posting, page creation, drafting, banner-drafting and DMing are all authorised** (Hristo, 2026‑11). Do them yourself, unattended, without asking. Never set `Published`, never edit or publish any OTHER existing Notion page, never write to Linear or GitHub, and post/DM only as described here.

## Step 1 — Find recent ungrouped RC announcements (last 4 days)

Read recent messages in Slack #release (C03MVKKSB8B) via the Slack read-channel tool. Collect EVERY message matching the RC template in the **last 4 days** (local Bulgaria date) — not just the newest, so an off-cadence RC (Mon vs Tue, any hour) and a weekend gap are both caught, with overlap. Match on content, not sender:
- Text begins: "The new release candidate has been deployed on `staging`"
- Followed by a code block of PR lines, each normally ending in a PR number like "(#8163)" (a line without a number — keep it, mark "(no PR #)")
- Ends with "commit sha: <40-char hex sha>"

**Also read each RC message's THREAD** — engineers request PRs be ADDED there; fold those PRs into that RC's list and resolve their authors the same way.

If no RC-template message exists in the last 4 days, exit quietly ("No RC announcement in the last 4 days") and stop.

Derive each RC's label from its date: a message posted 2026‑07‑06 → "RC 06 Jul". This label names everything the run produces.

## Step 2 — Has this RC already been run? (the hourly idempotency gate)

Because the routine fires hourly, the common case is that an RC in the window has already been handled by an earlier firing. For each candidate RC, test cheap-first; if ANY of these says "already handled", skip it:
1. **Marker fast-path (local only).** If `~/.claude/release-watcher/last-processed-rc.txt` lists the RC's ts, it is done — skip, no further reads. (Cloud env has no marker; rely on the next two, which are authoritative in both.)
2. **Coordination-channel check (authoritative).** Read recent messages in #release-notes-coordination (C086QAY9UNL). If a breakdown for this RC was already posted — a message containing "release breakdown for changelog triage + updates" referencing this RC's "RC <DD Mon>" label or its ts — it is done. Skip, and (local) append the ts.
3. **Published/complete-changelog check (handled elsewhere).** Compute the RC's release date (Step 4.1) and query the Changelog archive for a page on that date (Step 4.3). If that page already exists **with real content** (drafted or Published — not an empty shell), the release has already been handled through another path; skip, report it, and (local) append the ts. *(This closes the gap where the changelog gets completed manually without a breakdown ever being posted.)*

If every candidate RC is already handled, exit quietly ("RC already handled — nothing to do") and stop. Otherwise take the NEWEST unhandled RC and continue.

## Step 3 — Build the release breakdown (parse → authors → teams → leads)

Parse every `#NNNN` from the RC code block plus any added in the thread; **count them and keep the total** — every PR must appear exactly once (coverage check before posting).

**Resolve each PR's author (environment-adaptive):**
- GitHub CLI authenticated (local): `gh pr view $n --repo cubbystorage/cubby --json number,author --jq '"\(.number)|\(.author.login)|\(.author.name // "")"'`.
- Not authenticated (cloud): the `cubbystorage/cubby` repo is attached. **The clone may be shallow — run `git fetch --unshallow` first** (the RC predates the shallow cutoff; without this every `git log --grep` returns empty). Then squash-merge subjects carry the PR number: `git log --grep="(#8163)" --format="%an|%ae|%s" -1`.
- Dependabot (`app/dependabot`) = bot, no human — Platform "bumps".

**Map each author to a team lead. Default: a PR goes under its author's team lead.** Overrides:
- **Evgeni Jechev** or **Hanna Matveyeva** → Onboarding / Import regardless of subject (no ⚠️). Does NOT apply to **Hannah Groves** (see name collisions).
- **Christo Dimitrov** (EM) → bucket HIS PRs by ticket prefix (`[CORE-…]`→Core FMS, `[REPORT-…]`→Reporting, `[COMMS-…]`→Communications, `[REVMAN-…]`→Revenue Management); do NOT flag his cross-team authorship.
- All **infra / DevX / deploy / terraform / dependency-bump / test / security-hardening** PRs → **Platform** (sub-bucketed `API/BQ` / `DevX / infra` / `TESTS` / `bumps`), even when authored by a product-team engineer.
- Ticket prefixes are the strongest team signal when the author map is unknown: CORE→Core FMS, COMMS→Communications, REVMAN/ECRI→Revenue Management, STORE→Storefront, ONB→Onboarding, REPORT→Reporting, AI/VOICE-AI/SMS AI/ML→AI, PLAT/DevX/Security→Platform.
- Otherwise, if a PR's subject clearly differs from the author's team, keep it under the author's team and mark **⚠️**; if an author can't be resolved/mapped, put it in a final "⚠️ Unresolved — needs an owner" section. Never guess, never drop a PR.

**Lead map** (re-confirm periodically):
- Core FMS → **Itso / Hristo Zahariev** `U06EH2E8P55`
- AI → **Declan** `U03AWGHR6DT`
- Revenue Management → **James Randall** `U0AAA4EBFC7` — own section (cc _David_ `U06MT433PB2`, _Hunter_ `U0ASA30R85S`)
- Communications → **mitko** `U06JXJQAMHQ`
- Storefront → **George G** `U0C1NP6UFPB`
- CDS → **Jan** `U05KD324MPX`
- Onboarding / Import → **James Baumeister** `U05A2R7BF3L` (cc _Hanna_ `U03QN39HWJ2`, _Evgeni Jechev_ `U052VS89PMF`)
- Corp → **Jason** `U0B1XJX7BU5` (n/a — no changelog owner)
- Reporting → **Vladimir** `U059FNS0HPV`
- Platform → lead Ivan Anev but do NOT @mention: header is just `` `Platform - n/a` ``

## Step 4 — Create (or reuse) the changelog page and draft the items

### 4.1 Release date
A **Monday** RC → that week's **Thursday** (+3d); a **Thursday** RC → the **following Monday** (+4d). Late-deploy fallback: a Mon/Tue RC → that week's Thursday; a Wed/Thu/Fri RC → the following Monday.

### 4.2–4.5 Shell page (create or reuse)
- **Name == Release Date**, formatted `Changelog: <Month> <D>, <YYYY>` with NO ordinal (e.g. `Changelog: July 27, 2026`).
- **Dedupe first** — query the "Changelog archive" data source (`31fdc465-1f0c-8011-adc5-000bb9e36953`) for a page whose Release Date start equals the computed date (or whose Name matches). If one exists, REUSE it (take its URL). *(Step 2.3 already short-circuits a page that has real content; a bare existing shell is reused.)*
- **Otherwise create it** under that data source (data_source_id `31fdc465-1f0c-8011-adc5-000bb9e36953`) with the default template (`31fdc465-1f0c-80a2-b319-efb2b5627715`). Fetch the schema first, then set: `Name` (title); `date:Release Date:start` = `YYYY-MM-DD`; `date:Release Date:is_datetime` = the NUMBER `0`; `Author` (person) = `["31ed872b-594c-8158-bfac-0002c8787e07"]` (Hristo); `Published` = `__NO__`; `In-app banner` set in 4.7. The "All Entries" view sorts by Release Date DESC, so a correctly-dated page lands on top; there is NO API way to reposition a row — if it isn't row 1, say so, don't try to drag it.
- **Capture the page URL** for the CTA and the DMs. If creation/lookup fails, still post the breakdown with `changelog to complete: _(page pending — create manually)_`, skip 4.6–4.7 and the DMs for the page link, and flag it. A Notion failure alone must NOT block the breakdown.

### 4.6 Draft the material changelog items (ALL teams) — inlined rules, no skill invocation
After the shell exists, write the customer-facing drafts yourself. Do NOT invoke `/release-changelog` (it is interactive and can publish). The rules below are the whole spec.

a. **Select only material, feature-like items.** Draft a blurb ONLY for items a facility manager would actually notice and care about: a genuinely new feature/capability, a notable enhancement to an existing one, or a bug fix with visible impact. **Exclude** (do not draft): refactors, infra, deploy/CI, tests, flag plumbing, performance/batching, internal or External-API-only fields, dependency bumps, security hardening with no UX change, and early-access/flagged-off work. **When unsure, exclude** — a missing draft is cheap; a wrong customer-facing line is not. Use **recent Core FMS changelog entries** (fetch the last few published archive pages) as the benchmark for what "worth describing" looks like and the level of detail.

b. **Classify each selected item.** New ✨ = new feature/capability; Improvements 🔨 = enhancement to something that exists; Fixes 🦂 = a visible bug fix.

c. **Write it operator-facing** (audience: facility managers): "You can now…", "Cubby now…", "Facility managers can now…". Fixes read `Fixed an issue where <area> …`. New/Improvements get a bold title + 1–2 sentences. No developer jargon (cache, refetch, endpoint, migration, feature flag) — describe the value, not the implementation.

d. **Prefix every drafted line with `DRAFT - TBC by <PM name>: `** where `<PM name>` is the owning team's lead (Core FMS→Itso, AI→Declan, Revenue Management→James Randall, Communications→mitko, Storefront→George G, CDS→Jan, Onboarding/Import→James Baumeister, Reporting→Vladimir). This tag is how each PM finds their items on a page organised by New/Improvements/Fixes. Keep it human-readable, e.g. `DRAFT - TBC by Itso: **Find rentals missing contact details.** The Rentals page …`.

e. **Source the copy, best available first.** Local (`gh` authed): prefer the `Changelog summary` line in the PR's "Product Review / QA Test Results" comment if present (`gh pr view <n> --repo cubbystorage/cubby --json comments,title,body`); else the PR title + description. Cloud (`gh` not authed): the squash-merge commit subject from Step 3 is all you have — write from it, and if the subject alone doesn't say what an operator would notice, **exclude** the item rather than invent a benefit.

f. **Merge, never overwrite.** Fetch the page's current content FIRST, then INSERT/APPEND the drafted lines under the matching existing heading (New ✨ / Improvements 🔨 / Fixes 🦂). Never delete or rewrite another team's entries, the template's placeholder stubs, or anything already on the page.

g. **Scope and failure.** Draft items for every team (each tagged with its PM). Note any ⚠️ (uncertain-owner) item in the run report, not in the customer copy. This and 4.7 are the ONLY Notion page content this routine writes, and ONLY on the page it created/reused this run — never edit any other existing Notion page, never set `Published`. If drafting fails, keep the shell, report it, and carry on — a drafting failure must NOT block the Slack post.

### 4.7 Draft the in-app banner
Set the archive row's **`In-app banner`** property to a one-line draft summarising the 2–4 most notable items across teams, prefixed **`DRAFT - TBC: `** (e.g. `DRAFT - TBC: Find rentals missing contact details, send messages to opted-out tenants, and more`). Style it like recent published banners (short, benefit-led). Leave `Published` false. If banner-drafting fails, report it and carry on.

## Step 5 — Format the two-part threaded post

Standard markdown (`**bold**`, `_italic_`, `` `code` ``), Slack-native `<url|label>` links and `<@Uxxx>` / `<!subteam^Sxxx>` mentions verbatim.

**Part 1 — parent** (short):
```
**RC <DD Mon>** — deployed on `staging` · <RC-announcement-permalink|RC announcement>

**<!subteam^S076BFE3Q4X>** only - **release breakdown for changelog triage + updates**

changelog to complete: <CHANGELOG-PAGE-URL>
```
`<!subteam^S076BFE3Q4X>` is the "@pm" content-writers subteam. Wrap the Step-4 page URL in angle brackets; if no page, use the 4.5 fallback.

**Part 2 — breakdown body** (thread reply). One section per lead:
```
<@lead> — `Team`

<PR title> (#<number>) — _<author full name>_
...

<@nextlead> — `Team`
...
```
Rules: blank line under each lead header; **no `•` bullets** on main items (plain lines); blank line between sections; `` `Team` `` in backticks; each author italic `_Name_`; cc's in parens on the header. Only section leads and the `<!subteam>` header are real @mentions — cc'd people and all PR authors are plain italic text (never ping them); do NOT @mention the Platform lead. Corp and Platform are "n/a"; Platform header is `` `Platform - n/a` `` sub-bucketed:
```
`Platform - n/a`

_`API/BQ`_
◦ <PR title> (#<number>) — _<author>_
_`DevX / infra`_
◦ ...
_`bumps`_
◦ ...
```
Omit any empty section/sub-bucket.

**Slack-render gotchas:** balance backticks in every PR title before emitting (strip a leading ```` ``` ```` code-fence; an odd backtick count turns the rest of the body into one code span); wrap any `name@version` token in backticks; the read-back tool collapses blank lines (don't trust it for spacing).

**Length:** Slack caps one message at 5000 chars. If the body exceeds ~4500, split it at section boundaries into multiple **thread replies** under the same parent (keeps the channel to one line). Keep whole team sections together.

**Coverage check before posting:** every PR appears exactly once; the item count equals Step 3's total.

## Step 6 — Save, re-check, then do the four outward actions

1. **Save** the breakdown to `~/.claude/release-watcher/<RC label>/breakdown.md` (Slack-ready: `=== PARENT MESSAGE ===` + `=== THREAD REPLY ===` blocks, real CTA URL), BEFORE posting, so a failure still leaves the work on disk. (Skip if no writable home.)
2. **Re-run the Step-2 gate immediately before posting — mandatory.** Time passes between Step 2 and here. Read #release-notes-coordination once more; if a breakdown for this RC appeared since, do NOT post/DM: record the marker (local) and report "RC already handled — raced; nothing posted." The saved breakdown.md stays as the artifact.
3. **Post the breakdown** to #release-notes-coordination (C086QAY9UNL) via `slack_send_message`, as a real thread: send Part 1 standalone (capture its `ts`); send each Part-2 chunk with `thread_ts` = that ts, `reply_broadcast` off. Read the thread back once and eyeball the render (don't treat collapsed blank lines as a bug). If visibly broken, say so with the permalink; do NOT re-post.
4. **DM each PM with drafted items.** For each team lead who has ≥1 drafted changelog item (4.6), `slack_send_message` with `channel_id` = that lead's user_id (a DM). Keep it short and point them at their drafts:
```
Changelog drafts for **RC <DD Mon>** are ready for your review — look for lines tagged `DRAFT - TBC by <their name>:`.
• Changelog page: <CHANGELOG-PAGE-URL>
• Breakdown thread: <coordination-thread-permalink>
Please finalise your items (and the in-app banner if it touches your area) before release day. These are drafts — nothing is published yet.
```
DM only leads with drafted items (skip Platform/Corp "n/a" and any team with no material items). Never `reply_broadcast`, never DM anyone else.
5. **Marker (local):** append the RC's ts to `~/.claude/release-watcher/last-processed-rc.txt` (deduped). Append even if a step failed or was skipped at 6.2 — but say clearly which happened.
6. **First line of your final message** = RC label + nature, e.g. "**RC 06 Jul** — breakdown posted (threaded), N items drafted, M PMs DM'd". Then report: parent permalink; changelog page URL; items drafted per team/bucket (or why skipped/excluded); banner draft text; which PMs were DM'd; coverage count (N/N placed); any ⚠️ or judgment calls.

## Hard constraints
- Post ONLY the two-part breakdown in #release-notes-coordination (C086QAY9UNL). DM ONLY team leads who have drafted items. Never post in #release, never reply in the RC thread, never `reply_broadcast`, never DM anyone outside the lead list.
- Notion: create/reuse the ONE shell changelog page, draft **material** items (each `DRAFT - TBC by <PM>:`) and the **banner** (`DRAFT - TBC:`), inserting/appending without overwriting. Leave `Published` false. Never edit or publish any OTHER existing Notion page. Nothing to Linear or GitHub.
- A Notion failure alone must NOT block the breakdown — post with the fallback CTA and flag it.
- If anything makes the breakdown unreliable (RC message unreadable, author resolution unavailable, >¼ of authors unresolved), post NOTHING and report the failure instead.

## Name collisions — keep distinct
- **Christo Dimitrov** (engineer, `christo@`, GitHub `cerebraldeath`) ≠ **Hristo / Itso Zahariev** (PM, `hristo.zahariev@`).
- GitHub `dbstarr` = **David Starr** (Revenue Management) ≠ **Declan Starrett** (AI).
- GitHub `hsgroves` = **Hannah Groves** (Revenue Management) ≠ **Hanna Matveyeva** (Onboarding) — the Evgeni/Hanna→Onboarding override applies only to Hanna Matveyeva.

## Keeping the copies in sync (canonical → both routines)
Canonical is this file in `hzahariev/my-skills`. After editing here and merging to `main`:
1. **Local fallback** — copy this body into `~/.claude/scheduled-tasks/release-rc-watcher/SKILL.md` (keep its frontmatter: `name`, fallback `description`, `model: claude-opus-4-8`; schedule hourly, offset). Mirror to `~/.claude/skills/release-rc-watcher/SKILL.md`.
2. **Cloud primary** — republish this body as the routine prompt via `RemoteTrigger update {trigger_id: trig_01LRm3sQZ2Mtq3pdHQAhEkdt, body:{...}}` (full `job_config`; cron **hourly**; keep `mcp_connections` = Slack+Notion+Linear, `sources` = cubby repo, `model: claude-opus-4-8`).
Never hand-edit either copy independently.

## Reference
- #release `C03MVKKSB8B`; #release-notes-coordination `C086QAY9UNL`; @pm subteam `S076BFE3Q4X`; repo `cubbystorage/cubby`.
- Notion Changelog archive: data source `31fdc465-1f0c-8011-adc5-000bb9e36953`, template `31fdc465-1f0c-80a2-b319-efb2b5627715`, Hristo (Author) `31ed872b-594c-8158-bfac-0002c8787e07`.
