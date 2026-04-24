# Testing Conventions

Đọc tài liệu này khi `test-authoring` cần giữ test nhất quán và portable giữa các codebase.

## 1. Placement

- Ưu tiên đặt test gần code đang được kiểm chứng hoặc theo pattern đã thống nhất trong codebase đang làm.
- Nếu codebase đã có quy ước đặt test riêng, bám theo quy ước đó thay vì tạo cấu trúc mới.

## 2. Determinism

- Test phải độc lập với thời gian, thứ tự chạy và môi trường bên ngoài khi có thể.
- Không để test phụ thuộc DB thật, network thật hoặc service thật nếu mục tiêu chỉ là unit-style verification.
- Dọn state, mock và fixture sau mỗi test để tránh bleed giữa cases.

## 3. Naming and readability

- Tên test phải mô tả được context và kỳ vọng.
- Mỗi test nên chứng minh một behavior rõ ràng thay vì gom nhiều kết luận không liên quan.
- Ưu tiên setup ngắn, explicit và dễ nhìn hơn là helper abstraction quá dày.

## 4. Mock boundaries

- Mock ở boundary ngoài unit đang test, không mock sâu tới mức test chỉ còn xác nhận implementation noise.
- Assert tương tác với dependency khi chính tương tác đó là behavior quan trọng.
- Nếu behavior quan trọng nằm ở integration boundary, cân nhắc chuyển sang integration-style test thay vì mock quá tay.

## 5. Before merge

- Test mới bao phủ đúng behavior hoặc bug đã sửa.
- Fixture, fake data và helper không vô tình hardcode assumption sai.
- Test failure message đủ rõ để người sau debug nhanh.
