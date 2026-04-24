---
name: bug-investigation
description: Tái hiện lỗi, thu bằng chứng, khoanh vùng nguyên nhân và đề xuất hướng xử lý mà không nhảy thẳng vào fix. Dùng khi bug mới xuất hiện, khó tái hiện hoặc ảnh hưởng rộng.
---

# Bug Investigation

## When to use

- Khi có bug report mới và chưa rõ root cause.
- Khi lỗi xuất hiện ngẫu nhiên hoặc khó tái hiện.
- Khi cần tách symptom, evidence và hypothesis trước khi sửa.

## How to use

1. Tái hiện lỗi bằng bộ bước ngắn nhất có thể.
2. Ghi lại input, log, screenshot, command output hoặc network trace.
3. Khoanh vùng lớp ảnh hưởng: client, API, state, data, cache, realtime hoặc runtime config.
4. So sánh expected vs actual và chốt giả thuyết mạnh nhất hiện có.

## Output format

- `Repro steps`
- `Observed evidence`
- `Likely root cause`
- `Impact`
- `Next action`

## Guardrails

- Không đoán nguyên nhân khi chưa có evidence đủ mạnh.
- Không lẫn symptom với root cause.
- Không tự fix nếu task chỉ yêu cầu điều tra.
