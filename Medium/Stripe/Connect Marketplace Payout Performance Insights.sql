-- Drop and create the database
DROP DATABASE IF EXISTS connect_marketplace_payout_db;
CREATE DATABASE connect_marketplace_payout_db;
USE connect_marketplace_payout_db;

-- Create dim_sellers table
CREATE TABLE dim_sellers (
  seller_id INT PRIMARY KEY,
  seller_segment VARCHAR(20) NOT NULL
);

-- Insert data into dim_sellers
INSERT INTO dim_sellers (seller_id, seller_segment) VALUES
(1, 'bronze'),
(2, 'silver'),
(3, 'gold'),
(4, 'silver'),
(5, 'bronze'),
(6, 'gold'),
(7, 'silver'),
(8, 'bronze'),
(9, 'gold'),
(10, 'silver');

-- Create fct_payouts table
CREATE TABLE fct_payouts (
  payout_id INT PRIMARY KEY,
  seller_id INT NOT NULL,
  payout_date DATE NOT NULL,
  payout_status VARCHAR(20) NOT NULL,
  FOREIGN KEY (seller_id) REFERENCES dim_sellers(seller_id)
);

-- Insert data into fct_payouts
INSERT INTO fct_payouts (payout_id, seller_id, payout_date, payout_status) VALUES
(1, 1, '2024-07-05', 'successful'),
(2, 1, '2024-07-18', 'failed'),
(3, 5, '2024-07-10', 'successful'),
(4, 5, '2024-07-21', 'successful'),
(5, 5, '2024-07-29', 'successful'),
(6, 8, '2024-07-15', 'failed'),
(7, 2, '2024-07-06', 'successful'),
(8, 2, '2024-06-28', 'successful'),
(9, 2, '2024-07-25', 'failed'),
(10, 4, '2024-07-08', 'successful'),
(11, 4, '2024-07-22', 'successful'),
(12, 7, '2024-07-12', 'failed'),
(13, 10, '2024-07-14', 'successful'),
(14, 10, '2024-07-24', 'failed'),
(15, 3, '2024-07-09', 'successful'),
(16, 3, '2024-07-23', 'successful'),
(17, 6, '2024-07-11', 'successful'),
(18, 6, '2024-07-27', 'successful'),
(19, 9, '2024-07-13', 'successful'),
(20, 9, '2024-07-26', 'failed');





-- You are a Product Analyst collaborating with the Stripe Connect team to evaluate the performance of 
-- seller payouts within the marketplace ecosystem. Your team is focused on understanding payout success 
-- rates and identifying any segments that may require intervention to improve their payout performance. 
-- By analyzing the data, you aim to provide actionable insights that will help enhance payout success 
-- across different seller segments.



-- Question 1: What is the total number of payouts made by each seller segment in July 2024?


SELECT seller_segment, COUNT(payout_id) AS n_payout
FROM fct_payouts fp
JOIN dim_sellers ds ON fp.seller_id = ds.seller_id
WHERE payout_date BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY 1
ORDER BY 2 DESC;


-- Question 2: Identify the seller segment with the highest payout success rate in July 2024 by comparing successful and failed payouts.

SELECT 
  seller_segment, 
  SUM(CASE WHEN payout_status = 'successful' THEN 1 ELSE 0 END) / COUNT(payout_id) AS payout_success_rate
FROM fct_payouts fp
JOIN dim_sellers ds ON fp.seller_id = ds.seller_id
WHERE payout_date BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY seller_segment
ORDER BY payout_success_rate DESC
LIMIT 1;


-- Question 3: What percentage of payouts were successful versus failed for each seller segment in July 2024, and how can this be 
-- used to recommend targeted improvements?

SELECT 
  seller_segment, 
  ROUND(100.0 * SUM(CASE WHEN payout_status = 'successful' THEN 1 ELSE 0 END) / COUNT(payout_id), 2) AS payout_success_pct,
  ROUND(100.0 * SUM(CASE WHEN payout_status = 'failed' THEN 1 ELSE 0 END) / COUNT(payout_id), 2) AS payout_failure_pct
FROM fct_payouts fp
JOIN dim_sellers ds ON fp.seller_id = ds.seller_id
WHERE payout_date BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY seller_segment
ORDER BY payout_success_pct DESC;



-- Your analyses will help the Stripe Connect team understand payout success rates across different seller segments. This insight 
-- is crucial for identifying which segments may need targeted interventions to improve their payout performance, ultimately 
-- enhancing the overall marketplace experience.
