-- Create the database
CREATE DATABASE IF NOT EXISTS photo_center_personalized_db;

-- Use the database
USE photo_center_personalized_db;

-- Create the table
CREATE TABLE fct_photo_gift_sales (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    purchase_date DATE,
    quantity INT
);

-- Insert data
INSERT INTO fct_photo_gift_sales (transaction_id, customer_id, product_id, purchase_date, quantity) VALUES
(1001, 1, 101, '2024-04-05', 2),
(1002, 2, 102, '2024-04-10', 1),
(1003, 1, 101, '2024-04-15', 3),
(1004, 3, 103, '2024-04-20', 5),
(1005, 4, 104, '2024-04-08', 4),
(1006, 1, 102, '2024-04-12', 1),
(1007, 2, 101, '2024-04-24', 2),
(1008, 3, 104, '2024-04-29', 3),
(1009, 5, 103, '2024-04-18', 2),
(1010, 6, 102, '2024-04-03', 6),
(1011, 1, 101, '2024-05-02', 2),
(1012, 7, 105, '2024-06-10', 1),
(1013, 9, 101, '2024-06-01', 1),
(1014, 10, 104, '2024-05-15', 4),
(1015, 2, 103, '2024-06-20', 3);







-- As a Data Analyst for the Walmart Photo Center team, you are tasked with evaluating the performance of personalized 
-- photo gifts. Your team aims to enhance customer satisfaction and refine product offerings by analyzing customer 
-- engagement and product popularity. The objective is to identify key purchasing behaviors and trends to inform inventory 
-- and marketing strategies.





-- Question 1: For each personalized photo gift product, what is the total quantity purchased in April 2024? 
-- This result will provide a clear measure of product performance for our inventory strategies.


SELECT product_id, SUM(quantity) AS total_quantity
FROM fct_photo_gift_sales
WHERE purchase_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY product_id;



-- Question 2: What is the maximum number of personalized photo gifts purchased in a single transaction during April 2024? 
-- This information will highlight peak purchasing behavior for individual transactions.

SELECT MAX(quantity) AS max_purchase
FROM fct_photo_gift_sales
WHERE purchase_date BETWEEN '2024-04-01' AND '2024-04-30';



-- Question 3: What is the overall average number of personalized photo gifts purchased per customer during April 2024? 
-- That is, for each customer, calculate the total number of personalized photo gifts they purchased in April 2024 — 
-- then return the average of those values across all customers.

SELECT SUM(quantity) / COUNT(DISTINCT customer_id) AS avg_purchase
FROM fct_photo_gift_sales
WHERE purchase_date BETWEEN '2024-04-01' AND '2024-04-30';



-- SELECT AVG(total_quantity) AS avg_purchase
-- FROM (
--     SELECT customer_id, SUM(quantity) AS total_quantity
--     FROM fct_photo_gift_sales
--     WHERE purchase_date BETWEEN '2024-04-01' AND '2024-04-30'
--     GROUP BY customer_id
-- ) AS customer_totals;


-- Your analyses will help Walmart's Photo Center team understand customer purchasing behavior and product popularity, which is 
-- crucial for optimizing inventory and tailoring marketing strategies to boost customer satisfaction.



