SHOW DATABASES;

-- DATA CLEANING - OLIST E-COMMERCE DATASET
USE olist;

-- CUSTOMERS TABLE

-- Total number of records in customers table
-- Result: 99441
SELECT COUNT(*)
FROM customers; 

-- Check for NULL or blank customer_id values
-- Result: Not any NULL or blank
SELECT customer_id
FROM customers
WHERE customer_id IS NULL
   OR customer_id = '';

-- Check for NULL or blank customer_unique_id values
-- Result: Not any NULL or blank
SELECT customer_unique_id
FROM customers
WHERE customer_unique_id IS NULL
   OR customer_unique_id = '';

-- Check for NULL or blank customer_zip_code_prefix values
-- Result: Not any NULL or blank
SELECT customer_zip_code_prefix
FROM customers
WHERE customer_zip_code_prefix IS NULL
   OR customer_zip_code_prefix = '';

-- Check for NULL or blank customer_city values
-- Result: Not any NULL or blank
SELECT customer_city
FROM customers
WHERE customer_city IS NULL
   OR customer_city = '';

-- Check for NULL or blank customer_state values
-- Result: Not any NULL or blank
SELECT customer_state
FROM customers
WHERE customer_state IS NULL
   OR customer_state = '';

-- Validate state codes (should be exactly two uppercase letters)
-- Result: Not any lower case letters
SELECT customer_state
FROM customers
WHERE customer_state NOT REGEXP '^[A-Z]{2}$';

-- Check for duplicate customer_id values
-- Result: Not any duplicate values
SELECT customer_id,
       COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check for duplicate customer_unique_id values
-- Result: Many customers have customer_unique_id
SELECT customer_unique_id,
       COUNT(*)
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;


-- ORDER_ITEMS TABLE

-- Total number of records
-- Result: 112650
SELECT COUNT(*)
FROM order_items;

-- Check for negative order_item_id values
-- Result:
SELECT order_item_id
FROM order_items
WHERE order_item_id < 0;

-- Check for zero or negative product prices
-- Result: Not any price
SELECT price
FROM order_items
WHERE price <= 0;

-- Count products with zero or negative prices
-- Result: 0
WITH number_of_zeroes AS (
    SELECT price
    FROM order_items
    WHERE price <= 0
)
SELECT COUNT(price)
FROM number_of_zeroes;

-- Check for zero or negative freight values
-- Result: Many freight values are 0.
SELECT freight_value
FROM order_items
WHERE freight_value <= 0;

-- Check for NULL or blank order_item_id values
-- Result: No any found.
SELECT order_item_id
FROM order_items
WHERE order_item_id IS NULL
   OR order_item_id = '';

-- Check duplicate order_id values
-- Note: Multiple products can belong to the same order.
-- Result: Many records are found.
SELECT order_id,
       COUNT(*)
FROM order_items
GROUP BY order_id
HAVING COUNT(*) > 1;


-- ORDER_PAYMENTS TABLE

-- Total number of records
-- Result: 103886
SELECT COUNT(*)
FROM order_payments;

-- Check for negative payment installments
-- Result: No any found.
SELECT payment_installments
FROM order_payments
WHERE payment_installments < 0;

-- Count negative payment installments
-- Result: 0
WITH number_of_payment_installments AS (
    SELECT payment_installments
    FROM order_payments
    WHERE payment_installments < 0
)
SELECT COUNT(payment_installments)
FROM number_of_payment_installments;

-- Check for zero or negative payment values
-- Result: Many records are there.
SELECT order_id,
       payment_value
FROM order_payments
WHERE payment_value <= 0;

-- Count zero or negative payment values
-- Result: 9
WITH number_of_zeroes AS (
    SELECT order_id,
           payment_value
    FROM order_payments
    WHERE payment_value <= 0
)
SELECT COUNT(order_id)
FROM number_of_zeroes;

-- Check for NULL or blank order_id values
-- Result: No any found.
SELECT order_id
FROM order_payments
WHERE order_id IS NULL
   OR order_id = '';

-- Check duplicate order_id values
-- Note: Multiple payment records can belong to one order.
-- Result: Many
SELECT order_id,
       COUNT(*)
FROM order_payments
GROUP BY order_id
HAVING COUNT(*) > 1;

-- ORDERS TABLE

-- Total number of records
-- Result: 99441
SELECT COUNT(*)
FROM orders;

-- Check for NULL or blank order_id values
-- Result: Not any
SELECT order_id
FROM orders
WHERE order_id IS NULL
   OR order_id = '';

-- Check for NULL or blank order_status values
-- Result:
SELECT order_status
FROM orders
WHERE order_status IS NULL
   OR order_status = '';

-- Count NULL or blank order_status values
-- Result: 0
WITH number_of_zeroes AS (
    SELECT order_status
    FROM orders
    WHERE order_status IS NULL
       OR order_status = ''
)
SELECT COUNT(order_status)
FROM number_of_zeroes;

-- Check missing order_delivered_carrier_date values
-- Result: Many
SELECT order_id,
       order_delivered_carrier_date
FROM orders
WHERE order_delivered_carrier_date IS NULL
   OR order_delivered_carrier_date = '';

-- Count missing order_delivered_carrier_date values
-- Result: 1783
WITH number_of_rows AS (
    SELECT order_id,
           order_delivered_carrier_date
    FROM orders
    WHERE order_delivered_carrier_date IS NULL
       OR order_delivered_carrier_date = ''
)
SELECT COUNT(order_id)
FROM number_of_rows;

-- Analyze missing carrier dates by order status
-- Result: Not any
SELECT order_status,
       COUNT(*) AS cnt
FROM orders
WHERE order_delivered_carrier_date IS NULL
GROUP BY order_status;

-- Check delivered orders with missing carrier date
-- Result: Not any
SELECT *
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NULL;


-- PRODUCTS TABLE

-- Check for NULL or blank product_id values
-- Result: No any found.
SELECT product_id
FROM products
WHERE product_id IS NULL
   OR product_id = '';

-- Check for NULL or blank product_category_name values
-- Result: No any found.
SELECT product_category_name
FROM products
WHERE product_category_name IS NULL
   OR product_category_name = '';

-- Count missing product categories
-- Result: 0
WITH number_of_zeroes AS (
    SELECT product_category_name
    FROM products
    WHERE product_category_name IS NULL
       OR product_category_name = ''
)
SELECT COUNT(product_category_name)
FROM number_of_zeroes;

-- Check products with zero dimensions or weight
-- Result: many records of product_weight_g are 0.
SELECT product_id,
       product_weight_g,
       product_width_cm
FROM products
WHERE product_weight_g = 0
   OR product_width_cm = 0;

-- Check duplicate product_id values
-- Result: No any found.
SELECT product_id,
       COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;