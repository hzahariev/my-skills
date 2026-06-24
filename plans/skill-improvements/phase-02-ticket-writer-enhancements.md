# Phase 2: ticket-writer Enhancements

_Status: pending_

## Goal

Bring my-skills `ticket-writer` to its best state: recover the Step 0 duplicate-scan that currently lives only in `~/.claude`, and add the Linear-rendering, grounding, and editor-lock lessons from this session.

## Entry Criteria

- [ ] Phase 1 committed (the shared reference exists to cite).
- [ ] `~/.claude/skills/ticket-writer/SKILL.md` available as the source of the local-only Step 0 block.

## Tasks

- [ ] Diff `~/.claude/skills/ticket-writer/SKILL.md` against `skills/ticket-writer/SKILL.md` to isolate the local-only **Step 0 — Duplicate scan** block (and any other local-only edits); port it into the my-skills copy.
- [ ] Add a **Linear rendering** format rule: prefer transposed **Field → Value** tables for notification/multi-attribute specs; note `${var}` mangle + wide-table truncation. Cite the reference.
- [ ] Strengthen the **codebase-grounding** step with two named patterns: *reuse-discovery* (find the existing component/endpoint to reuse — e.g. `GridExportControls`, `NotificationSetting.Type`) and *enumerate-the-enum* (list the real enum/event-type set — e.g. `CubbyEvent.Type`). Add CORE-607 / CORE-746 as reference cases.
- [ ] Add **editor-lock** guidance to the push section: re-fetch before each edit, verify `updatedAt` advanced after `save_issue`. Cite the reference.
- [ ] Add a one-line pointer instructing the model to read `references/cubby-linear-conventions.md`.

## Tests

_No unit tests — grep checks. The Step 0 port is recovering existing behaviour, not new logic._

- [ ] `grep -c "Step 0" skills/ticket-writer/SKILL.md` ≥ 1
- [ ] Format rule + grounding patterns present.

## Verification

```bash
cd /Users/hzahariev/Documents/my-skills
grep -c "Step 0" skills/ticket-writer/SKILL.md
grep -ci "Field → Value\|reuse\|enumerate\|editor" skills/ticket-writer/SKILL.md
head -5 skills/ticket-writer/SKILL.md   # frontmatter intact (name: ticket-writer)
```

Also verify manually:
- Step 0 reads coherently in context (not a duplicated/orphaned block).

## Exit Criteria

- [ ] Every task checked off
- [ ] `grep -c "Step 0"` ≥ 1; format rule + grounding patterns + editor-lock present
- [ ] Frontmatter unchanged (`name: ticket-writer`)
- [ ] No previously-present guidance accidentally dropped
- [ ] Run `cyw` (or manual diff review) — zero issues
- [ ] phases.md phase checkbox updated to `[x]`

## Commit

```
ticket-writer: add Step 0 dup-scan, Linear format + grounding rules
```
