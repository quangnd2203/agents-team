# API Docs Alignment Guide

Đọc tài liệu này khi `api-contract` cần so khớp implementation với docs/spec machine-readable hoặc docs sinh tự động.

## 1. Source of truth

- Xác định rõ nguồn chính của contract hiện tại là gì: code-first, schema-first, generated types hay external spec.
- Không coi example docs là source of truth nếu runtime implementation khác.
- Nếu có nhiều nguồn, phải chỉ ra nguồn nào đang đúng và nguồn nào đã drift.

## 2. Những gì cần rà trong docs/spec

- Route hoặc operation name, method, auth requirements.
- Request shape: path, query, headers, body, enums, nullable và optional fields.
- Response shape: success payload, wrapper, pagination, metadata, ack shape.
- Error semantics: status, error code, machine-readable fields, validation format.

## 3. Tình huống thường lệch

- API docs hoặc spec machine-readable không cập nhật sau khi đổi runtime behavior.
- GraphQL schema đúng nhưng resolver trả thêm hoặc thiếu field.
- AsyncAPI hoặc docs event không còn khớp event name, ack hay replay behavior.
- Generated types cập nhật chậm hơn producer hoặc consumer.

## 4. Khi kết luận mismatch

- Nêu rõ mismatch nằm ở implementation, docs/spec hay consumer assumption.
- Chỉ ra file hoặc artifact cụ thể cần sửa.
- Nếu interface đã public, nói rõ compatibility strategy và verify path.
