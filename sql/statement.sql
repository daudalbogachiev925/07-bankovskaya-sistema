SELECT t.id, t.created, t.kind, t.amount, t.status,
       CASE WHEN t.from_acc = :acc THEN 'out' ELSE 'in' END AS direction,
       COALESCE(c1.full_name,'—') AS from_client,
       COALESCE(c2.full_name,'—') AS to_client
FROM transactions t
LEFT JOIN accounts a1 ON a1.id = t.from_acc
LEFT JOIN accounts a2 ON a2.id = t.to_acc
LEFT JOIN clients c1 ON c1.id = a1.client_id
LEFT JOIN clients c2 ON c2.id = a2.client_id
WHERE t.from_acc = :acc OR t.to_acc = :acc
ORDER BY t.created DESC
LIMIT 100;
