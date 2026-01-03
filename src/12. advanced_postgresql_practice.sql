/* =========================================================
   ADVANCED POSTGRESQL PRACTICE
   Topics Covered:
   - Stored Procedures
   - User Defined Functions (UDF)
   - Window Functions
   - LEAD / LAG
   - Common Table Expressions (CTE)
   ========================================================= */

------------------------------------------------------------
-- VIEW ALL EMPLOYEES
------------------------------------------------------------
SELECT * FROM employees;

------------------------------------------------------------
-- STORED PROCEDURE: UPDATE SALARY BY EMP_ID
------------------------------------------------------------
CREATE OR REPLACE PROCEDURE updt_salary(
    p_sal NUMERIC(10,2),
    p_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary = p_sal
    WHERE emp_id = p_id;
END;
$$;

CALL updt_salary(100000, 10);

------------------------------------------------------------
-- STORED PROCEDURE: ADD NEW EMPLOYEE
------------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_employee(
    fname VARCHAR,
    dept VARCHAR,
    salary NUMERIC,
    age INT,
    hire_date DATE,
    bonus NUMERIC,
    status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employees (
        fname, dept, salary, age, hire_date, bonus, status
    )
    VALUES (
        fname, dept, salary, age, hire_date, bonus, status
    );
END;
$$;

CALL add_employee(
    'Manish', 'IT', 75000, 26, '2024-01-12', 5000, 'ACTIVE'
);

------------------------------------------------------------
-- UDF: HIGHEST PAID EMPLOYEE(S) IN A GIVEN DEPARTMENT
------------------------------------------------------------
CREATE OR REPLACE FUNCTION max_salary_dept(p_dept_name VARCHAR)
RETURNS TABLE (
    emp_id INT,
    fname VARCHAR,
    salary NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.emp_id, e.fname, e.salary
    FROM employees e
    WHERE e.dept = p_dept_name
      AND e.salary = (
          SELECT MAX(e2.salary)
          FROM employees e2
          WHERE e2.dept = p_dept_name
      );
END;
$$;

SELECT * FROM max_salary_dept('IT');

------------------------------------------------------------
-- WINDOW FUNCTIONS
------------------------------------------------------------

-- Running total of salary (company-wide)
SELECT 
    fname,
    salary,
    SUM(salary) OVER (ORDER BY salary) AS running_total
FROM employees;

-- Running average of salary
SELECT 
    fname,
    salary,
    AVG(salary) OVER (ORDER BY salary) AS running_avg
FROM employees;

-- Highest paid employee per department
SELECT fname, dept, salary
FROM (
    SELECT 
        fname,
        dept,
        salary,
        RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 1;

-- Employee count per department (window function)
SELECT DISTINCT
    dept,
    COUNT(*) OVER (PARTITION BY dept) AS dept_count
FROM employees;

-- Top 3 highest paid employees per department
SELECT fname, dept, salary
FROM (
    SELECT 
        fname,
        dept,
        salary,
        RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS rk
    FROM employees
) t
WHERE rk <= 3
ORDER BY dept, salary DESC;

-- First hired employee per department
SELECT emp_id, fname, dept, hire_date
FROM (
    SELECT 
        emp_id,
        fname,
        dept,
        hire_date,
        RANK() OVER (PARTITION BY dept ORDER BY hire_date ASC) AS rk
    FROM employees
) t
WHERE rk = 1;

-- Cumulative salary per department
SELECT 
    fname,
    dept,
    salary,
    SUM(salary) OVER (
        PARTITION BY dept
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM employees
ORDER BY dept, salary;

------------------------------------------------------------
-- LEAD & LAG
------------------------------------------------------------

-- Salary difference from previous employee in department
SELECT 
    fname,
    dept,
    salary,
    salary - LAG(salary) OVER (PARTITION BY dept ORDER BY salary) AS diff_from_prev
FROM employees;

-- Days gap between hires in department
SELECT 
    fname,
    hire_date,
    hire_date - LAG(hire_date) OVER (PARTITION BY dept ORDER BY hire_date) AS days_gap
FROM employees;

-- Next salary in department
SELECT 
    fname,
    salary,
    LEAD(salary) OVER (PARTITION BY dept ORDER BY salary) AS next_salary
FROM employees;

------------------------------------------------------------
-- CTEs (COMMON TABLE EXPRESSIONS)
------------------------------------------------------------

-- Employees earning above department average (GROUP BY CTE)
WITH avg_salary_dept AS (
    SELECT dept, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY dept
)
SELECT 
    e.emp_id,
    e.fname,
    e.dept,
    e.salary,
    a.avg_sal
FROM employees e
JOIN avg_salary_dept a
ON e.dept = a.dept
WHERE e.salary > a.avg_sal;

-- Employees earning above department average (WINDOW + CTE)
WITH dept_avg AS (
    SELECT 
        emp_id,
        fname,
        dept,
        salary,
        AVG(salary) OVER (PARTITION BY dept) AS avg_dept_salary
    FROM employees
)
SELECT 
    emp_id,
    fname,
    dept,
    salary,
    ROUND(avg_dept_salary, 2) AS avg_dept_salary
FROM dept_avg
WHERE salary > avg_dept_salary;

-- Highest paid employees per department using CTE
WITH ranked_employees AS (
    SELECT 
        emp_id,
        fname,
        dept,
        salary,
        RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS rk
    FROM employees
),
top_paid AS (
    SELECT * FROM ranked_employees WHERE rk = 1
)
SELECT * FROM top_paid;

-- Highest salary per department (GROUP BY + JOIN)
WITH max_salary_dept AS (
    SELECT dept, MAX(salary) AS max_salary
    FROM employees
    GROUP BY dept
)
SELECT e.fname, e.dept, e.salary
FROM employees e
JOIN max_salary_dept a
ON e.dept = a.dept
WHERE e.salary = a.max_salary;

-- Highest salary per department (WINDOW FUNCTION)
WITH max_sal_dept AS (
    SELECT 
        fname,
        dept,
        salary,
        MAX(salary) OVER (PARTITION BY dept) AS max_sal
    FROM employees
)
SELECT fname, dept, salary
FROM max_sal_dept
WHERE salary = max_sal;
