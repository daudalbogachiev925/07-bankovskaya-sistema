from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import text
from db import get_session

router = APIRouter()

class CreditIn(BaseModel):
    client_id: int
    amount: float
    rate: float
    term_months: int

@router.post("/")
def issue(data: CreditIn, db: Session = Depends(get_session)):
    mp = data.amount * (data.rate/100/12) / (1 - (1 + data.rate/100/12) ** (-data.term_months))
    row = db.execute(text("""
        INSERT INTO credits (client_id, amount, rate, term_months, monthly_payment)
        VALUES (:client_id, :amount, :rate, :term_months, :mp) RETURNING id
    """), {**data.dict(), "mp": round(mp, 2)}).fetchone()
    db.commit()
    return {"id": row[0], "monthly_payment": round(mp, 2)}

@router.get("/client/{client_id}")
def by_client(client_id: int, db: Session = Depends(get_session)):
    return [dict(r._mapping) for r in db.execute(
        text("SELECT * FROM credits WHERE client_id=:c"),
        {"c": client_id}).fetchall()]
