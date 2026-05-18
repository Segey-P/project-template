# Spec Compliance Checklist

**Purpose:** Run through this checklist before creating *any* new file. If any check fails, stop and resolve before proceeding.

---

## Pre-Creation Checks

| # | Check | Pass/Fail | Auto-Fix? |
|---|-------|-----------|-----------|
| 1 | **Not a protected file** — AGENTS.md, financial/critical logic, deployment configs | not protected | No — stop, requires human approval |
| 2 | **File doesn't already exist** — grep for topic keywords | grep returns 0 results | No — update existing file instead |
| 3 | **Filename follows convention** — `[type]-[kebab-topic].md` | matches pattern | Yes — rename to correct format |
| 4 | **Correct directory** — spec files in `specs/`, code in `src/`, tests in `tests/` | correct location | Yes — move to correct dir |
| 5 | **Lowercase only** — no uppercase letters in filename | all lowercase | Yes — auto-lowercase rename |
| 6 | **No version/date in filename** — git tracks history | no version/date | Yes — strip version/date |
| 7 | **One topic per file** — does this topic warrant its own file? | singular scope | No — split into separate files |
| 8 | **File doesn't exceed ~150 lines** — has any precursor file grown too large? | under limit | No — split by sub-topic |

---

## Post-Creation Checks

| # | Check | Required For | Auto-Fix? |
|---|-------|-------------|-----------|
| 1 | **Has required sections** (see table below) | All spec files | No — add missing sections |
| 2 | **No placeholder content** — all TODOs, FIXMEs, "to be filled" removed | All files | No — resolve placeholders |
| 3 | **Markdown only** — no HTML, no proprietary formats | All files | Yes — strip non-MD |
| 4 | **Tables formatted correctly** — pipe alignment, no broken rows | All files | Yes — auto-align tables |
| 5 | **No duplicate content** — doesn't repeat what another file covers | All files | No — deduplicate |
| 6 | **Security/privacy noted** — explicit Local vs. Cloud data handling | Spec files | No — add security section |
| 7 | **Status section present** — checklist of milestones that updates as work progresses | Spec files | No — add Status section |

---

## Required Sections by File Type

| File Prefix | Required Sections |
|-------------|------------------|
| `spec-` | `Executive Summary`, `Core Objectives`, `Architecture` (or `High-Level Architecture`), `Security & Privacy`, `Status` |
| `context-` | `Purpose`, `Rules` (or `Guidelines`), `Scope` |
| `plan-` | `Goal`, `Phases` (or `Steps`), `Timeline`, `Success Criteria` |
| `ref-` | `Source`, `Effective Date`, `Notes` |
| `notes-` | `Context`, `Observations` (or `Key Points`), `Date` |

---

## Common Violations & Auto-Fixes

### Violation: Underscore in filename
- **Detected:** `spec-my_feature.md`
- **Auto-fix:** Rename to `spec-my-feature.md`
- **Rule:** Hyphens only, no underscores except in compound type prefixes

### Violation: Uppercase in filename
- **Detected:** `spec-MyFeature.md`
- **Auto-fix:** Rename to `spec-myfeature.md`
- **Rule:** Lowercase only

### Violation: No type prefix
- **Detected:** `overview.md`
- **Auto-fix:** Rename to `spec-overview.md` (if requirements) or `context-overview.md` (if instructions)
- **Rule:** Always use a type prefix

### Violation: Version number in filename
- **Detected:** `spec-auth-v2.md`
- **Auto-fix:** Rename to `spec-auth.md` (git tracks versions)
- **Rule:** No version numbers or dates

### Violation: Mixed topics in one file
- **Detected:** File covers multiple unrelated subjects
- **Auto-fix:** Not possible — split manually
- **Rule:** One topic per file

### Violation: Attempting to modify a protected file
- **Detected:** Agent attempts to edit AGENTS.md, financial code, or deployment config
- **Auto-fix:** Not possible — stop and request human approval
- **Rule:** Protected files require explicit user permission

### Violation: Deleting an active file without deprecating
- **Detected:** File removed but not moved through `_Archive/`
- **Auto-fix:** Not possible — restore file and go through deprecation workflow
- **Rule:** Deprecate via `_Archive/` — never delete directly

---

## How to Use This Checklist

1. **Before creating any file**, run through the Pre-Creation Checks
2. **After creating the file**, run through the Post-Creation Checks
3. **For auto-fixable violations**, apply the fix immediately
4. **For non-fixable violations**, present the issue to the user for guidance
5. **Log any violations** that required human review in `SPEC_COMPLIANCE.md`
6. **To deprecate a file:** move it to `_Archive/` with a deprecation note in the file header, then log in `SPEC_COMPLIANCE.md`
