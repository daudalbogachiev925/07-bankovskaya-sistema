CREATE OR REPLACE FUNCTION accrue_monthly_interest(p_rate NUMERIC DEFAULT 0.05)
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE v_count INT;
BEGIN
    UPDATE accounts
    SET balance = balance * (1 + p_rate/12)
    WHERE kind = 'deposit' AND status = 'active';
    GET DIAGNOSTICS v_count = ROW_COUNT;

    INSERT INTO audit_log (action, entity, details)
    VALUES ('interest_accrual', 'accounts', jsonb_build_object('rate', p_rate, 'count', v_count));

    RETURN v_count;
END; $$;
