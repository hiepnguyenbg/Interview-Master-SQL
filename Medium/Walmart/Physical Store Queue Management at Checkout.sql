-- Drop and create the database
DROP DATABASE IF EXISTS physical_store_queue_management_db;
CREATE DATABASE IF NOT EXISTS physical_store_queue_management_db;
USE physical_store_queue_management_db;

-- Create the dim_stores table
CREATE TABLE dim_stores (
  store_id INT PRIMARY KEY,
  store_name VARCHAR(255) NOT NULL,
  location VARCHAR(255) NOT NULL
);

-- Insert data into dim_stores
INSERT INTO dim_stores (store_id, store_name, location) VALUES
(1, 'Walmart Supercenter - Downtown', 'New York, NY'),
(2, 'Walmart Neighborhood Market', 'Los Angeles, CA'),
(3, 'Walmart Supercenter - Suburb', 'Chicago, IL'),
(4, 'Walmart Discount', 'Houston, TX'),
(5, 'Walmart Express', 'Phoenix, AZ'),
(6, 'Walmart Supercenter - West', 'San Francisco, CA'),
(7, 'Walmart Extra', 'Dallas, TX'),
(8, 'Walmart Market', 'Miami, FL'),
(9, 'Walmart Supercenter - East', 'Boston, MA'),
(10, 'Walmart Outlet', 'Detroit, MI');

-- Create the fct_checkout_times table
CREATE TABLE fct_checkout_times (
  store_id INT,
  transaction_id INT PRIMARY KEY,
  checkout_start_time DATETIME NOT NULL,
  checkout_end_time DATETIME NOT NULL,
  FOREIGN KEY (store_id) REFERENCES dim_stores(store_id)
);

-- Insert data into fct_checkout_times
INSERT INTO fct_checkout_times (store_id, transaction_id, checkout_end_time, checkout_start_time) VALUES
(1, 1, '2024-07-05 10:05:00', '2024-07-05 10:00:00'),
(1, 2, '2024-07-12 15:40:00', '2024-07-12 15:30:00'),
(2, 3, '2024-07-06 11:20:00', '2024-07-06 11:15:00'),
(2, 4, '2024-07-20 12:08:00', '2024-07-20 12:00:00'),
(3, 5, '2024-07-07 13:15:00', '2024-07-07 13:00:00'),
(3, 6, '2024-07-21 14:45:00', '2024-07-21 14:30:00'),
(4, 7, '2024-07-08 16:12:00', '2024-07-08 16:00:00'),
(4, 8, '2024-07-22 09:43:00', '2024-07-22 09:30:00'),
(5, 9, '2024-07-09 08:06:00', '2024-07-09 08:00:00'),
(5, 10, '2024-07-23 17:50:00', '2024-07-23 17:45:00'),
(6, 11, '2024-07-10 19:20:00', '2024-07-10 19:00:00'),
(6, 12, '2024-07-24 20:15:00', '2024-07-24 20:00:00'),
(7, 13, '2024-07-11 10:36:00', '2024-07-11 10:30:00'),
(7, 14, '2024-07-25 11:05:00', '2024-07-25 11:00:00'),
(8, 15, '2024-07-12 12:14:00', '2024-07-12 12:00:00'),
(8, 16, '2024-07-26 13:45:00', '2024-07-26 13:30:00'),
(9, 17, '2024-07-13 14:10:00', '2024-07-13 14:00:00'),
(9, 18, '2024-07-27 15:12:00', '2024-07-27 15:00:00'),
(10, 19, '2024-07-14 17:05:00', '2024-07-14 17:00:00'),
(10, 20, '2024-07-28 13:05:00', '2024-07-28 13:00:00');






-- As a Business Analyst for the Store Operations team at Walmart, you are tasked with examining checkout 
-- wait times to enhance the customer shopping experience. Your team aims to identify which stores have 
-- longer wait times and determine specific hours when these delays are most pronounced. The insights you 
-- provide will guide staffing strategies to reduce customer wait times and improve overall efficiency.


