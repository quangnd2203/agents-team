# Impact Checklist

## 1. Contract surfaces

- Request / response contracts
- Event names và payloads
- Background job payloads
- Cache key format và cached shape

## 2. Data surfaces

- Schema và migration
- Seed hoặc backfill data
- Nullable/optional field semantics
- Enum hoặc constant values đang được persist

## 3. Runtime and config

- Env vars mới/cũ
- Startup assumptions
- Feature flag hoặc rollout order
- Cross-service compatibility nếu có consumer ngoài codebase

## 4. Consumer / producer coupling

- Parsing assumptions của consumer
- Type guards, mapper hoặc adapter đang dùng
- Error shape và loading fallback
- Realtime stale-state hoặc duplicate event handling

## 5. Rollout safety

- Có backward-compatible phase không
- Có cần migration trước deploy hay sau deploy không
- Có rollback path không
- Cần verify gì ngay sau rollout
