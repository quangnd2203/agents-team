# Clean Code Checklist

Dùng checklist này để soi một thay đổi trước khi merge hoặc trước khi bắt đầu refactor sâu.

## 1. Scope và ownership

- Mục tiêu thay đổi có viết được trong 1-2 câu không.
- Diff có bám đúng một flow hoặc một nhóm concern gần nhau không.
- Logic đang nằm đúng module và đúng layer chưa.
- Có đụng sang subsystem khác chỉ vì tiện tay không.

## 2. Layering và data flow

- Handler, controller, page hoặc action có đang ôm nghiệp vụ quá nhiều không.
- Service hoặc use case có lẫn chi tiết persistence, transport hoặc UI state không.
- Repository, adapter hoặc gateway có giữ đúng trách nhiệm I/O không.
- Dữ liệu đi qua các tầng có bị méo shape hoặc map lặp lại nhiều lần không.

## 3. Naming và intent

- Tên hàm, biến, type có nói rõ intent nghiệp vụ không.
- Có tên mơ hồ như `data`, `item`, `temp`, `process`, `handleStuff` không.
- Tên có phản ánh đúng side effect, ví dụ `load`, `build`, `save`, `publish` không.

## 4. Function shape

- Mỗi hàm có một trách nhiệm chính không.
- Có thể dùng early return để giảm nesting không.
- Nhánh điều kiện dài có thể tách thành helper theo ý nghĩa nghiệp vụ không.
- Có đoạn nào đang dùng boolean flag hoặc nhiều tham số positional gây khó đọc không.

## 5. Types và contracts

- Hàm nhiều tham số đã nên gom thành object có type rõ chưa.
- Có lặp magic string, magic number hoặc ad-hoc object shape không.
- Input, output và error contract có đủ rõ để caller dùng an toàn không.
- Chỗ nào có thể dựa vào type để bỏ comment thừa hoặc if thừa không.

## 6. State và side effects

- Có mutate input hoặc shared state một cách bất ngờ không.
- Side effects như network, DB, file, analytics, cache đã được cô lập đủ chưa.
- Logic thuần có đang bị trộn với I/O khiến khó test không.
- Cleanup, rollback hoặc retry path có nằm đúng chỗ không.

## 7. Error handling và observability

- Error có được bắt ở đúng boundary không.
- Có nuốt lỗi, log mơ hồ hoặc trả lỗi thiếu context không.
- Log có đủ để debug mà không lộ dữ liệu nhạy cảm không.
- Fallback path có rõ ràng và an toàn không.

## 8. Testability và verify

- Thay đổi này có test ở mức thấp nhất đủ bắt bug không.
- Happy path, unhappy path và edge case chính đã được chạm tới chưa.
- Manual verify path có ngắn, rõ và lặp lại được không.
- Có thêm branch mới nhưng không có test hoặc smoke check tương ứng không.

## 9. Mở rộng và bảo trì

- Nếu thêm một case mới trong 1-2 tháng tới, chỗ này có mở rộng tự nhiên không.
- Có abstraction nào được tạo quá sớm mà chưa có nhu cầu lặp lại rõ không.
- Có duplication nào đáng giữ tạm để tránh abstraction sai không.
- Người đọc mới có thể lần theo flow trong vài phút không.

## 10. UI và frontend

- View component có đang ôm fetch, mapping, formatting và interaction logic quá nhiều không.
- State local, derived state và server state có bị trộn lẫn không.
- Styling có bám design system hoặc token hiện có không.
- Loading, empty, error và disabled state có được thể hiện rõ không.

## Rule of thumb

- Ưu tiên code dễ đổi hơn code “thông minh”.
- Tách theo responsibility, không tách theo cảm giác.
- Giữ diff nhỏ nhưng không giấu rủi ro.
- Nếu phải giải thích quá nhiều, thường là shape code chưa đủ rõ.
