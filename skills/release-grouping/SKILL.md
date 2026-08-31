---
name: release-grouping
description: Group a release candidate's PR list under team leads for the RC Slack thread. Parses the RC announcement PR list, resolves each PR's author from GitHub, maps authors to their Linear team, and buckets the PRs under each team lead in the format used every release. Use when the user says "group the rc", "group the release by team", "who owns which PR", "split the RC for QA", or "release-grouping".
---

# Release Grouping

Turn a flat release-candidate PR list into a Slack post grouped by **team lead**, matching
the format the team uses every release (each lead is a header; their team's PRs are bullets
underneath). This is how QA ownership gets divided when an RC is announced — it usually runs
right after the RC-deployed message and before `test-feature`.

> This skill is the **standalone grouping logic** (parse → authors → teams → leads), for ad-hoc
> "group this RC for me" requests. The **automated** Tue/Fri watcher — detect the RC, create the
> Notion changelog shell, and post the canonical **two-part threaded** breakdown to
> #release-notes-coordination — lives in the `release-rc-watcher` skill, which is the source of
> truth for both the cloud and local routines. Keep the lead map + gotchas below in step with it.

Always show a draft and get approval before posting anything to Slack.

## Arguments

Parse arguments after the skill name:

- **RC announcement** — a Slack message/link (channel `#eng-releases`, i.e. `C03MVKKSB8B`)
  whose body has the full PR list in a code block, one PR per line ending in `(#NNNN)`.
- **Previous grouped message** — a link to a prior release's grouped reply (the one that
  bucketed PRs under people). Used for the format AND to learn who each team's lead is.
- If either is missing, ask for it.

---

## Step 1 — Parse the PR list

Read the RC announcement (use the Slack read tools — `slack_read_thread` with the message
`ts`). Extract every `#NNNN` from the code block. **Count them and keep the total** — every
PR must appear exactly once in the final output (coverage check in Step 6).

---

## Step 2 — Get each PR's author from GitHub

Loop over every PR number:

```bash
for n in <numbers>; do
  gh pr view $n --repo cubbystorage/cubby --json number,author \
    --jq '"\(.number)|\(.author.login)|\(.author.name // "")"' 2>/dev/null
done
```

`app/dependabot` = bot (no human owner) — it goes in the Platform "bumps" group.

---

## Step 3 — Map each author to a Linear team

Use the Linear MCP tools: `list_teams`, then `list_users` with a `team` filter for each
engineering team (Core FMS, Communications, Platform, Storefront, Revenue Management, AI,
Reporting, Onboarding, Corp).

⚠️ **Filter out org-wide people.** A handful of admins / PMs / founders appear in **every**
team's member list (they are not that team's engineers). Ignore them when placing authors —
an author's real team is the one where they appear and most of those org-wide names don't.
Place each author on the single team where they are a team-specific member.

---

## Step 4 — Identify each team's lead

Linear has **no "team lead" field**, so do NOT expect to read it from Linear:

1. Take each lead from the **previous grouped message** — whoever headed that bucket last
   time is the source of truth for who owns the area.
2. If a team has PRs this release but wasn't in the prior message, **ask the user** — do not
   guess a lead.
3. **Some teams roll up under another team's lead** rather than getting their own header —
   nest their PRs as a sub-group under that lead and cc the person who did the work.

Known leads (as of Aug 2026 — re-confirm periodically; they can change):
- Core FMS → **Itso / Hristo Zahariev**
- Communications → **mitko** (`U06JXJQAMHQ`)
- Storefront → **Jan Früchtl** (no Slack ID → write "Jan" as plain text)
- Onboarding / Import → **James Baumeister** (cc Hanna, Evgeni Jechev)
- AI → **Declan Starrett**
- Revenue Management → **James Randall** — its OWN section (took over from Declan Starrett on 2026-07-23), cc the RevMan authors (e.g. David Starr, Hunter Buckhorn)
- Reporting → **Vladimir Mladenov**
- Corp → **Jason Maytin** (n/a — no changelog owner)
- Platform / DevX / API / bumps / tests → **Ivan Anev** (header is just `` `Platform - n/a` ``, do NOT @mention him)

---

## Step 5 — Bucket the PRs

Group PRs as bullets under each lead. **Default rule: a PR goes under its author's team lead.**

Overrides (author wins over subject, no ⚠️):
- **Evgeni Jechev** or **Hanna Matveyeva** → Onboarding / Import regardless of subject. Does NOT
  apply to **Hannah Groves** (RevMan — see Gotchas).
- **Christo Dimitrov** (EM, authors across many teams) → bucket HIS PRs by subject / ticket prefix
  (`[CORE-…]`→Core FMS, `[REPORT-…]`→Reporting, `[COMMS-…]`→Communications); don't flag him.

Then:
- If a PR's subject area clearly differs from the author's team (e.g. a `[REPORT-*]` fix
  written by an AI-team dev), keep it under the author's team but mark it **⚠️** so the user
  can decide.
- Group all infra / DevX / deploy / terraform / dependency-bump / test PRs under the **Platform**
  lead (sub-grouped `API/BQ` · `DevX / infra` · `TESTS` · `bumps`), even when authored by a
  product-team engineer.

---

## Step 6 — Draft, confirm, then post

Show the user a draft:
- **Bold lead name (team)** as each header.
- PRs bulleted underneath, with the **author in italics in parens** so the mapping is
  verifiable (offer to strip authors for the final post).
- A short list of the ⚠️ subject-area mismatches and any leads you had to ask about.

**Coverage check before showing:** re-count the bulleted PRs — the number must equal the
total from Step 1. Report it (e.g. "41/41 placed").

Wait for the user's OK. Only then, if asked, convert the lead names to Slack **@mentions**
and post as a **reply in the RC thread** (`slack_send_message` with `thread_ts`). Posting to
Slack is sending on the user's behalf — confirm first.

---

## Gotchas

- **Name collisions — keep these distinct:**
  - "Christo Dimitrov" (engineer, `christo@`, GitHub `cerebraldeath`) is **NOT** "Hristo /
    Itso Zahariev" (PM, `hristo.zahariev@`).
  - GitHub `dbstarr` = **David Starr** (Revenue Management) is **NOT** Declan Starrett (AI).
  - GitHub `hsgroves` = **Hannah Groves** (Revenue Management) is **NOT** Hanna Matveyeva
    (Onboarding) — the Evgeni/Hanna→Onboarding override applies only to Hanna Matveyeva.
- **Bots:** Dependabot PRs → Platform "bumps", no person attached.
- **Coverage:** never show a draft whose PR count doesn't match Step 1's total — a missing or
  duplicated PR is the most common error here.

---

## Reference

- **GitHub repo:** `cubbystorage/cubby`
- **Releases channel:** `#eng-releases` (`C03MVKKSB8B`) — RC announcements + grouped QA replies
- **Linear teams:** Core FMS, Communications, Platform, Storefront, Revenue Management, AI,
  Reporting, Onboarding, Corp (plus non-eng: Product, Design, Accounting, Access Control Support)
- **Pairs with:** `release-rc-watcher` (the automated detect→group→post routine) · `test-feature`
  (QA the PRs you own) → `release-changelog` (write the notes).
