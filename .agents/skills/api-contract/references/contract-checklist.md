# Contract Checklist

## 1. Interface basics

- Xác định producer, consumer và transport: HTTP, RPC, GraphQL, webhook hay realtime.
- Kiểm tra tên operation hoặc event, auth/preconditions và lifecycle của flow.
- Xác định rõ field bắt buộc, optional, nullable, enum và nested objects.

## 2. Request / input

- Params, headers, query, body hoặc input object có đúng shape không.
- Validation rules và default behavior có khớp giữa hai phía không.
- Có field nào được consumer gửi nhưng producer đã bỏ hoặc đổi nghĩa không.

## 3. Response / output

- Success payload, wrapper, metadata, pagination hoặc ack shape có khớp không.
- Consumer có đang giả định field luôn tồn tại dù runtime có thể trả `null` hoặc thiếu không.
- Error shape, status hoặc code có còn parse được ở consumer không.

## 4. Compatibility

- Có breaking change nào chạm consumer hiện có không.
- Có cần phase tương thích ngược, versioning hoặc dual-write/dual-read không.
- Có batch job, webhook target hoặc integration ngoài codebase cần cập nhật không.

## 5. Verify trước khi chốt

- Implementation, docs/spec và generated types đã đồng bộ.
- Có ít nhất một happy path và một unhappy path được verify.
- Mismatch được quy trách nhiệm rõ cho producer, consumer hoặc docs layer.
