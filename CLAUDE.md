# Claude Context — [Project Name]

> Copy this file into each new project. Fill in the sections marked [like this].

## Project Overview

- **Name:** [Project Name]
- **Status:** Discovery
- **Repo:** github.com/Segey-P/[repo-slug]
- **Purpose:** [One or two sentence description.]
- **Stack:** [e.g. Streamlit + PostgreSQL]
- **Deploy:** Streamlit Community Cloud

## User Profile

- **Role:** Senior IT Consultant (Banking sector), Canadian (Squamish, BC — Pacific Time)
- **Style:** Direct, precise, no softening. Tables and bullet points.
- **Technical level:** Not a developer — use plain language when explaining options.
- **Workflow:** Cloud-first via Claude Code web. Minimize local machine dependency.

## Tech Stack & Environment

| Component | Technology | Version |
|-----------|-----------|---------|
| Language | [e.g., Python 3.10+] | |
| Framework | [e.g., Streamlit, FastAPI] | |
| Database | [e.g., PostgreSQL, SQLite] | |
| Cloud | [e.g., Streamlit Cloud, AWS] | |
| Auth | [e.g., OAuth, Email+Password] | |

## Before Making Changes

1. Read `TODO.md` — current next actions and priorities.
2. Read all files in `specs/` if present (especially `context-*.md` first).
3. Never commit secrets or credentials (use environment variables).

## Directory Structure

```
project-name/
├── CLAUDE.md                    ← agent instructions (this file)
├── AGENTS.md                    ← agent-neutral mirror
├── README.md                    ← user-facing overview
├── TODO.md                      ← active tasks only (updated daily)
├── specs/                       ← specification files
│   ├── context-*.md            ← agent instructions (read first)
│   ├── spec-*.md               ← requirements & definitions
│   ├── plan-*.md               ← phases & roadmap
│   └── ref-*.md                ← decisions & reference data
├── src/                         ← source code
├── tests/                       ← test suite
├── scripts/                     ← utilities (migrations, seed data)
├── requirements.txt             ← Python dependencies
└── .gitignore                   ← exclude venv/, .env, secrets
```

## AI Agent Rules

1. **Session start:** Read `specs/context-*.md` first, then `TODO.md`.
2. **Push strategy:** Push directly to `main` — no feature branches unless large/risky.
3. **Code style:** Prefer editing existing files over creating new ones.
4. **Dependencies:** Minimal & justified. Evaluate alternatives before adding.
5. **Comments:** Only *why*, never *what*. Well-named code is self-documenting.
6. **Abstractions:** No premature helpers. Three similar lines is fine.
7. **Completeness:** No half-finished work. Either done or blocked.
8. **Updates:** Keep `TODO.md` current throughout the session. Delete completed items immediately.
9. **Specs:** Update at end of session or after major requirement changes.

## Development Commands

| Task | Command |
|------|---------|
| **Install deps** | `pip install -r requirements.txt` |
| **Run locally** | `streamlit run app.py` or `python app.py` |
| **Run tests** | `pytest tests/ -v` |
| **Format code** | `black src/ tests/` (if using Black) |
| **Database migration** | `python scripts/migrate.py <migration_file.sql>` |

## TODO.md Convention

`TODO.md` at the repo root is the source of truth for what's next.
The Project Hub dashboard reads it automatically.

**Golden Rule:** Only active/next-step items. Delete completed items immediately in the same commit.

Format:

```markdown
# [Project Name] — TODO

## Priority 1
- [ ] Task description (what to deliver, not how)
- [ ] Another task

## Blocked / Parked
- [ ] Task (blocker: awaiting decision on X)
```

**Up to 6 items are shown in the dashboard.**

## Naming Conventions

### Files
- **Specs:** `spec-*.md`, `context-*.md`, `plan-*.md`, `ref-*.md`
- **Python:** `snake_case.py`, `test_module.py`
- **Classes:** `PascalCase`, **Functions:** `snake_case()`
- **Database:** Tables `snake_case` plural, columns `snake_case`

## Secrets & Environment

- **Store in:** `.env.local` (not committed) or Streamlit Cloud secrets
- **Never commit:** `.env`, API keys, credentials, passwords
- **Format:** Use environment variables for all secrets

Example:
```bash
# .env.local (add to .gitignore)
ANTHROPIC_API_KEY=sk-ant-...
DATABASE_URL=postgresql://user:pass@host/db
```

## Streamlit Cloud Deployment

1. Push to GitHub `main` branch (auto-deploys)
2. Add secrets in Streamlit Cloud dashboard → app settings
3. Ensure `requirements.txt` is up-to-date
4. Test locally before pushing: `streamlit run app.py`
5. Test on deployment after merge (CSS, auth, APIs)

## Code Quality

- **Linting:** Follow PEP 8 (use `black` or `ruff`)
- **Testing:** Write tests for business logic; UI tests are manual
- **Coverage:** Aim for > 70% on business logic
- **Git commits:** Imperative mood ("Fix bug" not "Fixed bug")

## Security Checklist

