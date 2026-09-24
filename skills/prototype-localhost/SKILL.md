---
name: prototype-localhost
description: Build a throwaway front-end prototype of a product concept inside the Cubby manager app and run it locally against the staging API, for G1 product approval or cross-team alignment. Starts with a short questionnaire, saves any WIP on its own branch, cuts a fresh branch from origin/master, wires the concept into the real screens with a localStorage-backed store, lints, and serves it at localhost:3000 for a click-through. Use when Hristo says "build a prototype", "prototype this", "mock it up in the app", "let's build it locally", or invokes /prototype-localhost. NOT for production code or PRs — the cubby remote is read-only.
---

# prototype-localhost

Turn an agreed concept into something Hristo can click through in the real Cubby manager app within a session — good enough to get G1 product approval or align design/eng/CS, never meant to ship.

**Principles**
- **Throwaway, but in the real app.** Real components, real screens, real staging data; fake persistence (`localStorage`), no backend changes, no new API calls.
- **Demo moments first.** Build the 3–6 clicks that carry the story; skip everything that doesn't appear in the demo.
- **Minimal, reversible patches.** Anchored replacements into existing files, one new folder for the concept, `// PROTOTYPE ONLY` on every new file. Never restyle or refactor along the way.
- **Fast feedback over proof.** Lint and format always; the full TypeScript check only if Hristo says yes (see Step 0, Q9).
- **Never push, never type credentials.** The cubby remote is read-only for this account; Hristo logs into staging himself.

Reference builds: **Do not rent list** (CORE-773, Sep 2026 — badge/banner/dialog, list icons + filters, rental-flow block, lease-config tab, move-out checkbox, activity-log entries) and **S700 POS devices** (device grid, pairing flow, "pay via card reader"; parked on `prototype/s700-device-management`).

---

## Step 0 — Questionnaire (before touching code)

Ask only what the conversation, the Linear ticket or the concept doc hasn't already answered. Present it as one checklist with a recommended default per item so Hristo can answer in a single reply.

1. **Goal & audience** — G1 approval, cross-team alignment, or a customer demo? Who watches (Jan/Declan/Jamie/Joro/CS/customer)? This sets fidelity and wording.
2. **The story** — the 3–6 demo moments in order ("mark a customer → see the banner → try to rent them → get refused"). These become the build checklist and the hand-off script.
3. **Surfaces in / out** — which pages, dialogs, lists, settings tabs are touched; what is explicitly *not* prototyped (backend behaviour, server-side filtering, storefront/API side, other apps).
4. **Source of truth** — ticket / concept doc / Figma links; decided points to respect verbatim (names, defaults, copy); open questions to leave visibly open.
5. **Data** — staging API (default) vs full local stack (needs Java 25 + MySQL + Postgres — usually not available); which staging org/facility to demo on; any records to pre-seed in the prototype store.
6. **Fidelity** — reuse existing components as-is (default) vs bespoke visuals; final copy vs placeholders.
7. **Branch & state** — commit current uncommitted work onto its own `prototype/<topic>` branch first (default yes if `git status` is dirty); prototype branch name = Linear's `gitBranchName`; keep the prototype uncommitted or commit locally at the end.
8. **Hand-off** — running localhost + click-through script (default); screenshots/supercut; a Linear comment on the ticket.
9. **Typecheck — YES or NO?** Always ask, with this framing: *"The full `tsc` check over the manager app takes ~10 minutes per run (it can hang for 20+ when the dev server is competing for CPU) and noticeably slows the machine while it runs. Lint and format take seconds and always run. For a throwaway prototype the default is **NO** — the app runs without it and hot-reload surfaces runtime errors. Run it? YES / NO"*. Respect the answer for the whole session; re-ask only if the scope grows into shared package code.

Reflect the answers back as the build checklist, then go.

## Step 1 — Branch prep (local only)

Repo: `/Users/hzahariev/Documents/cubby work docs/cubby` (path has spaces — quote it). Remote is read-only: **never push, never open PRs**.

