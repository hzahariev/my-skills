# Phase 6: Distribution — Symlink ~/.claude → my-skills

_Status: pending_

## Goal

Kill skill drift at the root: replace the Cubby-skill **copies** in `~/.claude/skills` with **symlinks** into `my-skills/skills/`, so local always mirrors the repo (the fix for the two drifts we hit — ticket-writer Step 0 and cs-requests-triage v3/v4).

## Entry Criteria

- [ ] Phase 5 PR **merged to `main`** on `hzahariev/my-skills`.
- [ ] `my-skills` local checkout is on `main` and up to date (`git pull`), so symlinks resolve to the merged content.

## Tasks

- [ ] Confirm `/Users/hzahariev/Documents/my-skills` is on `main` with the improvements merged.
- [ ] For each Cubby skill — `ticket-writer`, `cs-requests-triage`, `cs-requests-update`, `api-spec`, `release-grouping`, `release-testing` — remove the `~/.claude/skills/<skill>` copy and create a symlink → `/Users/hzahariev/Documents/my-skills/skills/<skill>` (matching the existing `portable-agent-skills` symlink convention).
- [ ] Leave the `portable-agent-skills` symlinks untouched.
- [ ] Do **not** touch the cubby repo's `.claude/skills`.

## Tests

_No unit tests — `ls`/readlink checks + a fresh-session smoke invocation._

- [ ] Each Cubby skill in `~/.claude/skills` is a symlink into `my-skills/skills/`.

## Verification

```bash
ls -la /Users/hzahariev/.claude/skills/ | grep -E "ticket-writer|cs-requests-triage|cs-requests-update|api-spec|release-"
# each should show '-> /Users/hzahariev/Documents/my-skills/skills/<skill>'
readlink /Users/hzahariev/.claude/skills/cs-requests-triage
cat /Users/hzahariev/.claude/skills/ticket-writer/SKILL.md | head -2   # resolves through symlink
```

Also verify manually:
- In a **fresh session**, `/cs-requests-triage` and `/cs-requests-update` resolve and load.
- Editing `my-skills/skills/<skill>/SKILL.md` is immediately reflected in `~/.claude` (no copy step).

## Exit Criteria

- [ ] Every task checked off
- [ ] All six Cubby skills are symlinks into `my-skills/skills/`; zero copies remain
- [ ] Skills resolve through the symlinks in a fresh session
- [ ] cubby repo untouched
- [ ] phases.md phase checkbox updated to `[x]`

## Commit

```
(local filesystem migration — no my-skills commit; note completion in phases.md)
```
