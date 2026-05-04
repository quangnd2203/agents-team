# agents-team

Repo này là catalog dùng chung cho Codex trên máy local, gồm:

- `.agents/skills/`: các skill portable dùng cho nhiều codebase.
- `.agents/plugins/marketplace.json`: marketplace local cho plugin dùng chung.
- `.agents/plugins/context7/`: plugin Context7 local.
- `.agents/plugins/atlassian/`: plugin Atlassian MCP local.
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
- Plugin marketplace `agents-team` nếu cấu hình `.codex/config.toml` của repo này được dùng hoặc được đồng bộ vào `~/.codex/config.toml`

## Plugin Context7

Repo này đã có plugin `context7` tại `.agents/plugins/context7`, được expose qua marketplace `agents-team`:

```toml
[marketplaces.agents-team]
source_type = "local"
source = "/Users/cuccung/project/core/agents-team"

[plugins."context7@agents-team"]
enabled = true
```

Nếu muốn rate limit cao hơn, set thêm biến môi trường trước khi mở Codex:

```bash
export CONTEXT7_API_KEY="ctx7sk-your-api-key"
```

Sau khi thêm hoặc sửa plugin/marketplace config, cần mở session Codex mới để runtime nạp lại plugin và MCP server.

## Plugin Atlassian

Repo này đã có plugin `atlassian` tại `.agents/plugins/atlassian`, được expose qua marketplace `agents-team`:

```toml
[plugins."atlassian@agents-team"]
enabled = true
```

Plugin này dùng `uvx mcp-atlassian` và đọc cấu hình từ environment. Set các biến `JIRA_URL`, `JIRA_USERNAME`, `JIRA_API_TOKEN`, `CONFLUENCE_URL`, `CONFLUENCE_USERNAME`, `CONFLUENCE_API_TOKEN` trước khi mở Codex.

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
