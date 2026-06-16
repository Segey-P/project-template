# [PROJECT_NAME] — Agent Guide

**Read this before touching any code.** Project-specific entry point for AI-assisted work.
Global workspace rules (priorities, user profile, git policy, testing standards) live in
`Projects/AGENTS.md` — this file adds project context on top of those.

---

## Project snapshot

[One or two sentences: what this app does and who it's for.]

- **Frontend:** [URL] ([framework, e.g. Next.js 15 PWA] → [hosting, e.g. Vercel])
- **Backend API:** [URL] ([framework, e.g. FastAPI] → [hosting, e.g. Render]) — _remove if no separate backend_
- **DB / Auth:** Supabase (Postgres + RLS) — project ref `[ref-id]`
- **Repo:** github.com/Segey-P/[repo-name]

---

## Key references

| File | Read When |
|------|-----------|
| `specs/index.md` | Starting any task — find the right spec fast |
| `specs/context-project-overview.md` | Starting any task — phase, constraints, personas |
| `specs/context-docs-standard.md` | Creating or updating any spec or doc |
| `specs/ref-decisions.md` | Before proposing any tech or architecture change |
| `[SCHEMA.md or specs/spec-data-model.md]` | Any data layer or schema work |
| `docs/project-management/PR_CHECKLIST.md` | Before opening a PR |

---

## Workflow rules

1. **Spec first.** Read `specs/index.md` and the relevant `spec-` file before writing code.
   `context-*` files are authoritative — follow them exactly, never infer alternatives.
2. **Schema changes via migrations.** Never alter tables in the Supabase dashboard without
   a migration file + schema doc update in the same commit.
3. **Merge conflicts resolved before PR.** Run `git fetch origin main && git rebase origin/main`
   before pushing. Fix conflicts, then open the PR.
4. **End every task with a summary:**
   - **PR link** — full GitHub URL + CI/merge status
   - **What shipped** — concise bullets of changes
   - **Next steps** — numbered list of what the user must do (env vars, Supabase SQL, deploy checks)
5. **Update specs in the same PR.** Any change to a feature must update the relevant spec's
   Implementation Status table and `docs/planning/traceability-index.md`.
6. **Archive, never delete.** Superseded docs go to `_archive/` with a `> Archived (Date)` banner.
7. **This file is locked.** Do not modify without explicit approval. Add detail to `specs/` instead.

---

## Hard rules

_Replace these placeholders with project-specific constraints. Examples below:_

- No [feature X] until [condition] — e.g. "No diagnosis features until 1,000+ labeled cases exist."
- No [architecture pattern] — e.g. "No separate backend; all server logic in API routes / Server Actions."
- [Data residency] — e.g. "No patient data through services without confirmed Canadian hosting."
- [Stack constraint] — e.g. "Run backend tests with Python 3.11, not 3.9 — codebase uses `X | Y` union types."
- Treat security-hardened files as authoritative — check `git log --oneline -10 -- <file>` before
  concluding a file is wrong. Intentional security changes (CORS, IDOR checks) can look like bugs.

---

## Testing rules

- Run tests before every commit — see `project-rules.md` for the exact command.
- Fix tests, never production code, to make tests pass. If a test fails because mock data is wrong,
  fix the mock — never alter handlers or configs just to satisfy a test.
- Naming: `test_[component]_[condition]_[outcome]`
