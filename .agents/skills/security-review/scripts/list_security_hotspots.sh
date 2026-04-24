#!/usr/bin/env bash

set -euo pipefail

root="${1:-.}"

usage() {
  cat <<'EOF'
Usage: list_security_hotspots.sh [root]

Scan a directory for common security-relevant hotspots.
Default root: current directory
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v rg >/dev/null 2>&1; then
  echo "rg is required for list_security_hotspots.sh" >&2
  exit 1
fi

common_args=(
  --hidden
  -n
  -S
  -g '!**/.git/**'
  -g '!**/.venv/**'
  -g '!**/node_modules/**'
  -g '!**/dist/**'
  -g '!**/build/**'
  -g '!**/__pycache__/**'
  -g '!**/coverage/**'
  -g '!**/__tests__/**'
  -g '!**/*.spec.*'
  -g '!**/*.test.*'
)

print_section() {
  local title="$1"
  local pattern="$2"
  local output=""

  echo "## ${title}"
  if output="$(rg "${common_args[@]}" -e "${pattern}" "${root}" 2>/dev/null)"; then
    printf '%s\n' "${output}" | sed -n '1,40p'
  else
    echo "(no matches)"
  fi
  echo
}

echo "# Security Hotspots"
echo "# root=${root}"
echo

print_section \
  "Identity and access control" \
  'authn|authz|authentication|authorization|login|logout|register|signup|signin|password|session|jwt|oauth|oidc|openid|saml|passport|guard|policy|permission|permissions|role|rbac|acl|csrf|cookie|bearer|refresh[_-]?token|access[_-]?token|nonce'

print_section \
  "Input validation, files, and parsing" \
  'validator|validation|schema|zod|joi|class-validator|ajv|sanitize|escape|deserialize|yaml\.load\(|pickle|multipart|upload|multer|mime|content-type|template|xml|csv'

print_section \
  "Secrets, tokens, and crypto" \
  'secret|api[_-]?key|token|password|private[_-]?key|client[_-]?secret|database_url|redis_url|encrypt|decrypt|hash|bcrypt|argon|pbkdf2|scrypt|hmac|signature|verify'

print_section \
  "Network egress and external integrations" \
  'fetch\(|axios|requests\.|httpx|aiohttp|urllib|urlopen|grpc|webhook|callback|oauth|openid|s3|sns|sqs|pubsub|kafka|rabbit|third[_-]?party|external'

print_section \
  "Persistence, cache, and background execution" \
  'prisma|typeorm|sequelize|mongoose|knex|sqlalchemy|redis|cache|queue|bull|rq|celery|cron|schedule|worker|job|consumer|producer'

print_section \
  "Admin, docs, logging, and debug surfaces" \
  'admin|dashboard|swagger|openapi|graphiql|playground|actuator|metrics|health|logger|logging|audit|trace|debug|console\.log|print\('

print_section \
  "Dangerous execution and shelling out" \
  'eval\(|exec\(|spawn\(|subprocess|os\.system|Runtime\.getRuntime|ProcessBuilder|shell=|bash -c|sh -c'

echo "## Dependency manifests"
if rg --files "${root}" 2>/dev/null | rg '(^|/)(pyproject\.toml|poetry\.lock|requirements[^/]*\.txt|package\.json|package-lock\.json|pnpm-lock\.yaml|yarn\.lock|Dockerfile|docker-compose[^/]*\.ya?ml)$' | sed -n '1,40p'; then
  true
else
  echo "(no matches)"
fi
