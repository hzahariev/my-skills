# Phase 4: cs-requests-update Enhancements

_Status: pending_

## Goal

Make `/cs-requests-update` lead with what actually **changed** since the last update, and lock in the format rules we converged on this session.

## Entry Criteria

- [ ] Phase 1 committed (reference exists to cite).

## Tasks

- [ ] Add a **diff-since-last-update** step: before drafting, locate the previous posted update (search the target Slack channel for the last "🔝 CS Top Requests — where things stand" message; fall back to a stored snapshot if present) and compute deltas — newly shipped, status moves, newly added, and closed/dup'd since then. Lead the message with "What changed since {date}".
- [ ] Reaffirm format rules: every bullet starts with `[TICKET-ID]`; one ticket per bullet; the 📊 snapshot counts must sum to N; confirm the channel before sending.
- [ ] Note the subagent-digest approach for large (30+) backlogs to keep context clean.
- [ ] Cite `references/cubby-linear-conventions.md` (label IDs, confirm-before-posting) instead of restating.

## Tests

_No unit tests — grep checks. New behaviour is a doc/workflow step, not code._

- [ ] Diff step present; format rules present.

## Verification

```bash
cd /Users/hzahariev/Documents/my-skills
grep -ci "since\|changed\|diff\|delta" skills/cs-requests-update/SKILL.md
grep -ci "TICKET-ID\|snapshot\|confirm" skills/cs-requests-update/SKILL.md
head -5 skills/cs-requests-update/SKILL.md   # frontmatter (name: cs-requests-update)
```

Also verify manually:
- The diff step has a sensible fallback when no prior update is found (first-run behaviour).

## Exit Criteria

- [ ] Every task checked off
- [ ] Diff-since-last-update step present with a first-run fallback
- [ ] Format rules retained; reference cited
- [ ] Run `cyw` (or manual diff review) — zero issues
- [ ] phases.md phase checkbox updated to `[x]`

## Commit

```
cs-requests-update: add diff-since-last-update; tighten format
```
