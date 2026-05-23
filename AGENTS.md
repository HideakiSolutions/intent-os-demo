# do not edit — managed by intent-os (intent: 5ff27691-7d67-47be-a70e-bed40784bab7, version: v1)
# AGENTS.md — Add pagination to GET /users endpoint

> Vendor-neutral agent instructions managed by intent-os.

## Scope

GET /users returns all users with no limit. Add limit (default 20, max 100) and offset query params. Return {items, total, limit, offset}.

## Artifacts Under Management

- `.controlplane/manifest.yaml`
- `.controlplane/context-summary.md`
- `.controlplane/constraints.md`
- `.controlplane/acceptance.md`
- `.controlplane/commands.md`
- `.controlplane/memory.md`
- `AGENTS.md`
- `CLAUDE.md`
- `.cursor/rules/intent-os.mdc`
- `.claude/settings.json`
- `.controlplane/hooks/pretooluse.sh`
- `.controlplane/hooks/posttooluse.sh`
- `.claude/mcp_servers.json`

## Required Checks

- lint
- test
- policy:secret-leak

## Constraints

Allowed tools: `read`, `write`, `grep`, `run`

Denied tools: `network_egress`

## Acceptance Criteria

- GET /users?limit=10&offset=0 returns at most 10 users
- Response has items/total/limit/offset
- limit>100 returns 400
- Tests cover edge cases
