---
name: security-review
description: Rà code, config, env wiring, data flow, dependency và thay đổi release theo hướng appsec findings-first. Dùng khi cần một lượt security review chuyên nghiệp cho diff, subsystem hoặc release ở bất kỳ codebase nào, đặc biệt quanh auth, authorization, validation, xử lý file, secret, logging, network egress, admin surface, thực thi không an toàn hoặc lộ dữ liệu nhạy cảm.
---

# Security Review

## When to use

- Khi cần một lượt appsec review tập trung cho diff, PR, subsystem hoặc release.
- Khi thay đổi chạm auth/authz, token/session/cookie, file upload, parser, secret, external provider, admin surface, logging, queue, config hoặc dependency.
- Khi người dùng nói `security review`, `appsec pass`, `hardening review`, `security gate` hoặc muốn review trước merge/deploy.

## Chế độ review

- `diff-based`: review thay đổi hiện tại và các flow lân cận có thể bị ảnh hưởng.
- `baseline`: review một subsystem hoặc service như một bề mặt độc lập.
- `release-gate`: đánh giá mức sẵn sàng trước staging/production.
- `hotspot`: đào sâu một bề mặt như auth, SSRF, upload, deserialization, secret handling hoặc admin exposure.

## How to use

- Khóa scope trước: changed paths, runtime entrypoints, deployment surface, dữ liệu nhạy cảm và trust boundaries chính.
- Dựng attack surface nhanh bằng `scripts/list_security_hotspots.sh`; có thể truyền thêm path để giới hạn scope.
- Đọc `references/security-review-playbook.md` để rà các trust boundary, sink và câu hỏi review phổ quát.
- Đọc `references/owasp-review-checklist.md` khi cần checklist sâu hơn theo category.
- Nếu codebase hoặc tổ chức có threat model, hotspot doc hoặc security policy riêng, đọc thêm sau playbook chung chứ không thay thế nó.
- Ưu tiên bề mặt reachable trước: request handler, webhook, gateway/RPC consumer, background job, admin route, storage adapter, external call, parser và auth policy.
- Với mỗi nghi vấn, trace end-to-end: source, validation/policy, sink, exploit preconditions, blast radius và guard hiện có.
- Chỉ report finding có risk thực tế hoặc regression risk rõ ràng. Tách blocking finding khỏi ghi chú hardening mang tính advisory.
- Nếu không có finding, nói rõ phạm vi đã review, residual risk và test/verification gap còn mở.

## Hướng dẫn mức độ

- `Critical`: compromise dễ khai thác với impact thảm họa như account takeover hàng loạt, secret compromise diện rộng hoặc internet-facing RCE.
- `High`: exploit credible với authz bypass, unsafe admin exposure, SSRF/RCE, broad sensitive-data access hoặc token/session compromise đáng kể.
- `Medium`: weakness có impact rõ nhưng cần precondition, actor đặc biệt hoặc blast radius hạn chế hơn.
- `Low`: defense-in-depth gap hoặc hardening miss có exploitability thấp nhưng vẫn nên sửa.

## Output format

- `Finding`
- `Severity`
- `Bằng chứng / bề mặt bị ảnh hưởng`
- `Kịch bản khai thác hoặc failure`
- `Vì sao đáng lo`
- `Hướng sửa / cách xác minh`

## Guardrails

- Không suy đoán lỗ hổng nếu chưa có evidence từ code, config, test hoặc runtime flow.
- Không biến style nit hoặc generic best practice thành finding nếu không làm đổi security posture.
- Không tin frontend-only controls, hidden UI, disabled button hoặc comments/docs claim; luôn xác minh enforcement ở server/policy boundary thật.
- Không dừng ở validation đầu vào; phải follow dữ liệu tới storage, log, cache, queue, template, outbound call và admin/reporting surfaces.
- Không kết luận "đã an toàn vì dùng library X"; phải xác minh library đó được wire đúng và đúng boundary.
