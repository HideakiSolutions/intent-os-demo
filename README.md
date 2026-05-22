# intent-os-demo

Demo Python FastAPI application managed by **Intent OS**.

## Stack
- FastAPI + Pydantic v2
- In-memory user store (demo)
- pytest test suite
- Docker-ready

## Endpoints
| Method | Path | Description |
|--------|------|-------------|
| GET | /health | Health check |
| GET | /users | List users |
| POST | /users | Create user |
| GET | /users/{id} | Get user |
| DELETE | /users/{id} | Delete user |

## Running locally
```bash
pip install -r requirements.txt
uvicorn src.api.main:app --reload
```

## Tests
```bash
pytest tests/ -v
```
