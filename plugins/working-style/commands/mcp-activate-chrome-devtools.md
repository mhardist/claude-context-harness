---
name: mcp-activate-chrome-devtools
description: Activate the Chrome DevTools MCP server for browser automation and debugging
---

# Activate Chrome DevTools MCP

Run the following command to activate the Chrome DevTools MCP server:

```bash
claude mcp add-json chrome-devtools "$(cat ~/.claude/mcp-archive/chrome-devtools.json | jq '."chrome-devtools"')"
```

After running this command, inform the user that Chrome DevTools is now active and will be available in the next Claude session.

**Chrome DevTools capabilities:**
- Browser automation and page interaction
- Screenshot capture and visual testing
- Network request monitoring
- Console message inspection
- Performance tracing
- DOM inspection and manipulation
