# Test Level Guide

## 1. Unit test

- Dùng khi thay đổi nằm trong logic cục bộ, pure function, mapper, validator hoặc service nhỏ.
- Phù hợp khi muốn bắt regression nhanh và cô lập nguyên nhân.

## 2. Integration test

- Dùng khi behavior phụ thuộc nhiều layer hoặc boundary như DB, cache, queue, HTTP client, adapter hoặc auth policy wiring.
- Phù hợp khi unit test không đủ chứng minh flow thật.

## 3. End-to-end test

- Dùng cho user flow hoặc system flow quan trọng cần chứng minh wiring từ đầu tới cuối.
- Không cần bao phủ mọi nhánh bằng e2e; chỉ chọn flow đại diện và rủi ro cao.

## 4. Smoke test

- Dùng để xác nhận build, startup, deploy hoặc flow chính vẫn sống sau thay đổi.
- Hữu ích cho release gate, migration hoặc runtime config changes.

## 5. Exemption prompts

- Có thể miễn test mới khi thay đổi thật sự không đổi behavior và risk thấp.
- Nếu miễn, phải nói rõ vì sao và verify nào thay thế cho test coverage.

## 6. Choosing reruns

- Rerun ít nhất các checks bảo vệ bề mặt bị ảnh hưởng trực tiếp.
- Nếu thay đổi chạm public interface, data format hoặc runtime wiring, mở rộng verify hơn phạm vi file đã sửa.