```bash
cd "/Users/hzahariev/Documents/cubby work docs/cubby"
git fetch origin master && git status --short | grep -v '^??'      # tracked WIP?
# WIP present → park it on its own branch so master stays clean:
git checkout -b prototype/<topic> && git add <the WIP paths> && git commit -m "WIP: <topic> prototype (local only)"
# fresh prototype branch from the tip of master:
git checkout -b <linear gitBranchName> origin/master
```
Untracked leftovers from older prototypes stay in the working tree; Vite may warn about one importing a module that only exists on another branch — harmless, mention it once.

## Step 2 — Map the surfaces (grep first, read slices)

Use Bash `grep -n` / `sed -n` for the exact hook points; read 20–40-line slices, not whole files. Catalogue before writing:

| Need | Where |
|---|---|
| Customer header badges + *Customer actions* menu | `pages/CustomerPage/components/CustomerContent.tsx` (`titleContent`, `moreActions`) |
| Profile banners | `pages/CustomerPage/pages/OverviewPage/OverviewPage.tsx`; lead drawer `components/interests/InterestDrawer.tsx` |
| Warning-banner template | `OverviewPage/components/LienProcessBanner.tsx` (`<Banner title tone="warning">`) |
| Dialog + form template | `pages/CollectionsPage/components/DelinquencyExemptionDialog.tsx` (`Dialog`, `useForm`+yup, `Select`, `TextInput`, `secondaryAction`) |
| List cells | Leads `pages/InterestsPage/InterestsPage.tsx` (`contactName` cell, "Existing tenant" icon); Rentals `pages/RentalsPage/utils/useRentalsDataGrid.tsx`; Collections/Lien `pages/*/hooks/useGridColumns.tsx` |
| Filters menu entries | hidden columns: `filterable: true, hidden: true, filterName, filterLabel, type: 'boolean', valueOptions` |
| New-rental / lead flow | `components/contact/ContactForm.tsx` (existing-tenant banners via `useExistingContacts`), `components/UnifiedOnboardingDialog/UnifiedOnboardingDialog.tsx` (`handleSubmit(intent)`) |
| Lease configuration tab | `pages/LeaseConfigurationsPage/pages/LeaseConfigurationPage/LeaseConfigurationPage.tsx` (`Tab` enum, `useMatch`, `RouteLink`) + child route in `config/routes.tsx` + a page under `.../pages/<Name>Page/` |
| Settings form building blocks | `LeaseDetailsForm.tsx` (`SideBySideCard`, `Checkbox` with `value`/`onChange(event.target.value)`) |
| Move-out flow | `components/MoveOutDialog/MoveOutDialog.tsx` (`onSuccess`), `components/MoveOutForm.tsx` |
| Activity log | `components/EventLog/EventLog.tsx` (merge point after `useFetchEventsQuery`), `EventSwitch.tsx` `EVENT_MAP`, `types/event.ts` (`EventType` enum + `Event` union first arm), `utils/constants/event.ts` (`EVENT_TYPE_LABELS`, exhaustive) |
| Server-side grids | `web/packages/components/src/data-grid/` (`DataGrid.tsx`, `hooks/useGridDataSource.ts`, `types.ts`) |

Component contracts worth remembering: `Badge tone` = neutral/informational/success/warning/critical; `Banner tone` = info/warning/error with optional `title`; `useModal(Component, props).open(partialProps)`; `useToast()(message, 'error')`; current user name = `useFetchProfileQuery().data.info.name`; fake ids via `Id(-n)` from `@cubby/types`; the app's `Link` is `components/Link`, **not** `@cubby/components`.

## Step 3 — Build

1. **Store** — `src/components/<topic>/proto<Topic>Store.ts`: `useSyncExternalStore` + `localStorage` key `cubby-proto-<topic>-v1`; typed state, defaults, actions, hooks (`useX`, `useXIds` as a `Set`), an event history if the concept touches the activity log. Model: `components/do-not-rent/protoDoNotRentStore.ts`.
2. **Components** — badge, banner, dialog, list icon, settings page; clone the nearest existing pattern rather than inventing.
3. **Patches** — a Python script with anchored `str.replace` that **aborts when an anchor's count ≠ 1**; imports in alphabetical position; hook values added to `useMemo` deps. Grep `\bName\b` before adding an import (multi-line imports hide existing names).
4. **Server-side grids** — filter-menu entries come from hidden columns, but the request goes to the API; use the DataGrid `clientFilters` prop (added Sep 2026) to keep the field out of the request and post-filter the fetched page. Say so in the hand-off.
5. **Activity log entries** — add the enum member, extend the `Event` union arm, add the label, register a renderer in `EVENT_MAP`, merge pseudo-events in `EventLog` for the right `EventScope`.
6. **Blocking flows** — intercept `handleSubmit(intent)` in `UnifiedOnboardingDialog` and show a toast; never silently drop leads.

