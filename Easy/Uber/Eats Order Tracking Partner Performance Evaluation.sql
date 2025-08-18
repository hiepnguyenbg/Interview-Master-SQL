-- Create the database
CREATE DATABASE IF NOT EXISTS eats_order_tracking_partner_db;

-- Use the new database
USE eats_order_tracking_partner_db;

-- Create the table
CREATE TABLE fct_orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    delivery_partner_id INT,
    actual_delivery_time DATETIME,
    delivery_partner_name VARCHAR(100),
    expected_delivery_time DATETIME
);

-- Insert data into the table
INSERT INTO fct_orders (order_id, order_date, delivery_partner_id, actual_delivery_time, delivery_partner_name, expected_delivery_time)
VALUES
(1, '2024-01-05', 1, '2024-01-05 11:45:00', 'Alice', '2024-01-05 12:00:00'),
(2, '2024-01-12', 1, '2024-01-12 13:00:00', 'Alice', '2024-01-12 13:00:00'),
(3, '2024-01-20', 1, '2024-01-20 12:35:00', 'Alice', '2024-01-20 12:30:00'),
(4, '2024-01-07', 2, '2024-01-07 13:50:00', 'Bob', '2024-01-07 14:00:00'),
(5, '2024-01-15', 2, '2024-01-15 15:05:00', 'Bob', '2024-01-15 15:00:00'),
(6, '2024-01-25', 2, '2024-01-25 14:00:00', 'Bob', '2024-01-25 14:30:00'),
(7, '2024-01-03', 3, '2024-01-03 15:55:00', 'Charlie', '2024-01-03 16:00:00'),
(8, '2024-01-10', 3, '2024-01-10 17:10:00', 'Charlie', '2024-01-10 17:00:00'),
(9, '2024-01-18', 3, '2024-01-18 16:40:00', 'Charlie', '2024-01-18 16:45:00'),
(10, '2024-01-04', 4, '2024-01-04 12:15:00', 'Dawn', '2024-01-04 12:00:00'),
(11, '2024-01-11', 4, '2024-01-11 12:20:00', 'Dawn', '2024-01-11 12:30:00'),
(12, '2024-01-19', 4, '2024-01-19 13:30:00', 'Dawn', '2024-01-19 13:00:00'),
(13, '2024-01-06', 5, '2024-01-06 10:50:00', 'Eve', '2024-01-06 11:00:00'),
(14, '2024-01-14', 5, '2024-01-14 11:28:00', 'Eve', '2024-01-14 11:30:00'),
(15, '2024-01-22', 5, '2024-01-22 11:10:00', 'Eve', '2024-01-22 11:00:00'),
(16, '2024-01-09', 6, '2024-01-09 17:50:00', 'Frank', '2024-01-09 18:00:00'),
(17, '2024-01-16', 6, '2024-01-16 18:20:00', 'Frank', '2024-01-16 18:30:00'),
(18, '2024-01-23', 6, '2024-01-23 18:55:00', 'Frank', '2024-01-23 19:00:00');




-- You are a Product Analyst on the Uber Eats team investigating delivery partner performance. The team wants to 
-- understand how accurately delivery partners are meeting expected delivery times. Your goal is to evaluate current 
-- tracking precision and identify potential improvements.





-- Question 1: What is the percentage of orders delivered on time in January 2024? Consider an order on time if its 
-- actual_delivery_time is less than or equal to its expected_delivery_time. This will help us assess overall tracking precision.

SELECT ROUND(100.0 * SUM(CASE WHEN actual_delivery_time <= expected_delivery_time THEN 1 END) / COUNT(*),2) AS on_time_pct
FROM fct_orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';


-- Question 2: List the top 5 delivery partners in January 2024 ranked by the highest percentage of on-time deliveries. 
-- Use the delivery_partner_name field from the records. This will help us identify which partners perform best.


SELECT delivery_partner_name,
ROUND(100.0 * SUM(CASE WHEN actual_delivery_time <= expected_delivery_time THEN 1 END) / COUNT(*),2) AS on_time_pct
FROM fct_orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY delivery_partner_name
ORDER BY on_time_pct DESC
LIMIT 5;


-- Question 3: Identify the delivery partner(s) in January 2024 whose on-time delivery percentage is below 50%. 
-- Return their partner names in uppercase. We need to work with these delivery partners to improve their on-time delivery rates.


SELECT UPPER(delivery_partner_name),
ROUND(100.0 * SUM(CASE WHEN actual_delivery_time <= expected_delivery_time THEN 1 END) / COUNT(*),2) AS on_time_pct
FROM fct_orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY delivery_partner_name
HAVING on_time_pct < 50;



--  Your analyses will help Uber Eats understand how accurately delivery partners are meeting expected delivery times, identify 
-- top performers, and pinpoint those who need support to improve their on-time delivery rates. This insight is crucial for 
-- improving customer satisfaction and operational efficiency.



