---
name: migration-impact
description: Phân tích hệ quả khi đổi schema, contract, payload, cache keys, env/config hoặc các surface có khả năng gây breaking change. Dùng khi người dùng hỏi “impact”, “nếu đổi cái này thì ảnh hưởng đâu”, “migration risk”, “breaking change”, hoặc khi cần rà backward compatibility trước khi sửa.
---

# Migration Impact

## When to use

- Khi có thay đổi ở schema, contract, payload, key hoặc config có thể ảnh hưởng nhiều thành phần.
- Khi cần biết bề mặt nào sẽ vỡ nếu đổi một field, event hoặc env.
- Khi cần đánh giá backward compatibility và rollout risk trước khi implement.

## How to use

- Xác định đúng điểm thay đổi gốc: DB, DTO, event, cache, env hoặc queue payload.
- Dò các consumer, producer, mapping layer và assumptions liên quan.
- Đối chiếu backward compatibility, migration path và thứ tự rollout an toàn.
- Dùng `references/impact-checklist.md` để rà các lớp ảnh hưởng trước khi chốt kết luận.
- Đọc thêm `references/impact-surfaces.md` khi cần map nhanh những bề mặt thường bị bỏ sót như persisted formats, jobs, config hoặc downstream consumers.

## Output format

- Điểm thay đổi gốc
- Bề mặt bị ảnh hưởng
- Rủi ro compatibility
- Điều kiện rollout / migration
- Verify checklist

## Guardrails

- Không coi một thay đổi là an toàn nếu chưa rà hết producer và consumer chính.
- Không trộn “impact” với “solution design” khi mục tiêu mới là đánh giá ảnh hưởng.
- Không bỏ qua data/backfill/migration order khi thay đổi chạm schema hoặc payload tồn tại lâu.