## Step 4 — Quality gates (seconds, always) + optional typecheck

Run from the **package directory**, on touched files only, with zsh word-splitting (`${=FILES}`):
```bash
cd web/apps/manager    && npx oxfmt ${=FILES} && npx oxlint --quiet ${=FILES}
cd web/packages/components && npx oxfmt ${=FILES} && npx oxlint --quiet ${=FILES}
```
Never format whole directories — it reformats unrelated files (revert those with `git checkout --`). Fix lint findings (import member order, `== null`, unnecessary `Boolean()`/`String()` conversions, `consistent-function-scoping`).

**Typecheck only if Q9 = YES:** `pnpm -F @cubby/manager typecheck` in the background (~10 min). Ignore the repo baseline (`apps/manager/.tscheck.rec.json`, currently `config/access.ts`) and errors inside untracked leftovers. If it exceeds ~12 minutes or sits at 0% CPU, kill it — it is hung.

## Step 5 — Run locally against staging

- Prereqs: `source ~/.nvm/nvm.sh && nvm use` inside `web/`, `pnpm`, installed `node_modules`. The full local backend needs Java 25 + MySQL + Postgres — assume unavailable unless checked.
- Staging API host: `API_DOMAIN` in `cloud/staging/api/cloudbuild.yml` (Sep 2026: `api-1b2ff12a-81efe02e97d4.staging.cubbystorage.dev`). Its CORS allows `http://localhost:3000`; the staging *manager UI* is behind Google IAP, the API is not.
- Start (the `preview_start` launcher sandbox cannot read the repo path, so start it yourself):
```bash
RUN=<scratchpad>; cd "/Users/hzahariev/Documents/cubby work docs/cubby/web" && source ~/.nvm/nvm.sh && nvm use >/dev/null && \
BROWSER=none VITE_CUBBY_API=https://<api-domain> nohup pnpm -F @cubby/manager start > "$RUN/vite-manager.log" 2>&1 & echo $! > "$RUN/vite-manager.pid"
```
  then poll port 3000 and open the Browser pane with `preview_start` **url** `http://localhost:3000`.
- Hristo logs in with his staging credentials — never type them. Verify compile via the Vite log (`hmr update` lines; `Failed to reload` = bad import) and the pane's console; take a screenshot to confirm the login page renders.
- Stop: `kill $(cat "$RUN/vite-manager.pid")`.

## Step 6 — Hand-off

Report: the click-through script (the demo moments, in order, with the screens to open), what is **not** in the prototype and why, the branch + files touched, caveats (client-side filtering, untracked leftovers), and how to stop/restart the server. Offer a **local** commit (no push). Record the run recipe, gotchas and decisions in memory. Iterate on feedback in batches: patch → lint → let HMR reload → tell Hristo what changed.

## Gotchas collected so far
- `Link` → `components/Link`; `Icon` is usually already imported via a multi-line `@cubby/components` import.
- `Event` union / `EVENT_TYPE_LABELS` are exhaustive — a new `EventType` needs enum + union arm + label + `EVENT_MAP`.
- `Checkbox.onChange` delivers `event.target.value` as a boolean already; `Select`/`TextInput` follow `useForm`'s `handleChange`.
- zsh: unquoted `$VAR` is not word-split; `--include=*.ts` must be quoted; `\1` backreferences don't work in BigQuery regex.
- `git checkout -b <branch> origin/master` refuses if untracked files would be overwritten — resolve, don't force.
- oxfmt/oxlint print "no files" when run from `web/` — run them from the package.
