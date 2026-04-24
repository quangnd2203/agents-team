#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: check_runtime_context.sh [root]

Inventory common runtime and delivery artifacts under the given root.
Default root: current directory
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

root_arg="${1:-.}"
if [[ ! -e "$root_arg" ]]; then
  echo "Root path does not exist: $root_arg" >&2
  exit 1
fi
root_dir="$(cd "$root_arg" && pwd)"

list_files() {
  if command -v rg >/dev/null 2>&1; then
    rg --files --hidden \
      -g '!**/.git/**' \
      -g '!**/node_modules/**' \
      -g '!**/dist/**' \
      -g '!**/build/**' \
      -g '!**/.venv/**' \
      -g '!**/coverage/**' \
      -g '!**/.pytest_cache/**' \
      -g '!**/.mypy_cache/**' \
      -g '!**/.ruff_cache/**' \
      -g '!**/__pycache__/**' \
      "$root_dir"
  else
    (
      cd "$root_dir" \
        && find . -type f | sed 's#^\./##' \
        | grep -Ev '^(\.git/|node_modules/|dist/|build/|\.venv/|coverage/|\.pytest_cache/|\.mypy_cache/|\.ruff_cache/|__pycache__/)'
    )
  fi
}

print_section() {
  local title="$1"
  local pattern="$2"
  local matches
  matches="$(printf '%s\n' "$all_files" | grep -E "$pattern" || true)"

  echo "## $title"
  if [[ -n "$matches" ]]; then
    printf '%s\n' "$matches" | head -n 40
  else
    echo "(no matches)"
  fi
  echo
}

all_files="$(list_files)"

echo "# Runtime Context"
echo "# root=$root_dir"
echo

print_section "CI and delivery workflows" '(^|/)(\.github/workflows/.*\.ya?ml|\.gitlab-ci\.yml|azure-pipelines\.ya?ml|Jenkinsfile|buildkite\.yml)$'
print_section "Container and runtime manifests" '(^|/)(Dockerfile[^/]*|docker-compose[^/]*\.ya?ml|compose\.ya?ml|Procfile|Chart\.ya?ml|helmfile\.ya?ml|skaffold\.ya?ml)$'
print_section "Infrastructure as code" '(^|/)(terraform/|.*\.tf$|pulumi\.(ya?ml|json)|serverless\.ya?ml|cdk\.json)$'
print_section "Application manifests" '(^|/)(package\.json|pyproject\.toml|requirements[^/]*\.txt|poetry\.lock|go\.mod|Cargo\.toml|Gemfile|pom\.xml|build\.gradle(\.kts)?|composer\.json)$'
print_section "Config and env examples" '(^|/)(\.env($|\.)|.*env.*example.*|application\.(ya?ml|properties|json)|[^/]*config\.(json|ya?ml|toml|ini|js|ts))$'

if command -v rg >/dev/null 2>&1; then
  echo "## Runtime keywords"
  rg -n --hidden -S \
    -g '!**/.git/**' \
    -g '!**/.gitignore' \
    -g '!**/node_modules/**' \
    -g '!**/dist/**' \
    -g '!**/build/**' \
    -g '!**/.venv/**' \
    -g '!**/coverage/**' \
    -g '!**/.pytest_cache/**' \
    -g '!**/.mypy_cache/**' \
    -g '!**/.ruff_cache/**' \
    -g '!**/__pycache__/**' \
    -g '!**/__tests__/**' \
    -g '!**/*.spec.*' \
    -g '!**/*.test.*' \
    '\bhealth\b|readiness|liveness|metrics|trace|observab|migration|rollback|feature[- ]flag|\bsecret(s)?\b|\bqueue(s)?\b|broker|\bcache(s)?\b|\bdatabase\b' \
    "$root_dir" 2>/dev/null | head -n 40 || echo "(no matches)"
  echo
fi
