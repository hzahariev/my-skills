---
name: release-changelog
description: Assemble a Notion changelog entry for a release. Pulls changelog summaries from QA comments on GitHub PRs, classifies items as public/internal, and updates the Notion changelog page. Use when user says "create the changelog", "write the release notes", or "release-changelog".
---

# Release Changelog

Assemble a Notion changelog entry from PR comments posted by the `test-feature` skill (formerly `release-testing`). Classify items, draft the changelog, and update the Notion page with user approval.

## Arguments

Parse arguments after the skill name:

- **PR list**: Comma-separated PR numbers (e.g., `7502, 7503, 7504`)
- **Changelog page URL**: A Notion page URL for the target changelog entry
- If no arguments, ask: "Which PRs and which changelog page?"

---

## Step 1 — Gather changelog summaries from PRs

### 1a. Fetch PR comments from GitHub

For each PR number, fetch comments to find the QA results:

```bash
gh pr view <number> --repo cubbystorage/cubby --json comments --jq '.comments[] | select(.body | contains("Product Review / QA Test Results")) | .body'
```

Extract the **Changelog summary** line from each QA comment. This was drafted during QA testing and describes the change in operator-facing language.

If a PR has no QA comment, fetch the PR description instead and draft a changelog summary from it:

```bash
gh pr view <number> --repo cubbystorage/cubby --json title,body
```

### 1b. Fetch previous changelogs for tone/style

Fetch the Notion changelog database and read the 2 most recent published entries to calibrate tone:

- **Changelog database**: `https://www.notion.so/31fdc4651f0c80f9aef8f99f0724527a`
- Note the format: New ✨ / Improvements 🔨 / Fixes 🦂 / Internal only
- Note the tone: operator-facing language, not developer language
- Note fix format: "Fixed an issue where **bold area**..." — one line each

---

## Step 2 — Classify each PR

### 2a. Propose categories

For each PR, propose a category based on the PR title and changelog summary:

| Category | Criteria |
|---|---|
| **New ✨** | Entirely new feature or capability |
| **Improvement 🔨** | Enhancement to an existing feature |
| **Fix 🦂** | Bug fix |
| **Internal only** | Early-access features, technical changes not worth announcing, or items the user wants to keep internal |

### 2b. Ask the user for classification decisions

Present a table of all PRs with proposed categories and ask:

1. **Which PRs are public vs. internal/early-access?** (e.g., "workflows are early access, keep internal")
2. **Any category changes?** (e.g., "move #7502 from Improvement to Fix")
3. **Any PRs to exclude entirely?**

Wait for answers before proceeding. Do NOT write to Notion until the user confirms.

---

## Step 3 — Draft the changelog

### 3a. Group items by category

Using the confirmed classifications, group the changelog summaries:

```
**New ✨**
<items, if any>

**Improvements 🔨**
<items>

**Fixes 🦂**
<items>

**Internal only**
<items>

**In-app banner:** "<~10 word summary of highlights>"
```

### 3b. Present ONLY the RC batch items

Show the user only the items from this batch — not existing content on the page. This is what they need to review and approve.

Ask: "Does this look right? Any changes before I update the Notion page?"

Wait for confirmation.

---

## Step 4 — Update the Notion page

### 4a. Fetch existing page content

Fetch the target changelog page using the Notion MCP tool (`notion-fetch` with the page URL or ID). Note what content already exists — other teams may have added entries.

### 4b. Merge content

Using the Notion MCP tool (`notion-update-page` with `update_content`):

1. **Preserve existing content** — Do not overwrite entries from other PRs not in this RC batch.
2. **Keep placeholder entries** if they exist for other teams to fill in (e.g., "Title. Text text.").
3. **Add RC items** alongside existing content in each section.
4. **Internal only items** go as bullet points with PR number references under the italic preamble: `*The following things are part of this release, but aren't worth announcing externally.*`

### 4c. Set properties

Using `notion-update-page` with `update_properties`:

- **In-app banner**: Set to the ~10 word summary
- **Do NOT set Published to true** — always leave unpublished until the user explicitly says to publish

---

## Step 5 — Verify and report

### 5a. Fetch the updated page

Re-fetch the Notion page to confirm the updates applied correctly.

### 5b. Print summary

```
## Changelog Updated — <release name>

**Page:** <Notion URL>
**Status:** Unpublished (pending approval)
**In-app banner:** "<banner text>"

**Items added:**
- New: X items
- Improvements: Y items
- Fixes: Z items
- Internal: W items

To publish, say "publish the changelog" and I'll set Published to true.
```

---

## Step 6 — Publish (on explicit request only)

Only when the user explicitly says to publish:

```
Using notion-update-page with update_properties:
- Published: __YES__
```

Confirm: "Changelog published at <Notion URL>."

---

## Reference

### Changelog format
- **New ✨:** Bold title + 1-2 operator-facing sentences
- **Improvements 🔨:** Bold title + 1-2 operator-facing sentences
- **Fixes 🦂:** "Fixed an issue where **area** ..." — one line each
- **Internal only:** Italic preamble + bullet points with PR refs
- **In-app banner:** ~5-10 words summarizing highlights

### Changelog tone
- Audience: facility managers / operators
- Use: "you can now...", "Cubby now...", "Facility managers can now..."
- Never use developer jargon (cache invalidation, refetch, prefetch, etc.)
- Describe the value, not the implementation

### Notion changelog database
- **Parent:** `https://www.notion.so/31fdc4651f0c80f9aef8f99f0724527a`
- **Properties:** Name, Release Date, In-app banner, Published, Author, Intercom article link
