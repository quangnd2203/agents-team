---
name: implement-change
description: Triển khai thay đổi nhỏ nhất theo đúng pattern hiện có của codebase. Dùng khi requirement đã rõ và cần fix bug, thêm tính năng scoped hoặc refactor an toàn mà không mở rộng phạm vi; tham khảo references/clean-code-guide.md để giữ layering, function shape, side effects và test scope, dùng references/ui-change-guide.md cho UI work, và dùng scripts/suggest_verify_commands.sh để gợi ý checks phù hợp sau khi sửa.
---

# Implement Change

## When to use

- Khi đã rõ yêu cầu và cần bắt tay vào code.
- Khi cần sửa bug, thêm tính năng nhỏ, hoặc refactor có kiểm soát.
- Khi phải bám theo kiến trúc và pattern sẵn có của codebase.

## How to use

- Đọc code liên quan trước, rồi xác định layer đúng chỗ.
- Giữ diff nhỏ, tránh đụng file không liên quan.
- Ưu tiên tái sử dụng pattern, helper, test và naming hiện có.
- Khi sửa logic hoặc refactor hơi sâu, đối chiếu `references/clean-code-guide.md` để giữ layering, naming, side effects và test scope nhất quán.
- Khi thay đổi chạm UI, layout, component styling, motion hoặc design-system behavior, đọc thêm `references/ui-change-guide.md`.
- Sau khi sửa, dùng `scripts/suggest_verify_commands.sh` để lấy checklist verify phù hợp với path hoặc package bị ảnh hưởng, rồi chạy các checks liên quan.

## Output format

- Mục tiêu thay đổi
- File/tầng bị ảnh hưởng
- Cách implement ngắn gọn
- Kiểm tra đã chạy
- Rủi ro còn mở

## Guardrails

- Không tự đổi scope nghiệp vụ.
- Không tạo pattern mới nếu codebase đã có pattern tương tự.
- Không bỏ qua test hoặc kiểm tra cuối.
