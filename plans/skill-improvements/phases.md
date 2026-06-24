# Phases: Cubby Linear skills — improvements & single-source consolidation

_Execution tracker for [`plan.md`](./plan.md)_

## Status

| Field | Value |
|---|---|
| Phase | Phase 2 of 6 — ticket-writer Enhancements |
| State | Executing |
| Blocker | None |
| Last updated | 2026-06-24 |

## Phases

- [x] [Phase 1: Shared Conventions Reference](./phase-01-shared-conventions-reference.md)
- [ ] [Phase 2: ticket-writer Enhancements](./phase-02-ticket-writer-enhancements.md)
- [ ] [Phase 3: cs-requests-triage → v4 Parity](./phase-03-cs-requests-triage-v4-parity.md)
- [ ] [Phase 4: cs-requests-update Enhancements](./phase-04-cs-requests-update-enhancements.md)
- [ ] [Phase 5: Verification Gate + PR](./phase-05-verification-and-pr.md)
- [ ] [Phase 6: Distribution — Symlink ~/.claude → my-skills](./phase-06-distribution-symlinks.md)

## Notes

- **Hard constraint:** all changes land in `hzahariev/my-skills` (+ `~/.claude`). **Never** the cubby repo (cubby's v4 is read-only source-of-improvement for Phase 3).
- **Manual gate between Phase 5 and 6:** the user merges the PR to `main` before the symlink migration runs.
- Phases 2/3/4 are independent (any order after Phase 1); listed in this order for review convenience.
- **Branch:** extending `cs-requests-skills` (PR #5) — the improvements depend on the rename, which lives on that branch, not `main`.
