CREATE TABLE clients (
    id BIGSERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    passport TEXT UNIQUE NOT NULL,
    birth DATE,
    income NUMERIC(15,2),
    segment TEXT DEFAULT 'mass',
    created TIMESTAMP DEFAULT NOW()
);

CREATE TABLE accounts (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT REFERENCES clients(id),
    kind TEXT NOT NULL CHECK (kind IN ('current','deposit','credit','card')),
    currency TEXT DEFAULT 'RUB',
    balance NUMERIC(15,2) DEFAULT 0,
    opened DATE DEFAULT CURRENT_DATE,
    closed DATE,
    status TEXT DEFAULT 'active'
);

CREATE TABLE cards (
    id BIGSERIAL PRIMARY KEY,
    account_id BIGINT REFERENCES accounts(id),
    number TEXT UNIQUE NOT NULL,
    expiry DATE,
    status TEXT DEFAULT 'active',
    pin_hash TEXT
);

CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    from_acc BIGINT REFERENCES accounts(id),
    to_acc BIGINT REFERENCES accounts(id),
    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),
    currency TEXT DEFAULT 'RUB',
    status TEXT DEFAULT 'done',
    kind TEXT DEFAULT 'transfer',
    created TIMESTAMP DEFAULT NOW()
);

CREATE TABLE credits (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT REFERENCES clients(id),
    amount NUMERIC(15,2) NOT NULL,
    rate NUMERIC(5,2) NOT NULL,
    term_months INT NOT NULL,
    monthly_payment NUMERIC(15,2),
    status TEXT DEFAULT 'active',
    issued DATE DEFAULT CURRENT_DATE
);

CREATE TABLE credit_payments (
    id BIGSERIAL PRIMARY KEY,
    credit_id BIGINT REFERENCES credits(id),
    amount NUMERIC(15,2),
    paid_at TIMESTAMP DEFAULT NOW(),
    principal NUMERIC(15,2),
    interest NUMERIC(15,2)
);

CREATE TABLE audit_log (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    action TEXT,
    entity TEXT,
    entity_id BIGINT,
    details JSONB,
    ts TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_acc_client ON accounts(client_id);
CREATE INDEX idx_tx_from ON transactions(from_acc);
CREATE INDEX idx_tx_to ON transactions(to_acc);
CREATE INDEX idx_tx_created ON transactions(created);
