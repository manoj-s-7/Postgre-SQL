CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	fname VARCHAR(50) NOT NULL,
	Lname VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	dept VARCHAR(20),
	salary NUMERIC(10,2) DEFAULT 30000.00,
	hire_date DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO employees (fname, lname, email, dept, salary)
VALUES
('Manoj',   'S',       'manoj.s@company.com',   'IT',       45000.00),
('Akash',   'Kumar',   'akash.k@company.com',   'HR',       38000.00),
('Ravi',    'Sharma',  'ravi.s@company.com',    'Finance',  52000.00),
('Sneha',   'Patil',   'sneha.p@company.com',   'IT',       48000.00),
('Ananya',  'Iyer',    'ananya.i@company.com',  'Marketing',42000.00),
('Rahul',   'Verma',   'rahul.v@company.com',   'Sales',    40000.00),
('Priya',   'Nair',    'priya.n@company.com',   'HR',       39000.00),
('Karthik', 'Rao',     'karthik.r@company.com', 'IT',       55000.00),
('Neha',    'Singh',   'neha.s@company.com',    'Finance',  50000.00),
('Arjun',   'Mehta',   'arjun.m@company.com',   'Sales',    41000.00);

INSERT INTO employees(fname,lname,email,dept) VALUES ('Rohit','Shetty','rohitshetty7@company.com','IT');

-- ERROR DUE TO DUPLICATE KEY (EMAIL)

INSERT INTO employees(fname,lname,email,dept) VALUES ('Manoj','Shetty','rohitshetty7@company.com','IT');

SELECT * FROM employees