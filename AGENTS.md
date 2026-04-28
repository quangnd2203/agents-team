# Repository Instructions

Đây là bộ hướng dẫn nền áp dụng cho mọi agent và mọi session trong repo.
Giữ file này ở mức broad, always-on và chỉ chứa các nguyên tắc áp dụng cho toàn repo.

## Communication

- Luôn dùng tiếng Việt để giao tiếp.
- Nếu phát hiện trade-off đáng kể, trình bày ngắn gọn theo hướng giúp ra quyết định.

## Repo-wide Engineering Rules

- Đặt logic đúng layer và đúng boundary của module; không đi đường tắt qua các tầng không thuộc trách nhiệm của mình.
- Ưu tiên tên hàm, type và biến rõ nghĩa; tránh các tên chung chung như `process`, `handleData`, `doWork`.
- Ưu tiên early return, giảm nesting và tách hàm khi logic bắt đầu dài hoặc nhiều nhánh.
- Khi một hàm có quá nhiều tham số hoặc ý nghĩa không rõ, gói chúng vào object/type có tên rõ ràng.
- Ưu tiên pure function và tránh mutate input nếu không thực sự cần.
- Không hardcode contract, status/error shape hoặc magic values nếu repo đã có DTO, schema, constants hoặc helper sẵn.

## Execution Mindset

- Trước khi code, nêu rõ giả định đang dùng; nếu còn mơ hồ hoặc có nhiều cách hiểu hợp lý, phải nói rõ điểm chưa chắc và trade-off thay vì tự chọn im lặng.
- Ưu tiên cách đơn giản nhất giải quyết đúng bài toán; không thêm feature, abstraction, configurability hoặc defensive handling nếu chưa được yêu cầu.
- Nếu có một hướng làm nhỏ hơn, rõ hơn hoặc ít rủi ro hơn, cần nói ra ngắn gọn trước khi triển khai.
- Nếu bản thân chưa hiểu rõ yêu cầu hoặc boundary của thay đổi, dừng lại để làm rõ thay vì tiếp tục theo suy đoán.

## Change Discipline

- Chỉ sửa đúng phần cần thiết cho bài toán; không tiện tay dọn dẹp, refactor hoặc đổi format ở vùng lân cận nếu không phục vụ trực tiếp cho yêu cầu.
- Giữ style và pattern hiện có của codebase, kể cả khi có thể có cách viết khác quen thuộc hơn.
- Chỉ xoá import, biến, hàm hoặc comment mà chính thay đổi của mình làm dư thừa; không xoá dead code có sẵn nếu chưa được yêu cầu.
- Nếu phát hiện vấn đề ngoài phạm vi đang làm, nêu ra ở phần báo cáo thay vì tự mở rộng diff.

## Goal-Driven Verification

- Trước khi triển khai task nhiều bước, chốt ngắn gọn mục tiêu thành các bước có thể kiểm chứng được.
- Với bugfix, ưu tiên tái hiện lỗi bằng test hoặc bằng bước verify rõ ràng trước, rồi xác nhận sau khi sửa.
- Với thay đổi logic, validation hoặc integration, cần gắn mỗi bước với cách verify tương ứng như test, build hoặc luồng chạy cụ thể.
- Không dừng ở mức "có vẻ đúng"; chỉ kết thúc khi đã có bằng chứng kiểm chứng phù hợp với mức độ rủi ro của thay đổi.

## Instruction Precedence

- Hướng dẫn càng gần vùng code đang sửa thì càng ưu tiên hơn hướng dẫn ở root này.
- Với thay đổi trong `back_end/`, đọc và tuân thủ thêm `back_end/AGENTS.md`.
- Với thay đổi trong `mobile/`, đọc và tuân thủ thêm `mobile/AGENTS.md`.
- Với workflow sâu như implement, contract review hoặc test strategy, dùng skill phù hợp và các reference docs đi kèm thay vì nhồi chi tiết vào file root này.
