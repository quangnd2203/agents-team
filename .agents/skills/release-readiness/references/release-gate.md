# Release Gate

## Must pass

- Build hoặc package verification liên quan tới deploy unit phải pass.
- Tests ở các flow bị ảnh hưởng hoặc risk cao phải pass hoặc có lý do miễn trừ rõ ràng.
- Config, secrets, migrations và external dependencies đã được kiểm tra đủ để rollout.
- Có rollback path hoặc mitigation path rõ cho thay đổi khó đảo ngược.
- Có ít nhất một smoke verification plan cho các flow quan trọng sau deploy.

## Should pass

- Docs, specs, dashboards hoặc runbook được cập nhật nếu change surface chạm vào chúng.
- Observability signals liên quan đã được xác định trước rollout.
- Compatibility risk với downstream consumers đã được rà hoặc có phase tương thích.

## Block release when

- Có failure đỏ ở change surface liên quan mà chưa có mitigation đáng tin cậy.
- Chưa hiểu rõ blast radius, migration order hoặc rollback story.
- Thay đổi public interface nhưng consumer chưa sẵn sàng hoặc chưa có compatibility plan.
- Thiếu smoke flow hoặc thiếu tín hiệu để biết rollout đang fail.
