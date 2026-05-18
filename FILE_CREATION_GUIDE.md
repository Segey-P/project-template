# File Creation Guide

**Audience:** AI agents creating or modifying files in any project within this workspace.
**Prerequisite:** Read `AGENTS.md` and `specs/SPEC_CHECKLIST.md` before following this guide.

---

## Standard Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  1. IDENTIFY need for a new file                           │
│     ↓                                                      │
│  2. CHECK existing files for duplicates or related content │
│     ↓                                                      │
│  3. CHOOSE type prefix and filename                        │
│     ↓                                                      │
│  4. SELECT correct directory                               │
│     ↓                                                      │
│  5. RUN pre-creation validation (validate_file_creation.sh)│
│     ↓                                                      │
│  6. RESOLVE any failures (auto-fix or manual)              │
│     ↓                                                      │
│  7. CREATE file with required sections                     │
│     ↓                                                      │
│  8. RUN post-creation verification (verify_file_compliance)│
│     ↓                                                      │
│  9. LOG results in SPEC_COMPLIANCE.md                      │
│     ↓                                                      │
│ 10. COMMIT and update related files                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Step Details

### Step 1: Identify the Need

Ask yourself:
- What is the purpose of this file? (requirements, context, plan, reference, notes)
- Does this belong in `specs/`, `src/`, or `tests/`?
- Is this a new file or an update to an existing one?

### Step 2: Check Existing Files

Before creating anything new:
- Search `specs/` for keywords related to your topic
- Search `src/` for existing implementations
- Search `tests/` for existing test files
- Grep across the project: `grep -ri "<topic>" .`

If a file already covers the topic, **update it instead of creating a new one.**

### Step 3: Choose Type & Name

Use the naming convention from `context-file_naming_rules.md`:

```
[type]-[kebab-topic].md
```

| Type | When to Use |
|------|-------------|
| `spec-` | Requirements, scope, functional definitions |
| `context-` | Background information, instructions, rules for agents |
| `plan-` | Phase plans, task breakdowns, sequenced work |
| `ref-` | Reference material, external standards, decision records |
| `notes-` | Working notes, meeting summaries, observations |

### Step 4: Select Directory

| File Type | Directory |
|-----------|-----------|
| Spec files | `specs/` |
| Source code | `src/` (or language-specific: `src/python/`, `src/js/`) |
| Tests | `tests/` |
| Project config | Root (`.gitignore`, `README.md`, etc.) |

The `specs/` directory is flat — no subdirectories. Clear naming replaces folder structure.

### Step 5: Run Pre-Creation Validation

```
bash validate_file_creation.sh --file "specs/spec-my-feature.md"
```

The script will check:
- Naming convention compliance
- Duplicate detection
- Directory correctness
- File size limits on related files

### Step 6: Resolve Failures

| Severity | Action |
|----------|--------|
| Auto-fixable | Apply the fix automatically (rename, lowercase, etc.) |
| Needs review | Present the issue to the user for guidance |
| Blocking | Do not create the file until resolved |

### Step 7: Create File with Required Sections

Use the required sections from `SPEC_CHECKLIST.md`:

- **`spec-*` files:** Executive Summary, Core Objectives, Architecture, Security & Privacy, Status
- **`context-*` files:** Purpose, Rules/Guidelines, Scope
- **`plan-*` files:** Goal, Phases/Steps, Timeline, Success Criteria
- **`ref-*` files:** Source, Effective Date, Notes
- **`notes-*` files:** Context, Observations/Key Points, Date

### Step 8: Run Post-Creation Verification

After creating the file, verify it:

- Manually check against `SPEC_CHECKLIST.md`
- Run grep for common issues: `grep -in "TODO\|FIXME\|XXX" specs/spec-my-feature.md`
- Verify required sections are present
- Check for duplicate content across files

### Step 9: Log Results

Update `SPEC_COMPLIANCE.md`:
- File created
- Validation results (pass/fail, auto-fixes applied)
- Any issues requiring human review

### Step 10: Commit and Update Related Files

- Add the file to git: `git add <file>`
- Update `README.md` if the file represents a significant new capability
- Update `plan-*` files if this completes a milestone
- Update `ref-status.md` or similar tracking files

---

## Deprecating a File

When a file is no longer needed, don't delete it — deprecate it:

1. **Add deprecation header** at top of file: `> **DEPRECATED** — Replaced by \`specs/replacement.md\`. Reason: …`
2. **Move to `_Archive/`** keeping original path structure: `mv specs/spec-old.md _Archive/specs/spec-old.md`
3. **Log in `SPEC_COMPLIANCE.md`** under Deprecation Records with date, file, and reason
4. **Update cross-references** in any files that linked to the deprecated file

Never delete a file directly — always go through `_Archive/`.

---

## Decision Tree: New File or Update Existing?

```
Is this a new topic?
├── YES → Is there an existing file on this topic?
│   ├── YES → Update the existing file
│   └── NO  → Create a new file with proper naming
└── NO → Is this an improvement to an existing feature?
    ├── YES → Update the relevant spec- file
    └── NO  → Determine correct file type and create
```

---

## Common Errors to Avoid

| Error | Why It's Harmful | How to Avoid |
|-------|-----------------|--------------|
| Creating duplicate files | Wastes context, confuses agents | Always grep for existing files first |
| No type prefix | Cannot determine file purpose | Follow naming convention strictly |
| Mixed topics in one file | Hard to navigate, bloated context | One topic per file, max ~150 lines |
| Placeholder content | Breaks agent workflow | Never commit TODOs or "to be filled" |
| Wrong directory | Breaks tool expectations | Check project structure before creating |
| Markdown violations | Renders poorly, hard to parse | Use standard Markdown only |
| Editing protected files | Requires human approval | Never modify AGENTS.md, financial logic, or deployment configs without asking |
| Deleting instead of deprecating | Loses history, breaks links | Move to `_Archive/` with deprecation notice |
