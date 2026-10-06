from fastapi import FastAPI
from routes import clients, accounts, transactions, credits, audit

app = FastAPI(title="Banking Core API", version="1.0")
app.include_router(clients.router, prefix="/clients", tags=["clients"])
app.include_router(accounts.router, prefix="/accounts", tags=["accounts"])
app.include_router(transactions.router, prefix="/transactions", tags=["transactions"])
app.include_router(credits.router, prefix="/credits", tags=["credits"])
app.include_router(audit.router, prefix="/audit", tags=["audit"])

@app.get("/health")
def health(): return {"status": "ok"}
