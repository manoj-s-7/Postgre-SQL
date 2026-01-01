CREATE TABLE employees (
    emp_id      SERIAL PRIMARY KEY,
    fname       VARCHAR(50) NOT NULL,
    dept        VARCHAR(30) NOT NULL,
    salary      NUMERIC(10,2) CHECK (salary > 0),
    age         INT CHECK (age BETWEEN 18 AND 60),
    hire_date   DATE NOT NULL,
    bonus       NUMERIC(10,2) DEFAULT 0,
    status      VARCHAR(10) CHECK (status IN ('ACTIVE','INACTIVE'))
);

INSERT INTO employees (fname, dept, salary, age, hire_date, bonus, status) VALUES
('Raj',     'IT',        60000, 28, '2019-06-15', 5000,  'ACTIVE'),
('Priya',   'HR',        45000, 32, '2020-01-10', 3000,  'ACTIVE'),
('Amit',    'IT',        52000, 26, '2021-08-01', 0,     'ACTIVE'),
('Suman',   'Finance',   70000, 40, '2018-03-20', 8000,  'INACTIVE'),
('Neha',    'Marketing', 48000, 24, '2022-11-05', 2000,  'ACTIVE'),
('Karan',   'IT',        39000, 22, '2023-02-14', 0,     'ACTIVE'),
('Pooja',   'HR',        51000, 35, '2017-09-30', 6000,  'INACTIVE'),
('Ravi',    'Finance',   62000, 45, '2016-05-12', 10000, 'ACTIVE'),
('Anita',   'Marketing', 43000, 29, '2021-12-01', 2500,  'ACTIVE'),
('Vikram',  'IT',        75000, 38, '2015-04-18', 12000, 'ACTIVE');

SELECT * FROM employees;
-- LEVEL 1 – WHERE + BETWEEN + ORDER
SELECT * FROM employees
WHERE salary NOT BETWEEN 40000 AND 60000;

SELECT * FROM employees
WHERE status = 'ACTIVE' AND age>25 
ORDER BY salary DESC;

SELECT * FROM employees
WHERE EXTRACT(YEAR FROM hire_date) < 2020 AND bonus = 0;

-- LEVEL 2 – AGGREGATE FUNCTIONS
SELECT dept,SUM(salary) FROM employees 
GROUP BY dept;

SELECT AVG(salary) FROM employees 
WHERE age<30;

SELECT dept,MAX(bonus) FROM employees 
GROUP BY dept;

SELECT COUNT(*) FROM employees 
WHERE status='INACTIVE';

-- LEVEL 3 – GROUP BY + HAVING

SELECT dept,ROUND(AVG(salary)) FROM employees
GROUP BY dept HAVING AVG(salary) > 50000;

SELECT dept,COUNT(*) FROM employees
GROUP BY dept HAVING COUNT(*) > 2;

SELECT dept,SUM(bonus) FROM employees 
GROUP BY dept HAVING SUM(bonus) > 10000;

-- LEVEL 4 – CASE
SELECT fname,salary,
CASE WHEN salary >= 70000 THEN 'HIGH'
	 WHEN salary BETWEEN 50000 AND 69999 THEN 'MEDIUM'
	 ELSE 'LOW'
	END AS salary_level
FROM employees;

SELECT fname,
CASE
    WHEN hire_date < '2019-01-01' THEN 'SENIOR'
    WHEN hire_date BETWEEN '2019-01-01' AND '2021-12-31' THEN 'MID'
    ELSE 'JUNIOR'
END AS experience_level
FROM employees;

-- LEVEL 5 – MIXED TRICKY QUESTIONS
SELECT dept,COUNT(*) FROM employees
WHERE status = 'ACTIVE'
GROUP BY dept; 

SELECT fname,salary,
CASE WHEN bonus = 0 THEN salary*0.1
	 ELSE bonus
	END AS bonus_salary
FROM employees;

SELECT fname, dept, salary
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept = e.dept
);

SELECT fname, age, salary, dept
FROM employees e
WHERE age < 30
AND salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept = e.dept
);

SELECT MAX(salary)
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

