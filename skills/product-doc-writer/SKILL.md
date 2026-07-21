---
name: product-doc-writer
description: >-
  Write a code-grounded internal product-documentation article in Notion (under
  "Product documentation") explaining how a Cubby feature works today — core
  concepts, entities, statuses/lifecycle, execution model, settings,
  permissions — for the engineering/product/design teams building it. Sources:
  the feature's Linear projects/tickets for the narrative, the cubby codebase
  (latest origin/master) as the canonical truth, plus a hand-authored SVG
  lifecycle diagram uploaded into the page. Use when Hristo asks for a "notion
  article under product documentation", to "document how <feature> works", or
  invokes /product-doc-writer. NOT a user how-to guide (Intercom help center
  covers that), NOT a concept/alignment doc (use doc-writer), NOT a ticket
  (use ticket-writer).
---

# Product Doc Writer — code-grounded feature documentation (Notion)

Produces an internal concepts article in Cubby's Notion **Product documentation** section (parent page `35ddc4651f0c8032bec3d599612cec4e`), modeled on the existing articles (Lien & Auctions, Workflows). Audience: eng/product/design who develop the feature and need the mental model — entities, lifecycle, mechanics — not end-user instructions.

## The house format (mirror an existing sibling article)
1. Header lines: `*product area: Core FMS*` and `*page owner: <mention-user url="user://…"/>*` (reuse the owner mention from a sibling page; ask Hristo to confirm it renders as him).
2. One-paragraph overview: what the feature is, what the doc covers, and the grounding statement ("grounded in production code (master, YYYY-MM-DD)").
3. Lifecycle/architecture **diagram** near the top (see Diagram below).
4. **Table-driven sections** separated by `---`: core entities, triggers/statuses, actions/nodes, execution model, lifecycle & management, settings, permissions. Prose only where a table can't carry it.
5. **Related tickets** (Linear links with one-line whys) and a *Sources* footer citing the Linear projects + repo commit SHA/date.
6. Length ≈ the Lien & Auctions article — short enough that people actually read it. Cut ruthlessly; verbatim identifiers over paraphrase.

## Workflow
1. **Template & destination.** Fetch the Product documentation parent page and one sibling article as the structure/length exemplar. New page → `notion-create-pages` under the parent; existing page → update in place.
2. **Gather from Linear.** `list_issues` for each of the feature's projects. Large dumps (>50k chars) → digest via a subagent: per-issue identifier, status, and what it says about *current* mechanics, quoting terminology verbatim. **Classify shipped vs not**: only `Done / Shipped` describes current behavior; `PR Merged / QA Ready` is *not shipped* (flag 🚧); refinement/backlog/triage is future — never document it as current. `get_issue` the main spec ticket(s) in full.
3. **Draft from tickets — then ground in code (mandatory).** Tickets lie: descriptions are aspirational, implementations drift, and follow-ups ship silently. Verify against **latest origin/master**:
   - The local cubby checkout is often stale and `git pull` can abort on untracked local files — **don't touch them**; instead `git fetch origin` + `git worktree add <scratchpad>/cubby-master origin/master`, and `git worktree remove` when done.
   - Send an **Explore agent (very thorough)** a numbered list of every mechanical claim in the draft; require per-claim verdicts (confirmed / wrong / partial) with corrected facts, **verbatim enum values / column / permission names**, and `file:line` evidence. Also ask what important current mechanics the draft misses entirely.
   - **Code is canonical.** Correct the article to the code; keep UI labels alongside enum values where they differ (e.g. `STOPPED` = "Terminated").
4. **Publish** to Notion (create or `replace_content`), then re-fetch once to confirm tables/mentions rendered.
5. **Diagram.** Author an SVG by hand (lifecycle/state flow + main runtime loop; muted palette, rounded rects, decision diamonds, colored end-state pills). Verify visually: render with headless Chrome (`--headless --screenshot --window-size=WxH --default-background-color=FFFFFFFF file://…svg`) and Read the PNG — fix overlaps/stray arrows before publishing. Upload via `notion-create-attachment` (SVG as inline text content) and embed with `<image src="file-upload://<id>"></image>` **within 1 hour** of upload, right after the intro. Keep the source `.svg` in the working dir for future edits; offer a `--force-device-scale-factor=2` PNG for sharing outside Notion.
6. **Report discrepancies, don't fix them silently.** Ticket-vs-code mismatches (stale tickets, shipped-but-open work) go to Hristo as a follow-up list for Linear reconciliation — no Linear comments or Slack announcements without explicit go-ahead.
7. **Memory.** Save/refresh a memory pointer to the article: URL, grounding commit, 🚧 items to unflag when they ship, and where the diagram source lives.

## Guardrails (non-negotiable)
- **Code-canonical:** never let a ticket claim override what the code shows; every mechanic in the article traces to code evidence or a shipped ticket.
- **Shipped-only as current:** merged-in-QA = 🚧 note; refinement/backlog = omit or explicit "proposed".
- **Verbatim identifiers:** enum values, column names, permission strings exactly as in code — that's what makes the doc useful to engineers.
- **Not a how-to:** no step-by-step operator instructions; Intercom owns those.
- **Confirm-before-posting** for anything beyond the article itself (Linear comments, Slack posts).

## Notion mechanics
- Parent: Product documentation page `35ddc4651f0c8032bec3d599612cec4e`; articles are child pages with an emoji icon.
- Tables via GFM markdown; `<mention-user url="user://…"/>` for the page owner; `> 🚧 …` callout-style line for in-QA features.
- `update-page` with `update_content` (old_str/new_str) for surgical edits; `replace_content` for full rewrites.
- `notion-create-attachment` accepts UTF-8 text (incl. SVG) inline; response's `file-upload://` source must be attached to a page within an hour or it expires.
