from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from datetime import date
from sqlalchemy.orm import Session
from sqlalchemy import text
from db import get_session

router = APIRouter()

class ClientIn(BaseModel):
    full_name: str
    passport: str
    birth: date | None = None
    income: float = 0

@router.post("/")
def create(data: ClientIn, db: Session = Depends(get_session)):
    row = db.execute(text("""
        INSERT INTO clients (full_name, passport, birth, income)
        VALUES (:full_name, :passport, :birth, :income) RETURNING id
    """), data.dict()).fetchone()
    db.commit()
    return {"id": row[0]}

@router.get("/")
def list_clients(db: Session = Depends(get_session)):
    return [dict(r._mapping) for r in db.execute(text("SELECT * FROM clients")).fetchall()]

@router.get("/{client_id}")
def get_client(client_id: int, db: Session = Depends(get_session)):
    c = db.execute(text("SELECT * FROM clients WHERE id=:i"), {"i": client_id}).fetchone()
    if not c: raise HTTPException(404)
    accounts = db.execute(text("SELECT * FROM accounts WHERE client_id=:i"), {"i": client_id}).fetchall()
    return {**dict(c._mapping), "accounts": [dict(a._mapping) for a in accounts]}
