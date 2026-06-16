---
type: Context
title: Knowledge Documentation Standard
description: Canonical OKF-aligned standard for specs, frontmatter, cross-linking, and index files across all projects.
tags: [standard, docs, okf, context]
timestamp: "2026-06-16T00:00:00Z"
---

# Knowledge Documentation Standard (canonical)

> **`context-` file — authoritative.** This is the workspace-level canonical standard
> for all projects. Adapted from Google's Open Knowledge Format (OKF v0.1) for
> AI-assisted software development. Project-level docs standard files inherit from
> and may extend this. It supersedes `context-specification-drafting.md`,
> `context-file_naming_rules.md`, and `specification-drafting-manual.md` wherever
> those exist.

---

## 1. Objective

Standardize how product specs and planning docs are written and maintained so the
repo stays "AI-ready": any agent can parse scope, traceability, and current build
state instantly, and docs never silently drift from the code.

---

## 2. Frontmatter Schema

Every `.md` file in `specs/` MUST start with a YAML frontmatter block:

```yaml
---
type: Feature Spec                       # REQUIRED — see §3 for valid values
title: Short Human-Readable Name         # REQUIRED — display name for index.md listings
description: One sentence summary.       # REQUIRED — used in index.md and search
Module: [Name]                           # existing field — keep
Business_Case_Stage: [e.g., Phase 2]    # existing field — keep
Dependencies: [spec-filename, ...]       # existing field — list filenames (no paths, no .md)
Test_Suite: [tests/path/, ...]           # existing field — paths to test files, or []
Status: Draft (Mon YYYY) — Phase X      # existing field — keep
resource: https://...                    # CONDITIONAL — include when spec maps to a live URL
tags: [tag1, tag2, tag3]                # RECOMMENDED — 3–5 lowercase terms
timestamp: "YYYY-MM-DDT00:00:00Z"       # RECOMMENDED — ISO 8601 date of last meaningful edit
---
```

**Field rules:**
- `type`, `title`, `description` are new OKF-aligned fields added to all specs
- `resource` is included only when the spec describes a deployed/live asset (app, API,
  database, table) — omit for abstract concepts (business cases, plans, notes)
- `Dependencies` lists filenames only (`spec-foo.md`), not full paths
- `timestamp` is set to the Status date or today when adding for the first time
- All other existing fields (`Module`, `Business_Case_Stage`, `Test_Suite`, `Status`)
  remain unchanged

---

## 3. Type Taxonomy

The `type:` value identifies the kind of concept. Infer from the filename prefix:

| `type:` value | Filename prefix | Used for |
|---|---|---|
| `Feature Spec` | `spec-` | User-facing feature requirements |
| `API Contract` | `spec-` | API endpoint/schema definitions |
| `Data Model` | `spec-` / `ref-` | Database schema, entity definitions |
| `Infrastructure Spec` | `spec-` | Deployment, CI/CD, platform infra |
| `Security Spec` | `spec-` | Security, privacy, compliance |
| `Business Case` | `spec-` | Business case, market analysis |
| `Context` | `context-` | Authoritative agent instructions |
| `Plan` | `plan-` | Phase plans, roadmaps, sequenced work |
| `Reference` | `ref-` | Decision logs, rate tables, external standards |
| `Working Notes` | `notes-` | Freeform notes — not authoritative |

When multiple types could apply, use the most specific one. Default to `Feature Spec`
for `spec-` files when uncertain.

---

## 4. Resource URLs

Use `resource:` to link a spec to its live deployed asset. Reference table per project:

### Scoutloop
| Spec scope | `resource:` URL |
|---|---|
| Frontend app | `https://scoutloop.me` |
| Backend API | `https://scoutloop-zwi9.onrender.com` |
| Supabase project | `https://supabase.com/dashboard/project/juuvozxnolgrwjmeoxnz` |

### Lease-Assist
| Spec scope | `resource:` URL |
|---|---|
| Frontend app | `https://lease-assist.vercel.app` |
| Supabase project | `https://supabase.com/dashboard/project/cofdurxatoniabvmmlsr` |

### Physio-ai
| Spec scope | `resource:` URL |
|---|---|
| Frontend app | `https://physio-ai-seven.vercel.app` |
| Supabase project | `https://supabase.com/dashboard/project/czclncvfxrqbsuhxtxae` |

---

## 5. Cross-Linking

Specs SHOULD link to each other using standard markdown links. Two places:

### 5.1 Inline links in body
When referring to a related concept inline, wrap the name in a link:
```markdown
See the [data model](../ref-database-schema.md) for table definitions.
The [platform infrastructure spec](../infrastructure/spec-requirements-platform-infrastructure.md)
defines the deployment environment.
```

### 5.2 See Also section
Every `spec-` file with one or more `Dependencies` MUST include a `## See Also`
section immediately before `## Implementation Status`. List each dependency as a
linked bullet with a one-line description of the relationship:

```markdown
## See Also

- [Database Schema](../ref-database-schema.md) — tables this feature reads/writes
- [Platform Infrastructure](../infrastructure/spec-requirements-platform-infrastructure.md) — deployment environment
- [Auth & Onboarding API](../spec-api-contract-auth-onboarding.md) — auth endpoints used by this module
```

### 5.3 Citations
When the body references external material (legal regulations, third-party APIs,
published standards), list sources under `## Citations` at the document bottom:

