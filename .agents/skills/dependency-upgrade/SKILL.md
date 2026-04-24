---
name: dependency-upgrade
description: Lập kế hoạch và đánh giá rủi ro khi nâng package, framework hoặc SDK, đặc biệt với major updates hoặc changelog có breaking changes. Dùng khi người dùng nói “upgrade”, “bump version”, “major update”, “changelog risk”, hoặc khi cần biết codebase đang dùng surface nào của dependency trước khi nâng.
---

# Dependency Upgrade

## When to use

- Khi cần nâng version package, framework hoặc SDK.
- Khi changelog có breaking changes và cần biết mức ảnh hưởng thực tế lên codebase.
- Khi muốn chốt verify plan và rollback notes trước khi nâng.

## How to use

- Xác định package cần nâng và version target.
- Dò codebase đang dùng surface nào của dependency đó.
- Đối chiếu breaking changes, deprecated APIs và behavioral changes quan trọng.
- Dùng `references/upgrade-checklist.md` để chốt patch plan, verify plan và rollback notes.

## Output format

- Dependency và target version
- Usage surface hiện tại
- Breaking changes đáng chú ý
- Patch / verify plan
- Rollback notes

## Guardrails

- Không nói “an toàn để nâng” nếu chưa biết codebase đang dùng phần nào của package.
- Không bỏ qua behavioral changes chỉ vì type signatures không đổi.
- Không gợi ý major upgrade mà thiếu verify path rõ ràng.
