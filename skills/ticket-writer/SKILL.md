---
name: ticket-writer
description: Write well-defined Linear engineering issues in a structured format. Only invoke when the user explicitly types /ticket-writer. Supports three modes — create (new issue), spec (structure an existing unstructured ticket), and refine (restructure existing spec by ID). Always drafts first for review, then pushes to Linear on confirmation.
---

# ticket-writer

Write terse Linear engineering specs. Every line earns its place — if an engineer would skip it, cut it.

> **Golden rule:** Keep terse phrasing for scope items that need to be delivered by dev. One observable fact per line. No explanations, no rationale, no filler. The ticket is a checklist of what to build — not a narrative of why.

---

## Modes

Detect the mode from the user's input:

- **Create** — user describes a feature, pastes raw context, or says "write a ticket for X"
- **Spec** — ticket already exists (e.g., from triage or a stub) but has no structured spec yet. Treat like Create for drafting, but use the existing issue ID for the push (like Refine). Post original description as PM context comment before overwriting.
- **Refine** — user says "refine CORE-49", "rewrite CORE-XXX", or references an existing issue ID that already has a structured spec

---

## Step 1 — Interview

### Create mode

Ask only what the user hasn't already provided. Skip any step their input already covers:

1. **What's broken or missing today?** — the problem
2. **What should happen instead?** — the desired outcome
3. **Is there a design?** — Figma link, or "not yet" / "not needed"
4. **Any dependencies or blockers?** — related Linear issues, or skip
5. **Any technical constraints the engineer should know?** — or skip

Do not ask about customer context. If the user provides it unprompted, store it for the post-push comment — it never enters the ticket body.

When the user pastes raw input (Slack thread, meeting notes, customer email), extract problem/outcome/quotes and structure them. Do not ask the user to re-explain what they already provided.

### Refine mode

1. Fetch the existing issue via `get_issue` (with `includeRelations: true`)
2. Fetch issue comments via `list_comments` — scan for design links (Figma URLs), resolved decisions, and context that should be folded into the spec
3. Note existing attachments (meeting recordings, docs, Intercom links) — these must be preserved or referenced in the refined ticket
4. If the existing ticket has open questions, ask the user which are now resolved — fold answers into scope and suggest moving resolved questions to a comment
5. Present related issues from step 1 and ask: "Are any of these now duplicates, dependencies, or no longer relevant?"
6. Present a short summary of the current structure and what's missing or could improve relative to the target format
7. Ask the user what to change, add, or restructure — or proceed with a full reformat if they say "rewrite it"
8. If an attached PR/branch implements an approach this respec discards, capture the discard rationale — it goes in the PM context comment on push — and remind the user to close the stale PR

**Multi-message input:** If the user needs to send screenshots, notes, or context across multiple messages (e.g., image limits), say: "Send everything you have. If you hit the image limit, keep going in follow-ups and say 'done' when finished." Do not start drafting until the user confirms all input is provided.

**Iterative review:** When the user reviews an already-pushed ticket and sends comments, collect them all before rewriting — one consolidated push beats editing after each comment (keeps the spec coherent, avoids churn and editor-lock bounces). If the user says "wait for all my comments," honor it explicitly before touching the ticket.

### Presenting decisions (all modes)

When the interview or research surfaces a product decision, present 2–4 concrete options with consequences and a recommendation — never an open-ended question. Frame each option around a case the user can rule on: "A lease has rent paid through but a $25 fee due now — `Due today` or `Good`?" beats "How should standing work?"

### Optional research (all modes — ask first)

Both checks below cost real time and tokens. Offer them with a recommendation and let the user decide — never run them unprompted. For simple tickets (copy tweaks, single-control changes), skip the offer entirely.

- **Codebase grounding** — offer when the ticket changes behavior/derivation logic or touches multiple surfaces: "Want me to verify this against the codebase (exact field/flag names, every surface consuming this behavior) — or are you confident in the details?" When run, the spec's surface list comes from the code, not from memory. Reference case: CORE-711's original spec named 3 affected surfaces; the codebase had 6+ consumers of the standing logic, plus an adjacent collections-queue bug.
- **Related in-flight work** — when a related issue has an attached PR/branch, offer to read it for mechanisms this spec should reuse or must not contradict. Two tickets shipping divergent definitions of the same concept is a spec failure. Reference case: CORE-711 collapsed from "introduce a new due-now concept" to "reuse CORE-710's existing method" after reading its open PR.

### Simplest-scope challenge (all modes)

