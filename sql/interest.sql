-- Начисление процентов на депозиты (5% годовых / 12 месяцев)
UPDATE accounts
SET balance = balance * (1 + 0.05/12)
WHERE kind='deposit' AND status='active'
RETURNING id, balance;
