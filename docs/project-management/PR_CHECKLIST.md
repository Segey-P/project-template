# PR Checklist

Run through this before opening every PR. Takes ~2 minutes.

## Code quality

- [ ] Tests pass: _(add project test command here, e.g. `make test` or `pytest tests/ -q`)_
- [ ] No obvious regressions in related areas
- [ ] New behaviour has a test (happy path + key failure mode)

## Schema / migrations (skip if no DB changes)

- [ ] Migration file created with timestamp prefix
- [ ] SCHEMA.md (or equivalent) updated in the same PR
- [ ] Migration applied to production and verified with table inspection
- [ ] `scripts/check_schema_docs.py` passes (if present)

## Documentation

- [ ] `SPEC_COMPLIANCE.md` updated — add one row per file created, modified, or deprecated this PR
- [ ] Relevant `specs/` or `docs/` files updated if behaviour changed
- [ ] No stale TODOs or placeholder text left in changed files

## Environment variables (skip if none added)

- [ ] New vars documented in `.env.example`
- [ ] Added to production environment (Render / Vercel / etc.)

## PR description

Include:
1. **What changed** — concise bullets
2. **Why** — motivation or linked issue
3. **Manual steps** — migrations to run, env vars to set, caches to clear
