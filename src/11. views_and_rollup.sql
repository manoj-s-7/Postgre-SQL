/* =========================================================
   VIEWS & ROLLUP (PostgreSQL)
   Topics:
   - CREATE VIEW
   - Aggregation on Views
   - GROUP BY with HAVING
   - ROLLUP for Grand Totals
   ========================================================= */

------------------------------------------------------------
-- VIEW: billing_info
-- Purpose: Order-level billing details with total price
------------------------------------------------------------
CREATE OR REPLACE VIEW billing_info AS
SELECT
    c.c_name,
    o.o_id,
    o.o_date,
    p.p_name,
    p.p_price,
    oi.quantity,
    SUM(p.p_price * oi.quantity) AS total_price
FROM customers c
JOIN orders o        ON c.c_id = o.c_id
JOIN order_items oi  ON o.o_id = oi.o_id
JOIN products p      ON p.p_id = oi.p_id
GROUP BY
    c.c_name,
    o.o_id,
    o.o_date,
    p.p_name,
    p.p_price,
    oi.quantity
ORDER BY
    o.o_id;

-- View data
SELECT * FROM billing_info;

------------------------------------------------------------
-- AGGREGATION ON VIEW
-- Total revenue per product (filtered)
------------------------------------------------------------
SELECT
    p_name,
    SUM(total_price) AS product_revenue
FROM billing_info
GROUP BY p_name
HAVING SUM(total_price) > 1500;

------------------------------------------------------------
-- ROLLUP
-- Product-wise totals + Grand Total
------------------------------------------------------------
SELECT
    COALESCE(p_name, 'Total') AS product_name,
    SUM(total_price) AS total_revenue
FROM billing_info
GROUP BY ROLLUP (p_name)
ORDER BY total_revenue;
