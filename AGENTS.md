# Agent Context — [Project Name]

Mirrors `CLAUDE.md` for non-Claude agents.

## What This Project Is

[One sentence description.]

## Rules

1. Read `TODO.md` before starting — it is the source of truth for next actions.
2. Never commit secrets or credentials.
3. Push to `main` directly.
4. `TODO.md` is read by the Project Hub dashboard — keep it current and updated throughout the session.
5. Prefer editing existing files over creating new ones.
6. Keep dependencies minimal.
7. Update specs in `specs/` at the end of every session and after any major change in requirements or behaviour.
8. Sync `opencode.json` with `opencode-agents/` at project start: `cp ../opencode-agents/opencode.json ./opencode.json`

---

## Specialized Agents (8 Active)

| # | Agent | Purpose | Model |
|---|---|---|---|
| 1 | Code Refiner | Code quality, refactoring, cleanup | MiniMax M2.5 (nvidia) |
| 2 | Security & Compliance Officer | Vulnerabilities, PIPEDA, OWASP, banking | MiniMax M2.5 (nvidia) |
| 3 | Tech Lead / Solution Architect | Architecture trade-offs, scalability | Nemotron 3 Super (nvidia) |
| 4 | UX Reviewer | UI/UX, accessibility, mobile | Nemotron 3 Super (nvidia) |
| 5 | Product Manager | Feature utility, MVP scope, prioritization | Nemotron 3 Super (nvidia) |
| 6 | Database Architect | Schema, migrations, ACID, indexing | Nemotron 3 Super (nvidia) |
| 7 | DevOps & Release Engineer | CI/CD, GitHub Actions, Streamlit Cloud | Nemotron 3 Super (nvidia) |
| 8 | Performance Optimizer | Streamlit/DB/API bottlenecks | MiniMax M2.5 (nvidia) |

## Model Pool (All FREE via NVIDIA / build.nvidia.com)

| Model | Provider | Context | Best For |
|---|---|---|---|
| **Nemotron 3 Super 120B** | nvidia | 262K | General purpose, routing, planning, coding |
| **MiniMax M2.5** | minimax | 197K | Fast lookups, security, docs |
| **DeepSeek R1** | deepseek | 164K | Quick fixes, reasoning |

**Fallback:** `openrouter/free` — auto-selects from all available free models.

**Rules:**
1. All models via build.nvidia.com — no cost, no credit card needed.
2. Connect via `/connect` in opencode — NVIDIA, MiniMax, DeepSeek, OpenRouter.
3. Log model switches in commit messages: `[model: Nemotron 3 Super]`

---

## Execution Protocol (All Agents)

For every multi-file or multi-step task:

1. **Plan first** — identify dependencies. Group by independent units.
2. **Estimate** — give time + model choice upfront before starting.
3. **Parallelize** — run independent tasks concurrently. Different models if justified.
4. **Sequential only** — when outputs feed into next steps.

| Phase | Parallel? | Model |
|---|---|---|
| Read + analyze | Sequential (once) | Nemotron 3 Super (nvidia) |
| Write / edit files | Parallel (no dependencies) | Nemotron 3 Super or MiniMax M2.5 (nvidia) |
| Git operations | Parallel (repos are independent) | Nemotron 3 Super (nvidia) |

Full definitions: `/Users/sergeypochikovskiy/AI_workspace/AGENTS.md`