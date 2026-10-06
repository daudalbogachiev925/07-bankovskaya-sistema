from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text
from db import get_session

router = APIRouter()

@router.get("/")
def list_log(limit: int = 100, db: Session = Depends(get_session)):
    return [dict(r._mapping) for r in db.execute(text("""
        SELECT * FROM audit_log ORDER BY ts DESC LIMIT :l
    """), {"l": limit}).fetchall()]
