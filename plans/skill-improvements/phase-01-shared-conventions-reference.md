# Phase 1: Shared Conventions Reference

_Status: complete_

## Goal

Create one reference doc (`references/cubby-linear-conventions.md`) capturing the cross-cutting Cubby/Linear conventions, so all three skills cite a single source instead of duplicating (or drifting on) them.

## Entry Criteria

- [x] This is the first phase.
- [x] Branch decision made: extend the existing PR #5 branch (`cs-requests-skills`) **or** open a fresh branch off `origin/main`. (Recommend a fresh branch off `main` once #5 merges, to keep the rename and the improvements as separate PRs.)

## Tasks

- [x] Create `references/cubby-linear-conventions.md` with sections:
  - **Notifications** — default off / opt-in; never email/SMS without permission; in-app on only for low-volume; all-off for high-volume/bursty; in-app = the `PUSH` channel; "notify when X due/eligible" with no event hook → daily sweep like `TASKS_DUE_TODAY`; framework = `NotificationSetting.Type` + `NotificationService.triggerLeaseNotification`.
  - **Linear rendering** — prefer transposed **Field → Value** tables for notification/multi-attribute specs; wide tables truncate; `${var}` tokens auto-link-mangle on editor re-open; use backtick/code form if stability matters.
  - **Label IDs** — 🔝 CS Top Request `0efe4774-742f-4c5c-b7cf-9ea812608863`, 🙋 CS Request `172c3469-3ee4-4920-a829-c21ce3942509`; emoji-prefixed names don't match plain-text filters — filter by ID.
  - **Editor-lock** — re-fetch (`get_issue`) before each edit; after `save_issue`, confirm `updatedAt` advanced (silent no-op if the issue is open in the app editor); reopen-mangle caveat.
  - **Confirm before posting** — draft → explicit go-ahead → then Linear write / Slack send.
- [x] At the top of the reference, document the **cite-vs-inline mechanism**: skills instruct the model to `Read references/cubby-linear-conventions.md` at the relevant step (skills don't auto-load sibling files).

## Tests

_No unit tests for skill docs — verification is grep/ls. No new behaviour to TDD._

- [x] `references/cubby-linear-conventions.md` exists with all five sections.

## Verification

```bash
cd /Users/hzahariev/Documents/my-skills
ls references/cubby-linear-conventions.md
grep -ci "opt-in\|Field → Value\|0efe4774\|editor\|confirm" references/cubby-linear-conventions.md
```

Also verify manually:
- Each section is concrete enough that a skill citing it needs no extra context.

## Exit Criteria

- [x] Every task above is checked off
- [x] The reference file exists with all five sections
- [x] Cite-vs-inline mechanism is documented
- [x] Run `cyw` (or manual diff review) — zero issues
- [x] phases.md phase checkbox updated to `[x]`

## Commit

```
Add cubby-linear-conventions shared reference
```