-- Question 1: What is the average checkout wait time in minutes for each Walmart store during July 2024? 
-- Include the store name from the dim_stores table to identify location-specific impacts. This metric will 
-- help determine which stores have longer customer wait times.



-- SELECT 
--   ds.store_name,
--   AVG(TIMESTAMPDIFF(MINUTE, fct.checkout_start_time, fct.checkout_end_time)) AS avg_checkout_minutes
-- FROM fct_checkout_times fct
-- JOIN dim_stores ds ON fct.store_id = ds.store_id
-- WHERE DATE(fct.checkout_end_time) BETWEEN '2024-07-01' AND '2024-07-31'
-- GROUP BY ds.store_name
-- ORDER BY avg_checkout_minutes DESC;


SELECT store_name, 
  AVG(EXTRACT(EPOCH FROM (checkout_end_time - checkout_start_time)) / 60) avg_checkout
FROM fct_checkout_times fct
JOIN dim_stores ds
ON fct.store_id = ds.store_id
WHERE DATE_TRUNC('day', checkout_start_time) BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY 1
ORDER BY 2 DESC;



-- Question 2: For the stores with an average checkout wait time exceeding 10 minutes in July 2024, what are 
-- the average checkout wait times in minutes broken down by each hour of the day? Use the store information 
-- from dim_stores to ensure proper identification of each store. This detail will help pinpoint specific hours 
-- when wait times are particularly long.



-- WITH store_avg_wait AS (
--   SELECT 
--     store_id,
--     AVG(TIMESTAMPDIFF(MINUTE, checkout_start_time, checkout_end_time)) AS avg_checkout_minutes
--   FROM fct_checkout_times
--   WHERE DATE(checkout_end_time) BETWEEN '2024-07-01' AND '2024-07-31'
--   GROUP BY store_id
--   HAVING avg_checkout_minutes > 10
-- )

-- SELECT 
--   ds.store_name,
--   HOUR(fct.checkout_start_time) AS hour_of_day,
--   AVG(TIMESTAMPDIFF(MINUTE, fct.checkout_start_time, fct.checkout_end_time)) AS avg_checkout_minutes
-- FROM fct_checkout_times fct
-- JOIN store_avg_wait sw ON fct.store_id = sw.store_id
-- JOIN dim_stores ds ON fct.store_id = ds.store_id
-- WHERE DATE(fct.checkout_end_time) BETWEEN '2024-07-01' AND '2024-07-31'
-- GROUP BY ds.store_name, hour_of_day
-- ORDER BY avg_checkout_minutes DESC;



WITH avg_checkout_time AS (
    SELECT store_id
    FROM fct_checkout_times
    WHERE DATE_TRUNC('day', checkout_start_time) BETWEEN '2024-07-01' AND '2024-07-31'
    GROUP BY store_id
    HAVING AVG(EXTRACT(EPOCH FROM (checkout_end_time - checkout_start_time)) / 60) > 10
)
SELECT store_name, 
    EXTRACT(HOUR FROM checkout_end_time) AS checkout_hour,
    AVG(EXTRACT(EPOCH FROM (checkout_end_time - checkout_start_time)) / 60) AS avg_checkout
FROM fct_checkout_times fct
JOIN dim_stores ds ON fct.store_id = ds.store_id
WHERE fct.store_id IN (SELECT store_id FROM avg_checkout_time)
AND DATE_TRUNC('day', checkout_start_time) BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY store_name, EXTRACT(HOUR FROM checkout_end_time);





-- Question 3: Across all stores in July 2024, which hours exhibit the longest average checkout wait times 
-- in minutes? This analysis will guide recommendations for optimal staffing strategies.

SELECT 
  HOUR(fct.checkout_start_time) AS hour_of_day,
  AVG(TIMESTAMPDIFF(MINUTE, fct.checkout_start_time, fct.checkout_end_time)) AS avg_checkout_minutes
FROM fct_checkout_times fct
WHERE DATE(fct.checkout_end_time) BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY hour_of_day
ORDER BY avg_checkout_minutes DESC
LIMIT 1;


