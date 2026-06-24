# Phase 3: cs-requests-triage → v4 Parity

_Status: pending_

## Goal

Bring the my-skills `cs-requests-triage` skill (currently v3) up to cubby's **v4** logic — feasibility probe, conditional workspace, duplicate-detection removed — while keeping the rename and idempotency we just shipped. Source is read-only; all writes land in my-skills.

## Entry Criteria

- [ ] Phase 1 committed.
- [ ] Read-only access to `cubby/.claude/skills/triage-cs-requests/SKILL.md` (v4).

## Tasks

- [ ] Read `cubby/.claude/skills/triage-cs-requests/SKILL.md` (v4) and capture the v4 deltas: Step 2a **codebase feasibility probe** (read-only Explore subagent), **Feasibility verdict** field + summary column, **conditional workspace** (>5 tickets → `.triage-runs/`; ≤5 in context), removal of cross-team pool / duplicate-detection / project-bundling, and the **ENG→CORE new-id gotcha** (after a team move `save_issue` returns a new identifier).
- [ ] Update `skills/cs-requests-triage/SKILL.md` to the v4 content, **preserving**: `name: cs-requests-triage`; the dual-marker idempotency (scan matches `<!-- cs-requests-triage` OR legacy `<!-- triage-cs-requests`); footer → `/cs-requests-triage skill (v4)`.
- [ ] Cite `references/cubby-linear-conventions.md` for shared conventions (label IDs, editor-lock, confirm-before-posting) instead of restating them.

## Tests

_No unit tests — grep checks. Behaviour is ported from a known-good v4; verify parity + preserved invariants._

- [ ] `grep -c "Feasibility" skills/cs-requests-triage/SKILL.md` ≥ 1
- [ ] Legacy marker retained for idempotency.

## Verification

```bash
cd /Users/hzahariev/Documents/my-skills
grep -c "Feasibility" skills/cs-requests-triage/SKILL.md          # >= 1
grep -c "triage-cs-requests" skills/cs-requests-triage/SKILL.md   # >= 1 (legacy dual-match)
grep -m1 "^name:" skills/cs-requests-triage/SKILL.md              # name: cs-requests-triage
grep -c "v4" skills/cs-requests-triage/SKILL.md                   # footer/version bumped
```

Also verify manually:
- The dual-marker scan instruction still matches both prefixes.
- No cross-team-pool / duplicate-detection / project-bundling steps remain (removed in v4).

## Exit Criteria

- [ ] Every task checked off
- [ ] Feasibility probe present; conditional-workspace logic present; v3 dup-detection/pool/bundling removed
- [ ] `name: cs-requests-triage` + dual-marker idempotency preserved; footer says v4
- [ ] Run `cyw` (or manual diff review) — zero issues
- [ ] phases.md phase checkbox updated to `[x]`

## Commit

```
cs-requests-triage: port v4 (feasibility probe, conditional workspace)
```
