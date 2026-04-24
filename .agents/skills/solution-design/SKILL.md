---
name: solution-design
description: Chốt một hướng thực thi thành thiết kế kỹ thuật ngắn gọn, action-oriented trước khi implement.
---

# Solution Design

## When to use

- Khi đã có hướng làm sơ bộ và cần biến nó thành thiết kế kỹ thuật cụ thể.
- Khi cần chốt modules, boundaries, data flow và các điểm sẽ phải sửa trước khi code.
- Khi muốn tránh nhảy thẳng vào implement khi execution shape chưa rõ.

## How to use

- Tóm tắt bài toán và mục tiêu thiết kế.
- Nêu modules hoặc flows bị ảnh hưởng, cùng boundary chính cần giữ.
- Chốt data flow, contract impact, state change hoặc persistence impact.
- Gắn thiết kế với rollout, test implications và rủi ro chính.

## Output format

- `Bối cảnh`
- `Thiết kế đề xuất`
- `Modules / flows ảnh hưởng`
- `Contract / data impact`
- `Test / rollout notes`

## Guardrails

- Không sa vào tutorial hoặc listing file quá chi tiết khi chưa cần.
- Không lặp lại việc map codebase nếu hiện trạng chưa rõ; lúc đó dùng `codebase-map` trước.
- Không để design mơ hồ tới mức implementer vẫn phải tự quyết định các điểm chính.
