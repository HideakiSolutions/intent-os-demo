from src.models.user import User, UserCreate
from datetime import datetime

class UserService:
    def __init__(self):
        self._store: dict[int, User] = {}
        self._next_id = 1

    def list(self) -> list[User]:
        return list(self._store.values())

    def get(self, user_id: int) -> User | None:
        return self._store.get(user_id)

    def create(self, body: UserCreate) -> User:
        user = User(id=self._next_id, name=body.name, email=body.email, created_at=datetime.utcnow())
        self._store[self._next_id] = user
        self._next_id += 1
        return user

    def delete(self, user_id: int) -> bool:
        if user_id not in self._store:
            return False
        del self._store[user_id]
        return True
