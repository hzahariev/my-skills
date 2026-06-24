---
name: doc-writer
description: >-
  Turn scattered, multi-source context (meeting recordings, Slack, Linear
  issues/projects/docs, GitHub PRs/code, BigQuery, screenshots) into a
  structured, grounded concept / discovery / alignment doc in Linear, in
  Cubby's "Open questions for All Aboard" house style — drafted and reviewed
  locally, then published to Linear only on an explicit GO. Use when Hristo
  wants to write a concept doc, discovery doc, alignment doc, "open questions"
  doc, or a PM proposal for a Core FMS / Cubby project, or invokes /doc-writer.
  NOT for concise engineering tickets (use ticket-writer) or generic prose.
---

# Doc Writer — grounded concept/alignment docs (Cubby PM style)

Hristo is a PM at Cubby Storage. This skill turns a pile of raw context into a crisp, **verified** concept/alignment doc in Linear that takes the team (and eventually a customer) from "scattered inputs" to "aligned on what we'll build" — *before* any Figma or spec.

## When to use / not use
- **Use** for: concept docs, discovery docs, alignment docs, "open questions" docs, PM proposals for a Cubby project.
- **Don't use** for: concise engineering tickets (→ `ticket-writer`); generic documents unrelated to Cubby product work.

## The house format (mirror this exactly)
Model every doc on Cubby's "Open questions for All Aboard":
1. **Framing (top):** the aim ("get aligned before we build"); **"proposed direction, not a commitment"**; an invitation to push back; the **scope boundary** (what's out / enhancement requests); the audience + review order.
2. **One alignment note:** pin down the single mental-model thing that's easy to misread (e.g. how the new thing differs from the existing thing it reuses).
3. **At-a-glance table:** `# | What we heard (the need) | Our proposed approach | Net-new?` — one row per topic.
4. **Per-topic sections** (numbered, priority order): **What we heard** (the need; cite the source) / **Our proposed approach** (with a lean) / **Open questions** (numbered Q1…, where their input changes direction). Renumber Qs sequentially across the whole doc; a topic that's settled has no open question.
5. **Future considerations — out of scope for this project:** deferred ideas, captured so they're not lost.

**Voice:** plain language for the *named audience* (a customer may read it). No jargon/slang — run a jargon pass ("lazily", "burn postage", etc. → plain words) before publishing.

## Workflow
1. **Frame the deliverable.** Confirm up front, before writing a word:
   - the **destination** — the *exact* Linear doc (new or existing); avoid creating duplicates;
   - the **exemplar/format** to mirror;
   - the **audience(s) + review order**;
   - the **GO-gate** — publish nothing to a shared surface until an explicit "GO";
   - **content-preservation** — if the target carries *other people's inline comments*, never full-replace it (use a separate doc, or append in the editor).
2. **Gather & ground.** Ingest the sources provided — Fellow meeting transcripts, Linear (projects/docs/issues), GitHub PRs + the local codebase, BigQuery, Notion, screenshots. **Cubby data → BigQuery; code logic → the codebase** (don't infer data from code or vice-versa). Use subagents for heavy reads to keep the main context clean. **Cite or flag every current-state claim** — never assert product behavior you haven't verified; mark assumptions explicitly; attribute design directives to their source (e.g. a project overview line, a teammate's Slack comment).
3. **Model & align.** Synthesize a verified picture; surface the keystone insight + the real decisions/gaps; reflect it back and get alignment *before* drafting.
4. **Draft in the house format** (above), leading each open question with a recommendation/lean.
5. **Self-review (`/cyw`).** Cross-check the draft against (a) what was discussed and (b) the source docs; capture deferred ideas as "Future considerations"; flag what's genuinely worth discussing vs. decided.
6. **Publish on GO.** Keep a local mirror (`plans/<slug>/concept-draft.md`); edit it freely and push to Linear only at confirmed checkpoints — **batch edits, don't re-save per word** (Linear's save replaces the whole doc body). After saving, **verify the write committed** (re-fetch or check `updatedAt` advanced — a silent no-op means the doc is open in the editor). Never clobber others' comments.

## Guardrails (non-negotiable)
- **Cite-or-flag** every current-state claim (code / BQ / prod); mark assumptions; attribute directives.
- **Plain language** for the audience; jargon pass before publish.
- **GO-gate** — no publish to any shared surface without an explicit "GO".
- **Comment-safety** — never full-replace a Linear doc that carries others' inline comments.
- **One canonical doc** — confirm the destination first; don't leave stale duplicates.
- **Local mirror + checkpoint push** — edit local, push at checkpoints, verify the commit.

## Linear mechanics
- `get_document` / `save_document` (full-content replace; pass `id` to update an existing doc; verify `updatedAt` advanced after a save).
- Comments: `list_comments` (with `documentId`). Anchored inline comments appear as `<linear-comment …>` inside the content — round-tripping them through `save_document` is risky, so prefer a separate doc when the target is commented.
- Linear regenerates the URL slug from the H1, but `slugId` is stable — existing links keep working.

## Cubby grounding sources (typical)
- **Meetings:** the Fellow transcript MCP (search by topic/participants; pull summaries before full transcripts).
- **Data / setup:** BigQuery `cubby-production.mysql_replication_target` (org-scoped; e.g. org 1 = internal "Cubby" test org, org 277 = All Aboard).
- **Code / logic:** the local `cubby` checkout.
- **Tickets / projects / docs:** the Linear MCP.
- **Provider / KB:** Notion.
