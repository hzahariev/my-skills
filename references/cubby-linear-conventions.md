# Cubby Linear Conventions (shared skill reference)

Cited by `/ticket-writer`, `/cs-requests-triage`, and `/cs-requests-update`. When a skill step says _"see cubby-linear-conventions"_, **read this file** — skills don't auto-load sibling files, so each skill must `Read` this explicitly at the relevant step.

---

## Notifications (when speccing a user notification)

- **Framework:** `NotificationSetting.Type` enum + `NotificationService.triggerLeaseNotification(...)`, which auto-scopes to a facility's (and org's) active managers holding the relevant permission. Channels: **In-App (= the `PUSH` channel) / Email / SMS**.
- **Default OFF / opt-in.** Never default Email or SMS on — don't hit inboxes without permission. In-app default-on only for low-volume, clearly-useful alerts; **all-off** for high-volume/bursty ones (e.g. delivery failures).
- "Notify when X is due/eligible" with **no domain event to hook** → a daily **sweep** modeled on `TASKS_DUE_TODAY` (the one existing type that sweeps + sends a consolidated list). Note `TASKS_DUE_TODAY` disables the in-app/PUSH channel — batch digests aren't surfaced as in-app alerts. No same-day consolidation mechanism exists otherwise.

## Linear rendering (spec formatting)

- For notification / multi-attribute specs, use **transposed Field → Value tables** (one attribute per row), not wide multi-column tables — Linear truncates wide cells.
- `${Variable.Name}` tokens get **auto-link-mangled** by Linear's editor (especially on re-open) and can render as broken links. They survive a clean API push but re-mangle if the issue is edited in the app. If stability matters, use backtick/code form `` `${Var}` ``.

## Linear labels (Cubby)

- 🔝 CS Top Request — id `0efe4774-742f-4c5c-b7cf-9ea812608863` (the prioritized backlog).
- 🙋‍♂️ CS Request — id `172c3469-3ee4-4920-a829-c21ce3942509` (intake).
- Label names carry emoji prefixes, so plain-text name filters return nothing — **filter by ID**.
- The 🔝 label spans many teams (Core FMS, Product, Onboarding, Reporting, Storefront, Communications, Revenue Mgmt) — don't team-filter when surveying it.

## Editor-lock (writing to Linear)

- `save_issue` **silently no-ops** if the issue is open in the Linear app editor.
- Re-fetch (`get_issue`) before each edit (users hand-edit between turns); after `save_issue`, confirm `updatedAt` advanced / the returned content reflects your change. If not, ask the user to close the editor, then re-push.
- Marking a duplicate: `save_issue duplicateOf <id>` creates the relation **and** auto-moves the issue into the team's Duplicate state (the relation must exist before the Duplicate state is allowed).

## Confirm before posting

- Draft → explicit user go-ahead → then Linear write / Slack send. "we can…" isn't authorization. Never auto-send a Slack message; confirm the channel first.
