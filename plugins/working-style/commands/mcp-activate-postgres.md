---
description: Activate the PostgreSQL MCP server for database queries and schema exploration
---

# Activate PostgreSQL MCP Server

Activate the PostgreSQL MCP server for database queries and schema exploration.

## Setup

Set `DATABASE_URL` in your environment (never hardcode credentials in this
file — it may end up in a repo). For production databases, use a read-only
role.

```bash
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres "$DATABASE_URL"
```

## Remote database via SSH tunnel (optional pattern)

If the database is only reachable through a bastion/VM, open a tunnel first.
Keep the SSH key in your secrets manager (e.g., 1Password) and pull it just
in time:

```bash
# Pull key from secrets manager (example: 1Password CLI)
op document get <your-key-document-id> --force --out-file /tmp/db_tunnel.pem && chmod 600 /tmp/db_tunnel.pem

# Open tunnel: local 5433 → remote 5432
ssh -f -N -L 5433:localhost:5432 -i /tmp/db_tunnel.pem <user>@<host> -o ServerAliveInterval=30 -o ServerAliveCountMax=10

# Verify
pg_isready -h 127.0.0.1 -p 5433 -U <db_user> -d <db_name> || echo "Tunnel not ready"

# Point DATABASE_URL at the tunnel, then add the MCP server as above
```

## Teardown

```bash
claude mcp remove postgres
# If you opened a tunnel:
pkill -f "ssh -f -N -L 5433" ; rm -f /tmp/db_tunnel.pem
```

## Why activate on demand?

Every always-on MCP server costs context in every session. Add servers when
the task needs them; remove them when done.
