#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: list_targets.sh [--mode path|content|both] [--regex] <keyword...>

Search files by path, content, or both.
Works in git repos and plain directories.
By default, keywords are matched as literal terms.
Use --regex to opt into regular-expression matching.
Default mode: both
EOF
}

mode="both"
use_regex="false"

while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    -h|--help)
      usage
      exit 0
      ;;
    --mode)
      [[ $# -ge 3 ]] || {
        usage >&2
        exit 1
      }
      mode="$2"
      shift 2
      ;;
    --regex)
      use_regex="true"
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -eq 0 ]]; then
  usage >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
patterns_file="$(mktemp)"
trap 'rm -f "$patterns_file"' EXIT
printf '%s\n' "$@" >"$patterns_file"

search_with_patterns() {
  local stdin_content="$1"

  if [[ "$use_regex" == "true" ]]; then
    printf '%s\n' "$stdin_content" | rg --no-heading --color=never --no-messages -f "$patterns_file"
  else
    printf '%s\n' "$stdin_content" | rg --no-heading --color=never --no-messages -F -f "$patterns_file"
  fi
}

search_path() {
  local files
  (
    cd "$repo_root"
    files="$(
      rg --files --hidden \
        -g '!**/.git/**' \
        -g '!**/node_modules/**' \
        -g '!**/dist/**' \
        -g '!**/build/**' \
        -g '!**/.venv/**' \
        -g '!**/coverage/**'
    )"
    search_with_patterns "$files"
  ) || true
}

search_content() {
  (
    cd "$repo_root"
    if [[ "$use_regex" == "true" ]]; then
      rg -n --hidden -S \
        -g '!**/.git/**' \
        -g '!**/node_modules/**' \
        -g '!**/dist/**' \
        -g '!**/build/**' \
        -g '!**/.venv/**' \
        -g '!**/coverage/**' \
        -f "$patterns_file"
    else
      rg -n --hidden -S -F \
        -g '!**/.git/**' \
        -g '!**/node_modules/**' \
        -g '!**/dist/**' \
        -g '!**/build/**' \
        -g '!**/.venv/**' \
        -g '!**/coverage/**' \
        -f "$patterns_file"
    fi
  ) || true
}

case "$mode" in
  path)
    search_path
    ;;
  content)
    search_content
    ;;
  both)
    echo "Path matches:"
    search_path
    echo
    echo "Content matches:"
    search_content
    ;;
  *)
    echo "Invalid mode: $mode" >&2
    usage >&2
    exit 1
    ;;
esac
