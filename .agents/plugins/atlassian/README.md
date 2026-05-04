# Atlassian Plugin

This plugin registers the `mcp-atlassian` server for Codex and includes a helper skill for generating Atlassian MCP tool documentation.

## Configuration

Set these environment variables before opening Codex:

```bash
export JIRA_URL="https://your-site.atlassian.net"
export JIRA_USERNAME="you@example.com"
export JIRA_API_TOKEN="your-jira-api-token"
export CONFLUENCE_URL="https://your-site.atlassian.net"
export CONFLUENCE_USERNAME="you@example.com"
export CONFLUENCE_API_TOKEN="your-confluence-api-token"
```

The MCP server is configured in `./.mcp.json` using:

```bash
uvx mcp-atlassian
```

## Enable

This repo exposes the plugin through `.agents/plugins/marketplace.json` as:

```toml
[plugins."atlassian@agents-team"]
enabled = true
```

After changing plugin configuration, open a new Codex session so the runtime can reload the marketplace and MCP server.
