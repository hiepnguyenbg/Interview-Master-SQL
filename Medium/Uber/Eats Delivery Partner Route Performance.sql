DROP DATABASE eats_delivery_parter_db;
CREATE DATABASE eats_delivery_parter_db;
USE eats_delivery_parter_db;

-- Create the table (earnings allows NULLs)
CREATE TABLE fct_delivery_routes (
    route_id INT PRIMARY KEY,
    delivery_partner_id INT,
    pickup_count INT,
    delivery_time FLOAT,
    earnings FLOAT NULL,
    route_date DATE
);

-- Insert all rows, using NULL for missing earnings
INSERT INTO fct_delivery_routes (
    earnings, route_id, route_date, pickup_count, delivery_time, delivery_partner_id
) VALUES
(8.25, 101, '2024-10-05', 1, 15.5, 1001),
(10.00, 102, '2024-10-10', 2, 20.0, 1002),
(12.50, 103, '2024-10-15', 3, 25.0, 1003),
(9.00,  104, '2024-10-20', 2, 18.0, 1001),
(8.00,  105, '2024-10-25', 1, 16.0, 1002),
(15.00, 106, '2024-11-05', 4, 30.0, 1003),
(14.00, 107, '2024-11-10', 3, 28.0, 1001),
(NULL, 108, '2024-11-15', 2, 22.0, 1002), -- Missing earnings
(8.50,  109, '2024-11-20', 1, 17.0, 1003),
(13.00, 110, '2024-12-05', 3, 27.5, 1001),
(10.50, 111, '2024-12-10', 2, 20.5, 1002),
(7.50,  112, '2024-12-15', 1, 16.5, 1003),
(NULL, 113, '2024-12-20', 4, 32.0, 1001), -- Missing earnings
(11.00, 114, '2024-12-25', 2, 21.0, 1002),
(12.00,	115, '2024-12-30', 3, 26.0, 1003);





-- You are a Product Analyst investigating how delivery partners manage multiple order pickups. 
-- The team wants to understand the efficiency of order clustering and routing strategies. The goal 
-- is to optimize delivery route performance to support partner earnings and operational effectiveness.




-- Question 1: For all delivery routes between October 1st and December 31st, 2024, what percentage of 
-- routes had multiple (ie. 2 or more) order pickups? This metric will quantify how often order bundling 
-- occurs to help evaluate routing efficiency.


SELECT 
  ROUND(100.0 * COUNT(CASE WHEN pickup_count >= 2 THEN 1 END) / COUNT(*), 2) AS multiple_pct
FROM fct_delivery_routes
WHERE route_date BETWEEN '2024-10-01' AND '2024-12-31';


-- Question 2: For delivery routes with multiple pickups between October 1st and December 31st, 2024, how does 
-- the average delivery time differ between routes with exactly 2 orders and routes with 3 or more orders? 
-- Use a CASE statement to segment the routes accordingly. This analysis will clarify the impact of different 
-- levels of order clustering on delivery performance.

-- WITH segmented_routes AS (
--   SELECT 
--     delivery_time,
--     CASE 
--       WHEN pickup_count = 2 THEN 'Two'
--       WHEN pickup_count >= 3 THEN 'At least 3'
--     END AS pickup_group
--   FROM fct_delivery_routes
--   WHERE route_date BETWEEN '2024-10-01' AND '2024-12-31'
-- )

-- SELECT 
--   pickup_group, 
--   AVG(delivery_time) AS avg_delivery_time
-- FROM segmented_routes
-- WHERE pickup_group IS NOT NULL
-- GROUP BY pickup_group;


SELECT AVG(CASE WHEN pickup_count = 2 THEN delivery_time END) AS avg_time_2_orders,
  AVG(CASE WHEN pickup_count >= 3 THEN delivery_time END) AS avg_time_3_or_more_orders
FROM fct_delivery_routes
WHERE route_date BETWEEN '2024-10-01' AND '2024-12-31';


-- Question 3: What is the average earnings per pickup across all routes?

-- Note: Some rows have missing values in the earnings column. Before calculating the final value, 
-- replace any missing earnings with the average earnings value.


SELECT 
  SUM(COALESCE(earnings, (SELECT AVG(earnings) FROM fct_delivery_routes))) / SUM(pickup_count) AS avg_earning
FROM fct_delivery_routes;



-- Your analyses will help Uber understand how often delivery partners bundle orders, how different levels of order 
-- clustering impact delivery times, and the average earnings per pickup considering missing data. These insights are 
-- valuable for optimizing delivery routes to support partner earnings and operational efficiency.

