---
name: test-strategy
description: Thiết kế chiến lược kiểm thử cho thay đổi code, gồm happy path, unhappy path, regression và mức độ kiểm tra theo subsystem bị ảnh hưởng. Dùng khi cần quyết định nên viết test gì, chọn test level nào, hoặc rerun check nào sau thay đổi; tham khảo references/test-level-guide.md và scripts/list_changed_areas.sh để map rủi ro và changed surface một cách portable.
---

# Test Strategy

## When to use

- Khi chuẩn bị viết test hoặc chốt test scope cho một thay đổi.
- Khi cần xác định test nào phải chạy lại sau khi sửa code.
- Khi muốn bao phủ happy path, unhappy path và edge cases.

## How to use

- Xác định behavior bị ảnh hưởng trước, rồi mới chọn loại test.
- Chia test theo unit, integration, e2e hoặc smoke tùy mức rủi ro.
- Ưu tiên regression test cho phần code đã thay đổi.
- Gắn test với AC thay vì chỉ test implementation.
- Đọc `references/test-level-guide.md` để chốt khi nào nên dùng unit, integration, end-to-end hoặc smoke.
- Khi đang xét một diff thực tế, dùng `scripts/list_changed_areas.sh` để map changed surface trước khi chốt regression scope.

## Output format

- Mục tiêu test
- Nhóm test cần có
- Regression cần chạy lại
- Edge cases đáng chú ý
- Tiêu chí pass/fail

## Guardrails

- Không viết test lan man ngoài phạm vi thay đổi.
- Không bỏ qua unhappy path.
- Không gắn test vào chi tiết implementation nếu behavior đã đủ rõ.
