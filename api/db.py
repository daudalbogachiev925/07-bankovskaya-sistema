from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import os

DSN = f"postgresql://{os.getenv('POSTGRES_USER','bank')}:{os.getenv('POSTGRES_PASSWORD','bank')}@{os.getenv('POSTGRES_HOST','localhost')}:5432/bank"
engine = create_engine(DSN, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine)

def get_session():
    s = SessionLocal()
    try: yield s
    finally: s.close()
