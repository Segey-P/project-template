# Project File Naming Rules

**Scope:** All Markdown files in the `specs/` directory (local, Google Drive, GitHub).  
**Audience:** AI agents and human contributors creating or referencing files in this project.

---

## Convention

```
[type]-[kebab-topic].md
```

- Lowercase only
- Hyphens between words (no spaces, no underscores except to separate type from topic if needed)
- No version numbers, dates, or numeric prefixes — git tracks history
- Be specific enough that the filename is self-describing without opening the file

---

## Type Prefixes

| Prefix | Purpose | Examples |
|--------|---------|---------|
| `spec-` | Requirements, scope, functional definitions for a system or feature | `spec-aacs-overview.md`, `spec-auth-flow.md` |
| `context-` | Background information for AI agents: goals, constraints, rules, personas | `context-file_naming_rules.md`, `context-financial-goals.md` |
| `plan-` | Phase plans, task breakdowns, sequenced work | `plan-phase1-setup.md`, `plan-q2-2026.md` |
| `ref-` | Reference material: tax tables, rate data, regulatory notes, external standards | `ref-canadian-tax-2026.md`, `ref-heloc-rates.md` |
| `notes-` | Freeform working notes, observations, meeting summaries — not authoritative | `notes-gemini-session-apr2026.md` |

---

## Rules for AI Agents

1. **Always use a type prefix.** A file named `overview.md` or `ideas.md` is not acceptable.
2. **Do not create a file if one already exists for that topic.** Check the file list first and update the existing file instead.
3. **Do not embed dates in filenames** unless the content is inherently date-specific (e.g., a quarterly reference table). Use `ref-canadian-tax-2026.md`, not `notes-2026-04-15.md`.
4. **`context-` files are authoritative instructions.** When a `context-` file exists for a topic, follow it exactly — do not infer alternatives.
5. **`spec-` files define what gets built.** Do not modify a `spec-` file to reflect what was built — update it to reflect what *should* be built, then mark tasks complete in the Status section.
6. **One topic per file.** Do not combine unrelated subjects in a single file. If a file grows beyond ~150 lines, consider splitting by sub-topic with a consistent prefix (e.g., `spec-aacs-sync.md`, `spec-aacs-auth.md`).

---

## File List Hygiene

- The `specs/` directory is flat — no subdirectories. Clear naming replaces folder structure.
- When a file is no longer relevant, remove it from `specs/` rather than leaving it as dead context. AI agents treat every file in `specs/` as current and authoritative.
