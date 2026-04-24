# Impact Surfaces

Đọc tài liệu này khi `migration-impact` cần map nhanh các surface thường bị ảnh hưởng bởi breaking change hoặc rollout order.

## 1. Interface surfaces

- HTTP/RPC/GraphQL contracts
- OpenAPI/AsyncAPI/schema artifacts hoặc docs machine-readable khác
- Webhook payloads và callback expectations
- Realtime event names, ack shape, replay hoặc reconnect behavior
- Generated clients, SDKs hoặc schema artifacts

## 2. Data and persistence surfaces

- Database schema, indexes, persisted enums và backfill assumptions
- Cache key format, cached value shape, TTL semantics
- Object storage paths, filenames, metadata shape hoặc exported files
- Serialized payloads sống lâu trong queue, topic hoặc scheduler

## 3. Runtime and config surfaces

- Env vars, feature flags, startup assumptions, secrets và default values
- Job schedule, worker concurrency, retry behavior
- Health checks, rollout order, multi-service compatibility

## 4. Consumer coupling

- UI parsing assumptions, fallback logic, type guards hoặc mappers
- Error shape, wrapper, serializer hoặc adapter layer đang reshape payload
- Batch jobs, reports, admin tools, internal scripts hoặc third-party consumers
- Monitoring, audit hoặc analytics pipelines đang dựa vào field cũ

## 5. Rollout prompts

- Có cần phase tương thích ngược không.
- Có cần migrate data trước, trong hay sau deploy không.
- Có deploy order hoặc smoke check nào phải khóa trước khi release không.
