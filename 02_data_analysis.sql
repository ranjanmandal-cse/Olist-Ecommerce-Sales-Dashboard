SHOW DATABASES;
use olist;


-- DATA ANALYSIS - OLIST E-COMMERCE DATASET

-- KPI ANALYSIS

-- Total Revenue
-- Result: 16008872.12
SELECT ROUND(SUM(payment_value), 2) AS Total_Revenue
FROM order_payments
WHERE payment_value > 0;

-- Total Orders
-- Result: 98666
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM order_items;

-- Total Customers
-- Result: 96096
SELECT COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM customers;

-- PAYMENT ANALYSIS

-- Revenue by payment type
-- Result:
-- payment_type  Revenue
-- boleto  2869361.27
-- credit_card  12542084.19
-- debit_card  217989.79
-- not_defined  0
-- voucher  379436.87

SELECT payment_type,
       ROUND(SUM(payment_value), 2) AS Revenue
FROM order_payments
GROUP BY payment_type;

-- ORDER ANALYSIS

-- Number of orders by status
-- Result:
-- order_status  Total_Orders
-- delivered	96478
-- invoiced	314
-- shipped	1107
-- processing	301
-- unavailable	609
-- canceled	625
-- created	5
-- approved	2
SELECT order_status,
       COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY order_status;


-- ===========================
-- CUSTOMER ANALYSIS
-- ===========================

-- Number of customers by state
-- Result:
-- customer_state  customer_count
-- AC  81
-- AL  413
-- AP  68
-- BA  3380
-- etc.
SELECT customer_state,
       COUNT(DISTINCT customer_id) AS customer_count
FROM customers
GROUP BY customer_state;

-- Finding the highest customer count among all states
-- Result: 41746
WITH number_of_customers AS (
    SELECT customer_state,
           COUNT(DISTINCT customer_id) AS customer_count
    FROM customers
    GROUP BY customer_state
)
SELECT MAX(customer_count) AS Highest_Customer_Count
FROM number_of_customers;


-- TIME SERIES ANALYSIS

-- Monthly order trend
-- Result:
-- Monthy  Total_Orders
-- January	8069
-- February	8508
-- March	9893
-- April	9343
-- May	10573
-- June	9412
-- July	10318
-- August	10843
-- September	4305
-- October	4959
-- November	7544
-- December	5674

SELECT
    MONTHNAME(order_purchase_timestamp) AS Month,
    COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY MONTH(order_purchase_timestamp),
         MONTHNAME(order_purchase_timestamp)
ORDER BY MONTH(order_purchase_timestamp);

-- Revenue by month
-- Result:
-- Month  Revenue
-- January	1253492.22
-- February	1284371.35
-- March	1609515.72
-- April	1578573.51
-- May	1746900.97
-- June	1535156.88
-- July	1658923.67
-- August	1696821.64
-- September	732454.23
-- October	839358.03
-- November	1194882.8
-- December	878421.1
SELECT
    MONTHNAME(o.order_purchase_timestamp) AS Month,
    ROUND(SUM(op.payment_value), 2) AS Revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
WHERE op.payment_value > 0
GROUP BY MONTH(o.order_purchase_timestamp),
         MONTHNAME(o.order_purchase_timestamp)
ORDER BY MONTH(o.order_purchase_timestamp);