---
name: mcp-activate-morphllm
description: Activate the Morphllm Fast Apply MCP server for bulk code transformations
---

# Activate Morphllm Fast Apply MCP

Run the following command to activate the Morphllm MCP server:

```bash
claude mcp add-json morphllm-fast-apply "$(cat ~/.claude/mcp-archive/morphllm-fast-apply.json | jq '."morphllm-fast-apply"')"
```

After running this command, inform the user that Morphllm is now active and will be available in the next Claude session.

**Morphllm capabilities:**
- Pattern-based code editing with token optimization
- Bulk transformations across multiple files
- Framework updates and style guide enforcement
