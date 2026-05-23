# do not edit — managed by intent-os (intent: 5ff27691-7d67-47be-a70e-bed40784bab7, version: v1)
# Acceptance Criteria

- GET /users?limit=10&offset=0 returns at most 10 users
- Response has items/total/limit/offset
- limit>100 returns 400
- Tests cover edge cases
