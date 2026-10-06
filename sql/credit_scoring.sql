WITH stats AS (
    SELECT c.id, c.income,
           COALESCE(SUM(a.balance),0) AS savings,
           COUNT(t.id) AS tx_count,
           COALESCE(AVG(t.amount),0) AS avg_tx
    FROM clients c
    LEFT JOIN accounts a ON a.client_id = c.id
    LEFT JOIN transactions t ON t.from_acc = a.id
    GROUP BY c.id
)
SELECT id, income, savings, tx_count, avg_tx,
       CASE
         WHEN income > 200000 AND savings > 500000 THEN 'A'
         WHEN income > 100000 AND tx_count > 20 THEN 'B'
         WHEN income > 50000 THEN 'C'
         ELSE 'D'
       END AS score
FROM stats
ORDER BY income DESC;
