/* =====================================================
   SQL MINI PROJECT: Customers, Orders & Products
   Database: PostgreSQL
   Concepts: PK, FK, JOIN, GROUP BY, HAVING
   ===================================================== */

-- =====================
-- DROP TABLES (Optional)
-- =====================
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- =====================
-- CREATE TABLES
-- =====================

CREATE TABLE customers (
    c_id SERIAL PRIMARY KEY,
    c_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    p_id SERIAL PRIMARY KEY,
    p_name VARCHAR(100) NOT NULL,
    p_price NUMERIC NOT NULL
);

CREATE TABLE orders (
    o_id SERIAL PRIMARY KEY,
    o_date DATE NOT NULL,
    c_id INT NOT NULL,
    FOREIGN KEY (c_id) REFERENCES customers(c_id)
);

CREATE TABLE order_items (
    oi_id SERIAL PRIMARY KEY,
    o_id INT NOT NULL,
    p_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (o_id) REFERENCES orders(o_id),
    FOREIGN KEY (p_id) REFERENCES products(p_id)
);

-- =====================
-- INSERT SAMPLE DATA
-- =====================

INSERT INTO customers (c_name) VALUES
('Arjun'),
('Priya'),
('Rahul'),
('Sneha'),
('Vikram');

INSERT INTO products (p_name, p_price) VALUES
('Laptop', 65000),
('Mouse', 800),
('Keyboard', 1500),
('Monitor', 12000),
('Headphones', 2500),
('Tab', 50000);

INSERT INTO orders (o_date, c_id) VALUES
('2025-01-01', 1),
('2025-01-02', 2),
('2025-01-03', 1),
('2025-01-04', 3),
('2025-01-05', 4);

INSERT INTO order_items (o_id, p_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 5, 1),
(4, 4, 1),
(5, 2, 1),
(5, 3, 1);

-- =====================
-- ANALYTICAL QUERIES
-- =====================

-- 1. Customers who placed at least one order
SELECT DISTINCT c.c_name
FROM customers c
JOIN orders o ON c.c_id = o.c_id;

-- 2. Orders with customer name and date
SELECT o.o_id, c.c_name, o.o_date
FROM customers c
JOIN orders o ON c.c_id = o.c_id;

-- 3. Products never ordered
SELECT p.p_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.p_id = p.p_id
);

-- 4. Total orders per customer
SELECT c.c_name, COUNT(o.o_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.c_id = o.c_id
GROUP BY c.c_name;

-- 5. Total quantity sold per product
SELECT p.p_name, SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON p.p_id = oi.p_id
GROUP BY p.p_name;

-- 6. Total revenue per product
SELECT p.p_name, SUM(p.p_price * oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi ON p.p_id = oi.p_id
GROUP BY p.p_name;

-- 7. Total amount spent per customer
SELECT c.c_name, SUM(p.p_price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.c_id = o.c_id
JOIN order_items oi ON o.o_id = oi.o_id
JOIN products p ON p.p_id = oi.p_id
GROUP BY c.c_name
ORDER BY total_spent DESC;

-- 8. Customers who spent more than 50,000
SELECT c.c_name, SUM(p.p_price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.c_id = o.c_id
JOIN order_items oi ON o.o_id = oi.o_id
JOIN products p ON p.p_id = oi.p_id
GROUP BY c.c_name
HAVING SUM(p.p_price * oi.quantity) > 50000;

-- 9. Order with highest total value
SELECT o.o_id, SUM(p.p_price * oi.quantity) AS order_total
FROM orders o
JOIN order_items oi ON o.o_id = oi.o_id
JOIN products p ON p.p_id = oi.p_id
GROUP BY o.o_id
ORDER BY order_total DESC
LIMIT 1;

-- 10. Customers with orders on different dates
SELECT c.c_name
FROM customers c
JOIN orders o ON c.c_id = o.c_id
GROUP BY c.c_name
HAVING COUNT(DISTINCT o.o_date) > 1;

-- 11. Products ordered by more than 2 customers
SELECT p.p_name
FROM products p
JOIN order_items oi ON p.p_id = oi.p_id
JOIN orders o ON oi.o_id = o.o_id
GROUP BY p.p_name
HAVING COUNT(DISTINCT o.c_id) > 2;

-- 12. Total items per order
SELECT o.o_id, o.o_date, SUM(oi.quantity) AS total_items
FROM orders o
JOIN order_items oi ON o.o_id = oi.o_id
GROUP BY o.o_id, o.o_date
ORDER BY o.o_id;

-- 13. Customers who ordered all products
SELECT c.c_name
FROM customers c
JOIN orders o ON c.c_id = o.c_id
JOIN order_items oi ON o.o_id = oi.o_id
GROUP BY c.c_id, c.c_name
HAVING COUNT(DISTINCT oi.p_id) = (SELECT COUNT(*) FROM products);
