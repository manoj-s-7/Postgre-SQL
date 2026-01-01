-- ============================================
-- EMPLOYEES TABLE PRACTICE (PostgreSQL)
-- Covers: DML, WHERE, ORDER BY, LIMIT, AGGREGATES, GROUP BY, HAVING
-- ============================================


-- ❌ Remove all data from the table (FAST, irreversible)
TRUNCATE TABLE employees;


-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

INSERT INTO employees (emp_id, fname, lname, email, dept, salary, hire_date)
VALUES
(1, 'Raj', 'Sharma', 'raj.sharma@example.com', 'IT', 50000.00, '2020-01-15'),
(2, 'Priya', 'Singh', 'priya.singh@example.com', 'HR', 45000.00, '2019-03-22'),
(3, 'Arjun', 'Verma', 'arjun.verma@example.com', 'IT', 55000.00, '2021-06-01'),
(4, 'Suman', 'Patel', 'suman.patel@example.com', 'Finance', 60000.00, '2018-07-30'),
(5, 'Kavita', 'Rao', 'kavita.rao@example.com', 'HR', 47000.00, '2020-11-10'),
(6, 'Amit', 'Gupta', 'amit.gupta@example.com', 'Marketing', 52000.00, '2020-09-25'),
(7, 'Neha', 'Desai', 'neha.desai@example.com', 'IT', 48000.00, '2019-05-18'),
(8, 'Rahul', 'Kumar', 'rahul.kumar@example.com', 'IT', 53000.00, '2021-02-14'),
(9, 'Anjali', 'Mehta', 'anjali.mehta@example.com', 'Finance', 61000.00, '2018-12-03'),
(10, 'Vijay', 'Nair', 'vijay.nair@example.com', 'Marketing', 50000.00, '2020-04-19');

-- Insert single record
INSERT INTO employees
VALUES (11, 'Kushal', 'Nayak', 'kushal.nayak@example.com',
        'Marketing', 60000.00, '2020-04-19');


-- View all data
SELECT * FROM employees;


-- ============================================
-- WHERE CLAUSE (Row Filtering)
-- ============================================

SELECT * FROM employees WHERE dept = 'IT';
SELECT * FROM employees WHERE fname = 'Raj';
SELECT * FROM employees WHERE emp_id = 5;
SELECT * FROM employees WHERE salary >= 50000;

-- OR condition
SELECT * FROM employees WHERE dept = 'IT' OR dept = 'HR';

-- IN operator (recommended)
SELECT * FROM employees WHERE dept IN ('HR', 'IT');

-- NOT IN
SELECT * FROM employees WHERE dept NOT IN ('HR', 'IT');

-- AND condition
SELECT * FROM employees WHERE dept = 'IT' AND salary <= 50000;


-- ============================================
-- BETWEEN (Range Filtering)
-- ============================================

SELECT * FROM employees
WHERE salary BETWEEN 40000 AND 60000;


-- ============================================
-- ORDER BY (Sorting)
-- ============================================

SELECT * FROM employees ORDER BY salary;          -- Ascending (default)
SELECT * FROM employees ORDER BY dept DESC;       -- Descending


-- ============================================
-- LIMIT & OFFSET
-- ============================================

SELECT * FROM employees LIMIT 5;

SELECT * FROM employees
WHERE salary BETWEEN 30000 AND 65000
LIMIT 7;

SELECT * FROM employees
WHERE salary BETWEEN 30000 AND 65000
LIMIT 7 OFFSET 5;


-- ============================================
-- DISTINCT (Unique values)
-- ============================================

SELECT DISTINCT dept FROM employees;


-- ============================================
-- LIKE (Pattern Matching)
-- ============================================

SELECT * FROM employees WHERE fname LIKE 'A%';    -- Starts with A
SELECT * FROM employees WHERE fname LIKE '%a';    -- Ends with a
SELECT * FROM employees WHERE fname LIKE '%i%';   -- Contains i
SELECT * FROM employees WHERE fname LIKE '_i%';   -- i as second letter
SELECT * FROM employees WHERE fname LIKE '%john%';-- Contains "john"
SELECT * FROM employees WHERE dept LIKE '__';     -- Exactly 2 characters


-- ============================================
-- AGGREGATE FUNCTIONS
-- ============================================

SELECT COUNT(*) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;


-- ============================================
-- GROUP BY
-- ============================================

-- Employees per department
SELECT dept, COUNT(*) AS emp_count
FROM employees
GROUP BY dept;

-- Average salary per department
SELECT dept, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept;

-- Max salary per department
SELECT dept, MAX(salary) AS max_salary
FROM employees
GROUP BY dept;

-- Min salary per department
SELECT dept, MIN(salary) AS min_salary
FROM employees
GROUP BY dept;

-- Total salary per department
SELECT dept, SUM(salary) AS total_salary
FROM employees
GROUP BY dept;


-- Employees hired per year
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year,
       COUNT(*) AS emp_count
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date);


-- ============================================
-- HAVING (Filter Groups)
-- ============================================

-- Departments with more than 2 employees
SELECT dept, COUNT(*) AS emp_count
FROM employees
GROUP BY dept
HAVING COUNT(*) > 2;

-- Departments with avg salary > 50000
SELECT dept, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept
HAVING AVG(salary) > 50000;

-- Years with more than 2 hires
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year,
       COUNT(*) AS emp_count
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
HAVING COUNT(*) > 2;


-- ============================================
-- WHERE + GROUP BY
-- ============================================

-- Exclude HR department
SELECT dept, COUNT(*) AS emp_count
FROM employees
WHERE dept <> 'HR'
GROUP BY dept;


-- ============================================
-- INTERVIEW-LEVEL QUERIES
-- ============================================

-- Avg salary by department for employees hired after 2019
SELECT dept, AVG(salary) AS avg_salary
FROM employees
WHERE hire_date > '2019-12-31'
GROUP BY dept;

-- Departments with total salary between 100k and 200k
SELECT dept, SUM(salary) AS total_salary
FROM employees
GROUP BY dept
HAVING SUM(salary) BETWEEN 100000 AND 200000;

-- Department with highest salary
SELECT dept, MAX(salary) AS max_salary
FROM employees
GROUP BY dept
ORDER BY max_salary DESC
LIMIT 1;

-- Department with highest average salary
SELECT dept, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept
ORDER BY avg_salary DESC
LIMIT 1;

-- Earliest hire date per department
SELECT dept, MIN(hire_date) AS earliest_hire
FROM employees
GROUP BY dept
ORDER BY earliest_hire;


-- ============================================
-- TRICKY GROUP BY
-- ============================================

-- Departments where employees hired after 2019
-- AND average salary > 50000
SELECT dept,
       COUNT(*) AS emp_count,
       AVG(salary) AS avg_salary
FROM employees
WHERE hire_date > '2019-12-31'
GROUP BY dept
HAVING AVG(salary) > 50000;

-- Years where total salary > 100000
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year,
       COUNT(*) AS emp_count,
       SUM(salary) AS total_salary
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
HAVING SUM(salary) > 100000;

-- Departments where minimum salary > 45000
SELECT dept,
       MIN(salary) AS min_salary,
       MAX(salary) AS max_salary
FROM employees
GROUP BY dept
HAVING MIN(salary) > 45000;
