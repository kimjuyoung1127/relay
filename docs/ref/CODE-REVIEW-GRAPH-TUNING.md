# relay Code Review Graph Tuning

This document defines a practical tuning loop for `code-review-graph` in `relay`.

The goal is not to maximize graph size.
The goal is to keep the graph focused on authored Python code and tests so review scope becomes smaller, faster, and easier to explain.

## Current Baseline

Verified on 2026-03-25 after adding [.code-review-graphignore](./.code-review-graphignore):

- `Languages: python`
- `Files: 25`
- `Nodes: 404`
- `Edges: 4289`

Current hotspot files by graph size:

- `src/relay/tui.py`
- `src/relay/service.py`
- `tests/test_tui.py`
- `tests/test_service.py`
- `src/relay/repository.py`
- `src/relay/workflow_store.py`

That shape is healthy for this repository.
It means the graph is focusing on the runtime orchestration layer and the tests most likely to move with those changes.

## What Good Looks Like

Treat the setup as healthy when these conditions stay true:

- `code-review-graph status` reports only `python`
- file count stays close to authored runtime code plus tests, not docs or caches
- top files are runtime modules and tests, not generated output
- critical modules surface at least one related test file in their dependent set
- broad workflow changes narrow quickly to a small file list before using `rg`

## What Bad Looks Like

Retune `.code-review-graphignore` if you see any of these:

- docs start appearing in hotspot tables
- generated or cache paths dominate edge counts
- file count jumps sharply after a build with no real code growth
- critical modules stop surfacing nearby tests
- `watch` becomes noisy because non-source files are updating constantly

## Benchmark Scenarios

Use these as the default tuning checks for `relay`.

### 1. Workflow orchestration change

Target module:
- `relay.service`

Healthy dependent set:
- `src/relay/cli.py`
- `src/relay/tui.py`
- `tests/test_service.py`
- `tests/test_tui.py`

Why it matters:
- `service.py` is the handoff and execution core, so graph results should include both runtime callers and nearby regression tests.

### 2. Shell and transcript regression

Target module:
- `relay.tui`

Healthy dependent set:
- `src/relay/cli.py`
- `tests/test_tui.py`

Why it matters:
- TUI regressions should stay tightly scoped instead of dragging in unrelated docs or storage code.

### 3. Workflow persistence change

Target module:
- `relay.workflow_store`

Healthy dependent set:
- `src/relay/tui.py`
- `tests/test_tui.py`
- `tests/test_workflow_store.py`

Why it matters:
- workflow state bugs often show up through the shell before they are obvious in persistence code.

### 4. PTY-origin debugging

Target module:
- `relay.session_host`

Healthy dependent set:
- `src/relay/tui.py`
- `tests/test_session_host.py`

Why it matters:
- PTY-origin work is riskier and the graph should help keep the file set small.

### 5. Storage and prompt cleanup changes

Target modules:
- `relay.repository`
- `relay.prompts`
- `relay.adapters`

Healthy dependent sets:
- `relay.repository`
  - `src/relay/service.py`
  - `tests/test_repository.py`
  - `tests/test_service.py`
  - `tests/test_tui.py`
- `relay.prompts`
  - `src/relay/service.py`
  - `src/relay/tui.py`
  - `tests/test_prompts.py`
- `relay.adapters`
  - `src/relay/service.py`
  - `src/relay/tui.py`
  - `tests/test_adapters.py`
  - `tests/test_service.py`

Why it matters:
- these are cross-cutting modules where graph quality is more useful than raw text search.

## Tuning Loop

1. Run `code-review-graph update`
2. Run `scripts/code_review_graph_report.sh`
3. Compare the hotspot tables and dependent sets to the healthy baselines above
4. If noise appears, tighten [.code-review-graphignore](./.code-review-graphignore)
5. If a valid source area disappears, loosen the ignore rules
6. Re-run `code-review-graph build`
7. Re-run `scripts/code_review_graph_report.sh`

## Repeatable Commands

```bash
code-review-graph status
code-review-graph update
scripts/code_review_graph_report.sh
```

If the graph needs a clean rebuild:

```bash
code-review-graph build
scripts/code_review_graph_report.sh
```

## Notes About Tests

The repository includes test files under [tests](./tests), but `pytest` is not currently installed in the local `.venv`, so automated pytest execution was not available during this setup pass.

That does not block graph tuning.
For this workflow, "tests" means:

- the graph should keep nearby test files visible
- the report should make it obvious when a runtime module has lost test adjacency
- once `pytest` is installed, the same benchmark scenarios can be paired with targeted test runs

Recommended follow-up after `pytest` is available:

- `tests/test_service.py`
- `tests/test_tui.py`
- `tests/test_workflow_store.py`
- `tests/test_session_host.py`
- `tests/test_repository.py`

## Recommended Rule

For `relay`, use the graph first when a change crosses UI, orchestration, persistence, prompts, adapters, or PTY boundaries.
Use `rg` after the graph narrows the file set.
