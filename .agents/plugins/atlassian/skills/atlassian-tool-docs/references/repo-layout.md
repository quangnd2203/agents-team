# Expected Repo Layout

Use this reference when wiring the generator into a repo or when the repo layout drifts.

## Required Files

- `scripts/generate_tool_docs.py`
- `scripts/templates/tool_category.mdx.j2`
- `docs/tools/`
- `docs/_overrides/`
- Python modules that expose `mcp_atlassian.servers.jira.jira_mcp`
- Python modules that expose `mcp_atlassian.servers.confluence.confluence_mcp`
- Python dependencies: `pyyaml`, `jinja2`

## Generator Responsibilities

- Introspect both FastMCP server instances and merge them into one tool map.
- Prefix raw tool names with `jira_` or `confluence_` before category matching.
- Build per-category MDX pages from a shared Jinja2 template.
- Support a `--check` mode that exits non-zero when any registered tool is undocumented.
- Load optional YAML sidecars from `docs/_overrides/*.yaml`.

## Where to Edit

- Add or move tools between sections in `CATEGORY_TOOLS`.
- Update human-facing page copy in `CATEGORY_META`.
- Adjust per-tool examples or tips in `docs/_overrides/<tool-name>.yaml`.
- Change MDX rendering in `scripts/templates/tool_category.mdx.j2`.

## Skill Assets

- The skill bundles a starter template at `assets/tool_category.mdx.j2`.
- Copy that asset into `scripts/templates/tool_category.mdx.j2` when the target repo does not already ship a compatible Jinja template.

## Verification

Run these checks after changes:

```bash
python scripts/generate_tool_docs.py --check
python scripts/generate_tool_docs.py
python -m py_compile scripts/generate_tool_docs.py
```

If `--check` reports unmapped tools, fix the category map before regenerating pages.
