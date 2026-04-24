# OWASP Security Review Checklist

Reference này tóm tắt từ các nguồn chính thống sau:

- OWASP ASVS 5.0.0
- OWASP Top 10:2025
- OWASP Secure Code Review Cheat Sheet
- OWASP Authentication Cheat Sheet
- OWASP Authorization Cheat Sheet
- OWASP Input Validation Cheat Sheet
- OWASP File Upload Cheat Sheet
- OWASP Logging Cheat Sheet
- OWASP Secrets Management Cheat Sheet
- OWASP SSRF Prevention Cheat Sheet
- OWASP Vulnerable Dependency Management Cheat Sheet

## Các nguyên tắc nên nhớ

- Baseline review: hiểu architecture, asset quan trọng, trust boundary, dependency, requirement, finding cũ.
- Diff review: ưu tiên file vừa đổi, trust boundary mới, integration mới, dependency mới, risk regression.
- Check security control ở server-side và persistence layer, không dựa vào UI.
- Findings phải có exploit path hoặc regression path rõ ràng.

## Checklist theo bề mặt

### 1. Authentication

- Credentials/token chỉ được đi qua kênh bảo mật và không lộ qua log/error.
- Action nhạy cảm cần có cơ chế re-auth hoặc step-up auth nếu flow yêu cầu.
- Lỗi auth phải fail safely, tránh user enumeration và tránh leak chi tiết nội bộ.
- Session/token phải có lifecycle rõ: issue, rotate, revoke, expire.

### 2. Authorization

- Permission check phải diễn ra trên mọi request/resource quan trọng, không chỉ ở UI.
- Mặc định deny-by-default, least privilege, check đúng tenant/object ownership.
- Static resource, export, artifact download, admin action đều phải được check authz.
- Authz failure cần được log và có test case regression.

### 3. Input validation và injection

- Mọi input không tin cậy cần được validate ở server-side sớm nhất có thể.
- Tách rõ syntactic validation và semantic validation.
- Ưu tiên allowlist, type/schema/range/length checks; denylist chỉ là lớp bổ sung.
- Tìm các điểm string concat cho query/command/path/template/URL.
- Cảnh báo regex phức tạp có nguy cơ ReDoS.

### 4. Upload, file, parser, artifact

- Chỉ allow business-critical file type, validate extension, MIME, signature, size.
- Đổi tên file trên storage bằng tên do server sinh ra; không tin filename hay path từ user.
- Temp file, extract, parse, image/doc processing đều là bề mặt untrusted.
- Store file ở nơi tách biệt, tránh public raw serving mặc định, siết permissions.
- Check upload/download authz, size limit, cleanup path, parser bomb, traversal.

### 5. Logging và monitoring

- Nhất quyết log auth failure, authz failure, input validation failure, high-risk admin action, file upload event, external service failure.
- Log cần có "when / where / who / what" để điều tra được.
- Không log password, access token, session id, DB connection string, encryption key, PII/PHI, transcript/audio raw nếu không được phép rõ ràng.
- Tách security signal với debug noise để tránh alarm fog.

### 6. Secrets và outbound provider egress

- Không hardcode secret trong code, config sample, test fixture, README, error string.
- Ưu tiên centralized storage, least privilege, automation, rotation; dynamic/short-lived secret tốt hơn nếu khả thi.
- Check env gate, feature flag và explicit opt-in trước khi gửi data nhạy cảm ra external provider.
- Check retry/error path để đảm bảo token, payload và transcript không bị leak.

### 7. SSRF và external call

- Nếu đích đến đã biết trước, ưu tiên allowlist host/domain/IP và tắt redirect theo mặc định.
- Validate scheme/host/IP bằng parser/library đáng tin cậy; không rely vào string match thủ công.
- Chặn private/internal/meta-data endpoint ở app layer và network layer nếu có thể.
- Watch webhook, callback URL, image import, file download, provider proxy flow.

### 8. Dependency và supply chain

- Bật dependency scanning sớm; không đợi đến cuối project mới xử lý.
- Nếu đã có patch, ưu tiên nâng version và rerun test.
- Nếu chưa có patch, thêm protective wrapper/mitigation sát bề mặt sử dụng và document rõ lý do.
- Scope ignore chỉ đến từng CVE cụ thể, không ignore nguyên package một cách mơ hồ.
- Check transitive dependency, package source, provenance, lockfile, và thay đổi runtime image.

## Severity heuristic

- `Critical`: đường dẫn để leo thang đặc quyền, RCE/deserialization, public leak transcript/audio/secret/PHI.
- `High`: authz bypass, unsafe external egress, SSRF vào nội bộ, log/storage lộ dữ liệu nhạy cảm, vulnerable dependency reachable trên critical path.
- `Medium`: control thiếu hoặc yếu trên bề mặt nhạy cảm, cleanup/redaction không đầy đủ, missing regression test ở path rủi ro cao.
- `Low`: gap phòng thủ bổ sung, exploitability hạn chế, impact thấp.

## Nguồn chính thống

- https://owasp.org/www-project-application-security-verification-standard/
- https://owasp.org/Top10/2025/
- https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html
- https://cheatsheetseries.owasp.org/cheatsheets/Vulnerable_Dependency_Management_Cheat_Sheet.html