Before drafting any ticket that introduces a new dialog, surface, or control, ask the user:

> "Can the main use cases be solved by exposing or extending **existing** actions/controls to more statuses, users, or contexts — instead of building something new?"

Reference case: CORE-223 started as a custom "Edit lien status" override dialog (status picker, warnings matrix, new event type, confirmation flow). After an ENG sync it collapsed into exposing the existing `Complete` and `Undo settle` actions on one more status each — same pain solved, fraction of the cost. The new-surface version was fully spec'd twice before being discarded.

Also anchor the scope to concrete recurring pain: identify the actual support requests / DB writes the ticket should eliminate (e.g., "resolves use cases like CORE-698") and verify the smallest scope covers them. Anything beyond that is a candidate for the appendix or a follow-up ticket.

---

## Step 2 — Judge complexity

**It's complex when 2+ of these are true:**
- Multiple surface areas are changing (e.g., Shop + Payments + Permissions)
- A new permission is being introduced
- Conditional logic with different behavior branches (when X → Y, when Z → W)
- A new data model, payment category, or transaction type
- A cross-cutting fix alongside the main feature
- Before/after behavior change pattern

**It's standard when:**
- Single surface, single concern
- Outcomes are a flat list — no need to group by concern
- An engineer can read it top to bottom without skipping irrelevant sections

**Complex-ticket gate:** If the ticket lands in complex format AND introduces a new dialog, surface, or data model, recommend the user validates the approach with ENG **before** finishing the deep spec. A 30-minute dev sync is cheaper than two rounds of spec polish on an approach that gets discarded (see CORE-223). Surface this as a one-line suggestion, not a blocker.

Reference examples:
- **Complex:** CORE-49 (Shop: Add Manager Special sale action) — 4 concern groups, new permission, new payment category, conditional logic, cross-cutting Walk-in fix
- **Complex, scope-optimized:** CORE-223 (Auctions: Cancel lien process and complete unpaid auctions) — started as a new override dialog, simplified to extending existing actions after ENG sync
- **Standard (gold standard):** CORE-164 (Trigger: Add Move-out trigger) — terse flat list, one fact per line, no explanatory prose
- **Standard:** CORE-163 (Workflows: Add move-in trigger and trigger sections), CORE-150 (Runs: Adjust runs screen badge styling), CORE-155 (Add preview for message templates), CORE-232 (Runs: Surface entity context in runs grid)
- **Workflow node / action (template):** CORE-165 (Node: add create task action) — the model for node tickets: capability-level bullets describing the action's observable behavior (fields it exposes, what it creates, when it skips), never the engine's run-loop mechanics or internal symbols

---

## Step 3 — Draft the issue

### Title

`Surface: Short imperative description`

Examples:
- `Rentals: Add Sparefoot source in Rental creation options`
- `Lease config: Make advertisement posting optional for lien/auction process`
- `Workflows: Add move-in trigger and trigger sections`
- `Shop: Add Manager Special sale action`

### Description — Standard format

Use for single-concern, well-scoped issues.

Each outcome is one line. Sub-bullets only for conditionals (`when X → Y`) or default values — never for explanation. If a design reference exists, the ticket complements it — never replicates it. Only specify: field names, validation, conditional logic, defaults, constraints, and behavior not visible in the design.

```markdown
[1-2 sentence intro — what this issue delivers and minimal context.]

### Design reference

[Figma link/embed/screenshot]

### Dependencies

> **Blocked by:** CORE-XXX — reason
> **Blocks:** CORE-XXX — reason

### What done looks like

- [Observable outcome — one terse line]
- [Another outcome — reference exact field names, permission names, config paths]
- [Another outcome]

### Open questions to resolve w ENG during dev

- [Known trap or ambiguity — one line]
```

*Open questions are optional — include when the implementation has known traps or decisions ENG should make during dev. Omit for straightforward issues like CORE-155.*

*Quality gate for open questions: each question must describe a real ambiguity the PM cannot resolve — not a hypothetical the engineer will answer by reading the code. Before including an open question, ask: "Would the PM know the answer to this?" If yes, resolve it in the spec. "Would this question survive a 30-second conversation with an engineer?" If not, cut it.*

*Quality gate for done items: each bullet must be independently observable. If it follows logically from another rule already in the spec, cut it — derived consequences are explanation, not scope. Implementation warnings ("without requiring X", "must not go stale") move to open questions. In a multi-ticket feature this applies across tickets too: if a fact is fully stated in another ticket, reference it ("events consolidated in CORE-840") rather than restating it — duplicated facts drift.*

