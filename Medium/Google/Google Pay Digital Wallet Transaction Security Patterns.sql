-- Step 0: Create the database
DROP DATABASE IF EXISTS google_pay_digital_wallet_db;
CREATE DATABASE google_pay_digital_wallet_db;

-- Step 1: Use the database
USE google_pay_digital_wallet_db;

-- Step 2: Create the fct_transactions table
CREATE TABLE fct_transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    merchant_category VARCHAR(50),
    transaction_status VARCHAR(20)
);

-- Step 3: Insert the data
INSERT INTO fct_transactions (transaction_id, transaction_date, merchant_category, transaction_status) VALUES
(1, '2024-01-05', 'Retail', 'SUCCESS'),
(2, '2024-01-10', 'Retail', 'FAILED'),
(3, '2024-01-20', 'Retail', 'SUCCESS'),
(4, '2024-01-15', 'Dining', 'SUCCESS'),
(5, '2024-01-18', 'Dining', 'FAILED'),
(6, '2024-01-25', 'Entertainment', 'SUCCESS'),
(7, '2024-01-30', 'Entertainment', 'SUCCESS'),
(8, '2024-01-12', 'Groceries', 'FAILED'),
(9, '2024-01-27', 'Groceries', 'FAILED'),
(10, '2024-01-09', 'Utilities', 'SUCCESS'),
(11, '2024-02-03', 'Retail', 'SUCCESS'),
(12, '2024-02-08', 'Dining', 'SUCCESS'),
(13, '2024-02-14', 'Entertainment', 'FAILED'),
(14, '2024-02-10', 'Groceries', 'SUCCESS'),
(15, '2024-02-05', 'Utilities', 'FAILED'),
(16, '2024-03-12', 'Retail', 'FAILED'),
(17, '2024-03-20', 'Dining', 'FAILED'),
(18, '2024-03-03', 'Entertainment', 'SUCCESS'),
(19, '2024-03-29', 'Groceries', 'SUCCESS'),
(20, '2024-03-15', 'Utilities', 'SUCCESS'),
(21, '2024-01-11', 'Travel', 'SUCCESS'),
(22, '2024-01-19', 'Travel', 'SUCCESS'),
(23, '2024-02-04', 'Travel', 'SUCCESS'),
(24, '2024-02-11', 'Travel', 'SUCCESS'),
(25, '2024-03-22', 'Travel', 'SUCCESS');





-- You are a Product Analyst on the Google Pay security team focused on improving the reliability of digital 
-- payments. Your team needs to analyze transaction success and failure rates across various merchant categories 
-- to identify potential friction points in payment experiences. By understanding these patterns, you aim to 
-- guide product improvements for a smoother and more reliable payment process.



-- Question 1: For January 2024, what are the total counts of successful and failed transactions in each merchant 
-- category? This analysis will help the Google Pay security team identify potential friction points in payment processing.


SELECT merchant_category,
  SUM(CASE WHEN transaction_status = 'SUCCESS' THEN 1 ELSE 0 END) AS n_success,
  SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END) AS n_failure
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY merchant_category;


-- Question 2: For the first quarter of 2024, which merchant categories recorded a transaction success rate below 90%? 
-- This insight will guide our prioritization of security enhancements to improve payment reliability.

WITH success_category AS (
  SELECT merchant_category,
    SUM(CASE WHEN transaction_status = 'SUCCESS' THEN 1 ELSE 0 END) AS n_success,
    SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END) AS n_failure
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31'
  GROUP BY merchant_category
)
SELECT
  merchant_category,
  ROUND(n_success / (n_success + n_failure), 2) AS success_rate
FROM success_category
WHERE (n_success / (n_success + n_failure)) < 0.9;



-- Question 3: From January 1st to March 31st, 2024, can you generate a list of merchant categories 
-- with their concatenated counts for successful and failed transactions? Then, rank the categories by 
-- total transaction volume. This ranking will support our assessment of areas where mixed transaction 
-- outcomes may affect user experience.


SELECT 
  merchant_category,
  COUNT(transaction_id) AS total_transaction,
  CONCAT(
    'SUCCESS: ', SUM(CASE WHEN transaction_status = 'SUCCESS' THEN 1 ELSE 0 END),
    ', FAILED: ', SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END)
  ) AS success_failure_counts,
  RANK() OVER (ORDER BY COUNT(transaction_id) DESC) AS transaction_rank
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY merchant_category;








