---
name: clean-code
description: Rà và cải thiện chất lượng code theo hướng clean code, maintainability và change safety. Dùng khi chuẩn bị implement, refactor, review diff, hoặc khi thấy logic phình to, naming mơ hồ, layer chồng chéo, side effect khó kiểm soát, test khó viết hay scope thay đổi có nguy cơ trôi.
---

# Clean Code

## When to use

- Khi cần một lượt sanity check trước khi bắt đầu code hoặc refactor.
- Khi diff bắt đầu lớn, khó đọc, khó test hoặc đụng nhiều layer.
- Khi muốn review lại code theo hướng maintainability thay vì chỉ style.

## How to use

- Xác định scope thay đổi và boundary bị ảnh hưởng trước khi bàn tới style.
- Đọc flow hiện có để phân biệt phần nào là logic nghiệp vụ, orchestration, I/O, mapping hoặc UI state.
- Đối chiếu thay đổi với `references/clean-code-checklist.md`.
- Nếu task là implement thực tế, dùng skill này để chốt guardrails rồi chuyển sang `implement-change`.
- Nếu task là review diff, báo findings theo impact thực tế thay vì ghi nhận xét chung chung.

## Review flow

1. Chốt mục tiêu thay đổi và thứ không nên đổi.
2. Kiểm tra layer và ownership của code có đúng chỗ không.
3. Kiểm tra function shape, naming, type shape và branching.
4. Kiểm tra side effects, error handling, logging và data mutation.
5. Kiểm tra testability, verify path và khả năng mở rộng sau thay đổi.

## Output format

- Mục tiêu thay đổi
- Điểm sạch
- Điểm chưa sạch
- Rủi ro nếu giữ nguyên
- Đề xuất cắt gọn hoặc tách trách nhiệm
- Checklist còn mở

## Guardrails

- Không biến clean code thành đổi style hàng loạt ngoài phạm vi.
- Không tạo abstraction mới nếu chưa có áp lực lặp lại hoặc boundary thật sự.
- Không tách file chỉ để làm code ngắn hơn nếu ownership trở nên mơ hồ.
- Không hy sinh correctness, test coverage hoặc DX để đổi lấy “đẹp”.