```markdown
## Citations

[1] [BC Privacy Act](https://www.bclaws.gov.bc.ca/civix/document/id/complete/statreg/03063_01)
[2] [Supabase RLS guide](https://supabase.com/docs/guides/auth/row-level-security)
```

---

## 6. Index Files

Every `specs/` directory and subdirectory MUST have an `index.md`. Index files:
- Have **no frontmatter**
- List every `.md` file (except `index.md` itself) as a linked bullet
- Use each file's `title:` and `description:` frontmatter fields for the entry text
- Group entries by `type:` with a heading per group
- List subdirectories as linked entries with a one-line summary

Format:
```markdown
# [Directory Name] — Spec Index

## Context Files
* [Title](filename.md) — description

## Feature Specs
* [Title](subdir/filename.md) — description
* [Subdirectory](subdir/) — what this subdir contains

## Plans
* [Title](plan-filename.md) — description

## Reference
* [Title](ref-filename.md) — description

## Working Notes
* [Title](notes-filename.md) — description
```

Omit a group heading if there are no files of that type. Subdirectory entries point
to `subdir/index.md`.

---

## 7. Drafting Lifecycle

Every new spec follows this 4-stage sequence:

| Stage | Activity | Goal |
|---|---|---|
| 1. Pitch | User shares idea + high-level requirements | Establish the vision |
| 2. Critique | Agent analyses feasibility, security, gaps | Find problems before writing |
| 3. Blueprint | Agent drafts outline in chat for review | Align on scope first |
| 4. Final Spec | Agent writes Markdown spec into `specs/` | Source of truth for coding agents |

**Guardrails:** critique before drafting · facts only, no filler · clarify Local vs.
Web before architecture · frame technical choices as plain-language options with a
recommendation.

---

## 8. Mandatory Spec Sections

Every **master `spec-`** file includes:
- Frontmatter (§2) · Executive Summary (2–3 sentences) · Core Objectives ·
  High-Level Architecture · Security & Privacy · **See Also** (§5.2, if deps exist) ·
  **Implementation Status** (§9) · Citations (§5.3, if applicable)

Every **sub-module `spec-`** file includes:
- Functional Requirements · Logic & Calculations · UI/UX Elements ·
  Non-Functional Requirements · Error Handling · See Also · Implementation Status

---

## 9. Implementation Status Tracking

**9.1 Header `Status` field:**

| State | Format | Example |
|---|---|---|
| Initial draft | `Draft (Mon YYYY) — Phase X` | `Draft (May 2026) — Phase 0` |
| Partial | `Draft (Mon YYYY) — Phase X built, Phase Y planned` | |
| Fully built | `Final (Mon YYYY)` | `Final (Jun 2026)` |
| Superseded | `Archived (Mon YYYY)` | `Archived (Jul 2026)` |

**9.2 Implementation Status section** (end of every `spec-` file):

```markdown
## Implementation Status

| Area | Status | Phase | Notes |
|------|--------|-------|-------|
| Feature A | ✅ Done | Phase 0 | Shipped and tested |
| Feature B | 🔄 Partial | Phase 0 | Gap: missing X |
| Feature C | 📅 Planned | Phase 2 | Not started |
```

Indicators: ✅ Done · 🔄 Partial · 🔜 In Progress · 📅 Planned · ❌ Deprecated

**9.3 Roadmap protocol:** `plan-` files show **future/remaining work only** — no
completed-sprint detail. Archive completed phase detail to `_archive/`.

---

## 10. File Naming & Layout

```
[type]-[kebab-topic].md
```

- Lowercase, hyphen-separated, self-describing
- No version numbers or dates in filenames (git tracks history) unless inherently
  date-specific (e.g. `ref-tax-rates-2026.md`)

| Prefix | Purpose |
|---|---|
| `spec-` | Requirements, scope, functional definitions |
| `context-` | Authoritative instructions for AI agents — read first |
| `plan-` | Phase plans, roadmaps, sequenced work |
| `ref-` | Reference data (rates, tables, external standards, decisions) |
| `notes-` | Freeform notes — not authoritative |

**Layout rules:**
- `specs/` root holds general specs + context files
- Feature modules MAY use one level of subdirectory (depth ≤ 2)
- Every directory must have `index.md` (§6)
- Check before creating — update, don't duplicate
- One topic per file; split beyond ~150 lines
- `context-` files are authoritative — follow exactly
- Never rewrite a `spec-` to match what was built — update its `Status` only

---

## 11. Update-on-Change Protocol

Any PR that adds or changes a feature MUST, in the same PR:

1. Update the relevant `spec-` file's **Status** + Implementation Status section
2. Update `docs/planning/traceability-index.md` (spec ↔ test mapping)
3. Update schema docs if any table/column/RLS policy changed
4. Archive, don't delete, any doc the change supersedes (→ `_archive/` with banner)

---

## 12. Archive Protocol

- Superseded docs go to `specs/_archive/` (or `docs/_archive/` for planning docs)
- Prepend: `> Archived (Mon YYYY) — superseded by <path>.`
- Archived files use `notes-` prefix where practical
- Cross-references in live docs point to archive when content migrated

---

## 13. Formatting

Markdown only (no HTML) · Tables for comparisons/architecture/status ·
Code blocks for directory trees, JSON schemas, CLI, formulas ·
Separate files per module to limit context bloat
