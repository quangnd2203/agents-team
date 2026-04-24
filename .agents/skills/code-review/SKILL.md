---
name: code-review
description: Review diff và pull request theo hướng findings-first, ưu tiên correctness, regression, security, compatibility và thiếu test trước khi merge.
---

# Code Review

## When to use

- Khi cần review PR, patch, hoặc diff trước khi merge.
- Khi muốn tìm bug, regression, hoặc rủi ro kỹ thuật.
- Khi cần một lượt phản biện độc lập trước release.

## How to use

- Đọc scope thay đổi và các luồng thực thi bị ảnh hưởng.
- Tập trung vào lỗi logic, edge case, security và compatibility.
- Đối chiếu với test hiện có để chỉ ra khoảng trống kiểm thử.
- Báo cáo findings theo mức độ ảnh hưởng thực tế.

## Output format

- `Finding`
- `Mức độ`
- `File/điểm ảnh hưởng`
- `Vì sao là rủi ro`
- `Gợi ý fix hoặc test`

## Guardrails

- Không nhận xét chung chung nếu không có impact rõ.
- Không bỏ qua missing test ở chỗ thay đổi có rủi ro.
- Không ưu tiên style hơn correctness.
