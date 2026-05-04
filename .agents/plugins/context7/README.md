# Context7 Plugin

This plugin registers the Context7 MCP server for Codex so agents can fetch current library and API documentation while coding.

## Configuration

Set `CONTEXT7_API_KEY` in your environment before enabling the plugin if you want higher rate limits.

```bash
export CONTEXT7_API_KEY="ctx7sk-your-api-key"
```

The MCP server is configured in `./.mcp.json` using:

```bash
npx -y @upstash/context7-mcp
```

## Enable

This repo exposes the plugin through `.agents/plugins/marketplace.json` as:

```toml
[plugins."context7@agents-team"]
enabled = true
```

After changing plugin configuration, open a new Codex session so the runtime can reload the marketplace and MCP server.
