#!/usr/bin/env bash
# intent-os PreToolUse hook (generated; do not edit)
# Reads tool call from stdin, asks intent-os gateway for decision.
set -euo pipefail

INPUT=$(cat)
TOKEN="${INTENT_OS_AGENT_TOKEN:-}"
GATEWAY="${INTENT_OS_GATEWAY_URL:-http://localhost:28089}"
AGENT_RUN_ID="${INTENT_OS_AGENT_RUN_ID:-}"

if [[ -z "$TOKEN" || -z "$AGENT_RUN_ID" ]]; then
  echo "intent-os: INTENT_OS_AGENT_TOKEN/INTENT_OS_AGENT_RUN_ID not set; allowing (dev fallback)" >&2
  exit 0
fi

TOOL=$(jq -r '.tool_name // .tool // ""' <<<"$INPUT")
TOOL_INPUT=$(jq '.tool_input // .input // {}' <<<"$INPUT")
BODY=$(jq -nc --arg tool "$TOOL" --argjson input "$TOOL_INPUT" '{tool:$tool, input:$input}')

RESP=$(curl -sS -m 10 -w "\n%{http_code}" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -X POST "$GATEWAY/v1/agent-runs/$AGENT_RUN_ID/tool-decisions" \
  --data "$BODY") || { echo "intent-os: gateway unreachable; denying" >&2; exit 2; }

CODE=$(printf "%s" "$RESP" | tail -n1)
BODY=$(printf "%s" "$RESP" | sed '$d')

DEC=$(jq -r '.decision // "deny"' <<<"$BODY")
REASONS=$(jq -r '(.reasons // []) | join("; ")' <<<"$BODY")

case "$DEC" in
  allow) exit 0 ;;
  require_approval)
    echo "intent-os: requires human approval — $REASONS" >&2
    exit 2 ;;
  deny|*)
    echo "intent-os: policy denied tool '$TOOL' — $REASONS" >&2
    exit 2 ;;
esac
