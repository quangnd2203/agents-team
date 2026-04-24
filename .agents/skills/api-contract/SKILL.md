---
name: api-contract
description: Rà và đồng bộ contract giữa producer và consumer của HTTP, RPC, GraphQL, webhook hoặc realtime flow, gồm request/response shape, validation, status hoặc error semantics, generated types, docs/spec drift và client assumptions. Dùng khi API thay đổi, integration bị lệch, hoặc nhiều phía bất đồng về payload hay event shape.
---

# API Contract

## When to use

- Khi interface giữa hai thành phần bị lệch hoặc có nguy cơ lệch sau thay đổi.
- Khi request, response, error shape, enum hoặc event payload vừa được chỉnh sửa.
- Khi docs/spec, generated types và implementation có dấu hiệu không còn đồng bộ.

## How to use

- Xác định producer, consumer và interface đang xét: HTTP, RPC, GraphQL, webhook hay realtime.
- So khớp method hoặc event name, auth/preconditions, params, payload, response hoặc ack, error semantics và optional/nullable fields.
- Kiểm tra consumer đang parse hoặc giả định dữ liệu ra sao, gồm mapper, validator, generated types hoặc fallback logic.
- Đối chiếu backward compatibility, versioning và migration path nếu interface đã có consumer ngoài scope hiện tại.
- Dùng `references/contract-checklist.md` để rà các lớp contract quan trọng.
- Nếu flow có docs/spec machine-readable hoặc docs sinh tự động, đọc thêm `references/api-docs-alignment-guide.md`.

## Output format

- Interface hoặc flow
- Điểm lệch contract
- Ảnh hưởng producer/consumer
- Hướng sửa hoặc migration path
- Test và verify cần bổ sung

## Guardrails

- Không bàn logic nghiệp vụ khi vấn đề thực chất là lệch interface.
- Không đề xuất breaking change nếu chưa nói rõ compatibility strategy.
- Ưu tiên bằng chứng từ code, schema, docs/spec và consumer behavior thật thay vì suy đoán.
