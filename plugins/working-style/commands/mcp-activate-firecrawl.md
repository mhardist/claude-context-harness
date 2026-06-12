---
name: mcp-activate-firecrawl
description: Activate the Firecrawl MCP server for web scraping and search capabilities
---

# Activate Firecrawl MCP

Run the following command to activate the Firecrawl MCP server:

```bash
claude mcp add-json firecrawl "$(cat ~/.claude/mcp-archive/firecrawl.json | jq '.firecrawl')"
```

After running this command, inform the user that Firecrawl is now active and will be available in the next Claude session.

**Firecrawl capabilities:**
- `firecrawl_scrape` - Scrape content from URLs
- `firecrawl_search` - Search the web with advanced filtering
- `firecrawl_map` - Discover URLs on a website
- `firecrawl_crawl` - Crawl multiple pages
- `firecrawl_extract` - Extract structured data from pages
