---
name: handoff-update
description: Tạo handoff ngắn gọn, action-oriented cho người nhận tiếp theo sau khi phân tích hoặc hoàn tất một phần việc.
---

# Handoff Update

## When to use

- Khi cần bàn giao công việc cho người nhận tiếp theo.
- Khi kết thúc một nhịp làm việc nhưng task chưa đóng hoàn toàn.
- Khi muốn chốt trạng thái hiện tại mà không bắt người sau đọc toàn bộ lịch sử.

## How to use

- Tóm tắt ngắn phần đã làm và trạng thái hiện tại.
- Nêu rõ phần chưa xong, rủi ro còn mở và blocker.
- Liệt kê checks đã chạy và checks còn thiếu.
- Chốt next actions có owner rõ ràng.

## Output format

- `Trạng thái hiện tại`
- `Đã làm`
- `Chưa làm / Rủi ro`
- `Checks đã chạy`
- `Next actions`

## Guardrails

- Không viết handoff kiểu kể chuyện dài dòng.
- Không bỏ sót blocker hoặc assumption có thể làm người nhận hiểu sai.
- Không dùng ngôn ngữ mơ hồ như “gần xong”, “chắc ổn” nếu chưa có tín hiệu xác nhận.
