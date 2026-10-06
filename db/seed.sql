INSERT INTO clients (full_name, passport, birth, income) VALUES
('Иванов И.И.','4501 123456','1985-05-10',120000),
('Петрова П.П.','4502 654321','1990-08-20',85000),
('Сидоров А.А.','4503 111222','1978-02-15',250000);

INSERT INTO accounts (client_id, kind, balance) VALUES
(1,'current',50000),(1,'deposit',200000),
(2,'current',15000),
(3,'current',500000),(3,'deposit',1000000);

INSERT INTO transactions (from_acc, to_acc, amount) VALUES
(1,3,5000),(3,1,2500),(1,2,10000);
