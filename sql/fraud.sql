SELECT t.id, t.from_acc, t.amount, t.created,
       AVG(t.amount) OVER (PARTITION BY t.from_acc) AS avg_amount,
       COUNT(*) OVER (PARTITION BY t.from_acc) AS tx_count
FROM transactions t
WHERE t.created >= NOW() - INTERVAL '1 hour'
  AND t.amount > (SELECT AVG(amount) * 5 FROM transactions t2 WHERE t2.from_acc = t.from_acc);
