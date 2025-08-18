-- Create the database
CREATE DATABASE IF NOT EXISTS cloud_service_customer_retention_db;

-- Use the database
USE cloud_service_customer_retention_db;

-- Create the table
CREATE TABLE fct_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    service_tier_code VARCHAR(50),
    transaction_date DATE
);

-- Insert data
INSERT INTO fct_transactions (customer_id, transaction_id, transaction_date, service_tier_code) VALUES
(101, 1, '2024-04-05', 'PREM_BASIC'),
(102, 2, '2024-04-10', 'PREM_PLUS'),
(103, 3, '2024-04-15', 'BASIC'),
(101, 4, '2024-04-20', 'PREM_BASIC'),
(104, 5, '2024-04-25', 'PREM_ULTIMATE'),
(105, 6, '2024-05-02', 'STANDARD'),
(106, 7, '2024-05-05', 'BASIC'),
(107, 8, '2024-05-08', 'PREM_PLUS'),
(105, 9, '2024-05-12', 'STANDARD'),
(108, 10, '2024-05-15', 'PREM_BASIC'),
(109, 11, '2024-05-20', 'STANDARD'),
(105, 12, '2024-06-03', 'PREM_BASIC'),
(111, 13, '2024-06-05', 'PREM_BASIC'),
(112, 14, '2024-06-07', 'STANDARD'),
(113, 15, '2024-06-10', 'PREM_PLUS'),
(111, 16, '2024-06-13', 'STANDARD'),
(114, 17, '2024-06-16', 'PREM_PLUS'),
(115, 18, '2024-06-20', 'PREM_ULTIMATE'),
(116, 19, '2024-06-23', 'STANDARD'),
(117, 20, '2024-06-28', 'PREM_BASIC');





-- As a Product Analyst on the Google Cloud team, you are working with your team to enhance customer retention 
-- and optimize cost structures for enterprise cloud services. The team is particularly focused on understanding 
-- how early adoption of premium service tiers affects customer behavior and spending patterns. Your goal is to 
-- analyze transaction data to guide strategic decisions on service tier offerings and pricing models to improve 
-- customer engagement and revenue.




-- Question 1: We want to evaluate early premium service adoption among enterprise customers. How many unique 
-- customers with service tier codes starting with ''PREM'' completed transactions from April 1st to April 30th, 2024?


SELECT COUNT(DISTINCT customer_id) AS n_unique_customers
FROM fct_transactions
WHERE service_tier_code LIKE 'PREM%'
AND transaction_date BETWEEN '2024-04-01' AND '2024-04-30';



-- Question 2: We need to understand usage trends for different service tiers in order to refine our service packages. 
-- Which service tier codes were used most frequently by customers for transactions in May 2024, ranked from most to least frequent?


SELECT service_tier_code, COUNT(transaction_id) AS total_transactions
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY service_tier_code
ORDER BY total_transactions DESC;





-- Question 3: We want to pinpoint the most active service tiers to inform pricing adjustments for enterprise cloud 
-- offerings. For transactions between June 1st and June 30th, 2024, what are the top three service tier codes based 
-- on transaction volume and how many transactions were recorded for each?



SELECT service_tier_code, COUNT(transaction_id) AS total_transactions
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-06-01' AND '2024-06-30'
GROUP BY service_tier_code
ORDER BY total_transactions DESC
LIMIT 3;



-- Your analyses will help the Google Cloud team understand customer behavior around premium service tiers and 
-- transaction volumes over specific months. This insight is crucial for making informed decisions on service 
-- tier offerings and pricing models to boost customer engagement and revenue.










