-- Drop and create the database
DROP DATABASE IF EXISTS subscription_pricing_tiers_db;
CREATE DATABASE subscription_pricing_tiers_db;
USE subscription_pricing_tiers_db;

-- Create the fct_subscriptions table
CREATE TABLE fct_subscriptions (
  subscription_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  pricing_tier VARCHAR(50),
  start_date DATE,
  end_date DATE,
  renewal_status VARCHAR(50)
);

-- Insert data into fct_subscriptions
INSERT INTO fct_subscriptions (subscription_id, customer_id, pricing_tier, start_date, end_date, renewal_status) VALUES
(1, 101, 'Basic', '2024-07-05', '2024-08-05', 'Not Renewed'),
(2, 102, 'Premium', '2024-07-10', '2024-08-10', 'Renewed'),
(3, 103, 'Enterprise', '2024-07-15', '2024-08-15', 'Renewed'),
(4, 101, 'Basic', '2024-08-06', '2024-09-06', 'Renewed'),
(5, 104, 'Basic', '2024-08-10', '2024-09-10', 'Not Renewed'),
(6, 105, 'Premium', '2024-08-12', '2024-09-12', 'Not Renewed'),
(7, 102, 'Premium', '2024-09-01', '2024-10-01', 'Renewed'),
(8, 106, 'Enterprise', '2024-09-05', '2024-10-05', 'Not Renewed'),
(9, 107, 'Premium', '2024-07-20', '2024-08-20', 'Not Renewed'),
(10, 108, 'Basic', '2024-07-22', '2024-08-22', 'Renewed'),
(11, 109, 'Enterprise', '2024-08-15', '2024-09-15', 'Renewed'),
(12, 110, 'Premium', '2024-09-10', '2024-10-10', 'Not Renewed'),
(13, 111, 'Basic', '2024-09-15', '2024-10-15', 'Not Renewed'),
(14, 103, 'Enterprise', '2024-09-20', '2024-10-20', 'Renewed'),
(15, 112, 'Premium', '2024-08-25', '2024-09-25', 'Renewed');



-- As a Product Analyst on the Billing & Subscriptions team at Stripe, you are tasked with evaluating how different 
-- pricing tiers affect customer retention and lifecycle. Your team is focused on understanding customer behavior 
-- across subscription levels to refine and optimize the pricing strategy. Your goal is to analyze subscription 
-- data to determine baseline subscription counts, assess retention effectiveness, and rank pricing tiers by retention rate.


-- Question 1: For Quarter 3 of 2024, what is the total number of distinct customers who started a subscription for 
-- each pricing tier? This query establishes baseline subscription counts for evaluating customer retention.


SELECT 
  pricing_tier, 
  COUNT(DISTINCT customer_id) AS n_customer
FROM fct_subscriptions
WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY 1
ORDER BY 2 DESC;


-- Question 2: Using subscriptions that started in Q3 2024, for each pricing tier, what percentage of customers 
-- renewed their subscription? Customers who have renewed their subscription would have a renewal status of 'Renewed'. 
-- This breakdown will help assess retention effectiveness across tiers.

SELECT 
  pricing_tier, 
  ROUND(100*SUM(CASE WHEN renewal_status = 'Renewed' THEN 1 END) / COUNT(DISTINCT customer_id),2) AS renewal_pct
FROM fct_subscriptions
WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY 1
ORDER BY 2 DESC;


-- WITH q3_subs AS (
--   SELECT customer_id, pricing_tier, 
--          MAX(renewal_status = 'Renewed') AS renewed_flag
--   FROM fct_subscriptions
--   WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30'
--   GROUP BY customer_id, pricing_tier
-- )
-- SELECT 
--   pricing_tier,
--   ROUND(100.0 * SUM(renewed_flag) / COUNT(DISTINCT customer_id), 2) AS renewal_pct
-- FROM q3_subs
-- GROUP BY pricing_tier
-- ORDER BY renewal_pct DESC;




-- Question 3: Based on subscriptions that started in Quarter 3 of 2024, rank the pricing tiers by their 
-- retention rate. We’d like to see both the retention rate and the rank for each tier, so we can identify 
-- which pricing model keeps customers engaged the longest.


-- SELECT 
--   pricing_tier, 
--   ROUND(100*SUM(CASE WHEN renewal_status = 'Renewed' THEN 1 END) / COUNT(DISTINCT customer_id),2) AS renewal_pct,
--   RANK() OVER (ORDER BY ROUND(100*SUM(CASE WHEN renewal_status = 'Renewed' THEN 1 END) / COUNT(DISTINCT customer_id),2) DESC)
-- FROM fct_subscriptions
-- WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30'
-- GROUP BY 1;


 WITH renewal AS (
   SELECT 
  pricing_tier, 
  100* COUNT(CASE WHEN renewal_status = 'Renewed' THEN 1 END) /
   COUNT(*) AS pct_renewal
FROM fct_subscriptions
WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY 1
 )
SELECT *, 
   RANK() OVER( ORDER BY pct_renewal DESC) AS retention_ranking
FROM renewal;


-- Your analyses will help Stripe understand how different pricing tiers perform in terms of customer retention. This insight is crucial 
-- for refining pricing strategies to maximize customer engagement and lifecycle value.
