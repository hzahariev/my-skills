---
name: ticket-writer
description: Write well-defined Linear engineering issues in a structured format. Only invoke when the user explicitly types /ticket-writer. Supports two modes — create (new issue) and refine (restructure existing issue by ID). Always drafts first for review, then pushes to Linear on confirmation.
---

# ticket-writer

Write terse Linear engineering specs. Every line earns its place — if an engineer would skip it, cut it.

> **Golden rule:** Keep terse phrasing for scope items that need to be delivered by dev. One observable fact per line. No explanations, no rationale, no filler. The ticket is a checklist of what to build — not a narrative of why.

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

**Multi-message input:** If the user needs to send screenshots, notes, or context across multiple messages (e.g., image limits), say: "Send everything you have. If you hit the image limit, keep going in follow-ups and say 'done' when finished." Do not start drafting until the user confirms all input is provided.

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

Reference examples:
- **Complex:** CORE-49 (Shop: Add Manager Special sale action) — 4 concern groups, new permission, new payment category, conditional logic, cross-cutting Walk-in fix
- **Standard (gold standard):** CORE-164 (Trigger: Add Move-out trigger) — terse flat list, one fact per line, no explanatory prose
- **Standard:** CORE-163 (Workflows: Add move-in trigger and trigger sections), CORE-150 (Runs: Adjust runs screen badge styling), CORE-155 (Add preview for message templates), CORE-232 (Runs: Surface entity context in runs grid)

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

**Migrations & data**
- New [category/type/entry]: `Name`
- New permission: `Group.Permission`; state default role assignment and link to related sections it feeds into (e.g., activity logs)

### Open questions to resolve w ENG during dev

- [Known trap or ambiguity — one line]
```

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

1. If scope boundaries, customer quotes, or discovery resources were collected, post them as a comment via `save_comment` with a `### PM context` header. Group: scope boundaries first, then customer context, then discovery links.
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

## How to use this skill

1. Ask clarifying questions only if feature behavior is genuinely ambiguous — not about goals, metrics, or audience.
2. Judge standard vs complex format based on what the issue involves.
3. Draft the title and description.
4. Present the draft for review.
5. On approval, push to Linear via `save_issue`.
6. Keep it scannable. Every line earns its place — no fluff.
