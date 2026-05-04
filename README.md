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
AGENTS_TEAM_DIR="<path-to-agents-team>"

ln -s "$AGENTS_TEAM_DIR/.agents/skills" ~/.codex/skills/skills_repo
ln -s "$AGENTS_TEAM_DIR/.codex/agents" ~/.codex/
```

Sau khi link xong, Codex sẽ thấy:

- Skill repo tại `~/.codex/skills/skills_repo`
- Agent definitions tại `~/.codex/agents`
- Plugin marketplace `agents-team` nếu cấu hình `.codex/config.toml` của repo này được dùng hoặc được đồng bộ vào `~/.codex/config.toml`

## Nạp bộ plugin local

Bộ plugin của repo này nằm trong `.agents/plugins/` và được khai báo qua marketplace `agents-team`.

Thêm block sau vào `~/.codex/config.toml`:

```toml
[marketplaces.agents-team]
source_type = "local"
source = "<path-to-agents-team>"

[plugins."context7@agents-team"]
enabled = true

[plugins."atlassian@agents-team"]
enabled = true
```

Nếu chỉ muốn nạp marketplace nhưng chưa bật plugin nào, chỉ giữ phần:

```toml
[marketplaces.agents-team]
source_type = "local"
source = "<path-to-agents-team>"
```

Sau khi sửa `~/.codex/config.toml`, mở session Codex mới để runtime nạp lại marketplace, plugin và MCP server.

Kiểm tra nhanh plugin đang có trong marketplace:

```bash
AGENTS_TEAM_DIR="<path-to-agents-team>"

python3 -m json.tool "$AGENTS_TEAM_DIR/.agents/plugins/marketplace.json"
```

## Plugin Context7

Repo này đã có plugin `context7` tại `.agents/plugins/context7`, được expose qua marketplace `agents-team`:

```toml
[marketplaces.agents-team]
source_type = "local"
source = "<path-to-agents-team>"

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
~/.codex/skills/skills_repo -> <path-to-agents-team>/.agents/skills
~/.codex/agents -> <path-to-agents-team>/.codex/agents
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
AGENTS_TEAM_DIR="<path-to-agents-team>"

ln -s "$AGENTS_TEAM_DIR/.agents/skills" ~/.codex/skills/skills_repo
ln -s "$AGENTS_TEAM_DIR/.codex/agents" ~/.codex/
```

## Lưu ý runtime

Sau khi thêm hoặc sửa agent trong `.codex/agents/*.toml`, cần mở session Codex mới để runtime nạp lại agent definitions. Việc file đã tồn tại trên disk không luôn đồng nghĩa agent đã được hydrate vào session đang chạy.
