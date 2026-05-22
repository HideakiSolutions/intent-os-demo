import pytest
from fastapi.testclient import TestClient
from src.api.main import app

client = TestClient(app)

def test_health():
    r = client.get("/health")
    assert r.status_code == 200

def test_create_and_get_user():
    r = client.post("/users", json={"name": "Alice", "email": "alice@example.com"})
    assert r.status_code == 201
    user_id = r.json()["id"]

    r = client.get(f"/users/{user_id}")
    assert r.status_code == 200
    assert r.json()["name"] == "Alice"

def test_list_users():
    r = client.get("/users")
    assert r.status_code == 200
    assert isinstance(r.json(), list)

def test_delete_user():
    r = client.post("/users", json={"name": "Bob", "email": "bob@example.com"})
    uid = r.json()["id"]
    r = client.delete(f"/users/{uid}")
    assert r.status_code == 204
