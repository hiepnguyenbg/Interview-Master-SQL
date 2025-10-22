-- Create database
CREATE DATABASE IF NOT EXISTS reorder_pattern_amazon_fresh_db;
USE reorder_pattern_amazon_fresh_db;

-- Drop tables if they exist
DROP TABLE IF EXISTS fct_orders;
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS dim_customers;

-- Create dim_customers table
CREATE TABLE dim_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

-- Create dim_products table
CREATE TABLE dim_products (
    product_id INT PRIMARY KEY,
    product_code VARCHAR(20),
    category VARCHAR(50)
);

-- Create fct_orders table
CREATE TABLE fct_orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    product_id INT,
    customer_id INT,
    reorder_flag INT,
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id)
);

-- Insert data into dim_customers
INSERT INTO dim_customers (customer_id, customer_name) VALUES
(1, 'Alice Smith'),
(2, 'Bob Johnson'),
(3, 'Charlie Davis'),
(4, 'Diana Garcia'),
(5, 'Ethan Martinez'),
(6, 'Fiona Clark'),
(7, 'George Lewis'),
(8, 'Hannah Walker'),
(9, 'Ian Hall'),
(10, 'Julia Allen');

-- Insert data into dim_products
INSERT INTO dim_products (product_id, product_code, category) VALUES
(1, 'FRU001', 'Fruits'),
(2, 'VEG002', 'Vegetables'),
(3, 'MIL003', 'Dairy'),
(4, 'BEV004', 'Beverages'),
(5, 'BAK005', 'Bakery'),
(6, 'FRU006', 'Fruits'),
(7, 'VEG007', 'Vegetables'),
(8, 'MIL008', 'Dairy'),
(9, 'BEV009', 'Beverages'),
(10, 'BAK010', 'Bakery');

-- Insert data into fct_orders
INSERT INTO fct_orders (order_id, order_date, product_id, customer_id, reorder_flag) VALUES
(1001, '2024-10-05', 1, 1, 1),
(1002, '2024-10-12', 2, 2, 0),
(1003, '2024-10-20', 3, 3, 1),
(1004, '2024-11-01', 4, 4, 0),
(1005, '2024-11-15', 5, 5, 1),
(1006, '2024-11-20', 6, 6, 1),
(1007, '2024-12-05', 7, 7, 0),
(1008, '2024-12-10', 8, 8, 1),
(1009, '2024-12-15', 9, 9, 0),
(1010, '2024-12-20', 10, 10, 1),
(1011, '2024-10-25', 1, 1, 1),
(1012, '2024-11-05', 3, 2, 1),
(1013, '2024-11-18', 2, 3, 0),
(1014, '2024-12-02', 4, 4, 1),
(1015, '2024-12-08', 5, 5, 0),
(1016, '2024-12-12', 6, 6, 1),
(1017, '2024-10-30', 7, 7, 1),
(1018, '2024-11-22', 2, 8, 0),
(1019, '2024-11-28', 9, 9, 1),
(1020, '2024-12-25', 10, 10, 0);





-- As a Data Analyst on the Amazon Fresh product team, you and your team are focused on 
-- enhancing the customer experience by streamlining the process for customers to reorder their 
-- favorite grocery items. Your goal is to identify the most frequently reordered product categories, 
-- understand customer preferences for these products, and calculate the average reorder frequency 
-- across categories. By analyzing these metrics, you aim to provide actionable insights that will inform 
-- strategies to improve customer satisfaction and retention.

-- Question 1: The product team wants to analyze the most frequently reordered product categories. 
-- Can you provide a list of the product category codes (using first 3 letters of product code) and their reorder counts for Q4 2024?

SELECT 
    LEFT(dp.product_code, 3) AS cat_code, 
    COUNT(fo.order_id) AS reorder_count
FROM fct_orders fo
JOIN dim_products dp ON fo.product_id = dp.product_id
WHERE fo.order_date BETWEEN '2024-10-01' AND '2024-12-31'
  AND fo.reorder_flag = 1
GROUP BY cat_code
ORDER BY reorder_count DESC;


-- Question 2: To better understand customer preferences, the team needs to know the details of customers who reorder 
-- specific products. Can you retrieve the customer information along with their reordered product code(s) for Q4 2024?

SELECT 
    dc.customer_id, 
    dc.customer_name, 
    dp.product_code
FROM fct_orders fo
JOIN dim_products dp ON fo.product_id = dp.product_id
JOIN dim_customers dc ON fo.customer_id = dc.customer_id
WHERE fo.order_date BETWEEN '2024-10-01' AND '2024-12-31'
  AND fo.reorder_flag = 1;



-- Question 3: When calculating the average reorder frequency, it's important to handle cases where reorder counts may 
-- be missing or zero. Can you compute the average reorder frequency across the product categories, ensuring that any 
-- missing or null values are appropriately managed for Q4 2024?

-- SELECT 
--         dp.category,
--         COUNT(CASE WHEN fo.reorder_flag = 1 THEN 1 END) * 1.0 / 
--         COUNT(fo.order_id) AS reorder_rate
-- FROM dim_products dp
-- LEFT JOIN fct_orders fo 
-- 	ON fo.product_id = dp.product_id
-- 	AND fo.order_date BETWEEN '2024-10-01' AND '2024-12-31'
-- GROUP BY dp.category
-- ORDER BY 2 DESC;



WITH cte AS (
  SELECT category, COUNT(order_id) AS order_count
  FROM fct_orders fo
RIGHT JOIN dim_products dp ON fo.product_id = dp.product_id
AND fo.order_date BETWEEN '2024-10-01' AND '2024-12-31'
  AND fo.reorder_flag = 1 
GROUP BY category 
)
SELECT AVG(order_count)
FROM cte;
