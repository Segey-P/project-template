# Spec Compliance Training

**Purpose:** Examples of compliant and non-compliant files to train AI agents on spec adherence.
**Scope:** All Markdown files in the `specs/` directory.

---

## Example 1: Filename Naming

### ✅ Compliant

```
spec-auth-flow.md        # Requirements for authentication flow
context-project-rules.md  # Agent instructions for the project
plan-phase1-setup.md      # Phase plan for initial setup
ref-tax-rates-2026.md     # Reference: tax rate table (date-appropriate)
notes-meeting-may17.md    # Meeting notes, not authoritative
```

### ❌ Non-Compliant

```
auth.md                   # No type prefix
MyFeature.md              # Uppercase, no prefix, no hyphens
spec_my_feature.md        # Underscores instead of hyphens
spec-auth-v2.md           # Version number in filename
plan Phase 1 Setup.md     # Spaces in filename
NOTES_2026_05_17.md       # Uppercase, underscores, date in filename
Ideas.md                  # No prefix, ambiguous purpose
```

### Why It Matters

Non-compliant filenames cause:
- Agents can't determine file purpose from name alone
- Sorting and grep searches become unreliable
- Context loading wastes tokens on files with unclear relevance
- Version numbers in filenames cause confusion (git handles versioning)

---

## Example 2: Required Sections

### ✅ Compliant `spec-auth-flow.md`

```markdown
# Authentication Flow Specification

## Executive Summary
A secure login system supporting email/password and OAuth providers.

## Core Objectives
- User registration with email verification
- Login with email/password
- OAuth integration (Google, GitHub)
- Password reset flow
- Session management with JWT

## High-Level Architecture
| Component | Technology |
|-----------|-----------|
| Backend | FastAPI + JWT |
| Frontend | Streamlit |
| Data | PostgreSQL (users table) |

## Security & Privacy
- Passwords hashed with bcrypt
- JWTs expire after 24 hours
- All data stored locally, no third-party sharing

## Status
- [x] User model and database schema
- [ ] Registration endpoint
- [ ] Login endpoint
- [ ] OAuth integration
- [ ] Frontend components
```

### ❌ Non-Compliant `auth.md`

```markdown
# Auth

We need login. Maybe JWT? Not sure yet. Will figure out later.

TODO: add more details

Features:
- login
- register
- oauth
```

### Why It Matters

The non-compliant version:
- Lacks structure: agents can't easily find specific information
- Contains placeholders that break automated workflows
- Has no security/privacy section (critical for financial/personal data)
- No Status section — impossible to track progress
- Ambiguous scope: "auth" could mean anything

---

## Example 3: One Topic Per File

### ✅ Compliant

```
spec-invoice-generation.md    # Invoice creation, PDF output
spec-payment-processing.md    # Payment gateway integration, refunds
spec-notifications.md         # Email/SMS notifications for events
```

### ❌ Non-Compliant

```
spec-invoicing.md (covers: invoices, payments, notifications, reminders)
```

### Why It Matters

A single 300-line file on "invoicing" forces agents to load everything even when working on one sub-feature. Separate files per module:
- Reduce token overhead during agent initialization
- Allow parallel work on independent features
- Make git history more readable (changes scoped to one file)
- Follow the ~150-line guideline for manageable file sizes

---

## Example 4: Directory Placement

### ✅ Compliant

| File | Directory | Reason |
|------|-----------|--------|
| `spec-auth-flow.md` | `specs/` | Requirements specification |
| `context-project-rules.md` | `specs/` | Agent instructions |
| `plan-phase1-setup.md` | `specs/` | Work plan |
| `main.py` | `src/` | Source code |
| `test_auth.py` | `tests/` | Tests |

### ❌ Non-Compliant

| File | Directory | Problem |
|------|-----------|---------|
| `auth_flow.md` | `src/` | Spec file in source directory |
| `plan.pdf` | `specs/` | Non-Markdown, wrong format |
| `context-rules.md` | Root | Agent instructions belong in specs/ |
| `test-spec.md` | `specs/` | Test files belong in tests/ |
| `main.py` | Root | Source code belongs in src/ |

### Why It Matters

Wrong placement:
- Breaks agent expectations (agents check `specs/` for instructions)
- Creates confusion about file purpose
- Makes automated validation harder (scripts expect specific directories)
- Violates the project structure defined in `AGENTS.md`

---

## Example 5: Markdown Quality

### ✅ Compliant

```markdown
## Section Title

Description text with **bold** and `inline code`.

| Column A | Column B |
|----------|----------|
| Value 1  | Value 2  |

- List item
- Another item
```

### ❌ Non-Compliant

```markdown
## Section Title

Description text with <b>bold</b> and <code>inline code</code>.

Column A | Column B
--- | ---
Value 1 | Value 2

* List item
* Another item
```

Uses HTML (breaks some Markdown renderers), missing pipe alignment, uses `*` for lists instead of `-`.

---

## Summary

| Rule | Compliant | Non-Compliant | Auto-Fix? |
|------|-----------|---------------|-----------|
| Filename: type prefix | `spec-auth.md` | `auth.md` | Suggest |
| Filename: lowercase | `spec-auth.md` | `spec-Auth.md` | Yes |
| Filename: hyphens | `spec-auth-flow.md` | `spec_auth_flow.md` | Yes |
| Filename: no version | `spec-auth.md` | `spec-auth-v2.md` | Suggest |
| Required sections | Has all sections | Missing sections | No |
| One topic per file | Split by module | Monolithic file | No |
| Correct directory | `specs/` for spec | Root or `src/` | Yes |
| No placeholders | Clean content | TODOs, FIXMEs | No |
| Markdown only | Standard MD | HTML tags | Suggest |
