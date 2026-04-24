# Security Review Playbook

## 1. Scope Fast

- Xác định runtime boundary: HTTP, WebSocket, RPC, queue/consumer, worker, cron, CLI, admin UI, webhook, IaC hoặc pipeline.
- Xác định crown-jewel assets: credential, token, secret, PII/PHI, payment data, internal URL, uploaded file, privileged action, audit data.
- Xác định actors: anonymous, authenticated user, tenant user, admin, service account, internal worker, third-party callback.

## 2. Map Trust Boundaries

- Entry points: controller, route, gateway, resolver, webhook, job consumer, file ingestion, template rendering, admin panel.
- Controls cần kiểm tra: authn, authz, tenant scoping, validation, sanitization, rate limiting, CSRF, CORS, cookie flags, idempotency, replay protection.
- Sensitive sinks: database, cache, object storage, filesystem, queue, log, analytics, outbound HTTP, internal metadata service, shell/process execution.

## 3. Review High-Risk Surfaces

- Authn/Authz
  Missing server-side ownership check, privilege escalation, weak session invalidation, trust sai vào third-party identity claim, privilege boundary drift giữa UI và backend.
- Input, injection and parser risk
  SQL/NoSQL injection, command injection, SSRF, path traversal, template injection, unsafe deserialization, archive extraction, file-type confusion, parser abuse.
- Secrets and crypto
  Hardcoded secrets, exposed env, weak hashing, missing key separation, unsigned/weakly verified token, crypto misuse, insecure randomness.
- Data exposure
  Sensitive field trong response, token/password trong log, verbose error leak, unauthenticated docs/admin/debug surface, public asset/storage leak.
- Network egress and integrations
  Unsafe callback/webhook handling, untrusted outbound fetch, SSRF through user-controlled URL, third-party auth/account-linking mistakes.
- Availability and abuse
  Brute force, missing throttling, unbounded upload/job, expensive query fan-out, cache stampede, broadcast amplification, replay spam.
- Dependencies and supply chain
  Vulnerable package, risky postinstall/build hook, broad CI secret exposure, unpinned base image/action, stale runtime dependency.

## 4. Evidence Standard

- Chỉ nâng thành finding khi chỉ ra được code path hoặc config path cụ thể.
- Nêu rõ attacker precondition, affected actor và blast radius.
- Phân biệt rõ theoretical concern với reachable issue.
- Ghi rõ test hoặc validation còn thiếu nếu finding dựa trên gap coverage.

## 5. High-Signal Questions

- Caller có thể tác động lên resource của người khác hoặc tenant khác không?
- Untrusted input có chạm tới sink mạnh như DB query, shell, template, parser, internal network hoặc file system không?
- Secret hoặc sensitive data có băng qua trust boundary sai chỗ không?
- Low-privileged actor có thể chạm admin, config, debug, docs hoặc observability surface không?
- Change này có mở rộng public exposure, bypass guard hoặc kéo dài session/token lifetime ngoài ý định không?

## 6. Reporting Notes

- Findings đứng trước summary.
- Nếu không có finding, nói rõ "không thấy finding bảo mật có thể xác nhận từ phần đã review".
- Luôn nêu residual risk khi scope chỉ là partial diff hoặc chưa có runtime verification.
