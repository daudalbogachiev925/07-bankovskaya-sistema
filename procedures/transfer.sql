CREATE OR REPLACE FUNCTION transfer(p_from BIGINT, p_to BIGINT, p_amount NUMERIC)
RETURNS TEXT LANGUAGE plpgsql AS $$
DECLARE v_balance NUMERIC;
BEGIN
    IF p_amount <= 0 THEN RAISE EXCEPTION 'Сумма должна быть положительной'; END IF;
    SELECT balance INTO v_balance FROM accounts WHERE id = p_from FOR UPDATE;
    IF v_balance IS NULL THEN RAISE EXCEPTION 'Счёт не найден'; END IF;
    IF v_balance < p_amount THEN RAISE EXCEPTION 'Недостаточно средств'; END IF;

    UPDATE accounts SET balance = balance - p_amount WHERE id = p_from;
    UPDATE accounts SET balance = balance + p_amount WHERE id = p_to;

    INSERT INTO transactions (from_acc, to_acc, amount, status)
    VALUES (p_from, p_to, p_amount, 'done');

    INSERT INTO audit_log (action, entity, details)
    VALUES ('transfer', 'accounts', jsonb_build_object('from', p_from, 'to', p_to, 'amount', p_amount));

    RETURN 'ok';
END; $$;
