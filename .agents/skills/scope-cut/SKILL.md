---
name: scope-cut
description: Cắt một feature hoặc task lớn thành phiên bản releaseable nhỏ hơn với must-have, defer list và acceptance boundary rõ ràng.
---

# Scope Cut

## When to use

- Khi feature hoặc task hiện tại quá to để ship an toàn trong một nhịp.
- Khi cần cắt MVP hoặc release slice rõ ràng.
- Khi cần cân bằng giữa tốc độ ship và độ đầy đủ tính năng.

## How to use

- Tóm tắt outcome tối thiểu cần giữ lại.
- Tách phần must-have và defer dựa trên giá trị thực tế.
- Nêu dependency hoặc blocker làm scope phình ra.
- Chốt acceptance boundary để biết khi nào có thể ship.

## Output format

- `Mục tiêu release`
- `Must-have`
- `Defer list`
- `Dependencies / Risks`
- `Acceptance boundary`

## Guardrails

- Không cắt scope theo kiểu làm vỡ flow chính của người dùng mà không nói rõ.
- Không biến scope cut thành roadmap dài hạn.
- Không giữ quá nhiều “nửa vời” khiến version cắt nhỏ không còn dùng được.
