# Test Case Checklist

## 1. Happy path

- Case thành công chính của behavior
- Input hợp lệ, dependency hoạt động bình thường
- Output hoặc state change đúng như mong đợi

## 2. Unhappy path

- Input sai hoặc thiếu dữ liệu bắt buộc
- Dependency trả lỗi hoặc reject
- Behavior cần fail rõ ràng thay vì “chết im”

## 3. Edge cases

- Giá trị ranh giới: `0`, `1`, số âm, chuỗi rỗng, mảng rỗng, giá trị rất lớn
- Trạng thái ít gặp nhưng hợp lệ
- Thứ tự dữ liệu, duplicate values hoặc timing-sensitive cases nếu có

## 4. Invalid inputs

- `null`, `undefined`, sai kiểu dữ liệu
- Field thiếu, field thừa, enum sai
- Payload không đúng shape hoặc data không parse được

## 5. Exceptions

- Hàm/service có throw đúng loại lỗi hoặc trả đúng error shape không
- Error message hoặc error code có đủ ý nghĩa để debug không
- Có đảm bảo fail fast ở case không thể tiếp tục không

## 6. Mocking / Stubbing

- Unit-style test không gọi DB thật, network thật hoặc runtime ngoài scope
- Chỉ mock boundary ngoài unit đang test
- Assert cả output lẫn tương tác quan trọng với dependency nếu behavior phụ thuộc vào nó
- Không mock sâu tới mức test chỉ còn xác nhận implementation noise

## 7. Naming

- Ưu tiên dạng `should ... when ...`
- Mỗi test nên nói rõ ngữ cảnh và kỳ vọng
- Không dùng tên mơ hồ như `works correctly` hoặc `test case 1`

## 8. AAA pattern

- Arrange: setup input, mocks, state ban đầu
- Act: gọi đúng behavior cần test
- Assert: kiểm tra output, thrown error hoặc side effect cần thiết
