drop database bank;
CREATE DATABASE bank;
use bank;

create table accont (
	acc_num int(3),
	amount decimal(10,2),
	acc_type enum('DEBIT','CHECK','CREDIT','ROSTER')
);

CREATE TRIGGER ins_sum BEFORE INSERT ON accont
FOR EACH ROW SET @sum = @sum + NEW.amount;

SET @sum = 0;

INSERT INTO accont VALUES (137,14.98,"ROSTER");
INSERT INTO accont VALUES (141,2937.50,"ROSTER");
INSERT INTO accont VALUES (97,-101.00,"ROSTER");

SELECT @sum AS 'Total amount insertered';

SHOW TRIGGERS;

DROP TRIGGER bank.ins_sum;

CREATE TRIGGER ins_transaction BEFORE INSERT ON accont
FOR EACH ROW SET
@deposits = @deposits + IF(NEW.amount>0,NEW.amount,0),
@withdrawals = @withdrawals + IF (NEW.amount<0,-NEW.amount,0);

INSERT INTO accont VALUES (113,400.09,"ROSTER");
INSERT INTO accont VALUES (149,-937.50,"ROSTER");
INSERT INTO accont VALUES (956,101.00,"ROSTER");

SELECT @deposits AS 'Total of deposits';
SELECT @withdrawals AS 'Total of withdrawals';

DROP TRIGGER bank.ins_transaction;

delimiter //
CREATE TRIGGER upd_check BEFORE UPDATE ON accont
	FOR EACH ROW 
	BEGIN 
		IF NEW.amount < 0 THEN
			SET NEW.amount = 0;
			SET NEW.amount = "DEBIT";
		ELSEIF NEW.amount > 100 THEN
			SET NEW.amount = 100;
		END IF;
	END;//
delimiter ;

SELECT * FROM accont;