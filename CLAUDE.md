See [AGENTS.md](./AGENTS.md) — it is the authoritative guide for all work on this project.

---

## Workflow rules

1. **Resolve merge conflicts before creating a PR.** Always run
   `git fetch origin main && git rebase origin/main` before pushing, and fix any conflicts first.

2. **End every task with a summary** that ALWAYS includes, in this order:
   - **PR link** — full GitHub PR URL and CI/merge status
   - **What shipped** — concise bullets of code changes and commits
   - **Your next steps** — numbered checklist of what the user must do (deploy waits, Supabase SQL,
     Render env vars, manual verification). If there's nothing for the user to do, say so explicitly.

3. **AGENTS.md is locked.** Do not modify it without explicit permission. Add detail to `specs/`
   and `docs/` instead. Keep AGENTS.md lean (~50 lines) as an entry point only.

4. **Plan before implementing.** For any structural change, new dependency, or spec-level decision:
   present the approach and wait for approval before writing code.

---

## Git commands

Never prepend `cd <directory>` to a git command. Always use `git -C <directory>` instead.

```bash
# Wrong — triggers security prompt:
cd "/path/to/project" && git log

# Correct:
git -C "/path/to/project" log
```
