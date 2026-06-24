# Plan: Cubby Linear skills — improvements & single-source consolidation

## Status

| Field | Value |
|---|---|
| Phase | Not yet broken down |
| State | Planning |
| Blocker | None |
| Last updated | 2026-06-24 |

## Goal

Harden the three Cubby Linear skills we used this session — `/ticket-writer`, `/cs-requests-update`, `/cs-requests-triage` — by folding in the lessons learned, and fix the distribution model so **`hzahariev/my-skills` is the single source of truth with zero drift** (`~/.claude/skills` symlinks into it; cubby is never written to). End state: all three skills are improved and consolidated in my-skills, and the same improvement can't silently diverge across copies again.

## Background — lessons → improvements (from this session)

- **Catch duplicates before speccing.** The Step 0 dup-scan caught CORE-442 (a dup of already-shipped ONB-224) and the CORE-607 cluster (4 dupes). → Keep/strengthen Step 0 in `ticket-writer`; it currently lives **only in `~/.claude`**, not my-skills.
- **Ground in code before writing scope.** Reuse-discovery (Payments `GridExportControls`, the `NotificationSetting.Type` framework) and enum-enumeration (`CubbyEvent.Type`, lien statuses) made specs precise and right-sized. → Make these explicit grounding patterns.
- **Notification conventions.** Default off / opt-in; never email/SMS without permission; in-app = PUSH; "notify when X due/eligible" uses a daily sweep like `TASKS_DUE_TODAY`. → Capture as a reusable reference.
- **Linear rendering gotchas.** Wide tables truncate and `${var}` tokens auto-link-mangle on editor re-open; transposed **Field → Value** tables render cleanly. → Add a format rule.
- **Editor-lock discipline.** `save_issue` silently no-ops if the issue is open in the app editor; re-fetch before each edit and verify the write landed. → Reinforce in the push section.
- **Confirm before posting.** Draft → explicit go-ahead → then push/send (Linear + Slack). → Keep as a hard rule in all three.
- **Distribution drift is real.** `ticket-writer` Step 0 is in `~/.claude` but not my-skills; `cs-requests-triage` is v3 in my-skills but v4 in cubby. Copies drift. → Symlink + single source of truth.

## Success Criteria

- [ ] **ticket-writer — Step 0 ported to my-skills:** `grep -c "Step 0" skills/ticket-writer/SKILL.md` ≥ 1 (currently 0).
- [ ] **ticket-writer — Linear rendering rule:** a format rule states "prefer transposed Field → Value tables for notification/multi-attribute specs" and notes the `${var}` auto-link mangle + wide-table truncation.
- [ ] **ticket-writer — grounding patterns:** the codebase-grounding step names the reuse-discovery and enumerate-the-enum patterns with the CORE-607 / CORE-746 reference cases.
- [ ] **ticket-writer — editor-lock:** push section includes re-fetch-before-edit + verify-after-write + the editor-reopen variable-mangle caveat.
- [ ] **Shared conventions reference exists** (notification defaults, in-app=PUSH, daily-sweep pattern, 🔝/🙋 label IDs, Linear table/variable gotchas, editor-lock) and the relevant skills cite or inline it.
- [ ] **cs-requests-triage at v4 parity in my-skills:** ported from cubby — `grep -c "Feasibility" skills/cs-requests-triage/SKILL.md` ≥ 1, conditional workspace (>5 tickets), dup-pool/bundling removed, ENG→CORE new-id gotcha noted; idempotency still dual-matches legacy `<!-- triage-cs-requests`.
- [ ] **cs-requests-update — diff-since-last-update:** the skill can compare current statuses against the previously posted update and lead with what changed; format rules retained (ID-first bullets, snapshot counts sum to N, confirm channel before sending).
- [ ] **No drift by construction:** `ls -la ~/.claude/skills/` shows the Cubby skills (`ticket-writer`, `cs-requests-triage`, `cs-requests-update`, `api-spec`, `release-grouping`, `release-testing`) as **symlinks (`->`)** into `my-skills/skills/`, not copies.
- [ ] **All SKILL.md parse:** each has valid frontmatter (`name`, `description`) and invokes under its name; `/cs-requests-triage` and `/cs-requests-update` resolve in a fresh session.
- [ ] **Shipped via my-skills only:** changes merged to `hzahariev/my-skills` `main` via PR; **zero** commits/edits to the cubby repo.

