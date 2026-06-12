---
name: mcp-activate-magic
description: Activate the Magic MCP server for UI component generation from 21st.dev
---

# Activate Magic MCP

Run the following command to activate the Magic MCP server:

```bash
claude mcp add-json magic "$(cat ~/.claude/mcp-archive/magic.json | jq '.magic')"
```

After running this command, inform the user that Magic is now active and will be available in the next Claude session.

**Magic capabilities:**
- `21st_magic_component_builder` - Generate modern UI components
- `21st_magic_component_inspiration` - Browse component examples
- `21st_magic_component_refiner` - Improve existing UI components
- `logo_search` - Find company logos in JSX/TSX/SVG format
- Production-ready React components with accessibility
