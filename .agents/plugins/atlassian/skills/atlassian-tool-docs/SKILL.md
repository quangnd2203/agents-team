---
name: atlassian-tool-docs
description: Generate and maintain MDX documentation for `mcp-atlassian` tools by introspecting the Jira and Confluence FastMCP servers, validating category coverage, and regenerating `docs/tools/*.mdx`. Use when Codex needs to add tool-reference docs, update category mappings after new MCP tools are added, fix undocumented Atlassian tools, or keep the documentation generator in sync with `mcp_atlassian.servers.jira` and `mcp_atlassian.servers.confluence`.
---

# Atlassian Tool Docs

Generate tool-reference pages from live FastMCP metadata instead of hand-maintaining large MDX files.

Use the bundled script at [scripts/generate_tool_docs.py](scripts/generate_tool_docs.py) as the source template when the target repo does not already have a generator, or patch the repo's existing generator in place when it already exists.

## Workflow

1. Confirm the target repo exposes Jira and Confluence FastMCP server instances, can import them from Python, and has `pyyaml` plus `jinja2` available in the active environment.
2. Read [references/repo-layout.md](references/repo-layout.md) if the target repo is missing expected docs folders, overrides, or the Jinja template.
3. If the repo does not have `scripts/templates/tool_category.mdx.j2`, start from [assets/tool_category.mdx.j2](assets/tool_category.mdx.j2) and adapt the frontmatter or component usage to the repo's docs system.
4. Run the generator in check mode first:

```bash
python scripts/generate_tool_docs.py --check
```

5. If coverage fails, update `CATEGORY_TOOLS` and `CATEGORY_META` before generating files. Keep the reverse lookup and duplicate detection intact.
6. If descriptions, examples, or tips need hand-tuned copy, add YAML sidecars under `docs/_overrides/` instead of hardcoding those values inside the generator.
7. Generate pages only after coverage is clean:

```bash
python scripts/generate_tool_docs.py
```

8. Review the diff in `docs/tools/*.mdx` and verify descriptions rendered safely in MDX tables. Preserve `_escape_mdx_in_table` behavior when descriptions may contain JSON-like braces.

## Editing Rules

- Prefer introspection from `jira_mcp.get_tools()` and `confluence_mcp.get_tools()` over maintaining duplicated tool metadata by hand.
- Preserve the prefixed tool naming convention: `jira_<tool>` and `confluence_<tool>`.
- Keep write detection tag-based unless the upstream server changes how tags are exposed.
- Keep multiline parameter descriptions collapsed to one line so Markdown tables stay readable.
- Emit warnings for stale mappings, but fail checks for unmapped registered tools.

## Resources

- Script template: [scripts/generate_tool_docs.py](scripts/generate_tool_docs.py)
- MDX page template: [assets/tool_category.mdx.j2](assets/tool_category.mdx.j2)
- Repo layout and extension points: [references/repo-layout.md](references/repo-layout.md)