## Technical Constraints

- **`hzahariev/my-skills` is the only GitHub home and source of truth. Never commit, PR, or edit the cubby repo.** Reading cubby's v4 to port logic is allowed; writing to cubby is not.
- Ship via **feature branch → PR** (existing workflow; PRs #3/#5 precedent). PR #5 (`cs-requests-skills`) is already open with the rename + new skill — decide whether to extend it or branch fresh.
- Each skill stays a **single `SKILL.md`** with YAML frontmatter (`name`, `description`, `disable-model-invocation: true`). A shared reference must be either inlined or explicitly read by the skill (skills don't auto-load sibling files).
- **Preserve idempotency:** `cs-requests-triage`'s comment marker must keep dual-matching the legacy `<!-- triage-cs-requests` prefix so already-triaged tickets stay skipped.
- **Symlink convention already exists** (`portable-agent-skills` skills are symlinked into `~/.claude/skills`) — match it for the Cubby skills.
- Linear specifics to respect in any skill that writes specs: 🔝 CS Top Request label id `0efe4774-742f-4c5c-b7cf-9ea812608863`, 🙋 CS Request id `172c3469-3ee4-4920-a829-c21ce3942509`; emoji-prefixed label names don't match plain-text filters (use IDs).

## Non-Goals

- **No cubby repo changes** — no cubby PRs, no renaming/removing cubby's `triage-cs-requests` copy. (Hard.)
- Not rebuilding the triage workspace mechanism or the Linear MCP integration wholesale.
- Not modifying the `portable-agent-skills` skills (commit, cyw, plan-*, security-review-*, tdd, etc.).
- Not removing confirm-before-posting — skills must keep drafting and waiting for explicit go-ahead before Linear writes / Slack sends.
- Not adding net-new skills beyond the three in scope.
- Not auto-merging PRs to `main` — leave the merge to the user.

## Affected Areas

**Will change** _(all under `/Users/hzahariev/Documents/my-skills`)_:
- `skills/ticket-writer/SKILL.md` — port Step 0 from `~/.claude`; add Linear-rendering format rule, grounding patterns, editor-lock notes.
- `skills/cs-requests-triage/SKILL.md` — bring to v4 parity (feasibility probe, conditional workspace, dup-pool/bundling removal) while keeping the dual-marker idempotency from the rename.
- `skills/cs-requests-update/SKILL.md` — add diff-since-last-update; tighten format rules.
- `references/cubby-linear-conventions.md` _(new, or inline per skill)_ — notification defaults, label IDs, table/variable gotchas, editor-lock, confirm-before-posting.

**Must stay consistent:**
- `~/.claude/skills/{ticket-writer,cs-requests-triage,cs-requests-update,api-spec,release-grouping,release-testing}` — convert copies → symlinks into `my-skills/skills/` (one-time migration; the fix that prevents future drift).
- `cs-requests-triage` idempotency marker contract (dual-match legacy + new).

**Source of improvement (read-only — do NOT modify):**
- `cubby/.claude/skills/triage-cs-requests/SKILL.md` (v4) — port the feasibility/workspace logic FROM here INTO my-skills.

**Tests / verification** _(no unit tests for skills — verify by grep + a smoke invocation in a fresh session)_:
- `grep` checks per success criteria (Step 0 present, Feasibility present, marker dual-match), `ls -la ~/.claude/skills` for symlinks, and `/cs-requests-triage` + `/cs-requests-update` resolving after reload.

---

_Phases: not yet broken down — run /plan-phase to generate phase documents._
