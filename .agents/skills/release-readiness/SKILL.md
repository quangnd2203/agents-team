---
name: release-readiness
description: Đánh giá một thay đổi có đủ an toàn để release hay không bằng cách kiểm tra build, test, config, migration, rollback và smoke verification. Dùng trước staging hoặc production deploy, trước handoff, hoặc khi cần quyết định go/no-go; tham khảo references/release-gate.md cho checklist release chung.
---

# Release Readiness

## When to use

- Trước khi release môi trường staging, pre-production hoặc production.
- Khi nhiều thành phần đổi cùng lúc và cần quyết định go/no-go.
- Khi phải xác nhận rollback, config và smoke test trước bàn giao.

## How to use

- Kiểm tra build, test và các quality gates tối thiểu của deploy unit bị ảnh hưởng.
- Rà config, secrets, migrations, caches, jobs và external dependencies có thể làm rollout fail.
- Kiểm tra breaking change, compatibility gap và rollback assumptions.
- Chốt smoke flow cần verify ngay sau deploy.
- Đối chiếu `references/release-gate.md` để phân loại must-pass, should-pass và block conditions.

## Output format
- Trạng thái chung
- Pass/fail checklist
- Rủi ro còn mở
- Điều kiện để release
- Next step

## Guardrails

- Không gọi release là an toàn nếu chưa có smoke verification tối thiểu.
- Không bỏ qua rollback path khi thay đổi chạm dữ liệu, runtime hoặc public interface.
- Ưu tiên fact từ build, test, logs, dashboards hoặc change surface thật thay vì cảm tính.
