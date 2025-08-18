-- Create the database
CREATE DATABASE IF NOT EXISTS everyday_necessaities_price_optimization_db;
USE everyday_necessaities_price_optimization_db;

-- Create dim_products table
CREATE TABLE dim_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(255)
);

-- Insert data into dim_products
INSERT INTO dim_products (product_id, product_name, category) VALUES
(1, 'Paper Towels', 'Essential Household'),
(2, 'Toilet Paper', 'Essential Household'),
(3, 'Laundry Detergent', 'Essential Household'),
(4, 'Dish Soap', 'Essential Household'),
(5, 'Batteries', 'Other'),
(6, 'Snacks', 'Other'),
(7, 'Cleaning Spray', 'Essential Household'),
(8, 'Shampoo', 'Other'),
(9, 'Hand Soap', 'Essential Household'),
(10, 'Face Mask', 'Essential Household');

-- Create fct_sales table
CREATE TABLE fct_sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id)
);

-- Insert data into fct_sales
INSERT INTO fct_sales (sale_id, sale_date, product_id, unit_price, quantity_sold) VALUES
(1, '2024-07-05', 1, 4.50, 10),
(2, '2024-07-06', 2, 6.00, 5),
(3, '2024-07-07', 3, 16.00, 7),
(4, '2024-07-08', 4, 3.99, 12),
(5, '2024-07-10', 1, 4.75, 8),
(6, '2024-07-11', 2, 7.50, 6),
(7, '2024-07-12', 3, 15.50, 4),
(8, '2024-07-13', 7, 5.00, 15),
(9, '2024-07-14', 7, 17.00, 9),
(10, '2024-07-15', 4, 3.50, 11),
(11, '2024-07-16', 5, 8.00, 20),
(12, '2024-07-17', 6, 2.50, 30),
(13, '2024-07-18', 8, 12.00, 5),
(14, '2024-07-19', 2, 6.50, 4),
(15, '2024-07-20', 1, 4.25, 3),
(16, '2024-07-20', 9, 4.00, 10),
(17, '2024-07-21', 10, 16.50, 6);




-- You are a Data Analyst in the Physical Stores Pricing Strategy team, working to ensure competitive pricing for 
-- essential household items. Your team is focused on categorizing products by price range and understanding sales 
-- trends to maintain affordability for customers. The objective is to use data to identify which price ranges 
-- drive the most sales volume, aiding in strategic pricing decisions.



-- Question 1: What is the total sales volume for essential household items in July 2024? Provide the result 
-- with a column named 'Total_Sales_Volume'.

SELECT 
    SUM(fs.quantity_sold * fs.unit_price) AS Total_Sales_Volume
FROM fct_sales fs
JOIN dim_products dp 
    ON fs.product_id = dp.product_id
WHERE fs.sale_date BETWEEN '2024-07-01' AND '2024-07-31'
  AND dp.category = 'Essential Household';


-- Question 2: For essential household items sold in July 2024, categorize the items into 'Low', 'Medium', and 'High' 
-- price ranges based on their average price. Use the following criteria: 'Low' for prices below $5, 'Medium' for 
-- prices between $5 and $15, and 'High' for prices above $15.


SELECT 
    dp.product_name,
    CASE 
        WHEN AVG(fs.unit_price) < 5 THEN 'Low'
        WHEN AVG(fs.unit_price) > 15 THEN 'High'
        ELSE 'Medium'
    END AS price_categorization
FROM fct_sales fs
JOIN dim_products dp 
    ON fs.product_id = dp.product_id
WHERE fs.sale_date BETWEEN '2024-07-01' AND '2024-07-31'
  AND dp.category = 'Essential Household'
GROUP BY dp.product_name;


-- Question 3: Identify the price range with the highest total sales volume for essential household items in 
-- July 2024. Use the same criteria as the previous question: 'Low' for prices below $5, 'Medium' for prices 
-- between $5 and $15, and 'High' for prices above $15.

--  Provide the result with columns named 'Price_Range' and 'Total_Sales_Volume'.


WITH price_range AS (
  SELECT 
    dp.product_name,
    SUM(fs.quantity_sold) AS product_volume,
    CASE 
      WHEN AVG(fs.unit_price) < 5 THEN 'Low'
      WHEN AVG(fs.unit_price) > 15 THEN 'High'
      ELSE 'Medium'
    END AS Price_Range
  FROM fct_sales fs
  JOIN dim_products dp 
    ON fs.product_id = dp.product_id
  WHERE fs.sale_date BETWEEN '2024-07-01' AND '2024-07-31'
    AND dp.category = 'Essential Household'
  GROUP BY dp.product_name
)
SELECT
  Price_Range, 
  SUM(product_volume) AS Total_Sales_Volume
FROM price_range
GROUP BY Price_Range
ORDER BY Total_Sales_Volume DESC
LIMIT 1;



-- WITH categorized_products AS (
--   SELECT 
--     fs.product_id,
--     dp.product_name,
--     CASE 
--       WHEN AVG(fs.unit_price) < 5 THEN 'Low'
--       WHEN AVG(fs.unit_price) > 15 THEN 'High'
--       ELSE 'Medium'
--     END AS Price_Range
--   FROM fct_sales fs
--   JOIN dim_products dp ON fs.product_id = dp.product_id
--   WHERE fs.sale_date BETWEEN '2024-07-01' AND '2024-07-31'
--     AND dp.category = 'Essential Household'
--   GROUP BY fs.product_id, dp.product_name
-- ),
-- sales_with_range AS (
--   SELECT 
--     cp.Price_Range,
--     fs.quantity_sold * fs.unit_price AS sale_amount
--   FROM fct_sales fs
--   JOIN categorized_products cp ON fs.product_id = cp.product_id
--   WHERE fs.sale_date BETWEEN '2024-07-01' AND '2024-07-31'
-- )
-- SELECT 
--   Price_Range,
--   ROUND(SUM(sale_amount), 2) AS Total_Sales_Volume
-- FROM sales_with_range
-- GROUP BY Price_Range
-- ORDER BY Total_Sales_Volume DESC
-- LIMIT 1;


