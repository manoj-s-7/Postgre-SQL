/*
====================================================
 PostgreSQL JOINs, GROUP BY & HAVING – Practice File
 Author : Manoj
 Purpose: Master 1-to-Many relationships using
          JOIN, GROUP BY, HAVING & subqueries
====================================================
*/

-- ===============================
-- 1. TABLE CREATION
-- ===============================

CREATE TABLE customers (
    cust_id SERIAL PRIMARY KEY,
    cust_name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    cust_id INT NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
);

-- ===============================
-- 2. DATA INSERTION
-- ===============================

INSERT INTO customers (cust_name, city) VALUES
('Raj', 'Bangalore'),
('Priya', 'Chennai'),
('Amit', 'Mumbai'),
('Sneha', 'Delhi'),
('Karan', 'Hyderabad');

INSERT INTO orders (order_date, amount, cust_id) VALUES
('2024-01-05', 1200.00, 1),
('2024-01-10', 3500.00, 1),
('2024-02-01', 2200.00, 2),
('2024-02-15', 1800.00, 2),
('2024-03-01', 5000.00, 3),
('2024-03-10', 750.00, 3),
('2024-03-18', 3000.00, 3),
('2024-04-01', 2600.00, 5);

-- ===============================
-- 3. VERIFY DATA
-- ===============================

SELECT * FROM customers;
SELECT * FROM orders;

-- ==================================================
-- LEVEL 1 – BASIC JOIN + GROUP BY
-- ==================================================

-- 1. Total order amount per customer (include zero-order customers)
SELECT
    c.cust_name,
    COALESCE(SUM(o.amount), 0) AS total_amount
FROM customers c
LEFT JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name;

-- 2. Customers who placed more than 1 order
SELECT
    c.cust_name,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING COUNT(o.order_id) > 1;

-- 3. Total number of orders per city
SELECT
    c.city,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.city;

-- 4. Customers with NO orders
SELECT
    c.cust_name
FROM customers c
LEFT JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING COUNT(o.order_id) = 0;

-- 5. Average order amount per customer
SELECT
    c.cust_name,
    COALESCE(ROUND(AVG(o.amount), 2), 0) AS avg_order_amount
FROM customers c
LEFT JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name;

-- ==================================================
-- LEVEL 3 – ADVANCED / INTERVIEW LEVEL
-- ==================================================

-- 6. Customers with the highest total order amount (handles ties)
SELECT
    c.cust_name,
    SUM(o.amount) AS total_amount
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING SUM(o.amount) = (
    SELECT MAX(total_per_customer)
    FROM (
        SELECT SUM(amount) AS total_per_customer
        FROM orders
        GROUP BY cust_id
    ) t
);

-- 7. Customers whose total spending is above the average customer spending
SELECT
    c.cust_name,
    SUM(o.amount) AS total_amount
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING SUM(o.amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM orders
        GROUP BY cust_id
    ) t
);

-- 8. Customers who placed orders but never exceeded 3000 in any single order
SELECT
    c.cust_name
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING MAX(o.amount) <= 3000;

-- 9. Cities having at least 2 different customers with orders
SELECT
    c.city,
    COUNT(DISTINCT c.cust_id) AS customer_count
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.city
HAVING COUNT(DISTINCT c.cust_id) >= 2;

-- 10. Customers whose order count is greater than the average order count
SELECT
    c.cust_name,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY cust_id
    ) t
);

/*
===========================================================
 PostgreSQL JOIN + GROUP BY + HAVING
 Level 2 (Tricky) – Practice Queries
 Author : Manoj
===========================================================
*/

-- =========================================================
-- 1. Customers whose TOTAL spending is greater than 4000
-- =========================================================

SELECT
    c.cust_name,
    SUM(o.amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING SUM(o.amount) > 4000;

-- =========================================================
-- 2. Cities where TOTAL order amount exceeds 5000
-- =========================================================

SELECT
    c.city,
    SUM(o.amount) AS city_total_amount
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.city
HAVING SUM(o.amount) > 5000;

-- =========================================================
-- 3. Customers whose AVERAGE order value is greater than 2000
-- =========================================================

SELECT
    c.cust_name,
    ROUND(AVG(o.amount), 2) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING AVG(o.amount) > 2000;

-- =========================================================
-- 4. Customers with MORE THAN 1 order
--    (Show order count + total amount)
-- =========================================================

SELECT
    c.cust_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.amount) AS total_amount
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING COUNT(o.order_id) > 1;

-- =========================================================
-- 5. Customers who placed orders in MORE THAN ONE MONTH
-- =========================================================

SELECT
    c.cust_name,
    COUNT(DISTINCT DATE_TRUNC('month', o.order_date)) AS month_count
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING COUNT(DISTINCT DATE_TRUNC('month', o.order_date)) > 1;

-- ===============================
-- END OF FILE
-- ===============================
