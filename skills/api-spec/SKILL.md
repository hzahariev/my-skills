---
name: api-spec
description: Turn an API enrichment request into a researched, scoped Linear ticket. Takes a customer request (Slack, spreadsheet, verbal), researches the current API + system data model, identifies the gap, drafts a ticket with variable tables, pushes to Linear, and prepares tracker spreadsheet rows. Use when the user says "api spec", "spec this API request", "write an API ticket for X", or invokes /api-spec.
---

# api-spec

Go from an external API request to a shipped Linear ticket with tracker rows. PM-scoped — no dev implementation suggestions, no JSON appendices.

> **Golden rule:** Always check the [Operator API docs](https://cubbystorage.github.io/docs/#operator-api) FIRST. The requested variables may already exist — either documented or undocumented. We are product managers. The ticket defines *what* variables to expose with types and examples. We do not tell engineers *how* to structure the JSON or implement it.

---

## Step 1 — Intake

Parse the user's input to extract:

- **What's being requested** — which variables, data, or fields
- **Who's requesting it** — customer name, source link (Slack thread, spreadsheet row, email)
- **Which API** — typically Operator API, but could be any
- **Which endpoint** — existing endpoint to enrich, or new endpoint needed

If the request is vague (e.g. "they need location data"), ask the user to clarify what specific data points are needed. If the user provides a Slack link, read the thread. If they provide a spreadsheet link, read it.

---

## Step 2 — Research

### 2a. Current API state (ALWAYS FIRST)

Fetch the API docs BEFORE any other research. This determines whether the request is already fulfilled.

- Operator API docs: https://cubbystorage.github.io/docs/#operator-api
- Use WebFetch to extract all fields on the relevant endpoint
- If everything requested is already in the API and documented → stop, inform the user, no ticket needed

### 2b. System data (staging app) — run 2b–2d in parallel

Check the staging manager app to see what data exists in the UI that isn't in the API.

- Staging base URL: https://app-cubbysto-manager-staging-71a3fe-558743914190.us-east1.run.app
- Navigate to the relevant settings/entity page and screenshot it
- Note every field visible in the UI

### 2c. Data model (codebase or BigQuery)

Check the source of truth for the data model:

- **Codebase**: Search for Java entity classes under `cubby/api/lib/src/main/java/com/cubby/model/`
- **BigQuery**: If the user provides access or runs queries, use the table schemas from `mysql_replication_target` dataset
- Note: column names, types, relationships (FK, join tables), and any JSON fields

### 2d. Scope spreadsheet (if provided)

Cross-reference the scope/tracker spreadsheet to see what's been cataloged and what status each item has. Use the Google Drive MCP `read_file_content` tool with the spreadsheet's file ID.

---

## Step 3 — Gap analysis

For each requested variable, classify it into one of three outcomes:

| Outcome | Meaning | Action |
|---|---|---|
| **Existing + documented** | Already in the API and in the docs | Obsolete request — inform the customer it's already available. No ticket needed. |
| **Existing + undocumented** | Already returned by the API but missing from the docs | Ticket scope = update the Operator API docs only. No dev work needed. |
| **Not existing + undocumented** | Not in the API at all, needs to be built | Ticket scope = create the API variables + document them. |

Produce a clear comparison table:

| Variable | In API? | In Docs? | In System? | Outcome |
|---|---|---|---|---|
| `example.field` | Yes | Yes | Yes | Obsolete — already available |
| `another.field` | Yes | No | Yes | Doc-only — update API docs |
| `new.field` | No | No | Yes | New scope — build + document |
| `missing.field` | No | No | No | Doesn't exist in system — flag to user |

Present this to the user for review before drafting. Ask:
- Should we include everything, or only a subset?
- Anything to park for later?
- Any fields to exclude?

**If all items are "Existing + documented"** → no ticket needed. Inform the user the request is already fulfilled and offer to reply to the customer with the relevant API docs/endpoints. Stop here.

**If only "Existing + undocumented" items** → ticket scope is documentation only.

**If any "Not existing" items** → proceed to Step 4.

---

## Step 4 — Draft the ticket

Use the established format from CORE-230, CORE-699, CORE-718, CORE-719.

### Title

`Operator API: [short description of what's being exposed]`

### Description structure

```markdown
## context

> **[Customer] request:** *[Exact quote of the request]*
>
> — [Source](link)

[1-2 paragraphs: what endpoint already returns, what's missing, why the customer needs it]

* [Scope spreadsheet](link) (relevant section)
* [Operator API docs](https://cubbystorage.github.io/docs/#operator-api)

---

## scope

- [ ] Expose the following **[group name]** variables:

| Variable | Type | Description | Example |
| -- | -- | -- | -- |
| `variable.name` | type | One-line description | `"example value"` |

- [ ] Expose the following **[another group]** variables:

| Variable | Type | Description | Example |
| -- | -- | -- | -- |
| `variable.name` | type | One-line description | `"example value"` |

- [ ] Update [Operator API docs](https://cubbystorage.github.io/docs/#operator-api) with the new fields
```

### Conventions

- Variable tables always have 4 columns: **Variable, Type, Description, Example**
- Group variables by logical category (e.g. "operational hours", "description & tags", "payment channel fees")
- Each group is a separate checkbox item with its own table
- Monetary values: integers in cents (e.g. `300` not `$3.00`)
- Dates: ISO-8601 format
- Enums: list all possible values (e.g. `SYSTEM` or `CUSTOM`)
- Arrays: show type as `string[]` or `object[]` with description of the structure
- Context section includes customer quote as blockquote with source link
- "Update Operator API docs" is always the last scope item
- No JSON appendix
- No dev implementation suggestions
- No "risks" or "edge cases" sections
- No scope boundaries section in the ticket body

### Parked items

If the user wants to park a scope item for later, add it at the bottom with strikethrough:

```markdown
---

### ~~PARKED: [Item name]~~

~~[Reason it's parked. Brief description of what would be exposed if un-parked.]~~

~~Variables that would be exposed:~~

| ~~Variable~~ | ~~Type~~ | ~~Description~~ |
| -- | -- | -- |
| ~~`variable`~~ | ~~type~~ | ~~description~~ |
```

---

## Step 5 — Review and push

1. Present the draft as a markdown code block for user review
2. Iterate on feedback — the user may adjust wording, remove/park items, change groupings
3. On approval, push to Linear:
   - Use `save_issue` with title, description, team, assignee, labels, project as specified by user
   - If the project doesn't exist, create it first with `save_project`
   - Verify the ticket landed in the correct project
4. If the channel is Slack Connect (externally shared), use `slack_send_message_draft` instead of `slack_send_message`
5. If the request originated from a Slack thread, offer to draft a reply to the customer explaining what's already available and what's being built

### Default Linear settings (override if user specifies different)

- **Team**: Core FMS
- **Assignee**: Georgi Sinekliev
- **Priority**: High
- **Labels**: as specified by user (common: PRIME, CS Request, Backend)

---

## Step 6 — Tracker update

Prepare copy/paste rows for the scope spreadsheet following its existing column structure:

| Object name on Prime website | Standard variable in Cubby | In Operator API today? | API Endpoint/Response Field | Status | Verification Notes |
|---|---|---|---|---|---|

- Add a section header row (bold, e.g. **FACILITY METADATA**)
- One row per variable
- Status per outcome:
  - `✅ Confirmed` — existing + documented
  - `⚠️ Undocumented` — existing + undocumented (needs docs update)
  - `❌ Missing` — not existing (needs dev work + docs)
- Include a brief verification note with type info or example

Present the rows as a markdown table the user can copy into the spreadsheet.

---

## Reference tickets

These are the gold-standard examples of the format:

- **CORE-230** — Value pricing / pricing strategy variables (the original template)
- **CORE-699** — Facility location metadata (hours, description, tags)
- **CORE-718** — Payment fee configuration variables
- **CORE-719** — Add storingVehicle input to lease creation (simpler, single-variable ticket)
