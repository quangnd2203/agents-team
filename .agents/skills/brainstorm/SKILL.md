---
name: brainstorm
description: Tạo và so sánh 2-4 phương án giải quyết cho một bài toán trước khi chốt hướng thực thi. Dùng khi cần mở lựa chọn, cân trade-off, hoặc chưa muốn nhảy ngay vào code.
---

# Brainstorm

## When to use

- Khi bài toán đã khá rõ nhưng còn nhiều hướng làm khả thi.
- Khi cần so sánh trade-off trước khi chốt solution.
- Khi người dùng yêu cầu brainstorm, options hoặc trade-off.

## How to use

- Tóm tắt bài toán và ràng buộc chính trong 1 câu.
- Đề xuất 2-4 phương án thực sự khác nhau.
- So sánh theo tiêu chí thực tế: độ phức tạp, rủi ro, thời gian, khả năng mở rộng.
- Chốt một khuyến nghị rõ ràng và nêu bước tiếp theo.

## Output format

- `Bài toán`
- `Các phương án`
- `So sánh trade-off`
- `Khuyến nghị`
- `Next step`

## Guardrails

- Không nhảy vào code hoặc thiết kế chi tiết khi mục tiêu chỉ là mở hướng.
- Không đưa nhiều phương án gần như trùng nhau.
- Không kết luận mơ hồ; khi đủ dữ liệu phải chốt một hướng đề xuất.
