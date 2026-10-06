from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import text
from db import get_session

router = APIRouter()

class AccountIn(BaseModel):
    client_id: int
    kind: str
    currency: str = "RUB"

@router.post("/")
def open_account(data: AccountIn, db: Session = Depends(get_session)):
    row = db.execute(text("""
        INSERT INTO accounts (client_id, kind, currency) VALUES (:client_id,:kind,:currency)
        RETURNING id
    """), data.dict()).fetchone()
    db.commit()
    return {"id": row[0]}

@router.get("/{acc_id}")
def get(acc_id: int, db: Session = Depends(get_session)):
    a = db.execute(text("SELECT * FROM accounts WHERE id=:i"), {"i": acc_id}).fetchone()
    if not a: raise HTTPException(404)
    return dict(a._mapping)

@router.post("/{acc_id}/close")
def close(acc_id: int, db: Session = Depends(get_session)):
    db.execute(text("UPDATE accounts SET status='closed', closed=CURRENT_DATE WHERE id=:i"),
               {"i": acc_id})
    db.commit()
    return {"status": "closed"}
