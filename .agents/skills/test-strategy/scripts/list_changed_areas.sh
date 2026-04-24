#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: list_changed_areas.sh [base-ref]

List changed files and top-level areas for a git repository.
- Without arguments: uses working tree, staged changes, and untracked files.
- With [base-ref]: compares base-ref...HEAD.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "This script is git-only and requires a git repository." >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"
base_ref="${1:-}"

if [[ -n "$base_ref" ]]; then
  changed_paths="$(git -C "$repo_root" diff --name-only "${base_ref}...HEAD" | sed '/^$/d' | sort -u)"
else
  changed_paths="$(
    {
      git -C "$repo_root" diff --name-only
      git -C "$repo_root" diff --cached --name-only
      git -C "$repo_root" ls-files --others --exclude-standard
    } | sed '/^$/d' | sort -u
  )"
fi

if [[ -z "$changed_paths" ]]; then
  echo "No changed files detected."
  exit 0
fi

echo "# Changed files"
printf '%s\n' "$changed_paths"
echo

echo "# Top-level areas"
printf '%s\n' "$changed_paths" \
  | awk -F/ '{print (NF > 1 ? $1 : ".")}' \
  | sort -u
