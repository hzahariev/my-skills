# Release Testing — Reference

Reference material for the `release-testing` skill. Read this during triage (Step 2b) and the
human-verify handoff (Step 5); you don't need it in working memory the whole run.

## Preview environment details

QA runs in **per-PR preview environments only — never staging** (as of 2026-07-02). Each PR gets its
own ephemeral Manager preview deploy, so it reflects exactly that PR's code and is isolated from
shared data.

- **Preview URL:** posted as a `github-actions` comment on the PR, format
  `:rocket: [Manager preview](<url>)`. Extract it per PR:
  ```bash
  gh pr view <number> --repo cubbystorage/cubby --json comments \
    --jq '.comments[] | select(.author.login=="github-actions") | .body' | grep -o 'https://[^)]*app-preview[^)]*'
  ```
  If no preview comment exists, the deploy hasn't built yet (or the PR predates preview envs) — ask
  the user for the link rather than falling back to staging.
- **Login:** provided by the user per session (do not store credentials in any file).
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

## Known preview-environment limitations (route these to human / eng up front)

Preview envs are per-PR and isolated, so the old *shared-data* reason to avoid mutations is gone — you
won't corrupt staging. **But two constraints still apply:** (1) the auto-mode **permission classifier
still blocks** any action it reads as a mutation, even in an isolated preview, so mutating entry points
remain `human-verify`; (2) a preview env may lack real bound data (leases, settled auctions, delinquent
tenants), so data-dependent checks are still `needs-data`.

- **Template rendering (lease-scoped vars, computed balances):** the in-app preview uses **mock data**
  and binds no `leaseId`, so `${Lease.*}` fixes (e.g. UnitSize trailing-zeros, EarliestLienEligibility,
  late-fee %) are **not** observable there. Verify via `GET /message-templates/{id}/preview` with a real
  `leaseId`, or a live send. (Variable *presence* in the picker is still checkable in-app.)
- **Workflow runs cannot be simulated in preview** — skip-missing-template, trigger side effects, and
  reservation→workflow behavior are `not-on-staging`; defer to backend/integration tests. (Triggered
  runs typically sit in `RUNNING` with no observable outcome.)
- **Auctions:** Refund / Mark-as-failed-hiding and $0-settle need a **settled auction with collected
  payment line items** (Winning Bid / Cleaning Deposit / Auction Deposit). Upcoming/unsettled auctions
  can't exercise these — `needs-data`.
- **Permission classifier:** any action it reads as a mutation is blocked even when you only
  intend to open a dialog and not Save → `human-verify`, not an agent action.
- **External API PRs:** runtime behavior isn't testable via the manager UI. The verifiable QA is
  whether the change is **documented in the Operator API docs** (https://cubbystorage.github.io/docs/api/) —
  check that the new parameter/endpoint appears on the relevant request; flag a DOCS GAP if missing.

## What the agent still can't drive in preview (route to human-verify)
- Payment flows (real card interaction), external-integration toggles, and anything the permission
  classifier reads as a mutation — blocked by the classifier regardless of the isolated environment.
- These are safe *data-wise* in an isolated preview, but the agent can't click them → route to the
  human-verify handoff (Step 5) with clear instructions so the user drives them.
