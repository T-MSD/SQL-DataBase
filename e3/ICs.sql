--1--

CREATE FUNCTION OR REPLACE chk_employee_age(ssn_employee)
RETURNS BOOLEAN AS
$$

DECLARE date DATE;
DECLARE current_date DATE
DECLARE age INTEGER;
DECLARE aux DATE

BEGIN
	
	SELECT bdate INTO date 
FROM employee 
WHERE ssn = ssn_employe

age INTERVAL := AGE(date)

RETURN EXTRACT(YEAR FROM age) >= 18
END;

$$ LANGUAGE plpgsql;


 -- o trigger assume que a funçao da data retorna boole--
CREATE OR REPLACE FUNCTION chk_age_proc()
RETURNS TRIGGER AS
$$

DECLARE chk BOOLEAN;

BEGIN

	chk := chk_employee_age(NEW.ssn);
	
	IF chk := FALSE THEN
		RAISE EXCEPTION  ‘This person is not old enough to be employed’;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER chk_age_trigger
AFTER INSERT OR UPDATE ON employee
FOR EACH ROW EXECUTE FUNCTION chk_age_proc();

	
--2--

CREATE OR REPLACE FUNCTION chk_workplace_type()
RETURNS TRIGGER AS $$
DECLARE
office_counter INT;
warehouse_counter INT;
BEGIN
SELECT COUNT(*) INTO office_counter FROM office WHERE address = NEW.address;

SELECT COUNT(*) INTO warehouse_counter FROM warehouse WHERE address = NEW.address;

IF office_counter > 0 AND warehouse_counter > 0 THEN
RAISE EXCEPTION 'Workplace cannot be both an office and a warehouse.';
END IF;

RETURN NEW;

END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS chk_workplace_type_trigger
CREATE TRIGGER chk_workplace_type_trigger
BEFORE INSERT OR UPDATE ON workplace
FOR EACH ROW EXECUTE FUNCTION chk_workplace_type();


--3--

CREATE OR REPLACE FUNCTION chk_order_in_contains()
RETURNS TRIGGER AS $$
BEGIN
IF NOT EXISTS (SELECT 1 FROM "Order" WHERE order_no = NEW.order_no) THEN
RAISE EXCEPTION 'Order does not exist in "Order" table.';
END IF;
    
RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_chk_order_in_contains
AFTER INSERT ON contains
FOR EACH ROW EXECUTE FUNCTION chk_order_in_contains();
