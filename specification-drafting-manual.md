# Specification Drafting Protocol

## 1. Objective

To standardize the communication and documentation process for new product ideas, ensuring every project is "AI-ready" for development by Claude or Gemini.

---

## 2. The Drafting Lifecycle

Every new project follows this 4-step sequence to ensure clarity and rigor:

| Stage | Activity | Goal |
|---|---|---|
| **1. The Pitch** | User shares the core idea and high-level requirements. | Establish the vision. |
| **2. The Critique** | Assistant analyzes feasibility, security, and logic. Suggests missing requirements. | Identify gaps and add professional suggestions. |
| **3. The Blueprint** | Assistant drafts an outline in the chat for immediate review. | Align on scope before writing any files. |
| **4. The Final Spec** | Assistant writes Markdown spec files into the project's `specs/` folder. User or Assistant explicitly pushes changes to GitHub. | Create the source of truth for AI coding agents. |

---

## 3. Mandatory Specification Components

Every **Master Specification** must include these sections:

- **Executive Summary:** A 2-3 sentence elevator pitch.
- **Core Objectives:** Bulleted list of what the tool must achieve.
- **High-Level Architecture:** A table of Backend, Frontend, and Data storage technologies.
- **Security & Privacy:** Explicit data handling instructions (e.g., "Local Only," "No GitHub").
- **Status:** Checklist of major milestones — updated as work progresses, never deleted.

---

## 4. Module-Level Detail Requirements

Each sub-module document must define:

1. **Functional Requirements:** Specific features and user actions.
2. **Logic & Calculations:** Formulas or step-by-step logic.
3. **UI/UX Elements:** Tables, charts, or navigation descriptions.
4. **Non-Functional Requirements:** Security, access, scalability considerations.
5. **Error Handling:** What happens when things go wrong.

---

## 5. File Naming Rules

All spec files must follow this convention:

```
[type]-[kebab-topic].md
```

- Lowercase only
- Hyphens between words — no spaces, no underscores
- No version numbers or dates in filenames — git tracks history
- Filename must be self-describing without opening the file

### Type Prefixes

| Prefix | Use | Examples |
|---|---|---|
| `spec-` | Requirements, scope, functional definitions | `spec-aacs-overview.md`, `spec-project-hub-master.md` |
| `context-` | Instructions for AI agents — read these first | `context-file_naming_rules.md`, `context-project-instructions.md` |
| `plan-` | Phase plans, task breakdowns, sequenced work | `plan-phase1-setup.md`, `plan-q2-2026.md` |
| `ref-` | Reference data: tax tables, rates, regulatory notes | `ref-canadian-tax-2026.md`, `ref-heloc-rates.md` |
| `notes-` | Freeform notes — not authoritative | `notes-session-apr2026.md` |

### Rules

1. **Always use a type prefix.** A file named `overview.md` or `ideas.md` is not acceptable.
2. **Check before creating.** If a file already exists for the topic, update it — do not create a duplicate.
3. **One topic per file.** Split files over ~150 lines into sub-topic files with consistent prefixes.
4. **`context-` files are authoritative.** Follow them exactly — do not infer alternatives.
5. **`spec-` files define what gets built.** Never rewrite a spec to match what was built. Update the Status section only.
6. **Keep `specs/` flat.** No subdirectories. Clear naming replaces folder structure.
7. **Remove stale files.** AI agents treat every file in `specs/` as current and authoritative. Delete files that no longer apply.

---

## 6. Technical Formatting Standards

- **Markdown only.** Use standard Markdown (`#`, `##`, `|`, `*`) — no HTML, no proprietary formats.
- **Tables** for comparisons, architecture, and status overviews.
- **Code blocks** for directory structures, JSON schemas, CLI commands, and formulas.
- **Separate files per module** to prevent context bloat during development.

---

## 7. Communication Guardrails

- **Critique first.** The assistant must analyze gaps before drafting — no jumping to files.
- **Concise and precise.** Facts and requirements only — no conversational filler.
- **Security first.** Clarify Local vs. Web deployment before any architecture decisions.
- **Non-technical user.** Ask clarifying questions in plain language. Frame technical choices as simple options with a clear recommendation.
