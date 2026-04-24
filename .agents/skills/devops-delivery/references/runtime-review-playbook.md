# Runtime Review Playbook

## 1. Inventory runtime surfaces

- Entrypoints: web app, API service, worker, cron, CLI, admin panel.
- Deploy artifacts: container image, package build, function bundle, VM artifact.
- Delivery layer: CI workflow, deploy script, orchestrator manifest, release job.

## 2. Dependencies and startup

- Runtime dependencies: database, cache, queue, object storage, broker, third-party services.
- Startup order, readiness assumptions và retry behavior.
- Config và secret sources: env vars, secret manager, config file, mounted volume.

## 3. Health and observability

- Health, readiness, liveness, smoke endpoint hoặc equivalent signals.
- Logging, metrics, tracing, alerting hoặc dashboard references.
- Error budget hoặc fail-fast signals nào sẽ cho biết rollout đang có vấn đề.

## 4. Delivery safety

- Build, package và deploy steps có deterministic không.
- Có rollback strategy, config rollback và migration rollback assumptions không.
- Có single point of failure ở pipeline hoặc environment bootstrap không.

## 5. Verify checklist

- Manifest quan trọng và dependency runtime đã được inventory.
- Thay đổi nào là reversible và thay đổi nào không.
- Smoke flow và health signals sau deploy đã được chốt rõ.
