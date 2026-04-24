---
name: test-authoring
description: Viết hoặc bổ sung test cases chất lượng cho code đã có, gồm happy path, unhappy path, edge cases, invalid inputs, exceptions, mocking và naming rõ ràng. Dùng khi người dùng nói “viết test cho tao”, “bổ sung test”, “bao phủ happy path/unhappy path”, “test mấy case đặc biệt”, “thêm edge case, invalid input, exception”, hoặc “mock dependency này giúp tao”.
---

# Test Authoring

## When to use

- Khi đã biết cần test gì và muốn viết bộ test cho ra hồn.
- Khi cần bổ sung các case xấu, case biên hoặc exception mà test hiện tại đang thiếu.
- Khi phải mock dependency để cô lập unit-style test mà vẫn giữ test có giá trị.

## How to use

- Xác định behavior chính trước, rồi mới liệt kê test cases tương ứng.
- Luôn rà ít nhất: happy path, unhappy path, edge cases, invalid inputs và exceptions/error paths.
- Dùng AAA pattern và đặt tên test theo kiểu `should ... when ...`.
- Với unit-style test, cô lập dependency bằng mock/stub phù hợp thay vì chạm DB, network hoặc runtime thật.
- Đối chiếu `references/test-case-checklist.md` để không quên các lớp case xấu, mocking boundaries và naming rules.
- Đọc thêm `references/testing-conventions.md` để giữ placement, naming, determinism và mocking policy nhất quán với codebase đang làm.

## Output format

- Mục tiêu test
- Cases cần có
- Mocks / stubs cần setup
- Assertions chính
- Gaps còn lại

## Guardrails

- Không chỉ viết happy path.
- Không bỏ qua negative cases nếu behavior có thể fail hoặc reject input.
- Không mock quá mức làm test mất giá trị thực tế.
- Không gắn test quá chặt vào implementation detail nếu behavior đã đủ rõ.
- Không gõ DB hoặc network thật trong unit-style test.
