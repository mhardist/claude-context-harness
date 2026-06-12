---
name: mcp-activate-context7
description: Activate the Context7 MCP server for library documentation lookup
---

# Activate Context7 MCP

Run the following command to activate the Context7 MCP server:

```bash
claude mcp add-json context7 "$(cat ~/.claude/mcp-archive/context7.json | jq '.context7')"
```

After running this command, inform the user that Context7 is now active and will be available in the next Claude session.

**Context7 capabilities:**
- `resolve-library-id` - Find library IDs for documentation lookup
- `get-library-docs` - Fetch up-to-date documentation for any library
- Official documentation patterns for frameworks and libraries
- Version-specific implementation guidance
