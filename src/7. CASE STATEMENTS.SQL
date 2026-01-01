/* =========================================================
   EMPLOYEES TABLE — CASE STATEMENTS PRACTICE (PostgreSQL)
   ========================================================= */

-- 1. View all employee records
SELECT *
FROM employees;

-- ---------------------------------------------------------

-- 2. Categorize employees based on salary range
SELECT fname,
       salary,
       CASE
           WHEN salary >= 50000 THEN 'HIGH-SALARY'
           WHEN salary >= 40000 THEN 'MID-SALARY'
           ELSE 'LOW-SALARY'
       END AS salary_range
FROM employees;

-- ---------------------------------------------------------

-- 3. Map departments to department types
SELECT fname,
       dept,
       CASE
           WHEN dept = 'IT' THEN 'TECH'
           WHEN dept = 'HR' THEN 'PEOPLE'
           WHEN dept = 'Finance' THEN 'MONEY'
           WHEN dept = 'Marketing' THEN 'MEDIA'
           ELSE 'OTHER'
       END AS dept_type
FROM employees;

-- ---------------------------------------------------------

-- 4. Classify employees based on hiring year
SELECT fname,
       hire_date,
       CASE
           WHEN EXTRACT(YEAR FROM hire_date) < 2020 THEN 'SENIOR'
           WHEN EXTRACT(YEAR FROM hire_date) BETWEEN 2020 AND 2021 THEN 'MID'
           ELSE 'JUNIOR'
       END AS experience
FROM employees;

-- ---------------------------------------------------------

-- 5. Calculate 10% bonus for employees with non-zero salary
SELECT fname,
       salary,
       CASE
           WHEN salary <> 0 THEN ROUND(0.10 * salary)
           ELSE 0
       END AS bonus
FROM employees;

-- ---------------------------------------------------------

-- 6. Count employees in each salary range
SELECT
       CASE
           WHEN salary > 55000 THEN 'HIGH-SALARY'
           WHEN salary BETWEEN 48000 AND 55000 THEN 'MID-SALARY'
           ELSE 'LOW-SALARY'
       END AS salary_range,
       COUNT(*) AS total_employees
FROM employees
GROUP BY salary_range;

-- ---------------------------------------------------------

-- 7. Identify official vs personal email addresses
SELECT email,
       CASE
           WHEN email LIKE '%@example.com' THEN 'OFFICIAL'
           ELSE 'PERSONAL'
       END AS email_type
FROM employees;

-- ---------------------------------------------------------

-- 8. Assign final grade based on department and salary
SELECT fname,
       dept,
       CASE
           WHEN dept = 'IT' AND salary >= 60000 THEN 'A'
           WHEN dept = 'IT' AND salary < 60000 THEN 'B'
           WHEN dept <> 'IT' AND salary >= 50000 THEN 'B'
           ELSE 'C'
       END AS final_grade
FROM employees;

-- ---------------------------------------------------------

-- 9. Rate departments based on average salary
SELECT dept,
       AVG(salary) AS avg_salary,
       CASE
           WHEN AVG(salary) >= 55000 THEN 'EXCELLENT'
           WHEN AVG(salary) >= 45000 THEN 'GOOD'
           ELSE 'NEEDS IMPROVEMENT'
       END AS dept_rating
FROM employees
GROUP BY dept;

-- ---------------------------------------------------------

-- 10. Determine employee tenure status using AGE + INTERVAL
SELECT fname,
       EXTRACT(YEAR FROM hire_date) AS hire_year,
       CASE
           WHEN AGE(CURRENT_DATE, hire_date) >= INTERVAL '5 years' THEN 'LOYAL'
           WHEN AGE(CURRENT_DATE, hire_date) >= INTERVAL '2 years' THEN 'REGULAR'
           ELSE 'NEW'
       END AS tenure_status
FROM employees;

/* ======================= END ============================ */
