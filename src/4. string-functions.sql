-- STRING FUNCTIONS 

-- CONCAT
SELECT CONCAT('HELLO','WORLD');

SELECT * FROM employees;

SELECT CONCAT(fname,lname) FROM employees;

SELECT CONCAT(fname,lname) AS fullname FROM employees;

SELECT CONCAT(fname,' ',lname) AS fullname FROM employees; --❌
SELECT CONCAT_WS(' ',fname,lname) AS fullname FROM employees; --✅

-- SUBSTRING 
SELECT SUBSTR('HELLO BUDDY',7,11)

-- REPLACE
SELECT REPLACE('HELLO BUDDY','HELLO','HEY')

SELECT REPLACE(dept,'IT','TECH') FROM employees;

-- LENGTH

SELECT LENGTH(fname) FROM employees;

SELECT *  FROM employees WHERE LENGTH(fname) > 5;

-- upper and lower 
SELECT  UPPER(fname) FROM employees;

-- left n right

SELECT LEFT('HELLO WORLD',5);
SELECT RIGHT('HELLO WORLD',5);

-- TRIM 
SELECT LENGTH('    MANOJ@123    ');
SELECT LENGTH(TRIM('    MANOJ@123    '));
-- POSITION
SELECT POSITION('om' IN 'Thomas')

