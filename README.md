# agents-team

Repo này là catalog dùng chung cho Codex trên máy local, gồm:

- `.agents/skills/`: các skill portable dùng cho nhiều codebase.
- `.codex/agents/`: các agent role như `ba`, `pm`, `tech_lead`, `dev_senior`, `qa`, `security`, `devops`.
- `.codex/config.toml`: cấu hình runtime chung cho agent catalog.

## Link vào Codex local

Chạy từ bất kỳ thư mục nào trên máy:

```bash
ln -s ~/project/core/agents-team/.agents/skills ~/.codex/skills/skills_repo
ln -s ~/project/core/agents-team/.codex/agents ~/.codex/
```

Sau khi link xong, Codex sẽ thấy:

- Skill repo tại `~/.codex/skills/skills_repo`
- Agent definitions tại `~/.codex/agents`

## Kiểm tra

```bash
ls -la ~/.codex/skills/skills_repo
ls -la ~/.codex/agents
```

Nếu link đúng, hai path trên sẽ trỏ về repo này:

```text
~/.codex/skills/skills_repo -> ~/project/core/agents-team/.agents/skills
~/.codex/agents -> ~/project/core/agents-team/.codex/agents
```

## Khi đã có link cũ

Nếu máy báo `File exists`, kiểm tra trước khi thay:

```bash
ls -la ~/.codex/skills/skills_repo
ls -la ~/.codex/agents
```

Nếu chắc chắn muốn trỏ lại về repo này:

```bash
rm ~/.codex/skills/skills_repo
rm ~/.codex/agents
ln -s ~/project/core/agents-team/.agents/skills ~/.codex/skills/skills_repo
ln -s ~/project/core/agents-team/.codex/agents ~/.codex/
```

## Lưu ý runtime

Sau khi thêm hoặc sửa agent trong `.codex/agents/*.toml`, cần mở session Codex mới để runtime nạp lại agent definitions. Việc file đã tồn tại trên disk không luôn đồng nghĩa agent đã được hydrate vào session đang chạy.
