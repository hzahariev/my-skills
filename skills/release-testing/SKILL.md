---
name: release-testing
description: QA test release candidate PRs on staging. Tests each PR against acceptance criteria from PR descriptions and Linear tickets, posts the full structured results as one consolidated comment on the associated Linear ticket (the canonical QA record), then a single closing pointer line on the GitHub PR. Use when the user says "release testing", "test the release candidate", "qa the rc", "qa these PRs", or invokes /release-testing.
---

# Release Testing

Test release candidate PRs on staging against acceptance criteria. Triage what is verifiable on staging up front, test the verifiable ones, hand the rest to the user in a drivable checklist, and keep one editable result comment **per Linear ticket** (the canonical QA record) plus a running `QA-RESULTS.md` artifact. The GitHub PR gets only a single one-line pointer to that Linear comment, posted once QA is fully done.

**Supporting files** — read each when you reach the step that needs it (don't load up front):
- **`reference.md`** — staging URL/login, impersonation, what-works-well, and known staging limitations. Consult during triage (Step 2b) and the human-verify handoff (Step 5).
- **`templates.md`** — the verbatim Linear QA-comment body template (Step 3e) and the `QA-RESULTS.md` skeleton (Step 6). Open it when you first post results.

## Arguments

Parse arguments after the skill name:

- **PR list**: Comma-separated PR numbers (e.g., `7502, 7503, 7504`)
- **Milestone or label**: A GitHub milestone name to auto-discover PRs
- If no arguments, ask: "Which PRs are in this RC?"

---

## Token discipline (keeps the run cheap — apply on every browser interaction)

Browser accessibility snapshots are the single biggest cost driver (a full-page snapshot is 5k–15k tokens; dozens dominate the session).

- **Never dump the full accessibility tree.** Default to a **scoped** snapshot (`target` ref + small `depth`, e.g. 6–14), or `browser_evaluate` for targeted reads ("does this listbox contain option X?", "is this text present?").
- **Read state from the resolved URL + filter chips**, not row dumps — Cubby grids encode filters/sort/pagination in the URL (`?filters[...]=...&sorting[...]=...`), so the URL after a click often proves the criterion for free.
- **Screenshots are evidence, not a reading tool** — take one only to attach PASS/FAIL proof; decide results via snapshot/evaluate.
- **Re-use refs**; only re-snapshot after a navigation/DOM change, and keep it scoped.
- Prefer `gh ... --jq` projections over whole-PR payloads.

If you're about to take a third full-page snapshot on one screen, switch to a scoped snapshot or `browser_evaluate`.

---

## Step 1 — Gather context (parallel)

Run all of the following in parallel — they are independent.

### 1a. Fetch PR details from GitHub

For each PR number, run:

```bash
gh pr view <number> --repo cubbystorage/cubby --json title,body,labels,changedFiles --jq '{title, changedFiles, labels: [.labels[].name], body}'
```

Extract: **Title/description** (acceptance criteria), **Linear refs** (`CORE-123`, `ENG-456`,
`ONB-44`, `REVMAN-5`), **changed-files count** (risk signal), **labels**. Also capture, for the
plan/results tables (Step 2a): the **change type**, a one-line **problem** (what's broken/missing),
and a one-line **solution** (what changed) — the PR body usually states both; the ticket fills gaps.

### 1b. Fetch Linear ticket context

For each referenced ticket, use the Linear MCP tool (`get_issue`). Extract **title/description**
(acceptance criteria), **priority**, **status**. PRs with thin descriptions usually have the real
criteria in the ticket — fetch it.

---

## Step 2 — Classify, triage, and plan

### 2a. Categorize each PR

For each PR determine:

- **Type** — one of:
  - `Bug` — fixes a reported/observed defect (has a `Bug` label or a customer report in the ticket).
  - `Fix` — corrects unintended behavior in existing functionality (title `[Fix]` / `Fix:`), no formal bug report. *When Bug vs Fix is ambiguous: `Bug` if there's a `Bug` label or customer report, else `Fix`.*
  - `Enhancement` — improves or extends an existing feature.
  - `Big feature` — substantial net-new capability (new surface / permission / data model — the "complex" shape).
- **Problem** — one line: what's broken or missing today (from the PR body / ticket).
- **Solution** — one line: what changed to address it (from the PR body / ticket).
- **Area** — title/files/ticket.
- **Risk** — Low (1–2 files UI-only) / Medium (3–20 files API+UI) / High (20+ files, permissions, data).

### 2b. Testability triage (do this before any browser action)

Put **every** PR into exactly one bucket. This decides who tests it and prevents wasting a run
attempting things staging or the permission classifier won't allow.

| Bucket | Meaning | Who/how |
|---|---|---|
| `auto` | Read-only UI verification — grid filters, sort, column/badge visibility, default-state, variable pickers | Agent tests in Step 3 |
| `auto-with-discard` | Requires entering an editor to *inspect* options, but changes can be abandoned without saving (e.g. workflow trigger/condition picker) | Agent tests in Step 3, then **discard** (see safety note) |
| `human-verify` | Entry point is a pre-submit dialog/wizard or any mutating action. The auto-mode permission classifier blocks these even when you only intend to view and not Save (e.g. "Create rental" wizard, "Add delinquency exemption" dialog, settling/refunding an auction) | Hand to user — they drive, agent records |
| `needs-data` | Verifiable in principle but the precondition isn't present (e.g. a settled+paid auction, a delinquent tenant, colliding access codes) | Ask user to provide/point to data, else → human-verify |
| `not-on-staging` | Cannot be exercised on staging at all (live workflow runs, reservation→workflow side effects, external integration toggles like OpenTech) | Defer to engineering (backend/integration tests) |

Heuristics:
- "Open dialog X but don't save" is **still `human-verify`** — the classifier treats the entry
  click as a mutation. Do not attempt it; route it to the user.
- Backend-only / lease-scoped rendering (template variables, computed balances) is usually
  **not visible in the in-app preview** (mock data, no bound lease) — see `reference.md` → *Known staging limitations*.

### 2c. Surface the plan and ask up front

Present the categorization + triage table (columns: `PR | Type | Problem | Solution | Area | Risk | Bucket`)
and ask, in **one** message, before testing:

1. **Test data / preconditions** — for each `needs-data` PR, can the user point to or set up the
   data (with facility + unit/tenant/auction)? If not, it becomes `human-verify` or `not-on-staging`.
2. **Restricted user** — for any permission-gated PR, which user to impersonate, at which facility.
3. **Credentials** — site.admin (or other) login for staging (never stored in this file).

Wait for answers. Then test order: `auto` and `auto-with-discard` first (cheap, high confidence),
and immediately queue `human-verify` / `needs-data` / `not-on-staging` into the human checklist
(Step 5) — do not attempt them in Step 3.

---

## Step 3 — Test the `auto` / `auto-with-discard` PRs on staging

Staging URL, login, and impersonation details are in `reference.md`. Log in as site.admin (or the
user-specified user); get credentials from the user or the plan document — never hardcode them.

### For each PR, run this loop:

#### 3a. Derive acceptance criteria

From the PR description + Linear ticket, extract concrete criteria as a checklist. Use explicit test
steps if present; otherwise derive from "what changed".

#### 3b. Execute tests (apply Token discipline)

Navigate to the relevant page and verify each criterion:
- Prove filter/sort/pagination/default-state via the **resolved URL + filter chips**.
- Use **scoped** snapshots (`target` + small `depth`) or `browser_evaluate` to read just the grid/
  dialog/listbox you need. Verify both states for visibility tests, both directions for sort tests.
- **`auto-with-discard` safety:** when you enter an editor to inspect (e.g. workflow trigger picker),
  make the change in-memory only, then **leave without saving** — confirm the "unsaved changes" guard
  ("Leave page" / discard) so nothing persists. Note this in the result.
- Take a screenshot only as PASS/FAIL evidence.
- Permissions: test as admin first; batch restricted-user checks in Step 4.

#### 3c. Record result

`PASS` (all criteria met) / `FAIL` (one+ unmet — capture repro) / `PARTIAL` (some verified, rest need
data/manual — say which) / `PENDING-HUMAN` (queued for the user) / `NOT-ON-STAGING` (deferred to eng).

#### 3d. Draft changelog summary

One line, reused by `release-changelog`. **Keep this label and format exactly** so that skill can
extract it.
- **Feature/Improvement:** `**Bold title.** 1–2 sentences from the operator's perspective.`
- **Fix:** `Fixed an issue where **bold area** did something wrong.`
- **Internal:** `Brief technical description (#PR_NUMBER)`

Operator-facing language ("you can now…", "Cubby now…"). No dev jargon (cache, refetch, prefetch…).

#### 3e. Post / update results — ONE consolidated comment on the Linear ticket, edited in place

The **full QA results live on the associated Linear ticket** as a single comment, **edited in
place** via its comment `id` as the run progresses (`auto` result now → final result after human
verify / bug-fix retests). This Linear comment is the **canonical QA record**. Do **not** post the
full results to the GitHub PR — it gets only the one-line pointer in Step 7 — and do not stack
duplicate comments. *(If a PR has no Linear ticket, fall back to a single GitHub PR comment for that one.)*

The body **must** keep the exact header `### Product Review / QA Test Results` and the
`**Changelog summary**` line — `release-changelog` greps for both (it reads them from this Linear comment).

**Use the body template in `templates.md`** (one consolidated comment; one results-table row per acceptance check).

**Create (first time):** call the Linear `save_comment` tool with `issueId` + `body`; capture the
returned comment **`id`**.
**Update in place:** call `save_comment` again with that `id` — edit the same comment as results land
and bugs flip to fixed. Verify the returned body each time (`save_comment` can silently no-op if the
issue is open in the Linear app editor — the editor-lock gotcha).

The web **anchor** is built from the **first segment** of the comment UUID (id `47333a74-2e40-…` →
`…/issue/<KEY>/…#comment-47333a74`) — capture it for the PR pointer in Step 7.

These comments are posted on behalf of the user; the attribution line marks them as skill-generated.

#### 3f. Update the artifact + print progress

Update `QA-RESULTS.md` (Step 6) and print a one-liner:

```
✓ #7485 — Pin "Other" to bottom — PASS (1/10)
```

#### 3g. If a test FAILS mid-run

Capture **environment** (facility, URL/auction/tenant id), a **numbered repro**, and an **evidence
link** (screenshot or video). Record FAIL in the comment + artifact, then **offer to file a dedicated
Linear bug** (team Core FMS, appropriate `Theme:` label) separate from the feature ticket — don't
file without the user's go-ahead.

---

## Step 4 — Restricted-user testing batch

If any PRs need restricted-user testing (impersonation steps in `reference.md`):

1. Admin tools (top-right) → Managers → find user → click row → **Impersonate**.
2. Test all restricted-user PRs in sequence (avoids switching back and forth).
3. Click **Exit** in the yellow banner to end impersonation.
4. Post/update results per 3e.

---

## Step 5 — Human-verify handoff (the queued buckets)

For every `human-verify` / `needs-data` / `not-on-staging` PR, produce a checklist the user can drive
**one at a time**. For each: ticket id, type, any precondition/data needed, numbered steps, and
explicit **Pass =** / **Fail =** lines. Offer to go through them interactively — present one, wait for
the user's PASS/FAIL (+ any evidence), then edit that PR's comment (3e) and the artifact, then present
the next.

Pre-fill the known repro for common cases (template preview via the preview endpoint, settled-auction
payment checks, workflow-run behavior) from `reference.md` → *Known staging limitations*.

---

## Step 6 — `QA-RESULTS.md` artifact (running source of truth)

Maintain a gitignored `QA-RESULTS.md` in the working directory; update it after each result so the run
survives context loss and is easy to share. **Skeleton + section formats are in `templates.md`.** It has
three sections:

1. **Results table** — `# | PR | Type | Problem | Solution | Area | Result | Notes`. `Type` = Bug / Fix / Enhancement / Big feature; `Problem` and `Solution` are the one-liners from Step 2a.
2. **Human-verify checklist** — the Step 5 items with steps + Pass/Fail, check off as completed.
3. **Slack block** — a copy-paste message, one line per PR (`:white_check_mark:` PASS · `:x:` FAIL · `:loading:` PARTIAL/PENDING-HUMAN/NOT-ON-STAGING, with a short reason; format `<emoji> <PR title> (#<number>)`).

Ensure `QA-RESULTS.md` is gitignored (add it to `.gitignore` if not already) — it is scratch output, not committed.

---

## Step 7 — Final summary + PR pointer

Once the **whole QA is complete**:

1. **Post the PR pointer** — for each PR, add **one single-line comment** on the GitHub PR: the
   verdict + a link to its Linear results comment (use the first-segment anchor from 3e). Nothing
   else goes on the PR — keep its comment section clean.
   ```bash
   gh pr comment <number> --repo cubbystorage/cubby --body "✅ QA verified & passed — full results: <issueUrl>#comment-<id>"
   ```
   Use ❌ / ⚠️ + a one-line reason for FAIL / PARTIAL.

2. Print the results table + the Slack block, then:
   ```
   **Summary:** X passed, Y failed, Z partial, W pending-human, V not-on-staging
   **Comments posted:** Y Linear tickets (full results) + X PR pointer lines
   ```

List any FAILs with repro for dev follow-up. Remind: "Run `/release-changelog` with these PRs to
assemble the Notion changelog — the changelog summaries from each Linear QA comment will be reused."
