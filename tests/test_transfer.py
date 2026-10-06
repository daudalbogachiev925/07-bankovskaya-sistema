from fastapi.testclient import TestClient
from main import app
client = TestClient(app)

def test_health():
    assert client.get("/health").json() == {"status": "ok"}

def test_transfer_validation():
    r = client.post("/transactions/transfer", json={"from_acc": 1, "to_acc": 2, "amount": -100})
    assert r.status_code == 400