### Description — Complex format

Use for multi-concern issues with frontend + backend + permissions + migrations. Only include concern groups that are relevant — omit any group with nothing in it.

Each group follows the same terse style as the standard format. One line per outcome. Sub-bullets only for conditionals, defaults, or before/after changes. No explanatory prose within outcomes. Inline clarifications use parenthetical — `(only when X)` — not a separate `*Note:*` bullet.

If a design reference exists, the ticket complements it — never replicates it. Only specify: field names, validation, conditional logic, defaults, constraints, and behavior not visible in the design.

```markdown
[1-2 sentence intro — what this issue delivers and minimal context.]

### Design reference

[Figma link/embed/screenshot]

### Dependencies

> **Blocked by:** CORE-XXX — reason
> **Blocks:** CORE-XXX — reason

### Context

[2-3 sentences. Current state → gap → what changes. No more.]

---

### What done looks like

**Surface changes**
- `Field name` (required/optional, constraint if any)
  - **When [condition]** -> [behavior]
  - Only visible when `[feature access flag]` is enabled (`[path to feature access config]`) — use when a new config depends on a feature access flag
- `Another field` (required)

**Behavior & logic**
- [Terse outcome statement]
  - **When [condition]** -> [behavior]
  - **Default:** [value]
- Update `[existing component/dialog]`:
  - **Before:** "[current text/behavior]"
  - **After:** "[new text/behavior]"

**Permissions**
- `Permission name` — not assigned by default, gates [what it controls]; specify which default role(s) it applies to

**Release & data**
- [Default state for new config — on/off]
- [Release actions — e.g., "enable for [customer] on release"]
- [Data implications — e.g., "existing leases unaffected, new config applies going forward"]
- Do NOT specify database field names, column types, or migration scripts — those are ENG implementation decisions

### Open questions to resolve w ENG during dev

- [Known trap or ambiguity — one line]
```

### When to add a lifecycle diagram

A rendered flow diagram replaces paragraphs of transition prose — one image can carry what would otherwise be 10+ bullets of "when X → Y" descriptions. Proactively offer to create one when **any** of these triggers apply:

- The feature touches a **status/state machine** — entities moving between statuses (auction lifecycle, lease lifecycle, payment states, workflow runs)
- The spec would otherwise need **3+ "moves to / reverts to / transitions to" bullets** describing flow
- Actions are **conditional on current state** (different buttons/menus per status)
- There are **branching outcomes** (sold/unsold, approved/rejected, paid/failed)
- A **new transition is being added** to an existing flow — the diagram shows exactly where it slots in, highlighted in red

When triggered, say: "This spec describes a state flow — want me to create a lifecycle diagram for it? It'll replace most of the transition descriptions."

Production steps: build as SVG in HTML, render to PNG via Puppeteer, upload via `prepare_attachment_upload` + PUT + `create_attachment_from_upload`, embed with `![title](assetUrl)` in a `+++` collapsible section. Iterate with the user in the browser (`open file.html`) before uploading. Keep the source HTML file so future scope changes can update the diagram.

### What goes to a comment, not the ticket body

Customer context, scope boundaries, and discovery resources are posted as a separate comment after the issue is pushed (see Step 5). They never appear in the ticket body. The spec is for engineers — keep it to what they build.

### Optional sections rule

Design reference, Dependencies, Context, and Open questions are only included when they have content. Omit any section that would be empty — never show placeholder text.

### Before -> after pattern

When the issue modifies existing behavior, make the change explicit under the relevant "what done looks like" item.

For short values, use a table:

| | Before | After |
|---|---|---|
| Revenue category | Merchandise | Manager Special |
| Deposit handling | Bundled in sale | Separate transaction |

For long text (sentences, dialog copy, multi-line content), use bold bullet pairs instead — Linear's markdown rendering truncates wide table cells:

- **Before:** "Confirming the refund will impact the account balance and additional late fees could apply..."
- **After:** "Confirming the refund will reverse the original transaction."

Only use this when there is a real "before" state. Never use for net-new features where no prior behavior exists.

---

## Step 4 — Present draft for review

Present the draft as a markdown code block the user can review. For refine mode, show the updated version alongside a summary of what changed from the original.

If the issue has 4+ concern groups or 15+ "done" items, suggest decomposing into sub-issues. This is a nudge, not an automatic action — the user decides.

