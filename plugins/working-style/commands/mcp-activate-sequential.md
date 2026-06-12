---
name: mcp-activate-sequential
description: Activate the Sequential Thinking MCP server for complex multi-step reasoning
---

# Activate Sequential Thinking MCP

Run the following command to activate the Sequential Thinking MCP server:

```bash
claude mcp add-json sequential-thinking "$(cat ~/.claude/mcp-archive/sequential-thinking.json | jq '."sequential-thinking"')"
```

After running this command, inform the user that Sequential Thinking is now active and will be available in the next Claude session.

**Sequential Thinking capabilities:**
- Multi-step reasoning and problem decomposition
- Hypothesis testing and validation
- Complex debugging and architectural analysis
- Systematic problem-solving with thought tracking
