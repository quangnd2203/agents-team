---
name: codebase-map
description: Quét entrypoints, luồng chạy, ownership và pattern hiện có trong codebase bằng inventory file và tìm kiếm nội dung. Dùng sau khi scope đã rõ và trước khi đề xuất hoặc implement thay đổi, đặc biệt khi cần tìm file tương tự, xác định đúng layer, hoặc hiểu context của subsystem đang bị ảnh hưởng.
---

# Codebase Map

## When to use

- Khi bắt đầu task mới và cần hiểu codebase đang tổ chức thế nào.
- Khi cần tìm file tương đồng trước khi thêm hoặc sửa logic.
- Khi cần xác định pattern đang dùng trong subsystem hoặc module liên quan.

## How to use

1. Inventory nhanh file và path liên quan bằng `scripts/list_targets.sh`; chọn `--mode path`, `--mode content` hoặc `--mode both` theo nhu cầu.
2. Nếu repo có git metadata hữu ích, dùng thêm như tín hiệu bổ sung thay vì coi đó là nguồn duy nhất.
3. Đọc 1-2 file gần nhất với task để nắm pattern thật.
4. Ghi lại các file, layer và luồng gọi chính.

## Output format

- `Entrypoints`
- `Relevant files`
- `Current pattern`
- `Notes / Gaps`

## Guardrails

- Không tự invent pattern mới nếu codebase đã có pattern sẵn.
- Không đề xuất code fix khi chưa map xong codebase.
- Không chỉnh sửa file; chỉ đọc và tổng hợp.
