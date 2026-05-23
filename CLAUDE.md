# do not edit — managed by intent-os (intent: 5ff27691-7d67-47be-a70e-bed40784bab7, version: v1)
# CLAUDE.md — Compatibility Pointer

This file is managed by intent-os. Read AGENTS.md for full agent instructions.

@AGENTS.md

## intent-os runtime

Este projeto opera sob governança intent-os. Antes de qualquer agent run:

1. Export envs no shell ou .env:
   - `INTENT_OS_AGENT_TOKEN` (mintado por `POST /v1/agent-runs`)
   - `INTENT_OS_AGENT_RUN_ID`
   - `INTENT_OS_GATEWAY_URL` (default http://localhost:28089)

2. `.claude/settings.json` já registra hooks PreToolUse/PostToolUse —
   bastante rodar `claude` neste diretório.

3. Toda chamada a Write/Edit/Bash/MultiEdit consulta o gateway. Decisões
   `deny` ou `require_approval` saem do hook com exit 2; mensagem aparece
   no terminal do agent.
