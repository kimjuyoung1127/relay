# relay Working Rules

This file is the local working guide for contributors and coding agents in `relay`.

## Project Shape

- `relay` is a local multi-AI handoff orchestrator.
- The highest-risk changes usually cross TUI, orchestration, persistence, prompts, adapters, and PTY session handling.
- Because of that, impact analysis matters more here than in a simple single-module project.

## Default Rule

- For tiny single-file edits, start with `rg`.
- For medium or cross-module edits, start with `code-review-graph`.
- If local repo skills are available, prefer `$relay-graph-ops` for graph-guided work in this repository.

## Use `code-review-graph` Before These Tasks

- reviewing a non-trivial code change
- changing `src/relay/service.py`
- changing `src/relay/tui.py`
- changing `src/relay/repository.py`
- changing `src/relay/workflow_store.py`
- changing `src/relay/session_host.py`
- changing `src/relay/adapters.py`
- changing `src/relay/prompts.py`
- debugging workflow regressions, provider routing, transcript issues, or PTY-origin behavior
- deciding which tests are most likely to move with a refactor

## You Can Skip The Graph For These Tasks

- docs-only edits
- copy changes or comment-only edits
- obvious one-line fixes in a single file
- small config changes with no cross-module effect

## Standard Graph Workflow

1. `code-review-graph update`
2. `scripts/code_review_graph_report.sh`
3. read the narrowed file set
4. use `rg` for exact strings and symbols
5. make the change
6. re-run `code-review-graph update` if the implementation changed structure

If the graph looks stale or suspicious:

1. `code-review-graph build`
2. `scripts/code_review_graph_report.sh`

## Ignore Rules

- Keep graph scope centered on `src/relay/**` and `tests/**`
- Exclude caches, build output, egg-info, graph output, and docs through [.code-review-graphignore](/Users/family/jason/relay/.code-review-graphignore)
- If docs or generated files start showing up in graph hotspots, tighten the ignore file
- If nearby tests disappear from dependent sets, check whether the ignore file became too aggressive

## Testing Rule

Use the local virtualenv for validation.

Full suite:

```bash
PYTHONPATH=src ./.venv/bin/python -m unittest discover -s tests -v
```

Current known-good result on 2026-03-25:

- `Ran 86 tests`
- `OK`

## High-Value Test Targets

- `tests/test_service.py`
- `tests/test_tui.py`
- `tests/test_workflow_store.py`
- `tests/test_session_host.py`
- `tests/test_repository.py`

## Practical Heuristic

- `rg` for text lookup
- graph for impact lookup
- tests for confidence after the narrowed edit lands

## Docs To Check When Needed

- [docs/ref/ARCHITECTURE.md](/Users/family/jason/relay/docs/ref/ARCHITECTURE.md)
- [docs/ref/CODE-REVIEW-GRAPH-TUNING.md](/Users/family/jason/relay/docs/ref/CODE-REVIEW-GRAPH-TUNING.md)
- [docs/status/PROJECT-STATUS.md](/Users/family/jason/relay/docs/status/PROJECT-STATUS.md)
- [docs/status/TEST-MATRIX.md](/Users/family/jason/relay/docs/status/TEST-MATRIX.md)
