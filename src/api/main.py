from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from src.models.user import User, UserCreate
from src.services.user_service import UserService

app = FastAPI(title="Intent OS Demo API", version="0.1.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

user_service = UserService()

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/users", response_model=list[User])
async def list_users():
    return user_service.list()

@app.post("/users", response_model=User, status_code=201)
async def create_user(body: UserCreate):
    return user_service.create(body)

@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: int):
    user = user_service.get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.delete("/users/{user_id}", status_code=204)
async def delete_user(user_id: int):
    if not user_service.delete(user_id):
        raise HTTPException(status_code=404, detail="User not found")
