---
name: api-doc-writer
description: >-
  Turn a cubbystorage/cubby PR that adds or changes Operator API request fields,
  endpoints, or response fields into a standalone, shareable "advance copy" API
  doc for an external integrator (SM2 / Prime's website team building on the
  Operator API), in the "Upcoming Operator API — <feature>" house format they
  already receive. Grounds examples and field wording in the PR's
  external_api.md diff + the current doc; drafts locally and prints a copy/paste
  version; nothing posted without a GO. Use when Hristo says "prep the API doc
  for this PR", "doc for SM2/Cameron", "give them the API doc in advance", or
  invokes /api-doc-writer. NOT the canonical external_api.md edit (that's eng's,
  in the PR), NOT a Linear ticket (use api-spec / ticket-writer), NOT an
  internal product doc (use product-doc-writer).
---

# API Doc Writer — advance Operator API docs for external integrators

Produces a **standalone, shareable** Operator API doc for an outside integrator — today that's **SM2** (Cameron McKinley, `cmckinley@sm2dev.com`), who is building Prime's website on the Operator API. The point is to hand them the exact request contract **in advance of the rendered docs** so they aren't blocked building their side. Audience: an external developer integrating against `/v1/...` — operator-facing and contract-focused, never internal class names or mechanics.

Canonical exemplar: the **"Merchandise at checkout"** doc Hristo posted to Cameron in Slack `#xwf-sm2` on 2026-09-09 (thread parent `1788939432.597269`, channel `C09F4M6TJUU`). Mirror its shape.

## The house format

1. **Title** — `# Upcoming Operator API — <feature>` (short; mirror the PR title's verb, e.g. "Turn off Cubby's confirmation and receipt emails").
2. **Banner blockquote** — pick the framing by the change's release status (confirm with Hristo if unsure; this is the one real judgment call):
   - *Not merged / contract could still move* → `> ⚠️ Pre-release / subject to change. … We're sharing it early so you can start building; we'll flag any changes to the contract before or at release.`
   - *Merged, ships soon (e.g. hotfix today), rendered docs lag* → `> ℹ️ Advance copy. These additions ship to production <when>; the rendered Operator API docs will be updated to match shortly after. The contract below is final — we're sharing it now so you're not blocked …`
   - *Already live* → `> ✅ Released — now live in the Operator API.`
3. **Section intro prose** — what the feature does, who it's for, the one-line *why* (e.g. "tenants were getting each email twice"). If the change spans several endpoints with shared semantics, add a **summary table** (`Field | Endpoints | Controls`) + a shared-behavior bullet list, then go per-endpoint.
4. **Per-endpoint section**, one per affected endpoint, separated by `---`:
   - `### <Endpoint name> — <what this adds here>`
   - `` `POST /v1/<path>` ``
   - `> Request Body — <endpoint>` then a ```json example (see Conventions — trimmed but faithful, the new field shown in context).
   - `> Response Body — <endpoint>` + ```json **only when a response changes**.
   - A line or two of prose on behavior / edge cases.
   - `Available to the \`X\` and \`Y\` roles.` **only when a new endpoint or permission is involved.**
   - `#### Required Properties` / `#### Optional Properties` / `#### Response Parameters` as `* \`field\` — description` bullets.
5. **`## Notes`** closing — state when there are no new endpoints/roles/response fields (so they know nothing is required unless they opt in), plus any edge cases (e.g. a deferred direct-debit payment still honours the flag).

## Grounding — sources, in order

1. **The PR.** `gh pr view <n> --repo cubbystorage/cubby --json title,body,author,state,files,url` and `gh pr diff <n> --repo cubbystorage/cubby` (save to scratchpad; `gh` resets cwd, use absolute paths).
2. **The `doc/external-api/external_api.md` diff is gold.** It carries the exact, eng-authored field descriptions and the changelog blurb. **Lift that wording** for the property bullets and the behavioural claims — do not paraphrase semantics. The changelog entry (top of the file, under the current month) is the crispest one-paragraph summary of the whole change.
3. **The request/response DTOs in the diff** (`api/lib/.../dto/api/*Request.java`) — confirm field names, types, defaults, and exactly which endpoints get which field.
4. **The current `external_api.md`** in the cubby checkout (`~/Documents/cubby work docs/cubby`) for faithful examples: `grep -n 'Request Body — <endpoint>'` to find each real request body, and read it for the real shape + anchors + section heading names. Harvest the ID-prefix conventions from existing examples (`grep -oE '"(fac|lead|lease|cust|pg|unit|pm|prod|org)_[A-Za-z0-9]+"'`).

## Conventions

- **Faithful, trimmed JSON.** Reuse the canonical example IDs the doc already uses (`fac_C7bSZyPT6fp`, `unit_GfNkzV4itfk`, `cust_BqaN6zApXCH`, `lease_V4w64pjUwVK`, `pm_V4w64pjUwVK`, `lead_7pQvR2xTmWs`, `pg_4a2da7d271a`, …) so it reads like the real docs. Show the **identifying fields + the new field(s)** only — don't dump a 40-line body. Keep it valid JSON (no comments).
- Use ` ```json ` fences for the shared copy (the repo uses ` ```json-doc ` internally — don't carry that over).
- **Don't invent behaviour.** Every semantic claim (defaults, "can't turn on an email the facility disabled", "text messages unaffected", "workflow emails are independent", "recorded on the payment so deferred settlement honours it", "ignored when X") must trace to the `external_api.md` wording or the DTO. When in doubt, verify in code with an Explore agent.
- Keep it to what the caller sends and what Cubby does. No internal service/class names.

## Deliverable & handoff

- Save to `~/Documents/Clude code desktop/operator-api-<slug>-doc-YYYY-MM-DD.md` (deliverables folder, dated name). Send it with `SendUserFile`.
- When Hristo asks for it "to copy/paste", print the **full doc inline**, clean, ready to paste into Slack.
- **Nothing is posted anywhere without an explicit GO** (confirm-before-posting). Offer to stage it as a Slack draft on `#xwf-sm2` with a short intro line — draft only, never send.
- Operator API tickets default to project **P-CORE-979** "Prime: Operator API - Go Live" — but this skill writes the *doc*, not tickets; only touch Linear if asked.
