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

## 5. Technical Formatting Standards

- **Markdown only.** Use standard Markdown (`#`, `##`, `|`, `*`) — no HTML, no proprietary formats.
- **Tables** for comparisons, architecture, and status overviews.
- **Code blocks** for directory structures, JSON schemas, CLI commands, and formulas.
- **Separate files per module** to prevent context bloat during development.

---

## 5. Communication Guardrails

- **Critique first.** The assistant must analyze gaps before drafting — no jumping to files.
- **Concise and precise.** Facts and requirements only — no conversational filler.
- **Security first.** Clarify Local vs. Web deployment before any architecture decisions.
- **Non-technical user.** Ask clarifying questions in plain language. Frame technical choices as simple options with a clear recommendation.
