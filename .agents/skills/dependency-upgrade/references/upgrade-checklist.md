# Upgrade Checklist

## 1. Xác định scope

- Package/framework/SDK nào sẽ nâng
- Current version và target version
- Có phải major upgrade không

## 2. Usage surface

- File nào import package này
- Có dùng API deprecated hoặc config cũ không
- Có plugin, adapter hoặc peer dependency liên quan không

## 3. Breaking change review

- API signature changes
- Default behavior changes
- Runtime/environment requirements mới
- Config format hoặc CLI flag changes

## 4. Patch plan

- Chỉnh import/call sites nào
- Có cần migrate config không
- Có cần cập nhật test fixtures hoặc mocks không

## 5. Verify and rollback

- Build/lint/test nào phải chạy
- Smoke flow nào phải kiểm
- Nếu fail thì rollback theo cách nào
