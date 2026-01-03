/* =========================================================
   POSTGRESQL TRIGGERS
   Topic:
   - BEFORE UPDATE trigger
   - Data validation using NEW record
   ========================================================= */

------------------------------------------------------------
-- VIEW CURRENT EMPLOYEES DATA
------------------------------------------------------------
SELECT * FROM employees;

------------------------------------------------------------
-- TRIGGER FUNCTION:
-- Ensures salary is never negative
------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_salary()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- If updated salary is negative, reset it to 0
    IF NEW.salary < 0 THEN
        NEW.salary := 0;
    END IF;

    RETURN NEW;
END;
$$;

------------------------------------------------------------
-- TRIGGER:
-- Executes BEFORE UPDATE on employees table
------------------------------------------------------------
CREATE TRIGGER before_updt_salary
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION check_salary();

------------------------------------------------------------
-- REMOVE EXISTING CHECK CONSTRAINT (if any)
-- Allows trigger-based validation instead
------------------------------------------------------------
ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_salary_check;

------------------------------------------------------------
-- TEST CASES
------------------------------------------------------------

-- Attempt to set negative salary (trigger will correct it to 0)
CALL updt_salary(-50000, 10);

-- Valid salary update
CALL updt_salary(50000, 10);

-- Verify result
SELECT emp_id, fname, salary
FROM employees
WHERE emp_id = 10;
