# Clean Code Guide

Tài liệu này bổ sung cho `implement-change` khi cần guardrails chi tiết hơn trong lúc code hoặc refactor.

## 1. Scope và layering

- Đặt logic đúng layer, đúng module và đúng boundary trước khi viết code.
- Không sửa nhiều subsystem cùng lúc nếu bài toán chỉ chạm một flow cụ thể.
- Khi cần đi qua nhiều layer, giữ dữ liệu và trách nhiệm rõ ràng giữa các tầng tương đương như handler, use case, service, repository, adapter hoặc UI layer.

## 2. Function shape

- Ưu tiên hàm ngắn, một trách nhiệm chính.
- Dùng early return để giảm nesting.
- Khi logic bắt đầu nhiều nhánh, tách helper theo ý nghĩa nghiệp vụ thay vì nhồi vào một hàm lớn.
- Tránh tên chung chung như `process`, `handle`, `manage` nếu chưa nói rõ hành động thực tế.

## 3. Parameters và types

- Nếu một hàm có quá nhiều tham số hoặc khó nhớ thứ tự, gom thành object có type rõ ràng.
- Tách type/interface đủ nghĩa để lời gọi hàm tự mô tả được intent.
- Dùng constants, enum, helper hoặc DTO sẵn có thay vì lặp magic strings và ad-hoc shapes.

## 4. Side effects

- Ưu tiên pure function khi có thể.
- Không mutate input trừ khi pattern hiện có của codebase yêu cầu như vậy và điều đó đã rõ ràng.
- Khi có state update hoặc I/O, cô lập side effects để dễ test và dễ review.

## 5. Test và verify

- Với logic mới, bugfix hoặc integration thay đổi, thêm hoặc cập nhật test ở mức thấp nhất đủ bắt bug.
- Không viết test lan man ngoài phạm vi thay đổi.
- Sau khi sửa, chạy verify phù hợp với bề mặt bị ảnh hưởng và ghi rõ những gì đã kiểm tra.
