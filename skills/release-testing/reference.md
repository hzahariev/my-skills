# Release Testing — Reference

Reference material for the `release-testing` skill. Read this during triage (Step 2b) and the
human-verify handoff (Step 5); you don't need it in working memory the whole run.

## Staging details
- **URL:** `https://app-cubbysto-manager-staging-71a3fe-558743914190.us-east1.run.app/`
- **Login:** provided by the user per session (do not store credentials in any file)
- **GitHub repo:** `cubbystorage/cubby`
- **Linear teams:** Core FMS (`CORE-`), ENG (`ENG-`), ONB (`ONB-`), REVMAN (`REVMAN-`)
- **Impersonation:** Admin tools (top-right) → Managers → user row → **Impersonate** → … → **Exit** (yellow banner)

## What works well (lean on these — cheap and reliable)
- Read-only grid checks: default filter, sort both directions, column/badge visibility — proven via
  the resolved URL + a scoped grid snapshot.
- `auto-with-discard` inspection: open an editor (e.g. workflow trigger → change type → read the
  condition listbox), then **Leave page / discard**. Great for "is option/condition X available?".
- Template **variable-picker presence** checks (the value is registered/selectable) via the editor's
  Insert-value / Values list — use `browser_evaluate` to scan the expanded group.

## Known staging limitations (route these to human / eng up front)
- **Template rendering (lease-scoped vars, computed balances):** the in-app preview uses **mock data**
  and binds no `leaseId`, so `${Lease.*}` fixes (e.g. UnitSize trailing-zeros, EarliestLienEligibility,
  late-fee %) are **not** observable there. Verify via `GET /message-templates/{id}/preview` with a real
  `leaseId`, or a live send. (Variable *presence* in the picker is still checkable in-app.)
- **Workflow runs cannot be simulated on staging** — skip-missing-template, trigger side effects, and
  reservation→workflow behavior are `not-on-staging`; defer to backend/integration tests. (Triggered
  runs typically sit in `RUNNING` with no observable outcome.)
- **Auctions:** Refund / Mark-as-failed-hiding and $0-settle need a **settled auction with collected
  payment line items** (Winning Bid / Cleaning Deposit / Auction Deposit). Upcoming/unsettled auctions
  can't exercise these — `needs-data`.
- **Permission classifier:** any action it reads as a staging mutation is blocked even when you only
  intend to open a dialog and not Save → `human-verify`, not an agent action.
- **External API PRs:** runtime behavior isn't testable via the manager UI. The verifiable QA is
  whether the change is **documented in the Operator API docs** (https://cubbystorage.github.io/docs/api/) —
  check that the new parameter/endpoint appears on the relevant request; flag a DOCS GAP if missing.

## What NOT to do on staging (mutates shared data)
- Lease creation/deletion, payment flows (real card interaction), error-condition triggering, settling/
  refunding auctions, applying exemptions, or anything that creates state that can't be cleanly undone.
- Route all of these to the human-verify handoff (Step 5) with clear instructions.
