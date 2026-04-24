---
name: devops-delivery
description: Rà soát và cải thiện CI/CD, runtime config, deploy safety, health checks, observability và verification flow cho bất kỳ codebase nào. Dùng khi thay đổi pipeline, container/orchestrator setup, env wiring, startup flow hoặc dependency vận hành; dùng references/runtime-review-playbook.md và scripts/check_runtime_context.sh để map bề mặt runtime hiện có.
---

# DevOps Delivery

## When to use

- Khi cần sửa pipeline, deploy flow, startup sequence, env wiring hoặc runtime dependency.
- Khi debug lỗi build, deploy, health check, readiness hoặc config drift.
- Khi cần chốt rollout safety, rollback path và cách verify sau thay đổi hạ tầng.

## How to use

- Xác định deploy unit hoặc runtime surface bị ảnh hưởng: service, worker, job, container, workflow, secret/config hoặc network dependency.
- Inventory nhanh manifest và runtime artifacts bằng `scripts/check_runtime_context.sh`.
- Đọc `references/runtime-review-playbook.md` để rà entrypoint, dependency graph, config, health, observability và rollback assumptions.
- Chỉ đề xuất thay đổi có thể quan sát, kiểm chứng và rollback.
- Nếu có external dependency hoặc managed service, nêu rõ verify path và fail-fast signal.

## Output format

- Scope vận hành
- Vấn đề hoặc risk hiện tại
- Thay đổi đề xuất
- Rủi ro rollout và rollback
- Cách verify

## Guardrails

- Không sửa business logic nếu vấn đề nằm ở runtime, delivery hoặc config.
- Không coi deploy là an toàn nếu chưa có health signal và verify path rõ.
- Ưu tiên thay đổi nhỏ, dễ rollback và có tín hiệu quan sát được.
