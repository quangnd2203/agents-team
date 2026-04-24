---
name: incident-response
description: Triage sự cố, giảm ảnh hưởng tới người dùng, thu bằng chứng và tách bạch mitigation ngắn hạn với fix dài hạn.
---

# Incident Response

## When to use

- Khi production hoặc staging có lỗi diện rộng, downtime hoặc degraded service.
- Khi bug khó tái hiện nhưng ảnh hưởng người dùng thật.
- Khi cần timeline, workaround và hành động sau sự cố.

## How to use

- Ưu tiên giảm ảnh hưởng trước: rollback, disable flow, hoặc cô lập thành phần lỗi.
- Khoanh vùng theo lớp: client, API, data store, cache, queue/realtime, deploy hoặc config/runtime.
- Ghi lại tín hiệu, log và thời điểm để tránh sửa mò.
- Chốt fix ngắn hạn và fix dài hạn riêng.

## Output format

- `Severity`
- `Ảnh hưởng hiện tại`
- `Hành động immediate`
- `Giả thuyết nguyên nhân`
- `Evidence`
- `Next step`

## Guardrails

- Không đề xuất thay đổi lớn khi chưa ổn định hệ thống.
- Không bỏ qua phương án giảm thiểu ảnh hưởng ngay lập tức.
- Không suy đoán nguyên nhân nếu chưa có evidence hoặc repro.
