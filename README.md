# my-skills

Personal Claude Code skills by Hristo Zahariev.

## Skills

| Skill | Description |
|-------|-------------|
| [api-spec](skills/api-spec/SKILL.md) | Turn an API enrichment request into a researched, scoped Linear ticket — researches the current API + data model, identifies the gap, drafts the ticket with variable tables, and preps tracker rows. |
| [cs-requests-triage](skills/cs-requests-triage/SKILL.md) | Batch-groom the CS Request backlog from Linear — fetch, analyze, label, size, and organize tickets with automated triage comments. |
| [cs-requests-update](skills/cs-requests-update/SKILL.md) | Draft a CS-leadership status update on the 🔝 CS Top Request backlog — pull statuses across teams, group by lifecycle, highlight what moved, and format it as a ready-to-send Slack message. |
| [release-grouping](skills/release-grouping/SKILL.md) | Group a release candidate's PR list under team leads for the RC Slack thread — resolve each PR's author and map them to their Linear team. |
| [release-testing](skills/release-testing/SKILL.md) | QA-test release candidate PRs on staging against their acceptance criteria, then post structured results to the GitHub PRs and Linear tickets. |
| [ticket-writer](skills/ticket-writer/SKILL.md) | Write well-defined Linear engineering issues in a structured spec format — create, spec (structure an existing ticket), or refine. |

## Usage

Install a skill into your Claude Code project:

```bash
claude install-skill https://github.com/hzahariev/my-skills/tree/main/skills/cs-requests-triage
```

Or copy the `SKILL.md` file into your project's `.claude/skills/<skill-name>/` directory.
