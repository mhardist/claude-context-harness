---
name: mcp-guide
description: MCP server selection guide — when and how to use each server
triggers:
  - MCP server questions
  - which MCP to use
  - complex debugging needing sequential thinking
  - library documentation lookup
  - UI component generation
  - bulk code transformations
  - browser testing
  - web search and research
---

# MCP Server Selection Guide

Quick decision matrix, then detailed sections per server.

## Decision Matrix

| Need | Server | Activate |
|------|--------|----------|
| Library/framework docs | Context7 | `/mcp-activate-context7` |
| Complex multi-step reasoning | Sequential | `/mcp-activate-sequential` |
| Bulk code transformations | Morphllm | `/mcp-activate-morphllm` |
| UI component generation | Magic | `/mcp-activate-magic` |
| Browser automation/E2E tests | Chrome DevTools | `/mcp-activate-chrome-devtools` |
| Web scraping/crawling | Firecrawl | `/mcp-activate-firecrawl` |
| Database queries | PostgreSQL | `/mcp-activate-postgres` |

## Context7

**Purpose**: Official library documentation lookup and framework pattern guidance.

**Use when**: Import statements, framework questions, version-specific APIs, official patterns needed.
**Use over WebSearch**: When you need curated, version-specific documentation.
**Skip for**: Simple explanations, non-framework code, general concepts.

**Triggers**: `import`, `require`, `from`, React/Vue/Angular/Next.js keywords, library API questions.

## Sequential Thinking

**Purpose**: Multi-step reasoning engine for complex analysis.

**Use when**: 3+ interconnected components, root cause analysis, architecture review, security assessment, hypothesis testing.
**Activated by flags**: `--think`, `--think-hard`, `--ultrathink`.
**Skip for**: Simple explanations, single-file changes, straightforward fixes.

**Triggers**: Complex debugging, system design, multi-component failure investigation.

## Morphllm

**Purpose**: Pattern-based code editing with token optimization for bulk transformations.

**Use when**: Multi-file consistent edits, framework updates, style enforcement, bulk text replacements.
**Use over manual edits**: When applying the same pattern across <10 files.
**Skip for**: Symbol renames (use IDE/Serena), semantic operations, complex analysis.

**Triggers**: "update all X to Y", style enforcement, framework migration patterns.

## Magic (21st.dev)

**Purpose**: Modern UI component generation with design system integration.

**Use when**: UI component requests (button, form, modal, card, table, nav), design system needs.
**Use over manual coding**: When you need production-ready, accessible components.
**Skip for**: Backend logic, database queries, server configuration.

**Triggers**: `/ui`, `/21`, responsive/accessible/interactive keywords.

## Chrome DevTools

**Purpose**: Browser automation, debugging, and testing.

**Use when**: E2E test scenarios, visual testing, form submission testing, screenshot capture, accessibility testing.
**Use over unit tests**: For integration testing, user journeys, visual validation.
**Skip for**: Static code review, syntax checking, logic validation.

**Triggers**: Browser testing, screenshot requests, WCAG compliance testing.

## Firecrawl

**Purpose**: Web scraping, search, and crawling.

**Use when**: Need to extract content from websites, crawl multiple pages, structured data extraction.
**Use over WebFetch**: When you need multi-page crawling or structured extraction.
**Skip for**: Simple single-page fetches (use WebFetch), local file operations.

## PostgreSQL

**Purpose**: Database queries and schema exploration.

**Use when**: Direct database queries needed, schema exploration, data analysis.
**Note**: Prefer a read-only connection string for production databases.

## Combo Patterns

| Scenario | Combo |
|----------|-------|
| Research + implement | Context7 (docs) → Sequential (strategy) |
| Build UI + validate | Magic (components) → Chrome DevTools (test) |
| Plan edits + execute | Sequential (plan) → Morphllm (apply) |
| Debug complex issue | Sequential (analyze) → Context7 (verify patterns) |
| Full-stack feature | Context7 (docs) + Sequential (design) + Magic (UI) |

## Flag-Based Activation

| Flag | Servers Enabled |
|------|----------------|
| `--think` | Sequential |
| `--think-hard` | Sequential + Context7 |
| `--ultrathink` | All servers |
| `--no-mcp` | None (native tools only + WebSearch fallback) |
