# UI Change Guide

Chỉ đọc tài liệu này khi task thực sự chạm giao diện, interaction, design tokens hoặc markup-to-component conversion.

## 1. Respect the current design system

- Tìm token, primitive, theme variables, component library hoặc utility classes đã có trước khi thêm mới.
- Nếu codebase đã có spacing, typography, color và motion tokens, ưu tiên tái sử dụng thay vì hardcode ad-hoc.
- Giữ consistency với visual language hiện tại trước khi tối ưu chi tiết cục bộ.

## 2. Styling policy

- Ưu tiên pattern styling hiện có của codebase: utility classes, component styles, tokens hoặc theme API.
- Tránh thêm layer styling mới nếu stack hiện tại đã đủ để giải bài toán.
- Chỉ dùng inline styles cho giá trị thật sự động hoặc tính toán tại runtime.

## 3. Markup and component boundaries

- Nếu đầu vào là HTML, design spec hoặc snippet raw, convert về component code của codebase trước khi chốt implementation.
- Tách component theo boundary dễ đọc, dễ test và đúng ownership của feature.
- Không giữ raw markup hoặc copied demo code làm implementation cuối nếu codebase đã có component pattern riêng.

## 4. Interaction and motion

- Hover, focus, loading, error và empty state phải rõ ràng nếu thay đổi có chạm user flow.
- Motion chỉ nên củng cố hierarchy hoặc feedback; tránh thêm animation chỉ để “cho đẹp”.
- Accessibility phải được giữ nguyên hoặc cải thiện, nhất là focus order, semantics và reduced-motion behavior nếu có.

## 5. Review before merge

- Kiểm tra lại responsive behavior, state transitions và visual consistency.
- Xác nhận không tạo token, component variant hoặc layout pattern mới nếu codebase đã có tương đương.
- Ghi rõ những trạng thái đã verify khi handoff.