- [ ] No secrets in code or git history
- [ ] Input validation on all user inputs
- [ ] SQL injection prevention (use prepared statements)
- [ ] HTTPS enforced (auto on Streamlit Cloud)
- [ ] Dependencies up-to-date

## Key Files

| File | Purpose | Who Owns |
|---|---|---|
| `TODO.md` | Current next steps (read by Project Hub) | Agent |
| `CLAUDE.md` | Agent instructions (this file) | Project owner |
| `AGENTS.md` | Agent-neutral mirror of CLAUDE.md | Project owner |
| `specs/` | Authoritative spec documents | Project owner + agent |
| `requirements.txt` | Python dependencies | Agent |
| `src/` | Source code | Agent |

## Specialized Agents (15 Active)

| # | Agent | Purpose | Default Model |
|---|---|---|---|
| 1 | Code Refiner | Code quality, refactoring, cleanup (merged) | Qwen3 Coder (Free) |
| 2 | Security & Compliance Officer | Vulnerabilities, PIPEDA, OWASP, banking (merged) | Liquid LFM 2.5 Thinking |
| 3 | Tech Lead / Solution Architect | Architecture trade-offs, scalability | Gemini 3 Flash |
| 4 | UX Reviewer | UI/UX, accessibility, mobile | Qwen3 Coder (Free) |
| 5 | Agent Coach | Meta-optimization of agent instructions | Gemini 3 Flash |
| 6 | Product Manager | Feature utility, MVP scope, prioritization | Gemini 3 Flash |
| 7 | Models Manager | Dynamic model routing and cost audits | Qwen3 Coder (Free) |
| 8 | Database Architect | Schema, migrations, ACID, indexing | DeepSeek-V4 Flash |
| 9 | Documentation Writer | README, inline docs, API docs | Qwen3 Coder (Free) |
| 10 | Testing Specialist | Unit/integration tests, edge cases | Qwen3 Coder (Free) |
| 11 | DevOps & Release Engineer | CI/CD, GitHub Actions, Streamlit Cloud, Vercel | Qwen3 Coder (Free) |
| 12 | Performance Optimizer | Streamlit/React/DB/API bottlenecks | Qwen3 Coder (Free) |
| 13 | API Design Reviewer | Endpoints, contracts, REST patterns | Qwen3 Coder (Free) |
| 14 | GitHub Ops | PRs, issues, branches, repo scaffolding | Qwen3 Coder (Free) |
| 15 | Streamlit Pro | Dashboard architecture, caching, Streamlit-specific | Qwen3 Coder (Free) |

## Model Switching

| Model | Best For | Limitations |
|---|---|---|
| **Qwen3 Coder (Free)** | Fast lookups, small edits, structured output | Limited reasoning depth |
| **Gemini 3 Flash** | Large context, history analysis, multi-file reads | Higher latency |
| **NVIDIA Nemotron 3 Super** | Cross-document reasoning, long-form writing | Slower than free models |
| **Liquid LFM 2.5 Thinking** | Regulatory analysis, security audits, complex logic | Token-heavy |
| **DeepSeek-V4 Flash** | SQL/NoSQL schemas, precise data tasks | Narrow focus |

**Rules:**
1. Start with cheapest capable model unless context is large (>50k tokens) or task is reasoning-heavy.
2. If output quality degrades, escalate to next tier.
3. Log model switches in commit messages: `[model: Gemini 3 Flash]`

Full definitions: `/Users/sergeypochikovskiy/AI_workspace/AGENTS.md`

---

## Execution Protocol (All Agents)

For every multi-file or multi-step task:

1. **Plan first** — identify dependencies. Group by independent units.
2. **Estimate** — give time + model choice upfront before starting.
3. **Parallelize** — run independent tasks concurrently. Different models if justified.
4. **Sequential only** — when outputs feed into next steps.

| Phase | Parallel? | Model |
|---|---|---|
| Read + analyze | Sequential (once) | Qwen3 Coder (Free) |
| Write / edit files | Parallel (no dependencies) | Qwen3 or Gemini 3 Flash |
| Git operations | Parallel (repos are independent) | Qwen3 Coder (Free) |

**Rule:** Never batch unrelated work sequentially just because it's the same tool. Parallelize whenever safe.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **App won't start** | Check logs: `streamlit run app.py` and look for errors |
| **Database connection fails** | Verify `DATABASE_URL` in secrets; test locally with `psql` |
| **API key errors** | Verify key exists and is current in secrets |
| **CSS not updating** | Hard-refresh browser (Cmd+Shift+R) |
| **Streamlit Cloud deploy fails** | Check `requirements.txt` syntax; verify secrets added |

## Resources

- **Workspace CLAUDE.md:** `/Users/sergeypochikovskiy/AI_workspace/CLAUDE.md` (overrides)
- **Streamlit docs:** https://docs.streamlit.io/
- **Python docs:** https://docs.python.org/3/
- **PostgreSQL docs:** https://www.postgresql.org/docs/
- **GitHub repo:** https://github.com/Segey-P/[repo-slug]

