#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: suggest_verify_commands.sh [path ...]

Suggest likely verification commands for the affected paths.
This script does not execute the commands.
Default path: current directory
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
targets=("$@")
if [[ ${#targets[@]} -eq 0 ]]; then
  targets=(".")
fi

resolve_target_dir() {
  local target="$1"
  local candidate

  if [[ "$target" = /* ]]; then
    candidate="$target"
  else
    candidate="$repo_root/$target"
  fi

  if [[ -d "$candidate" ]]; then
    (cd "$candidate" && pwd)
    return
  fi

  if [[ -e "$candidate" ]]; then
    (cd "$(dirname "$candidate")" && pwd)
    return
  fi

  candidate="$(dirname "$candidate")"
  while [[ "$candidate" != "/" && ! -e "$candidate" ]]; do
    candidate="$(dirname "$candidate")"
  done

  if [[ -e "$candidate" ]]; then
    if [[ -d "$candidate" ]]; then
      (cd "$candidate" && pwd)
    else
      (cd "$(dirname "$candidate")" && pwd)
    fi
  else
    echo "$repo_root"
  fi
}

detect_package_manager() {
  local dir="$1"
  if [[ -f "$dir/pnpm-lock.yaml" ]]; then
    echo "pnpm"
  elif [[ -f "$dir/yarn.lock" ]]; then
    echo "yarn"
  elif [[ -f "$dir/bun.lockb" || -f "$dir/bun.lock" ]]; then
    echo "bun"
  else
    echo "npm"
  fi
}

list_manifest_ancestors() {
  local dir="$1"
  while true; do
    for name in package.json pyproject.toml go.mod Cargo.toml Gemfile pom.xml build.gradle build.gradle.kts Makefile docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
      [[ -e "$dir/$name" ]] && echo "$dir/$name"
    done
    for requirements_file in "$dir"/requirements*.txt; do
      [[ -e "$requirements_file" ]] && echo "$requirements_file"
    done
    [[ "$dir" == "$repo_root" || "$dir" == "/" ]] && break
    dir="$(dirname "$dir")"
  done | awk '!seen[$0]++'
}

print_package_json_suggestions() {
  local manifest="$1"
  local dir
  local pkg_manager
  local script_names
  dir="$(dirname "$manifest")"
  pkg_manager="$(detect_package_manager "$dir")"
  script_names="$(grep -Eo '"(lint|test|build|typecheck|check|verify|ci)"[[:space:]]*:' "$manifest" \
    | sed -E 's/"([^"]+)".*/\1/' \
    | sort -u || true)"

  echo "- JS/TS package: $manifest"
  if [[ -n "$script_names" ]]; then
    while IFS= read -r script_name; do
      [[ -z "$script_name" ]] && continue
      echo "  $pkg_manager run $script_name"
    done <<<"$script_names"
  else
    echo "  (no common scripts found; inspect package.json manually)"
  fi
}

print_python_suggestions() {
  local manifest="$1"
  local dir
  dir="$(dirname "$manifest")"

  echo "- Python project: $manifest"
  echo "  pytest"
  grep -qi 'ruff' "$manifest" 2>/dev/null && echo "  ruff check ."
  grep -qi 'mypy' "$manifest" 2>/dev/null && echo "  mypy ."
  grep -qi '\[build-system\]' "$manifest" 2>/dev/null && echo "  python -m build"
  if [[ -f "$dir/requirements.txt" ]]; then
    echo "  pip install -r requirements.txt  # if env is not prepared"
  fi
  return 0
}

print_go_suggestions() {
  local manifest="$1"
  echo "- Go module: $manifest"
  echo "  go test ./..."
  echo "  go vet ./..."
}

print_rust_suggestions() {
  local manifest="$1"
  echo "- Rust crate or multi-package manifest: $manifest"
  echo "  cargo test"
  echo "  cargo clippy --all-targets --all-features"
}

print_make_suggestions() {
  local manifest="$1"
  local targets
  targets="$(grep -E '^(lint|test|build|check|verify|ci):' "$manifest" | cut -d: -f1 | sort -u || true)"
  echo "- Makefile: $manifest"
  if [[ -n "$targets" ]]; then
    while IFS= read -r target; do
      [[ -z "$target" ]] && continue
      echo "  make $target"
    done <<<"$targets"
  else
    echo "  (inspect Makefile targets manually)"
  fi
}

print_container_suggestions() {
  local manifest="$1"
  echo "- Container/runtime manifest: $manifest"
  echo "  docker compose config  # if compose is in scope"
}

for target in "${targets[@]}"; do
  target_dir="$(resolve_target_dir "$target")"

  echo "## Target: $target"
  manifests="$(list_manifest_ancestors "$target_dir")"
  if [[ -z "$manifests" ]]; then
    echo "- No common project manifests found between $target_dir and $repo_root"
    echo
    continue
  fi

  while IFS= read -r manifest; do
    [[ -z "$manifest" ]] && continue
    case "$(basename "$manifest")" in
      package.json) print_package_json_suggestions "$manifest" ;;
      pyproject.toml|requirements.txt|requirements-dev.txt|requirements-test.txt) print_python_suggestions "$manifest" ;;
      go.mod) print_go_suggestions "$manifest" ;;
      Cargo.toml) print_rust_suggestions "$manifest" ;;
      Makefile) print_make_suggestions "$manifest" ;;
      docker-compose.yml|docker-compose.yaml|compose.yml|compose.yaml) print_container_suggestions "$manifest" ;;
      *)
        echo "- Manifest: $manifest"
        ;;
    esac
  done <<<"$manifests"

  echo
done
