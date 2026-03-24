#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
db_path="$repo_root/.code-review-graph/graph.db"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 1
  fi
}

strip_repo_prefix() {
  sed "s#^$repo_root/##"
}

sql() {
  sqlite3 -cmd '.timeout 2000' "$db_path" "$1"
}

print_section() {
  printf '\n%s\n' "$1"
}

report_dependents() {
  local module="$1"
  local rows
  rows="$(sql "SELECT DISTINCT file_path FROM edges WHERE kind='IMPORTS_FROM' AND target_qualified='$module' ORDER BY file_path;")"

  printf '%s\n' "$module"
  if [[ -z "$rows" ]]; then
    printf '  dependents: none\n'
    return
  fi

  local count
  local test_count
  count="$(printf '%s\n' "$rows" | sed '/^$/d' | wc -l | tr -d ' ')"
  test_count="$(printf '%s\n' "$rows" | strip_repo_prefix | grep -c '^tests/' || true)"
  printf '  dependent files: %s\n' "$count"
  printf '  test files: %s\n' "$test_count"
  printf '%s\n' "$rows" | strip_repo_prefix | sed 's#^#  - #'
}

require_cmd code-review-graph
require_cmd sqlite3

if [[ ! -f "$db_path" ]]; then
  echo "graph database not found at $db_path" >&2
  echo "run 'code-review-graph build' first" >&2
  exit 1
fi

printf 'relay code-review-graph report\n'
printf 'repo: %s\n' "$repo_root"
printf 'generated: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"

print_section 'Graph status'
code-review-graph status

print_section 'Top files by node count'
sql "SELECT file_path, COUNT(*) AS node_count FROM nodes GROUP BY file_path ORDER BY node_count DESC LIMIT 10;" \
  | strip_repo_prefix \
  | awk -F'|' '{printf "%3s  %s\n", $2, $1}'

print_section 'Top files by edge count'
sql "SELECT file_path, COUNT(*) AS edge_count FROM edges GROUP BY file_path ORDER BY edge_count DESC LIMIT 10;" \
  | strip_repo_prefix \
  | awk -F'|' '{printf "%4s  %s\n", $2, $1}'

print_section 'Representative module dependents'
report_dependents 'relay.service'
report_dependents 'relay.tui'
report_dependents 'relay.workflow_store'
report_dependents 'relay.session_host'
report_dependents 'relay.repository'
report_dependents 'relay.prompts'
report_dependents 'relay.adapters'

print_section 'Quick interpretation'
printf '%s\n' '- Healthy reports keep hotspots centered on src/relay/** and tests/**.'
printf '%s\n' '- If docs, caches, or build output appear above, tighten .code-review-graphignore.'
printf '%s\n' '- If a critical module loses nearby tests, inspect whether ignore rules became too aggressive.'
