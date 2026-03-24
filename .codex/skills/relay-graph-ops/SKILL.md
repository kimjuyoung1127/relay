---
name: relay-graph-ops
description: Use this skill when working in the relay repository on medium or cross-module code changes, reviews, refactors, or bug fixes and you want to use code-review-graph plus the local report script to narrow scope and pick the most relevant tests.
---

# Relay Graph Ops

Use this skill only for work inside the `relay` repository.

This skill is the project-local overlay for graph-guided work.
It adds `relay`-specific triggers, report commands, and test targets on top of normal `code-review-graph` usage.

## When To Use

Trigger this skill when the task:

- reviews a non-trivial code change
- edits shared runtime paths such as `src/relay/service.py` or `src/relay/tui.py`
- touches persistence, prompts, adapters, or PTY session behavior
- needs blast-radius analysis before a refactor
- needs help choosing the smallest relevant test set

Do not use this skill for:

- docs-only edits
- copy-only changes
- obvious one-line single-file fixes

## Read First

Before doing deeper work, skim these local references:

- [`RELAY.md`](../../../RELAY.md)
- [`docs/ref/CODE-REVIEW-GRAPH-TUNING.md`](../../../docs/ref/CODE-REVIEW-GRAPH-TUNING.md)

## Preconditions

1. Confirm the graph CLI is available.
   - `code-review-graph --help`
2. Confirm the repo graph exists.
   - `code-review-graph status`
3. If the graph is missing or stale:
   - `code-review-graph build`

## Default Workflow

1. Run `code-review-graph update`
2. Run `scripts/code_review_graph_report.sh`
3. Use the report to identify the smallest relevant runtime files and nearby tests
4. Read only that narrowed set first
5. Use `rg` inside that set for exact strings and symbols
6. After edits, run `code-review-graph update` again if structure changed
7. Run the most relevant tests, or the full suite if the change crosses multiple runtime boundaries

If the report looks suspiciously broad or empty:

1. Inspect `.code-review-graphignore`
2. Run `code-review-graph build`
3. Re-run `scripts/code_review_graph_report.sh`

## High-Value Modules

Start with the graph before changing:

- `src/relay/service.py`
- `src/relay/tui.py`
- `src/relay/repository.py`
- `src/relay/workflow_store.py`
- `src/relay/session_host.py`
- `src/relay/adapters.py`
- `src/relay/prompts.py`

## High-Value Test Targets

Prioritize these when the graph points nearby:

- `tests/test_service.py`
- `tests/test_tui.py`
- `tests/test_workflow_store.py`
- `tests/test_session_host.py`
- `tests/test_repository.py`
- `tests/test_adapters.py`
- `tests/test_prompts.py`

Full suite command:

```bash
PYTHONPATH=src ./.venv/bin/python -m unittest discover -s tests -v
```

## Output Shape

When using this skill, summarize findings like this:

```md
Graph status
- ...

Relevant scope
- ...

Likely tests
- ...

Fallback or risks
- ...
```
