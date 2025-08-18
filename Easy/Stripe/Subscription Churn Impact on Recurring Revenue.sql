-- Create the database
CREATE DATABASE IF NOT EXISTS subscription_churn_impact_db;

-- Use the database
USE subscription_churn_impact_db;

-- Create the table
CREATE TABLE fct_subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    tier_name VARCHAR(50),
    start_date DATE,
    end_date DATE
);

-- Insert data
INSERT INTO fct_subscriptions (subscription_id, customer_id, tier_name, start_date, end_date) VALUES
(1, 101, 'Basic',      '2024-01-15', '2024-07-10'),
(2, 102, 'Premium',    '2024-03-01', '2024-08-05'),
(3, 103, 'Enterprise', '2024-02-20', '2024-07-20'),
(4, 104, 'Plus',       '2024-04-10', '2024-09-15'),
(5, 105, 'Standard',   '2024-05-15', NULL),
(6, 106, 'Basic',      '2024-06-01', '2024-08-10'),
(7, 107, 'Premium',    '2024-07-01', NULL),
(8, 108, 'Enterprise', '2024-09-01', '2024-09-10'),
(9, 109, 'Basic',      '2024-06-15', '2024-07-25'),
(10, 110, 'Premium',   '2024-03-15', '2024-08-20'),
(11, 111, 'Premium',   '2024-04-12', '2024-07-15'),
(12, 112, 'Ultimate',  '2024-05-10', '2024-07-22'),
(13, 113, 'Basic',     '2024-06-20', '2024-08-15');






-- As a Product Analyst on the Billing team, you are tasked with investigating customer retention patterns 
-- across different subscription tiers. Your team is particularly interested in understanding which tiers 
-- are experiencing the highest customer dropout rates. Your goal is to develop insights that can inform 
-- strategies to reduce subscription cancellations and stabilize recurring revenue.



-- Question 1: Identify the first 3 subscription tiers in alphabetical order. Don't forget to remove duplicate values. 
-- This query will help us understand what values are in the tier_name column.


SELECT DISTINCT tier_name
FROM fct_subscriptions
ORDER BY tier_name
LIMIT 3;



-- Question 2: Determine how many customers canceled their subscriptions in August 2024 for tiers labeled 'Basic' 
-- or 'Premium'. This query is used to evaluate cancellation trends for these specific subscription levels.


SELECT COUNT(DISTINCT customer_id) AS n_users
FROM fct_subscriptions
WHERE end_date BETWEEN '2024-08-01' AND '2024-08-31'
AND (tier_name = 'Basic'  OR tier_name = 'Premium');



-- Question 3: Find the subscription tier with the highest number of cancellations during Quarter 3 2024 
-- (July 2024 through September 2024). This query will guide retention strategies by identifying the tier 
-- with the most significant dropout case.


-- Question 3: Find the subscription tier with the highest number of cancellations during Quarter 3 2024 
-- (July 2024 through September 2024). This query will guide retention strategies by identifying the tier 
-- with the most significant dropout case.

SELECT tier_name, COUNT(subscription_id) AS n_sub_cancellation
FROM fct_subscriptions
WHERE end_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY tier_name
ORDER BY n_sub_cancellation DESC
LIMIT 1;



-- Your analyses will help Stripe's Billing team identify which subscription tiers have the highest dropout rates, 
-- enabling them to focus retention efforts where they matter most and stabilize recurring revenue.
