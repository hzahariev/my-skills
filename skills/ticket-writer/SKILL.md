---
name: ticket-writer
description: Write well-defined Linear engineering issues in a structured format. Use when the user says "write a ticket", "create an issue", "spec this", "draft a linear ticket", "refine CORE-XXX", "rewrite this ticket", or any request to document a feature for engineering. Supports two modes — create (new issue) and refine (restructure existing issue by ID). Always drafts first for review, then pushes to Linear on confirmation.
---

# ticket-writer

Write Linear engineering issues that serve three audiences: **engineers** (know exactly what to build), **designers** (can validate their work captures all changes), and **Claude Code** (can use the issue as a completeness checklist).

---

## Modes

Detect the mode from the user's input:

- **Create** — user describes a feature, pastes raw context, or says "write a ticket for X"
- **Refine** — user says "refine CORE-49", "rewrite CORE-XXX", or references an existing issue ID

---

## Step 1 — Interview

### Create mode

Ask only what the user hasn't already provided. Skip any step their input already covers:

1. **What's broken or missing today?** — the problem
2. **What should happen instead?** — the desired outcome
3. **Is there a design?** — Figma link, or "not yet" / "not needed"
4. **Any dependencies or blockers?** — related Linear issues, or skip
5. **Any customer context?** — quotes, Slack links, or skip
6. **Any technical constraints the engineer should know?** — or skip

When the user pastes raw input (Slack thread, meeting notes, customer email), extract problem/outcome/quotes and structure them. Do not ask the user to re-explain what they already provided.

### Refine mode

1. Fetch the existing issue via `get_issue` (with `includeRelations: true`)
2. Fetch issue comments via `list_comments` — scan for design links (Figma URLs), resolved decisions, and context that should be folded into the spec
3. Note existing attachments (meeting recordings, docs, Intercom links) — these must be preserved or referenced in the refined ticket
4. If the existing ticket has open questions, ask the user which are now resolved — fold answers into scope and suggest moving resolved questions to a comment
5. Present related issues from step 1 and ask: "Are any of these now duplicates, dependencies, or no longer relevant?"
6. Present a short summary of the current structure and what's missing or could improve relative to the target format
7. Ask the user what to change, add, or restructure — or proceed with a full reformat if they say "rewrite it"

**Multi-message input:** If the user needs to send screenshots, notes, or context across multiple messages (e.g., image limits), say: "Send everything you have. If you hit the image limit, keep going in follow-ups and say 'done' when finished." Do not start drafting until the user confirms all input is provided.

---

## Step 2 — Judge complexity

Choose the format based on what the issue involves:

- **Standard** — single concern, one surface area, no permissions or migration changes
- **Complex** — multiple concerns (frontend + backend + permissions + migrations), conditional logic, state transitions

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

Use for single-concern, well-scoped issues:

```markdown
[1-2 sentence intro — what this issue delivers and minimal context.]

### Design reference

[Figma link/embed/screenshot]

### Dependencies

> **Blocked by:** CORE-XXX — reason
> **Blocks:** CORE-XXX — reason

### What done looks like

- [Observable outcome — falsifiable, machine-verifiable statement]
- [Another outcome — reference exact field names, permission names, config paths]
- [Another outcome]

### Scope boundaries

- [Explicit exclusion] is out of scope and should be tracked separately.

---

### Customer context
> "Direct quote" — Name, Company
> [Source link]
```

### Description — Complex format

Use for multi-concern issues with frontend + backend + permissions + migrations:

```markdown
[1-2 sentence intro — what this issue delivers and minimal context.]

### Design reference

[Figma link/embed/screenshot]

### Dependencies

> **Blocked by:** CORE-XXX — reason
> **Blocks:** CORE-XXX — reason

### Context

[3-6 sentences. Current state -> gap/problem -> what needs to change. Plain prose, no bullets.]

---

### What done looks like

**Surface changes**
- [What the user sees/does differently]
  - detail
  - *Note:* edge case or clarification

**Behavior & logic**
- [What changes in processing, validation, state transitions]
  - **When [condition]** -> [behavior]
  - **Default:** [value] — [migration note or "no migration needed"]
  - *Technical hint:* [inline note for engineers on this specific item]

**Permissions**
- [New or modified permissions]
  - Who gets it by default (or "not assigned by default — admin must grant")
  - What it gates

**Migrations & data**
- [Schema changes, data backfills, new categories]
  - Migration required: yes/no

### Scope boundaries

- [Explicit exclusion] is out of scope and should be tracked separately.

---

### Customer context
> "Direct quote" — Name, Company
> [Source link]
```

### Optional sections rule

Design reference, Dependencies, Context, and Customer context are only included when they have content. Omit any section that would be empty — never show placeholder text.

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

### Refine mode

Call `save_issue` with:
- `id`: the existing issue identifier (e.g., `CORE-49`)
- `title`: the updated title
- `description`: the updated description

Preserve all existing metadata (assignee, priority, labels, project). Only update title and description.

### Post-push (both modes)

After successfully pushing, offer: "Want me to search for duplicate tickets and mark them as duplicates of this issue?" Search by keywords from the title and description, review matches, and present candidates for the user to confirm before marking.

---

## Format rules

- **Backticks** for anything engineers need to identify precisely: field names (`overlock_exempt`), status values (`Needs advertisement`), config paths (`Settings > Lease configurations > [config] > Delinquency`), permission names (`Can edit rentability for vacant units`), flag names
- **`if/when -> then`** for conditional logic, nested sub-bullets under the condition
- **`->` arrows** for flows and state transitions: `Delivering lien` -> `Waiting for auction`
- **Tables** for mapping multiple items (competitors, config options, columns, permissions)
- **Before -> after tables** only when modifying existing behavior
- **Bold key terms** on first use when introducing a concept
- **`*Note:*`** for inline clarifications that don't fit the main flow
- **Machine-verifiable outcomes** — "what done looks like" items reference exact field names, permission names, config paths so an engineer or Claude Code can check against the codebase
- Required vs optional fields explicitly stated with the condition that toggles them
- Default values always stated with migration impact

## What NOT to include

- "User goals" / "Business goals" sections
- "Success metrics" or "How will we know this succeeded?"
- "User stories" (As a... I want... So that...)
- "Acceptance criteria" headers
- "Out of scope for v1" boilerplate
- "Open questions" unless genuinely blocking and not answerable without the engineer
- Lengthy problem statements restating what the context already said
- **Design narration** — if a design reference exists, do not describe dialog layouts, panel positions, button placements, or card contents that are visible in the design. Only specify: field names, validation rules, conditional logic, defaults, and technical constraints. The design covers what it looks like; the ticket covers how it behaves.

## How to use this skill

1. Ask clarifying questions only if feature behavior is genuinely ambiguous — not about goals, metrics, or audience.
2. Judge standard vs complex format based on what the issue involves.
3. Draft the title and description.
4. Present the draft for review.
5. On approval, push to Linear via `save_issue`.
6. Keep it scannable. Every line earns its place — no fluff.