If the refined scope materially changes effort relative to the issue's current estimate, flag the mismatch in one line — never set the estimate yourself.

Do not create or update anything in Linear until the user explicitly approves.

---

## Step 5 — Push to Linear

After the user approves:

### Create mode

Call `save_issue` with:
- `title`: the drafted title
- `description`: the drafted description (everything below the title)
- `team`: `Core FMS`
- `blockedBy`: issue IDs if dependencies exist
- `blocks`: issue IDs if this blocks other work

Do NOT set priority, labels, project, or cycle — the user manages those manually.

### Spec mode

Before updating the description, post a `### PM context` comment containing the original ticket description under an **Original ticket description** heading. This preserves the raw context (Slack quotes, customer details, reproduction steps) that the spec intentionally strips out. Then call `save_issue` with:
- `id`: the existing issue identifier
- `title`: the drafted title
- `description`: the drafted description
- `team`: `Core FMS`

Do NOT set priority, labels, project, or cycle — the user manages those manually.

### Refine mode

Before updating the description, post a `### PM context` comment containing the original ticket description under an **Original ticket description** heading — unless the original description already follows the structured spec format (in which case the comment is unnecessary).

Call `save_issue` with:
- `id`: the existing issue identifier (e.g., `CORE-49`)
- `title`: the updated title
- `description`: the updated description

Preserve all existing metadata (assignee, priority, labels, project). Only update title and description. Never remove embedded images/screenshots from the description unless the user explicitly asks — even when a scope change appears to make them obsolete; flag instead and let the user decide.

> **Verify the write landed.** After every `save_issue`, confirm the returned `description` / `updatedAt` reflects your change. If it echoes the OLD content and `updatedAt` didn't advance, the issue is open in the Linear app editor and the write silently no-op'd — ask the user to close it, then re-push. Re-fetch with `get_issue` before each edit, since users often hand-edit between turns.

### Post-push (all modes)

1. If scope boundaries, customer quotes, or discovery resources were collected, post them as a comment via `save_comment` with a `### PM context` header. Group: scope boundaries first, then discarded-approach rationale (if any), then customer context, then discovery links.
2. Offer: "Want me to search for duplicate tickets and mark them as duplicates of this issue?" Search by keywords from the title and description, review matches, and present candidates for the user to confirm before marking.

---

## Format rules

