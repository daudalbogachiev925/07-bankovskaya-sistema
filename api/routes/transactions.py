from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import text
from db import get_session

router = APIRouter()

class TransferIn(BaseModel):
    from_acc: int
    to_acc: int
    amount: float

@router.post("/transfer")
def transfer(data: TransferIn, db: Session = Depends(get_session)):
    try:
        result = db.execute(text("SELECT transfer(:f, :t, :a)"),
                            {"f": data.from_acc, "t": data.to_acc, "a": data.amount}).fetchone()
        db.commit()
        return {"status": result[0]}
    except Exception as e:
        db.rollback()
        raise HTTPException(400, str(e))

@router.get("/history/{acc_id}")
def history(acc_id: int, db: Session = Depends(get_session)):
    return [dict(r._mapping) for r in db.execute(text(open('sql/statement.sql').read()),
                                                 {"acc": acc_id}).fetchall()]
