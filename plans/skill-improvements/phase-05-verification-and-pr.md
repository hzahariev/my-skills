# Phase 5: Verification Gate + PR

_Status: pending_

## Goal

Prove the plan's success criteria across all three skills + the reference, and get the change review-ready on `hzahariev/my-skills`. No cubby changes.

## Entry Criteria

- [ ] Phases 1–4 committed on the working branch.

## Tasks

- [ ] Run every success-criteria check from `plan.md` (greps below) and confirm each passes.
- [ ] Validate each `SKILL.md` frontmatter parses and has `name` + `description` (and `disable-model-invocation: true` where intended).
- [ ] Run the `cyw` skill across the full branch diff — resolve any findings.
- [ ] Push the branch; open or update the PR on `hzahariev/my-skills`; write a summary mapping each change to its lesson.
- [ ] Hand off to the user to merge to `main` (auto-merge is a non-goal).

## Tests

_Aggregate verification of all prior phases — greps + frontmatter validation + cyw._

- [ ] All success-criteria greps pass.

## Verification

```bash
cd /Users/hzahariev/Documents/my-skills
grep -c "Step 0" skills/ticket-writer/SKILL.md            # >= 1
grep -c "Feasibility" skills/cs-requests-triage/SKILL.md  # >= 1
grep -c "triage-cs-requests" skills/cs-requests-triage/SKILL.md   # >= 1 (legacy marker)
grep -ci "since\|changed" skills/cs-requests-update/SKILL.md       # >= 1
ls references/cubby-linear-conventions.md
for f in skills/*/SKILL.md; do echo "== $f =="; head -4 "$f"; done   # frontmatter sane
gh pr view --json url,state,title 2>&1 || true
```

Also verify manually:
- Rendered tables (Field → Value) look clean in the Linear/markdown preview.
- No cubby repo files were touched (`git -C "/Users/hzahariev/Documents/cubby work docs/cubby" status` clean of skill edits).

## Exit Criteria

- [ ] Every task checked off
- [ ] All success-criteria greps pass; every frontmatter valid
- [ ] `cyw` finds zero issues
- [ ] PR is green and ready for review on `hzahariev/my-skills`; zero cubby changes
- [ ] **User merges the PR to `main`** (gate before Phase 6)
- [ ] phases.md phase checkbox updated to `[x]`

## Commit

```
(PR-level — no new file; ensure branch pushed and PR ready)
```