- **Brevity first** — default to the shortest phrasing that is still precise. "`X` is available on `Y`" not "A new `X` option has been added and is now available on `Y`". Strip filler words: "simply", "just", "also", "additionally", "as well". One outcome per line. If a bullet has no conditional or default, it's a single sentence.
- **Backticks** for anything engineers need to identify precisely: field names (`overlock_exempt`), status values (`Needs advertisement`), config paths (`Settings > Lease configurations > [config] > Delinquency`), permission names (`Can edit rentability for vacant units`), flag names
- **`if/when -> then`** for conditional logic, nested sub-bullets under the condition
- **`->` arrows** for flows and state transitions: `Delivering lien` -> `Waiting for auction`
- **Tables** for mapping multiple items (competitors, config options, columns, permissions)
- **Before -> after tables** only when modifying existing behavior
- **Collapsible sections** — wrap complementary reference sections (matrices, warning tables, activity log templates, open questions) with `+++` markers before and after the content. This is Linear's native collapsible syntax. Do NOT use HTML `<details>`/`<summary>` tags — Linear does not render tables inside them.
- **Lifecycle diagram layout conventions** (see "When to add a lifecycle diagram" in Step 3 for triggers and production steps) — rendered image, never ASCII art (breaks in Linear's proportional font). Swim lanes per phase, decision diamonds for branching, new transitions highlighted in red, undo/revert actions as text labels next to the box (not return arrows — they create crossing lines). Pair with a Status × Actions matrix table in a collapsible section.
- **Table numbering** — number reference tables ("Table 1:", "Table 2:") in section headings for clear cross-referencing from the main body
- **Internal anchor links** — when referencing another section in the ticket (e.g., "see warnings table below"), use Linear's internal anchor links for navigation instead of plain text references
- **Machine-verifiable outcomes** — "what done looks like" items reference exact field names, permission names, config paths so an engineer or Claude Code can check against the codebase
- **Concise field definitions** — use `Field name` (required/optional, constraint) format, not prose. E.g., `Amount` (required, > $0.00) not "Amount is a dollar input that accepts any dollar-and-cent value"
- Default values always stated
- **Technical hints are rare** — only include when pointing to a specific reusable config path or a non-obvious verification step. Don't hint at patterns engineers already know from their codebase. If you'd remove it during dev review, don't write it.
- **"Same pattern as X" references are rare** — use only when the pattern is non-obvious or the engineer might build from scratch instead of reusing. One per ticket max, not on every bullet.
- **No PM rationale in outcomes** — "What done looks like" items are pure outcomes, not justifications. E.g., "Revenue recorded under new `Manager Special` payment category" not "...which enables GL mapping rules and cleaner reporting for operators"

## What NOT to include

- "User goals" / "Business goals" sections
- "Success metrics" or "How will we know this succeeded?"
- "User stories" (As a... I want... So that...)
- "Acceptance criteria" headers
- "Out of scope for v1" boilerplate
- Scope boundaries in the ticket body (post as comment instead)
- Customer context in the ticket body (post as comment instead)
- **Blocking** open questions in the main spec body — if a question blocks work, resolve it before writing the ticket
- Lengthy problem statements restating what the context already said
- **Explanatory prose in outcomes** — no "which enables...", "this ensures...", "so that...", "this is because...". The outcome states what; the Context section (if needed) states why.
- **Design narration** — if a design reference exists, do not describe dialog layouts, panel positions, button placements, or card contents that are visible in the design. Only specify: field names, validation rules, conditional logic, defaults, and technical constraints. The design covers what it looks like; the ticket covers how it behaves.
- Section headers with no content or placeholder text
- Technical hints about patterns the engineer already knows from their codebase
- **Internal code symbols** — class/service names, enum constant identifiers, private fields or variables (`WorkflowRunProcessorService`, `currentNodeIndex`, `WorkflowNodeType.SCHEDULE_CALL`). Litmus test: does this name exist only because of *how* eng builds it, not *what* the user observes? Cut it. Real existing entity fields the behavior keys off (`PhoneCall.status = ANSWERED`, `source = WORKFLOW`) stay — that's the observable contract, not the implementation. For workflow-node/action tickets especially, describe the action's observable behavior (what it creates, the fields it exposes, when it skips), never the run-loop mechanics (holds / advances / job-scheduling).

## Decomposing a feature into multiple tickets

When a feature is too big for one ticket (the 4+ concern-groups / 15+ done-items nudge in Step 4), split it into dependency-ordered iteration tickets with a shared foundation:

- **One foundation ticket** owns the complete entity/data model and the complete permission set — built once. Later tickets populate or reference those fields/permissions; they never re-define schema or add permissions piecemeal (single migration footprint, no incremental model churn).
- **Front-load the frontend** in the foundation: build all surfaces and controls permission-gated but non-functional, then later iterations wire each control's backend — so each FE area is touched once.
- **Order by dependency** and label every ticket with its iteration in the opening line ("Iteration 2 of N; ships with CORE-XXX"). Keep the label style identical across the set.
- **Single source of truth** — each fact lives in exactly one ticket; the others link to it (events, permission definitions, lifecycle rules: define once, reference everywhere else). Restating a shared rule in two tickets guarantees drift.
- **Finish with a consistency pass** (e.g. `/cyw`) across the whole set: enum/field names, permission names + gating, shared constraints, iteration labels, and that every cross-reference resolves.

Reference: the [Prime] Scheduled Calls split — CORE-738 (entity + full permission model + non-functional FE) → CORE-739 / CORE-840 (workflow node + lifecycle backend) → CORE-841 (go-live) → CORE-842 (manual). Permissions defined once in 738; events consolidated once in 840; each later ticket references rather than restates.

## Batch workflow

When writing multiple tickets in one session, draft all tickets before pushing any — this allows cross-referencing (e.g., "consider bundling with CORE-XXX") and ensures consistency across related tickets. Present all drafts together for review. Push sequentially after approval, posting PM context comments for each.

---

## How to use this skill

1. Ask clarifying questions only if feature behavior is genuinely ambiguous — not about goals, metrics, or audience. Present decisions as options with a recommendation, never open-ended.
2. Offer optional research (codebase grounding, related in-flight PRs) when it would change the spec — the user decides whether to spend the time.
3. Run the simplest-scope challenge before drafting anything that adds a new dialog, surface, or data model.
4. Judge standard vs complex format based on what the issue involves. For complex + new surface, suggest an ENG sync before deep-spec'ing.
5. Draft the title and description.
6. Present the draft for review.
7. On approval, push to Linear via `save_issue`.
8. Keep it scannable. Every line earns its place — no fluff.
