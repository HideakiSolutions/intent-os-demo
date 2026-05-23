#!/usr/bin/env bash
# intent-os PostToolUse hook (generated; do not edit)
# Reads tool result from stdin, sends observation to gateway (fire-and-forget).
set -euo pipefail

INPUT=$(cat)
TOKEN="${INTENT_OS_AGENT_TOKEN:-}"
GATEWAY="${INTENT_OS_GATEWAY_URL:-http://localhost:28089}"
AGENT_RUN_ID="${INTENT_OS_AGENT_RUN_ID:-}"

if [[ -z "$TOKEN" || -z "$AGENT_RUN_ID" ]]; then exit 0; fi

TOOL=$(jq -r '.tool_name // .tool // ""' <<<"$INPUT")
TOOL_INPUT=$(jq '.tool_input // .input // {}' <<<"$INPUT")
OUTPUT=$(jq -r '.tool_response.output // .tool_response // .output // ""' <<<"$INPUT" | head -c 4096)
EXIT_CODE=$(jq -r '.tool_response.exit_code // .exit_code // 0' <<<"$INPUT")

BODY=$(jq -nc --arg tool "$TOOL" --argjson input "$TOOL_INPUT" --arg output "$OUTPUT" --argjson exit_code "$EXIT_CODE" \
  '{tool:$tool, input:$input, output:$output, exit_code:$exit_code}')

curl -sS -m 5 -o /dev/null \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -X POST "$GATEWAY/v1/agent-runs/$AGENT_RUN_ID/tool-observations" \
  --data "$BODY" || true

exit 0
