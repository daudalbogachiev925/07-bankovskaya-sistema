SELECT c.id, c.full_name,
       COALESCE(SUM(CASE WHEN a.kind='current' THEN a.balance ELSE 0 END),0) AS current_balance,
       COALESCE(SUM(CASE WHEN a.kind='deposit' THEN a.balance ELSE 0 END),0) AS deposit_balance,
       COALESCE(SUM(a.balance),0) AS total_balance
FROM clients c
LEFT JOIN accounts a ON a.client_id = c.id AND a.status='active'
GROUP BY c.id
ORDER BY total_balance DESC;
