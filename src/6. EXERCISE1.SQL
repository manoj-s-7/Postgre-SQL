-- EXSERCISE STRING FUNCTIONS
SELECT CONCAT_WS(':',emp_id,fname,lname,dept) FROM employees WHERE emp_id = 1;

SELECT CONCAT_WS(':',emp_id,CONCAT_WS(' ',fname,lname),dept,salary) FROM employees LIMIT 1;

SELECT CONCAT_WS(':',emp_id,fname,UPPER(dept)) FROM employees WHERE emp_id = 4;

SELECT CONCAT_WS(' ',CONCAT(LEFT(DEPT,1),emp_id),fname) FROM employees LIMIT 5;

-- EXSERCISE CLAUSES

SELECT DISTINCT dept FROM employees;

SELECT * FROM employees ORDER BY salary DESC;

SELECT * FROM employees LIMIT 3;

SELECT * FROM employees  WHERE fname LIKE 'A%';

SELECT * FROM employees  WHERE LENGTH(lname) = 4;

-- EXSERCISE AGGREGATE
SELECT COUNT(*) FROM employees;

SELECT dept,COUNT(*) FROM employees GROUP BY dept;

SELECT * FROM employees ORDER BY salary DESC LIMIT 1;
SELECT SUM(salary) FROM employees WHERE dept='IT';

SELECT dept,AVG(salary) FROM employees GROUP BY dept;

-- SUBQUERY 
SELECT * FROM employees WHERE salary=(SELECT MAX(salary) FROM employees); --✅

SELECT * FROM employees WHERE salary=(SELECT MIN(salary) FROM employees); --✅

